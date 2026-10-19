#!/usr/bin/env python3
"""Offline checks only. Never imports USB libraries or accesses hardware."""
from pathlib import Path
from hashlib import sha256
import json,random
from emulator import CPU
from disassemble import decode
from check_control_path import exercise,machine
ROOT=Path(__file__).resolve().parents[2]
old=(ROOT/'neximage-eeprom-format-index-experimental.bin').read_bytes()
new=(ROOT/'neximage-eeprom-uvc-roi-lookup-candidate.bin').read_bytes()
manifest=json.loads((ROOT/'diagnostics/firmware-re/roi-candidate-manifest.json').read_text())
assert sha256(old).hexdigest()==manifest['base_sha256']
assert sha256(new).hexdigest()==manifest['candidate_sha256']
assert len(old)==len(new)==32768
assert sum(a!=b for a,b in zip(old,new))==76
assert old[:0x18f7]==new[:0x18f7] and old[0x1944:]==new[0x1944:]
assert new[0x1f0c]==2 and new[0x1f34]==0x4f
# Regression for direct/indirect upper RAM separation, source/destination order,
# bit addressing, and real call/return stack behavior.
c=CPU(bytes.fromhex('7580017880a6807881a680850a0b750a552200'))
c.ram[0x80]=0x13;c.ram[0x81]=0x37;c.run(0)
assert c.ram[0x80]==1 and c.ram[0x81]==1 and c.ram[0x0b]==0 and c.ram[0x0a]==0x55
assert c.direct(0x81)==0xca
# Exercise actual firmware 32-bit multiply/divide against independent Python
# arithmetic, rather than mocking the arithmetic used by clock calculation.
rng=random.Random(28414934)
for _ in range(40):
    a=rng.randrange(2**32);b=rng.randrange(1,2**32)
    for routine,expected in [(0x1108,(a*b)&0xffffffff),(0x1193,a//b)]:
        c=CPU(old[4:])
        for j,v in enumerate(a.to_bytes(4,'big')):c.wreg(4+j,v)
        for j,v in enumerate(b.to_bytes(4,'big')):c.wreg(j,v)
        c.run(routine)
        actual=int.from_bytes(bytes(c.reg(j) for j in range(4,8)),'big')
        assert actual==expected,(routine,a,b,actual,expected)
# The original handler reproduces the independently measured erroneous clock.
r=exercise(old,2,666667)
assert (r['width'],r['height'],r['pixel_clock'])==(29083,264,7227990)
assert (r['width']&0x3fc)*r['height']==107712
# Inspect every byte of the new replacement block as instructions; verify local
# branch targets hit instruction boundaries or the original continuation.
pc=0x18f3;starts=set();branches=[]
while pc<0x1940:
    starts.add(pc);n,text,_=decode(new[4:],pc)
    if text.startswith(('cjne','sjmp','ljmp')):branches.append(int(text.rsplit(' ',1)[1],0))
    pc+=n
assert pc==0x1940 and all(t in starts or t==0x1940 for t in branches)
# All 253 unsupported frame IDs reject without setting apply pending and
# without writing the destination dimension slots.
for frame in range(256):
    if frame in (1,2,4):continue
    c=machine(new,frame,666667)
    c.ram[0x81:0x83]=bytes.fromhex('0500');c.ram[0x9d:0x9f]=bytes.fromhex('03c0')
    c.run(0x17e9)
    assert c.bit(0xc6)==0 and c.bit(0x0e)==0,frame
    assert c.ram[0x81:0x83]==bytes.fromhex('0500') and c.ram[0x9d:0x9f]==bytes.fromhex('03c0')
# All advertised interval requests retain the old negotiation results while
# producing correct geometry and an in-range computed clock.
rows=[]
for frame,dimensions,intervals in [
 (1,(1280,960),[333333,400000,666667,1000000]),
 (2,(720,480),[166667,333333,400000,666667]),
 (4,(640,480),[166667,333333,400000,666667])]:
    for interval in intervals:
        a=exercise(old,frame,interval);b=exercise(new,frame,interval)
        assert (b['width'],b['height'])==dimensions
        assert a['negotiated_interval']==b['negotiated_interval']
        assert b['uvc_apply_pending']==1
        # This exact formula is an independent translation of existing 0x2b0b.
        expected=((100000000//b['negotiated_interval'])*1650*(b['height']+30))//10
        assert b['pixel_clock']==expected
        assert 12000000<=b['pixel_clock']<=41000000,b
        assert b['pixel_clock']!=a['pixel_clock']
        rows.append(b)
# Run the real existing ROI register writers, mocking only the physical I2C
# transaction. Sensor endpoint registers and USB bridge dimensions are logged.
for frame,dimensions in [(1,(1280,960)),(2,(720,480)),(4,(640,480))]:
    c=machine(new,frame,666667);c.run(0x17e9)
    def sensor_write(cpu):
        cpu.sensor_writes.append(((cpu.reg(6)<<8)|cpu.reg(7),(cpu.reg(4)<<8)|cpu.reg(5)))
    c.hooks[0x2c75]=sensor_write
    c.run(0x2d49);c.run(0x2c00)
    writes=dict(c.sensor_writes)
    w,h=dimensions
    assert writes[0x3004]==0 and writes[0x3008]==w-1
    assert writes[0x3002]==0 and writes[0x3006]==h-1
    assert writes[0x300a]==h+30
    assert c.bridge[0x1e]==(w//4)&255 and c.bridge[0x1f]==(h//4)&255
# Execute the actual main-loop deferred apply block, intercepting only hardware
# work and unrelated tasks after its end. No new apply calls are injected.
for frame,dimensions in [(1,(1280,960)),(2,(720,480)),(4,(640,480))]:
    c=machine(new,frame,666667);c.run(0x17e9)
    def sensor_write(cpu):
        cpu.sensor_writes.append(((cpu.reg(6)<<8)|cpu.reg(7),(cpu.reg(4)<<8)|cpu.reg(5)))
    hardware_calls=[]
    c.hooks[0x2c75]=sensor_write
    c.hooks[0x15b6]=lambda cpu:hardware_calls.append('PLL')
    c.hooks[0x2611]=lambda cpu:hardware_calls.append('sensor-sequencer-reset')
    c.hooks[0x2215]=lambda cpu:hardware_calls.append('exposure-update')
    c.hooks[0x319d]=lambda cpu:None # end of apply block, skip unrelated main tasks
    c.run(0x316d)
    writes=dict(c.sensor_writes);w,h=dimensions
    assert writes[0x3008]==w-1 and writes[0x3006]==h-1
    assert c.bit(0x0e)==0 and 'PLL' in hardware_calls
    assert 12000000<=int.from_bytes(c.ram[0x77:0x7b],'big')<=41000000
# Decode and emulate real GET_CUR response construction to prove format index,
# frame ID, and negotiated interval remain readable after the replacement.
for frame in [1,2,4]:
    c=machine(new,frame,666667);c.run(0x17e9)
    assert not c.fifo_rx
    c.wdirect(0xf5,0x81);c.wdirect(0xfe,26);c.wbit(0xc3,1)
    c.run(0x17e9)
    reply=bytes(c.fifo_tx)
    assert len(reply)==26
    assert reply[2:4]==bytes([1,frame])
    assert int.from_bytes(reply[4:8],'little')==int.from_bytes(c.ram[0x85:0x89],'big')
result={'status':'PASS — offline model, NOT hardware validation','arithmetic_cases':80,'unsupported_frame_ids_rejected':253,'advertised_mode_cases':rows,'known_original_clock_reproduced':7227990,'known_original_image_byte_count_explained':107712,'roi_register_sequences_checked':3,'get_cur_roundtrips_checked':3,'deferred_apply_paths_checked':3,'peripheral_limitations':'EP0 FIFO and ready flags modeled; actual EP0 routines executed. Sensor I2C transaction stubbed. PLL programming, sensor timing, USB streaming and concurrent interrupts are NOT emulated.'}
(ROOT/'diagnostics/firmware-re/offline-validation.json').write_text(json.dumps(result,indent=2)+'\n')
print('PASS: hashes and patch boundaries; 80 arithmetic cases; 253 invalid frame IDs; 12 advertised modes; 3 ROI writer sequences; 3 deferred apply paths; 3 GET_CUR roundtrips.')
for r in rows:print(r)
