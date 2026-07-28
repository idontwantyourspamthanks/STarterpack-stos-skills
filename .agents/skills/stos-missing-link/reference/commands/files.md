# Missing Link commands: File handling

All addresses must be "actual": use `start(bank)` for memory banks, and `varptr(F$)` for filename strings, which must end with a `chr$(0)` zero byte. File numbers inside file-banks are numbered from 0.

## DLOAD
`l = DLOAD (fadr,adr,ofs,num)` — load a byte range from a disk file to any address.

- **fadr**: address of the filename (with a 0-byte at the end)
- **adr**: address to load to (screen or memory bank)
- **ofs**: offset to start loading from within the file
- **num**: number of bytes to read
- **l**: returned number of bytes actually read

DLOAD and DSAVE provide complex file loading and saving, allowing the easy creation of both archives and data-bases: you can load just part of a file, starting at any byte offset.

### Example
```stos
10 F$="PIC.DAT"+chr$(0)
20 L=dsave(varptr(F$),physic,0,32032)
30 L=dload(varptr(F$),back,0,32032)
40 get palette(back)
```

### Gotchas
- The community tutorial claims DLOAD only reads files written by DSAVE (a "special format" other programs can't load); the official doc describes plain offset/length file I/O with no special format. Treat the tutorial claim as unverified — see errata.md.

**See also:** DSAVE, REAL LENGTH

## DSAVE
`l = DSAVE (fadr,adr,ofs,num)` — save a byte range from any address to a disk file.

- **fadr**: address of the filename (with a 0-byte at the end)
- **adr**: address to save from
- **ofs**: offset to start saving from within the file
- **num**: number of bytes to write
- **l**: returned number of bytes actually written

The counterpart to DLOAD: saves NUM bytes from ADR into the file at offset OFS, so you can build up archives and data-bases one record at a time. See the DLOAD example above.

**See also:** DLOAD

## REAL LENGTH
`r = REAL LENGTH (fadr)` — return the depacked size of a packed disk file.

- **fadr**: pointer to the filename (with a zero-byte at the end)
- **r**: depacked length of the file, or 0 if the file was not packed or didn't exist

Vital for programs which have to reserve memory banks exactly the size of a depacked file: check the real length first, reserve, load, then DEPACK.

### Example
```stos
10 F$=fileselect$("*.*","Select a file",4)
20 if F$="" then end
30 F$=F$+chr$(0)
40 SZ=real length(varptr(F$))
50 if SZ=0 then print "Not packed!" : end
60 print "Depacked size is";SZ
```

**See also:** DEPACK, DLOAD

## BANK LOAD
`BANK LOAD fadr,adr,num` — load one file from a disk-based file-bank.

- **fadr**: pointer to the file-bank's filename (zero-byte terminated)
- **adr**: address to load the file to
- **num**: file number to load from the bank (starting at 0)

File-banks are special archives holding all the data files a game would otherwise leave lying around on disk — e.g. 20 maps in one large .BNK file instead of 20 separate files. This cuts down the file count and speeds up loading considerably. Make file-banks with the MAKEFBNK utility (see make-utility.md); files inside are numbered from 0.

### Example
```stos
10 reserve as work 10,free
15 F$="MY_BANK.BNK"+chr$(0)
20 bank load varptr(f$),start(10),4
30 bload "MY_BANK.BNK",start(10)
40 bank copy start(10),physic,6
```

**See also:** BANK COPY, BANK LENGTH, BANK SIZE

## BANK COPY
`BANK COPY adr1,adr2,num` — "load" one file from a file-bank already in memory.

- **adr1**: address of the file-bank in memory (previously BLOADed)
- **adr2**: address to copy the file to
- **num**: file number to copy (starting at 0)

Written to make memory-enhanced versions of your games easy: BLOAD the whole file-bank into memory once, then BANK COPY individual files out of it instead of hitting the disk. See the BANK LOAD example above (lines 30-40).

**See also:** BANK LOAD, BANK SIZE

## BANK LENGTH
`r = BANK LENGTH (fadr,num)` — return the length of one file in a disk-based file-bank.

- **fadr**: pointer to the file-bank's filename (zero-byte terminated)
- **num**: file number to check (from 0)
- **r**: the file size in bytes

Use it to find out how big a file is before reserving a bank for a BANK LOAD.

### Example
```stos
5 F$="MY_BANK.BNK"+chr$(0)
10 L=bank length(varptr(F$),4)
20 reserve as work 10,L
30 bank load varptr(F$),start(10),4
40 erase 10
50 reserve as work 10,100000
60 bload "MY_BANK.BNK",10
70 L=bank size(start(10),5)
80 reserve as work 11,L
90 bank copy start(10),start(11),5
```

**See also:** BANK LOAD, BANK SIZE

## BANK SIZE
`r = BANK SIZE (adr,num)` — return the length of one file in a file-bank already in memory.

- **adr**: address of the file-bank in memory
- **num**: file number to check (from 0)
- **r**: the file size in bytes

The in-memory counterpart to BANK LENGTH, used with BANK COPY — see the BANK LENGTH example above (lines 60-90).

### Gotchas
- STOS 3D tip from the official doc: you can turn all your 3D files and surfaces into one big file-bank by cheating — install a small ramdisk the size of the largest 3D file, BANK LOAD the file into memory, BSAVE it into the ramdisk, then TD LOAD it back in.

**See also:** BANK COPY, BANK LENGTH

## DEPACK
`l = DEPACK (adr)` — depack a data file packed with a common ST packer.

- **adr**: address of the packed file (screen or memory bank)
- **l**: length of the depacked file, or 0 if it was not packed

Depacks data packed with Atomik v3.5, Ice v2.4, Fire v2.2, Automation v5.1, Speed v2.0 and Speed v3.0. Works well with MODs and chip music such as Mad Max files. Reserve the bank to the original (depacked) size of the file — use REAL LENGTH to find it.

### Example
```stos
10 bload "packed.dat",back
20 L=depack(back)
30 if L=0 then print "Not packed!" : end
40 print "depacked size is";L
```

### Gotchas
- The data is depacked on top of itself, so make sure you have enough room at the end of the workspace: reserve the bank to the file's depacked size, not its packed size.

**See also:** REAL LENGTH
