# NexImage Burst C UVC investigation — 2026-10-19

**LATEST RESULT:** The subsequently approved executable-code patch is applied
and validated after a physical reconnect. Stock v4l2-ctl now captures valid
720×480, 1280×960, and 640×480 frames without an initialization helper; reopen
also passed. Native mode is 7.5 fps, smaller tested modes about 14.9 fps. See
firmware-re/README.md and firmware-re/validation-cold1/results.json. The older
sections below preserve the investigation history and earlier limitations.

**CURRENT STATUS AFTER THE APPROVED WRITE:** The format-index patch is applied
and survives reconnect. Stock Linux uvcvideo plus v4l2-ctl successfully saved ten
error-free frames each at 720×480 and 1280×960 after volatile sensor initialization.
This resolves the incorrect expected size; it is not fully automatic UVC operation.
The original investigation below records the earlier unpatched state.
See the post-reconnect results appended at the end.

Camera 28414934, 199e:8308, firmware 146, USB High Speed, Ubuntu kernel
7.0.0-38-generic. No EEPROM writes, operating-mode changes, resets, or flashes
were performed during this investigation. Driver detach/reattach, UVC
probe/commit, and sensor ROI/clock changes were volatile.

## Result

Complete raw image frames were obtained without changing the kernel or EEPROM:

* 720×480: 28 consecutive complete USB payloads, each 345,600 image bytes
  plus a 2-byte UVC header, with alternating FID and EOF set.
* 1280×960: 21 complete payloads, each 1,228,800 image bytes plus header.
* Standard V4L2 also delivered 345,600-byte buffers after sensor initialization
  while uvcvideo stayed attached. Those buffers still have ERROR because its
  negotiated expected frame size is 5,038,848 bytes.

This is byte-complete Bayer image acquisition, not yet a demonstration of a
focused optical scene or successful error-free standard UVC operation. The saved
720×480 image contains varying sensor data and the Bayer mosaic; a dark scene
alone cannot establish optical quality. See valid-roi720.png / .pgm and
valid-roi1280.pgm. No display or lens adjustments were made.

Two independent problems remain in the firmware's UVC path: duplicate format
indices prevent correct host-side frame-size selection, and UVC commit does not
establish the requested sensor ROI correctly. Its pixel-clock choice is also
inconsistent with the supported clock range in some settings.

## Backups and integrity

All three supplied backup/candidate files retain their original contents:

| File | SHA-256 |
|---|---|
| neximage-eeprom-original.bin | 743c32526036dd6600ee0e40596eea8df8264af6f0b3bdf4adfaec33bf4f6dc9 |
| neximage-eeprom-after-attempt.bin | cdf65664e3cad5640b9923dfa370e1ab9fc100b4ed6ed908587daddd2bb2584a |
| neximage-eeprom-uvc335-candidate.bin | cdf65664e3cad5640b9923dfa370e1ab9fc100b4ed6ed908587daddd2bb2584a |

A full 32,768-byte live read also exactly matched the corrected backup, with only
0x1F34 differing from the original (33→4F). The upper EEPROM half is all FF.
Do not run dump_neximage.py as supplied: it unconditionally overwrites the
original backup filename. It was inspected but not run.

## Protocol review

src/Usb2Camera.cpp is the primary evidence:

* read_eeprom selects a big-endian 16-bit address using vendor OUT 40/03,
  wValue=0, wIndex=A1, two address bytes; then sequential IN C0/02,
  wValue=0, wIndex=A0 reads. Selecting the read address does not program EEPROM.
* upload_firmware_file programs up to 32 data bytes using OUT 40/02/A1,
  with a two-byte address prefix, then IN C0/02/A0 and a delay. It is not a
  read-address operation. No such programming requests were sent here.
* set_mode changes PID bytes at 005A/005B and the mode flag at 3DFF. Its
  16-KiB-derived constants do not change when get_eeprom_size reports 32 KiB.
* get_firmware_version uses class/device-recipient IN A0/81, selector 2D00,
  wIndex=0100. This established a way to access terminal controls without
  claiming an interface owned by uvcvideo.

The EEPROM stores individual descriptor templates interspersed with code.
The live configuration is assembled at runtime and is not a contiguous 335-byte
EEPROM block starting at 1F32. For example, the 1280 frame template is at 1E99,
720 at 1E45, 640 at 1EC3, GREY format at 1EED, GRBG format at 1F09, and the
configuration header at 1F32. No assumption about relocating those blocks is safe.

## Live descriptor audit

