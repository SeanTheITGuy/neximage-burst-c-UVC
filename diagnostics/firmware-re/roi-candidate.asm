18f3 [ee 18f7]  78 96      mov R0, #0x96
18f5 [ee 18f9]  e6         mov A, @R0
18f6 [ee 18fa]  b4 01 02   cjne A, #0x01, 0x18fb
18f9 [ee 18fd]  80 09      sjmp 0x1904
18fb [ee 18ff]  b4 02 02   cjne A, #0x02, 0x1900
18fe [ee 1902]  80 04      sjmp 0x1904
1900 [ee 1904]  b4 04 37   cjne A, #0x04, 0x193a
1903 [ee 1907]  14         dec A
1904 [ee 1908]  75 f0 03   mov 0xf0, #0x03
1907 [ee 190b]  a4         mul AB
1908 [ee 190c]  24 c9      add A, #0xc9
190a [ee 190e]  f5 82      mov 0x82, A
190c [ee 1910]  e5 f0      mov A, 0xf0
190e [ee 1912]  34 32      addc A, #0x32
1910 [ee 1914]  f5 83      mov 0x83, A
1912 [ee 1916]  a3         inc DPTR
1913 [ee 1917]  e4         clr A
1914 [ee 1918]  93         movc A, @A + DPTR
1915 [ee 1919]  fa         mov R2, A
1916 [ee 191a]  a3         inc DPTR
1917 [ee 191b]  e4         clr A
1918 [ee 191c]  93         movc A, @A + DPTR
1919 [ee 191d]  f5 82      mov 0x82, A
191b [ee 191f]  8a 83      mov 0x83, R2
191d [ee 1921]  74 05      mov A, #0x05
191f [ee 1923]  93         movc A, @A + DPTR
1920 [ee 1924]  ff         mov R7, A
1921 [ee 1925]  74 06      mov A, #0x06
1923 [ee 1927]  93         movc A, @A + DPTR
1924 [ee 1928]  78 81      mov R0, #0x81
1926 [ee 192a]  f6         mov @R0, A
1927 [ee 192b]  08         inc R0
1928 [ee 192c]  a6 07      mov @R0, 0x07
192a [ee 192e]  74 07      mov A, #0x07
192c [ee 1930]  93         movc A, @A + DPTR
192d [ee 1931]  ff         mov R7, A
192e [ee 1932]  74 08      mov A, #0x08
1930 [ee 1934]  93         movc A, @A + DPTR
1931 [ee 1935]  78 9d      mov R0, #0x9d
1933 [ee 1937]  f6         mov @R0, A
1934 [ee 1938]  08         inc R0
1935 [ee 1939]  a6 07      mov @R0, 0x07
1937 [ee 193b]  02 19 40   ljmp 0x1940
193a [ee 193e]  c2 c6      clr 0xc6
193c [ee 1940]  22         ret
193d [ee 1941]  00         nop
193e [ee 1942]  00         nop
193f [ee 1943]  00         nop
