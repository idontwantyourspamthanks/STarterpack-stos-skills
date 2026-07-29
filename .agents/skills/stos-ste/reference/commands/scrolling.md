# STE extension commands: Hardware scrolling

The STE has hardware scrolling, which enables screen data to be shifted in bytes rather than words using the hardware. All this adds up to single-pixel scrolling.

## HARD SCREEN SIZE
`HARD SCREEN SIZE w,h,mode` — Sets the screen's logical size.

- **w**: width of screen
- **h**: height of screen, ready for scrolling
- **mode**: not explained anywhere in the doc (see errata); HARD1STE.DOC always passes 0 and punts on it too ("0 means 0 ? if you know please tell me")

**See also:** HARD SCREEN OFFSET, HARD PHYSIC, HARD INTER ON

## HARD SCREEN OFFSET
`HARD SCREEN OFFSET x,y` — Tells the ST where to start displaying the screen.

While the interrupt routine is running (HARD INTER ON) you use HARD SCREEN OFFSET to get the scrolling effect.

**See also:** HARD SCREEN SIZE, HARD INTER ON

## HARD PHYSIC
`x = HARD PHYSIC (screen address)` — Tells the ST where the screen is stored.

- **screen address**: address of the screen data

### Gotchas
- Written as a function returning `x`, but it is a setter: HARD1STE.DOC (Jens Hucke's follow-up column) states "All it does is set the origin of the image data it will window onto". What, if anything, `x` receives is not explained; Hucke's own sketch uses `x=hard physic(logic)`.

**See also:** HARD SCREEN SIZE, HARD SCREEN OFFSET

## HARD INTER ON
`HARD INTER ON` — Turns on the hardware scrolling interrupt routine.

Once you have set all the hardware scrolling commands (HARD SCREEN SIZE, HARD PHYSIC) you turn on the scrolling with this. While the interrupt routine is running, use HARD SCREEN OFFSET to get the scrolling effect.

### Gotchas
- If an error occurs while the interrupt is on, STOS turns hardware scrolling off automatically.

**See also:** HARD INTER OFF, HARD SCREEN OFFSET

## HARD INTER OFF
`HARD INTER OFF` — Turns off the hardware scrolling interrupt routine.

**See also:** HARD INTER ON

## General gotchas
- The follow-up column does survive: HARD1STE.DOC (Jens Hucke, same STOSSER series that produced STE_1.doc/STE_2.doc) explains the technique — windowing onto a virtual screen. Create picture data larger than 320x200 (stacked vertically, or interleaved line by line for horizontal), tell the STE its size with `HARD SCREEN SIZE w,h,0` (w and h in pixels; even Hucke punts on the third parameter: "0 means 0 ? if you know please tell me"), set the data origin with HARD PHYSIC, position the window with HARD SCREEN OFFSET, then start the interrupt with HARD INTER ON. His setup sketch:
```stos
30 reserve as work 14,640000
40 reserve as work 15,640000
150 physic=start(14)
160 logic=start(15)
600 x=hard physic(logic) : screen swap
```
- The example programs named in HARD1STE.DOC (VERTICAL.BAS, HORIZON1.BAS, 4SCREENS.BAS and the picture HSHORIZO.NEO) do not survive. Hucke also warns the PD version of the extension "didn't work with the stuff I wrote" — he used the registered version. The official doc says registered users (£10) received "a comprehensive manual with copious examples"; only the smaller doc survives.
- Standard STOS sprites don't survive hardware scrolling: STOS clips screen data at 320x200, and sprites assume every screen line is 320 pixels wide, so on a widened or scrolled screen they are distorted or erased even when displayed in the middle of the monitor's picture (STE_2.doc; corroborated by HARD1STE.DOC, which advises using the Blitter for graphic copying instead).
