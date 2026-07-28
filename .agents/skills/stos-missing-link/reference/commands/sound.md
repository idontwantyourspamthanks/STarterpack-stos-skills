# Missing Link commands: Sound

All addresses must be "actual": use `start(bank)` for memory banks. DIGIPLAY, MUSAUTO and MUSPLAY all run on interrupt; if the program crashes while one is active, changing program area (HELP, then a different program) stops the interrupt — save before testing new interrupt code.

## DIGIPLAY
`DIGIPLAY md,sadr,sz,freq,lp` — replay sampled sound on interrupt.

- **md**: mode — 1 is on, 0 is off
- **sadr**: address of the sample (or of a digibank)
- **sz**: sample size in bytes — or a digibank sample number (see below)
- **freq**: playback frequency, 3-25 KHz
- **lp**: loop flag — 1 loops, 0 plays once

DIGIPLAY takes less processor time than Maestro and covers quite a few of its commands in one. If the sample plays through its whole length it is automatically stopped, unless looping is on. Samples must be BLOADed raw.

The third parameter has two meanings: if it is **greater than 50** it is the sample SIZE in bytes and a raw sample at SADR is played; if it is **50 or less** it is a SAMPLE NUMBER in a digibank held at SADR. Digibanks are made with the MAKE utility and hold up to 50 samples in one file, numbered from 0 (sample 1 becomes 0, sample 2 becomes 1, and so on).

### Example
```stos
10 bload "sample.sam",back
20 digiplay 1,back,32000,10,1
30 repeat : until inkey$=" "
40 digiplay 0,0,0,0,0
```

Playing sample 2 (the third sample) from a digibank in bank 5:
```stos
10 reserve as work 5,30000 : bload "sambank.mbk",5
20 digiplay 1,start(5),2,10,1
```

### Gotchas
- Digibank sample numbers start from 0, unlike Maestro's SAMPLAY.
- If a sample sounds distorted, it is probably in the wrong signed/unsigned format — fix it with SAMSIGN.

**See also:** SAMSIGN, MUSPLAY

## SAMSIGN
`SAMSIGN sadr,sz` — convert a sample between signed and unsigned formats.

- **sadr**: address of the sample data
- **sz**: length of the sample in bytes

Especially useful if you have something like Master Sound 2, where you normally have to press CTRL-S before saving the sample out to use it. If a sample sounds distorted when played with DIGIPLAY, run SAMSIGN over it (or use the (UN)SIGN SAMPLE option when building a digibank in MAKE).

### Example
```stos
10 bload "sample.sam",back
20 samsign back,32000
```

**See also:** DIGIPLAY

## MUSAUTO
`r = MUSAUTO (adr,num,size)` — auto-detect and play chip music on interrupt.

- **adr**: address of the music file
- **num**: music number to play (if the file holds several tunes); pass 0 to turn the music off
- **size**: size of the music file
- **r**: the music type detected (see list below)

MUSAUTO plays "good" music back from STOS on interrupt. It examines the music's offset and sets itself up for that driver automatically — no need to know the play offset. It detects some 21 kinds of chip music; the value returned signifies the type:

```text
1. Mad Max              11. Megatizer           21. Nexus
2. Count Zero           12. Synth Dream
3. Lap #1               13. Big Alec #2
4. Lap #2               14. Ben Daglish
5. Big Alec #1          15. Lary
6. Ninja Turtle         16. Reserved
7. Zound Dragger        17. Reserved
8. TAO (chip #1)        18. Lap (1 scanline)
9. Titan                19. TAO (digidrum)
10. LTK                 20. TAO (chip #2)
```

### Example
```stos
10 reserve as work 10,50000
20 F$=fileselect$("*.MU?")
30 if F$="" then end
40 open in #1,F$ : L=lof(#1) : close #1
45 bload F$,10
50 N=musauto(start(10),1,L)
60 wait key
70 N=musauto(0,0,0)
80 goto 20
```

### Gotchas
- **The registered version returns different type numbers.** The updated MUSAUTO recognises more drivers (31 types) and renumbers them: 1-2 Mad Max, 3 Count Zero, 4 Big Alec (old), 5-7 TAO (chip #1/chip #2/digi), 8 Lap (1990), 9 Lap (1991), 10 Big Alec (new), 11 Megatizer, 12 Undead, 13 Zound Dragger, 14 Titan, 15 LTK, 16 TriMod, 17 Lap (1 scanline), 18 Synth Dream, 19 Ben Daglish, 20 Nexus, 21-22 Chrispy Noodle #1/#2, 23 MUF/SMF, 24 Misfit, 25 Blipp Blopper, 26 G.S.R Format, 27 FFT, 28 Crusader, 29 Newline, 30 Millenium Brothers, 31 Synergy. Do not write programs that depend on the v1.0 numbers.
- Registered version: type 23 (MUF/SMF) is recognised by file extension, which MUSAUTO never sees, so it is never returned — play those files with `musplay start(10),1,4` instead.

**See also:** MUSPLAY

## MUSPLAY
`MUSPLAY adr,num,offset` — play chip music on interrupt with an explicit play offset.

- **adr**: address of the music file
- **num**: music number; pass 0 to turn the music off
- **offset**: the play offset (e.g. 8 for Mad Max)

For music which MUSAUTO doesn't recognise, provided you know the play offset. Also useful for sound effects in games, as it doesn't have to work out the music type and so takes less time to initialise than MUSAUTO.

### Example
```stos
10 reserve as work 10,50000
20 bload "COUNT_0.MUS",10
30 musplay start(10),1,6
40 repeat : until inkey$=" "
50 musplay start(10),0,2
```

### Gotchas
- The community tutorial claims the Mad Max offset is 1; the official doc says 8. The official doc wins — see errata.md.

**See also:** MUSAUTO, DIGIPLAY
