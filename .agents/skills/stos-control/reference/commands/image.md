# Control commands: image

## QUICK SCREEN$
`quick screen$ SCREEN,X,Y,STRING,MODE` — plot a string in `screen$` format onto a screen, much faster than the STOS equivalent.

- **SCREEN**: screen address
- **X, Y**: coordinates to plot at
- **STRING**: string in `screen$` format
- **MODE**: option bits — bit 0: 0 = replace mode, 1 = transparent mode; bit 1: 0 = don't flip vertically, 1 = flip vertically in real time as it is plotted

A clipping region can be activated with SET CLIP.

### Gotchas
- Bit 2 of MODE (draw without clipping checks) can also be set here and on IMAGE PUT, but per the doc it only really makes a speed difference on IMAGE MAP.

**See also:** SET CLIP, IMAGE PUT, FONT

## IMAGE PUT
`image put SCREEN,X,Y,BANK_ADDRESS,NUMBER,MODE` — put a pre-shifted image from an image bank onto the screen.

- **SCREEN**: screen address
- **X, Y**: coordinates to plot at
- **BANK_ADDRESS**: actual address of the image bank — pass `start(bank)`, not the bank number
- **NUMBER**: image number within the bank
- **MODE**: same option bits as QUICK SCREEN$ (replace/transparent, vertical flip)

Similar to the Missing Link's BOB command: slightly slower, but more flexible — you don't have to store both up- and down-facing sprites. This is the only sprite routine available for STOS that is compatible with the STE's hardware scrolling, working on screens of many different sizes. You can have up to 65536 images in a bank.

### Gotchas
- Image banks are pre-shifted and must be made with the MAKER utility (maker.bas); they are *not* compatible with STOS sprite banks or Missing Link banks.
- All bank parameters take actual addresses via `start(bank)`.
- Works together with SET CLIP and SCREENSIZE for large STE screens.

**See also:** QUICK SCREEN$, FONT, SET CLIP, IMAGE WIDTH, IMAGE HEIGHT, IMAGE PALETTE, SCREENSIZE, make-utility.md

## FONT
`font SCREEN,X,Y,BANK_ADDRESS,STRING` — write text in a 16-colour font using images from an image bank.

- **SCREEN**: screen address
- **X, Y**: coordinates to write at
- **BANK_ADDRESS**: actual address of the font image bank — pass `start(bank)`
- **STRING**: the text to write

### Example
```stos
10 font logic,0,0,start(10),"HELLO"
```

### Gotchas
- Make sure the text is in upper case.
- Including a `chr$(23)` in the text moves the "graphic" cursor to the beginning of the next line.
- Font banks are made with the MAKER utility (maker.bas), like image banks.

**See also:** IMAGE PUT, QUICK SCREEN$, SET CLIP, make-utility.md

## SET CLIP
`set clip X1,X2,Y1,Y2` — set the clipping rectangle for QUICK SCREEN$, IMAGE PUT and FONT.

- **X1, X2, Y1, Y2**: clipping rectangle edges

### Gotchas
- The X coordinates are rounded to the nearest multiple of 16.
- The command listing (both manuals) writes the parameter order as `X1,X2,Y1,Y2`, while the full description (both manuals) writes `set clip X1,Y1,X2,Y2` — the doc is internally inconsistent about the order.
- In shareware V3.5a the clipping rectangle must be re-set immediately after SCREENSIZE due to a compiler-version bug (fixed in the registered version).

**See also:** QUICK SCREEN$, IMAGE PUT, FONT, SCREENSIZE

## IMAGE WIDTH
`INTEGER=image width BANK_ADDRESS` — get the width of all the images in an image bank.

- **BANK_ADDRESS**: actual address of the image bank, e.g. `start(bank)`

### Gotchas
- The V3.5a shareware command listing names this command `font width`; its full description and the V3.6b registered manual both use `image width`.

**See also:** IMAGE HEIGHT, IMAGE PUT, make-utility.md

## IMAGE HEIGHT
`INTEGER=image height BANK_ADDRESS` — get the height of all the images in an image bank.

- **BANK_ADDRESS**: actual address of the image bank, e.g. `start(bank)`

### Gotchas
- The V3.5a shareware command listing names this command `font height`; its full description and the V3.6b registered manual both use `image height`.

**See also:** IMAGE WIDTH, IMAGE PUT, make-utility.md

## IMAGE PALETTE
`image palette BANK_ADDRESS` — get (apply) the palette stored in an image bank.

- **BANK_ADDRESS**: actual address of the image bank, e.g. `start(bank)`

**See also:** IMAGE PUT, SPREAD, make-utility.md
