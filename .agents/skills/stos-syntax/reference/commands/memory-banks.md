# STOS commands: memory-banks

## LISTBANK
`LISTBANK` — List the banks in use.

LISTBANK lists the numbers of the banks currently reserved by a program, along with their location and size.

### Example
```text
load "BULLET.BAS"

listbank
Reserved memory banks:
1    sprites  S:$055000  E:$066500  L:$011500
3    music    S:$066500  E:$067300  L:$000E00
7    data     S:$067300  E:$069300  L:$002000
8    program  S:$069300  E:$069B00  L:$000800
9    data     S:$069B00  E:$06A200  L:$000700
10   data     S:$06A200  E:$06A900  L:$000700
11   data     S:$06A900  E:$06AF00  L:$000600
12   data     S:$06AF00  E:$06C000  L:$001100
13   data     S:$06C000  E:$06FF00  L:$003F00

S: =  The start address of the bank.
E: =  The end address of the bank.
L: =  The length of the bank.
```

As a default, all these values are printed in hexadecimal notation. You can change the format to decimal with the `HEXA OFF` command.

## HEXA ON/OFF
`HEXA ON/OFF` — Toggle hexadecimal listing.

- `HEXA OFF` — Sets bank listings to decimal notation.
- `HEXA ON` — Sets bank listings to hexadecimal format.

### Example
```text
load "BULLET.BAS"
hexa off
listbank
Reserved memory banks:
1    sprites  S:348160  E:419072  L:7091
3    music    S:419072  E:422656  L:3584
7    data     S:422656  E:430848  L:8192
8    program  S:430848  E:432896  L:2048
9    data     S:432896  E:434688  L:1792
10   data     S:434688  E:436480  L:1792
11   data     S:436480  E:438016  L:1536
12   data     S:438016  E:442368  L:4352
13   data     S:442368  E:458496  L:16128
```

> [!NOTE] Unverified: bank 1's length is printed as L:7091 here, but the same bank in the LISTBANK example above is listed as L:$011500 (= 70912 in decimal). The manual contradicts itself; transcribed verbatim.

## RESERVE
`RESERVE` — Reserve a bank of memory.

Any banks used by the sprites, music, icons, 3D extensions, and the menus are allocated automatically by the system. The RESERVE command allows you to allocate any other banks you require. Each different type of bank has its own individual form of the RESERVE instruction:

- `RESERVE AS SCREEN bank` — Reserves a temporary bank of memory for a screen. This bank is always 32k long. See Chapter 7.
- `RESERVE AS DATASCREEN bank` — Reserves a permanent bank of memory 32k long for use as a screen. This screen is saved along with your program, so it's great for title screens. See Chapter 7.
- `RESERVE AS SET bank,length` — Reserves a permanent bank of memory *length* bytes long for use as a character set. See Chapter 8.
- `RESERVE AS WORK bank,length` — Reserves a temporary bank for use as a workspace *length* bytes long.
- `RESERVE AS DATA bank,length` — Reserves a permanent bank of memory *length* bytes long for use as a workspace.

Note that *bank* may be any number between 1-15. Since banks 1 to 4 are normally reserved by the system, it's wisest to leave these banks alone. *Length* is automatically rounded up to the nearest 256-byte page. The only other limit to the length of a bank is the amount of available memory.

### Example
```text
new
hexa off
reserve as screen 5
listbank
Reserved memory banks:
5 screen S: 950016 E: 982784 L: 32768
```

This reserves bank number 5 as a temporary screen. Now type:

```text
clear
listbank
```

As you can see, bank 5 has now been completely erased. In order to create a more permanent bank, enter:

```text
reserve as datascreen 5
listbank
clear
listbank
Reserved memory banks:
5 dscreen S: 950016 E: 982784 L: 32768
```

Bank 5 is totally unaffected by the `clear` command. We'll now demonstrate how this screen can be loaded with real data.

```text
screen copy logic to 5              Copies the current screen to bank 5.
cls                                 Erase screen.
screen copy 5 to logic              Copies bank 5 back to current screen, and
                                    restores it.
```

For more information about SCREEN COPY see Chapter 7.

## RESERVE AS DATA
`RESERVE AS DATA bank,length` — Reserve a permanent bank of memory.

- **bank**: bank number to reserve (1-15). Banks 1-4 are normally reserved by the system.
- **length**: size of the bank in bytes; automatically rounded up to the nearest 256-byte page.

RESERVE AS DATA reserves a permanent bank of memory *length* bytes long for use as a workspace. Permanent banks only need to be defined once, and are subsequently saved along with your program automatically. Unlike temporary banks, permanent banks are unaffected by the `CLEAR` command.