The sysfs device+configuration descriptor dump is live-descriptors.bin (353
bytes). An independent standard GET_DESCRIPTOR requesting 1024 bytes returned
335 configuration bytes; direct-config.bin records them. The corrected
configuration header and bulk endpoint 82 / 512-byte packets are present.

| Item | Observed | Required / interpretation |
|---|---|---|
| UVC version | 1.00 | Uses 26-byte probe/commit controls |
| VS header bLength | 15 | 13 + 3×2 = 19 for its own advertised fields |
| VS bNumFormats | 3 | Two actual format descriptors |
| VS wTotalLength | 169 | Actual VS class-specific descriptors total 203 |
| Format IDs | GRBG=1, Y800=1 | Must distinguish formats |
| Frame descriptors | All follow Y800 | GRBG has zero parsed frames |
| bNumFrameDescriptors | Four in both formats | Zero follow GRBG; three follow Y800 |
| Actual frames | IDs 1,2,4 | 1280×960, 720×480, 640×480 |
| Frame-based fixed size | bVariableSize=0, 8 bpp | Expected width×height bytes |
| 1280 bitrate bounds | FFFFC000 / FFFF8000 | Implausible and min exceeds max |
| 720 bitrate bounds | 6656 / 26624 | Inconsistent with an 8-bit image stream |

These are FRAME_BASED descriptors (10/11), not UNCOMPRESSED frame descriptors
(04/05). They contain dwBytesPerLine, not an on-wire
`dwMaxVideoFrameBufferSize` field. Patching the usual uncompressed descriptor's
byte offsets would corrupt a different field here. The 720 and 640 descriptor
strides and dimensions themselves are sensible. Frame-based payload descriptors
belong to the UVC 1.1 specification family, despite this device claiming UVC 1.0;
Linux accepts them. Changing bcdUVC alone would change control lengths and is
not a safe fix.

The 12-byte processing-unit descriptor is consistent with its UVC 1.0 layout;
lsusb's “too short”/bmVideoStandards output should not be treated as evidence
that the next descriptor needs patching.

Reproduce the complete offline audit with:

    python3 diagnostics/audit_descriptors.py

## Why Linux reports GRBG, huge sizeimage, and ERROR

Reference source is upstream Linux v7.0, saved locally as uvc_*.c. It has not
been established byte-for-byte identical to Ubuntu's patched module.

1. Format parsing assigns the three frames to the second (Y800/GREY) descriptor.
2. S_FMT selects GREY and negotiates format index 1. The returned index is then
   resolved to the *first* matching format, GRBG, leaving the previously selected
   frame object. Thus GREY can return GRBG.
3. uvc_fixup_video_ctrl also picks the first index-1 format. With zero frames,
   it returns before replacing the device's bogus maximum frame-size value.
4. uvc_video_validate_buffer marks fixed-size, uncompressed buffers erroneous
   whenever bytesused differs from negotiated dwMaxVideoFrameSize. This is
   sufficient to flag both 107,712-byte and complete 345,600-byte buffers here.
   Additional transient errors on initial buffers are not excluded.

