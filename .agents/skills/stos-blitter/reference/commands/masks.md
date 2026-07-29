# Blitter extension commands: Masks and counts

## blit endmask 1
`BLIT ENDMASK1 mask` — Set the destination mask for the first word of each line.

- **mask**: mask as a binary word, the same as in the SET LINE command

**See also:** blit endmask 2, blit endmask 3, blit x count

## blit endmask 2
`BLIT ENDMASK2 mask` — Set the destination mask for all the words in the middle of each line.

- **mask**: mask as a binary word, the same as in the SET LINE command

The command in the middle sets the mask for all the words in the middle. If you want a pinstripe effect, set the mask to `%1010101010101010`.

**See also:** blit endmask 1, blit endmask 3

## blit endmask 3
`BLIT ENDMASK3 mask` — Set the destination mask for the last word of each line.

- **mask**: mask as a binary word, the same as in the SET LINE command

**See also:** blit endmask 1, blit endmask 2

## blit x count
`BLIT X COUNT count` — Set the number of words to be read on a line.

- **count**: number of words per line

**See also:** blit y count, blit source x inc, blit endmask 1

## blit y count
`BLIT Y COUNT count` — Set the number of lines.

- **count**: number of lines

**See also:** blit x count, blit source y inc
