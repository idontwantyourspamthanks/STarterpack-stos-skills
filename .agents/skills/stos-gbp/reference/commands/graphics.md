# GBP extension commands: graphics

## FASTWIPE
`FASTWIPE ADDR` — very fast clear of 32000 bytes (one screen) from an address.

- **ADDR**: actual address to clear — a screen address (e.g. `physic`) or the start of a memory bank (e.g. `start(BNK)`), never a bare bank number.

A much faster version of the STOS `cls` command. Can clear memory banks or screen addresses; when clearing a memory bank pass the start of the bank, and the bank should be a reserved screen bank.

### Example
```stos
10 fastwipe start(BNK)
```
or, to clear a screen address:
```stos
10 fastwipe physic
```

## ELITE UNPACK
`ELITE UNPACK ADDR1,ADDR2` — unpack a Degas Elite compressed PC? picture.

- **ADDR1**: actual address of the compressed picture data.
- **ADDR2**: actual address of the destination (a normal STOS screen bank, or a screen address).

Unpacks Degas Elite compressed pictures into a screen bank you have reserved for the result. Once unpacked, the palette can be grabbed in the normal way with `get palette`.

### Example
Unpack a picture from bank 11 into bank 10 and display it:
```stos
10 key off : curs off : mode 0 : hide
20 reserve as screen 10
30 reserve as work 11,(length of PC? file)
40 bload "FILENAME.PC?",11
50 elite unpack start(11),start(10)
60 screen copy 10 to physic
70 get palette(10)
```
Screens can also be unpacked directly to the screen and the palette installed from it:
```text
elite unpack start(10),physic
get palette(physic)
```

### Gotchas
- The doc says this routine SHOULD work in all three resolutions, but the author had not tested that.

**See also:** TINY UNPACK, CA UNPACK

## TINY UNPACK
`TINY UNPACK ADDR,ADDR2` — unpack a TINY compressed image.

- **ADDR**: actual address of the compressed picture data.
- **ADDR2**: actual address of the destination.

Does exactly the same as ELITE UNPACK, except that it unpacks a TINY compressed image.

**See also:** ELITE UNPACK, CA UNPACK

## CA UNPACK
`CA UNPACK ADDR,ADDR2` — unpack a Crack Art format (CA?) image file.

- **ADDR**: actual address of the compressed picture data.
- **ADDR2**: actual address of the destination.

Same usage as ELITE UNPACK and TINY UNPACK, but unpacks an image file saved in the Crack Art format (CA?). Packed files are created with CA PACK.

### Gotchas
- Doc typo: the manual's description says "this routine will packed an image file" — it unpacks, of course. See errata.

**See also:** CA PACK, ELITE UNPACK, TINY UNPACK

## CA PACK
`X=CA PACK ADDR,ADDR2,PAL,MODE` — compress a screen into a Crack Art image file.

- **ADDR**: actual address of the source image.
- **ADDR2**: actual address of the destination for the compressed image.
- **PAL**: address of the palette data to be used, usually `ADDR+32000`.
- **MODE**: the picture's screen resolution (0 = Low, 1 = Medium, 2 = High).
- **X**: the length of the compressed picture file.

Creates a compressed Crack Art image file from a standard STOS screen bank, for use with CA UNPACK.

### Example
Compress the current physical screen into bank 10 and save it:
```stos
10 reserve as screen 10
20 L=ca pack physic,start(10),physic+32000,0
30 bsave "picture.ca1",start(10) to start(10)+L
```
L contains the compressed length of the image file.

**See also:** CA UNPACK

## SETPAL
`SETPAL ADDR` — install a new palette from data at an address.

- **ADDR**: actual address of the palette data.

Useful for storing large palette changes in a memory bank and setting them whenever they are needed. The data format is the standard Degas format: 16 words, each word representing colour 0 - 15.

### Example
Copy some values into memory bank 10, then set the palette from it:
```stos
10 reserve as work 10,32 : mem=start(10)
20 restore 80 : for lp=0 to 15 : read(x)
30 doke mem,x : mem=mem+2
40 next lp
50 :
60 setpal start(10) : wait vbl : end
70 :
80 data $000,$111,$222,$333,$444,$555,$666,$777
90 data $000,$111,$222,$333,$444,$555,$666,$777
```

## BCLS
`BCLS ADDR,SCAN` — erase a number of scanlines on one bitplane of the screen.

- **ADDR**: address of the screen; add 2 per bitplane to select the plane (+0 = plane 1, +2 = plane 2, +4 = plane 3, +6 = plane 4).
- **SCAN**: number of scanlines to erase.

### Example
Clear 10 scanlines on plane 1 of the physical screen:
```stos
10 bcls physic,10
```

### Gotchas
- Doc typo: the manual says the number of scanlines "is passed in the variable ADDR" — it is passed in SCAN. See errata.

## MIRROR
`MIRROR OPT,ADDR,SYPOS,ADDR2,DYPOS,NUM` — mirror part of the screen, normal, halved or doubled.

- **OPT**: mirror option — 1 = Normal, 2 = Half Copy, 3 = Double Copy.
- **ADDR**: source address of the image.
- **SYPOS**: source Y pixel offset.
- **ADDR2**: destination screen address.
- **DYPOS**: destination Y pixel offset.
- **NUM**: number of lines to mirror.

### Example
Mirror the STOS key box to the middle of the screen:
```stos
10 mirror 1,physic,0,physic,100,32
```
Put it in a loop and move the mouse over the key box to see the effect.
