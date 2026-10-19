#!/usr/bin/env python3
"""Reproduce full-sized Bayer buffers through unchanged uvcvideo.
Tests frame flags after the approved format-index EEPROM correction.
"""
import os,subprocess
from pathlib import Path
from initialize_sensor import initialize
root=Path(__file__).resolve().parent.parent
os.chdir(root)
subprocess.run(['v4l2-ctl','-d','/dev/video0','--set-fmt-video=width=720,height=480,pixelformat=GREY','--set-parm=15'],check=True,timeout=25)
env=dict(os.environ,NEXIMAGE_CAPTURE_PREFIX='diagnostics/postpatch-initialized',NEXIMAGE_CAPTURE_COUNT='24')
p=subprocess.Popen(['./diagnostics/capture_errors'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT,text=True,env=env)
lines=[]
try:
    for line in p.stdout:
        print(line,end='',flush=True);lines.append(line)
        if 'STREAMON success' in line:
            initialize(720,480,12000000)
            message='Volatile sensor ROI/clock verified while uvcvideo remains attached.\n'
            print(message,end='',flush=True);lines.append(message)
    if p.wait(timeout=15):raise RuntimeError('V4L2 capture failed')
finally:
    if p.poll() is None:p.terminate();p.wait(timeout=10)
    (root/'diagnostics/v4l2-postpatch-initialized.txt').write_text(''.join(lines))
