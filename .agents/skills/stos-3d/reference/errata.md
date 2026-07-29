# STOS 3D errata

Discrepancies, manual typos and unreadable spots found while distilling
the official manual (110-page scan). Resolutions noted per item.

<!-- from errata-a.md -->
# STOS 3D KB errata — batch A (world, surface)

Discrepancies and unreadable spots found while distilling the STOS 3D manual
(extensions/stos-3d/stos_3d_manual.pdf; OCR in extensions/stos-3d/Docs-ocr/).
Manual page numbers are the printed page numbers (PDF page = printed + 4).

- TD DELETE ZONE: manual p.80 prints the syntax as `Td DELETE ZONE on, zn`; the quick reference (p.110) gives `Td DELETE ZONE n, zn`. Verified against the page image — the `on` really is printed, a manual misprint. Resolution: `n, zn` used, misprint noted in the entry.
- TD WORLD example: OCR of p.78 read `ZW=Td World Z2(5,x5,y5,z5)`; the page image confirms `ZW=Td World Z(5,x5,y5,z5)`. Resolution: corrected.
- TD OBJECT: main text (p.72) gives `Td OBJECT n,name,x,y,z,A,B,C`; the quick reference (p.110) gives `Td OBJECT n,name$,x,y,z,A,B,C`. The manual's own example uses a quoted string. Resolution: main-text form used, `$` variant noted in the entry.
- TD SURFACE: main text (p.83) gives `Td SURFACE name1,b1,f1,n2,b2,f2,rt`; the quick reference (p.110) gives `Td SURFACE name1,b1,f1 to n2,b2,f2,rt`. Resolution: main-text form used, `to` variant noted in the entry.
- TD REDRAW / TD CLS: the manual's syntax lines give a descriptive parameter, `Td REDRAW screen address (usually logic)`; the quick reference (p.110) abbreviates it as `Td REDRAW scr` / `Td CLS scr` (OCR read `ser`). Resolution: main-text form used.
- TD PRIORITY / TD SET COLOUR: documented only on manual p.87, which is typeset in a different style from the rest of the manual (apparently a late-addition addendum page); both are absent from the quick reference. Content verified against the page image and transcribed in full.
- TD DEBUG: present in the extension token table (3D.EXS, "STOS 3D extension I 1.1T") but documented nowhere in the manual — not in the command chapters, the quick reference or the error appendix — and no disk README survives in this copy. Resolution: KB entry marked Unverified with no syntax.
- TD SET ZONE prose: manual p.79 reads "defines a invisible spherical zone" (grammar misprint in the original); condensed in the KB entry.

<!-- from errata-b.md -->
# STOS 3D KB errata (batch B: position / motion / animation commands)

Transcription notes from distilling `extensions/stos-3d/stos_3d_manual.pdf` (scan with no text layer; OCR in `extensions/stos-3d/Docs-ocr/`). All syntax lines below were verified against the PDF page images (pdftoppm, 150 dpi). Manual page = PDF page - 4.

- TD ANGLE REL: the manual's syntax line on p74 prints `Td ANGEL REL n,dA,dB,dC` — "ANGEL" is a typo for ANGLE (confirmed against the page image; the command summary on the reference page and the prose both say ANGLE REL). Normalized to `Td ANGLE REL n,dA,dB,dC` in motion.md.
- TD MOVE X/Y/Z: the syntax lines on p75 print `Td MOVE X n,string` (no `$` on string), while the command summary on the quick-reference page writes `Td MOVE X/Y/Z n,string$`. Body form transcribed verbatim in motion.md; the string is a movement string either way.
- TD ANGLE A/B/C: body syntax on p75 prints `angle$` (with `$`); consistent with the quick-reference page. No discrepancy.
- TD ANIM: syntax on p82 declares parameter `p`, but the description says "moves point number pn in object n"; TD ANIM POINT on the same page uses `pn` throughout. Kept each form verbatim where it appears (`p` in the TD ANIM syntax line, `pn` in the description and in TD ANIM POINT).
- TD DELETE ZONE (not in this batch, noted in passing): p80 prints the syntax line as `Td DELETE ZONE on, zn` — the "on" appears to be a typo for `n`.
- General: OCR of these pages misread `z` as `2` (Td OBJECT line, p72), `angle$` as `angleS`/`angles` (p75), and `(n,z)` as `Rin.z)` etc. (p80); all corrected against the page images, so no Unverified notes were needed in the entries.
- Unnumbered manual examples (Td Move 4,100,100,3000; Td Move Rel 2,0,100,0) are reproduced in direct-mode text fences; the Td MOVE Z / Td BEARING examples were printed as short unnumbered listings and were given line numbers (10, 20, 30) to fit the KB example format. The TD ANGLE example keeps its original tutorial line numbers (110/120).
