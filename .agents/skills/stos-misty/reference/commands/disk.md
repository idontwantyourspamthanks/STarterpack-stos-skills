# Misty commands: Disk

## FLOPRD
`FLOPRD Buffer,NumSecs,Side,Track,Sector,Drive` — Read Numsecs starting at Sector and store at Buffer.

- **Buffer**: actual address to store the sectors, e.g. `start(10)`
- **NumSecs**: number of sectors to read
- **Side,Track,Sector**: disk position to start reading from
- **Drive**: drive number

You can achieve the same thing with a TRAP call, but this is slightly faster and easier to remember. The buffer address must be an actual address (`start(bank)`, not a bare bank number); no real-number parameters.

### Example
```stos
10 reserve as work 10,512
20 floprd start(10),1,0,0,1,0
```

### Gotchas
- Do not pass DRIVE as the drive parameter — the author tried it and STOS didn't like it very much.

**See also:** FLOPWRT, MEDIACH

## FLOPWRT
`FLOPWRT Buffer,NumSecs,Side,Track,Sector,Drive` — Write sectors to disk.

- **Buffer**: actual address of the data to write
- **NumSecs**: number of sectors to write
- **Side,Track,Sector**: disk position to start writing at
- **Drive**: drive number

**See also:** FLOPRD, MEDIACH

## MEDIACH
`MEDIACH (D)` — Checks whether the disk in drive D has been changed.

- **D**: drive number

Returns:
- 0 - Definitely changed
- 1 - Maybe changed
- 2 - Not changed

This command can be achieved with a call to TRAP also.

### Example
```text
print mediach (0)
```

### Gotchas
- The manual says this command doesn't work correctly at the moment (the author thinks), but he doesn't know why — it could be that his documentation on the BIOS is incorrect.

> [!NOTE] Unverified: the standard BIOS Mediach convention is 0 = not changed, 1 = maybe changed, 2 = definitely changed — the reverse of the list printed here. Given the author's own doubt about this command, treat the return values with caution.

**See also:** FLOPRD, FLOPWRT, NDRV

## NDRV
`NDRV` — Returns the number of drives attached to the computer.

This can be achieved with a deek to a system variable, but the author thought it merited a command seeing as he can never remember the correct address.

### Example
```text
print ndrv
```

**See also:** MEDIACH
