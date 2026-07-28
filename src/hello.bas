10 rem hello.bas - edit this in VSCode, run it in Hatari
20 rem sync (Ctrl+Shift+B), then in STOS:  load "HELLO.ASC"  then  run
30 mode 0
40 paper 0 : ink 1 : cls : hide
50 locate 0,3 : centre "H E L L O   F R O M   V S C O D E"
60 locate 0,6 : centre "STOS Basic on the Atari ST"
70 locate 0,9 : centre "Hatari + GEMDOS hard-drive workflow"
80 locate 0,14 : centre "edit  src/hello.bas"
90 locate 0,16 : centre "then:  load  and  run"
100 p = 1
110 for c = 0 to 400
120 ink p
130 locate 0,20 : centre "press a key to stop"
140 p = p + 1 : if p > 15 then p = 1
150 for d = 1 to 4 : wait vbl : next d
160 next c
170 wait key
