# Celestron NexImage Burst C — Linux UVC firmware repair

**20 October 2026 update:** the camera now advertises its usable stream as
**GRBG (8-bit Bayer)** following an additional eight-byte descriptor GUID swap.
All four post-reconnect capture tests passed (40 complete frames), and the owner
confirmed correct colours after setting the astronomy application's Bayer Pattern
to **GRBG**. See the [GRBG repair record](diagnostics/firmware-re/GRBG-PROPOSAL.md).
The current verified image is [neximage-eeprom-grbg-candidate.bin](neximage-eeprom-grbg-candidate.bin),
SHA-256 `2633c2d87526c1372bf704fd9de8b40a44c0b53160ebd0dd65a36bb91887d2d2`.
The three-fix history and older image below describe the 19 October baseline.

A working, camera-side repair for the **Celestron NexImage Burst C** USB astronomy camera (The Imaging Source hardware). This project documents how its built-in UVC mode was repaired so the camera can capture through the **stock Linux `uvcvideo` driver**, without an out-of-tree driver, kernel patch, or per-session sensor-initialization helper.

**Status: working on one tested camera, not a universal firmware release.** The patched EEPROM image was read back from that camera after programming and validated with real image captures. Compatibility with other hardware revisions or firmware versions has **not** been established.

> [!CAUTION]
> **Do not blindly flash the included EEPROM image to another camera.** It is a full, **device-specific 32 KiB EEPROM dump**, not a generic firmware updater package. It can contain device-specific settings and identity information. Flashing it to a different unit may overwrite those settings or make the camera unresponsive. A bad executable-code patch can also prevent USB enumeration, making software recovery impossible. The original investigation did **not** test external EEPROM recovery.
>
> The included image and writeup are provided for research and reproducibility, **not as a validated one-click upgrade for other cameras**. Back up *your own camera's* EEPROM and verify its hardware, firmware and bytes before adapting the changes.

## The result

After the repair, the camera enumerates as `199e:8308` and records complete Bayer frames via V4L2. These are measured results from the repaired camera:

| Capture mode | Valid frames saved | Bytes per frame | Measured rate |
|---|---:|---:|---:|
| 720 × 480 | 10 | 345,600 | 14.90 fps |
| 1280 × 960 | 10 | 1,228,800 | 7.50 fps |
| 640 × 480 | 10 | 307,200 | 14.90 fps |
| 720 × 480 (reopened) | 10 | 345,600 | 14.90 fps |

The test sequence included a physical USB reconnect and several resolution changes. All 40 saved images were complete and lacked `V4L2_BUF_FLAG_ERROR`. Mode changes sometimes produced one transitional error buffer, which was discarded before valid frames were saved. The owner also confirmed visible image output.

## The three fixes

The camera already contains a UVC operating mode, but its firmware has multiple defects that prevent ordinary capture on current Linux kernels. Repairing it required:

| EEPROM address | Change | Why it matters |
|---|---|---|
| `0x1F34` | `33 → 4F` | Corrects the USB configuration's advertised length from 307 to 335 bytes, so Linux sees bulk video endpoint `0x82`. |
| `0x1F0C` | `01 → 02` | Gives the frameless GRBG descriptor its own format index instead of colliding with the usable GREY/Y800 format. |
| `0x18F7–0x1943` | 77-byte 8051 code replacement (76 bytes different) | Fixes firmware frame-descriptor lookup so sensor ROI and clock initialization use the selected frame's actual dimensions. |

The final image differs from the preserved pre-repair EEPROM backup at **78 byte positions**. The third fix was necessary: after the first two, streaming could be made to work only with additional host-side sensor initialization.

One especially revealing symptom was a repeatable **107,712-byte** invalid frame. Reverse engineering traced it to incorrect firmware-derived geometry: `408 × 264 = 107,712`. The same bad lookup reproduced the observed 7,227,990 Hz clock. Fixing the lookup eliminated the need for an initialization helper.

For the USB descriptor investigation, reverse engineering, patch rationale, code locations, validation methodology, and recovery considerations, see **[NEXIMAGE-BURST-C-UVC-REPAIR.md](NEXIMAGE-BURST-C-UVC-REPAIR.md)**.

## Using a repaired camera on Linux

Once your camera **has already been repaired**, connect it and check that the standard UVC driver recognizes it:

