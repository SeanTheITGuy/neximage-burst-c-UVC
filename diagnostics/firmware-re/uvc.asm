17e9 [ee 17ed]  af f7      mov R7, 0xf7
17eb [ee 17ef]  ef         mov A, R7
17ec [ee 17f0]  24 fe      add A, #0xfe
17ee [ee 17f2]  60 06      jz 0x17f6
17f0 [ee 17f4]  04         inc A
17f1 [ee 17f5]  60 03      jz 0x17f6
17f3 [ee 17f7]  02 19 f5   ljmp 0x19f5
17f6 [ee 17fa]  af f5      mov R7, 0xf5
17f8 [ee 17fc]  ef         mov A, R7
17f9 [ee 17fd]  14         dec A
17fa [ee 17fe]  70 03      jnz 0x17ff
17fc [ee 1800]  02 18 80   ljmp 0x1880
17ff [ee 1803]  24 80      add A, #0x80
1801 [ee 1805]  60 43      jz 0x1846
1803 [ee 1807]  24 fe      add A, #0xfe
1805 [ee 1809]  60 0b      jz 0x1812
1807 [ee 180b]  24 fc      add A, #0xfc
1809 [ee 180d]  60 07      jz 0x1812
180b [ee 180f]  24 05      add A, #0x05
180d [ee 1811]  60 03      jz 0x1812
180f [ee 1813]  02 19 f7   ljmp 0x19f7
1812 [ee 1816]  d2 c6      setb 0xc6
1814 [ee 1818]  e4         clr A
1815 [ee 1819]  f5 47      mov 0x47, A
1817 [ee 181b]  f5 48      mov 0x48, A
1819 [ee 181d]  90 2e 10   mov DPTR, #0x2e10
181c [ee 1820]  93         movc A, @A + DPTR
181d [ee 1821]  f5 49      mov 0x49, A
181f [ee 1823]  a3         inc DPTR
1820 [ee 1824]  e4         clr A
1821 [ee 1825]  93         movc A, @A + DPTR
1822 [ee 1826]  f5 4a      mov 0x4a, A
1824 [ee 1828]  90 2e 0c   mov DPTR, #0x2e0c
1827 [ee 182b]  12 12 7e   lcall 0x127e
182a [ee 182e]  e4         clr A
182b [ee 182f]  8f 4b      mov 0x4b, R7
182d [ee 1831]  12 1f de   lcall 0x1fde
1830 [ee 1834]  8f 4c      mov 0x4c, R7
1832 [ee 1836]  12 1f a6   lcall 0x1fa6
1835 [ee 1839]  8f 4d      mov 0x4d, R7
1837 [ee 183b]  12 12 7e   lcall 0x127e
183a [ee 183e]  12 1f 4c   lcall 0x1f4c
183d [ee 1841]  12 1f e8   lcall 0x1fe8
1840 [ee 1844]  12 38 e3   lcall 0x38e3
1843 [ee 1847]  d2 c3      setb 0xc3
1845 [ee 1849]  22         ret
1846 [ee 184a]  d2 c6      setb 0xc6
1848 [ee 184c]  e4         clr A
1849 [ee 184d]  f5 47      mov 0x47, A
184b [ee 184f]  f5 48      mov 0x48, A
184d [ee 1851]  78 95      mov R0, #0x95
184f [ee 1853]  e6         mov A, @R0
1850 [ee 1854]  f5 49      mov 0x49, A
1852 [ee 1856]  08         inc R0
1853 [ee 1857]  e6         mov A, @R0
1854 [ee 1858]  f5 4a      mov 0x4a, A
1856 [ee 185a]  78 85      mov R0, #0x85
1858 [ee 185c]  12 12 72   lcall 0x1272
185b [ee 185f]  e4         clr A
185c [ee 1860]  8f 4b      mov 0x4b, R7
185e [ee 1862]  78 85      mov R0, #0x85
1860 [ee 1864]  12 12 72   lcall 0x1272
1863 [ee 1867]  12 1f e1   lcall 0x1fe1
1866 [ee 186a]  8f 4c      mov 0x4c, R7
1868 [ee 186c]  78 85      mov R0, #0x85
186a [ee 186e]  12 12 72   lcall 0x1272
186d [ee 1871]  12 1f a9   lcall 0x1fa9
1870 [ee 1874]  8f 4d      mov 0x4d, R7
1872 [ee 1876]  78 85      mov R0, #0x85
1874 [ee 1878]  12 12 72   lcall 0x1272
1877 [ee 187b]  12 1f 4c   lcall 0x1f4c
187a [ee 187e]  12 1f e8   lcall 0x1fe8
187d [ee 1881]  02 38 e3   ljmp 0x38e3
1880 [ee 1884]  e4         clr A
1881 [ee 1885]  f5 69      mov 0x69, A
1883 [ee 1887]  d2 c6      setb 0xc6
1885 [ee 1889]  7d 47      mov R5, #0x47
1887 [ee 188b]  7f 22      mov R7, #0x22
1889 [ee 188d]  12 38 5c   lcall 0x385c
188c [ee 1890]  78 96      mov R0, #0x96
188e [ee 1892]  a6 4a      mov @R0, 0x4a
1890 [ee 1894]  e5 4a      mov A, 0x4a
1892 [ee 1896]  b4 04 05   cjne A, #0x04, 0x189a
1895 [ee 1899]  75 6d 05   mov 0x6d, #0x05
1898 [ee 189c]  80 03      sjmp 0x189d
189a [ee 189e]  85 4a 6d   mov 0x6d, 0x4a
189d [ee 18a1]  af 4c      mov R7, 0x4c
189f [ee 18a3]  78 08      mov R0, #0x08
18a1 [ee 18a5]  12 20 8f   lcall 0x208f
18a4 [ee 18a8]  a8 04      mov R0, 0x04
18a6 [ee 18aa]  a9 05      mov R1, 0x05
18a8 [ee 18ac]  aa 06      mov R2, 0x06
18aa [ee 18ae]  ab 07      mov R3, 0x07
18ac [ee 18b0]  eb         mov A, R3
18ad [ee 18b1]  45 4b      orl A, 0x4b
18af [ee 18b3]  ff         mov R7, A
18b0 [ee 18b4]  ea         mov A, R2
18b1 [ee 18b5]  fe         mov R6, A
18b2 [ee 18b6]  e9         mov A, R1
18b3 [ee 18b7]  fd         mov R5, A
18b4 [ee 18b8]  e8         mov A, R0
18b5 [ee 18b9]  fc         mov R4, A
18b6 [ee 18ba]  c0 04      push 0x04
18b8 [ee 18bc]  c0 05      push 0x05
18ba [ee 18be]  c0 06      push 0x06
18bc [ee 18c0]  c0 07      push 0x07
18be [ee 18c2]  af 4d      mov R7, 0x4d
18c0 [ee 18c4]  78 10      mov R0, #0x10
18c2 [ee 18c6]  12 20 8f   lcall 0x208f
18c5 [ee 18c9]  d0 03      pop 0x03
18c7 [ee 18cb]  d0 02      pop 0x02
18c9 [ee 18cd]  d0 01      pop 0x01
18cb [ee 18cf]  d0 00      pop 0x00
18cd [ee 18d1]  12 1f cb   lcall 0x1fcb
18d0 [ee 18d4]  c0 04      push 0x04
18d2 [ee 18d6]  c0 05      push 0x05
18d4 [ee 18d8]  c0 06      push 0x06
18d6 [ee 18da]  c0 07      push 0x07
18d8 [ee 18dc]  af 4e      mov R7, 0x4e
18da [ee 18de]  e4         clr A
18db [ee 18df]  fc         mov R4, A
18dc [ee 18e0]  fd         mov R5, A
18dd [ee 18e1]  fe         mov R6, A
18de [ee 18e2]  78 18      mov R0, #0x18
18e0 [ee 18e4]  12 12 5f   lcall 0x125f
18e3 [ee 18e7]  d0 03      pop 0x03
18e5 [ee 18e9]  d0 02      pop 0x02
18e7 [ee 18eb]  d0 01      pop 0x01
18e9 [ee 18ed]  d0 00      pop 0x00
18eb [ee 18ef]  12 1f cb   lcall 0x1fcb
18ee [ee 18f2]  78 85      mov R0, #0x85
18f0 [ee 18f4]  12 12 9b   lcall 0x129b
18f3 [ee 18f7]  90 32 c9   mov DPTR, #0x32c9
18f6 [ee 18fa]  e4         clr A
18f7 [ee 18fb]  93         movc A, @A + DPTR
18f8 [ee 18fc]  fb         mov R3, A
18f9 [ee 18fd]  74 01      mov A, #0x01
18fb [ee 18ff]  93         movc A, @A + DPTR
18fc [ee 1900]  fa         mov R2, A
18fd [ee 1901]  74 02      mov A, #0x02
18ff [ee 1903]  93         movc A, @A + DPTR
1900 [ee 1904]  8b 6a      mov 0x6a, R3
1902 [ee 1906]  8a 6b      mov 0x6b, R2
1904 [ee 1908]  f5 6c      mov 0x6c, A
1906 [ee 190a]  e5 6d      mov A, 0x6d
1908 [ee 190c]  75 f0 2a   mov 0xf0, #0x2a
190b [ee 190f]  a4         mul AB
190c [ee 1910]  ab 6a      mov R3, 0x6a
190e [ee 1912]  25 6c      add A, 0x6c
1910 [ee 1914]  f9         mov R1, A
1911 [ee 1915]  e5 6b      mov A, 0x6b
1913 [ee 1917]  35 f0      addc A, 0xf0
1915 [ee 1919]  fa         mov R2, A
1916 [ee 191a]  90 ff dc   mov DPTR, #0xffdc
1919 [ee 191d]  12 0f f6   lcall 0x0ff6
191c [ee 1920]  fe         mov R6, A
191d [ee 1921]  90 ff db   mov DPTR, #0xffdb
1920 [ee 1924]  12 0f f6   lcall 0x0ff6
1923 [ee 1927]  fd         mov R5, A
1924 [ee 1928]  ee         mov A, R6
1925 [ee 1929]  78 81      mov R0, #0x81
1927 [ee 192b]  f6         mov @R0, A
1928 [ee 192c]  ed         mov A, R5
1929 [ee 192d]  08         inc R0
192a [ee 192e]  f6         mov @R0, A
192b [ee 192f]  90 ff de   mov DPTR, #0xffde
192e [ee 1932]  12 0f f6   lcall 0x0ff6
1931 [ee 1935]  fe         mov R6, A
1932 [ee 1936]  90 ff dd   mov DPTR, #0xffdd
1935 [ee 1939]  12 0f f6   lcall 0x0ff6
1938 [ee 193c]  fd         mov R5, A
1939 [ee 193d]  ee         mov A, R6
193a [ee 193e]  78 9d      mov R0, #0x9d
193c [ee 1940]  f6         mov @R0, A
193d [ee 1941]  ed         mov A, R5
193e [ee 1942]  08         inc R0
193f [ee 1943]  f6         mov @R0, A
1940 [ee 1944]  e4         clr A
1941 [ee 1945]  f5 0d      mov 0x0d, A
1943 [ee 1947]  f5 0e      mov 0x0e, A
1945 [ee 1949]  f5 0f      mov 0x0f, A
1947 [ee 194b]  f5 10      mov 0x10, A
1949 [ee 194d]  f5 69      mov 0x69, A
194b [ee 194f]  12 1f b0   lcall 0x1fb0
194e [ee 1952]  12 20 96   lcall 0x2096
1951 [ee 1955]  70 03      jnz 0x1956
1953 [ee 1957]  02 19 d5   ljmp 0x19d5
1956 [ee 195a]  12 1f b0   lcall 0x1fb0
1959 [ee 195d]  12 20 9f   lcall 0x209f
195c [ee 1960]  c0 04      push 0x04
195e [ee 1962]  c0 05      push 0x05
1960 [ee 1964]  c0 06      push 0x06
1962 [ee 1966]  c0 07      push 0x07
1964 [ee 1968]  78 85      mov R0, #0x85
1966 [ee 196a]  12 12 72   lcall 0x1272
1969 [ee 196d]  d0 03      pop 0x03
196b [ee 196f]  d0 02      pop 0x02
196d [ee 1971]  d0 01      pop 0x01
196f [ee 1973]  d0 00      pop 0x00
1971 [ee 1975]  12 20 3b   lcall 0x203b
1974 [ee 1978]  33         rlc A
1975 [ee 1979]  78 96      mov R0, #0x96
1977 [ee 197b]  e6         mov A, @R0
1978 [ee 197c]  75 f0 14   mov 0xf0, #0x14
197b [ee 197f]  50 29      jnc 0x19a6
197d [ee 1981]  12 1f b6   lcall 0x1fb6
1980 [ee 1984]  12 20 9f   lcall 0x209f
1983 [ee 1987]  c0 04      push 0x04
1985 [ee 1989]  c0 05      push 0x05
1987 [ee 198b]  c0 06      push 0x06
1989 [ee 198d]  c0 07      push 0x07
198b [ee 198f]  78 85      mov R0, #0x85
198d [ee 1991]  12 12 72   lcall 0x1272
1990 [ee 1994]  d0 03      pop 0x03
1992 [ee 1996]  d0 02      pop 0x02
1994 [ee 1998]  d0 01      pop 0x01
1996 [ee 199a]  d0 00      pop 0x00
1998 [ee 199c]  12 20 3b   lcall 0x203b
199b [ee 199f]  74 ff      mov A, #0xff
199d [ee 19a1]  fb         mov R3, A
199e [ee 19a2]  fa         mov R2, A
199f [ee 19a3]  f9         mov R1, A
19a0 [ee 19a4]  f8         mov R0, A
19a1 [ee 19a5]  12 11 08   lcall 0x1108
19a4 [ee 19a8]  80 1e      sjmp 0x19c4
19a6 [ee 19aa]  12 1f b6   lcall 0x1fb6
19a9 [ee 19ad]  12 20 9f   lcall 0x209f
19ac [ee 19b0]  c0 04      push 0x04
19ae [ee 19b2]  c0 05      push 0x05
19b0 [ee 19b4]  c0 06      push 0x06
19b2 [ee 19b6]  c0 07      push 0x07
19b4 [ee 19b8]  78 85      mov R0, #0x85
19b6 [ee 19ba]  12 12 72   lcall 0x1272
19b9 [ee 19bd]  d0 03      pop 0x03
19bb [ee 19bf]  d0 02      pop 0x02
19bd [ee 19c1]  d0 01      pop 0x01
19bf [ee 19c3]  d0 00      pop 0x00
19c1 [ee 19c5]  12 20 3b   lcall 0x203b
19c4 [ee 19c8]  e4         clr A
19c5 [ee 19c9]  7b 64      mov R3, #0x64
19c7 [ee 19cb]  fa         mov R2, A
19c8 [ee 19cc]  f9         mov R1, A
19c9 [ee 19cd]  f8         mov R0, A
19ca [ee 19ce]  d3         setb C
19cb [ee 19cf]  12 12 25   lcall 0x1225
19ce [ee 19d2]  50 05      jnc 0x19d5
19d0 [ee 19d4]  05 69      inc 0x69
19d2 [ee 19d6]  02 19 4b   ljmp 0x194b
19d5 [ee 19d9]  12 1f b0   lcall 0x1fb0
19d8 [ee 19dc]  12 20 96   lcall 0x2096
19db [ee 19df]  70 02      jnz 0x19df
19dd [ee 19e1]  f5 69      mov 0x69, A
19df [ee 19e3]  78 97      mov R0, #0x97
19e1 [ee 19e5]  a6 69      mov @R0, 0x69
19e3 [ee 19e7]  18         dec R0
19e4 [ee 19e8]  12 1f b2   lcall 0x1fb2
19e7 [ee 19eb]  78 85      mov R0, #0x85
19e9 [ee 19ed]  12 12 9b   lcall 0x129b
19ec [ee 19f0]  d2 0e      setb 0x0e
19ee [ee 19f2]  75 ac 14   mov 0xac, #0x14
19f1 [ee 19f5]  75 ad 40   mov 0xad, #0x40
19f4 [ee 19f8]  22         ret
19f5 [ee 19f9]  c2 c6      clr 0xc6
19f7 [ee 19fb]  22         ret
19f8 [ee 19fc]  e4         clr A
19f9 [ee 19fd]  f5 4a      mov 0x4a, A
19fb [ee 19ff]  f5 49      mov 0x49, A
19fd [ee 1a01]  f5 48      mov 0x48, A
19ff [ee 1a03]  f5 47      mov 0x47, A
1a01 [ee 1a05]  e5 f5      mov A, 0xf5
1a03 [ee 1a07]  b4 01 03   cjne A, #0x01, 0x1a09
1a06 [ee 1a0a]  75 3c 01   mov 0x3c, #0x01
1a09 [ee 1a0d]  e5 f5      mov A, 0xf5
1a0b [ee 1a0f]  b4 84 03   cjne A, #0x84, 0x1a11
1a0e [ee 1a12]  75 47 01   mov 0x47, #0x01
1a11 [ee 1a15]  e5 f5      mov A, 0xf5
1a13 [ee 1a17]  b4 86 03   cjne A, #0x86, 0x1a19
1a16 [ee 1a1a]  75 47 03   mov 0x47, #0x03
1a19 [ee 1a1d]  af f7      mov R7, 0xf7
1a1b [ee 1a1f]  ef         mov A, R7
1a1c [ee 1a20]  24 fe      add A, #0xfe
1a1e [ee 1a22]  70 03      jnz 0x1a23
1a20 [ee 1a24]  02 1b 9e   ljmp 0x1b9e
1a23 [ee 1a27]  24 fe      add A, #0xfe
1a25 [ee 1a29]  70 03      jnz 0x1a2a
1a27 [ee 1a2b]  02 1a e1   ljmp 0x1ae1
1a2a [ee 1a2e]  24 f8      add A, #0xf8
1a2c [ee 1a30]  70 03      jnz 0x1a31
1a2e [ee 1a32]  02 1b 36   ljmp 0x1b36
1a31 [ee 1a35]  24 ec      add A, #0xec
1a33 [ee 1a37]  70 03      jnz 0x1a38
1a35 [ee 1a39]  02 1a bc   ljmp 0x1abc
1a38 [ee 1a3c]  24 fe      add A, #0xfe
1a3a [ee 1a3e]  60 50      jz 0x1a8c
1a3c [ee 1a40]  04         inc A
1a3d [ee 1a41]  60 03      jz 0x1a42
1a3f [ee 1a43]  02 1b fa   ljmp 0x1bfa
1a42 [ee 1a46]  12 20 53   lcall 0x2053
1a45 [ee 1a49]  60 26      jz 0x1a6d
1a47 [ee 1a4b]  14         dec A
1a48 [ee 1a4c]  60 2b      jz 0x1a75
1a4a [ee 1a4e]  14         dec A
1a4b [ee 1a4f]  60 2e      jz 0x1a7b
1a4d [ee 1a51]  24 fe      add A, #0xfe
1a4f [ee 1a53]  60 35      jz 0x1a86
1a51 [ee 1a55]  24 fe      add A, #0xfe
1a53 [ee 1a57]  60 20      jz 0x1a75
1a55 [ee 1a59]  24 86      add A, #0x86
1a57 [ee 1a5b]  70 60      jnz 0x1ab9
1a59 [ee 1a5d]  7d 4b      mov R5, #0x4b
1a5b [ee 1a5f]  7f 02      mov R7, #0x02
1a5d [ee 1a61]  12 38 5c   lcall 0x385c
1a60 [ee 1a64]  78 a1      mov R0, #0xa1
1a62 [ee 1a66]  76 00      mov @R0, #0x00
1a64 [ee 1a68]  08         inc R0
1a65 [ee 1a69]  76 03      mov @R0, #0x03
1a67 [ee 1a6b]  12 3c 9c   lcall 0x3c9c
1a6a [ee 1a6e]  02 2d 49   ljmp 0x2d49
1a6d [ee 1a71]  78 a1      mov R0, #0xa1
1a6f [ee 1a73]  e6         mov A, @R0
1a70 [ee 1a74]  fe         mov R6, A
1a71 [ee 1a75]  08         inc R0
1a72 [ee 1a76]  e6         mov A, @R0
1a73 [ee 1a77]  80 09      sjmp 0x1a7e
1a75 [ee 1a79]  e4         clr A
1a76 [ee 1a7a]  f5 47      mov 0x47, A
1a78 [ee 1a7c]  02 1b f3   ljmp 0x1bf3
1a7b [ee 1a7f]  12 20 49   lcall 0x2049
1a7e [ee 1a82]  f5 47      mov 0x47, A
1a80 [ee 1a84]  ee         mov A, R6
1a81 [ee 1a85]  f5 48      mov 0x48, A
1a83 [ee 1a87]  02 1b f3   ljmp 0x1bf3
1a86 [ee 1a8a]  75 47 02   mov 0x47, #0x02
1a89 [ee 1a8d]  02 1b f3   ljmp 0x1bf3
1a8c [ee 1a90]  12 20 53   lcall 0x2053
1a8f [ee 1a93]  60 11      jz 0x1aa2
1a91 [ee 1a95]  14         dec A
1a92 [ee 1a96]  60 1a      jz 0x1aae
1a94 [ee 1a98]  14         dec A
1a95 [ee 1a99]  60 1c      jz 0x1ab3
1a97 [ee 1a9b]  24 fc      add A, #0xfc
1a99 [ee 1a9d]  60 11      jz 0x1aac
1a9b [ee 1a9f]  24 86      add A, #0x86
1a9d [ee 1aa1]  70 1a      jnz 0x1ab9
1a9f [ee 1aa3]  c2 c6      clr 0xc6
1aa1 [ee 1aa5]  22         ret
1aa2 [ee 1aa6]  12 20 49   lcall 0x2049
1aa5 [ee 1aa9]  f5 47      mov 0x47, A
1aa7 [ee 1aab]  ee         mov A, R6
1aa8 [ee 1aac]  f5 48      mov 0x48, A
1aaa [ee 1aae]  80 0d      sjmp 0x1ab9
1aac [ee 1ab0]  80 00      sjmp 0x1aae
1aae [ee 1ab2]  e4         clr A
1aaf [ee 1ab3]  f5 47      mov 0x47, A
1ab1 [ee 1ab5]  80 06      sjmp 0x1ab9
1ab3 [ee 1ab7]  75 47 ff   mov 0x47, #0xff
1ab6 [ee 1aba]  75 48 ff   mov 0x48, #0xff
1ab9 [ee 1abd]  02 1b f3   ljmp 0x1bf3
1abc [ee 1ac0]  12 20 53   lcall 0x2053
1abf [ee 1ac3]  60 11      jz 0x1ad2
1ac1 [ee 1ac5]  14         dec A
1ac2 [ee 1ac6]  60 12      jz 0x1ad6
1ac4 [ee 1ac8]  14         dec A
1ac5 [ee 1ac9]  60 14      jz 0x1adb
1ac7 [ee 1acb]  24 fc      add A, #0xfc
1ac9 [ee 1acd]  60 09      jz 0x1ad4
1acb [ee 1acf]  24 86      add A, #0x86
1acd [ee 1ad1]  70 0f      jnz 0x1ade
1acf [ee 1ad3]  c2 c6      clr 0xc6
1ad1 [ee 1ad5]  22         ret
1ad2 [ee 1ad6]  80 07      sjmp 0x1adb
1ad4 [ee 1ad8]  80 00      sjmp 0x1ad6
1ad6 [ee 1ada]  e4         clr A
1ad7 [ee 1adb]  f5 47      mov 0x47, A
1ad9 [ee 1add]  80 03      sjmp 0x1ade
1adb [ee 1adf]  75 47 02   mov 0x47, #0x02
1ade [ee 1ae2]  02 1b f3   ljmp 0x1bf3
1ae1 [ee 1ae5]  12 20 53   lcall 0x2053
1ae4 [ee 1ae8]  60 29      jz 0x1b0f
1ae6 [ee 1aea]  14         dec A
1ae7 [ee 1aeb]  60 30      jz 0x1b19
1ae9 [ee 1aed]  14         dec A
1aea [ee 1aee]  60 37      jz 0x1b23
1aec [ee 1af0]  24 fe      add A, #0xfe
1aee [ee 1af2]  60 40      jz 0x1b30
1af0 [ee 1af4]  24 fe      add A, #0xfe
1af2 [ee 1af6]  60 16      jz 0x1b0a
1af4 [ee 1af8]  24 86      add A, #0x86
1af6 [ee 1afa]  70 3b      jnz 0x1b33
1af8 [ee 1afc]  7d 4b      mov R5, #0x4b
1afa [ee 1afe]  7f 02      mov R7, #0x02
1afc [ee 1b00]  12 38 5c   lcall 0x385c
1aff [ee 1b03]  e5 4c      mov A, 0x4c
1b01 [ee 1b05]  f5 09      mov 0x09, A
1b03 [ee 1b07]  e5 4b      mov A, 0x4b
1b05 [ee 1b09]  f5 0a      mov 0x0a, A
1b07 [ee 1b0b]  02 2c e0   ljmp 0x2ce0
1b0a [ee 1b0e]  75 47 10   mov 0x47, #0x10
1b0d [ee 1b11]  80 24      sjmp 0x1b33
1b0f [ee 1b13]  e5 0a      mov A, 0x0a
1b11 [ee 1b15]  f5 47      mov 0x47, A
1b13 [ee 1b17]  e5 09      mov A, 0x09
1b15 [ee 1b19]  f5 48      mov 0x48, A
1b17 [ee 1b1b]  80 1a      sjmp 0x1b33
1b19 [ee 1b1d]  90 0c 99   mov DPTR, #0x0c99
1b1c [ee 1b20]  74 01      mov A, #0x01
1b1e [ee 1b22]  93         movc A, @A + DPTR
1b1f [ee 1b23]  f5 47      mov 0x47, A
1b21 [ee 1b25]  80 10      sjmp 0x1b33
1b23 [ee 1b27]  90 0c 9b   mov DPTR, #0x0c9b
1b26 [ee 1b2a]  12 20 4c   lcall 0x204c
1b29 [ee 1b2d]  f5 47      mov 0x47, A
1b2b [ee 1b2f]  ee         mov A, R6
1b2c [ee 1b30]  f5 48      mov 0x48, A
1b2e [ee 1b32]  80 03      sjmp 0x1b33
1b30 [ee 1b34]  75 47 02   mov 0x47, #0x02
1b33 [ee 1b37]  02 1b f3   ljmp 0x1bf3
1b36 [ee 1b3a]  12 20 53   lcall 0x2053
1b39 [ee 1b3d]  60 3f      jz 0x1b7a
1b3b [ee 1b3f]  14         dec A
1b3c [ee 1b40]  60 48      jz 0x1b86
1b3e [ee 1b42]  14         dec A
1b3f [ee 1b43]  60 50      jz 0x1b91
1b41 [ee 1b45]  24 fc      add A, #0xfc
1b43 [ee 1b47]  60 2e      jz 0x1b73
1b45 [ee 1b49]  24 86      add A, #0x86
1b47 [ee 1b4b]  70 53      jnz 0x1b9c
1b49 [ee 1b4d]  d2 c6      setb 0xc6
1b4b [ee 1b4f]  7d 4b      mov R5, #0x4b
1b4d [ee 1b51]  7f 04      mov R7, #0x04
1b4f [ee 1b53]  12 38 5c   lcall 0x385c
1b52 [ee 1b56]  af 4e      mov R7, 0x4e
1b54 [ee 1b58]  ae 4d      mov R6, 0x4d
1b56 [ee 1b5a]  ad 4c      mov R5, 0x4c
1b58 [ee 1b5c]  ac 4b      mov R4, 0x4b
1b5a [ee 1b5e]  12 1f e1   lcall 0x1fe1
1b5d [ee 1b61]  78 7b      mov R0, #0x7b
1b5f [ee 1b63]  a6 07      mov @R0, 0x07
1b61 [ee 1b65]  af 4e      mov R7, 0x4e
1b63 [ee 1b67]  ae 4d      mov R6, 0x4d
1b65 [ee 1b69]  ad 4c      mov R5, 0x4c
1b67 [ee 1b6b]  ac 4b      mov R4, 0x4b
1b69 [ee 1b6d]  78 18      mov R0, #0x18
1b6b [ee 1b6f]  12 12 4c   lcall 0x124c
1b6e [ee 1b72]  78 80      mov R0, #0x80
1b70 [ee 1b74]  a6 07      mov @R0, 0x07
1b72 [ee 1b76]  22         ret
1b73 [ee 1b77]  e4         clr A
1b74 [ee 1b78]  f5 47      mov 0x47, A
1b76 [ee 1b7a]  f5 49      mov 0x49, A
1b78 [ee 1b7c]  80 22      sjmp 0x1b9c
1b7a [ee 1b7e]  78 7b      mov R0, #0x7b
1b7c [ee 1b80]  e6         mov A, @R0
1b7d [ee 1b81]  f5 47      mov 0x47, A
1b7f [ee 1b83]  78 80      mov R0, #0x80
1b81 [ee 1b85]  e6         mov A, @R0
1b82 [ee 1b86]  f5 49      mov 0x49, A
1b84 [ee 1b88]  80 16      sjmp 0x1b9c
1b86 [ee 1b8a]  e4         clr A
1b87 [ee 1b8b]  f5 47      mov 0x47, A
1b89 [ee 1b8d]  f5 48      mov 0x48, A
1b8b [ee 1b8f]  f5 49      mov 0x49, A
1b8d [ee 1b91]  f5 4a      mov 0x4a, A
1b8f [ee 1b93]  80 0b      sjmp 0x1b9c
1b91 [ee 1b95]  75 47 78   mov 0x47, #0x78
1b94 [ee 1b98]  e4         clr A
1b95 [ee 1b99]  f5 48      mov 0x48, A
1b97 [ee 1b9b]  75 49 78   mov 0x49, #0x78
1b9a [ee 1b9e]  f5 4a      mov 0x4a, A
1b9c [ee 1ba0]  80 55      sjmp 0x1bf3
1b9e [ee 1ba2]  d2 c6      setb 0xc6
1ba0 [ee 1ba4]  af f5      mov R7, 0xf5
1ba2 [ee 1ba6]  ef         mov A, R7
1ba3 [ee 1ba7]  14         dec A
1ba4 [ee 1ba8]  60 23      jz 0x1bc9
1ba6 [ee 1baa]  24 80      add A, #0x80
1ba8 [ee 1bac]  b4 07 00   cjne A, #0x07, 0x1bab
1bab [ee 1baf]  50 46      jnc 0x1bf3
