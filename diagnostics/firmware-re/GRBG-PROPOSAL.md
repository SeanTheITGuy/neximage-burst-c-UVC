# GRBG advertisement proposal — 20 October 2026

Status: **flashed with user authorization and verified on hardware**. Two full
EEPROM readbacks matched the candidate. After physical reconnect, stock V4L2
advertised and negotiated GRBG at all three resolutions.

## Hardware result

`validation-grbg-cold1/results.json` records four passing captures: 10 complete
frames each at 720×480, 1280×960, 640×480, then 720×480 reopened. All negotiated
GRBG. Rates were 14.90, 7.50, 14.90, and 14.90 fps. The first stream had zero
error buffers; each subsequent mode change had one discarded transitional error
buffer. All 40 saved frames had exact expected sizes and no ERROR flag.
No private initialization helper or kernel changes were used.

The frameless GREY entry remains enumerated, while all usable resolutions appear
under GRBG. The owner subsequently confirmed functional astronomy-application
output with correct colours after setting **Bayer Pattern = GRBG**. The application
name and resolution were not recorded, so this is not a separate optical phase
test of every mode. Programming evidence is in `grbg-write-result.json`.

Yesterday's repair fixed configuration length, duplicate format IDs, and the
firmware's frame-dimension lookup. It demonstrated complete Bayer frames without
a host initialization helper. The usable descriptor still identifies those
pixels as Y800 (V4L2 GREY). The earlier GRBG descriptor has no frames.

## Proposed change

Swap the GUID identities of the two existing format templates:

| EEPROM range | Current bytes | Candidate bytes | Meaning |
|---|---|---|---|
| `0x1EF2–0x1EF5` | `59 38 30 30` (Y800) | `47 52 42 47` (GRBG) | Label frame-bearing format index 1 as Bayer |
| `0x1F0E–0x1F11` | `47 52 42 47` (GRBG) | `59 38 30 30` (Y800) | Move the unused identity to frameless format index 2 |

Both 16-byte GUIDs have the same remaining 12 bytes. The descriptor lengths,
indices, 8-bit depth, fixed-size flag, frame descriptors, pointer tables, and
all executable code stay byte-identical. This preserves all three previous fixes.
Swapping both names avoids two descriptors reporting the same Bayer format.
Changing the empty GRBG index back to 1 would reintroduce yesterday's failure.

Linux v7.0 explicitly maps UVC_GUID_FORMAT_GRBG to V4L2_PIX_FMT_SGRBG8, whose
FourCC is `GRBG`. Its frame parser computes width × height × bits-per-pixel / 8
for fixed-size formats, so the expected frame sizes should remain unchanged.
Sources:

- https://github.com/torvalds/linux/blob/v7.0/drivers/media/common/uvc.c
- https://github.com/torvalds/linux/blob/v7.0/include/linux/usb/uvc.h
- https://github.com/torvalds/linux/blob/v7.0/drivers/media/usb/uvc/uvc_driver.c

This is a targeted Linux compatibility experiment, not a complete UVC descriptor
cleanup. The empty secondary format and the known header/count inconsistencies
remain; removing or reordering templates requires additional analysis of runtime
descriptor assembly. No firmware UVC version change is needed for this experiment.

## Offline evidence

Run from the repository root:

```bash
python3 diagnostics/firmware-re/build_grbg_candidate.py
```

The script never imports USB libraries or accesses the camera. It hash-checks the
verified working 32-KiB image, checks both format templates, limits all differences
to the eight listed bytes, and compares the original and candidate firmware's
emulated control/geometry/clock results for all 12 advertised size/interval cases.
All 12 matched, with correct dimensions. The existing emulator stubs peripheral
operations; this does not validate real descriptor enumeration or streaming.

Base SHA-256:
`e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6`

Candidate: `neximage-eeprom-grbg-candidate.bin`, SHA-256:
`2633c2d87526c1372bf704fd9de8b40a44c0b53160ebd0dd65a36bb91887d2d2`

`grbg-candidate-manifest.json` records every changed byte, two proposed writes,
rollback, and the control-path results. Neither four-byte write crosses a 32-byte
EEPROM page boundary. No programming utility is added by this proposal.

## Hardware validation for a later programming step

1. Read the entire live EEPROM and require an exact match to the base hash and
   the tested camera identity. Preserve that readback. Program only the two
   four-byte ranges; require two complete readbacks matching the candidate.
2. Physically disconnect and reconnect. Inspect live descriptors and
   `v4l2-ctl --list-formats-ext`. Require format index 1 to be GRBG with all three
   frame sizes, and no duplicate format indices. The old empty GREY entry may
   remain visible depending on driver behavior; it is not a capture mode.
3. Capture using `pixelformat=GRBG`, with no sensor helper, at 720×480, 1280×960,
   640×480, and 720×480 again. Require saved frames without ERROR, exact sizes
   345600/1228800/307200 bytes, and rates comparable to yesterday's 14.9/7.5 fps.
   Repeat after a cold reconnect. Check negotiated FourCC as well as enumeration.
4. Use a lit scene with known red and blue objects to verify the actual first
   two rows are GR/ BG in each mode. Existing GRBG firmware labelling is evidence
   of intent, not an independent optical phase measurement. Cropping by odd
   offsets or changing sensor mirror/flip can change Bayer phase.
5. Open the intended astronomy application's V4L2 backend. Require recognition
   as raw 8-bit GRBG, and test its debayer preview/recording settings. Correct
   advertisement enables Bayer-aware applications to identify the data; it
   cannot guarantee every application automatically enables colour conversion.

Example capture after a successful flash/reconnect (use the actual video node):

```bash
v4l2-ctl -d /dev/video0 \
  --set-fmt-video=width=720,height=480,pixelformat=GRBG \
  --set-parm=15 --stream-mmap=4 --stream-count=30 \
  --stream-to=capture-grbg.raw
```

Rollback, if USB access still works: restore only the two four-byte ranges from
the saved working base, require a full base-hash match, then reconnect. Preserve
yesterday's repairs; do not restore a pre-repair image. EEPROM programming and
power-loss risks still apply even though no executable code is changed.
