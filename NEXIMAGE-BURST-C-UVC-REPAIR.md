# Celestron NexImage Burst C: repairing UVC operation under modern Linux

**20 October update:** an additional eight-byte GUID swap now exposes all usable
frames as GRBG. Four post-reconnect captures passed (40 complete frames), and the
owner confirmed correct colours with the application's **Bayer Pattern = GRBG**.
Use `pixelformat=GRBG` with the updated firmware. See the
[GRBG repair record](diagnostics/firmware-re/GRBG-PROPOSAL.md) for exact bytes,
image hash, programming verification, and capture results. The report below
preserves the 19 October repair history and its GREY-labelled baseline image.

**Investigation and repair record — 19 October 2026**  
**Camera serial:** 28414934  
**Repository:** TheImagingSource/tcam-firmware-update

## Result

The camera now produces valid image frames through the stock Linux `uvcvideo`
driver and ordinary `v4l2-ctl`, including after a physical reconnect and after
stopping, changing modes, and restarting capture. No sensor-initialization helper
or kernel patch is required.

This required three corrections to the camera's EEPROM image:

| Correction | EEPROM location | Purpose |
|---|---|---|
| Configuration length | `0x1F34`: `33 → 4F` | Expose the previously truncated streaming endpoint descriptor |
| Format index | `0x1F0C`: `01 → 02` | Stop Linux confusing a frameless GRBG format with the frame-bearing GREY format |
| UVC frame lookup | `0x18F7–0x1943`, inclusive | Make the existing firmware initialization use the selected frame's actual dimensions |

The last correction replaces 77 bytes of executable code; 76 byte values differ.
The final 32,768-byte image differs from the preserved original backup at exactly
**78 byte positions**. Each correction was separately approved before it was
written. The original backup was preserved throughout.

Measured final results:

| Capture | Valid frames saved | Bytes per image | Measured rate |
|---|---:|---:|---:|
| 720×480, first stream after reconnect | 10 | 345,600 | 14.9023 fps |
| 1280×960, after mode change | 10 | 1,228,800 | 7.5001 fps |
| 640×480, after mode change | 10 | 307,200 | 14.9018 fps |
| 720×480, reopened after the other modes | 10 | 345,600 | 14.9019 fps |

All 40 saved frames were dequeued without `V4L2_BUF_FLAG_ERROR`. Each of the
three mode changes produced one transitional error buffer, which `v4l2-ctl`
discarded before saving valid frames. The first post-reconnect capture had no
error buffers. The owner subsequently confirmed that the camera displays an image.

The repair is demonstrated on this camera and firmware image. It does not
establish compatibility with other NexImage cameras or every application, and
it does not make the descriptors completely UVC-compliant.

## 1. Starting hardware and software

| Item | Value |
|---|---|
| Camera | Celestron NexImage Burst C, manufactured by The Imaging Source |
| Sensor | ON Semiconductor/Aptina AR0132AT, native 1280×960 color sensor |
| Serial | `28414934` |
| Proprietary-mode USB ID | `199e:8208` |
| UVC-mode USB ID | `199e:8308` |
| Reported firmware version | 146 |
| EEPROM | 32,768 bytes |
| USB link | USB 2.0 High Speed, 480 Mbps |
| Host | Ubuntu Linux, xHCI controller, kernel `7.0.0-38-generic` |

The USB device descriptor's `bcdDevice` value, displayed as `8.13`, is a separate
field from the manufacturer's reported firmware version 146. These patches do
not assign a new firmware-version number.

The official utility can switch the device to UVC mode:

```bash
sudo ./build/bin/tcam-firmware-update -d 28414934 -m uvc
```

That command is recorded here as a historical step, not something to rerun on
the repaired camera. It changes the product ID and a mode flag; it does not
install a different firmware implementation. Therefore an existing but defective
UVC path can become visible when switching modes.

The file named `neximage-eeprom-original.bin` is the unmodified **pre-repair
backup used in this investigation**, not necessarily a factory/proprietary-mode
image. Its PID bytes already encode `8308` and its mode byte is already `01`.
The 78-byte final difference count is relative to that backup; it does not count
the earlier mode-switch changes.

