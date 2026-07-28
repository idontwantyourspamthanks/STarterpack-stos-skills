# Memory banks

STOS Basic stores the data that sprites, screens, music and other resources need in up to 15 dedicated memory regions called **banks**. Each bank is identified by a number from 1 to 15, and every program held in memory carries its own private set of banks. Banks let binary data live next to your Basic program without occupying variable space or cluttering the listing.

Some banks are tied to a single purpose — sprites live in bank 1, icons in bank 2, music in bank 3, and bank 4 is held back for the 3D extension — while the rest are general-purpose and you choose what they hold.

## Permanent and temporary banks

Every bank is either **permanent** or **temporary**:

- **Permanent banks** survive `CLEAR` and `RUN`. They are saved automatically with the program, which makes them ideal for title screens, character sets, and any data that should travel inside the `.BAS` file.
- **Temporary banks** are reinitialised every time the program runs and are wiped by `CLEAR`. They suit scratch buffers and transient screens that you reload from disc at startup.

This single distinction drives the choice between `RESERVE AS DATASCREEN` and `RESERVE AS SCREEN`, and between `RESERVE AS DATA` and `RESERVE AS WORK`.

## Types of memory bank

| Class       | Stores                        | Allowed banks | Type      |
| ----------- | ----------------------------- | ------------- | --------- |
| Sprites     | Sprite definitions            | Bank 1 only   | Permanent |
| Icons       | Icon definitions              | Bank 2 only   | Permanent |
| Music       | Music                         | Bank 3 only   | Permanent |
| 3D          | Held for the 3D extension     | Bank 4 only   | Permanent |
| Set         | Character sets                | Banks 1-15    | Permanent |
| Screen      | A complete screen             | Banks 1-15    | Temporary |
| Datascreen  | A screen (saved with program) | Banks 1-15    | Permanent |
| Work        | Temporary workspace           | Banks 1-15    | Temporary |
| Data        | Permanent workspace           | Banks 1-15    | Permanent |
| Menu        | Menu lines                    | Bank 15       | Temporary |
| Program     | Machine-code program          | Banks 1-15    | Varies    |

Banks 1-4 are normally grabbed automatically by the sprite/icon/music/3D system, so for your own `RESERVE` calls it is wisest to pick from 5 upwards. Bank numbers passed to bank commands may be any value from 1 to 15.

## Reserving a bank

The `RESERVE` command allocates a bank. Each class has its own form:

- `RESERVE AS SCREEN bank` — a 32k temporary screen.
- `RESERVE AS DATASCREEN bank` — a 32k permanent screen, saved with the program (ideal for title screens).
- `RESERVE AS SET bank,length` — a permanent character set.
- `RESERVE AS WORK bank,length` — a temporary workspace.
- `RESERVE AS DATA bank,length` — a permanent workspace.

Requested lengths are rounded up to the nearest 256-byte page; the only other ceiling is free memory. A typical session looks like:

```text
new
hexa off
reserve as screen 5
listbank
Reserved memory banks:
5 screen S:950016 E:982784 L:32768
```

`CLEAR` then wipes bank 5 because `SCREEN` is temporary. Repeating the experiment with `RESERVE AS DATASCREEN 5` produces a bank that survives `CLEAR` and is saved alongside the program.

## Inspecting banks

`LISTBANK` prints every reserved bank with its start address, end address and length. By default the figures are hexadecimal; `HEXA OFF` switches them to decimal and `HEXA ON` switches them back. This is the standard way to confirm what your program is carrying before a save.

## Copying and erasing banks

- `BCOPY source TO dest` copies the entire contents of one bank into another.
- `BGRAB prgno` copies every bank attached to program `prgno` into the current program; `BGRAB prgno,b` copies just bank `b`. Program numbers 1-4 are the four programs held in memory, and 5 upwards are accessories. This is how many supplied accessories pull ready-made sprite, icon and music banks into your own program.
- `ERASE b` frees bank `b` and returns its memory to the pool.

## Bank addresses and lengths

Two functions let a program reach into a bank by memory address:

