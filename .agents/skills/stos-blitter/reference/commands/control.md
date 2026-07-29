# Blitter extension commands: Control

## blit busy
`x=BLIT BUSY` — Check whether the blitter has finished a copy in progress.

- **returns**: 1 or 0

The blitter runs alongside the central processor, so you can do something else while it's doing its tricks — unless you have used BLIT HOG. The blitter is damn quick, so you're unable to do much before it has finished in interpreter mode; once compiled, things go a lot faster. You could set the blitter off copying data, check your variables or do the sprite stuff, then check to see if it has finished before carrying on.

### Gotchas
- The magazine tutorial documents `X=BLIT BUSY` twice with two different meanings: first as "checks to see if a blitter is fitted", and again as the last command, checking whether the blitter "has finished". The first meaning is likely the separate `blitter` token (token 131) mislabelled in the tutorial — see the `blitter` entry. The mapping is inferred, not proven; this entry covers the "has it finished" meaning.

**See also:** blitter, blit it, blit hog, blit remain

## blitter
`x=BLITTER` — Check whether a blitter is fitted.

- **returns**: 1 if you have one of the little beauties fitted, 0 if you don't

Documented only in the exxos version of the tutorial (`extensions/blitter/BLITTER.TXT`), which lists it as a separate command from BLIT BUSY. Verified present in the binary's token table (token 131, with its own jump-table handler).

### Gotchas
- The magazine tutorial (`extensions/ste/Docs/blitter.txt`) describes this same fitted-check as the FIRST of its two `X=BLIT BUSY` meanings. The likely explanation is that the magazine mislabelled `BLITTER` as `BLIT BUSY` — but that mapping is inferred, not proven.

**See also:** blit busy, blit remain

## blit hog
`BLIT HOG` — Put the blitter chip in command of your ST, taking all the processing time.

Stops all interrupts, apart from a few important system ones.

### Gotchas
- Avoid using this: STOS has its own interrupt routines and it doesn't like it.

**See also:** blit it, blit busy

## blit it
`BLIT IT` — This is it! Sets everything going — starts the blit.

Triggers the transfer configured by the setup, mask, count and operation commands.

### Gotchas
- You must make sure you have set up all the relevant details first, or else the system is almost certain to crash. No worries — you can't damage it; just boot up and try again. (You did save the program before you ran it, didn't you?)

**See also:** blit source address, blit dest address, blit x count, blit busy

## about blitter
`ABOUT BLITTER` — (inferred) Show extension version/credit information.

> [!NOTE] Unverified: present in the binary's token table but not described in any surviving doc. The name suggests it displays version info; the binary contains the strings "Blitter Extension. v 1.1 (c)1992 Ambrah" and "NuBlitter Extension (c)1991 Architect & Line Productions Programmed by Asa Burrows." Treat the syntax and behaviour as inferred.

**See also:** blit busy
