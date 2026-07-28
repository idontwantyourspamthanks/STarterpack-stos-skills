# Missing Link commands: Miscellaneous

All addresses must be "actual": use `start(bank)` for memory banks. RASTER, HERTZ, SET HERTZ and MOSTLY HARMLESS come from the registration-version update (UPDATE.DOC).

## COMPSTATE
`d = COMPSTATE` — return the current state of your program: compiled or interpreted.

- **d**: TRUE if the program is compiled, FALSE if running under the interpreter

Makes life much easier when writing or debugging: e.g. display 10 sprites when running in BASIC but 20 when compiled, only play music in the compiled version, or adjust timing loops so the program runs at the same speed either way (the compiler speeds variable handling up, so a countdown loop needs a larger start value when compiled).

### Example
```stos
10 if not(compstate) then print "In BASIC" : end
20 print "Compiled!"
```

### Gotchas
- To check whether a program is compiled to GEM, use the "hidden" compiler-extension command `COMPAD`, which returns a negative number for GEM-compiled programs.

## RELOCATE
`RELOCATE padr` — alter an executable program so it can run from any address.

- **padr**: address of the program to relocate

Normally STOS only lets you CALL a program if it is reserved as a program bank. With RELOCATE you can BLOAD the program to any address or bank and still call it.

### Example
```stos
10 bload "my_prog.prg",back
20 relocate back
30 call back+28
```

### Gotchas
- The official doc calls at `back+28` (skipping the 28-byte .PRG header); the community tutorial's example calls at `back` — see errata.md.

**See also:** COMPSTATE

## BOUNDARY
`r = BOUNDARY (n)` — round a number down to its nearest 16-pixel boundary.

- **n**: the number to round down
- **r**: the rounded number

Very useful for restoring sprite backgrounds, since screen X-coordinates for block operations must be multiples of 16. Much, much quicker than the STOS `X=X/16*16` equivalent.

### Example
```stos
10 home : print boundary(x mouse);"   "
20 wait vbl : goto 10
```

### Gotchas
- The community tutorial claims BOUNDARY rounds to the *nearest* boundary (11 -> 16, 25 -> 32). The official doc says it rounds *down* (11 -> 0, 25 -> 16). The official doc wins — see errata.md.

**See also:** OVERLAP

## OVERLAP
`r = OVERLAP (x1,y1,x2,y2,wd1,hg1,wd2,hg2)` — fast collision check between two rectangular blocks.

- **x1,y1**: top-left of the first rectangle
- **x2,y2**: top-left of the second rectangle
- **wd1,hg1**: width and height of the first rectangle
- **wd2,hg2**: width and height of the second rectangle
- **r**: non-zero if the rectangles overlap

Useful for checking whether a bullet or sprite has reached a certain part of the screen. If you use sprites, keep the hot spot in the top-left corner so the sprite position matches the rectangle origin (bobs always have their hot spot there).

### Example
```stos
10 repeat
20 if overlap(x mouse,y mouse,144,84,16,16,32,32) then bell
30 until mouse key=1
```

**See also:** BOUNDARY

## REBOOT
`REBOOT n` — reset the machine, clearing ram-disks and reset-resident programs.

- **n**: pass $ABCD to skip the confirmation requester; anything else asks first

Performs a cold boot. There is a double check where the program asks if you want to proceed; pass N as $ABCD to skip it.

### Example
```stos
10 reboot 0
```
```stos
10 reboot $ABCD
```

### Gotchas
- Originally called "cold boot", but STOS tokenised it into "col DBOOT" when entered — hence REBOOT.

## HERTZ
`freq = HERTZ` — return the current screen frequency.

- **freq**: the monitor frequency in Hz

**Registered version only.**

### Example
```stos
10 H=hertz
```

### Gotchas
- **Registered version only.**
- The community tutorial spells it "HERZ" and claims it also returns 70 for mono monitors; UPDATE.DOC documents only 50/60 Hz handling — see errata.md.

**See also:** SET HERTZ, RASTER

## SET HERTZ
`SET HERTZ freq` — set the monitor frequency.

- **freq**: frequency to set — 50 or 60

**Registered version only.**

### Example
```stos
10 wait vbl : set hertz 50
```

### Gotchas
- **Registered version only.**
- UPDATE.DOC's example reads `set freq 50` — a typo for SET HERTZ (see errata.md).
- Sync with `wait vbl` before switching, as in the official example.

**See also:** HERTZ

## RASTER
`RASTER flag,coladr,line,wid,num,col` — change a single colour register at given scanlines.

- **flag**: on/off flag — 1 is on, 0 is off
- **coladr**: address of the colour data (one word per colour)
- **line**: scanline to start the raster on
- **wid**: how far apart each raster occurs
- **num**: number of rasters to do
- **col**: colour register to change (0-15)

**Registered version only.**

Used the same way as PALSPLIT, but changes one colour rather than the whole palette. Great for "parallax" skies and multi-coloured text in intros. Turn it off with `raster 0,0,0,0,0,0`.

### Example
```stos
10 reserve as work 10,512*2
15 H=0
20 for R=0 to 7 : for G=0 to 7 : for B=0 to 7
30 doke start(10)+H,R*256+G*16+B
40 H=H+2
50 next B : next G : next R
60 raster 1,start(10)+H,1,1,199,0
70 H=H+2 : if H>311*2 then H=0
80 wait vbl
90 raster 0,0,0,0,0,0
100 if inkey$<>" " then goto 60
```

### Gotchas
- **Registered version only.**
- The UPDATE.DOC example (reproduced verbatim above) looks internally inconsistent — the colour-data pointer uses H after the loop has run it to the end of the buffer, and lines 70-90 sit behind the raster-on call. Treat it as illustrative only; see errata.md.

**See also:** PALSPLIT, HERTZ

## MOSTLY HARMLESS
`a = MOSTLY HARMLESS (1,2,3,4,5)` — suppress the shareware nag message.

**Registered version only.**

Kills the "This message will not appear when you register" requester that pops up while editing. Put it in your AUTOEXEC file: save a BASIC file called AUTOEXEC.BAS in the root directory containing the example below.

### Example
```stos
10 A=mostly harmless(1,2,3,4,5)
```

### Gotchas
- **Registered version only.** The parameters are a fixed magic sequence — pass exactly 1,2,3,4,5.
