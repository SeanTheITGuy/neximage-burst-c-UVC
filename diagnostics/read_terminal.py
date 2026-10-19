#!/usr/bin/env python3
"""Read documented EUVC terminal ROI controls, restoring kernel ownership."""
import json
from pathlib import Path
import usb.core,usb.util
d=usb.core.find(idVendor=0x199e,idProduct=0x8308)
assert usb.util.get_string(d,d.iSerialNumber).rstrip('\0')=='28414934'
detached=[];claimed=[];result={}
try:
 for i in [1,0]:
  if d.is_kernel_driver_active(i):d.detach_kernel_driver(i);detached.append(i)
 for i in [0,1]:usb.util.claim_interface(d,i);claimed.append(i)
 for sel,n in [(0x20,2),(0x24,4),(0x25,4),(0x26,4),(0x27,4),(0x28,4),(0x29,4),(0x2a,1),(0x38,4),(0x39,4)]:
  for req in [0x81,0x82,0x83]:
   try:
    b=bytes(d.ctrl_transfer(0xa1,req,sel<<8,0x100,n,timeout=1000))
    print(hex(sel),hex(req),b.hex(' '),int.from_bytes(b,'little'),flush=True)
    result[f'{sel:02x}-{req:02x}']=b.hex()
   except usb.core.USBError as e:print(hex(sel),hex(req),e,flush=True)
 Path('diagnostics/terminal-controls.json').write_text(json.dumps(result,indent=2))
finally:
 for i in reversed(claimed):usb.util.release_interface(d,i)
 for i in reversed(detached):
  try:d.attach_kernel_driver(i)
  except usb.core.USBError as e:
   if not d.is_kernel_driver_active(i):print('reattach failed',i,e)
 usb.util.dispose_resources(d)