## RESERVE AS WORK
`RESERVE AS WORK bank,length` — Reserve a temporary workspace bank.

- **bank**: bank number to reserve (1-15). Banks 1-4 are normally reserved by the system.
- **length**: size of the bank in bytes; automatically rounded up to the nearest 256-byte page.

RESERVE AS WORK reserves a temporary bank for use as a workspace *length* bytes long. Temporary banks are reinitialised every time a program is run. Furthermore, unlike permanent banks, temporary banks are erased from memory by the `CLEAR` command.

## BCOPY
`BCOPY #source TO #dest` — Copy the entire contents of one bank to another.

- **source**: the source bank number (1-15).
- **dest**: the destination bank number (1-15).

BCOPY copies the entire contents of bank number *source* into bank number *dest*. As usual *source* and *dest* can range from 1-15.

### Example
```text
BCOPY 5 TO 6
```

Copies bank 5 into bank 6.

## BGRAB
`BGRAB prgno [,b]` — Copy some or all banks from a program into the current program.

- **prgno**: program number to copy from. Numbers 1-4 denote one of the four programs which can be stored in memory at any one time; numbers 5-16 represent an accessory.
- **b**: optional bank number to copy (1-15).

BGRAB copies one or more banks stored at program number *prgno* into the current program. If the optional bank number *b* is not included, then all the banks attached to program number *prgno* are copied into the current program, and any other banks of memory which are linked to this program are erased. Otherwise, the bank number specifies one bank which is to be transferred into the current program. All other banks remain unaffected.

This instruction is used to great effect by many of the accessories on the disc.

## ERASE
`ERASE b` — Delete a bank.

- **b**: the bank number to delete (1-15).

ERASE deletes the contents of a memory bank *b*. Any memory used by this bank is freed for use by your program.

## START
`bs=START(b)` — Get the start address of a bank.

- **b**: bank number (1-15).
- **prgno**: program number (1-16); values greater than 4 refer to accessories.

This function returns the start address of bank number *b* in the ST's memory.

- `START(b)` — Returns the start of bank *b* in the current program.
- `START(prgno,b)` — Returns the start of bank number *b* in program *prgno*.

### Example
```text
reserve as screen 10
print start(10)
```

## LENGTH
`bl=LENGTH(b)` — Get the length of a bank.

- **b**: bank number (1-15).
- **prgno**: program number (1-16); values greater than 4 refer to accessories.

This function returns the length in bytes of bank number *b*. If a value of zero is returned by LENGTH, then bank *b* does not exist.

- `LENGTH(b)` — Gets the length of bank *b* in the current program.
- `LENGTH(prgno,b)` — Gets the length of bank *b* in program number *prgno*.

### Example
```text
new
reserve as screen 5
print length(5)
32768
erase 5
print length(5)
0
```

## SAVE
`SAVE "filename.ext"[,options]` — Save part or all of a STOS Basic program.

The SAVE instruction provides a general and straightforward way of saving a STOS Basic program on to the disc. Unlike the equivalent instruction found in most other versions of Basic, STOS also allows you to save a variety of other types of information. This is determined by the extension of the filename used in the SAVE command. Here is a summary of the various data types, along with their extensions:

- `.BAS` — Normal Basic program.
- `.ACB` — Accessory; load using ACCLOAD.
- `.PI1`, `.PI2`, `.PI3` — Degas format screen shot (low, medium, high resolution).
- `.NEO` — Neochrome format; low resolution only.
- `.MBK` — One memory bank.
- `.MBS` — All current banks.
- `.VAR` — All currently defined variables.
- `.ASC` — Ascii listing.
- `.PRG` — Run-only program; executable directly from desktop.

If none of these extensions are used, then STOS adds .BAS to the filename automatically, and saves the current Basic program on to the disc. Any existing program of the same name will be renamed with the extension .BAK.

**Basic programs:** `SAVE "Filename.BAS"` saves the program with any current memory banks on to the disc under the name Filename.BAS. If a file with the same name already exists, this is overwritten.

**Accessories:** `SAVE "Filename.ACB"` saves the Basic program as an accessory. This program can be loaded using ACCLOAD, and accessed from the HELP menu at any time.

**Degas images:** `SAVE "Filename.PI1"[,address of screen]` (similarly `.PI2`, `.PI3`) saves a copy of the screen to the disc in Degas format. The extensions indicate the resolution of the image: `.PI1` = low resolution, `.PI2` = medium resolution, `.PI3` = high resolution. The screen address is optional; if omitted, the current screen is saved. Any screen saved in this manner can be subsequently edited directly from Degas.

```text
save "screen.PI1"
cls
load "screen.PI1"
```

