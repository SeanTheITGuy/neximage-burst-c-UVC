#!/usr/bin/env python3
"""Run the real UVC handler offline; emulate EP0 data receipt, not USB hardware."""
from pathlib import Path
import json
from emulator import CPU
ROOT=Path(__file__).resolve().parents[2]

def machine(image,frame,interval):
    cpu=CPU(image[4:]);cpu.wdirect(0xf7,2);cpu.wdirect(0xf5,1)
    cpu.ram[0x95]=1;cpu.wdirect(0x18,1) # initialized format ID and UVC mode flag
    payload=bytes([1,0,1,frame])+interval.to_bytes(4,'little')+bytes(18)
    cpu.fifo_rx=list(payload);cpu.wdirect(0xfe,len(payload));cpu.wbit(0xc2,1)
    return cpu

def exercise(image,frame,interval):
    c=machine(image,frame,interval)
    try:c.run(0x17e9)
    except Exception:
        print(c.trace);raise
    width=int.from_bytes(c.ram[0x81:0x83],'big');height=int.from_bytes(c.ram[0x9d:0x9f],'big')
    negotiated=int.from_bytes(c.ram[0x85:0x89],'big')
    c.hooks[0x2d49]=lambda _:None
    c.hooks[0x2c00]=lambda _:None
    c.hooks[0x15b6]=lambda _:None
    c.hooks[0x2215]=lambda _:None
    c.run(0x2b0b)
    clock=int.from_bytes(c.ram[0x77:0x7b],'big')
    return {'frame':frame,'requested_interval':interval,'width':width,'height':height,'negotiated_interval':negotiated,'pixel_clock':clock,'steps':c.steps,'uvc_apply_pending':c.bit(0xe)}
if __name__=='__main__':
    image=(ROOT/'neximage-eeprom-format-index-experimental.bin').read_bytes()
    results=[]
    for frame in [1,2,4]:
        r=exercise(image,frame,666667);results.append(r);print(r)
    (ROOT/'diagnostics/firmware-re/original-control-emulation.json').write_text(json.dumps(results,indent=2)+'\n')
