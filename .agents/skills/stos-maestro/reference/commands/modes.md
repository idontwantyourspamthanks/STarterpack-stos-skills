# Maestro commands: Modes

## SAMLOOP ON
`SAMLOOP ON` — Repeat a sampled sound.

After this command has been performed, any sample subsequently played using SAMPLAY, SAMMUSIC or SAMRAW is continually repeated from beginning to end. Like all the sampling commands, SAMLOOP is accomplished using an interrupt routine, so once the loop is started the program can get on with other work.

### Example
```text
reserve as data 6,12000
bload "A:\sound\explsion.sam",6:rem Load a sample from the samples disc
```
```stos
10 click off:sound init:samspeed auto
20 samloop on
30 samraw start(6),start(6)+length(6)
40 print "Press a key to end"
50 wait key:samstop:samloop off:click on
```

### Gotchas
- Only affects FUTURE playback — it has no effect on a sample already playing; halt a running loop with SAMSTOP.

**See also:** SAMLOOP OFF, SAMSWEEP ON, SAMSTOP

## SAMLOOP OFF
`SAMLOOP OFF` — Exit from a sample loop.

Instructs the sample routine to play any future samples exactly once. This instruction has no effect on the sample which is currently being played — to halt an existing sample, use SAMSTOP instead.

### Example
```text
reserve as data 6,12000
bload "A:\sound\explosion.sam",6:rem Load a sample from the samples disc
```
```stos
10 click off:sound init:samspeed 10
20 samloop on:rem Repeat the next sample
30 samraw start(6),start(6)+length(6):rem Play sample
40 print "Press a key to end"
50 wait key:samstop:samloop off:rem Turn off looping
60 samraw start(6),start(6)+length(6):rem Play a single shot
```

### Gotchas
- Only affects FUTURE playback; use SAMSTOP for the currently-playing sample.

**See also:** SAMLOOP ON, SAMSTOP

## SAMDIR FORWARD
`SAMDIR FORWARD` — Play a sample from start to finish.

The normal state: all samples are played back in the direction they were originally recorded. SAMDIR FORWARD cancels the effect of SAMDIR BACKWARD.

### Gotchas
- Only affects FUTURE playback.

**See also:** SAMDIR BACKWARD, SAMSWEEP ON

## SAMDIR BACKWARD
`SAMDIR BACKWARD` — Play a sample backwards.

Reverses the action of all future playback commands: any subsequent samples are played backwards until cancelled by SAMDIR FORWARD. Surprisingly useful — reversing normal speech and altering the playback speed creates a convincing "alien" language (the technique used in the radio version of The Hitch-hiker's Guide to the Galaxy).

### Example
```text
reserve as data 6,10000
bload "A:\voice\gameover.sam",6:rem Load a sample from the samples disc
```
```stos
10 click off:sound init
20 samdir backward
40 samraw start(6),start(6)+length(6)
50 wait key:samstop
```
The manual then suggests adding `30 samloop on` and `55 samloop off` to loop the reversed sample.

### Gotchas
- Only affects FUTURE playback.

**See also:** SAMDIR FORWARD, SAMLOOP ON

## SAMSWEEP ON
`SAMSWEEP ON` — Repeatedly play a sample forwards and backwards.

Ideal for the generation of "swishing" noises like those produced by an aeroplane: the effect repeatedly cycles a sample forwards and backwards. Like SAMLOOP, the sweeping action only takes effect from the next sample which is played.

### Example
```text
reserve as data 6,784
bload "A:\sound\swosh.sam",6:rem Load a sample from the samples disc
```
```stos
10 click off:sound init
20 samsweep on:rem Start sweeping
30 samraw start(6),start(6)+784
50 wait key:samstop
```

### Gotchas
- Only affects FUTURE playback; stop a running sweep with SAMSTOP.

**See also:** SAMSWEEP OFF, SAMLOOP ON

## SAMSWEEP OFF
`SAMSWEEP OFF` — Stop the sweeping effect for the next sample.

Removes the sweeping effect from any sample subsequently played with SAMPLAY, SAMMUSIC or SAMRAW. Like SAMLOOP OFF it has no effect on the sample which is currently being performed.

### Gotchas
- Only affects FUTURE playback; use SAMSTOP for the currently-playing sample.

**See also:** SAMSWEEP ON, SAMSTOP
