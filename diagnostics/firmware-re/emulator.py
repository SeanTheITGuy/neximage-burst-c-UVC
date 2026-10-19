#!/usr/bin/env python3
"""Small offline MCS-51 interpreter for the firmware's control/data paths.
Not a peripheral or timing emulator. Unimplemented opcodes fail closed. SFR and
I2C effects are modeled explicitly by the harness; this is not hardware validation.
"""
from disassemble import decode
class CPU:
    def __init__(self,code):
        self.code=bytes(code).ljust(65536,b'\xff');self.ram=bytearray(256);self.sfr=bytearray(128);self.xram=bytearray(65536)
        self.pc=0;self.steps=0;self.hooks={};self.visited=set();self.trace=[];self.bridge={};self.bridge_writes=[];self.sensor_writes=[];self.fifo_rx=[];self.fifo_tx=[]
        self.wdirect(0x81,0xca)
    def direct(self,a):
        if a==0xa4:
            if not self.fifo_rx:raise RuntimeError("EP0 FIFO underflow")
            return self.fifo_rx.pop(0)
        if a==0xad:return self.bridge.get(self.direct(0xac),0)
        return self.ram[a] if a<128 else self.sfr[a-128]
    def wdirect(self,a,v):
        v &= 255
        if a<128:self.ram[a]=v
        else:self.sfr[a-128]=v
        if a==0xa4:self.fifo_tx.append(v)
        if a==0xad:
            self.bridge[self.direct(0xac)]=v;self.bridge_writes.append((self.direct(0xac),v))
    def reg(self,n):return self.ram[((self.direct(0xd0)>>3)&3)*8+n]
    def wreg(self,n,v):self.ram[((self.direct(0xd0)>>3)&3)*8+n]=v&255
    def bit(self,a):return (self.direct(a&0xf8) if a>=128 else self.ram[0x20+(a>>3)])>>(a&7)&1
    def wbit(self,a,v):
        addr=(a&0xf8) if a>=128 else 0x20+(a>>3)
        self.wdirect(addr,(self.direct(addr)&~(1<<(a&7)))|((v&1)<<(a&7)))
    @property
    def A(self):return self.direct(0xe0)
    @A.setter
    def A(self,v):self.wdirect(0xe0,v)
    @property
    def C(self):return self.bit(0xd7)
    @C.setter
    def C(self,v):self.wbit(0xd7,int(bool(v)))
    @property
    def dptr(self):return self.direct(0x82)|(self.direct(0x83)<<8)
    @dptr.setter
    def dptr(self,v):self.wdirect(0x82,v);self.wdirect(0x83,v>>8)
    def read(self,arg,bit=False):
        arg=arg.strip().lower()
        if arg=='a':return self.A
        if arg=='c':return self.C
        if arg=='dptr':return self.dptr
        if arg.startswith('#'):return int(arg[1:],0)
        if arg.startswith('/'):return 1-self.read(arg[1:],True)
        if arg.startswith('@r'):return self.ram[self.reg(int(arg[2:]))]
        if arg.startswith('r'):return self.reg(int(arg[1:]))
        return self.bit(int(arg,0)) if bit else self.direct(int(arg,0))
    def write(self,arg,v,bit=False):
        arg=arg.strip().lower()
        if arg=='a':self.A=v
        elif arg=='c':self.C=v
        elif arg=='dptr':self.dptr=v
        elif arg.startswith('@r'):self.ram[self.reg(int(arg[2:]))]=v&255
        elif arg.startswith('r'):self.wreg(int(arg[1:]),v)
        elif bit:self.wbit(int(arg,0),v)
        else:self.wdirect(int(arg,0),v)
    def push(self,v):
        sp=(self.direct(0x81)+1)&255;self.wdirect(0x81,sp);self.ram[sp]=v&255
    def pop(self):
        sp=self.direct(0x81);v=self.ram[sp];self.wdirect(0x81,(sp-1)&255);return v
    def ret(self):self.pc=(self.pop()<<8)|self.pop()
    def run(self,start,limit=1000000):
        self.pc=start;self.push(0xff);self.push(0xff)
        for _ in range(limit):
            if self.pc==0xffff:return
            if self.pc in self.hooks:
                self.hooks[self.pc](self);self.ret();continue
            self.step()
        raise RuntimeError(f'Instruction budget exhausted at {self.pc:04x}')
    def step(self):
        pc=self.pc;n,text,_=decode(self.code,pc);self.pc=(pc+n)&65535;self.steps+=1;self.visited.add(pc)
        self.trace.append((pc,text));self.trace=self.trace[-40:]
        spl=text.lower().split(None,1);op=spl[0];args=[s.strip() for s in spl[1].split(',')] if len(spl)>1 else []
        read=self.read;write=self.write
        if op=='nop':pass
        elif op=='mov':write(args[0],read(args[1],args[0]=='c'),args[0]=='c' or args[1]=='c')
        elif op=='movc':self.A=self.code[(self.A+(self.dptr if 'dptr' in args[1] else self.pc))&65535]
        elif op=='movx':
            ptr=args[1] if args[0]=='a' else args[0]
            address=self.dptr if ptr=='@dptr' else (self.direct(0xa0)<<8)|self.reg(int(ptr[-1]))
            if args[0]=='a':self.A=self.xram[address]
            else:self.xram[address]=self.A
        elif op in ('inc','dec'):
            mask=65535 if args[0]=='dptr' else 255;write(args[0],(read(args[0])+(1 if op=='inc' else -1))&mask)
        elif op in ('add','addc','subb'):
            a=self.A;b=read(args[1]);c=self.C if op!='add' else 0
            result=a-b-c if op=='subb' else a+b+c
            self.C=(result<0) if op=='subb' else (result>255)
            self.wbit(0xd6,((a&15)-(b&15)-c<0) if op=='subb' else ((a&15)+(b&15)+c>15))
            self.wbit(0xd2,((a^b)&(a^result)&128)!=0 if op=='subb' else ((~(a^b))&(a^result)&128)!=0)
            self.A=result
        elif op in ('anl','orl','xrl'):
            bit=args[0]=='c';a=read(args[0],bit);b=read(args[1],bit)
            write(args[0],a&b if op=='anl' else a|b if op=='orl' else a^b,bit)
        elif op in ('clr','setb','cpl'):
            bit=args[0]!='a';v=read(args[0],bit)
            write(args[0],0 if op=='clr' else 1 if op=='setb' else (v^1 if bit else v^255),bit)
        elif op in ('rr','rl','rrc','rlc','swap'):
            a=self.A;c=self.C
            if op=='rr':self.A=(a>>1)|(a<<7)
            elif op=='rl':self.A=(a<<1)|(a>>7)
            elif op=='rrc':self.A=(a>>1)|(c<<7);self.C=a&1
            elif op=='rlc':self.A=(a<<1)|c;self.C=a>>7
            else:self.A=(a<<4)|(a>>4)
        elif op=='mul':
            value=self.A*self.direct(0xf0);self.A=value;self.wdirect(0xf0,value>>8);self.C=0;self.wbit(0xd2,value>255)
        elif op=='div':
            a=self.A;b=self.direct(0xf0);self.C=0;self.wbit(0xd2,b==0)
            if b:self.A=a//b;self.wdirect(0xf0,a%b)
        elif op in ('ljmp','ajmp','sjmp'):self.pc=int(args[0],0)
        elif op=='jmp':self.pc=(self.A+self.dptr)&65535
        elif op in ('lcall','acall'):
            self.push(self.pc&255);self.push(self.pc>>8);self.pc=int(args[0],0)
        elif op in ('ret','reti'):self.ret()
        elif op=='push':self.push(read(args[0]))
        elif op=='pop':write(args[0],self.pop())
        elif op=='cjne':
            a=read(args[0]);b=read(args[1]);self.C=a<b
            if a!=b:self.pc=int(args[2],0)
        elif op=='djnz':
            value=(read(args[0])-1)&255;write(args[0],value)
            if value:self.pc=int(args[1],0)
        elif op in ('jc','jnc','jz','jnz'):
            yes={'jc':bool(self.C),'jnc':not self.C,'jz':self.A==0,'jnz':self.A!=0}[op]
            if yes:self.pc=int(args[0],0)
        elif op in ('jb','jnb','jbc'):
            bit=read(args[0],True)
            if (not bit if op=='jnb' else bit):
                self.pc=int(args[1],0)
                if op=='jbc':write(args[0],0,True)
        elif op=='xch':a=self.A;self.A=read(args[1]);write(args[1],a)
        else:raise NotImplementedError(f'{pc:04x}: {text}')
        # The accumulator parity bit is maintained by real 8051 hardware.
        self.wbit(0xd0,self.A.bit_count()&1)
