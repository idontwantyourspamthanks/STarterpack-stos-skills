# STE extension commands: Extended colour palette

The STE has a palette of 4096 colours rather than the ST's 512. These commands mirror the STOS PALETTE and COLOUR commands but take hex RGB values.

## E PALETTE
`E PALETTE $RGB,$RGB,...(up to 16 colour values)` — Sets the screen palette, exactly as the STOS PALETTE command, but using hex colour values.

Hex uses base sixteen rather than decimal base 10; letters are used for values over nine — ten is `a`, eleven is `b`, and so on. White now becomes `$fff`.

**See also:** E COLOUR, E COLOR

## E COLOUR
`E COLOUR colour,$RGB` — The same as the COLOUR command but using hex values and access to the 4096 colours.

- **colour**: colour register, 0 to 15
- **$RGB**: hex red/green/blue value, e.g. `$fff` for white

**See also:** E PALETTE, E COLOR

## E COLOR
`x= E COLOR (colour)` — Returns the RGB value of a colour number.

- **colour**: colour register, 0 to 15

No, it isn't a spelling mistake — it's a limitation of STOS: you can't use the same name for a command and a function, so the function form of E COLOUR is spelled E COLOR.

**See also:** E PALETTE, E COLOUR

## General gotchas
- Although the palette has 4096 colours, you can still only use 16 on screen at once.
