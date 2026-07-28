# Control commands: screen

## SCREENSIZE
`screensize WIDTH,HEIGHT` — tell the Control sprite engine the size of STE hardware-scrolled screens.

- **WIDTH, HEIGHT**: screen dimensions in pixels; the same parameters as the `hard screensize` command from the STE extension

This informs the sprite engine (QUICK SCREEN$, IMAGE PUT, FONT) what size screens you have set up for the STE's hardware scrolling, so images can be plotted correctly on screens larger than 320 x 200.

### Gotchas
- Do not use `screen$` grabs — or any other STOS graphics commands — on screens that are not the usual 320 x 200: STOS itself is unaware the screen size has changed and you will get very strange results.
- In the shareware V3.5a *compiler* version a bug scrambles the clipping rectangle values when SCREENSIZE is used, which can crash programs using QUICK SCREEN$, FONT, IMAGE PUT or MANY IMAGE; work around it by re-issuing the clip straight afterwards (`screensize 320,200` then `set clip 0,0,320,200`). The doc states this bug is fixed in the registered version.
- Default size is 320 x 200.

**See also:** SCREEN OFFSET, SET CLIP, IMAGE PUT

## SPREAD
`spread ADDRESS,START_COLOUR,END_COLOUR` — produce graduated shades between two colour indexes.

- **ADDRESS**: screen address (the full description names this parameter SCREEN_ADDRESS, e.g. `logic`)
- **START_COLOUR, END_COLOUR**: first and last colour indexes of the range to blend

SPREAD interpolates the palette entries between START_COLOUR and END_COLOUR. For example, if colour 1 is $111 and colour 7 is $777, then `spread logic,1,7` produces:

```text
colour 1= $111
colour 2= $222
colour 3= $333
colour 4= $444
colour 5= $555
colour 6= $666
colour 7= $777
```

### Example
```stos
10 spread logic,1,7
```

### Gotchas
- Does not work correctly on colours which have the STE's extra palette bits set.

**See also:** IMAGE PALETTE

## BRDR REMOVE
`brdr remove TYPE` — remove the top and/or bottom screen border (STFMs only).

- **TYPE**: 0 = return borders to normal, 1 = remove bottom border only, 2 = remove top border, 3 = remove both borders

### Gotchas
- STFM machines only (the BORDER.BAS example echoes "STFMs only (sorry!)").
- While a border is removed the keyboard can only be read with the HARDKEY command from the Misty extension, or by peeking the value from $FFFC02.

**See also:** HSCROLL

## HSCROLL
`hscroll SCREEN,START_Y,END_Y,BITPLANES,NUMBEROFPIXELS` — fast horizontal scroll of a band of the screen.

- **SCREEN**: screen address, as usual
- **START_Y**: first line to scroll
- **END_Y**: last line to scroll
- **BITPLANES**: bit pattern of bitplanes to scroll — `%1` scrolls bitplane 1 only, `%1111` scrolls them all
- **NUMBEROFPIXELS**: pixels to scroll by; positive scrolls right, negative scrolls left

STOS' own horizontal scrolling is appalling; this command attempts to redress the balance.

### Gotchas
- Only works on regular 320 x 200 sized screens.

**See also:** SCREEN OFFSET, SCREENSIZE

## CRACK PAC
`INTEGER=crack pac SCREEN_ADDRESS,DEST_ADDRESS` — pack a low-res Crack Art screen into memory; returns the packed length.

- **SCREEN_ADDRESS**: the screen to pack
- **DEST_ADDRESS**: where the packed data goes (e.g. `start(bank)`)

Works as for the STOS `pack` command, but for screens saved by the Crack Art package.

**See also:** CRACK UNPAC

## CRACK UNPAC
`crack unpac SCREEN_ADDRESS,DEST_ADDRESS,MODE` — unpack a packed Crack Art screen onto a screen.

- **MODE**: 0 = the palette of the current screen is not altered; non-zero = it is

Crack Art is an art package; CRACK PAC and CRACK UNPAC pack and unpack low-res Crack Art screens. Bank and screen addresses are as normal.

### Gotchas
- The command listing names the parameters `SCREEN_ADDRESS,DEST_ADDRESS`, but the full description writes `crack unpac BANK_ADDRESS,SCREEN_ADDRESS,MODE` — i.e. the source is the packed bank address and the destination is the screen.

**See also:** CRACK PAC
