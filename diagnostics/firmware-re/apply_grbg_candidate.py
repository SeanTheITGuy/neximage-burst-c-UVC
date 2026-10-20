#!/usr/bin/env python3
"""Guarded application of the separately approved eight-byte GRBG descriptor patch.
Dry-run unless --write is explicit. Never changes operating mode or resets USB.
"""
import argparse,hashlib,json,sys,time
from pathlib import Path
import usb.core,usb.util
ROOT=Path(__file__).resolve().parents[2]
BASE_SHA='e18911b387db7ca7975535facc8d0c5898decf94cb64e5c694611abb8895d7d6'
NEW_SHA='2633c2d87526c1372bf704fd9de8b40a44c0b53160ebd0dd65a36bb91887d2d2'
ORIGINAL_SHA='743c32526036dd6600ee0e40596eea8df8264af6f0b3bdf4adfaec33bf4f6dc9'
def ensure(condition,message):
    if not condition:raise RuntimeError(message)
def digest(data):return hashlib.sha256(data).hexdigest()
def preserve(path,data):
    if path.exists():ensure(path.read_bytes()==data,f'Existing snapshot differs: {path}')
    else:
        with path.open('xb') as f:f.write(data)
def read_eeprom(dev):
    ensure(dev.ctrl_transfer(0x40,3,0,0xa1,b'\0\0',timeout=10000)==2,'Read address selection failed')
    time.sleep(.01)
    result=bytearray()
    for address in range(0,32768,64):
        b=bytes(dev.ctrl_transfer(0xc0,2,0,0xa0,64,timeout=10000))
        ensure(len(b)==64,f'Short read at {address:#x}')
        result.extend(b)
    return bytes(result)
def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('--write',action='store_true');args=parser.parse_args()
    base=(ROOT/'neximage-eeprom-working-uvc-autoinit.bin').read_bytes()
    candidate=(ROOT/'neximage-eeprom-grbg-candidate.bin').read_bytes()
    ensure(len(base)==len(candidate)==32768,'Image length mismatch')
    ensure(digest(base)==BASE_SHA and digest(candidate)==NEW_SHA,'Image hash mismatch')
    expected=bytearray(base)
    ensure(base[0x1ef2:0x1ef6]==b'Y800' and base[0x1f0e:0x1f12]==b'GRBG','Wrong descriptor bytes')
    expected[0x1ef2:0x1ef6]=b'GRBG'
    expected[0x1f0e:0x1f12]=b'Y800'
    ensure(candidate==expected,'Changes outside approved GUID swap')
    chunks=[(0x1ef2,4),(0x1f0e,4)]
    for address,n in chunks:
        ensure(address//32==(address+n-1)//32,'Page crossing')
    dev=usb.core.find(idVendor=0x199e,idProduct=0x8308)
    ensure(dev is not None,'UVC camera not found')
    journal={'status':'PREPARING','serial':'28414934','base_sha256':BASE_SHA,'candidate_sha256':NEW_SHA,'transactions':[]}
    journal_path=ROOT/'diagnostics/firmware-re/grbg-write-result.json'
    def save():journal_path.write_text(json.dumps(journal,indent=2)+'\n')
    try:
        serial=usb.util.get_string(dev,dev.iSerialNumber).rstrip('\0')
        ensure(serial=='28414934',f'Wrong serial {serial!r}')
        print(f'Camera {serial}, bus {dev.bus}, address {dev.address}',flush=True)
        before=read_eeprom(dev)
        ensure(before==base,'Live EEPROM is not the exact verified working image; refusing')
        print(f'Full 32-KiB pre-write match: {digest(before)}',flush=True)
        if not args.write:
            print('DRY RUN: complete preflight passed; no programming requests sent.');return
        preserve(ROOT/'diagnostics/firmware-re/eeprom-before-grbg-write.bin',before)
        journal['status']='PROGRAMMING';save()
        for address,n in chunks:
            entry={'address':f'0x{address:04x}','length':n,'status':'STARTED'}
            journal['transactions'].append(entry);save()
            data=address.to_bytes(2,'big')+candidate[address:address+n]
            count=dev.ctrl_transfer(0x40,2,0,0xa1,data,timeout=10000)
            entry['out_count']=count;save()
            ensure(count==len(data),f'Programming OUT short at {address:#x}; do not disconnect')
            completion=bytes(dev.ctrl_transfer(0xc0,2,0,0xa0,1,timeout=10000))
            entry['completion_length']=len(completion)
            ensure(len(completion) in (0,1),'Unexpected completion length')
            time.sleep(.02)
            entry['status']='SENT';save()
            print(f'Programmed {address:#06x}: {n} data bytes, completion length {len(completion)}',flush=True)
        journal['status']='VERIFYING';save()
        for attempt in range(2):
            after=read_eeprom(dev)
            preserve(ROOT/f'diagnostics/firmware-re/eeprom-after-grbg-write-{attempt}.bin',after)
            ensure(after==candidate,f'Full verification {attempt+1} FAILED; do not disconnect; inspect snapshot')
            print(f'Full 32-KiB verification {attempt+1}: {digest(after)}',flush=True)
        journal['status']='APPLIED AND VERIFIED TWICE; awaiting cold reconnect and hardware capture tests'
        journal['full_read_verifications']=2;journal['changed_byte_count']=8
        journal['existing_descriptor_corrections']={'0x1f0c':'02','0x1f34':'4f'};save()
        print('SUCCESS. Only approved GUID bytes changed; both descriptor fixes preserved.',flush=True)
    except BaseException as error:
        if args.write and journal['transactions']:
            journal['status']='INTERRUPTED OR FAILED — DO NOT DISCONNECT UNTIL FULL READBACK REVIEW'
            journal['error']=str(error);save()
            print(journal['status'],file=sys.stderr,flush=True)
        raise
    finally:usb.util.dispose_resources(dev)
if __name__=='__main__':main()
