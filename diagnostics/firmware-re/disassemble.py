#!/usr/bin/env python3
"""Addressed MCS-51 listing. Camera EEPROM code address = file offset - 4.
Uses the pinned, vendored disasm51 opcode definitions (Apache-2.0).
A requested range is decoded sequentially; this does NOT prove code reachability.
"""
import argparse,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'vendor'))
from disasm51.instructions import Instructions,ArgType
OPS=Instructions().instructions
ROOT=Path(__file__).resolve().parents[2]

def decode(code,pc):
    ins=OPS[code[pc]];raw=code[pc:pc+ins.length];args=[];i=1
    for typ in ins.args or []:
        v=raw[i];i+=1
        if typ==ArgType.LABEL:v=v*256+raw[i];i+=1;s=f'0x{v:04x}'
        elif typ==ArgType.REL:v=(pc+ins.length+(v if v<128 else v-256))&65535;s=f'0x{v:04x}'
        elif typ==ArgType.ADDR:v=((pc+ins.length)&0xf800)|((raw[0]&0xe0)<<3)|v;s=f'0x{v:04x}'
        else:s=f'0x{v:02x}'
        args.append(s)
    return ins.length,ins.mnemonic.format(*args),raw

def listing(code,start,end):
    pc=start
    while pc<end:
        n,text,raw=decode(code,pc)
        print(f'{pc:04x} [ee {pc+4:04x}]  {raw.hex(" "):9s}  {text}')
        pc+=n
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--image',type=Path,default=ROOT/'neximage-eeprom-format-index-experimental.bin');p.add_argument('start',type=lambda x:int(x,0));p.add_argument('end',type=lambda x:int(x,0));a=p.parse_args()
    listing(a.image.read_bytes()[4:],a.start,a.end)
