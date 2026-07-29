# STOS memory bank (.MBK) file format

The binary format of `.MBK` files (sprite banks and other memory banks), as
saved by the STOS sprite definer and compatible tools. Verified against the
Lemon&Lime exporter source (`web/src/lib/retro-export.ts`) and real files from
this project. Big-endian throughout.

## File header (18 bytes)

| offset | size | contents |
|--------|------|----------|
| 0x00 | 10 | `"Lionpoubnk"` — magic string |
| 0x0A | 2 | `00 00` padding |
| 0x0C | 2 | **bank number** (big-endian word; sprites must be bank 1) |
| 0x0E | 2 | `0x8100` constant |
| 0x10 | 2 | alloc size (file size padded to a multiple of 256) |

## Bank body (starts at 0x12)

| offset | size | contents |
|--------|------|----------|
| 0x12 | 4 | signature `19 86 19 87` |
| 0x16 | 4 | constant `0x12` |
| 0x1A | 8 | data length (`bodyLen - 4`, written twice) |
| 0x22 | 2 | sprite count |
| 0x24 | 4 | `0` |

## Directory (at 0x28, one 8-byte entry per sprite)

Each entry:

| size | contents |
|------|----------|
| 4 | offset of this sprite's block, **relative to 0x28** (absolute = 0x28 + offset) |
| 1 | width units (width / 16) |
| 1 | height in pixels |
| 2 | padding (`00 00`) |

The first offset is always `count * 8 + 36` (directory + PALT block sizes).

> Gotcha: bytes 4-5 of an entry read as a word look like a "size" (e.g. `0x0110`
> = 272 for 16x16) — it is NOT a size, it is widthUnits and height packed.

## PALT block (36 bytes, follows the directory)

`"PALT"` (4 bytes) then **16 big-endian colour words** immediately after.
Each word is `$0RGB` — 3 bits per channel, 0-7 (e.g. `$257` = R2 G5 B7).

> Gotcha: the block header is **4 bytes** ("PALT" only) — NOT 8. Reading the
> colours from +8 instead of +4 shifts every colour down two indices and
> produces garbage at the tail. (This exact mistake cost a full debugging
> session in this project.)

## Sprite blocks

Each sprite block is `height × widthUnits × 10` bytes, in two parts:

1. **Mask** — `height × widthUnits` words (2 bytes each). Bit `15-x` = 1 means
   pixel (row, x) is transparent.
2. **Image** — `height × widthUnits` groups of 4 plane words `[p0,p1,p2,p3]`
   (standard ST screen format). Bit `15-x` of plane `p` is bit `p` of the
   colour index for pixel (row, x).

| sprite size | mask | image | block total |
|-------------|------|-------|-------------|
| 16x16 | 32 bytes | 128 bytes | 160 bytes |
| 32x32 | 128 bytes | 512 bytes | 640 bytes |

## Notes

- Everything is big-endian (the 68000 way). A tool writing little-endian
  fields produces files STOS silently misreads.
- The bank number at 0x0C is authoritative: `load "file.mbk"` places the bank
  there with no override. Sprite banks must be 1.
- Palette count fields do not exist; the block is always exactly 16 words.
- Data length fields in the body are in-memory sizes, not on-disk block sizes.
