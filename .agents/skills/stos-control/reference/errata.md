# Control extension errata

Discrepancies and typos found in the official docs (CONTREG.DOC V3.6b,
CONTROL35.DOC V3.5a) during distillation, plus shareware/registered
differences. Resolutions noted per item.

<!-- from errata-a.md -->
# Control extension errata (batch A: construct, string/cursor, parallel, zone commands)

Cross-check of CONTROL35.DOC (V3.5a shareware) against CONTREG.DOC (V3.6b registered) for the 23 commands covered by commands/construct.md, string-cursor.md, parallel.md and zone.md.

## Shareware vs registered disagreements
- None. The command listings and full descriptions of these 23 commands are word-for-word identical between V3.5a and V3.6b (only whitespace/line-wrap differs). Version differences in the docs concern only the screen/image commands (font width vs image width, image map syntax, the set clip/screensize compiler bug fixed in 3.6b), which are outside this batch.

## Internal doc inconsistencies (both versions share them)
- CONTREG.DOC + CONTROL35.DOC: doc body spells `init mega zone` and `test negazone`; command listing uses `init megazone` / `test megazone`. Listing form used in the KB.
- CONTREG.DOC + CONTROL35.DOC: SET MEGAZONE listing parameter `ZOMENUMBER` is a typo for ZONENUMBER (doc body's spelling).
- CONTREG.DOC + CONTROL35.DOC: RANGE MEGAZONE listing uses LOWERRANGE,UPPERRANGE; doc body describes the same parameters as ZONE_S,ZONE_E.
- CONTREG.DOC + CONTROL35.DOC: WRITE equivalence example uses `al=len$(a$)`; STOS has no LEN$ function — should be `al=len(a$)`. Corrected in the KB example.
- CONTREG.DOC + CONTROL35.DOC: switch-construct example line 110 contains `ren do loading` — typo for `rem`. Corrected in the KB example.
- CONTREG.DOC + CONTROL35.DOC: PARALLEL listing shows `INTEGER=parallel(PORTNUMBER)` while the doc body writes `J=parallel(0-1)`; same for the PARA direction/fire functions. PORTNUMBER is the joystick adaptor port (0 or 1).

<!-- from errata-b.md -->
# Control KB — errata (batch B: screen, image, registered commands)

One line per discrepancy found between the V3.5a shareware manual (CONTROL35.DOC) and the V3.6b registered manual (CONTREG.DOC) while writing commands/screen.md, commands/image.md and commands/registered.md. V3.6b (registered) wins unless noted.

1. IMAGE WIDTH/IMAGE HEIGHT — V3.5a command listing names them `font width`/`font height`; V3.5a's own full descriptions and V3.6b use `image width`/`image height`. KB follows `image width`/`image height`.
2. IMAGE MAP — V3.5a syntax is `image map SCREEN_ADDRESS,IMAGE_BANK_ADDRESS,MAP_ADDRESS,X,Y,MODE` (0=replace/1=transparent); V3.6b drops MODE (moved to SET MAP) and adds the optional VALUE parameter. KB follows V3.6b.
3. MAP W/MAP H — V3.5a lists `=map width`/`=map height`; V3.6b lists `=map w`/`=map h`. KB follows V3.6b.
4. BIGCOPY — V3.5a documents only the replace-mode form; V3.6b adds the `...,MODE` variant (0=replace, 1=merge) and the blitter notes. KB documents both, flagging MODE as V3.6b-only.
5. SCREENSIZE — V3.5a documents a compiler-version bug that scrambles the clipping rectangle after SCREENSIZE (workaround: re-issue SET CLIP) and states it is fixed in the registered version; V3.6b omits the note. Bug kept as a Gotcha for shareware users.
6. ENABLE BLIT / MADD / DAC PLACE — absent from V3.5a entirely; new in V3.6b. MANY IMAGE is fully documented in the V3.6b body but absent from its command listing (included in the KB for completeness).
7. Registered-command availability — V3.5a includes TURBOCOPY through MAP ADDRESS in interpreted form only ("you must register to receive the compiler equivalents"); V3.6b presents the same commands (plus ENABLE BLIT/MADD) as registered-only. KB marks all 19 as registered-only per V3.6b, with the shareware interpreted-only caveat noted.
8. SET MAP — V3.6b adds the bit-2 no-clipping MODE option (2-3 screens/sec faster); V3.5a documents MODE as plain 0=replace/1=transparent. KB follows V3.6b.
