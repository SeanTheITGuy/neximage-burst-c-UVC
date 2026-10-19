#!/usr/bin/env python3
"""Summarize saved bulk reads; detect payload boundaries via short transfers."""
from pathlib import Path
import argparse,json
from collections import Counter
p=argparse.ArgumentParser();p.add_argument('prefix');p.add_argument('--read-size',type=int,default=16384);p.add_argument('--width',type=int);p.add_argument('--height',type=int);a=p.parse_args()
base=Path(__file__).resolve().parent
b=(base/f'bulk-{a.prefix}.bin').read_bytes();r=json.loads((base/f'bulk-{a.prefix}.json').read_text())
payload=bytearray();frames=[];header=None
for x in r:
 if 'length' not in x:
  # A timed-out request can return partial bytes. Do not treat it as
  # a guaranteed short USB packet. This script only verifies full payloads.
  payload.clear();continue
 chunk=b[x['offset']:x['offset']+x['length']];payload.extend(chunk)
 if x['length'] < a.read_size:
  if len(payload)>=2 and payload[0]==2 and payload[1] in (2,3):
   frames.append({'image_bytes':len(payload)-2,'flags':payload[1],'time':x['time']})
   if a.width and a.height and len(payload)-2==a.width*a.height:
    path=base/f'valid-{a.prefix}.pgm'
    if not path.exists():path.write_bytes(f'P5\n{a.width} {a.height}\n255\n'.encode()+payload[2:])
  payload.clear()
print(a.prefix,'complete payloads',len(frames),'image sizes',dict(Counter(x['image_bytes'] for x in frames)),'headers',dict(Counter(x['flags'] for x in frames)))
print('payload completion intervals:',[round(frames[i]['time']-frames[i-1]['time'],6) for i in range(1,min(len(frames),10))])