The first descriptor diagnosis and repair described below had already been
completed when the later streaming investigation began. Their evidence was
supplied at handoff and the backup differences were independently checked.

## 2. First failure: Linux could not find a streaming endpoint

### What happened

The camera enumerated in UVC mode, but `VIDIOC_STREAMON` failed with `EIO`.
Linux reported an invalid/truncated configuration and registered no endpoint on
video-streaming interface 1.

The configuration header was:

```text
09 02 33 01 02 01 00 80 FA
```

USB encodes the total configuration length little-endian. Here `33 01` means
`0x0133`, or 307 bytes. Direct control transfers requesting more data showed that
the camera actually returned **335 bytes**.

The truncated portion included the required endpoint descriptor:

```text
07 05 82 02 00 02 01
```

It defines bulk IN endpoint `0x82`, with 512-byte maximum packets. Linux could
not use an endpoint that it had discarded while parsing the shortened configuration.

### What changed, and why

The configuration header was located at EEPROM offset `0x1F32`. Changing only
`0x1F34` from `33` to `4F` changed the declared total to `0x014F`, or 335 bytes:

```text
09 02 4F 01 02 01 00 80 FA
```

The full EEPROM was compared with the original backup. Exactly one byte had
changed. After unplugging and reconnecting, the truncation warnings disappeared,
endpoint `0x82` was registered, and `STREAMON` succeeded.

**What this established:** the endpoint-discovery problem was fixed. It did not
establish that the camera was sending valid frames.

## 3. Second failure: streaming started, but every frame was erroneous

After the length repair, several symptoms remained:

- Requesting `GREY` returned `GRBG`.
- A 720×480 image was reported as requiring 5,038,848 bytes, instead of 345,600.
- Stable dequeued buffers contained only about 107,712 bytes and carried
  `V4L2_BUF_FLAG_ERROR`.
- Timestamps were about 67.1 ms apart, suggesting approximately 15 fps.
- A normal `v4l2-ctl --stream-to` capture produced an empty file because its
  stream writer discarded the erroneous buffers.

A small C capture utility was written to save **all** dequeued buffers, including
error-flagged ones. This distinguished “no image data arrived” from “the driver
received data and rejected its frame size.”

The relevant artifacts are [capture_errors.c](diagnostics/capture_errors.c), the
saved raw buffers, and the capture logs under [diagnostics](diagnostics/).

### Descriptor audit

The live descriptor set had additional inconsistencies:

| Field or structure | Observed problem |
|---|---|
| Format identities | GRBG and Y800/GREY both used format index 1 |
| Frame association | All three frame descriptors followed GREY; none followed GRBG |
| Frame counts | Both formats claimed four frames, inconsistent with the actual layout |
| Streaming header format count | Claimed three formats; two were present |
| Streaming header length | 15 bytes, but its declared fields required 19 |
| Streaming class-specific total | Claimed 169 bytes; actual total was 203 |
| Some bitrate fields | Implausible values, including a minimum greater than the maximum |

The three actual frame IDs were 1, 2, and 4, for 1280×960, 720×480, and 640×480.
The descriptors use the **frame-based** format/frame layouts, subtypes `0x10`
and `0x11`. Those contain `dwBytesPerLine`; they do not have the same field
layout as the usual uncompressed-frame descriptor. Blindly patching an offset
labelled `dwMaxVideoFrameBufferSize` in another descriptor layout would therefore
have changed the wrong bytes.

The camera also advertises UVC 1.00 while using frame-based descriptor structures
associated with UVC 1.1. Changing the version number alone would alter the control
lengths expected by Linux and was not a justified fix.

The EEPROM stores descriptor templates interspersed with executable code. The
camera assembles the live configuration at runtime. In particular, there is no
contiguous 335-byte configuration block beginning at EEPROM `0x1F32` that could
safely be replaced as a single descriptor blob.

See [descriptor-audit.txt](diagnostics/descriptor-audit.txt) and
[live-descriptors.bin](diagnostics/live-descriptors.bin) for the recorded layout.

