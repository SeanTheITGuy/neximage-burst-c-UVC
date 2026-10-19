2a00 [ee 2a04]  78 7f      mov R0, #0x7f
2a02 [ee 2a06]  e4         clr A
2a03 [ee 2a07]  f6         mov @R0, A
2a04 [ee 2a08]  d8 fd      djnz R0, 0x2a03
2a06 [ee 2a0a]  75 81 ca   mov 0x81, #0xca
2a09 [ee 2a0d]  02 2a 47   ljmp 0x2a47
2a0c [ee 2a10]  02 32 4e   ljmp 0x324e
2a0f [ee 2a13]  e4         clr A
2a10 [ee 2a14]  93         movc A, @A + DPTR
2a11 [ee 2a15]  a3         inc DPTR
2a12 [ee 2a16]  f8         mov R0, A
2a13 [ee 2a17]  e4         clr A
2a14 [ee 2a18]  93         movc A, @A + DPTR
2a15 [ee 2a19]  a3         inc DPTR
2a16 [ee 2a1a]  40 03      jc 0x2a1b
2a18 [ee 2a1c]  f6         mov @R0, A
2a19 [ee 2a1d]  80 01      sjmp 0x2a1c
2a1b [ee 2a1f]  f2         movx @R0, A
2a1c [ee 2a20]  08         inc R0
2a1d [ee 2a21]  df f4      djnz R7, 0x2a13
2a1f [ee 2a23]  80 29      sjmp 0x2a4a
2a21 [ee 2a25]  e4         clr A
2a22 [ee 2a26]  93         movc A, @A + DPTR
2a23 [ee 2a27]  a3         inc DPTR
2a24 [ee 2a28]  f8         mov R0, A
2a25 [ee 2a29]  54 07      anl A, #0x07
2a27 [ee 2a2b]  24 0c      add A, #0x0c
2a29 [ee 2a2d]  c8         xch A, R0
2a2a [ee 2a2e]  c3         clr C
2a2b [ee 2a2f]  33         rlc A
2a2c [ee 2a30]  c4         swap A
2a2d [ee 2a31]  54 0f      anl A, #0x0f
2a2f [ee 2a33]  44 20      orl A, #0x20
2a31 [ee 2a35]  c8         xch A, R0
2a32 [ee 2a36]  83         movc A, @A + PC
2a33 [ee 2a37]  40 04      jc 0x2a39
2a35 [ee 2a39]  f4         cpl A
2a36 [ee 2a3a]  56         anl A, @R0
2a37 [ee 2a3b]  80 01      sjmp 0x2a3a
2a39 [ee 2a3d]  46         orl A, @R0
2a3a [ee 2a3e]  f6         mov @R0, A
2a3b [ee 2a3f]  df e4      djnz R7, 0x2a21
2a3d [ee 2a41]  80 0b      sjmp 0x2a4a
2a3f [ee 2a43]  01 02      ajmp 0x2802
2a41 [ee 2a45]  04         inc A
2a42 [ee 2a46]  08         inc R0
2a43 [ee 2a47]  10 20 40   jbc 0x20, 0x2a86
2a46 [ee 2a4a]  80 90      sjmp 0x29d8
2a48 [ee 2a4c]  26         add A, @R0
2a49 [ee 2a4d]  e9         mov A, R1
2a4a [ee 2a4e]  e4         clr A
2a4b [ee 2a4f]  7e 01      mov R6, #0x01
2a4d [ee 2a51]  93         movc A, @A + DPTR
2a4e [ee 2a52]  60 bc      jz 0x2a0c
2a50 [ee 2a54]  a3         inc DPTR
2a51 [ee 2a55]  ff         mov R7, A
2a52 [ee 2a56]  54 3f      anl A, #0x3f
2a54 [ee 2a58]  30 e5 09   jnb 0xe5, 0x2a60
2a57 [ee 2a5b]  54 1f      anl A, #0x1f
2a59 [ee 2a5d]  fe         mov R6, A
2a5a [ee 2a5e]  e4         clr A
2a5b [ee 2a5f]  93         movc A, @A + DPTR
2a5c [ee 2a60]  a3         inc DPTR
2a5d [ee 2a61]  60 01      jz 0x2a60
2a5f [ee 2a63]  0e         inc R6
2a60 [ee 2a64]  cf         xch A, R7
2a61 [ee 2a65]  54 c0      anl A, #0xc0
2a63 [ee 2a67]  25 e0      add A, 0xe0
2a65 [ee 2a69]  60 a8      jz 0x2a0f
2a67 [ee 2a6b]  40 b8      jc 0x2a21
2a69 [ee 2a6d]  e4         clr A
2a6a [ee 2a6e]  93         movc A, @A + DPTR
2a6b [ee 2a6f]  a3         inc DPTR
2a6c [ee 2a70]  fa         mov R2, A
2a6d [ee 2a71]  e4         clr A
2a6e [ee 2a72]  93         movc A, @A + DPTR
2a6f [ee 2a73]  a3         inc DPTR
2a70 [ee 2a74]  f8         mov R0, A
2a71 [ee 2a75]  e4         clr A
2a72 [ee 2a76]  93         movc A, @A + DPTR
2a73 [ee 2a77]  a3         inc DPTR
2a74 [ee 2a78]  c8         xch A, R0
2a75 [ee 2a79]  c5 82      xch A, 0x82
2a77 [ee 2a7b]  c8         xch A, R0
2a78 [ee 2a7c]  ca         xch A, R2
2a79 [ee 2a7d]  c5 83      xch A, 0x83
2a7b [ee 2a7f]  ca         xch A, R2
2a7c [ee 2a80]  f0         movx @DPTR, A
2a7d [ee 2a81]  a3         inc DPTR
2a7e [ee 2a82]  c8         xch A, R0
2a7f [ee 2a83]  c5 82      xch A, 0x82
2a81 [ee 2a85]  c8         xch A, R0
2a82 [ee 2a86]  ca         xch A, R2
2a83 [ee 2a87]  c5 83      xch A, 0x83
2a85 [ee 2a89]  ca         xch A, R2
2a86 [ee 2a8a]  df e9      djnz R7, 0x2a71
2a88 [ee 2a8c]  de e7      djnz R6, 0x2a71
2a8a [ee 2a8e]  80 be      sjmp 0x2a4a
2a8c [ee 2a90]  02 80 01   ljmp 0x8001
2a8f [ee 2a93]  e0         movx A, @DPTR
2a90 [ee 2a94]  07         inc @R1
2a91 [ee 2a95]  05 81      inc 0x81
2a93 [ee 2a97]  03         rr A
2a94 [ee 2a98]  08         inc R0
2a95 [ee 2a99]  00         nop
2a96 [ee 2a9a]  20 07 05   jb 0x07, 0x2a9e
2a99 [ee 2a9d]  81 03      ajmp 0x2c03
2a9b [ee 2a9f]  08         inc R0
2a9c [ee 2aa0]  00         nop
2a9d [ee 2aa1]  09         inc R1
2a9e [ee 2aa2]  05 25      inc 0x25
2aa0 [ee 2aa4]  03         rr A
2aa1 [ee 2aa5]  08         inc R0
2aa2 [ee 2aa6]  00         nop
2aa3 [ee 2aa7]  06         inc @R0
2aa4 [ee 2aa8]  24 0d      add A, #0x0d
2aa6 [ee 2aaa]  00         nop
2aa7 [ee 2aab]  00         nop
2aa8 [ee 2aac]  00         nop
2aa9 [ee 2aad]  07         inc @R1
2aaa [ee 2aae]  05 82      inc 0x82
2aac [ee 2ab0]  02 40 00   ljmp 0x4000
2aaf [ee 2ab3]  01 07      ajmp 0x2807
2ab1 [ee 2ab5]  05 82      inc 0x82
2ab3 [ee 2ab7]  02 00 02   ljmp 0x0002
2ab6 [ee 2aba]  01 ff      ajmp 0x28ff
2ab8 [ee 2abc]  1d         dec R5
2ab9 [ee 2abd]  ad ff      mov R5, 0xff
2abb [ee 2abf]  1d         dec R5
2abc [ee 2ac0]  b5 ff 1e   cjne A, 0xff, 0x2add
2abf [ee 2ac3]  10 ff 1d   jbc 0xff, 0x2adf
2ac2 [ee 2ac6]  cf         xch A, R7
2ac3 [ee 2ac7]  ff         mov R7, A
2ac4 [ee 2ac8]  1d         dec R5
2ac5 [ee 2ac9]  ea         mov A, R2
2ac6 [ee 2aca]  ff         mov R7, A
2ac7 [ee 2acb]  83         movc A, @A + PC
2ac8 [ee 2acc]  39         addc A, R1
2ac9 [ee 2acd]  ff         mov R7, A
2aca [ee 2ace]  83         movc A, @A + PC
2acb [ee 2acf]  53 ff 2a   anl 0xff, #0x2a
2ace [ee 2ad2]  90 ff 2a   mov DPTR, #0xff2a
2ad1 [ee 2ad5]  9e         subb A, R6
2ad2 [ee 2ad6]  ff         mov R7, A
2ad3 [ee 2ad7]  1e         dec R6
2ad4 [ee 2ad8]  29         add A, R1
2ad5 [ee 2ad9]  00         nop
2ad6 [ee 2ada]  00         nop
2ad7 [ee 2adb]  01 ff      ajmp 0x28ff
2ad9 [ee 2add]  2a         add A, R2
2ada [ee 2ade]  a3         inc DPTR
2adb [ee 2adf]  ff         mov R7, A
2adc [ee 2ae0]  2a         add A, R2
2add [ee 2ae1]  a9 00      mov R1, 0x00
2adf [ee 2ae3]  00         nop
2ae0 [ee 2ae4]  00         nop
2ae1 [ee 2ae5]  ff         mov R7, A
2ae2 [ee 2ae6]  1d         dec R5
2ae3 [ee 2ae7]  ad ff      mov R5, 0xff
2ae5 [ee 2ae9]  1d         dec R5
2ae6 [ee 2aea]  b5 ff 1e   cjne A, 0xff, 0x2b07
2ae9 [ee 2aed]  10 ff 1d   jbc 0xff, 0x2b09
2aec [ee 2af0]  cf         xch A, R7
2aed [ee 2af1]  ff         mov R7, A
2aee [ee 2af2]  1d         dec R5
2aef [ee 2af3]  ea         mov A, R2
2af0 [ee 2af4]  ff         mov R7, A
2af1 [ee 2af5]  83         movc A, @A + PC
2af2 [ee 2af6]  39         addc A, R1
2af3 [ee 2af7]  ff         mov R7, A
2af4 [ee 2af8]  83         movc A, @A + PC
2af5 [ee 2af9]  53 ff 2a   anl 0xff, #0x2a
2af8 [ee 2afc]  97         subb A, @R1
2af9 [ee 2afd]  ff         mov R7, A
2afa [ee 2afe]  2a         add A, R2
2afb [ee 2aff]  9e         subb A, R6
2afc [ee 2b00]  ff         mov R7, A
2afd [ee 2b01]  1e         dec R6
2afe [ee 2b02]  29         add A, R1
2aff [ee 2b03]  00         nop
2b00 [ee 2b04]  00         nop
2b01 [ee 2b05]  02 ff 2a   ljmp 0xff2a
2b04 [ee 2b08]  a3         inc DPTR
2b05 [ee 2b09]  ff         mov R7, A
2b06 [ee 2b0a]  2a         add A, R2
2b07 [ee 2b0b]  b0 00      anl C, /0x00
2b09 [ee 2b0d]  00         nop
2b0a [ee 2b0e]  00         nop
2b0b [ee 2b0f]  12 24 3e   lcall 0x243e
2b0e [ee 2b12]  ff         mov R7, A
2b0f [ee 2b13]  24 72      add A, #0x72
2b11 [ee 2b15]  fd         mov R5, A
2b12 [ee 2b16]  ee         mov A, R6
2b13 [ee 2b17]  34 01      addc A, #0x01
2b15 [ee 2b19]  fc         mov R4, A
2b16 [ee 2b1a]  c3         clr C
2b17 [ee 2b1b]  e4         clr A
2b18 [ee 2b1c]  9f         subb A, R7
2b19 [ee 2b1d]  cf         xch A, R7
2b1a [ee 2b1e]  74 05      mov A, #0x05
2b1c [ee 2b20]  9e         subb A, R6
2b1d [ee 2b21]  cf         xch A, R7
2b1e [ee 2b22]  2d         add A, R5
2b1f [ee 2b23]  f5 48      mov 0x48, A
2b21 [ee 2b25]  ef         mov A, R7
2b22 [ee 2b26]  3c         addc A, R4
2b23 [ee 2b27]  f5 47      mov 0x47, A
2b25 [ee 2b29]  78 9e      mov R0, #0x9e
2b27 [ee 2b2b]  e6         mov A, @R0
2b28 [ee 2b2c]  24 1e      add A, #0x1e
2b2a [ee 2b2e]  f5 4a      mov 0x4a, A
2b2c [ee 2b30]  18         dec R0
2b2d [ee 2b31]  e4         clr A
2b2e [ee 2b32]  36         addc A, @R0
2b2f [ee 2b33]  f5 49      mov 0x49, A
2b31 [ee 2b35]  78 85      mov R0, #0x85
2b33 [ee 2b37]  12 12 8e   lcall 0x128e
2b36 [ee 2b3a]  7f 00      mov R7, #0x00
2b38 [ee 2b3c]  7e e1      mov R6, #0xe1
2b3a [ee 2b3e]  7d f5      mov R5, #0xf5
2b3c [ee 2b40]  7c 05      mov R4, #0x05
2b3e [ee 2b42]  12 11 93   lcall 0x1193
2b41 [ee 2b45]  8f 82      mov 0x82, R7
2b43 [ee 2b47]  8e 83      mov 0x83, R6
2b45 [ee 2b49]  ae 49      mov R6, 0x49
2b47 [ee 2b4b]  af 4a      mov R7, 0x4a
2b49 [ee 2b4d]  ab 07      mov R3, 0x07
2b4b [ee 2b4f]  aa 06      mov R2, 0x06
2b4d [ee 2b51]  ea         mov A, R2
2b4e [ee 2b52]  33         rlc A
2b4f [ee 2b53]  95 e0      subb A, 0xe0
2b51 [ee 2b55]  f9         mov R1, A
2b52 [ee 2b56]  f8         mov R0, A
2b53 [ee 2b57]  ae 47      mov R6, 0x47
2b55 [ee 2b59]  af 48      mov R7, 0x48
2b57 [ee 2b5b]  12 23 b1   lcall 0x23b1
2b5a [ee 2b5e]  12 11 08   lcall 0x1108
2b5d [ee 2b61]  a8 04      mov R0, 0x04
2b5f [ee 2b63]  a9 05      mov R1, 0x05
2b61 [ee 2b65]  aa 06      mov R2, 0x06
2b63 [ee 2b67]  ab 07      mov R3, 0x07
2b65 [ee 2b69]  ae 83      mov R6, 0x83
2b67 [ee 2b6b]  af 82      mov R7, 0x82
2b69 [ee 2b6d]  12 23 b1   lcall 0x23b1
2b6c [ee 2b70]  12 11 08   lcall 0x1108
2b6f [ee 2b73]  e4         clr A
2b70 [ee 2b74]  7b 0a      mov R3, #0x0a
2b72 [ee 2b76]  fa         mov R2, A
2b73 [ee 2b77]  f9         mov R1, A
2b74 [ee 2b78]  f8         mov R0, A
2b75 [ee 2b79]  12 11 93   lcall 0x1193
2b78 [ee 2b7c]  78 77      mov R0, #0x77
2b7a [ee 2b7e]  12 12 9b   lcall 0x129b
2b7d [ee 2b81]  12 2d 49   lcall 0x2d49
2b80 [ee 2b84]  12 2c 00   lcall 0x2c00
2b83 [ee 2b87]  12 15 b6   lcall 0x15b6
2b86 [ee 2b8a]  02 22 15   ljmp 0x2215
2b89 [ee 2b8d]  90 01 53   mov DPTR, #0x0153
2b8c [ee 2b90]  e4         clr A
2b8d [ee 2b91]  93         movc A, @A + DPTR
2b8e [ee 2b92]  f5 1f      mov 0x1f, A
2b90 [ee 2b94]  e4         clr A
2b91 [ee 2b95]  f5 1d      mov 0x1d, A
2b93 [ee 2b97]  75 1c 01   mov 0x1c, #0x01
2b96 [ee 2b9a]  75 41 01   mov 0x41, #0x01
2b99 [ee 2b9d]  75 42 ff   mov 0x42, #0xff
2b9c [ee 2ba0]  f5 1e      mov 0x1e, A
2b9e [ee 2ba2]  c2 13      clr 0x13
2ba0 [ee 2ba4]  12 3b 06   lcall 0x3b06
2ba3 [ee 2ba7]  30 0a 38   jnb 0x0a, 0x2bde
2ba6 [ee 2baa]  75 2e 01   mov 0x2e, #0x01
2ba9 [ee 2bad]  75 2f 01   mov 0x2f, #0x01
2bac [ee 2bb0]  90 00 82   mov DPTR, #0x0082
2baf [ee 2bb3]  e4         clr A
2bb0 [ee 2bb4]  93         movc A, @A + DPTR
2bb1 [ee 2bb5]  c3         clr C
2bb2 [ee 2bb6]  13         rrc A
2bb3 [ee 2bb7]  f5 26      mov 0x26, A
2bb5 [ee 2bb9]  90 00 84   mov DPTR, #0x0084
2bb8 [ee 2bbc]  e4         clr A
2bb9 [ee 2bbd]  93         movc A, @A + DPTR
2bba [ee 2bbe]  c3         clr C
2bbb [ee 2bbf]  13         rrc A
2bbc [ee 2bc0]  f5 24      mov 0x24, A
2bbe [ee 2bc2]  a3         inc DPTR
2bbf [ee 2bc3]  e4         clr A
2bc0 [ee 2bc4]  93         movc A, @A + DPTR
2bc1 [ee 2bc5]  f5 25      mov 0x25, A
2bc3 [ee 2bc7]  a3         inc DPTR
2bc4 [ee 2bc8]  e4         clr A
2bc5 [ee 2bc9]  93         movc A, @A + DPTR
2bc6 [ee 2bca]  25 e0      add A, 0xe0
2bc8 [ee 2bcc]  f5 27      mov 0x27, A
2bca [ee 2bce]  a3         inc DPTR
2bcb [ee 2bcf]  e4         clr A
2bcc [ee 2bd0]  93         movc A, @A + DPTR
2bcd [ee 2bd1]  f5 28      mov 0x28, A
2bcf [ee 2bd3]  90 00 90   mov DPTR, #0x0090
2bd2 [ee 2bd6]  e4         clr A
2bd3 [ee 2bd7]  93         movc A, @A + DPTR
2bd4 [ee 2bd8]  60 05      jz 0x2bdb
2bd6 [ee 2bda]  75 29 01   mov 0x29, #0x01
2bd9 [ee 2bdd]  80 03      sjmp 0x2bde
2bdb [ee 2bdf]  75 29 02   mov 0x29, #0x02
2bde [ee 2be2]  75 ac 21   mov 0xac, #0x21
2be1 [ee 2be5]  e5 25      mov A, 0x25
2be3 [ee 2be7]  24 80      add A, #0x80
2be5 [ee 2be9]  f5 ad      mov 0xad, A
2be7 [ee 2beb]  75 ac 20   mov 0xac, #0x20
2bea [ee 2bee]  85 24 ad   mov 0xad, 0x24
2bed [ee 2bf1]  75 ac 22   mov 0xac, #0x22
2bf0 [ee 2bf4]  85 26 ad   mov 0xad, 0x26
2bf3 [ee 2bf7]  75 ac 25   mov 0xac, #0x25
2bf6 [ee 2bfa]  85 27 ad   mov 0xad, 0x27
2bf9 [ee 2bfd]  75 ac 14   mov 0xac, #0x14
2bfc [ee 2c00]  85 28 ad   mov 0xad, 0x28
2bff [ee 2c03]  22         ret
