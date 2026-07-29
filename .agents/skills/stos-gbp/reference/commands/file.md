# GBP extension commands: file

## D CRUNCH
`D CRUNCH ADDR` — unpack a file compressed with a recognised packer, in place.

- **ADDR**: actual address of the compressed data (e.g. `start(bank)` — never a bare bank number).

Unpacks data compressed with the most popular packers: Speed Packer 2, Speed Packer 3, Atomik V2.5, Ice V2.11, Ice V2.40, Automation V5 and Fire V2.0. The packer format is recognised automatically from the file header.

### Gotchas
- The de-pack routines are a0 -> a0 routines: the compressed data is OVERWRITTEN during decompression, and the unpacked result expands over the same memory. Memory banks must be reserved to the ORIGINAL (uncompressed) file length of the data, otherwise you overwrite data you may need and can crash the ST.
- ADDR must be an actual address, not a bank number.

**See also:** PAKTYPE, PAKSIZE

## PAKTYPE
`X=PAKTYPE(ADDR)` — identify which packer compressed the data at an address.

- **ADDR**: actual address of the packed data.
- **X**: packer code, or 0 if the format is not recognised.

Return values:

- **0**: not recognised
- **1**: Speed Packer 2
- **2**: Atomik V2.5
- **3**: Ice V2.11
- **4**: Automation V5
- **5**: Ice V2.40
- **6**: Fire V2.0
- **7**: Speed Packer 3

All recognised packer formats have a special header to tell them apart; this command reads it.

**See also:** D CRUNCH, PAKSIZE

## PAKSIZE
`X=PAKSIZE(ADDR)` — return the uncompressed size of a packed file.

- **ADDR**: actual address of the packed data.
- **X**: the size the data will occupy once unpacked.

Use before D CRUNCH to reserve a bank large enough for the unpacked data.

**See also:** D CRUNCH, PAKTYPE

## FSTART
`X=FSTART(N,ADDR)` — return the position in memory of file N inside a GBP file bank.

- **N**: file number within the GBP bank.
- **ADDR**: actual address of the GBP file bank.
- **X**: address in memory where file N starts.

A GBP bank allows many files to be stored in just one memory bank, so lots of data can be loaded while still leaving lots of banks free. GBP banks are created with the GBP bank builder accessory (`GBP_BANK.ACB` in the extension archive; load with `ACCLOAD "GBP_BANK"` and access it from the HELP menu).

**See also:** FLENGTH, FOFFSET

## FLENGTH
`X=FLENGTH(N,ADDR)` — return the length of file N inside a GBP file bank.

- **N**: file number within the GBP bank.
- **ADDR**: actual address of the GBP file bank (created with the `GBP_BANK.ACB` builder accessory).
- **X**: length of file N in bytes.

**See also:** FSTART, FOFFSET

## FOFFSET
`X=FOFFSET(N,ADDR)` — return the offset of file N from the start of a GBP file bank.

- **N**: file number within the GBP bank.
- **ADDR**: actual address of the GBP file bank (created with the `GBP_BANK.ACB` builder accessory).
- **X**: offset of file N relative to the start of the bank (e.g. file two may be 1024 bytes from the start of the bank).

**See also:** FSTART, FLENGTH
