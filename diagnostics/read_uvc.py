#!/usr/bin/env python3
"""Read UVC controls and optionally inspect bulk data. No EEPROM write requests.
Temporarily releases kernel ownership; always attempts to restore it.
"""
import argparse, json, time
from pathlib import Path
import usb.core, usb.util
p=argparse.ArgumentParser(description=__doc__)
p.add_argument('--capture',action='store_true',help='Commit the current probe (volatile) and read endpoint 0x82')
p.add_argument('--roi',nargs=2,type=int,metavar=('WIDTH','HEIGHT'))
p.add_argument('--clock',type=int)
p.add_argument('--frame',type=int)
p.add_argument('--interval',type=int)
p.add_argument('--read-size',type=int,default=16384)
p.add_argument('--seconds',type=float,default=3)
p.add_argument('--prefix',default='current')
a=p.parse_args()
assert a.read_size > 0 and a.read_size % 512 == 0
assert 0 < a.seconds <= 10
assert a.prefix.replace('-', '').isalnum()
d=usb.core.find(idVendor=0x199e,idProduct=0x8308)
assert d is not None
assert usb.util.get_string(d,d.iSerialNumber).rstrip('\0')=='28414934'
claimed=False;detached=[]
try:
    for i in [1,0]:
        if d.is_kernel_driver_active(i):
            d.detach_kernel_driver(i);detached.append(i)
    usb.util.claim_interface(d,1);claimed=True
    usb.util.claim_interface(d,0)
    controls={}
    if a.frame is not None:
        probe=bytearray(d.ctrl_transfer(0xa1,0x81,0x100,1,26,timeout=2000))
        probe[0:4]=bytes([1,0,1,a.frame])
        if a.interval is not None:probe[4:8]=a.interval.to_bytes(4,'little')
        print('SET PROBE',probe.hex(' '),flush=True)
        d.ctrl_transfer(0x21,1,0x100,1,probe,timeout=2000)
    for req in [0x81,0x82,0x83,0x87]:
        for sel in [1,2]:
            try:
                b=bytes(d.ctrl_transfer(0xa1,req,sel<<8,1,26,timeout=2000))
                print(hex(req),sel,len(b),b.hex(' '),flush=True)
                controls[f'{req:02x}-{sel}']=b.hex()
            except usb.core.USBError as e:print(hex(req),sel,e,flush=True)
    Path(f'diagnostics/uvc-controls-{a.prefix}.json').write_text(json.dumps(controls,indent=2))
    if a.capture:
        probe=bytes(d.ctrl_transfer(0xa1,0x81,0x100,1,26,timeout=2000))
        print('COMMIT current probe',probe.hex(' '),flush=True)
        d.ctrl_transfer(0x21,1,0x200,1,probe,timeout=2000)
        if a.roi:
            width,height=a.roi
            assert 32 <= width <= 1280 and 32 <= height <= 960
            for sel,value in [(0x28,0),(0x29,0),(0x25,width),(0x26,height)]:
                d.ctrl_transfer(0x21,1,sel<<8,0x100,value.to_bytes(4,'little'),timeout=2000)
                print('ROI readback',hex(sel),bytes(d.ctrl_transfer(0xa1,0x81,sel<<8,0x100,4,timeout=2000)).hex(),flush=True)
        if a.clock:
            assert 12000000 <= a.clock <= 41000000
            d.ctrl_transfer(0x21,1,0x2400,0x100,a.clock.to_bytes(4,'little'),timeout=2000)
            print('CLOCK readback',bytes(d.ctrl_transfer(0xa1,0x81,0x2400,0x100,4,timeout=2000)).hex(),flush=True)
        for sel in [0x24,0x25,0x26]:
            print('final terminal',hex(sel),bytes(d.ctrl_transfer(0xa1,0x81,sel<<8,0x100,4,timeout=2000)).hex(),flush=True)
        records=[];deadline=time.monotonic()+a.seconds
        out=Path(f'diagnostics/bulk-{a.prefix}.bin').open('wb')
        try:
            while time.monotonic()<deadline:
                try:
                    b=bytes(d.read(0x82,a.read_size,timeout=500))
                    records.append({'time':time.monotonic(),'length':len(b),'offset':out.tell(),'head':b[:16].hex()})
                    out.write(b)
                except usb.core.USBTimeoutError:records.append({'timeout':True})
        finally:out.close()
        Path(f'diagnostics/bulk-{a.prefix}.json').write_text(json.dumps(records,indent=2))
        from collections import Counter
        print('transfer lengths',Counter(r.get('length','timeout') for r in records),flush=True)
        print('first records',records[:10],flush=True)
finally:
    if claimed:
        usb.util.release_interface(d,0)
        usb.util.release_interface(d,1)
    for i in reversed(detached):
        try:d.attach_kernel_driver(i)
        except usb.core.USBError as e:
            if not d.is_kernel_driver_active(i):print('reattach failed',i,e,flush=True)
    usb.util.dispose_resources(d)