- `START(b)` — the start address of bank `b`, or `START(prgno,b)` for a bank belonging to another program or accessory.
- `LENGTH(b)` — the length of bank `b` in bytes; returns zero if the bank does not exist.

```text
new
reserve as screen 5
print length(5)
32768
erase 5
print length(5)
0
```

## Saving and loading banks

STOS overloads the `SAVE` and `LOAD` filename extension to choose the data type. For banks specifically:

- `SAVE "file.MBK",b` writes a single bank to disc; `LOAD "file.MBK"` loads it back, optionally into a different bank with `LOAD "file.MBK",b`. The load automatically reserves a bank of the right type if one does not yet exist.
- `SAVE "file.MBS"` dumps every bank attached to the current program into one file; `LOAD "file.MBS"` restores them into their original bank numbers, erasing any existing contents.

For raw binary data without bank management, use `BSAVE file$,start TO end` and its partner `BLOAD file$,addr`, or `BLOAD file$,#bank` to load straight into a bank whose address you can then read with `START`. A typical use is dumping a character set:

```text
bsave "\STOS\8X8.CRO", start(5) to start(5)+length(5)
```

Loading a set of `.MBK` files for sprites, music and icons is the standard way to attach art to a program in one go:

```text
new
load "sprdemo.mbk"
load "musdemo.mbk"
load "icondemo.mbk"
listbank
```

## How banks interact with other file types

A few neighbouring extensions are worth knowing because they share the same workflow:

- `SAVE "file.BAS"` writes the program **together with all its permanent banks**. This is why `DATASCREEN`, `DATA` and `SET` banks travel with the program transparently.
- `SAVE "file.PI1"` / `.PI2` / `.PI3` (Degas) and `SAVE "file.NEO"` (Neochrome) save a screen, optionally taking an explicit screen address — typically the start of a `SCREEN` or `DATASCREEN` bank. `LOAD` with the same extensions loads the image back, defaulting to the current screen.
- `SAVE "file.ASC"` exports the listing as ASCII but deliberately omits the banks — useful for editing in a word processor, but the bank data must be reloaded separately.
- `LOAD "file.PRG",b` loads a TOS-relocatable machine-code program into bank `b`, which can then be called with `CALL START(b)`. Never feed GEM desktop programs through this route.

## Accessories

Accessories are special STOS programs that lie dormant in memory until summoned with the `HELP` key. They are loaded with `ACCLOAD` and removed with `ACCNEW`; each one occupies one of the accessory program slots above 4, which is why `BGRAB` and `START` use those numbers when reaching into an accessory's banks.

- `ACCLOAD "name"` loads `name.ACB` from disc, leaving any Basic program you are editing untouched. `ACCLOAD` with no argument loads every accessory on the current disc at once — convenient, but expensive on a 520ST.
- `ACCNEW` wipes all currently installed accessories; the idiom `accnew:accload "*"` swaps a whole set in one go.
- `ACCNB` returns 0 if the running program is not an accessory, or its accessory program number if it is. An accessory can test this to behave differently when launched normally versus from the `HELP` menu.

The same program can be saved as either a normal `.BAS` file or an `.ACB` accessory — the only real difference is whether you intend to call it up via `HELP`. The manual's `CLOCK.ACB` example shows the shape:

```stos
10 windopen 1,22,5,18,4,5
20 curs off
30 clw
40 print "DATE:";date$;
50 locate 0,1
60 print "TIME:";time$;
70 if inkey$="" then 50
80 curs on : default
```

The STOS disc ships with a standard set of accessories that allocate and edit the dedicated banks: `SPRITES.ACB` (sprite definer, bank 1), `FONTS.ACB` (character definer), `ICONS.ACB` (icon definer, bank 2), `MUSIC.ACB` (music, bank 3) and `COMPACT.ACB` (screen compactor), plus utilities such as `SCAN`, `ASCII`, `MOUSE`, `TYPE`, `DUMP` and `STOSCOPY`. Each editor writes its output into the appropriate bank; you then `BGRAB` or `SAVE` that bank into your own program.
