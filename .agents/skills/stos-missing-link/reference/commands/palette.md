# Missing Link commands: Palette

All addresses passed to these commands must be "actual" addresses: use `start(bank)` for memory banks, not the bank number. PALSPLIT runs on interrupt; if the program crashes while it is active, changing program area (HELP, then a different program) stops the interrupt — save before testing new interrupt code.

## PALT
`r = PALT (gadr)` — fetch the palette from a Missing Link / STOS graphics file.

- **gadr**: address of the .MBK file (sprite bank, bob bank, picture, etc.)
- **r**: returned address of the palette data

PALT gets the palette from various .MBK files automatically. It searches for the "PALT" string which is found in STOS sprite banks and in all of the Missing Link's graphic files. Similar to `GET PALETTE`, but it captures the palette from an MBK file or bank — pictures, sprites, bobs, joeys, tiles, blocks — rather than from a screen, so it can replace the usual sprite-bank palette routine. After a `get palette` from a screen you can use PALT as many times as you like to pull palettes from banks.

### Example
```stos
10 load "sprite.mbk",1
20 D=palt(start(1)) : wait vbl
```

**See also:** PALSPLIT, FLOODPAL, BRIGHTEST

## PALSPLIT
`PALSPLIT md,cadr,y,hig,num` — split the palette at given scanlines so different screen areas use different palettes.

- **md**: mode — 0 is off, 1 is on
- **cadr**: address of the palette data (each palette is 16 words of colour data)
- **y**: starting scanline for the palette split
- **hig**: number of scanlines to split over (199 for a full screen)
- **num**: number of palette splits to do

PALSPLIT gives you separate palettes for different areas of the screen — for instance a 16-colour logo at the top, a 16-colour scrolling map in the middle and a score panel at the bottom, each with its own palette. It works by switching palettes so fast it looks like more than sixteen colours are on screen at once. You can only have one different palette on any given part of the screen: one palette may come from the screen (via `get palette`), the rest from any MBK bank (sprites, bobs, joeys, tiles...). Turn it off with `palsplit 0,0,0,0,0`.

### Example
```stos
10 key off : curs off : flash off : hide : mode 0
20 reserve as screen 5 : load "pic.pi1",5
30 load "sprites.mbk"
40 get palette(5) : SP=palt(start(1))
50 screen copy 5,0,0,319,50 to 0,0
60 sprite 1,100,100,1
70 palsplit 1,SP,100,199,2
80 wait key : palsplit 0,0,0,0,0
```

### Gotchas
- Runs on interrupt — always switch it off (`palsplit 0,0,0,0,0`) before ending the program.
- An object moved into another palette's screen area takes on that area's palette.

**See also:** PALT, RASTER

## FLOODPAL
`FLOODPAL colr` — quickly fill the whole palette with a given colour.

- **colr**: the colour to use (STe-style $RGB value)

FLOODPAL fills every palette register with COLR — e.g. if COLR is 0 and colour 0 is black, the entire palette becomes black. Useful for fades.

### Example
```stos
10 for C=$000 to $777 step $111
20 floodpal c : wait vbl
30 next C
```

**See also:** PALT, PALSPLIT

## BRIGHTEST
`r = BRIGHTEST (padr)` — calculate the brightest colour in a palette.

- **padr**: address of the palette to check
- **r**: the pen number of the brightest colour

Extremely useful for ensuring you can always see your highscore or lives in a game where the palette changes: find the brightest colour of each picture and print text in it.

### Example
```stos
10 load "bobs.mbk",1
20 D=palt(start(1))
30 C=brightest(D)
40 print "Brightest bob colour is";C
50 C=brightest(logic+32000)
60 print "Brightest current colour is";C
```

### Gotchas
- Do not use the hardware palette ($FF8240) as PADR — it usually returns the wrong result. Pass a palette stored in memory (e.g. the address returned by PALT, or the palette block of a picture such as `logic+32000`).

**See also:** PALT
