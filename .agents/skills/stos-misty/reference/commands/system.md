# Misty commands: System

## HARDKEY
`HARDKEY` — Returns the contents of the hardware keyboard register.

This was added as some music and assembly routines cut off the INKEY$ command, and it looks a lot nicer than the PEEK.

### Example
```stos
10 print "Press SPACE"
20 repeat : until hardkey=57
```

### Gotchas
- Do remember to put in a `clear key` at the end of your routine!

**See also:** KBSHIFT

## FREQ
`FREQ` — Return the frequency of the monitor (50 or 60).

Mono is always 70hz, so there's no point in returning it. This command will become more useful when (stroke if) the SETFREQ command is added.

### Example
```text
print freq
```

**See also:** RESVALID

## RESVALID
`RESVALID` — Returns TRUE if the reset vector is set and FALSE otherwise.

This can be very useful for either checking for a virus or to see if someone has one of those picture-ripper type programs in that uses the reset vector to install itself.

### Example
```stos
10 if resvalid then print "Lard!"
```

**See also:** WARMBOOT, FREQ

## SETRTIM
`SETRTIM x` — Sets the value of the REAL timer.

- **x**: new timer value

These 2 timing commands (SETRTIM and RTIM) were added after the authors had severe problems with some music types and some border-removal routines where the TIMER variable was needed. For instance, after playing some Synth-dream music TIMER would no longer update, which caused quite a lot of problems in games where you were to be invulnerable for the first 3 seconds or whatever.

### Example
```text
setrtim 0
```

**See also:** RTIM

## RTIM
`RTIM` — Returns the value of the REAL timer.

Added together with SETRTIM because some music and border-removal routines stop the normal TIMER variable updating — see SETRTIM.

### Example
```text
print rtim
```

**See also:** SETRTIM

## WARMBOOT
`WARMBOOT` — Causes a reset, as if you had pressed the reset button.

This command can be very useful for making sure people aren't mucking around with your programs. A reset is always disheartening to inept crackers...

### Example
```stos
10 repeat : g$=upper$(inkey$) : until g$<>""
20 if g$="Q" then warmboot
```

**See also:** RESVALID, AESIN

## AESIN
`AESIN` — Checks whether GEM is initialised or not.

This command is used to make sure a program that's supposed to run from the AUTO folder isn't being run from the desktop, which can be extremely useful for demos.

### Example
```stos
10 if aesin then ?"Do you like GEM or something?"
```

**See also:** WARMBOOT, BLITTER

## BLITTER
`BLITTER` — Checks for a blitter chip.

### Example
```stos
10 if blitter then ?"Huh!"
```

### Gotchas
- The manual itself says this command is untested, because neither of the authors has a blitter.

**See also:** AESIN

## SILENCE
`SILENCE` — Stops all sounds.

Very very useful for clearing those residual notes left when you stop a bit of music.

### Example
```stos
10 dreg(0)=1 : call start(10)
20 repeat : call start(10)+2 : until inkey$=" "
30 silence
```

**See also:** SETRTIM, RTIM

## KBSHIFT
`KBSHIFT` — Returns the values of the shift+special keys.

This command can be useful in games as you can test for combinations of different keys (as in the example, where 3 means both shift keys).

### Example
```stos
10 print "Press BOTH shift keys"
20 repeat
30 until kbshift=3
```

**See also:** HARDKEY

## KOPY
`KOPY Src, Dst, Size` — A super-fast version of the COPY command: copies Size number of bytes (EVEN!) from address Src to address Dst.

- **Src**: actual source address
- **Dst**: actual destination address
- **Size**: number of bytes to copy — must be EVEN

This command is about twice as fast as COPY. It is very, very useful for disting objects for demo coders. Addresses must be actual addresses (`start(bank)`, not a bare bank number); no real-number parameters.

### Example
```stos
10 cls back,1
20 kopy back,logic,32000
```

### Gotchas
- Make sure the number of bytes you copy is even! You may not like the consequences if you don't...

**See also:** FASTCOPY, SKOPY, COPY