**Neochrome:** `SAVE "Filename.NEO"` saves a low resolution screen in Neochrome format. This file can be either loaded into a Basic program, or modified from within Neochrome.

**Memory banks:** `SAVE "Filename.MBK",b` stores the memory bank with number *b* on to the disc; it can be loaded back again using LOAD. `SAVE "Filename.MBS"` saves all the banks allotted to the current program in one large file.

**Variables:** `SAVE "Filename.VAR"` saves all the currently defined variables directly on to the disc.

**Ascii listings:** `SAVE "Filename.ASC"` lists the Basic program to a file in Ascii format. This file can now be edited outside STOS Basic by a wordprocessor or a text editor. Note that the banks of memory are not output by this function.

**Run-only programs:** `SAVE "Filename.PRG"` saves a version of your program in a special format which allows it to be loaded and executed straight from the Gem desktop. In order to use this function, you should first prepare a disc using the STOSCOPY.ACB accessory, which makes a copy of the entire \STOS\ directory on the disc. NEVER SAVE A RUN-ONLY PROGRAM ON THE ORIGINAL SYSTEM DISC!

When you save one of these programs, two files with the same name are created on the disc. One file has the extension .BAS and is stored in the \STOS\ folder. The second file lies outside the folder, and has the .PRG extension. It is this file which can be executed from the GEM desktop. When a run-only program terminates or an error occurs, it immediately returns to Gem.

### Example
Generate a disc with the correct files using a freshly formatted disc in conjunction with the STOSCOPY.ACB accessory. Now load the sprite editor into memory:

```text
load "sprites.acb"
```

Place the save disc into the drive, and type:

```text
save "sprites.prg"
```

At this point STOS Basic will ask you to confirm that you really wish to save this program. Enter Y or y at this prompt. To test the result, quit from STOS Basic using the SYSTEM command, and double click on the file sprites.prg.

### Gotchas
- Any attempt to execute the STOS Basic editor from a run-only program will crash the ST completely.
- The files PIC.PI1 and PIC.PI3 in the STOS folder contain low and high resolution pictures which will be displayed automatically during loading. You can omit these files from the disc to save space.
- The default colours used by your program will be the standard ones used by the Gem Desktop, and not the normal STOS Basic colours.
- Any of your own programs installed as RUN ONLY may be freely distributed or sold providing you acknowledge that they were written in STOS Basic and use the protect accessory when giving the disc to anyone who has not bought a copy of STOS Basic.
- If you place the run-only program in the \AUTO\ folder it will load and run automatically, whenever the disc is booted up.

**See also:** LOAD, BSAVE

## BSAVE
`BSAVE file$, start to end` — Save a block of memory in binary format.

- **file$**: the destination filename.
- **start**: the start address of the memory block.
- **end**: the end address of the memory block.

The memory stored between *start* and *end* is saved to the file *file$*. The data is saved out as it is in memory with no special formatting. You can use this function for various tasks, one of which would be to save out a character set from bank 5.

### Example
```text
bsave "\STOS\8X8.CRO", start (5) to start (5)+length (5)
```

**See also:** BLOAD

## LOAD
`LOAD "filename.ext"[,options]` — Load part or all of a STOS Basic program.

The LOAD instruction complements SAVE by allowing you to enter either a program or data file from the disc. Here is a list of the various types of files which may be loaded using this command:

- Basic programs: `.BAS`, `.BAK`, `.ACB`, `.ASC`
- Images: `.NEO`, `.PI1`, `.PI2`, `.PI3`
- Memory banks: `.MBK`, `.MBS`
- Variables: `.VAR`
- Machine-code programs: `.PRG`

See SAVE for a fuller discussion of these extensions.

**Basic programs:** `LOAD "Filename"` loads a Basic program, assuming the extension ".BAS". `LOAD "Filename.BAS"` is identical. `LOAD "Filename.BAK"` loads a backup of a Basic program created when a same-named file was saved with an automatic .BAK rename. `LOAD "Filename.ACB"` loads an accessory as a normal Basic program, so it can be edited and debugged in the usual way.

```text
load "config.bas"
run
```

```text
load "type.acb"
list
```

**Ascii files:** `LOAD "Filename.ASC"` loads an Ascii version of a Basic program, created using either a text editor, or another version of Basic. Note that this program must have line numbers, and be in plain Ascii; First Word users should turn the WP option off before exporting a program into STOS Basic. This instruction does not erase the current program; instead the new file is merged with this program.

**Memory banks:** `LOAD "Filename.MBK"[,b]` loads a single data file into a memory bank. If the optional destination *b* is included, then the file is loaded directly into bank number *b* (1-15). Otherwise the file is loaded back into the bank from which it was saved. Any existing data in this bank is erased during the loading process. Furthermore, the LOAD instruction automatically reserves a bank of the appropriate type if it has not already been defined.

