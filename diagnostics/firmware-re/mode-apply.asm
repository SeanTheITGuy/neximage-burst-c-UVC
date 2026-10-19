15b6 [ee 15ba]  78 77      mov R0, #0x77
15b8 [ee 15bc]  12 12 72   lcall 0x1272
15bb [ee 15bf]  8f 5b      mov 0x5b, R7
15bd [ee 15c1]  8e 5a      mov 0x5a, R6
15bf [ee 15c3]  8d 59      mov 0x59, R5
15c1 [ee 15c5]  8c 58      mov 0x58, R4
15c3 [ee 15c7]  78 bd      mov R0, #0xbd
15c5 [ee 15c9]  76 00      mov @R0, #0x00
15c7 [ee 15cb]  08         inc R0
15c8 [ee 15cc]  76 26      mov @R0, #0x26
15ca [ee 15ce]  08         inc R0
15cb [ee 15cf]  76 01      mov @R0, #0x01
15cd [ee 15d1]  08         inc R0
15ce [ee 15d2]  76 04      mov @R0, #0x04
15d0 [ee 15d4]  08         inc R0
15d1 [ee 15d5]  76 09      mov @R0, #0x09
15d3 [ee 15d7]  78 c4      mov R0, #0xc4
15d5 [ee 15d9]  76 01      mov @R0, #0x01
15d7 [ee 15db]  76 01      mov @R0, #0x01
15d9 [ee 15dd]  78 c2      mov R0, #0xc2
15db [ee 15df]  76 00      mov @R0, #0x00
15dd [ee 15e1]  08         inc R0
15de [ee 15e2]  76 20      mov @R0, #0x20
15e0 [ee 15e4]  12 23 ff   lcall 0x23ff
15e3 [ee 15e7]  c3         clr C
15e4 [ee 15e8]  94 c0      subb A, #0xc0
15e6 [ee 15ea]  ee         mov A, R6
15e7 [ee 15eb]  64 80      xrl A, #0x80
15e9 [ee 15ed]  94 80      subb A, #0x80
15eb [ee 15ef]  40 03      jc 0x15f0
15ed [ee 15f1]  02 17 93   ljmp 0x1793
15f0 [ee 15f4]  08         inc R0
15f1 [ee 15f5]  12 24 4f   lcall 0x244f
15f4 [ee 15f8]  12 10 9a   lcall 0x109a
15f7 [ee 15fb]  12 23 b1   lcall 0x23b1
15fa [ee 15fe]  e4         clr A
15fb [ee 15ff]  7b 26      mov R3, #0x26
15fd [ee 1601]  fa         mov R2, A
15fe [ee 1602]  f9         mov R1, A
15ff [ee 1603]  f8         mov R0, A
1600 [ee 1604]  c3         clr C
1601 [ee 1605]  12 12 25   lcall 0x1225
1604 [ee 1608]  50 03      jnc 0x1609
1606 [ee 160a]  02 17 85   ljmp 0x1785
1609 [ee 160d]  78 c4      mov R0, #0xc4
160b [ee 160f]  12 24 4f   lcall 0x244f
160e [ee 1612]  12 23 ff   lcall 0x23ff
1611 [ee 1615]  12 10 9a   lcall 0x109a
1614 [ee 1618]  12 23 b1   lcall 0x23b1
1617 [ee 161b]  e4         clr A
1618 [ee 161c]  7b 13      mov R3, #0x13
161a [ee 161e]  f8         mov R0, A
161b [ee 161f]  d3         setb C
161c [ee 1620]  12 12 25   lcall 0x1225
161f [ee 1623]  40 03      jc 0x1624
1621 [ee 1625]  02 17 85   ljmp 0x1785
1624 [ee 1628]  78 c5      mov R0, #0xc5
1626 [ee 162a]  76 02      mov @R0, #0x02
1628 [ee 162c]  78 c5      mov R0, #0xc5
162a [ee 162e]  e6         mov A, @R0
162b [ee 162f]  ff         mov R7, A
162c [ee 1630]  c3         clr C
162d [ee 1631]  64 80      xrl A, #0x80
162f [ee 1633]  94 90      subb A, #0x90
1631 [ee 1635]  40 03      jc 0x1636
1633 [ee 1637]  02 17 85   ljmp 0x1785
1636 [ee 163a]  ef         mov A, R7
1637 [ee 163b]  12 23 89   lcall 0x2389
163a [ee 163e]  c0 04      push 0x04
163c [ee 1640]  12 23 80   lcall 0x2380
163f [ee 1643]  d0 00      pop 0x00
1641 [ee 1645]  12 11 08   lcall 0x1108
1644 [ee 1648]  c0 04      push 0x04
1646 [ee 164a]  c0 05      push 0x05
1648 [ee 164c]  c0 06      push 0x06
164a [ee 164e]  c0 07      push 0x07
164c [ee 1650]  12 23 aa   lcall 0x23aa
164f [ee 1653]  12 24 07   lcall 0x2407
1652 [ee 1656]  d0 03      pop 0x03
1654 [ee 1658]  d0 02      pop 0x02
1656 [ee 165a]  d0 01      pop 0x01
1658 [ee 165c]  d0 00      pop 0x00
165a [ee 165e]  12 11 93   lcall 0x1193
165d [ee 1661]  78 c7      mov R0, #0xc7
165f [ee 1663]  12 12 9b   lcall 0x129b
1662 [ee 1666]  78 77      mov R0, #0x77
1664 [ee 1668]  12 12 8e   lcall 0x128e
1667 [ee 166b]  c0 00      push 0x00
1669 [ee 166d]  78 c7      mov R0, #0xc7
166b [ee 166f]  12 12 72   lcall 0x1272
166e [ee 1672]  d0 00      pop 0x00
1670 [ee 1674]  12 11 93   lcall 0x1193
1673 [ee 1677]  78 c6      mov R0, #0xc6
1675 [ee 1679]  a6 07      mov @R0, 0x07
1677 [ee 167b]  e4         clr A
1678 [ee 167c]  7b 02      mov R3, #0x02
167a [ee 167e]  fa         mov R2, A
167b [ee 167f]  f9         mov R1, A
167c [ee 1680]  f8         mov R0, A
167d [ee 1681]  c0 00      push 0x00
167f [ee 1683]  78 77      mov R0, #0x77
1681 [ee 1685]  12 12 72   lcall 0x1272
1684 [ee 1688]  d0 00      pop 0x00
1686 [ee 168a]  12 11 93   lcall 0x1193
1689 [ee 168d]  c0 04      push 0x04
168b [ee 168f]  c0 05      push 0x05
168d [ee 1691]  c0 06      push 0x06
168f [ee 1693]  c0 07      push 0x07
1691 [ee 1695]  78 77      mov R0, #0x77
1693 [ee 1697]  12 12 8e   lcall 0x128e
1696 [ee 169a]  c0 00      push 0x00
1698 [ee 169c]  78 c7      mov R0, #0xc7
169a [ee 169e]  12 12 72   lcall 0x1272
169d [ee 16a1]  d0 00      pop 0x00
169f [ee 16a3]  12 11 93   lcall 0x1193
16a2 [ee 16a6]  d0 07      pop 0x07
16a4 [ee 16a8]  d0 06      pop 0x06
16a6 [ee 16aa]  d0 05      pop 0x05
16a8 [ee 16ac]  d0 04      pop 0x04
16aa [ee 16ae]  d3         setb C
16ab [ee 16af]  12 12 3b   lcall 0x123b
16ae [ee 16b2]  40 03      jc 0x16b3
16b0 [ee 16b4]  78 c6      mov R0, #0xc6
16b2 [ee 16b6]  06         inc @R0
16b3 [ee 16b7]  78 c6      mov R0, #0xc6
16b5 [ee 16b9]  e6         mov A, @R0
16b6 [ee 16ba]  ff         mov R7, A
16b7 [ee 16bb]  d3         setb C
16b8 [ee 16bc]  64 80      xrl A, #0x80
16ba [ee 16be]  94 90      subb A, #0x90
16bc [ee 16c0]  40 03      jc 0x16c1
16be [ee 16c2]  02 17 7e   ljmp 0x177e
16c1 [ee 16c5]  c3         clr C
16c2 [ee 16c6]  ef         mov A, R7
16c3 [ee 16c7]  64 80      xrl A, #0x80
16c5 [ee 16c9]  94 84      subb A, #0x84
16c7 [ee 16cb]  50 03      jnc 0x16cc
16c9 [ee 16cd]  02 17 7e   ljmp 0x177e
16cc [ee 16d0]  78 c5      mov R0, #0xc5
16ce [ee 16d2]  12 23 87   lcall 0x2387
16d1 [ee 16d5]  c0 04      push 0x04
16d3 [ee 16d7]  12 23 80   lcall 0x2380
16d6 [ee 16da]  d0 00      pop 0x00
16d8 [ee 16dc]  12 11 08   lcall 0x1108
16db [ee 16df]  c0 04      push 0x04
16dd [ee 16e1]  78 c6      mov R0, #0xc6
16df [ee 16e3]  12 23 81   lcall 0x2381
16e2 [ee 16e6]  d0 00      pop 0x00
16e4 [ee 16e8]  12 11 08   lcall 0x1108
16e7 [ee 16eb]  c0 04      push 0x04
16e9 [ee 16ed]  c0 05      push 0x05
16eb [ee 16ef]  c0 06      push 0x06
16ed [ee 16f1]  c0 07      push 0x07
16ef [ee 16f3]  12 23 aa   lcall 0x23aa
16f2 [ee 16f6]  12 24 07   lcall 0x2407
16f5 [ee 16f9]  d0 03      pop 0x03
16f7 [ee 16fb]  d0 02      pop 0x02
16f9 [ee 16fd]  d0 01      pop 0x01
16fb [ee 16ff]  d0 00      pop 0x00
16fd [ee 1701]  12 11 93   lcall 0x1193
1700 [ee 1704]  78 c7      mov R0, #0xc7
1702 [ee 1706]  12 12 9b   lcall 0x129b
1705 [ee 1709]  12 24 12   lcall 0x2412
1708 [ee 170c]  c0 04      push 0x04
170a [ee 170e]  c0 05      push 0x05
170c [ee 1710]  c0 06      push 0x06
170e [ee 1712]  c0 07      push 0x07
1710 [ee 1714]  78 77      mov R0, #0x77
1712 [ee 1716]  12 12 72   lcall 0x1272
1715 [ee 1719]  d0 03      pop 0x03
1717 [ee 171b]  d0 02      pop 0x02
1719 [ee 171d]  d0 01      pop 0x01
171b [ee 171f]  d0 00      pop 0x00
171d [ee 1721]  12 17 d8   lcall 0x17d8
1720 [ee 1724]  d3         setb C
1721 [ee 1725]  12 24 1e   lcall 0x241e
1724 [ee 1728]  40 3f      jc 0x1765
1726 [ee 172a]  12 24 12   lcall 0x2412
1729 [ee 172d]  c0 04      push 0x04
172b [ee 172f]  c0 05      push 0x05
172d [ee 1731]  c0 06      push 0x06
172f [ee 1733]  c0 07      push 0x07
1731 [ee 1735]  78 77      mov R0, #0x77
1733 [ee 1737]  12 12 72   lcall 0x1272
1736 [ee 173a]  d0 03      pop 0x03
1738 [ee 173c]  d0 02      pop 0x02
173a [ee 173e]  d0 01      pop 0x01
173c [ee 1740]  d0 00      pop 0x00
173e [ee 1742]  12 17 d8   lcall 0x17d8
1741 [ee 1745]  8f 5b      mov 0x5b, R7
1743 [ee 1747]  8e 5a      mov 0x5a, R6
1745 [ee 1749]  8d 59      mov 0x59, R5
1747 [ee 174b]  8c 58      mov 0x58, R4
1749 [ee 174d]  12 23 ff   lcall 0x23ff
174c [ee 1750]  78 bd      mov R0, #0xbd
174e [ee 1752]  a6 06      mov @R0, 0x06
1750 [ee 1754]  08         inc R0
1751 [ee 1755]  a6 07      mov @R0, 0x07
1753 [ee 1757]  78 c4      mov R0, #0xc4
1755 [ee 1759]  e6         mov A, @R0
1756 [ee 175a]  78 bf      mov R0, #0xbf
1758 [ee 175c]  f6         mov @R0, A
1759 [ee 175d]  78 c5      mov R0, #0xc5
175b [ee 175f]  e6         mov A, @R0
175c [ee 1760]  78 c0      mov R0, #0xc0
175e [ee 1762]  f6         mov @R0, A
175f [ee 1763]  78 c6      mov R0, #0xc6
1761 [ee 1765]  e6         mov A, @R0
1762 [ee 1766]  78 c1      mov R0, #0xc1
1764 [ee 1768]  f6         mov @R0, A
1765 [ee 1769]  e4         clr A
1766 [ee 176a]  7f e8      mov R7, #0xe8
1768 [ee 176c]  7e 03      mov R6, #0x03
176a [ee 176e]  fd         mov R5, A
176b [ee 176f]  fc         mov R4, A
176c [ee 1770]  c3         clr C
176d [ee 1771]  12 24 1e   lcall 0x241e
1770 [ee 1774]  40 2f      jc 0x17a1
1772 [ee 1776]  78 77      mov R0, #0x77
1774 [ee 1778]  12 12 72   lcall 0x1272
1777 [ee 177b]  78 c7      mov R0, #0xc7
1779 [ee 177d]  12 23 d3   lcall 0x23d3
177c [ee 1780]  40 07      jc 0x1785
177e [ee 1782]  78 c5      mov R0, #0xc5
1780 [ee 1784]  06         inc @R0
1781 [ee 1785]  06         inc @R0
1782 [ee 1786]  02 16 28   ljmp 0x1628
1785 [ee 1789]  78 c3      mov R0, #0xc3
1787 [ee 178b]  06         inc @R0
1788 [ee 178c]  e6         mov A, @R0
1789 [ee 178d]  18         dec R0
178a [ee 178e]  60 03      jz 0x178f
178c [ee 1790]  02 15 e0   ljmp 0x15e0
178f [ee 1793]  06         inc @R0
1790 [ee 1794]  02 15 e0   ljmp 0x15e0
1793 [ee 1797]  78 c4      mov R0, #0xc4
1795 [ee 1799]  06         inc @R0
1796 [ee 179a]  c3         clr C
1797 [ee 179b]  e6         mov A, @R0
1798 [ee 179c]  64 80      xrl A, #0x80
179a [ee 179e]  94 90      subb A, #0x90
179c [ee 17a0]  50 03      jnc 0x17a1
179e [ee 17a2]  02 15 d9   ljmp 0x15d9
17a1 [ee 17a5]  78 bd      mov R0, #0xbd
17a3 [ee 17a7]  e6         mov A, @R0
17a4 [ee 17a8]  fc         mov R4, A
17a5 [ee 17a9]  08         inc R0
17a6 [ee 17aa]  e6         mov A, @R0
17a7 [ee 17ab]  fd         mov R5, A
17a8 [ee 17ac]  74 30      mov A, #0x30
17aa [ee 17ae]  ff         mov R7, A
17ab [ee 17af]  fe         mov R6, A
17ac [ee 17b0]  12 2c 75   lcall 0x2c75
17af [ee 17b3]  78 bf      mov R0, #0xbf
17b1 [ee 17b5]  7f 2e      mov R7, #0x2e
17b3 [ee 17b7]  12 17 cc   lcall 0x17cc
17b6 [ee 17ba]  78 c1      mov R0, #0xc1
17b8 [ee 17bc]  7f 2a      mov R7, #0x2a
17ba [ee 17be]  12 17 cc   lcall 0x17cc
17bd [ee 17c1]  78 c0      mov R0, #0xc0
17bf [ee 17c3]  12 24 4f   lcall 0x244f
17c2 [ee 17c6]  7f 2c      mov R7, #0x2c
17c4 [ee 17c8]  7e 30      mov R6, #0x30
17c6 [ee 17ca]  12 2c 75   lcall 0x2c75
17c9 [ee 17cd]  02 3a 5d   ljmp 0x3a5d
17cc [ee 17d0]  e6         mov A, @R0
17cd [ee 17d1]  fd         mov R5, A
17ce [ee 17d2]  33         rlc A
17cf [ee 17d3]  95 e0      subb A, 0xe0
17d1 [ee 17d5]  fc         mov R4, A
17d2 [ee 17d6]  7e 30      mov R6, #0x30
17d4 [ee 17d8]  12 2c 75   lcall 0x2c75
17d7 [ee 17db]  22         ret
17d8 [ee 17dc]  c3         clr C
17d9 [ee 17dd]  ef         mov A, R7
17da [ee 17de]  9b         subb A, R3
17db [ee 17df]  ff         mov R7, A
17dc [ee 17e0]  ee         mov A, R6
17dd [ee 17e1]  9a         subb A, R2
17de [ee 17e2]  fe         mov R6, A
17df [ee 17e3]  ed         mov A, R5
17e0 [ee 17e4]  99         subb A, R1
17e1 [ee 17e5]  fd         mov R5, A
17e2 [ee 17e6]  ec         mov A, R4
17e3 [ee 17e7]  98         subb A, R0
17e4 [ee 17e8]  fc         mov R4, A
17e5 [ee 17e9]  12 00 03   lcall 0x0003
17e8 [ee 17ec]  22         ret
