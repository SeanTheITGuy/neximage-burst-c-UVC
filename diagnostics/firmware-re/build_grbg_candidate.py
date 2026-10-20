#!/usr/bin/env python3
"""Build and check a descriptor-only GRBG candidate. Never accesses USB."""
from hashlib import sha256
from pathlib import Path
import json
from check_control_path import exercise

ROOT = Path(__file__).resolve().parents[2]
BASE_SHA = 'e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6'


def main():
    base = (ROOT / 'neximage-eeprom-working-uvc-autoinit.bin').read_bytes()
    assert len(base) == 32768 and sha256(base).hexdigest() == BASE_SHA
    suffix = bytes.fromhex('00001000800000aa00389b71')
    for offset, index, name in [(0x1eed, 1, b'Y800'), (0x1f09, 2, b'GRBG')]:
        assert base[offset:offset + 5] == bytes([28, 36, 16, index, 4])
        assert base[offset + 5:offset + 21] == name + suffix
        assert base[offset + 21] == 8 and base[offset + 27] == 0
    candidate = bytearray(base)
    candidate[0x1ef2:0x1ef6] = b'GRBG'
    candidate[0x1f0e:0x1f12] = b'Y800'
    changes = [{'offset': f'0x{i:04x}', 'before': f'{a:02x}', 'after': f'{b:02x}'}
               for i, (a, b) in enumerate(zip(base, candidate)) if a != b]
    assert len(changes) == 8
    assert candidate[:0x1ef2] == base[:0x1ef2]
    assert candidate[0x1ef6:0x1f0e] == base[0x1ef6:0x1f0e]
    assert candidate[0x1f12:] == base[0x1f12:]
    # Execute the existing real firmware probe/commit geometry and clock paths.
    # Peripheral routines remain stubbed by the existing emulator harness.
    results = []
    code = base[4:]
    for slot, frame, dimensions in [(1, 1, (1280, 960)), (2, 2, (720, 480)), (3, 4, (640, 480))]:
        entry = 0x32c9 + 3 * slot
        ptr = int.from_bytes(code[entry + 1:entry + 3], 'big')
        desc = code[ptr:ptr + 42]
        assert desc[:4] == bytes([42, 36, 17, frame])
        assert (int.from_bytes(desc[5:7], 'little'), int.from_bytes(desc[7:9], 'little')) == dimensions
        for n in range(desc[21]):
            interval = int.from_bytes(desc[26 + 4*n:30 + 4*n], 'little')
            old = exercise(base, frame, interval)
            new = exercise(bytes(candidate), frame, interval)
            assert new == old
            assert (new['width'], new['height']) == dimensions
            results.append(new)
    target = ROOT / 'neximage-eeprom-grbg-candidate.bin'
    target.write_bytes(candidate)
    manifest = {
        'status': 'OFFLINE ONLY; NOT FLASHED; hardware and application behavior unverified',
        'base_sha256': BASE_SHA,
        'candidate_file': target.name,
        'candidate_sha256': sha256(candidate).hexdigest(),
        'changes': changes,
        'offline_control_path_comparisons': results,
        'proposed_writes': [
            {'offset': '0x1ef2', 'before': '59383030', 'after': '47524247'},
            {'offset': '0x1f0e', 'before': '47524247', 'after': '59383030'}],
        'rollback': 'Restore only the two four-byte ranges from the verified base; full readback must match base_sha256.'}
    (ROOT / 'diagnostics/firmware-re/grbg-candidate-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(json.dumps({'candidate': target.name, 'sha256': manifest['candidate_sha256'],
                      'changed_bytes': len(changes), 'matching_control_cases': len(results),
                      'status': manifest['status']}, indent=2))


if __name__ == '__main__':
    main()
