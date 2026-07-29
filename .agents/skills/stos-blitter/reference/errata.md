# Blitter KB errata

Transcription notes from distilling the NuBlitter v1.1 extension (binary `extensions/blitter/Extensions/Stos/BLITTER.EXG`; tutorial `extensions/ste/Docs/blitter.txt`; cross-check `extensions/blitter/BLITTER.TXT`).

- BLIT BUSY: the magazine tutorial documents `X=BLIT BUSY` twice with two different meanings — first as "checks to see if a blitter is fitted" (1 = fitted, 0 = not), and again as the final command described as checking whether an in-progress blit "has finished". The first meaning is likely the separate `blitter` token mislabelled; the mapping is flagged as inferred, not proven, in both entries' Gotchas.
- Command count: the tutorial advertises "24 clever new commands", but the binary's token table contains 27 tokens. The extras beyond the tutorial's 24 are three: BLITTER (token 131), BLIT REMAIN (token 133), ABOUT BLITTER (token 174).
- BLIT REMAIN and ABOUT BLITTER: present in the binary's token table but not described in any surviving doc; both entries carry an Unverified note and a clearly-marked inferred one-line description (BLIT REMAIN plausibly reads remaining blitter status; ABOUT BLITTER plausibly shows version info — the binary embeds "Blitter Extension. v 1.1 (c)1992 Ambrah" and "NuBlitter Extension (c)1991 Architect & Line Productions Programmed by Asa Burrows").
- Two different "blitter extensions" exist: this KB covers the NuBlitter binary (Asa Burrows). `extensions/blitter/Sources/BLITTER.S` is the assembly source of a different, earlier extension (STORM, Neil Halliday, 1994 beta) with different command names; its commands are deliberately NOT documented here.
- BLITTER: documented only in the exxos tutorial as `x=BLITTER` and absent from the magazine tutorial under that name; verified present in the binary's token table as token 131 with its own jump-table handler.
- Binary token 162's string is " blit it" with a leading space; the KB normalizes it to `blit it`.
- Tutorial typo "BLITHALFTONE" (missing space, both versions) and exxos "NOT source4 AND destination" (op 4) normalized in the entries.
- Tutorial describes BLIT HOP values as 0=all ones / 1=half tone / 2=source / 3=source and half tone; transcribed as printed.
- No numbered program examples exist in either tutorial, so all entries omit the Example section rather than inventing one.