```text
new
load "sprdemo.mbk"
load "musdemo.mbk"
load "icondemo.mbk"
listbank
```

`LOAD "Filename.MBS"` loads a series of banks stored in a single file. These banks are loaded directly into their original bank numbers. If these banks already exist, the old versions are erased.

```text
save "BANKS.MBS"
new
listbank
load "BANKS.MBS"
listbank
```

As you can see, all the banks have been loaded in one operation.

**Variables:** `LOAD "Filename.VAR"` loads a list of variables stored on the disc using `SAVE "filename.VAR"`. Any currently existing variables are replaced. Note that this instruction affects ALL the variables in the program.

```text
new
10 dim A(100)
20 for X=1 to 100
30 A(X)=X
40 next X
50 save "numbers.VAR"
```

Run this program with a disc in the drive. Now type in:

```text
new
load "numbers.VAR"
for X=1 to 100:print A(X):next x
```

See how the array A has been automatically defined by the load operation.

**Images:** `LOAD "Filename.PI1"[,address of screen]` (similarly `.PI2`, `.PI3`) loads a Degas format picture file from the disc. If the address of the screen is not included, the image is loaded into the current screen. Otherwise it is loaded into the screen at *address*; normally this address will point to the start of a memory bank defined as either a SCREEN or DATASCREEN. Remember that PI1 denotes a low resolution screen, PI2 medium resolution, and PI3 high resolution.

Place the disc containing the \STOS folder into your disc drive and type:

```text
cls
mode 0
load "\STOS\PIC.PI1"
```

Or for a monochrome monitor:

```text
load "\STOS\PIC.PI3"
```

These commands load the STOS title screen into the ST's memory.

**Machine-code programs:** `LOAD "Filename.PRG",b` loads a machine-code program into a memory bank number *b*. Any program you wish to use in this manner should be stored in TOS relocatable format, and must be placed in a file ending with the ".PRG" extension. DO NOT TRY TO USE GEM-BASED PROGRAMS FOR THIS PURPOSE! You should also avoid accessing any of the memory management functions from Gemdos. All other functions may be used, providing you take care. You can call one of these functions using the CALL instruction:

```text
CALL START(Bank number)
```

Note that when you copy a bank containing a program into another bank, this is automatically relocated for you.

**See also:** SAVE, BLOAD

## BLOAD
`BLOAD file$,addr` or `BLOAD file$, #bank` — Load binary information into a specified address or bank.

- **file$**: the file to load.
- **addr**: the memory address at which to load the data.
- **bank**: the bank number to load into.

This function loads binary data without altering the incoming information. There are two forms:

- `BLOAD file$,addr` — The file *file$* is loaded into the memory address *addr*.
- `BLOAD file$, #bank` — *file$* is loaded into *bank*; the address at which the data resides once loaded is the start address of the bank. This start value can be found with `bkaddr = start (bank)`.

### Example
```text
bload "mouse.acb", physic
```

Loads in the mouse accessory at the memory address of the physical screen.

**See also:** BSAVE

## ACCLOAD
`ACCLOAD "name"` — Load an accessory.

The STOS Basic accessories are special programs which lie dormant in the ST's memory until you call them up using the Help key. Before you can use one of these accessories you must first load it into memory using the ACCLOAD command.

`ACCLOAD "name"` loads the accessory from the file *name* into memory. Any normal Basic programs you have entered will be completely unaffected.

You can use this function to load all the accessories stored on a disc into memory at once. In order to do this, simply specify a name of `*`.

### Example
```text
accload "sprites.ACB"
```

Load all the accessories stored on a disc:

```text
accload "*"
```

Note that you can also use CONFIG.BAS to install a list of these accessories permanently. This is very wasteful of memory and should be used with caution by users restricted to a standard 520ST.

## ACCNEW
`ACCNEW` — Remove all currently installed accessories.

ACCNEW erases all the accessories from memory. It is often used in conjunction with ACCLOAD to remove any unwanted accessories before loading a new one.

### Example
```text
accnew:accload "*"
```

**See also:** ACCNB

## ACCNB
`ACCNB` — Get accessory number.

ACCNB returns a value of zero if a program is not installed as an accessory, and a number between 4 and 15 if it is. This number represents the program number of the accessory. It's often useful for an accessory to be able to tell whether it is executing as an accessory or directly as a Basic program.

### Example
```text
new
10 ? accnb
20 wait key
save "acctest.acb"
accnew
accload "acctest.acb"
```

If you run the program directly from the editor, the number zero will be printed. But if you call up the accessory named acctest from the Help menu, the number displayed will be equal to the function key you pressed + 4.

