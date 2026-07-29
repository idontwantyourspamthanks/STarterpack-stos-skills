# Blitter extension commands: Operations

## blit hop
`BLIT HOP hop` — Set the operation to perform with the halftone pattern you have set.

- **hop**: halftone operation, one of four values:
  - 0 = all ones
  - 1 = half tone
  - 2 = source
  - 3 = source and half tone

If you don't want to use the half tone, set BLIT HOP to 2.

**See also:** blit halftone, blit h line, blit op

## blit op
`BLIT OP op` — Set the logical operation of the data being copied.

- **op**: logical operation; the operations are the same as for BLIT HOP, with two extra options:
  - 0 = all zeros
  - 15 = all ones

**See also:** blit hop, blit copy

## blit h line
`BLIT H LINE number` — Set the line number to start the half tone mask when it's being used.

- **number**: starting halftone line, ranges from 0 to 15

**See also:** blit halftone, blit hop, blit smudge

## blit smudge
`BLIT SMUDGE smudge` — Control whether the BLIT SKEW value is used as the BLIT H LINE number.

- **smudge**: 1 = the data set in BLIT SKEW is used as the BLIT H LINE number; 0 = it isn't ("so phooey to you")

**See also:** blit skew, blit h line

## blit skew
`BLIT SKEW skew` — Set the number of bits to be shifted to the right before being copied to the destination address.

- **skew**: bits to shift right, ranges from 0 to 15

**See also:** blit smudge, blit op

## blit nfsr
`BLIT NFSR n` — No Final Source Read: when set, the last source read on every line is not performed.

- **n**: 1 = skip the last source read on every line

**See also:** blit fxsr, blit skew

## blit fxsr
`BLIT FXSR n` — Force Extra Source Read: when set, an extra source read is performed on every line.

- **n**: 1 = perform an extra source read on every line

**See also:** blit nfsr, blit skew
