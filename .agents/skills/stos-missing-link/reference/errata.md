# Missing Link errata

Discrepancies found during distillation between the official docs (LINK.DOC/
UPDATE.DOC), the DEANO tutorial, and the example programs. Resolutions noted
per item; official docs win unless a real bug is documented.

<!-- from errata-a.md -->
# Missing Link KB errata — batch A (sprites, mapping, text, gfx)

- JOEY: LINK.DOC quick ref shows display form as `JOEY scr,gadr,img,x,y,,COL,0` (double comma, COL), command list shows `JOEY scr,gadr,img,x,y,colr,0`, tutorial shows `JOEY SCR,ADR,IMAGE,X,Y,COLOUR,0`; resolution: command-list form used.
- B WIDTH: tutorial summary mistypes it as `W=W HEIGHT (ADR,IMAGE)`; LINK.DOC has `w = B WIDTH (gadr,img)`; resolution: B WIDTH per LINK.DOC.
- BOB/JOEY examples: LINK.DOC prints both examples with a duplicate line number 20 (clip-set line and `repeat` line); resolution: `repeat` renumbered to 25 in KB examples.
- WORLD/LANDSCAPE window X granularity: LINK.DOC says window X co-ordinates "should be multiples of 16", tutorial states this is due to a bug/quirk in the ST's hardware registers; resolution: documented as a constraint, tutorial's hardware explanation noted as its own claim.
- X LIMIT/Y LIMIT example: LINK.DOC example calls `world 0,0,256,160,1` (5 params) though the documented WORLD clip syntax has 6 (`world x1,y1,x2,y2,0,1`); resolution: example reproduced verbatim, discrepancy noted in the entry.
- WHICH BLOCK / SET BLOCK: LINK.DOC quick ref spells them `WHICHBLOCK` / `SETBLOCK`, command list spells them `WHICH BLOCK` / `SET BLOCK`; resolution: quick-ref spelling used (canonical headings), command-list variant noted in each entry's Gotchas.
- TEXT bug: tutorial documents that TEXT prints in one pen colour only and PEN has no effect; LINK.DOC does not mention this; resolution: stated as a Gotcha (real documented bug).
- TEXT FONT values: LINK.DOC only says "FONT is the number of the font"; tutorial specifies 0-2 = default low/med/high res fonts, 3+ = font bank; resolution: tutorial's detail adopted.
- MANY BOB: UPDATE.DOC quick ref runs two parameters together as `xoff,yoffnum,0`; command list has `xoff,yoff,num,0`; resolution: command-list form used.
- MANY JOEY clip form: UPDATE.DOC command list shows 10 parameters (`x1,y1,x2,y2,0,0,0,0,1`), quick ref shows 11 (`x1,y1,x2,y2,0,0,0,0,0,0,1`); resolution: 11-parameter form used — confirmed by decoding the clip line in MANYJOEY.BAS (`many joey 0,0,320,200,0,0,0,0,0,0,1`).
- MANY BULLET / MANY SPOT: UPDATE.DOC spells the Y-array parameter `yady` (typo) in both quick ref and command list, and the command-list examples wrongly include `start(1)` and a trailing `,0` copied from MANY JOEY; MANY1.BAS and MANYSPOT.BAS confirm the 8-parameter form `scr,xadr,yadr,statadr,coladr,xoff,yoff,num`; resolution: 8-parameter form with `yadr` used, examples corrected accordingly.
- MANY BOB status semantics: UPDATE.DOC says a bob is drawn if its status element is "not 0", tutorial says status 1 draws and 0 skips; resolution: doc's "not 0 draws" wording used (superset, no conflict in practice).
- MOZAIC: LINK.DOC says X2,Y2 are "the bottom left" of the window; tutorial says bottom right and the parameter order confirms it; resolution: bottom right used.
- DISPLAY PC1: listed in LINK.DOC quick ref but its full documentation was omitted from v1.0 ("administrative oversight" per UPDATE.DOC); tutorial does not cover it; resolution: documented from UPDATE.DOC, marked as present in the original extension (not registration-only).
- MANY OVERLAP example: UPDATE.DOC example uses `boom` (compiled-extension sound command) in line 110; resolution: reproduced verbatim from the doc.

<!-- from errata-b.md -->
# Missing Link KB — errata (batch B)

One line per source discrepancy found while writing palette.md, files.md, sound.md, joystick.md, misc.md and make-utility.md. "link" = LINK.DOC (official v1.0), "update" = UPDATE.DOC (official registration update), "tutorial" = docs/missing-link.md (DEANO). Official docs win.

1. BOUNDARY — tutorial claims it rounds to the *nearest* 16-pixel boundary (11 -> 16, 25 -> 32); link says it rounds *down*. KB follows link.
2. P JOY — tutorial claims the result is just 1 (moved) / 0 (not moved); link says D is returned in much the same format as STOS `JOY` (bitmask). KB follows link.
3. MUSPLAY — tutorial claims the Mad Max play offset is 1; link says "ie 8 for Mad Max". KB follows link.
4. REAL LENGTH — tutorial's example inverts the test (`if R<>0 then print "File not packed."`); link states R = 0 means not packed / not found. KB follows link.
5. HERTZ — tutorial spells it "HERZ" and claims it can return 70 on mono monitors; update documents SET HERTZ with 50 or 60 only and says nothing about 70 Hz. KB follows update.
6. SET HERTZ — update's own example reads `10 wait vbl : set freq 50` (wrong command name, a typo for SET HERTZ); KB example corrected.
7. RELOCATE — tutorial example calls `back`; link example calls `back+28` (skips the 28-byte PRG header). KB follows link.
8. DLOAD/DSAVE — tutorial claims DLOAD cannot load normal files and that DSAVE writes a special format "no-one else can load"; link describes plain offset/length file I/O with no special format. Tutorial claim unverified; flagged in files.md.
9. BANK COPY — link's BANK LENGTH/SIZE example line 90 reads `bank copy start(10),start(11),5)` (stray closing paren); KB example corrected.
10. MUSAUTO — link's example has two lines numbered 40; KB renumbers the second (`bload F$,10`) to 45.
11. MUSAUTO — link (v1.0) returns 21 music-type codes; update (registered) returns 31 renumbered codes and says old programs depending on the values may break. Documented as a gotcha in sound.md, not treated as an error.
12. RASTER — update's example appears internally inconsistent (colour-data pointer `start(10)+H` uses H after it has run past the 512-word buffer; the H-cycling loop at lines 70-100 sits behind the raster-on call and the raster-off). Reproduced verbatim in misc.md with a warning.
13. PALSPLIT — tutorial misspells the command "palspilt" in its syntax header and renames the params YNUM/PAL_SPLIT (link: hig/num); cosmetic only.
14. MAKE.DOC — section 2.3.1 says the BOBS option creates a "BOO bank"; typo for bob bank. Also 2.3.3/2.3.4 cover WORLD/LANDSCAPE block banks, confirming tiles/world data are made from 16x16 sprite grids.