Sources:
[uvc_driver.c](https://github.com/torvalds/linux/blob/v7.0/drivers/media/usb/uvc/uvc_driver.c),
[uvc_v4l2.c](https://github.com/torvalds/linux/blob/v7.0/drivers/media/usb/uvc/uvc_v4l2.c),
[uvc_video.c](https://github.com/torvalds/linux/blob/v7.0/drivers/media/usb/uvc/uvc_video.c).

Dynamic debug/ftrace and usbmon require root, and sudo needed authentication.
They were unnecessary to establish these failures because direct bulk capture
reproduced the problem and exposed the actual wire headers. No kernel tracing
settings were changed.

## USB evidence for the short frames

Current probe at frame index 2 returned:

    00 00 01 02 2b 2c 0a 00 00 00 00 00 00 00 00 00 00 00
    00 e3 4c 00 00 e3 4c 00

Decoded: format 1, frame 2, interval 666667 (100 ns units), maximum frame size
and maximum payload size both 0x004CE300 = 5,038,848 = 2592×1944. The latter is
the related 72-series sensor's frame size, not this camera's 1280×960 sensor.

With 16-KiB synchronous bulk reads, stable frames were six 16,384-byte reads
and a 9,410-byte short read: total 107,714 bytes. At the payload start, headers
alternate `02 02` / `02 03`: length=2, EOF=1, FID toggles, ERR=0. EOH is not set;
Linux accepts this. Boundaries repeat about every 67.12 ms. There are no apparent
UVC headers embedded within the saved 107,712-byte decoded image data.

Repeating with 64-KiB reads produced one 65,536-byte read and a 42,178-byte short
read per frame: the identical 107,714-byte payload. Thus host read size and
Linux's bulk-decoder segmentation are not the cause. No missing EOF was seen
on these stable payloads. Initial data after committing can be stale/partial;
partial timeout reads must not be interpreted as reliable payload boundaries.

Artifacts: bulk-current.{bin,json}, bulk-frame2large.{bin,json},
uvc-controls-current.json, uvc-controls-frame2large.json.

## Finding the missing sensor initialization

The existing Open Astro Project EUVC driver explicitly handles this camera
family and documents setting sensor ROI and pixel clock *in addition to* UVC
commit. Its comments specifically mention the Burst C. Source files are saved
as oa-EUVC* for inspection:

[EUVCcontroller.c](https://github.com/openastroproject/openastro/blob/master/liboacam/euvc/EUVCcontroller.c),
[EUVC.h](https://github.com/openastroproject/openastro/blob/master/liboacam/euvc/EUVC.h).

Known terminal selectors on entity 1:

| Selector | Meaning | Width |
|---|---|---|
| 24 | Pixel clock, Hz | 4 bytes LE |
| 25 / 26 | ROI width / height | 4 bytes LE |
| 28 / 29 | ROI x / y | 4 bytes LE |
| 2A | Binning | 1 byte |

Reads gave ROI 1280×960 and binning 1 even with UVC frame 2 selected. Clock
GET_MIN/MAX reported 12–41 MHz. Some commits returned a current pixel clock
of 298,821,918 Hz, outside that range. The exact implementation bug in this
clock calculation has not been reverse engineered.

After committing frame 2, setting ROI x=y=0, width=720, height=480 and clock
12,000,000 yielded 28 complete 345,600-byte images. Measured interval ~70.12 ms,
not exactly the advertised 66.667 ms. ROI-only after a fresh frame-2 commit also
produced complete images but ~116.43 ms apart; clock readback was 7,227,990 Hz,
below the advertised 12-MHz minimum. Thus ROI correction alone fixes frame
length in that state; explicit clock setting gives a usable, bounded rate.

Frame 1 requested interval 666667 but probe returned 1333333 (7.5 fps), outside
its advertised interval list. Explicit ROI 1280×960 and clock 24 MHz nevertheless
produced 21 complete 1,228,800-byte images at ~68.06 ms intervals. Therefore the
reported UVC timing does not reliably describe actual sensor timing.

The source also mentions selectors 38/39 with uncertain semantics. They were
only read, not set. No speculative sensor-register writes were attempted.

A UVC-attached initialization test used class/device controls OUT 20/01 and
IN A0/81 with wIndex=0100. No detach was required. While standard V4L2 was
streaming, readback confirmed the settings, then buffers converged through a
transitional 408,576-byte buffer to 345,600 bytes. The repeated wrapper
run also reached 345,600 bytes by sequence 7. See v4l2-initialized.txt.

Utilities:

    cc -Wall -Wextra -O2 diagnostics/capture_errors.c -o diagnostics/capture_errors
    ./diagnostics/capture_errors

In a second terminal, after STREAMON (a commit can overwrite the clock):

    python3 diagnostics/initialize_sensor.py --width 720 --height 480 --clock 12000000

USB permission is needed. The already-granted temporary ACL on
/dev/bus/usb/001/056 is sufficient until re-enumeration; it does not persist
across reconnects. capture_errors saves error-flagged buffers; v4l2-ctl's stream
writer discards them. With the present EEPROM those buffers remain ERROR.

For direct, temporary driver-detach capture:

    python3 diagnostics/read_uvc.py --capture --frame 2 --interval 666667 --roi 720 480 --clock 12000000 --seconds 2 --prefix another720
    python3 diagnostics/analyze_bulk.py another720 --width 720 --height 480

The direct tool restores kernel ownership in a finally block. Reattaching
interface 0 can automatically claim interface 1; EBUSY for a subsequent attach
of an already-active interface is harmless. Both interfaces and video nodes
were checked after direct testing. Standard UVC reprobes can overwrite sensor
clock settings after reattachment. The direct tool's --capture starts streaming;
without it the tool only reads controls (except optional --frame negotiation).

## Tests that did not establish working standard UVC

* 640×480 / frame 4: no completed V4L2 buffer within 2.5 s. Direct capture
  yielded data but no complete payload boundary in the sampled 1.2 s.
* 1280×960 / advertised 10 fps: negotiated 7.5 fps and no completed V4L2
  buffer within 2.5 s without explicit sensor setup.
* 720×480 / requested 30 or 60 fps: negotiated 15 fps; original short frames.
* Five early v4l2-ctl experiments had five-second command timeouts and buffered
  stdout. Those logs are inconclusive; the later bounded C captures and direct
  USB records supersede them.

A separate reopen/STREAMON test reverted to short/error buffers and then no
completed buffer. Thus the initialization cannot be assumed to survive a new
stream: apply it after each STREAMON. This was tested, not merely inferred.
The reproducible wrapper `python3 diagnostics/capture_initialized.py` performs
that sequence and saves its log.

## Experimental EEPROM candidate — NOT APPLIED

File: neximage-eeprom-format-index-experimental.bin (32,768 bytes).
SHA-256: a2fe7b95f855dabe6451c1c378ea238763b089f493f97800271c5c856582319c.

The one new byte compared to the verified corrected backup:

| EEPROM offset | Corrected backup | Candidate | Meaning |
|---|---|---|---|
| 1F0C | 01 | 02 | GRBG format template bFormatIndex |

Relative to the untouched original, **exactly two bytes** differ: 1F0C 01→02
and the already-approved 1F34 33→4F. No other byte changes. Generator
make_index_candidate.py verifies full-file hashes, descriptor context and
complete differences; index-candidate.json records the manifest.

Reasoning: keep the actually used firmware format index 1 on the frame-bearing
GREY descriptor, move the empty GRBG descriptor out of its way, and let the
stock Linux frame-size correction select 345,600 / 1,228,800 bytes correctly.
The expected usable API format becomes GREY; the pixels are still raw Bayer.
GRBG remains a descriptor with no frames. This minimal experiment does not
make every descriptor UVC-compliant and does not fix missing ROI/clock setup.
It is a targeted test, not a demonstrated complete repair.

Risks: any EEPROM programming can fail or affect enumeration. A descriptor
index may also be used by undocumented firmware logic; no full firmware source
or checksum specification is available. The prior byte edit proves this image
can boot with that prior edit, not that arbitrary further edits are checksum-
free. This candidate changes no code, pointers, lengths, VID/PID, mode flag,
serial, or calibration data. Do not flash an entire replacement image merely
to change this byte. Do not assume a generic 72-series firmware is sensor-
compatible: Celestron documents this camera as AR0132AT, 1280×960.

Recovery plan if explicitly authorized later:

1. Before programming, read all 32 KiB and require the exact corrected-backup
   SHA; verify serial, UVC PID and target context. Stop if anything differs.
2. Program only 1F0C, verify the entire EEPROM against the candidate before
   reconnecting. Retain the unchanged original and corrected images.
3. After reconnect, inspect descriptors and test GREY negotiation and complete
   frame capture, including the documented volatile ROI/clock initialization.
4. To roll back this experiment, restore **only 1F0C to 01** and verify all
   32 KiB equal the corrected backup. **Keep 1F34=4F.** Reconnect and retest.
5. If normal UVC binding fails but USB vendor access survives, use the same
   vendor protocol for that one-byte rollback without switching camera mode.
   If the device no longer enumerates, software recovery is not guaranteed;
   external EEPROM programming may be necessary. Recovery hardware was not
   tested, so this risk cannot be eliminated.

No EEPROM-write utility was executed. Further persistent changes require
explicit user authorization.

## Upstream context

Celestron's [product specifications](https://www.celestron.com/products/neximage-burst-color)
identify the AR0132AT sensor and 1280×960 native resolution. The vendor's
[older 72-series Linux note](https://theimagingsource.deskpro.com/en/kb/articles/pdf/linux-pipeline-for-older-dfk-72-camera-models)
explains a monochrome-labelled Bayer workaround for that different camera
family; it is not authorization or compatibility evidence for flashing its
firmware onto this camera. The local 146 images contain many of the same
legacy descriptor templates, reinforcing the shared-code origin without
establishing interchangeability.

The [USB-IF document library](https://www.usb.org/documents?search=USB%20Video)
provides the UVC 1.1 class and frame-based payload documents. Relevant checks
are unique format indices, the 13+p*n streaming-header size, format/frame
association, fixed-size frame geometry, and payload EOF/FID interpretation.

## Concrete remaining blocker

The unchanged standard driver now demonstrably receives complete frames after
volatile sensor setup, but cannot accept them as valid while the duplicated
format IDs leave its expected frame size at 5,038,848. Correcting that identity
collision requires a persistent descriptor experiment or a host workaround.
A fully automatic, power-cycle-safe UVC repair additionally needs the firmware
commit path to set ROI/clock correctly; a verified firmware code patch for that
path has not been established. The minimal candidate should not be represented
as solving that second issue.

Final integrity check: a preliminary sequential read immediately after streaming
failed comparison. Repeating with a 10-ms delay after read-address selection
returned all 32,768 bytes exactly matching the corrected-backup SHA, with zero
byte differences. The manufacturer reader explicitly delays after selecting the
address; retain that delay in future diagnostics. The successful final read is
live-final-read-0.bin, documented in live-eeprom-final-verified.txt. No EEPROM
programming request was sent in response to the failed read.

## Authorized format-index write — follow-up

The user explicitly approved applying the one-byte candidate. Pre-write full
EEPROM matched the corrected backup. Exactly one programming request was sent:
OUT 40/02, wValue=0, wIndex=A1, data=1F 0C 02. It returned 3; the subsequent
completion IN returned zero bytes. No retry or additional write was sent.
Two independent full readbacks exactly matched the candidate SHA
a2fe7b95f855dabe6451c1c378ea238763b089f493f97800271c5c856582319c.
Only 1F0C differs from the corrected backup; 1F34 remains 4F.
See format-index-write-result.json and eeprom-after-format-index-write.bin.
Live descriptors were read next to check whether the change requires a physical
power cycle. Original investigation text above describes the pre-write state.

## Post-reconnect results — valid standard V4L2 capture

The new live descriptors show GRBG format index 2 and Y800/GREY index 1.
Linux now selects GREY as requested and reports sizeimage=345600 at 720×480
or 1228800 at 1280×960. Neither kernel source nor module parameters were changed.

A 24-buffer capture with initialization after STREAMON produced 17 consecutive
error-free 345600-byte buffers (sequence 7–23). Early buffers were transitional
errors. A subsequent standard v4l2-ctl capture discarded the startup errors
and successfully wrote ten valid frames per size:

| Size | Verified frames | Output bytes | Measured rate | Sensor clock |
|---|---|---|---|---|
| 720×480 | 10 | 3456000 | ~14.26 fps | 12 MHz |
| 1280×960 | 10 | 12288000 | ~14.69 fps | 24 MHz |

Artifacts: v4l2-valid-720x480.raw and v4l2-valid-1280x960.raw, their .raw.log
files, v4l2-postpatch-initialized.txt and postpatch-validation.json.

Use the wrapper from the repository root (choose a new output filename):

    python3 diagnostics/capture_v4l2.py --count 30 --output capture.raw

Native resolution:

    python3 diagnostics/capture_v4l2.py --width 1280 --height 960 --clock 24000000 --count 30 --output capture-native.raw

This launches standard v4l2-ctl, observes successful STREAMON, then sets only
volatile ROI/clock controls and verifies readback. It allows startup errors to
be discarded, verifies the final file size, and saves the capture log. It does
not write EEPROM, switch mode, detach uvcvideo, or alter the kernel.

Remaining limits: the camera advertises GREY but supplies a Bayer mosaic
(previously GRBG-labelled), so color rendering requires debayering. Other apps
need the same initialization after their own STREAMON, or a future firmware
commit-path fix. This helper does not make every application work automatically.
UVC's reported fps can disagree with measured sensor timing. USB read/write
permission is required for the helper and may be lost after another reconnect.
Only the approved EEPROM byte was programmed; no additional persistent repair
was attempted.

## Offline executable-code investigation — later follow-up

A concrete UVC frame-pointer lookup defect was located. Existing firmware already
contains a deferred ROI/clock apply path; the earlier missing-initialization
explanation was incomplete. The old path reads bogus dimensions, reproducing
both the observed 107712-byte output and the independently read 7227990-Hz clock.
An offline in-place code candidate and emulator checks are now in firmware-re/.
See firmware-re/README.md for evidence, limitations, complete patch references
and recovery plan. Candidate SHA: e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6.
It is NOT applied: the camera remains on the working descriptor-only patch.

## Approved executable-code write

The user approved applying the ROI lookup candidate. Only EEPROM 18F7–1943 was
programmed, in four page-bounded transactions. Two full readbacks exactly match
e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6.
Both earlier descriptor corrections remain intact. Physical reconnect and
no-helper capture validation are pending; see firmware-re/roi-write-result.json.

## Final no-helper hardware validation

All four post-reconnect standard V4L2 captures passed: 720×480, native
1280×960, 640×480, then 720×480 reopened. Forty valid frames were saved at exact
expected lengths, with flags clear. One initial transition error buffer was
discarded on each mode change; none occurred in the first 720×480 capture.
No helper or further EEPROM write was used. See firmware-re/validation-cold1/.
The verified working final image is neximage-eeprom-working-uvc-autoinit.bin.
