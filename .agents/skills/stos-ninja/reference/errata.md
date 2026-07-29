# Ninja Tracker errata

Discrepancies between TRACKER.DOC (the V1.05 manual) and the TRACKER.EXT binary token table / demo.

- The doc writes the play command joined as `trackplay ADDRESS`; the binary token table has it spaced as `track play`. (The doc similarly runs words together in prose, e.g. "STOSin", "modis".)
- The doc's syntax line for VU METER is `VALUE=vu meter(INTEGER)` with the 1-4 range in prose; the binary's built-in listing writes it as `INTEGER=vu meter(1-4)`.
- The doc's TRACK KEY syntax line reads `Integer=track key` (mixed case); the binary listing has `INTEGER=track key`.
- The doc says TRACK INFO "does not exist in compiled form"; the compiler-extension half (TRACKER.ECT) is much smaller than the interpreted one because the mod player is compressed and decompresses itself each run.
- The doc's installation section contains a typo: "Copy the file tracter.ect" (should be `tracker.ect`).
- The embedded ProPlayer V3.2 player core credits itself as "ST/STE/Falcon030", but the doc states the extension is for 1 meg STE/TT/Falcon only.
- TRACKER.BAS is tokenized; only string fragments are readable (file-selector text "*.mod", "Please select a mod to play", frequency button labels 5.0/8.5/12/14, "if short on memory change line 110"), so no usable example listings could be recovered from it.
