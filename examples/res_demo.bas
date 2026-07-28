10 rem res_demo.bas - taken verbatim from the STOS manual (known-good)
20 rem try it: copy to src/ and Ctrl+Shift+B, or load directly in STOS
30 rem demonstrates: MODE, IF/THEN, CENTRE, LOCATE, WAIT KEY, REM
40 if mode=2 then stop: rem high resolution not supported
50 if mode=0 then mode=1: rem enter medium resolution
60 centre "Medium Resolution"
70 locate 0,4: centre "Press a key"
80 wait key
90 mode 0
100 centre "Low resolution"
110 wait key