### Why Linux returned the wrong format and marked buffers bad

We compared the behavior with upstream Linux v7.0 source. The Ubuntu module was
not proven byte-for-byte identical to that source, but its observed behavior
matched the relevant paths.

Linux initially chooses GREY and negotiates its format index. On receiving
index 1 back, it resolves that ID to the first matching descriptor: the frameless
GRBG entry. That explains why a GREY request could return GRBG.

The same collision prevents the normal frame-size correction from finding a
frame. Linux consequently retains the camera's bogus maximum-frame-size reply.
Its fixed-size image validator marks a buffer erroneous when the received byte
count differs from the expected frame size. This was sufficient to reject both
107,712-byte buffers and, later, complete 345,600-byte buffers.

The camera reported both maximum frame size and maximum payload size as
`0x004CE300` = **5,038,848 = 2592×1944**. That matches a related 72-series camera's
image geometry, rather than this camera's sensor. The numeric relationship
suggested shared legacy firmware assumptions, but did not establish that another
model's firmware would be safe to install.

References: [format parsing](https://github.com/torvalds/linux/blob/v7.0/drivers/media/usb/uvc/uvc_driver.c),
[format selection](https://github.com/torvalds/linux/blob/v7.0/drivers/media/usb/uvc/uvc_v4l2.c), and
[stream-control correction and frame validation](https://github.com/torvalds/linux/blob/v7.0/drivers/media/usb/uvc/uvc_video.c).

## 4. Direct USB capture isolated the short-frame problem

We temporarily detached the kernel driver, performed standard volatile UVC
probe/commit operations through libusb, captured bulk data, and restored driver
ownership afterward. No EEPROM programming was part of these tests.

Stable USB payloads contained:

```text
2-byte UVC header + 107,712 image bytes = 107,714 total bytes
```

The headers alternated `02 02` and `02 03`: header length two, end-of-frame set,
frame ID alternating, and payload error bit clear. The EOH bit was not set, but
Linux accepted that header convention.

Changing host read size did not change the payload size:

| Host read size | Reads per stable payload | Total |
|---|---|---:|
| 16,384 bytes | Six full reads plus 9,410 bytes | 107,714 |
| 65,536 bytes | One full read plus 42,178 bytes | 107,714 |

This reproduced the truncation without Linux's UVC decoder. It ruled out the
Linux frame decoder and its URB segmentation as the explanation for the stable
short payloads. It also showed that the stable frames did have end markers;
missing EOF alone was not the cause.

Initial bytes after starting a stream could be partial or stale. Partial reads
ending in a timeout were not treated as trustworthy USB payload boundaries.

Evidence: [bulk-current.json](diagnostics/bulk-current.json),
[bulk-frame2large.json](diagnostics/bulk-frame2large.json), their `.bin` files,
and [analyze_bulk.py](diagnostics/analyze_bulk.py).

## 5. A temporary helper proved the sensor could deliver complete frames

The Open Astro Project's existing EUVC driver explicitly describes extra sensor
configuration for this camera family, including a comment naming the Burst C.
It sets ROI and pixel clock in addition to UVC negotiation.

The relevant camera-terminal controls, on entity 1, were:

| Selector | Function | Data |
|---|---|---|
| `0x24` | Pixel clock | Four-byte little-endian Hz value |
| `0x25`, `0x26` | ROI width and height | Four-byte little-endian values |
| `0x28`, `0x29` | ROI X and Y origins | Four-byte little-endian values |
| `0x2A` | Binning | One byte |

Reads advertised a supported clock range of 12–41 MHz. Some negotiated states
reported clocks outside that range. ROI-only testing later exposed a current
clock of **7,227,990 Hz**, an important clue for the reverse engineering.

After UVC commit, explicitly setting origin (0,0), ROI 720×480, and clock 12 MHz
produced **28 complete 345,600-byte images** through direct USB capture. Setting
ROI 1280×960 and clock 24 MHz produced **21 complete 1,228,800-byte images**.
The data varied like sensor output, rather than being empty buffers. Optical
focus and image quality were not assessed during those byte-level tests.

The manufacturer's own updater uses class/device-recipient controls to read
firmware version. Following that convention also let the helper set and read
back the ROI/clock controls while `uvcvideo` remained attached. A standard V4L2
stream then received complete frames, although the wrong expected frame size
still caused error flags.

**Why this test mattered:** it demonstrated a working sensor-to-USB image path
and supplied a known-good configuration sequence. It separated the sensor
configuration problem from the format-index problem.

At this point we suspected that UVC negotiation omitted required initialization.
Later executable-code analysis refined that explanation: initialization already
existed, but consumed dimensions fetched from the wrong descriptor location.

Sources: [EUVCcontroller.c](https://github.com/openastroproject/openastro/blob/master/liboacam/euvc/EUVCcontroller.c)
and [EUVC control definitions](https://github.com/openastroproject/openastro/blob/master/liboacam/euvc/EUVC.h).
Local tools include [initialize_sensor.py](diagnostics/initialize_sensor.py) and
[read_uvc.py](diagnostics/read_uvc.py). These were diagnostic workarounds; the final
firmware does not require them.

## 6. Second EEPROM correction: distinguish the format indices

We generated a candidate that changed only the empty GRBG descriptor's format
index, leaving index 1 on the frame-bearing GREY descriptor:

```text
EEPROM 0x1F0C: 01 → 02
```

The intent was to let Linux find the correct frame and calculate its normal
expected size. This did not attempt to add missing GRBG frame descriptors or
correct every descriptor inconsistency.

After explicit approval, the full live EEPROM was first required to match the
known length-corrected backup exactly. One three-byte vendor OUT payload,
`1F 0C 02`, programmed the single data byte. Its completion read returned zero
bytes, so we did not assume that the write had failed or repeat it. Two complete
EEPROM readbacks instead established that it had succeeded and that no other
byte had changed.

A physical reconnect was required because the running camera still served its
old in-memory descriptors immediately after the EEPROM write.

After reconnect:

- Live descriptors showed GRBG index 2 and GREY index 1.
- GREY requests remained GREY.
- Linux reported 345,600 bytes at 720×480 and 1,228,800 bytes at 1280×960.
- With temporary sensor initialization, V4L2 delivered 17 consecutive complete
  720×480 buffers with the error flag clear.
- Standard `v4l2-ctl` saved ten valid frames at each of 720×480 and 1280×960.

This independently confirmed the format-index diagnosis. The camera still
needed the temporary helper after each new stream, so the repair was not yet
complete.

Evidence: [format-index-write-result.json](diagnostics/format-index-write-result.json),
[postpatch-validation.json](diagnostics/postpatch-validation.json), and
[v4l2-postpatch-initialized.txt](diagnostics/v4l2-postpatch-initialized.txt).

## 7. Reverse engineering identified the firmware's actual initialization bug

### Code mapping and existing routines

The repository supplies an updater and compiled firmware images, not the camera
firmware's source. We therefore analyzed the saved image offline using a pinned
MCS-51/8051 disassembler and a small interpreter built for the relevant paths.

The image contains a four-byte prefix. For this image:

```text
CPU code address = EEPROM file offset − 4
```

Reset-vector targets, computed jump tables, descriptor pointers, and decoded
control behavior support that mapping. The exact MCU model and full boot-prefix
format were not independently established, and the patch leaves the prefix alone.

**All addresses in the following table are CPU code addresses, not EEPROM offsets.**

| Address | Function identified |
|---|---|
| `0x17E9` | UVC probe/commit handler |
| `0x1880` | SET_CUR data receipt and negotiation |
| `0x18F3–0x193F` | Defective dimension lookup |
| `0x1940` | Continuation: origin reset and timing negotiation |
| `0x19EC` | Set pending-mode flag |
| `0x3181–0x319B` | Deferred application of the selected mode |
| `0x375F` | Apply a changed pixel clock |
| `0x2D49` | Apply width and X origin |
| `0x2C00` | Apply height and Y origin |
| `0x2B0B` | Calculate clock from geometry and interval, then apply configuration |
| `0x15B6` | Program sensor PLL |

This was a significant finding: we did not need to graft an entirely new helper
into firmware. The existing main-loop path already applied ROI and clock.

### The incorrect descriptor arithmetic

A table at code address `0x32C9` holds three-byte pointers:

| Slot | Pointer bytes | Target |
|---|---|---|
| 0 | `FF 1E E9` | Y800 format descriptor |
| 1 | `FF 1E 95` | Frame ID 1: 1280×960 |
| 2 | `FF 1E 41` | Frame ID 2: 720×480 |
| 3 | `FF 1E BF` | Frame ID 4: 640×480 |
| 4 | `FF 1F 21` | Color descriptor |
| 5 | `FF 1F 27` | Endpoint descriptor |

The original UVC code loaded slot 0, then treated that **format** descriptor as
the base of a contiguous array of 42-byte **frame** descriptors. It also remapped
frame ID 4 to ordinal 5, another legacy assumption inconsistent with this image's
actual table. Its dimension reads therefore landed in unrelated descriptor bytes.

For the requested 720×480 frame, the original code read:

```text
Width  = 0x719B = 29,083
Height = 0x0108 = 264
```

The low-byte bridge width programming corresponds to 408 pixels after its
four-pixel units are taken into account:

```text
408 × 264 = 107,712
```

That matches the repeating image size. The full meaning of additional bridge
mode bits was not documented, so the numeric match alone was treated as evidence,
not a complete hardware register specification.

An even stronger independent check came from the clock. Executing the original
firmware arithmetic with those bogus dimensions and the negotiated interval
produced **7,227,990 Hz**, exactly matching the earlier live clock readback.

For the tested values, the existing calculation is equivalent to:

```text
clock_Hz = ((100000000 // interval_100ns) × 1650 × (height + 30)) // 10
```

The effective horizontal line length is 1280 + 370 = 1650 clocks. Integer division
introduces small rate differences: a 720×480 request at 15 fps computes
12,538,350 Hz and yields about 14.9 fps. The earlier 12-MHz helper yielded about
14.26 fps for the same reason.

### The in-place correction

The replacement code:

1. Accepts frame IDs 1, 2, and 4, rejecting unsupported IDs before table access.
2. Maps those IDs to pointer slots 1, 2, and 3.
3. Fetches the actual frame descriptor pointer.
4. Reads its little-endian width and height into the existing firmware variables.
5. Jumps back to the original origin-reset, interval-negotiation, and deferred
   initialization path.

It replaces CPU `0x18F3–0x193F`, which is EEPROM **`0x18F7–0x1943` inclusive**.
The 74-byte replacement and rejection path are followed by three NOP bytes.
The image length is unchanged, no code is relocated, and no unused EEPROM area
is assumed to be executable. Existing sensor-control routines and frame-rate
tables are retained.

The candidate generator, addressed listing, and full byte manifest are:

- [build_roi_candidate.py](diagnostics/firmware-re/build_roi_candidate.py)
- [roi-candidate.asm](diagnostics/firmware-re/roi-candidate.asm)
- [roi-candidate-manifest.json](diagnostics/firmware-re/roi-candidate-manifest.json)

## 8. Offline validation before programming executable code

The risk was higher than for a descriptor edit: incorrect executable code could
hang probing or sensor setup and make vendor-access rollback unavailable.
Before seeking write approval, the candidate was checked offline.

The interpreter separates upper indirect RAM from SFRs, models register banks,
stack and flags, and executes the firmware's actual control arithmetic and EP0
receive/transmit routines against a modeled FIFO. It is not a complete camera,
USB-timing, PLL, or interrupt emulator. Hardware-specific operations were stubbed
where applicable; passing the model alone was not considered a working repair.

Checks included:

- Full-image hashes, exact changed-byte boundaries, and preservation of both
  descriptor fixes.
- Eighty randomized executions of the original 32-bit multiply/divide routines,
  compared with independent Python arithmetic.
- Reproduction of the original erroneous dimensions and measured bad clock.
- Replacement branches landing on valid instruction boundaries.
- Rejection of all 253 unsupported frame IDs from an initially clear pending state.
- Correct dimensions and in-range computed clocks for all 12 advertised
  size/interval requests, while preserving the old negotiation results.
- Existing ROI register-write sequences and deferred mode-application paths
  for all three sizes.
- Valid GET_CUR reply construction for all three frame IDs.

The analysis also checked for outside absolute calls/jumps into the replaced
block. A misleading `12 19 17` sequence was identified as sensor-sequencer data,
not an executable call. These checks did not prove the absence of every possible
indirect reference or concurrent-interrupt interaction.

Results and reproducible checks:

```bash
python3 diagnostics/firmware-re/test_roi_candidate.py
```

See [offline-validation.json](diagnostics/firmware-re/offline-validation.json)
and [test_roi_candidate.py](diagnostics/firmware-re/test_roi_candidate.py).
The disassembler definitions came from
[disasm51 1.0.2](https://github.com/OlekMazur/disasm51), vendored locally under its
Apache-2.0 license. No camera access was needed for this reverse-engineering phase.

## 9. Programming the approved code block

After separate explicit approval, the live EEPROM was required to match the
working descriptor-only image exactly. The patch was then written as four
transactions confined to 32-byte page boundaries:

| EEPROM start | Data bytes | Reason for split |
|---|---:|---|
| `0x18F7` | 9 | Finish the current 32-byte page |
| `0x1900` | 32 | One aligned page |
| `0x1920` | 32 | One aligned page |
| `0x1940` | 4 | Remaining bytes |

This avoided assuming that an unaligned multi-byte EEPROM write could safely
cross a page boundary. Completion reads returned lengths 1, 0, 0, and 0.
No programming request was repeated merely because a completion reply was empty.

**Two independent full 32-KiB readbacks matched the entire candidate exactly.**
Only the approved code block changed; both previous descriptor fixes remained
intact. A physical reconnect then loaded the new executable image.

The source protocol came from [Usb2Camera.cpp](src/Usb2Camera.cpp):

| Operation | USB request |
|---|---|
| Select EEPROM read address | OUT `40/03`, value 0, index `A1`, two-byte big-endian address |
| Read sequential EEPROM data | IN `C0/02`, value 0, index `A0` |
| Program EEPROM data | OUT `40/02`, value 0, index `A1`, address followed by data |
| Programming completion read | IN `C0/02`, value 0, index `A0`, following the vendor sequence |

The read-address selector and programmer use different request numbers.
An address-selection delay was important: an immediate sequential read once
failed comparison, whereas a repeat with a 10-ms settling delay matched the
whole expected image. Readback mismatch was investigated rather than treated
as proof that EEPROM contents had changed.

The guarded writer, transaction record, and before/after snapshots are in
[firmware-re](diagnostics/firmware-re/):
[apply_roi_candidate.py](diagnostics/firmware-re/apply_roi_candidate.py),
[roi-write-result.json](diagnostics/firmware-re/roi-write-result.json), and
[eeprom-after-roi-write-1.bin](diagnostics/firmware-re/eeprom-after-roi-write-1.bin).
These programming tools are historical repair artifacts, not normal capture commands.

## 10. Hardware validation without helpers

After reconnect, the camera enumerated normally as `199e:8308`, serial 28414934.
Validation used only standard `v4l2-ctl` calls. It did not import a USB library,
set private sensor controls, detach the driver, change the kernel, or write EEPROM.

The test sequence was 720×480 → 1280×960 → 640×480 → 720×480 reopened. Each test
saved ten full frames, with the measured results shown at the start of this
report. Exact file sizes, buffer flags, and timestamps were checked. This
established that the new firmware itself supplied the initialization previously
provided by the helper.

The helper-free validator and complete evidence are:

- [validate_without_helper.py](diagnostics/firmware-re/validate_without_helper.py)
- [results.json](diagnostics/firmware-re/validation-cold1/results.json)
- [Capture logs and raw images](diagnostics/firmware-re/validation-cold1/)

The initial tests required raw USB permissions for libusb. Those temporary ACLs
were lost on re-enumeration. The final V4L2-only tests did not need them, an
additional check that no hidden raw-USB initializer was responsible for success.

## 11. Using the repaired camera

Use `GREY` as the API pixel format. Despite that label, the bytes remain the
sensor's Bayer mosaic, previously labelled GRBG; color rendering requires
appropriate debayering. Do not interpret the raw file as RGB pixels.

For example, using a new destination filename:

```bash
v4l2-ctl -d /dev/video0 \
  --set-fmt-video=width=720,height=480,pixelformat=GREY \
  --set-parm=15 \
  --stream-mmap=4 --stream-count=30 \
  --stream-to=capture.raw
```

At native resolution:

```bash
v4l2-ctl -d /dev/video0 \
  --set-fmt-video=width=1280,height=960,pixelformat=GREY \
  --set-parm=10 \
  --stream-mmap=4 --stream-count=30 \
  --stream-to=capture-native.raw
```

The latter negotiates approximately **7.5 fps**, not the requested 10 fps.
Device-node numbering may change if other cameras are present.

The earlier `initialize_sensor.py` and `capture_v4l2.py` helpers are no longer
needed for this firmware image. They remain useful records of the intermediate
diagnosis and could be relevant if reverting to the descriptor-only image.

## 12. Remaining limitations and the status-endpoint warnings

### Frame rates and descriptor consistency

The code correction deliberately preserves the legacy timing tables. The
reported/negotiated rate list is still imperfect: native mode runs at 7.5 fps,
smaller tested modes at about 14.9 fps, and some untested requests can negotiate
rates absent from the descriptor list. Faster advertised rates were not all
validated on hardware.

The unused GRBG format still has no frame descriptors. The camera continues
to expose Bayer data through GREY, and the streaming header/count/bitrate defects
identified earlier were not all repaired. Successful Linux streaming is not a
claim of complete UVC specification compliance or compatibility with all software.

A single startup error buffer on a mode change was observed and discarded.
Sustained valid frames followed; merely succeeding at STREAMON was never the
acceptance criterion. Long-duration reliability, every control, and every
third-party application were not exhaustively tested.

### `Non-zero status (-75) in status completion handler`

These messages occurred before the executable-code patch and remain visible.
They refer to the **interrupt notification endpoint `0x81`**, not the bulk image
endpoint `0x82`. The notification endpoint advertises eight-byte maximum packets.

`-75` is `EOVERFLOW`: the endpoint returned more data than the allowed packet
size or remaining receive-buffer capacity. A firmware status-packet mismatch is
plausible, but the status packets were not captured to establish the exact cause.

In the inspected Linux status handler, this error returns without resubmitting
the status URB. Asynchronous control-change or other status notifications can
therefore stop. This does not by itself prove that normal control reads/writes
or image transfers fail. Our image captures succeeded despite the warnings.

The remaining issue was left separate from the proven streaming repair. It
warrants investigation if notifications, controls, or capture stability misbehave;
it is not evidence by itself that the repaired image stream is invalid.

References: [Linux USB error definitions](https://cdn.kernel.org/doc/html/latest/driver-api/usb/error-codes.html)
and [UVC status handler](https://github.com/torvalds/linux/blob/v7.0/drivers/media/usb/uvc/uvc_status.c).

## 13. Backups, exact changes, and recovery

All images below are 32,768 bytes. Their hashes and byte differences were checked
again while preparing this document.

| Stage | File | Changed bytes versus original |
|---|---|---:|
| Original investigation backup, already UVC mode | [neximage-eeprom-original.bin](neximage-eeprom-original.bin) | 0 |
| Configuration-length correction | [neximage-eeprom-after-attempt.bin](neximage-eeprom-after-attempt.bin) | 1 |
| Both descriptor corrections | [neximage-eeprom-format-index-experimental.bin](neximage-eeprom-format-index-experimental.bin) | 2 |
| Final working firmware with automatic initialization | [neximage-eeprom-working-uvc-autoinit.bin](neximage-eeprom-working-uvc-autoinit.bin) | 78 |

SHA-256 values, in the same order:

```text
original:
743c32526036dd6600ee0e40596eea8df8264af6f0b3bdf4adfaec33bf4f6dc9

configuration length fixed:
cdf65664e3cad5640b9923dfa370e1ab9fc100b4ed6ed908587daddd2bb2584a

both descriptors fixed:
a2fe7b95f855dabe6451c1c378ea238763b089f493f97800271c5c856582319c

final working firmware:
e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6
```

The final working image is an actual verified post-write readback. It equals
both independent post-write snapshots and the candidate file
`neximage-eeprom-uvc-roi-lookup-candidate.bin`. The word “candidate” in that older
filename no longer means the image is untested. Similarly,
`neximage-eeprom-uvc335-candidate.bin` is identical to the length-corrected backup.

Every final changed byte is listed in
[final-eeprom-byte-diff.csv](diagnostics/final-eeprom-byte-diff.csv), and the
stage hashes and complete comparisons are in
[final-repair-manifest.json](diagnostics/final-repair-manifest.json).
The executable block's before/after transaction data is in
[proposed-write-plan.json](diagnostics/firmware-re/proposed-write-plan.json),
whose name reflects its origin as the pre-write plan.

The rollback target for the executable-code experiment is the **descriptor-only
working image**, SHA `a2fe…`, not the untouched original. Restoring EEPROM
`0x18F7–0x1943` from that image and verifying the entire 32 KiB would remove the
code correction while keeping `0x1F0C=02` and `0x1F34=4F`. That rollback would
restore the need for the host sensor-initialization helper.

If separately reverting the format-index experiment, the previous plan was to
restore only `0x1F0C=01`, keeping `0x1F34=4F`, and verify the entire image against
the length-corrected backup. There is no operational reason to undo the successful
configuration-length fix or restore the original image wholesale.

Any future programming should first verify the precise camera identity and full
expected EEPROM hash, preserve the current working image, confine writes to
reviewed ranges, and verify the entire resulting image before reconnecting.
EEPROM programming or a bad executable patch can impair enumeration and prevent
software rollback. External EEPROM recovery has not been tested. Success here
is not permission or evidence to flash these model-specific bytes onto another
camera or install an unrelated generic firmware image.

The supplied `dump_neximage.py` unconditionally writes to the original-backup
filename. It was not used during the later investigation because that would
have risked overwriting the preserved original. Future dumps should use a new
filename and retain the original hash-verified backup.

## 14. Evidence and provenance

This document consolidates the final conclusions; the older investigation notes
were accumulated as hypotheses changed and contain explicitly historical states.
Use this document and the final validation records to determine what is now true.

| Evidence | Location |
|---|---|
| Updater's actual vendor protocol | [src/Usb2Camera.cpp](src/Usb2Camera.cpp) |
| Descriptor audit and USB payload records | [diagnostics/](diagnostics/) |
| Earlier chronological investigation notes | [INVESTIGATION.md](diagnostics/INVESTIGATION.md) |
| Detailed executable-code analysis | [firmware-re/README.md](diagnostics/firmware-re/README.md) |
| Offline interpreter and regression checks | [firmware-re/](diagnostics/firmware-re/) |
| Executable patch's complete byte manifest | [roi-candidate-manifest.json](diagnostics/firmware-re/roi-candidate-manifest.json) |
| Actual programming transaction records | [roi-write-result.json](diagnostics/firmware-re/roi-write-result.json) |
| Final helper-free hardware tests | [validation-cold1/results.json](diagnostics/firmware-re/validation-cold1/results.json) |
| Final complete image history and byte differences | [final-repair-manifest.json](diagnostics/final-repair-manifest.json) |

The first repair was established from USB descriptor evidence. The second was
supported by Linux's format-selection behavior and verified by corrected frame
sizes. The final code repair tied the observed short payload and wrong clock to
a specific firmware lookup defect, passed bounded offline checks, and was then
validated on the actual camera without private controls. Keeping those evidence
levels separate is what allowed the working hardware repair to be distinguished
from the earlier, incomplete explanations.
