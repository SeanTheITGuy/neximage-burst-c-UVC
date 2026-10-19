# Offline UVC ROI/clock firmware correction

Current status: **APPLIED AND WORKING with stock V4L2 after physical reconnect,
without sensor-initialization helpers.** All three sizes and a repeated stream
startup passed. Two full EEPROM readbacks verified the programmed image before
reconnect. Both descriptor corrections are preserved. The analysis below records
the preceding offline phase; measured hardware results are appended at the end.

## Finding

The firmware already applies ROI and pixel clock after UVC negotiation. The
short frames came from an incorrect descriptor lookup, not an absent sensor
initialization routine. The earlier investigation's proposed missing-ROI
explanation was incomplete; the executable code resolves it.

The EEPROM has a 4-byte prefix. Within this image, CPU code address equals
EEPROM offset minus 4. This mapping is supported by the reset LJMP at file
0004 targeting the actual startup at file 2A04, computed jump tables, descriptor
pointers, and the consistency of the decoded control paths. The exact hardware
model and full boot-prefix format have not been independently established; this
patch changes neither the prefix nor the image extent.

The relevant paths (all addresses in this section are **CPU code addresses**):

| Address | Purpose |
|---|---|
| 3483 | Dispatch USB request type |
| 3838 | Dispatch class request by interface/mode |
| 3924 → 0168 | Camera-terminal EUVC controls |
| 17E9 | UVC VS_PROBE / VS_COMMIT handler |
| 1880 | SET_CUR data receipt and negotiation |
| 18F3–193F | Incorrect frame dimension lookup; candidate replaces this block |
| 1940 | Existing ROI-origin reset and timing negotiation continuation |
| 19EC | Set pending-mode flag bit 0E |
| 316D / 3181–319B | Main task / deferred mode application |
| 375F | Apply changed pixel-clock state, including sensor reinitialization |
| 2D49 | Apply ROI width and X origin to sensor and bridge |
| 2C00 | Apply ROI height and Y origin to sensor and bridge |
| 2B0B | Compute clock from geometry and frame interval, apply ROI and PLL |
| 15B6 | Sensor PLL programming |
| 2C75 | Physical sensor register write transaction |

The existing deferred path calls the clock update, both ROI writers, their
existing trampolines, and 2B0B, then clears pending bit 0E. The candidate does
not inject new initialization calls, allocate scratch RAM, or add an interrupt
handler. It repairs the geometry those existing routines consume.

The private controls confirm the shared machinery:

| Selector | Handler | Result |
|---|---|---|
| 24 | 0434 | Calculate clock state at indirect RAM 77–7A; call 375F |
| 25 | 0397 | Store width at indirect RAM 81–82; call 2D49 |
| 26 | 03E8 | Store height at indirect RAM 9D–9E; call 2C00 |
| 28 | 0553 | Store X origin at direct RAM 0D–0E; call 2D49 |
| 29 | 05A9 | Store Y origin at direct RAM 0F–10; call 2C00 |

## The bug and its quantitative match to hardware

Table 32C9 contains three-byte generic code pointers:

| Slot | Pointer | Target |
|---|---|---|
| 0 | FF 1E E9 | Y800 FORMAT descriptor |
| 1 | FF 1E 95 | FRAME descriptor: ID 1, 1280×960 |
| 2 | FF 1E 41 | FRAME descriptor: ID 2, 720×480 |
| 3 | FF 1E BF | FRAME descriptor: ID 4, 640×480 |
| 4 | FF 1F 21 | Color descriptor |
| 5 | FF 1F 27 | Endpoint descriptor |

The old code loads slot 0 and treats that FORMAT descriptor as a base for
contiguous, 42-byte FRAME descriptors. It also remaps frame ID 4 to ordinal 5,
a legacy assumption inconsistent with this image's actual frame-pointer table.
For frame 2 it reads width 0x719B (29083) and height 0x0108 (264) from unrelated
descriptor bytes. Its width divided by four is written to an 8-bit bridge
register: the low byte corresponds to 408 pixels. **408×264 = 107712**, matching
the repeated image byte count. This explains the numeric match; the full
physical interpretation of the bridge's additional mode bits is not documented.

