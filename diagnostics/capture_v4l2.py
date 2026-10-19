#!/usr/bin/env python3
"""Capture NexImage Bayer frames through stock uvcvideo and v4l2-ctl.
Requires the approved format-index patch and USB read/write access. Sets only
volatile ROI/clock controls after STREAMON; never writes EEPROM or changes mode.
The GREY-labelled bytes are the sensor's GRBG Bayer mosaic, not RGB.
"""
import argparse
import os
from pathlib import Path
import selectors
import subprocess
import time
from initialize_sensor import initialize

def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--width',type=int,default=720)
    ap.add_argument('--height',type=int,default=480)
    ap.add_argument('--clock',type=int,default=12000000)
    ap.add_argument('--fps',type=int,default=15,help='UVC requested rate; sensor clock determines actual rate')
    ap.add_argument('--count',type=int,default=30)
    ap.add_argument('--output',type=Path,default=Path('diagnostics/neximage-valid.raw'))
    ap.add_argument('--timeout',type=float,default=40)
    a=ap.parse_args()
    if (a.width,a.height) not in [(720,480),(1280,960),(640,480)]:ap.error('Use an advertised frame size')
    if not 12000000<=a.clock<=41000000:ap.error('Clock must be within 12–41 MHz')
    if not 1<=a.count<=1000 or not 0<a.timeout<=300:ap.error('Invalid count or timeout')
    if a.output.exists():ap.error(f'Refusing to overwrite {a.output}')
    a.output.parent.mkdir(parents=True,exist_ok=True)
    subprocess.run(['v4l2-ctl','-d','/dev/video0',f'--set-fmt-video=width={a.width},height={a.height},pixelformat=GREY',f'--set-parm={a.fps}'],check=True,timeout=25)
    cmd=['stdbuf','-oL','-eL','v4l2-ctl','-d','/dev/video0','--stream-mmap=4',f'--stream-count={a.count}',f'--stream-to={a.output}','--verbose']
    child=subprocess.Popen(cmd,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
    sel=selectors.DefaultSelector();sel.register(child.stdout,selectors.EVENT_READ)
    initialized=False;lines=[];pending=b'';deadline=time.monotonic()+a.timeout
    try:
        while True:
            if time.monotonic()>deadline:raise TimeoutError('Capture did not finish within the deadline')
            if not sel.select(.5):continue
            data=os.read(child.stdout.fileno(),65536)
            if not data:break
            pending+=data
            while b'\n' in pending:
                line,pending=pending.split(b'\n',1)
                text=line.decode(errors='replace');lines.append(text)
                print(text,flush=True)
                if 'VIDIOC_STREAMON returned 0' in text and not initialized:
                    initialize(a.width,a.height,a.clock);initialized=True
                    print('Sensor ROI/clock initialized and verified; waiting for valid frames.',flush=True)
        if child.wait(timeout=5):raise RuntimeError('v4l2-ctl failed')
        if not initialized:raise RuntimeError('Did not observe successful STREAMON')
        expected=a.width*a.height*a.count
        actual=a.output.stat().st_size
        if actual!=expected:raise RuntimeError(f'Output size {actual}, expected {expected}')
        print(f'VALID CAPTURE: {a.count} frames, {actual} bytes, saved to {a.output}',flush=True)
    finally:
        sel.close()
        if child.poll() is None:child.terminate();child.wait(timeout=10)
        a.output.with_suffix(a.output.suffix+'.log').write_text('\n'.join(lines)+'\n')
if __name__=='__main__':main()
