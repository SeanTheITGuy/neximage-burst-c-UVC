0100 [ee 0104]  39         addc A, R1
0101 [ee 0105]  00         nop
0102 [ee 0106]  33         rlc A
0103 [ee 0107]  00         nop
0104 [ee 0108]  34 00      addc A, #0x00
0106 [ee 010a]  00         nop
0107 [ee 010b]  00         nop
0108 [ee 010c]  00         nop
0109 [ee 010d]  00         nop
010a [ee 010e]  00         nop
010b [ee 010f]  00         nop
010c [ee 0110]  00         nop
010d [ee 0111]  00         nop
010e [ee 0112]  00         nop
010f [ee 0113]  00         nop
0110 [ee 0114]  00         nop
0111 [ee 0115]  00         nop
0112 [ee 0116]  00         nop
0113 [ee 0117]  00         nop
0114 [ee 0118]  00         nop
0115 [ee 0119]  00         nop
0116 [ee 011a]  00         nop
0117 [ee 011b]  00         nop
0118 [ee 011c]  00         nop
0119 [ee 011d]  00         nop
011a [ee 011e]  00         nop
011b [ee 011f]  00         nop
011c [ee 0120]  00         nop
011d [ee 0121]  00         nop
011e [ee 0122]  00         nop
011f [ee 0123]  00         nop
0120 [ee 0124]  00         nop
0121 [ee 0125]  00         nop
0122 [ee 0126]  00         nop
0123 [ee 0127]  00         nop
0124 [ee 0128]  00         nop
0125 [ee 0129]  00         nop
0126 [ee 012a]  00         nop
0127 [ee 012b]  00         nop
0128 [ee 012c]  00         nop
0129 [ee 012d]  00         nop
012a [ee 012e]  00         nop
012b [ee 012f]  00         nop
012c [ee 0130]  00         nop
012d [ee 0131]  00         nop
012e [ee 0132]  00         nop
012f [ee 0133]  00         nop
0130 [ee 0134]  00         nop
0131 [ee 0135]  00         nop
0132 [ee 0136]  00         nop
0133 [ee 0137]  00         nop
0134 [ee 0138]  00         nop
0135 [ee 0139]  00         nop
0136 [ee 013a]  00         nop
0137 [ee 013b]  00         nop
0138 [ee 013c]  00         nop
0139 [ee 013d]  00         nop
013a [ee 013e]  00         nop
013b [ee 013f]  00         nop
013c [ee 0140]  00         nop
013d [ee 0141]  00         nop
013e [ee 0142]  00         nop
013f [ee 0143]  00         nop
0140 [ee 0144]  00         nop
0141 [ee 0145]  00         nop
0142 [ee 0146]  00         nop
0143 [ee 0147]  00         nop
0144 [ee 0148]  00         nop
0145 [ee 0149]  00         nop
0146 [ee 014a]  00         nop
0147 [ee 014b]  00         nop
0148 [ee 014c]  00         nop
0149 [ee 014d]  00         nop
014a [ee 014e]  00         nop
014b [ee 014f]  00         nop
014c [ee 0150]  00         nop
014d [ee 0151]  00         nop
014e [ee 0152]  00         nop
014f [ee 0153]  00         nop
0150 [ee 0154]  08         inc R0
0151 [ee 0155]  13         rrc A
0152 [ee 0156]  00         nop
0153 [ee 0157]  01 10      ajmp 0x0010
0155 [ee 0159]  80 10      sjmp 0x0167
0157 [ee 015b]  00         nop
0158 [ee 015c]  20 01 06   jb 0x01, 0x0161
015b [ee 015f]  00         nop
015c [ee 0160]  00         nop
015d [ee 0161]  80 01      sjmp 0x0160
015f [ee 0163]  01 00      ajmp 0x0000
0161 [ee 0165]  00         nop
0162 [ee 0166]  00         nop
0163 [ee 0167]  00         nop
0164 [ee 0168]  00         nop
0165 [ee 0169]  00         nop
0166 [ee 016a]  00         nop
0167 [ee 016b]  00         nop
0168 [ee 016c]  e4         clr A
0169 [ee 016d]  f5 47      mov 0x47, A
016b [ee 016f]  f5 48      mov 0x48, A
016d [ee 0171]  f5 49      mov 0x49, A
016f [ee 0173]  f5 4a      mov 0x4a, A
0171 [ee 0175]  e5 f5      mov A, 0xf5
0173 [ee 0177]  b4 01 03   cjne A, #0x01, 0x0179
0176 [ee 017a]  75 3c 01   mov 0x3c, #0x01
0179 [ee 017d]  e5 f5      mov A, 0xf5
017b [ee 017f]  b4 84 03   cjne A, #0x84, 0x0181
017e [ee 0182]  75 47 01   mov 0x47, #0x01
0181 [ee 0185]  e5 f5      mov A, 0xf5
0183 [ee 0187]  b4 86 03   cjne A, #0x86, 0x0189
0186 [ee 018a]  75 47 03   mov 0x47, #0x03
0189 [ee 018d]  af f7      mov R7, 0xf7
018b [ee 018f]  ef         mov A, R7
018c [ee 0190]  12 12 d8   lcall 0x12d8
018f [ee 0193]  01 e7      ajmp 0x00e7
0191 [ee 0195]  04         inc A
0192 [ee 0196]  0b         inc R3
0193 [ee 0197]  20 06 02   jb 0x06, 0x0198
0196 [ee 019a]  c9         xch A, R1
0197 [ee 019b]  11 03      acall 0x0003
0199 [ee 019d]  00         nop
019a [ee 019e]  20 04 34   jb 0x04, 0x01d1
019d [ee 01a1]  24 03      add A, #0x03
019f [ee 01a3]  97         subb A, @R1
01a0 [ee 01a4]  25 03      add A, 0x03
01a2 [ee 01a6]  e8         mov A, R0
01a3 [ee 01a7]  26         add A, @R0
01a4 [ee 01a8]  05 01      inc 0x01
01a6 [ee 01aa]  27         add A, @R1
01a7 [ee 01ab]  05 53      inc 0x53
01a9 [ee 01ad]  28         add A, R0
01aa [ee 01ae]  05 a9      inc 0xa9
01ac [ee 01b0]  29         add A, R1
01ad [ee 01b1]  06         inc @R0
01ae [ee 01b2]  0e         inc R6
01af [ee 01b3]  2a         add A, R2
01b0 [ee 01b4]  06         inc @R0
01b1 [ee 01b5]  96         subb A, @R0
01b2 [ee 01b6]  2b         add A, R3
01b3 [ee 01b7]  08         inc R0
01b4 [ee 01b8]  8f 2c      mov 0x2c, R7
01b6 [ee 01ba]  06         inc @R0
01b7 [ee 01bb]  cb         xch A, R3
01b8 [ee 01bc]  2d         add A, R5
01b9 [ee 01bd]  07         inc @R1
01ba [ee 01be]  12 2e 06   lcall 0x2e06
01bd [ee 01c1]  50 36      jnc 0x01f5
01bf [ee 01c3]  08         inc R0
01c0 [ee 01c4]  48         orl A, R0
01c1 [ee 01c5]  37         addc A, @R1
01c2 [ee 01c6]  0a         inc R2
01c3 [ee 01c7]  16         dec @R0
01c4 [ee 01c8]  38         addc A, R0
01c5 [ee 01c9]  0a         inc R2
01c6 [ee 01ca]  16         dec @R0
01c7 [ee 01cb]  39         addc A, R1
01c8 [ee 01cc]  09         inc R1
01c9 [ee 01cd]  bf 3a 09   cjne R7, #0x3a, 0x01d5
01cc [ee 01d0]  56         anl A, @R0
01cd [ee 01d1]  3b         addc A, R3
01ce [ee 01d2]  0a         inc R2
01cf [ee 01d3]  97         subb A, @R1
01d0 [ee 01d4]  3c         addc A, R4
01d1 [ee 01d5]  0a         inc R2
01d2 [ee 01d6]  e2         movx A, @R0
01d3 [ee 01d7]  3e         addc A, R6
01d4 [ee 01d8]  03         rr A
01d5 [ee 01d9]  50 40      jnc 0x0217
01d7 [ee 01db]  07         inc @R1
01d8 [ee 01dc]  b7 44 08   cjne @R1, #0x44, 0x01e3
01db [ee 01df]  04         inc A
01dc [ee 01e0]  45 08      orl A, 0x08
01de [ee 01e2]  d9 47      djnz R1, 0x0227
01e0 [ee 01e4]  07         inc @R1
01e1 [ee 01e5]  70 50      jnz 0x0233
01e3 [ee 01e7]  00         nop
01e4 [ee 01e8]  00         nop
01e5 [ee 01e9]  0b         inc R3
01e6 [ee 01ea]  f0         movx @DPTR, A
01e7 [ee 01eb]  af f5      mov R7, 0xf5
01e9 [ee 01ed]  ef         mov A, R7
01ea [ee 01ee]  24 7f      add A, #0x7f
01ec [ee 01f0]  70 03      jnz 0x01f1
01ee [ee 01f2]  02 02 9d   ljmp 0x029d
01f1 [ee 01f5]  14         dec A
01f2 [ee 01f6]  70 03      jnz 0x01f7
01f4 [ee 01f8]  02 02 be   ljmp 0x02be
01f7 [ee 01fb]  14         dec A
01f8 [ee 01fc]  70 03      jnz 0x01fd
01fa [ee 01fe]  02 02 c1   ljmp 0x02c1
01fd [ee 0201]  24 fe      add A, #0xfe
01ff [ee 0203]  70 03      jnz 0x0204
0201 [ee 0205]  02 02 c6   ljmp 0x02c6
0204 [ee 0208]  24 fe      add A, #0xfe
0206 [ee 020a]  70 03      jnz 0x020b
0208 [ee 020c]  02 02 97   ljmp 0x0297
020b [ee 020f]  24 86      add A, #0x86
020d [ee 0211]  60 03      jz 0x0212
020f [ee 0213]  02 0b f3   ljmp 0x0bf3
0212 [ee 0216]  e4         clr A
0213 [ee 0217]  f5 4e      mov 0x4e, A
0215 [ee 0219]  f5 4d      mov 0x4d, A
0217 [ee 021b]  f5 4c      mov 0x4c, A
0219 [ee 021d]  f5 4b      mov 0x4b, A
021b [ee 021f]  12 0c 3a   lcall 0x0c3a
021e [ee 0222]  c0 04      push 0x04
0220 [ee 0224]  c0 05      push 0x05
0222 [ee 0226]  c0 06      push 0x06
0224 [ee 0228]  c0 07      push 0x07
0226 [ee 022a]  12 20 30   lcall 0x2030
0229 [ee 022d]  12 12 4c   lcall 0x124c
022c [ee 0230]  d0 03      pop 0x03
022e [ee 0232]  d0 02      pop 0x02
0230 [ee 0234]  d0 01      pop 0x01
0232 [ee 0236]  d0 00      pop 0x00
0234 [ee 0238]  12 1f cb   lcall 0x1fcb
0237 [ee 023b]  c0 04      push 0x04
0239 [ee 023d]  c0 05      push 0x05
023b [ee 023f]  c0 06      push 0x06
023d [ee 0241]  c0 07      push 0x07
023f [ee 0243]  12 20 75   lcall 0x2075
0242 [ee 0246]  d0 03      pop 0x03
0244 [ee 0248]  d0 02      pop 0x02
0246 [ee 024a]  d0 01      pop 0x01
0248 [ee 024c]  d0 00      pop 0x00
024a [ee 024e]  12 1f cb   lcall 0x1fcb
024d [ee 0251]  c0 04      push 0x04
024f [ee 0253]  c0 05      push 0x05
0251 [ee 0255]  c0 06      push 0x06
0253 [ee 0257]  c0 07      push 0x07
0255 [ee 0259]  12 20 30   lcall 0x2030
0258 [ee 025c]  12 12 5f   lcall 0x125f
025b [ee 025f]  d0 03      pop 0x03
025d [ee 0261]  d0 02      pop 0x02
025f [ee 0263]  d0 01      pop 0x01
0261 [ee 0265]  d0 00      pop 0x00
0263 [ee 0267]  12 20 5b   lcall 0x205b
0266 [ee 026a]  7f e0      mov R7, #0xe0
0268 [ee 026c]  7e 93      mov R6, #0x93
026a [ee 026e]  7d 04      mov R5, #0x04
026c [ee 0270]  7c 00      mov R4, #0x00
026e [ee 0272]  ab 4e      mov R3, 0x4e
0270 [ee 0274]  aa 4d      mov R2, 0x4d
0272 [ee 0276]  a9 4c      mov R1, 0x4c
0274 [ee 0278]  f8         mov R0, A
0275 [ee 0279]  d3         setb C
0276 [ee 027a]  12 12 3b   lcall 0x123b
0279 [ee 027d]  40 03      jc 0x027e
027b [ee 027f]  02 0b fc   ljmp 0x0bfc
027e [ee 0282]  e4         clr A
027f [ee 0283]  ff         mov R7, A
0280 [ee 0284]  fe         mov R6, A
0281 [ee 0285]  fd         mov R5, A
0282 [ee 0286]  fc         mov R4, A
0283 [ee 0287]  a8 4b      mov R0, 0x4b
0285 [ee 0289]  12 12 3b   lcall 0x123b
0288 [ee 028c]  50 03      jnc 0x028d
028a [ee 028e]  02 0b fc   ljmp 0x0bfc
028d [ee 0291]  ac 4b      mov R4, 0x4b
028f [ee 0293]  78 99      mov R0, #0x99
0291 [ee 0295]  12 20 b0   lcall 0x20b0
0294 [ee 0298]  02 22 15   ljmp 0x2215
0297 [ee 029b]  75 47 7f   mov 0x47, #0x7f
029a [ee 029e]  02 0b f3   ljmp 0x0bf3
029d [ee 02a1]  78 99      mov R0, #0x99
029f [ee 02a3]  12 12 72   lcall 0x1272
02a2 [ee 02a6]  e4         clr A
02a3 [ee 02a7]  8f 47      mov 0x47, R7
02a5 [ee 02a9]  78 99      mov R0, #0x99
02a7 [ee 02ab]  12 12 72   lcall 0x1272
02aa [ee 02ae]  12 1f e1   lcall 0x1fe1
02ad [ee 02b1]  8f 48      mov 0x48, R7
02af [ee 02b3]  78 99      mov R0, #0x99
02b1 [ee 02b5]  12 12 72   lcall 0x1272
02b4 [ee 02b8]  12 1f a9   lcall 0x1fa9
02b7 [ee 02bb]  8f 49      mov 0x49, R7
02b9 [ee 02bd]  f5 4a      mov 0x4a, A
02bb [ee 02bf]  02 0b f3   ljmp 0x0bf3
02be [ee 02c2]  02 0b e3   ljmp 0x0be3
02c1 [ee 02c5]  90 0c 8f   mov DPTR, #0x0c8f
02c4 [ee 02c8]  80 69      sjmp 0x032f
02c6 [ee 02ca]  02 09 b6   ljmp 0x09b6
02c9 [ee 02cd]  af f5      mov R7, 0xf5
02cb [ee 02cf]  ef         mov A, R7
02cc [ee 02d0]  24 7f      add A, #0x7f
02ce [ee 02d2]  60 21      jz 0x02f1
02d0 [ee 02d4]  24 fe      add A, #0xfe
02d2 [ee 02d6]  60 23      jz 0x02f7
02d4 [ee 02d8]  24 fe      add A, #0xfe
02d6 [ee 02da]  60 22      jz 0x02fa
02d8 [ee 02dc]  24 03      add A, #0x03
02da [ee 02de]  24 fa      add A, #0xfa
02dc [ee 02e0]  40 03      jc 0x02e1
02de [ee 02e2]  02 0b f3   ljmp 0x0bf3
02e1 [ee 02e5]  24 87      add A, #0x87
02e3 [ee 02e7]  70 18      jnz 0x02fd
02e5 [ee 02e9]  d2 c6      setb 0xc6
02e7 [ee 02eb]  7d 0c      mov R5, #0x0c
02e9 [ee 02ed]  af fe      mov R7, 0xfe
02eb [ee 02ef]  12 38 5c   lcall 0x385c
02ee [ee 02f2]  02 08 77   ljmp 0x0877
02f1 [ee 02f5]  85 0c 47   mov 0x47, 0x0c
02f4 [ee 02f8]  02 0b f3   ljmp 0x0bf3
02f7 [ee 02fb]  02 0b e8   ljmp 0x0be8
02fa [ee 02fe]  02 0b e3   ljmp 0x0be3
02fd [ee 0301]  c2 c6      clr 0xc6
02ff [ee 0303]  22         ret
0300 [ee 0304]  af f5      mov R7, 0xf5
0302 [ee 0306]  ef         mov A, R7
0303 [ee 0307]  14         dec A
0304 [ee 0308]  60 23      jz 0x0329
0306 [ee 030a]  24 80      add A, #0x80
0308 [ee 030c]  b4 07 00   cjne A, #0x07, 0x030b
030b [ee 030f]  50 40      jnc 0x034d
030d [ee 0311]  90 03 14   mov DPTR, #0x0314
0310 [ee 0314]  12 1f 41   lcall 0x1f41
0313 [ee 0317]  73         jmp @A + DPTR
0314 [ee 0318]  02 03 2c   ljmp 0x032c
0317 [ee 031b]  02 03 41   ljmp 0x0341
031a [ee 031e]  02 03 44   ljmp 0x0344
031d [ee 0321]  02 0b f3   ljmp 0x0bf3
0320 [ee 0324]  02 03 4a   ljmp 0x034a
0323 [ee 0327]  02 03 47   ljmp 0x0347
0326 [ee 032a]  02 03 41   ljmp 0x0341
0329 [ee 032d]  c2 c6      clr 0xc6
032b [ee 032f]  22         ret
032c [ee 0330]  90 0c 95   mov DPTR, #0x0c95
032f [ee 0333]  12 1f d8   lcall 0x1fd8
0332 [ee 0336]  8f 48      mov 0x48, R7
0334 [ee 0338]  12 12 7e   lcall 0x127e
0337 [ee 033b]  78 10      mov R0, #0x10
0339 [ee 033d]  12 12 4c   lcall 0x124c
033c [ee 0340]  8f 49      mov 0x49, R7
033e [ee 0342]  02 0b f3   ljmp 0x0bf3
0341 [ee 0345]  02 0b d1   ljmp 0x0bd1
0344 [ee 0348]  02 09 08   ljmp 0x0908
0347 [ee 034b]  02 0b e3   ljmp 0x0be3
034a [ee 034e]  02 09 b6   ljmp 0x09b6
034d [ee 0351]  c2 c6      clr 0xc6
034f [ee 0353]  22         ret
0350 [ee 0354]  af f5      mov R7, 0xf5
0352 [ee 0356]  ef         mov A, R7
0353 [ee 0357]  14         dec A
0354 [ee 0358]  60 23      jz 0x0379
0356 [ee 035a]  24 80      add A, #0x80
0358 [ee 035c]  b4 07 00   cjne A, #0x07, 0x035b
035b [ee 035f]  50 37      jnc 0x0394
035d [ee 0361]  90 03 64   mov DPTR, #0x0364
0360 [ee 0364]  12 1f 41   lcall 0x1f41
0363 [ee 0367]  73         jmp @A + DPTR
0364 [ee 0368]  02 03 85   ljmp 0x0385
0367 [ee 036b]  02 03 8b   ljmp 0x038b
036a [ee 036e]  02 03 8e   ljmp 0x038e
036d [ee 0371]  02 0b f3   ljmp 0x0bf3
0370 [ee 0374]  02 03 91   ljmp 0x0391
0373 [ee 0377]  02 0b f3   ljmp 0x0bf3
0376 [ee 037a]  02 03 82   ljmp 0x0382
0379 [ee 037d]  d2 c6      setb 0xc6
037b [ee 037f]  7d 16      mov R5, #0x16
037d [ee 0381]  7f 01      mov R7, #0x01
037f [ee 0383]  02 38 5c   ljmp 0x385c
0382 [ee 0386]  02 0b d1   ljmp 0x0bd1
0385 [ee 0389]  85 16 47   mov 0x47, 0x16
0388 [ee 038c]  02 0b f3   ljmp 0x0bf3
038b [ee 038f]  02 0b d1   ljmp 0x0bd1
038e [ee 0392]  02 09 08   ljmp 0x0908
0391 [ee 0395]  02 0b e3   ljmp 0x0be3
0394 [ee 0398]  c2 c6      clr 0xc6
0396 [ee 039a]  22         ret
0397 [ee 039b]  af f5      mov R7, 0xf5
0399 [ee 039d]  ef         mov A, R7
039a [ee 039e]  14         dec A
039b [ee 039f]  60 23      jz 0x03c0
039d [ee 03a1]  24 80      add A, #0x80
039f [ee 03a3]  b4 07 00   cjne A, #0x07, 0x03a2
03a2 [ee 03a6]  50 41      jnc 0x03e5
03a4 [ee 03a8]  90 03 ab   mov DPTR, #0x03ab
03a7 [ee 03ab]  12 1f 41   lcall 0x1f41
03aa [ee 03ae]  73         jmp @A + DPTR
03ab [ee 03af]  02 03 ce   ljmp 0x03ce
03ae [ee 03b2]  02 03 d3   ljmp 0x03d3
03b1 [ee 03b5]  02 03 d9   ljmp 0x03d9
03b4 [ee 03b8]  02 03 df   ljmp 0x03df
03b7 [ee 03bb]  02 03 e2   ljmp 0x03e2
03ba [ee 03be]  02 0b f3   ljmp 0x0bf3
03bd [ee 03c1]  02 03 cc   ljmp 0x03cc
03c0 [ee 03c4]  12 0b fd   lcall 0x0bfd
03c3 [ee 03c7]  78 81      mov R0, #0x81
03c5 [ee 03c9]  f6         mov @R0, A
03c6 [ee 03ca]  ef         mov A, R7
03c7 [ee 03cb]  08         inc R0
03c8 [ee 03cc]  f6         mov @R0, A
03c9 [ee 03cd]  02 2d 49   ljmp 0x2d49
03cc [ee 03d0]  80 0b      sjmp 0x03d9
03ce [ee 03d2]  78 81      mov R0, #0x81
03d0 [ee 03d4]  02 0a 70   ljmp 0x0a70
03d3 [ee 03d7]  90 0c 7f   mov DPTR, #0x0c7f
03d6 [ee 03da]  02 0a 63   ljmp 0x0a63
03d9 [ee 03dd]  90 0c 7b   mov DPTR, #0x0c7b
03dc [ee 03e0]  02 0a 63   ljmp 0x0a63
03df [ee 03e3]  02 0b 17   ljmp 0x0b17
03e2 [ee 03e6]  02 0b 17   ljmp 0x0b17
03e5 [ee 03e9]  c2 c6      clr 0xc6
03e7 [ee 03eb]  22         ret
03e8 [ee 03ec]  af f5      mov R7, 0xf5
03ea [ee 03ee]  ef         mov A, R7
03eb [ee 03ef]  14         dec A
03ec [ee 03f0]  60 23      jz 0x0411
03ee [ee 03f2]  24 80      add A, #0x80
03f0 [ee 03f4]  b4 07 00   cjne A, #0x07, 0x03f3
03f3 [ee 03f7]  50 3c      jnc 0x0431
03f5 [ee 03f9]  90 03 fc   mov DPTR, #0x03fc
03f8 [ee 03fc]  12 1f 41   lcall 0x1f41
03fb [ee 03ff]  73         jmp @A + DPTR
03fc [ee 0400]  02 04 1d   ljmp 0x041d
03ff [ee 0403]  02 04 22   ljmp 0x0422
0402 [ee 0406]  02 04 28   ljmp 0x0428
0405 [ee 0409]  02 04 2e   ljmp 0x042e
0408 [ee 040c]  02 04 2e   ljmp 0x042e
040b [ee 040f]  02 0b f3   ljmp 0x0bf3
040e [ee 0412]  02 04 1d   ljmp 0x041d
0411 [ee 0415]  12 0b fd   lcall 0x0bfd
0414 [ee 0418]  78 9d      mov R0, #0x9d
0416 [ee 041a]  f6         mov @R0, A
0417 [ee 041b]  ef         mov A, R7
0418 [ee 041c]  08         inc R0
0419 [ee 041d]  f6         mov @R0, A
041a [ee 041e]  02 2c 00   ljmp 0x2c00
041d [ee 0421]  78 9d      mov R0, #0x9d
041f [ee 0423]  02 0a 70   ljmp 0x0a70
0422 [ee 0426]  90 0c 81   mov DPTR, #0x0c81
0425 [ee 0429]  02 0a 83   ljmp 0x0a83
0428 [ee 042c]  90 0c 7d   mov DPTR, #0x0c7d
042b [ee 042f]  02 0a 83   ljmp 0x0a83
042e [ee 0432]  02 0b 17   ljmp 0x0b17
0431 [ee 0435]  c2 c6      clr 0xc6
0433 [ee 0437]  22         ret
0434 [ee 0438]  af f5      mov R7, 0xf5
0436 [ee 043a]  ef         mov A, R7
0437 [ee 043b]  24 7f      add A, #0x7f
0439 [ee 043d]  60 74      jz 0x04af
043b [ee 043f]  14         dec A
043c [ee 0440]  70 03      jnz 0x0441
043e [ee 0442]  02 04 d2   ljmp 0x04d2
0441 [ee 0445]  14         dec A
0442 [ee 0446]  70 03      jnz 0x0447
0444 [ee 0448]  02 04 e4   ljmp 0x04e4
0447 [ee 044b]  24 fe      add A, #0xfe
0449 [ee 044d]  70 03      jnz 0x044e
044b [ee 044f]  02 04 fe   ljmp 0x04fe
044e [ee 0452]  24 fe      add A, #0xfe
0450 [ee 0454]  60 5b      jz 0x04ad
0452 [ee 0456]  24 86      add A, #0x86
0454 [ee 0458]  60 03      jz 0x0459
0456 [ee 045a]  02 0b f3   ljmp 0x0bf3
0459 [ee 045d]  12 0c 3a   lcall 0x0c3a
045c [ee 0460]  c0 04      push 0x04
045e [ee 0462]  c0 05      push 0x05
0460 [ee 0464]  c0 06      push 0x06
0462 [ee 0466]  c0 07      push 0x07
0464 [ee 0468]  12 20 30   lcall 0x2030
0467 [ee 046b]  12 12 4c   lcall 0x124c
046a [ee 046e]  d0 03      pop 0x03
046c [ee 0470]  d0 02      pop 0x02
046e [ee 0472]  d0 01      pop 0x01
0470 [ee 0474]  d0 00      pop 0x00
0472 [ee 0476]  12 1f cb   lcall 0x1fcb
0475 [ee 0479]  c0 04      push 0x04
0477 [ee 047b]  c0 05      push 0x05
0479 [ee 047d]  c0 06      push 0x06
047b [ee 047f]  c0 07      push 0x07
047d [ee 0481]  12 20 75   lcall 0x2075
0480 [ee 0484]  d0 03      pop 0x03
0482 [ee 0486]  d0 02      pop 0x02
0484 [ee 0488]  d0 01      pop 0x01
0486 [ee 048a]  d0 00      pop 0x00
0488 [ee 048c]  12 1f cb   lcall 0x1fcb
048b [ee 048f]  c0 04      push 0x04
048d [ee 0491]  c0 05      push 0x05
048f [ee 0493]  c0 06      push 0x06
0491 [ee 0495]  c0 07      push 0x07
0493 [ee 0497]  12 20 30   lcall 0x2030
0496 [ee 049a]  12 12 5f   lcall 0x125f
0499 [ee 049d]  d0 03      pop 0x03
049b [ee 049f]  d0 02      pop 0x02
049d [ee 04a1]  d0 01      pop 0x01
049f [ee 04a3]  d0 00      pop 0x00
04a1 [ee 04a5]  12 20 5b   lcall 0x205b
04a4 [ee 04a8]  fc         mov R4, A
04a5 [ee 04a9]  78 77      mov R0, #0x77
04a7 [ee 04ab]  12 20 b0   lcall 0x20b0
04aa [ee 04ae]  02 37 5f   ljmp 0x375f
04ad [ee 04b1]  80 35      sjmp 0x04e4
04af [ee 04b3]  78 77      mov R0, #0x77
04b1 [ee 04b5]  12 12 72   lcall 0x1272
04b4 [ee 04b8]  e4         clr A
04b5 [ee 04b9]  8f 47      mov 0x47, R7
04b7 [ee 04bb]  78 77      mov R0, #0x77
04b9 [ee 04bd]  12 12 72   lcall 0x1272
04bc [ee 04c0]  12 1f e1   lcall 0x1fe1
04bf [ee 04c3]  8f 48      mov 0x48, R7
04c1 [ee 04c5]  78 77      mov R0, #0x77
04c3 [ee 04c7]  12 12 72   lcall 0x1272
04c6 [ee 04ca]  12 1f a9   lcall 0x1fa9
04c9 [ee 04cd]  8f 49      mov 0x49, R7
04cb [ee 04cf]  78 77      mov R0, #0x77
04cd [ee 04d1]  12 12 72   lcall 0x1272
04d0 [ee 04d4]  80 22      sjmp 0x04f4
04d2 [ee 04d6]  90 0c 8b   mov DPTR, #0x0c8b
04d5 [ee 04d9]  12 1f d8   lcall 0x1fd8
04d8 [ee 04dc]  8f 48      mov 0x48, R7
04da [ee 04de]  12 1f a6   lcall 0x1fa6
04dd [ee 04e1]  8f 49      mov 0x49, R7
04df [ee 04e3]  12 12 7e   lcall 0x127e
04e2 [ee 04e6]  80 10      sjmp 0x04f4
04e4 [ee 04e8]  90 0c 87   mov DPTR, #0x0c87
04e7 [ee 04eb]  12 1f d8   lcall 0x1fd8
04ea [ee 04ee]  8f 48      mov 0x48, R7
04ec [ee 04f0]  12 1f a6   lcall 0x1fa6
04ef [ee 04f3]  8f 49      mov 0x49, R7
04f1 [ee 04f5]  12 12 7e   lcall 0x127e
04f4 [ee 04f8]  78 18      mov R0, #0x18
04f6 [ee 04fa]  12 12 4c   lcall 0x124c
04f9 [ee 04fd]  8f 4a      mov 0x4a, R7
04fb [ee 04ff]  02 0b f3   ljmp 0x0bf3
04fe [ee 0502]  02 09 b6   ljmp 0x09b6
