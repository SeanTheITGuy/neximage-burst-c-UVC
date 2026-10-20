#!/usr/bin/env python3
"""Validate the approved firmware patch using ONLY stock V4L2 capture.
No USB library, private sensor controls, kernel changes, or EEPROM writes.
Run after a physical reconnect. Saves logs, frame files, and a JSON summary.
"""
from pathlib import Path
import argparse,json,re,subprocess,time
ROOT=Path(__file__).resolve().parents[2]
def main():
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--count',type=int,default=10)
    ap.add_argument('--label',default='cold1')
    ap.add_argument('--format', choices=['GREY', 'GRBG'], default='GREY')
    ap.add_argument('--device', default='/dev/video0')
    args=ap.parse_args()
    if not 3<=args.count<=100:ap.error('Count must be between 3 and 100')
    if not args.label.replace('-','').isalnum():ap.error('Use an alphanumeric label')
    folder=ROOT/'diagnostics/firmware-re'/f'validation-{args.label}'
    folder.mkdir(exist_ok=False)
    summary={'status':'RUNNING','private_sensor_controls_used':False,'tests':[]}
    def save(): (folder/'results.json').write_text(json.dumps(summary,indent=2)+'\n')
    save()
    for num,(width,height,fps) in enumerate([(720,480,15),(1280,960,10),(640,480,15),(720,480,15)]):
        tag=f'{num}-{width}x{height}'
        output=folder/f'{tag}.raw'
        cmd=['stdbuf','-oL','-eL','v4l2-ctl','-d',args.device,f'--set-fmt-video=width={width},height={height},pixelformat={args.format}',f'--set-parm={fps}','--get-fmt-video','--get-parm','--stream-mmap=4',f'--stream-count={args.count}',f'--stream-to={output}','--verbose']
        record={'width':width,'height':height,'requested_fps':fps,'command':cmd};summary['tests'].append(record);save()
        print(f'Testing {tag}, standard V4L2 only...',flush=True)
        start=time.monotonic()
        try:
            result=subprocess.run(cmd,capture_output=True,text=True,timeout=25)
            log=result.stdout+result.stderr;record['exit_code']=result.returncode
        except subprocess.TimeoutExpired as e:
            log=(e.stdout or b'').decode(errors='replace')+(e.stderr or b'').decode(errors='replace')
            record.update({'status':'TIMEOUT','elapsed_seconds':time.monotonic()-start})
            (folder/f'{tag}.log').write_text(log);summary['status']='FAILED';save()
            raise RuntimeError(f'{tag} timed out; see {folder}')
        (folder/f'{tag}.log').write_text(log)
        rows=[line for line in log.splitlines() if line.startswith('cap dqbuf:')]
        good=[line for line in rows if '(error,' not in line]
        sizes=[int(re.search(r'bytesused:\s*(\d+)',line)[1]) for line in good]
        timestamps=[float(re.search(r'ts:\s*([0-9.]+)',line)[1]) for line in good]
        size=output.stat().st_size if output.exists() else 0
        expected=width*height*args.count
        negotiated = re.search(r"Pixel Format\s*:\s*'([^']+)'", log)
        record['negotiated_format'] = negotiated[1] if negotiated else None
        passed=(result.returncode==0 and record['negotiated_format']==args.format and len(good)==args.count and size==expected and all(n==width*height for n in sizes))
        record.update({'status':'PASS' if passed else 'FAIL','good_frames':len(good),'error_frames':len(rows)-len(good),'file_bytes':size,'expected_file_bytes':expected,'elapsed_seconds':time.monotonic()-start,'measured_fps':(len(timestamps)-1)/(timestamps[-1]-timestamps[0]) if len(timestamps)>1 else None})
        save();print(json.dumps({k:v for k,v in record.items() if k!='command'}),flush=True)
        if not passed:
            summary['status']='FAILED';save();raise RuntimeError(f'{tag} failed; see {folder}')
    summary['status']='PASS';save();print(f'All four captures passed without helpers. Results: {folder}',flush=True)
if __name__=='__main__':main()
