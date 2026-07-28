# Control commands: String and cursor

String-to-memory copy, relative cursor movement, cursor position save/restore, cyclic range addition, and a file-existence test. Source: CONTREG.DOC (V3.6b); CONTROL35.DOC (V3.5a) is identical for all of these commands.

## WRITE
`write STRING,ADDRESS` — copy a string into memory at ADDRESS.

- **STRING**: the string to copy.
- **ADDRESS**: destination address. If using banks this must be the actual start of the bank, e.g. `write "hello",start(10)` not `write "hello",10`.

Writes a copy of STRING starting at ADDRESS. Provides an easy way to bypass the infamous STOS string bug, and has the advantage over the STOS `copy` command that it will copy strings of non-even (odd) lengths.

### Example
```stos
10 reserve as data 10,10000
20 write "hello world",start(10)
```
The above is equivalent to the following:
```stos
10 reserve as data 10,1000
20 s=start(10)
30 a$="hello world"
40 al=len(a$)
50 for loop=1 to al
60 poke s+loop-1,asc(mid$(a$,loop,1))
70 next loop
```

### Gotchas
- Doc example line 40 reads `al=len$(a$)`; `len$` is a doc typo — STOS uses `len(a$)` (corrected above).

## CMOVE
`cmove INTEGER,INTEGER` — move the cursor relative to its current position.

- **INTEGER,INTEGER**: relative column and row offsets.

### Gotchas
- Remember to put a `;` after your PRINT statements, otherwise the cursor is moved to the next line.

**See also:** CREMEMBER, CRECALL

## CREMEMBER
`cremember` — store the current cursor position in a safe place.

Pair with CRECALL so subroutines can return the cursor to its original position on exit.

**See also:** CRECALL, CMOVE

## CRECALL
`crecall` — move the cursor back to its CREMEMBERed position.

Restores the cursor position saved by CREMEMBER. Together these two commands mean you can write subroutines which return the cursor to its original position on exit from the subroutine.

**See also:** CREMEMBER, CMOVE

## ADD
`A=add(A,I,L,R)` — add I to A, wrapping A cyclically into the range L to R.

- **A**: the value to adjust.
- **I**: increment to add.
- **L**, **R**: lower and upper bounds of the range.

Adds I to A and then ensures A is in the range L to R in a cyclical manner.

### Example
It is equivalent to the following code:
```stos
10 A=A+I
20 if A<L then A=R
30 if A>R then A=L
```

## EXIST$
`A=exist$(FILENAME$+CHR$(0))` — test whether a file exists at the current path.

- **FILENAME$+CHR$(0)**: filename with a trailing CHR$(0) terminator.

Returns true if the file FILENAME$ exists at the current path, false if it does not.

### Gotchas
- Despite the `$` in the name, EXIST$ returns a truth value used as an integer, not a string.
- The filename must be terminated with CHR$(0) as shown in the syntax.

**See also:** WRITE
