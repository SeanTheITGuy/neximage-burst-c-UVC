#!/usr/bin/env python3
"""Offline descriptor/backup audit. Never opens a USB device or writes EEPROM."""
from pathlib import Path
from hashlib import sha256
import json
ROOT = Path(__file__).resolve().parent.parent
original = (ROOT/'neximage-eeprom-original.bin').read_bytes()
patched = (ROOT/'neximage-eeprom-after-attempt.bin').read_bytes()
assert sha256(original).hexdigest() == '743c32526036dd6600ee0e40596eea8df8264af6f0b3bdf4adfaec33bf4f6dc9'
assert sha256(patched).hexdigest() == 'cdf65664e3cad5640b9923dfa370e1ab9fc100b4ed6ed908587daddd2bb2584a'
assert len(original) == len(patched) == 32768
diffs = [(i,a,b) for i,(a,b) in enumerate(zip(original,patched)) if a != b]
assert diffs == [(0x1f34,0x33,0x4f)]
print('Verified backups: exactly one difference, 0x1f34: 33 -> 4f')
b = (ROOT/'diagnostics/live-descriptors.bin').read_bytes()
def le(x):return int.from_bytes(x,'little')
interface = None
formats = []
header = None
cs_total = 0
o = 0
while o < len(b):
    n = b[o]
    assert n >= 2 and o+n <= len(b)
    d = b[o:o+n]
    if d[1] == 4:interface = d[6]
    if interface == 2 and d[1] == 0x24:
        cs_total += n
        if d[2] == 1:
            header={'length':n,'formats':d[3],'total_length':le(d[4:6]),'control_size':d[12], 'required_length':13+d[3]*d[12]}
        if d[2] == 0x10:
            formats.append({'index':d[3],'declared_frames':d[4],'guid':d[5:21].hex(),'bits_per_pixel':d[21],'variable_size':d[27],'frames':[]})
        if d[2] == 0x11:
            assert formats
            f={'index':d[3],'width':le(d[5:7]),'height':le(d[7:9]),'min_bitrate':le(d[9:13]),'max_bitrate':le(d[13:17]),'default_interval':le(d[17:21]),'stride':le(d[22:26]),'intervals':[le(d[i:i+4]) for i in range(26,n,4)]}
            f['expected_bytes'] = f['stride']*f['height']
            formats[-1]['frames'].append(f)
    o += n
print(json.dumps({'streaming_header':header,'actual_cs_total':cs_total,'formats':formats},indent=2))
