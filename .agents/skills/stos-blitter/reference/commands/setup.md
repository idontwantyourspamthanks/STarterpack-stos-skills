# Blitter extension commands: Setup

## blit halftone
`BLIT HALFTONE pat1,pat2,,,,,,,,,,,,,,pat16` — Set up a 16x16 halftone pattern.

- **pat1..pat16**: 16 pattern words; easiest to enter as binary words, so each digit represents a pixel

The pattern is used by subsequent blit operations according to the halftone operation selected with BLIT HOP.

**See also:** blit hop, blit h line, blit smudge

## blit source x inc
`BLIT SOURCE X INC inc` — Set the increment (in bytes) to the next source word on a line.

- **inc**: increment in bytes

The blitter copies one word at a time — each word is made up of two bytes. Set to 2 and it does a direct copy; set it to 4 and you only get every other word.

**See also:** blit source address, blit source y inc, blit dest x inc

## blit source y inc
`BLIT SOURCE Y INC inc` — Set the source line increment (in bytes).

- **inc**: increment in bytes

Works the same way as BLIT SOURCE X INC, but steps between lines of the source instead of words within a line.

**See also:** blit source address, blit source x inc, blit dest y inc

## blit remain
`BLIT REMAIN` — (inferred) Read remaining blitter status.

> [!NOTE] Unverified: present in the binary's token table but not described in any surviving doc. The name suggests it reports how much of the current blit remains to be done; treat the syntax and behaviour as inferred.

**See also:** blit busy, blit it

## blit source address
`BLIT SOURCE ADDRESS address` — Set the memory address of the blit source.

- **address**: source memory address; the value is rounded to an even number

**See also:** blit dest address, blit source x inc, blit x count

## blit dest x inc
`BLIT DEST X INC inc` — Set the increment (in bytes) to the next destination word on a line.

- **inc**: increment in bytes

Does the same trick as BLIT SOURCE X INC, but on the destination.

**See also:** blit dest address, blit dest y inc, blit source x inc

## blit dest y inc
`BLIT DEST Y INC inc` — Set the destination line increment (in bytes).

- **inc**: increment in bytes

The Y INC commands set the line increment in the same manner as the X INC commands set the word increment.

**See also:** blit dest address, blit dest x inc, blit source y inc

## blit dest address
`BLIT DEST ADDRESS address` — Set the memory address of the blit destination.

- **address**: destination memory address; the value is rounded to an even number

**See also:** blit source address, blit dest x inc, blit endmask 1
