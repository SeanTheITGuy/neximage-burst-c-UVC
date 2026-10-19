#!/usr/bin/env python3
"""Build an offline, UNFLASHED UVC frame-lookup code correction.
The existing firmware's deferred handler already applies ROI and pixel clock.
Only its erroneous dimension lookup is replaced, in-place; no code is relocated.
"""
from pathlib import Path
from hashlib import sha256
import json
ROOT=Path(__file__).resolve().parents[2]
BASE_SHA='a2fe7b95f855dabe6451c1c378ea238763b089f493f97800271c5c856582319c'
START,END=0x18f3,0x1940
class Patch:
    def __init__(self):self.b=bytearray();self.labels={};self.fixups=[]
    def emit(self,h):self.b.extend(bytes.fromhex(h))
    def label(self,name):self.labels[name]=START+len(self.b)
    def branch(self,prefix,label):
        self.emit(prefix);self.fixups.append((len(self.b),label));self.b.append(0)
    def finish(self):
        for index,label in self.fixups:
            distance=self.labels[label]-(START+index+1)
            assert -128<=distance<=127
            self.b[index]=distance&255
        assert len(self.b)<=END-START
        self.b.extend(bytes(END-START-len(self.b)))
        return bytes(self.b)
def generate():
    old=(ROOT/'neximage-eeprom-format-index-experimental.bin').read_bytes()
    assert len(old)==32768 and sha256(old).hexdigest()==BASE_SHA
    assert old[START+4:START+10]==bytes.fromhex('9032c9e493fb')
    p=Patch()
    p.emit('7896e6')                  # A = negotiated frame ID
    p.branch('b401','try2');p.branch('80','lookup')
    p.label('try2');p.branch('b402','try4');p.branch('80','lookup')
    p.label('try4');p.branch('b404','reject');p.emit('14') # frame 4 -> table slot 3
    p.label('lookup')
    p.emit('75f003a424c9f582e5f03432f583') # DPTR = 32c9 + 3 * slot
    p.emit('a3e493faa3e493f5828a83')   # DPTR = code pointer in that table entry
    p.emit('740593ff7406937881f608a607') # frame width LE -> IRAM 81:82 BE
    p.emit('740793ff740893789df608a607') # frame height LE -> IRAM 9d:9e BE
    p.emit('021940')                  # resume original origin reset, timing and apply
    p.label('reject');p.emit('c2c622') # stall unsupported frame ID, return
    block=p.finish()
    new=bytearray(old);new[START+4:END+4]=block
    assert len(new)==len(old)
    assert new[0x1f0c]==2 and new[0x1f34]==0x4f
    differences=[{'eeprom_offset':f'0x{i:04x}','code_address':f'0x{i-4:04x}','before':f'{a:02x}','after':f'{b:02x}'} for i,(a,b) in enumerate(zip(old,new)) if a!=b]
    assert differences and all(START+4<=int(d['eeprom_offset'],16)<END+4 for d in differences)
    # No absolute LCALL/LJMP from outside the replaced block targets its interior.
    code=old[4:]
    external=[]
    for i in range(len(code)-2):
        if START<=i<END:continue
        # Confirmed AR0132 sequencer DATA, consumed as 0x120 16-bit
        # words by routine 0x2611; raw 12 19 xx there is not an LCALL.
        if 0x0d21<=i<0x0f61:continue
        if code[i] in (2,0x12) and START<int.from_bytes(code[i+1:i+3],'big')<END:external.append(i)
    assert not external,external
    for index,expected in [(1,(1280,960)),(2,(720,480)),(3,(640,480))]:
        entry=0x32c9+index*3
        assert code[entry]==255
        address=int.from_bytes(code[entry+1:entry+3],'big')
        assert code[address:address+3]==bytes.fromhex('2a2411')
        assert (int.from_bytes(code[address+5:address+7],'little'),int.from_bytes(code[address+7:address+9],'little'))==expected
    target=ROOT/'neximage-eeprom-uvc-roi-lookup-candidate.bin'
    if target.exists():assert target.read_bytes()==new
    else:target.write_bytes(new)
    original=(ROOT/'neximage-eeprom-original.bin').read_bytes()
    assert sha256(original).hexdigest()=='743c32526036dd6600ee0e40596eea8df8264af6f0b3bdf4adfaec33bf4f6dc9'
    assert [(i,a,b) for i,(a,b) in enumerate(zip(original,old)) if a!=b]==[(0x1f0c,1,2),(0x1f34,0x33,0x4f)]
    manifest={'status':'OFFLINE ONLY: NOT WRITTEN TO CAMERA; peripheral/timing behavior not validated on hardware', 'base_sha256':BASE_SHA,'candidate_file':target.name,'candidate_sha256':sha256(new).hexdigest(),'length':len(new),'replaced_code_range_inclusive':['0x18f3','0x193f'],'replaced_eeprom_range_inclusive':['0x18f7','0x1943'],'block_length':len(block),'changed_byte_count':len(differences),'changes_from_working_backup':differences,'all_changes_from_original':[{'eeprom_offset':f'0x{i:04x}','before':f'{a:02x}','after':f'{b:02x}'} for i,(a,b) in enumerate(zip(original,new)) if a!=b], 'labels':{k:f'0x{v:04x}' for k,v in p.labels.items()}, 'rollback':'Restore the replaced 77-byte EEPROM block from the verified working a2fe... image; verify all 32768 bytes match base_sha256 before power cycling. Software recovery depends on successful enumeration; external EEPROM recovery is untested.'}
    (ROOT/'diagnostics/firmware-re/roi-candidate-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print(target.name,sha256(new).hexdigest(),len(differences),'changed bytes; 77-byte replacement block; NOT APPLIED')
    return bytes(new)
if __name__=='__main__':generate()
