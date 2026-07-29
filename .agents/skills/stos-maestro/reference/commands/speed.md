# Maestro commands: Speed

## SAMSPEED
`SAMSPEED n` — Set the sampling rate.

- **n**: rate in KHz, 5 to 22; 10 KHz is the default

Sets the rate which will be used for any subsequent sampler commands. Although the STOS Maestro Plus cartridge is capable of working at speeds of up to 32 KHz, STOS Basic programs are restricted to a maximum of 22 KHz (STOS is too busy handling sprites and the other interrupts to play back faster). To play a 32 KHz sample from STOS Basic, compress it first with the Pack option from the FX menu of MAESTRO.PRG and play the packed sample at 16 KHz.

### Example
```text
load "voices.mbk":rem Created with MAESTRO.ACB
```
```stos
10 click off:sound init
20 for i=5 to 22
30 samspeed i:samplay 1:wait 20
40 next i
```

### Gotchas
- Issuing SAMSPEED n cancels automatic mode (see SAMSPEED AUTO).

**See also:** SAMSPEED AUTO, SAMSPEED MANUAL, SAMRECORD

## SAMSPEED AUTO
`SAMSPEED AUTO` — Enter automatic sampling mode.

Automatically selects the appropriate sample speed for the current sample. Automatic mode expects the speed of the sample to have been encoded into the current memory bank during the recording process; this information is included with all samples produced using the STOS Maestro sampler program. Using AUTO with samples created from another source — such as the SAMRECORD function — generates a syntax error. Automatic mode is effectively cancelled the next time the sampling rate is changed with SAMSPEED n.

### Example
```text
load "voices.mbk":rem Load some sound effects
```
```stos
10 click off:sound init
20 print "Default speed":samplay 1
30 print "Hit a key to continue":wait key
40 samspeed auto:rem Set appropriate speed automatically
50 print "Recorded speed":samplay 1
60 wait key
```

### Gotchas
- Errors on samples without an encoded Maestro speed (e.g. anything recorded with SAMRECORD, which does not store its rate).
- The underlying playback engine in SOURCE.S behaves differently: if the "JON" rate code is not found it silently falls back to the current rate rather than erroring. The STOS command enforces the error. See errata.md.

**See also:** SAMSPEED, SAMSPEED MANUAL, SAMRECORD

## SAMSPEED MANUAL
`SAMSPEED MANUAL` — Exit automatic sampling mode.

Exits from automatic playback mode and immediately returns the sample speed to the rate set by the most recent SAMSPEED n command in the program.

### Example
```text
load "voices.mbk":rem Loads some sound effects
```
```stos
10 click off:sound init
20 samspeed 20:rem Set very fast speed
30 print "20 KHz":samplay 1
40 print "Hit a key to continue":wait key
50 samspeed auto:rem Set proper speed
60 print "Recorded speed":samplay 1
70 wait key:samspeed manual:rem Set samspeed back to 20KHz
80 print "20 KHz again":samplay 1:wait key
```

**See also:** SAMSPEED, SAMSPEED AUTO
