# Missing Link commands: text

## TEXT
`TEXT scr,font,tadr,x,y` — fast replacement for PRINT, drawing on one bitplane.

- **scr**: screen address — `back`, `physic`, `logic` or a memory bank via `start(bank)`
- **font**: font number — 0 to 2 are the default STOS low/medium/high resolution character sets, 3 onwards selects a font bank
- **tadr**: address of the text (use `varptr(T$)` for a STOS string)
- **x,y**: position of the text in text co-ordinates

TEXT only prints on 1 bitplane and is much, much faster than PRINT. It can print on any screen or memory bank, use other fonts without opening a window, and needs no LOCATE.

### Example
```stos
30 T$="Register now!"+chr$(0)
40 text logic,0,varptr(T$),10,10
```

### Gotchas
- The text must end with a 0 byte; append `chr$(0)` to STOS strings.
- Bug (documented in the DEANO tutorial): TEXT prints in one pen colour only — the PEN command has no effect on the printed string.
- To print a number, convert it with the STRING command first; TEXT cannot print a number variable directly.
- To print into a bank, `reserve as screen 5` and pass `start(5)` as SCR.

**See also:** STRING, PRINT

## STRING
`tadr = STRING (num)` — convert an integer to a string for the TEXT command.

- **num**: the number to convert (integers only!)
- **tadr**: returned as the address of the string, ready to pass directly to TEXT

Much faster than STR and specifically designed for TEXT. The string has two spaces added to the end (so repeated prints overwrite leftover digits).

### Example
```stos
30 T=12345 : ADR=string(T)
40 text logic,0,ADR,10,11
```

### Gotchas
- Integers only.
- Do not use VARPTR on the result — STRING already returns the address.

**See also:** TEXT, STR
