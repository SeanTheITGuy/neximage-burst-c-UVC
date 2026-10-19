#!/usr/bin/env python3
"""Set volatile NexImage ROI/clock while uvcvideo remains attached.

Uses the manufacturer's class/device recipient convention (also used by
Usb2Camera::get_firmware_version). No EEPROM, mode, reset, or flash requests.
Run after STREAMON: a later UVC commit may overwrite the sensor clock.
"""
import argparse
from pathlib import Path
import usb.core,usb.util

def initialize(width,height,clock):
    assert 32 <= width <= 1280 and width%4 == 0
    assert 32 <= height <= 960 and height%2 == 0
    assert 12000000 <= clock <= 41000000
    d=usb.core.find(idVendor=0x199e,idProduct=0x8308)
    assert d is not None
    # Use cached sysfs identity: this firmware can reject string requests
    # while streaming. Match the precise libusb bus/address as well.
    matches=[]
    for node in Path('/sys/bus/usb/devices').iterdir():
        try:
            if int((node/'busnum').read_text())==d.bus and int((node/'devnum').read_text())==d.address:
                matches.append((node/'serial').read_text().strip())
        except (FileNotFoundError,ValueError):pass
    assert matches==['28414934'],matches
    try:
        for sel,value in [(0x28,0),(0x29,0),(0x25,width),(0x26,height),(0x24,clock)]:
            assert sel in (0x24,0x25,0x26,0x28,0x29)
            n=d.ctrl_transfer(0x20,1,sel<<8,0x100,value.to_bytes(4,'little'),timeout=2000)
            assert n==4
            got=bytes(d.ctrl_transfer(0xa0,0x81,sel<<8,0x100,4,timeout=2000))
            assert int.from_bytes(got,'little')==value,(sel,got)
    finally:usb.util.dispose_resources(d)

if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--width',type=int,default=720);p.add_argument('--height',type=int,default=480);p.add_argument('--clock',type=int,default=12000000)
    a=p.parse_args();initialize(a.width,a.height,a.clock)
    print('Volatile ROI and clock verified; EEPROM untouched.')
