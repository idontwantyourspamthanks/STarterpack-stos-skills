# Errata and unverified entries

Items the extractors could not resolve from the scans. Check against the physical page images in dev/pdf-pages/.

> Resolutions: see errata-response.md (user rulings). Settled items have been
> applied to the knowledge base and removed from the per-batch errata sources;
> items remaining below are either reference records or not user-ruled.

<!-- from errata-batch-03.md -->
# Errata — batch-03

- HEXA ON/OFF example (pages 52-53): bank 1's length is printed as L:7091 here, contradicting the same bank's L:$011500 (= 70912) in the LISTBANK example on page 52. The manual contradicts itself; transcribed verbatim with an Unverified note in the entry. Not user-ruled.
<!-- from errata-batch-14.md -->
# Errata — batch-14

Resolved: the user ruled (errata-response.md) that there are 8 address registers and 8 data registers, both ranging 0-7 (A0-A7 and D0-D7). The CALL, AREG and DREG entries in batch-14.md and docs/stos-manual/topics/appendix-d.md have been corrected to follow this ruling; the previous verbatim-inconsistency records are dropped.
<!-- from errata-compiler.md -->
- Neochrome viewer line 30 (page 12): scan-confirmed — the scan is legible and prints `30 if right$(F$,4)<>".NEO" then boom : goto 10`. Transcribed verbatim; the earlier Unverified inline note has been removed.
- `load "butSet.cmp"` (page 12, BULLET tutorial): OCR is clearly wrong; normalised to `load "bullet.cmp"` based on context (the program just compiled as `BULLET.CMP`).
- Function-key definitions block (page 8): OCR shows `F14(shift-F4) fload^.CMP"` and `F15(shift-F5) fsave"*.CMP"`. Normalised the first to `fload "*.CMP"` (caret interpreted as a stray quote). Minor and unambiguous given the second line.
- `10 COMPATH$="D:\STOS\UTILITY"` (page 9): plain OCR fix — the scan prints `10 COMPATH$="D:\STOS\UTILITY":rem Example path name`; the OCR's zero-for-O misread (`C0MPATH$`) has been corrected.
- Sprite editor compile example (page 17): the manual refers to "the sprite editor definer" and loads `sprite.acb`; interpreted as the STOS sprite editor accessory. Listing not reproduced verbatim.
<!-- from errata-topic-appendix-e.md -->
- TRAP #3 function number register (page 257): source states the window TRAP carries its function number in D7, which is unconventional on the 68000 (D7 is normally callee-saved). Transcribed as printed; flagged in inline NOTE.
- Floating-point function numbers (page 264): values transcribed AS PRINTED — `$09 EQFL` (duplicating $09 LOG10FL), `$19 COSFL` ("Calculate the hyperbolic cos"), `$1A TANFL` ("Calculate the hyperbolic tan"). The printed table is internally inconsistent (duplicate $09; hyperbolic entries named COSFL/TANFL rather than COSHFL/TANHFL); flagged inline with `> [!NOTE] Unverified:`.
- ADFL assembly example (page 263): OCR fixes confirmed against the scan — `MOVE!` is `MOVE.L`, the period separating operands is a comma, and `MOVE #fl,D0` is `MOVE #0,D0`. Listing restored to the printed order (function number first, then the MOVE.Ls).
- FLTOA assembly example (page 264): `#$9999999A,D2` kept per the same 1.1 value in the ADFL example on page 263 (the FLTOA example itself prints `#99999999A,D2`); documented in the inline note. `BUF: BDF 1000,0` restored verbatim as printed and flagged with `> [!NOTE] Unverified:`.
- PSG register table (page 266): OCR loses the register numbers in the left column entirely (rendered as `CVJ CO`, `LO CO`, `GO`, `CO`, `o`, `CVJ`, `CO`). The clean register-by-register listing lives in `dev/pdf-pages/out/batch-15.md` and is not reproduced in the topic guide.
<!-- from errata-topic-editor.md -->
- MATCH example (pages 50-51): the source listing is split across two pages with several OCR artefacts in the `data` statements and print strings (`MfountT`, `PO$`, `lO^adams`). The full listing is not reproduced in `docs/stos-manual/topics/editor.md`; instead the underlying demonstration is described in prose and the cleaner standalone `SORT` example (page 50) is shown in full. Flagged inline with `> [!NOTE] Unverified:`.
<!-- from errata-topic-graphics.md -->
- SET MARK marker type table (page 135): scan-confirmed — the table is fully legible in the scan and prints the type numbers 1-6 (1 Point, 2 Plus sign, 3 Star, 4 Square, 5 Diagonal cross, 6 Diamond), corroborated by the worked example (`set mark 4,83` → "three squares"). The earlier Unverified inline note has been removed.
- SET PAINT type table (page 130): the OCR table layout is mangled (`O`, `C\J CO T *`), but the prose ("Type can range from 0 to 4") plus the demonstration loop on page 131 (`for TYPE=2 to 3`, with LIM=24 for type 2 and LIM=12 for type 3) make the five type meanings unambiguous: 0=unfilled, 1=solid, 2=dotted (24 patterns), 3=lined (12 patterns), 4=user-defined. No inline note added.
- Throughout the chapter, many short code listings contain obvious OCR damage (e.g. `colour 5f$770` → `colour 5,$770`; `set line %1111111111111111.10,0,1` → comma for period; `els` → `cls` per standing rule; `mco!`/`colour(l)` in the COLOUR print loop; `1r$700` and `$70` in the PIE example; duplicate/jumbled line numbers in the DIVX/DIVY demo). Rather than reproduce these verbatim, the topic guide uses clean, minimal examples written to the documented syntax. No individual inline notes were added for these, as none are quoted.
<!-- from errata-topic-guided-tour.md -->
- `for A=1 to 15:sprite A,1,A#10,A` (printed page 3, file page-010): OCR reads `A#10`. Reconstructed as `A*10` so the 15 sprites spread across distinct y coordinates (10,20,...,150). Flagged inline with `> [!NOTE] Unverified:`. The same line also had `Arwait key.next A` normalised to `A:wait key:next A`.
- First MOVE example (printed page 4, file page-011): OCR reads `move x 1,"0{1,1,0)L320"`, which is too mangled to reconstruct confidently (the leading `0`, the `{`, and the trailing `320` after `L` do not fit the `(dx,dy,count)L` pattern used by every other MOVE example in the chapter). Omitted in favour of the cleaner second example `move x 1,"(1,3,100)(1,-3,100)L"` from the same page.
- `anim 1,"(1,10)t'2,10)(3,10)(4,10)L''` (printed page 5, file page-012): normalised to `anim 1,"(1,10)(2,10)(3,10)(4,10)L"` (`t'` read as `( `, trailing smart quotes `''` straightened). Confident given the surrounding examples.
- `flash 1 ,"(000,5)(333^)(666,5)(777,5)(555I5)(222,5)"` (printed page 9, file page-017): normalised to `flash 1,"(000,5)(333,5)(666,5)(777,5)(555,5)(222,5)"` (`333^)` and `555I5)` both read as the repeating `NNN,5)` pattern of the other tuples). Confident.
- `load "animalsl.mbk"` (printed page 3, file page-010): normalised to `animals1.mbk` (lowercase L read as digit 1). Confident — the same file is named `animals1.mbk` on printed page 7 (file page-014).
- `load "backgmd.mbk"` / `BACKGRD MRK l` (printed page 6, file page-013): normalised to `backgrnd.mbk`, matching the explicit `load "backgrnd.mbk"` on printed page 7.
- `locate 0f0:print x mousefy mouse:goto 10` (printed page 10, file page-018): normalised to `locate 0,0: print x mouse,y mouse: goto 10` (`f` read as `,`). Confident.
- Menu example (printed page 15, file page-023): OCR reads `menii$(1)="Menu "`, `menu$(1/l)="ltem1"`, etc. Normalised to `menu$(1)="Menu"`, `menu$(1,1)="Item1"` (`menii`→`menu`, `1/l`→`1,1`, `ltem`→`Item`). Confident.
- `print icon$ (X*5+Y+1)` (printed page 14, file page-022): normalised to `print icon$(X*5+Y+1)` (stray space inside the function call removed).
- Throughout: curly/smart quotes (`'`, `'`, `"` `"`) straightened to ASCII; `modeO` read as `mode 0`; `wait keyimode` / `wait keyigoto` / `keyigoto` read as `wait key: mode` / `wait key: goto` (the `i` standing in for STOS's `:` separator).
<!-- from errata-topic-music-sound.md -->
- `load "music.mbk"` (page 113, direct-mode example): OCR reads `load ~music.mbkJ,` — the quote characters are mangled into `~` and `J,`. Reconstructed as `load "music.mbk"` based on context (the `.MBK` extension is specified two pages later, and the same filename appears correctly elsewhere in the chapter). Normalisation is unambiguous.
- `accnew : accload "music.acb"` (page 115): OCR reads `accnewiaccload "music.acb"` — missing the colon-space separator between the two commands. Reconstructed based on the standard accessory-loading idiom used throughout the manual (see compiler.md and the sprite editor chapter). Trivial.
- Chromatic note list (page 116): scan-confirmed — the scan prints `C,C#,D,D#,E,F,F#,G,G#,A,A#,B`; transcribed verbatim in the printed comma form.
- Dotted-note character (page 116): scan-confirmed — the scan prints `by using the "." character`; transcribed verbatim.
- NOISE/ENVEL experimentation program (pages 125-126): OCR merges line numbers (`30 els 35 locate 0r0:`), mangles the `cls` command to `els` (per the standing `els`→`cls` rule), and corrupts the `locate 0,0` syntax to `locate 0r0`. Rather than reproduce the damaged listing, the technique is described in prose at the end of the topic guide. Not flagged inline because the listing is not reproduced.
- `print "You're DEAD!"` (pages 124-125, BOOM and SHOOT examples): OCR uses curly/smart quotes and apostrophes in places; normalised to straight ASCII per the conventions.
<!-- from errata-topic-other-commands.md -->
- USING exponential-form character (page 202): scan-confirmed — the scan prints `^ (Shift+6) Prints out a number in exponential form.` Transcribed as `^`; the earlier Unverified inline note has been removed.
<!-- from errata-topic-screen.md -->
- Triangle double-buffer example, modified erase line (page 147): OCR reads `polygon X1+I-16,Y1 to X2+16,Y2 to X3+16,Y3 to X1+I-16,Y1`, dropping `-I-` from the second and third corners. Reconstructed as `X2-I-16`/`X3+I-16` from the pattern of the original line 60 (`X1+I-8`/`X2-I-8`/`X3+I-8`) and the manual's explanation that, under double-buffering, the erased triangle sits two steps back. Flagged inline with `> [!NOTE] Unverified:`.
- PACK example (page 160): the function signature is `I=PACK scr,bnk`, but the worked example mixes `L=pack(5,6)` (line 20), `reserve as data 7,L` (line 21) and `copy start(6),start(6)+I to start(7)` (line 22). Normalised to `L` throughout as the single packed-length variable. Obvious typo, not a reconstruction — not flagged inline.
- Page-flip loop (page 150/150-b): condensed from the manual's ZOOM banner demo. The scanned listing reserves screens 5-11, zooms the text progressively into each, then flips with `for i=6 to 11:physic=i:wait vbl:wait 5:next i` followed by `wait 30:goto 140`. Only the verified flip core (bank range 6-11, `physic=i`, `wait vbl`, `wait 5`) is reproduced as a standalone illustration; the surrounding reserve/zoom setup and loop-back are dropped. Listing not reproduced verbatim.
- REDUCE four-copies example (page 151): reproduced with the REM and setup lines removed and renumbered consecutively; the `reduce 5 to X*160,Y*95,(X+1)*159+1,(Y+1)*96` line and loop structure are verbatim. The asymmetric tile bounds (95 vs 96 step, 159+1) are as printed in the manual.
<!-- from errata-topic-writing-a-game.md -->
# Errata — Writing a game topic guide

Source pages: `dev/pdf-pages/manual/pages/page-234.txt` … `page-237.txt`.

## OCR reconstructions

- **Triangle example, line 50** (`plot x1vy1`): reconstructed as `plot x1,y1`. The OCR `v` is a misread comma; the comma form is the only valid STOS syntax and matches the triangle's starting vertex.
- **Triangle example, line 80** (`draw to x1ry1`): reconstructed as `draw to x1,y1`. Same OCR error (`r` for `,`); line 80 closes the triangle back to the top vertex at (x1,y1).

Both reconstructions are flagged inline in the topic guide with a `> [!NOTE] Unverified:` block, following the precedent set in `docs/stos-manual/compiler.md` for the GEM-run Neochrome viewer example.