More decisively, executing the original clock arithmetic with those dimensions
and interval 666667 produces **7,227,990 Hz**, exactly matching the independently
saved live GET_CUR clock from the earlier ROI-only experiment. This agreement
is independent of candidate behavior and checks the code mapping and arithmetic.

Routine 2B0B uses an effective horizontal line length of 1280+370=1650 clocks.
Its integer calculation is equivalent for the tested values to:

    clock = ((100000000 // negotiated_interval) * 1650 * (height + 30)) // 10

This explains why the known 12-MHz / 720×480 helper produces about 14.26 fps,
and the 24-MHz / 1280×960 helper about 14.69 fps. The firmware's intermediate
integer division causes its computed clock to differ slightly from exact
floating-point requested-fps arithmetic.

## Candidate implementation

File: `neximage-eeprom-uvc-roi-lookup-candidate.bin` in repository root.
Length: 32768 bytes.
SHA-256: `e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6`.

Base is the exact currently working descriptor-patched image:
`neximage-eeprom-format-index-experimental.bin`, SHA-256
`a2fe7b95f855dabe6451c1c378ea238763b089f493f97800271c5c856582319c`.
The original backup is independently hash-checked as
`743c32526036dd6600ee0e40596eea8df8264af6f0b3bdf4adfaec33bf4f6dc9`.
The generator verifies that the base differs from that original only at
1F0C 01→02 and 1F34 33→4F.

Replacement logic:

1. Accept frame IDs 1, 2, 4; reject other IDs before dereferencing the table.
2. Convert IDs 1,2,4 to pointer slots 1,2,3.
3. Read the frame pointer from 32C9 + 3×slot.
4. Read little-endian wWidth/wHeight at frame offsets 5/7 and store them in
   the existing big-endian indirect-RAM slots 81–82 and 9D–9E.
5. Jump to the original continuation at 1940, retaining its origin reset,
   interval negotiation, and deferred apply behavior.

The code is replaced **in place**, with no new code cave, relocation, load-size
extension, or upper EEPROM use. The new instructions plus rejection path occupy
74 bytes; the remaining three bytes are NOPs and are not on the normal path.
The 77-byte block is CPU 18F3–193F / EEPROM **18F7–1943 inclusive**.
Exactly **76 individual byte values differ** within that block. There are
**78 changed bytes relative to the untouched original**, including the two
already-applied descriptor corrections.

Every changed byte, before and after, is recorded in
`roi-candidate-manifest.json`, including both working-backup and original-backup
comparisons. `roi-candidate.asm` gives an addressed instruction listing.
All descriptor data, device identity, flags, code outside the one block, and
both existing corrections are preserved byte-for-byte.

A raw scan found no outside absolute call/jump into the replaced block after
excluding the confirmed sensor-sequencer constant table 0D21–0F60. The raw
12 19 17 bytes at 0D5D are part of that sensor data, not an LCALL. This check
is not a proof against every possible indirect reference or undocumented path.

## Offline validation

The disassembler opcode definitions are vendored from disasm51 1.0.2
(Apache-2.0): https://github.com/OlekMazur/disasm51.
`disassemble.py` adds explicit CPU and EEPROM addresses. Sequential listings
are not themselves proof of code reachability.

`emulator.py` is a small MCS-51 interpreter, separating direct SFRs from upper
indirect RAM, maintaining banked registers, stack, carry/overflow/auxiliary
carry, bit addressing and accumulator parity. The actual firmware EP0 receive
and transmit routines execute against a modeled FIFO and ready flags. Sensor
I2C, PLL work, sensor sequencer reset and exposure-update hardware are stubbed
where applicable. It does **not** model USB bus timing, real PLL lock, sensor
streaming, or interrupts; passing these tests is not hardware qualification.

`test_roi_candidate.py` checks:

* SHA-256, complete image length, all changed-byte boundaries and preservation
  of both existing descriptor fixes.
* Upper-RAM/SFR separation, MOV direct source/destination order, and stack return.
* The original firmware's 32-bit multiply/divide routines in 80 randomized
  arithmetic cases against independent Python arithmetic.
* The original failing mode's exact 7,227,990-Hz clock and 107,712-byte match.
* All local replacement branches land on instructions or the original continuation.
* All 253 unsupported frame IDs reject without dimension-table access or setting
  a new pending-apply flag. This tests an initially clear pending flag; concurrent
  invalid requests during an earlier pending apply are not modeled.
* All 12 advertised size/interval requests: correct geometry, unchanged timing
  negotiation, pending-apply set, and computed clocks within the device's
  advertised 12–41-MHz range.
* Real existing ROI writers for all three sizes: correct sensor X/Y starts and
  ends and frame-line length; physical I2C transaction is stubbed.
* Real existing deferred-apply block for all three sizes, through pending-flag
  clearing; peripheral-specific work and unrelated subsequent tasks are stubbed.
* Real GET_CUR response construction and EP0 transmit for all three frame IDs.

Results: `offline-validation.json` and `offline-validation.txt`.

Reproduce, from repository root:

    python3 diagnostics/firmware-re/build_roi_candidate.py
    python3 diagnostics/firmware-re/test_roi_candidate.py

These programs never import USB libraries and never open the camera.

## Predicted behavior and limits

For 15-fps requests, the existing rate negotiation predicts:

| Frame | Dimensions | Returned interval | Computed clock | Approximate sensor fps |
|---|---|---|---|---|
| 1 | 1280×960 | 1333333 | 12251250 Hz | 7.5 |
| 2 | 720×480 | 666667 | 12538350 Hz | 14.9 |
| 4 | 640×480 | 666667 | 12538350 Hz | 14.9 |

The geometry and clock should then be applied automatically by the already
present deferred handler, without a host initialization helper. That is a
prediction, not a measured result for this candidate.

This intentionally leaves the legacy rate tables unchanged. Full-resolution
requests still negotiate 7.5 fps despite their descriptor's faster list; some
640×480 requests also negotiate rates absent from their descriptor. The actual
sensor/PLL may approximate the computed clocks. This candidate does not claim
accurate support for all advertised rates or complete UVC conformance.

The camera still identifies its usable format as GREY while producing Bayer
pixels. This candidate does not add proper GRBG frame descriptors or repair the
remaining streaming-header counts and lengths. First-frame transitions can
still be erroneous; the success criterion is sustained full frames without
ERROR after settling, including reopen and cold reconnect tests.

## Integrity and recovery assessment

This is executable code, with greater risk than the previous descriptor edits.
A defect could hang UVC probing or sensor setup, and may interfere with USB
control traffic needed for rollback. The image's checksum/boot verification
scheme and external recovery hardware have not been established. The prior
successful descriptor edits do not prove code changes are safe. An interrupted
multi-byte write could leave a mixed, nonworking program.

No boot vectors, mode flag, PID, serial, calibration area, or image-size prefix
are changed. Staying inside an existing block avoids the unverified assumptions
that extra EEPROM space would be loaded or executable. The 76 changed-byte
count does not mean 76 programming transactions are needed.

`proposed-write-plan.json` records a **nonexecuted** page-bounded plan for the
77-byte block: 9 bytes at 18F7, 32 at 1900, 32 at 1920, and 4 at 1940. Splitting
on 32-byte boundaries avoids assuming that arbitrary unaligned 32-byte writes
can cross EEPROM pages safely. The manifest includes old and new data for each
transaction. This is not an executable write tool or write authorization.

If separately authorized to test later:

1. Verify camera serial and full live 32-KiB image exactly equals base SHA a2fe…;
   stop if anything differs. Keep that working image as the rollback target.
2. Program only the listed ranges, with full readback verification against the
   candidate before reconnecting. Do not assume an empty completion reply
   means failure or success; the previous one-byte transaction returned an
   empty completion but was verified successful by two full reads.
3. Cold reconnect. Check enumeration and full EEPROM integrity. Test plain
   stock v4l2-ctl **without** the helper at 720×480/15 first, then native mode
   and 640×480. Check buffer ERROR flags, exact image sizes and actual timing.
   Repeat stream stop/start and a physical reconnect before declaring success.
4. If rollback is needed and vendor access works, restore exactly the saved
   77-byte block and verify the full image equals base SHA a2fe… before cycling.
   Preserve 1F0C=02 and 1F34=4F: do not restore the untouched original wholesale.
5. If USB control service no longer works, software recovery is not guaranteed.
   External EEPROM programming may be required and has not been tested.

No persistent hardware operation is part of this offline work.

## Approved programming result

Serial 28414934, bus 1/device 57. Full pre-write image exactly matched the working
a2fe7b95f855dabe6451c1c378ea238763b089f493f97800271c5c856582319c backup.
Exactly the four page-bounded requests in proposed-write-plan.json were sent:
18F7/9 bytes, 1900/32 bytes, 1920/32 bytes, 1940/4 bytes. Completion lengths
were respectively 1,0,0,0; no retry or extra programming request was made.
Two complete readbacks matched candidate SHA
e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6 exactly.
Only the approved 77-byte range was touched (76 differing values); both descriptor
fixes remain intact. See roi-write-result.json and the before/after full images.

The camera must be physically reconnected to load the new executable image.
After reconnect, validate_without_helper.py tests four ordinary v4l2-ctl captures
(720, native, 640, and 720 reopened), without private controls or USB-library use.
Its validation logs must pass before the firmware-side repair is called working.

## Cold-reconnect hardware validation — PASS

After the physical reconnect, the camera enumerated as 199e:8308, serial
28414934, bus 1/device 58. Only stock v4l2-ctl was used: no private sensor
controls, USB-library initialization, kernel changes, or additional EEPROM writes.

| Test | Valid saved frames | Image bytes/frame | Measured fps | Startup error buffers |
|---|---|---|---|---|
| 720×480 after reconnect | 10 | 345600 | 14.9023 | 0 |
| 1280×960 mode change | 10 | 1228800 | 7.5001 | 1 |
| 640×480 mode change | 10 | 307200 | 14.9018 | 1 |
| 720×480 reopened | 10 | 345600 | 14.9019 | 1 |

Every saved frame was dequeued without V4L2_BUF_FLAG_ERROR. v4l2-ctl discarded
the single transitional error buffer on the three mode-change tests. Output file
sizes exactly matched ten full frames. All 40 valid frames and logs are in
validation-cold1/; results.json records the exact commands and measurements.

The firmware-side ROI/clock correction is therefore demonstrated on this camera.
It does not require the earlier initialize_sensor.py / capture_v4l2.py helpers.
Select GREY, whose bytes remain the raw Bayer mosaic. Example from repository
root, using a new destination filename:

    v4l2-ctl -d /dev/video0 --set-fmt-video=width=720,height=480,pixelformat=GREY --set-parm=15 --stream-mmap=4 --stream-count=30 --stream-to=capture.raw

The legacy frame-rate table and Bayer labelling limitations described above
remain. Native resolution still negotiates/measures 7.5 fps. Individual third-
party applications have not been tested. Camera-related kernel status-endpoint
overflow warnings (-75) remain visible around probing; they did not prevent
these validated image captures and were not independently repaired here.

A copy of the verified actual post-write EEPROM readback is preserved as
neximage-eeprom-working-uvc-autoinit.bin (repository root), SHA-256
e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6.
The untouched original and the earlier descriptor-only working backup remain
available. No post-reconnect raw-USB permission grant was required for these
V4L2-only tests.
