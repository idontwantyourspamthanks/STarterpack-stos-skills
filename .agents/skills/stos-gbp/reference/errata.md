# GBP extension errata

Discrepancies found between GBP.DOC (the manual), the V4.7 `GBP.EXP` token table, and `Sources/COMPILER.S`.

- **PERCENT undocumented**: a `percent` token exists in the V4.7 `GBP.EXP` token table and in COMPILER.S (two integer params; computes how many times the second fits into 100x the first, rounding up), but GBP.DOC never describes it. The KB entry is best-effort inference from the source.
- **JAR missing from V4.7**: JAR is documented in GBP.DOC and present in COMPILER.S (`cjar`), but the V4.7 `GBP.EXP` token table contains no `jar` token, so JAR is unusable with the V4.7 interpreter extension.
- **SETPRT return value**: GBP.DOC documents SETPRT as a function (`X=SETPRT(VAR)`, read settings by passing -1), but the COMPILER.S parameter table defines `setprt` as a procedure (leading 0, no return value).
- **EPLAY intro example typo**: the doc's address-warning example `Eplay start(10),length(10),0,01` has only four parameters (and a stray `01`); the syntax requires five (STRT,LENGTH,SPEED,MODE,PLAYMODE).
- **BCLS doc typo**: the description says the number of scanlines "is passed in the variable ADDR"; it is passed in SCAN.
- **CA UNPACK doc typo**: the description says "this routine will packed an image file"; it unpacks.
- **GBP.DOC file format**: every line of GBP.DOC ends with a NUL byte (CRLF text with trailing `\0`); strip NULs before text-processing the file.
- SETPRT bit table — GBP.DOC says "bit 1 being on the far right", but its own example (`setprt(%000100)` setting Epson = bit 2) only works with bit 0 rightmost. The KB writes "bit 0 is the far right"; logged here per policy (the doc text is a typo).
