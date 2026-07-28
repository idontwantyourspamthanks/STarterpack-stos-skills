# Misty KB errata

Transcription notes from distilling `extensions/misty/MISTY.DOC` (v1.7, 23/06/92). Atari extended-ASCII/CRLF stripped and transliterated to plain ASCII; all example code kept verbatim.

- SKOPY: syntax line ends `Scr2,X3,X4` but every example passes destination X,Y — `X4` is almost certainly a typo for `Y3`; transcribed verbatim and flagged with an Unverified note in the entry.
- SKOPY: syntax text says "N is the number of bitplanes*" — the asterisk has no matching footnote anywhere in the manual; asterisk dropped, flagged in errata only.
- SKOPY: "X co-ordinates only on 16 boundary" kept verbatim in the summary; expanded to "16-pixel boundary" in the Gotchas (meaning is unambiguous from the bitplanes section).
- SKOPY: authors' benchmark shows SKOPY 3 (39/34 VBL) slower than SKOPY 4 (31/27 VBL), which is counter-intuitive; transcribed as printed with an Unverified note.
- MEDIACH: printed return values (0=changed, 1=maybe, 2=not changed) are the reverse of the standard BIOS Mediach convention (0=not changed ... 2=definitely changed); the manual itself says the command "doesn't work correctly". Transcribed faithfully with an Unverified note.
- RESVALID: manual typo "Returns TRUE is the reset vector is set" normalized to "if the reset vector is set".
- WARMBOOT: manual typo "dishearting" normalized to "disheartening".
- MOUSEOFF: manual typo "upto 30% processor time" normalized to "up to"; example line `10 showon` kept verbatim (presumably `show on`).
- FLOPRD: parameter case inconsistency in the manual ("NumSecs" in syntax, "Numsecs" in the description) — syntax line kept verbatim, description matched to it.
- General: manual's "rather then `14`" (bank-address rule) normalized to "rather than"; rule itself encoded in every entry that takes an address.
- RESVALID: manual's "useful for either check for a virus" normalized to "either checking for a virus" in system.md (grammar); "demo's" rendered as "demos" in AESIN entry.