```bash
lsusb -d 199e:8308
v4l2-ctl --list-devices
v4l2-ctl -d /dev/video0 --list-formats-ext
```

Capture 30 frames at 720 × 480 (substitute the correct `/dev/video*` node for your system):

```bash
v4l2-ctl -d /dev/video0 \
  --set-fmt-video=width=720,height=480,pixelformat=GRBG \
  --set-parm=15 \
  --stream-mmap=4 --stream-count=30 \
  --stream-to=capture.raw
```

For native 1280 × 960:

```bash
v4l2-ctl -d /dev/video0 \
  --set-fmt-video=width=1280,height=960,pixelformat=GRBG \
  --set-parm=10 \
  --stream-mmap=4 --stream-count=30 \
  --stream-to=capture-native.raw
```

**Important:** select `GRBG` in the V4L2 API and set the application's Bayer Pattern to **GRBG** for colour output. The image bytes are raw Bayer mosaic data. The native-resolution example negotiates about **7.5 fps**, not 10 fps. The older 19 October image still requires `GREY` capture.

## Hardware and image identification

The repair was developed and verified on this specific device:

| Property | Tested unit |
|---|---|
| Camera | Celestron NexImage Burst C |
| Sensor | ON Semiconductor / Aptina AR0132AT, 1280 × 960 |
| Original proprietary-mode USB ID | `199e:8208` |
| UVC-mode USB ID | `199e:8308` |
| Reported manufacturer firmware version | `146` |
| EEPROM | 32,768 bytes |
| Interface | USB 2.0 High Speed (480 Mbps) |
| Tested Linux host | Ubuntu, kernel `7.0.0-38-generic` |

**SHA-256 of the 19 October verified working EEPROM image (before the GRBG update):**

```text
e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6
```

The pre-repair backup (already switched into UVC mode) had SHA-256:

```text
743c32526036dd6600ee0e40596eea8df8264af6f0b3bdf4adfaec33bf4f6dc9
```

Use the hash to verify the released binary matches the tested image. **A matching hash is not proof that the image is safe for a different camera.**

## Files

- **[`NEXIMAGE-BURST-C-UVC-REPAIR.md`](NEXIMAGE-BURST-C-UVC-REPAIR.md)** — detailed investigation, findings, descriptor issues, reverse engineering, validation and rollback considerations.
- **[`neximage-eeprom-working-uvc-autoinit.bin`](neximage-eeprom-working-uvc-autoinit.bin)** — final working 32 KiB EEPROM readback from the tested device. Verify its SHA-256 against the hash above before using it for analysis.

The full report also references diagnostic scripts, logs, manifests, and intermediate images from the investigation. Those references require the corresponding files to be included if you want all links and experiments to be reproducible.

## Known limitations

- The firmware is **not fully UVC-specification-compliant**. Some format counts, class-specific descriptor lengths and bitrate fields remain inconsistent.
- The unused format entry still has no frame descriptors. In the current image it is labelled GREY; all usable sizes are exposed through GRBG.
- Reported frame-rate options are imperfect. Not every advertised mode or rate was tested.
- The USB status interrupt endpoint can still report `-75` (`EOVERFLOW`) warnings. The image stream worked despite these; the notification issue was not fully resolved.
- Long-duration stability, application compatibility beyond the demonstrated V4L2 tests, and other cameras or firmware revisions are unverified.

## Background and credits

The Imaging Source's [`tcam-firmware-update`](https://github.com/TheImagingSource/tcam-firmware-update) project provided the EEPROM-access protocol and UVC-mode switch. The [Open Astro Project](https://github.com/openastroproject/openastro) EUVC driver helped identify the camera's additional sensor controls. Linux `uvcvideo` source and USB captures were used to diagnose descriptor and frame-handling failures.

The repair was developed through hands-on testing, firmware analysis and an AI-assisted investigation, with EEPROM writes approved and verified against complete camera readbacks. Consult the [technical report](NEXIMAGE-BURST-C-UVC-REPAIR.md) for the evidence trail.

**If you're working on another NexImage Burst C:** please compare its firmware and EEPROM layout before attempting any patch. A safe reusable patching method would need to preserve each camera's unique data and validate the exact original bytes rather than distributing a full EEPROM image as a drop-in replacement.
