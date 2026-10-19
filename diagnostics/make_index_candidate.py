#!/usr/bin/env python3
"""Generate an EXPERIMENTAL descriptor-only image; never opens the camera.
This isolates duplicate format IDs. It does not fix ROI/clock initialization.
"""
from pathlib import Path
from hashlib import sha256
import json
root=Path(__file__).resolve().parent.parent
original=(root/'neximage-eeprom-original.bin').read_bytes()
current=(root/'neximage-eeprom-after-attempt.bin').read_bytes()
assert len(original)==len(current)==32768
assert sha256(original).hexdigest()=='743c32526036dd6600ee0e40596eea8df8264af6f0b3bdf4adfaec33bf4f6dc9'
assert sha256(current).hexdigest()=='cdf65664e3cad5640b9923dfa370e1ab9fc100b4ed6ed908587daddd2bb2584a'
assert [(i,a,b) for i,(a,b) in enumerate(zip(original,current)) if a!=b]==[(0x1f34,0x33,0x4f)]
addr=0x1f0c
assert current[addr-3:addr+25]==bytes.fromhex('1c241001044752424700001000800000aa00389b7108011009860000')
candidate=bytearray(current);candidate[addr]=2
assert candidate[0x1f34]==0x4f
changes=[{'offset':f'0x{i:04x}','old':f'{a:02x}','new':f'{b:02x}'} for i,(a,b) in enumerate(zip(current,candidate)) if a!=b]
assert changes==[{'offset':'0x1f0c','old':'01','new':'02'}]
name=root/'neximage-eeprom-format-index-experimental.bin'
if name.exists():assert name.read_bytes()==candidate
else:name.write_bytes(candidate)
manifest={'file':name.name,'sha256':sha256(candidate).hexdigest(),'changes_from_corrected_backup':changes,'changes_from_original':[{'offset':f'0x{i:04x}','old':f'{a:02x}','new':f'{b:02x}'} for i,(a,b) in enumerate(zip(original,candidate)) if a!=b], 'status':'NOT APPLIED. Isolates duplicate format-index issue; does not fix ROI/clock or all UVC descriptor inconsistencies.', 'rollback':'Restore only EEPROM 0x1f0c to 01 from corrected backup, retaining 0x1f34=4f. Verify all 32768 bytes equal corrected backup, then reconnect.'}
(root/'diagnostics/index-candidate.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps(manifest,indent=2))
