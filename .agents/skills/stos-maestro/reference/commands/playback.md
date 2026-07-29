# Maestro commands: Playback

## SOUND INIT
`SOUND INIT` — Kill any existing sounds and prepare the ST's sound chip for the sampler instructions.

Normally called once at the start of a program, immediately after switching off the keyboard click: the keyboard click interferes with the sampler system, so it must be turned off with `click off` before sampling or playback.

### Example
```stos
10 click off:rem Switch off keyboard clicks
20 sound init:rem Initialise sound chip
```

### Gotchas
- Always precede with `click off` — the keyboard click interferes with the sampler.
- The playback commands run independently of the STOS Maestro Plus cartridge; no cartridge is needed for SOUND INIT.

**See also:** SAMPLAY, SAMSTOP, SAMSPEED

## SAMPLAY
`SAMPLAY n` — Play a sample from the current memory bank.

- **n**: sample number, 1 to 32, in the current memory bank (normally bank 5)

SAMPLAY plays one of the 32 possible samples stored in the current memory bank. Samples are played back using interrupts and are completely independent of the rest of the STOS system, so sound effects can be added to a game without slowing down the action. Only a single sample can be played at any one time: if a new sample is started before the existing one has completed, the old sample is immediately replaced — a feature that can be exploited for effects such as stuttering voices.

### Example
```text
load "effects.mbk"
click off:sound init:samspeed auto
samplay 1:rem Plays an explosion
samplay 2:rem Laser beam
samplay 3:rem Gun
```
Stutter effect:
```stos
10 click off:sound init:samspeed auto
20 for i=1 to 5
30 samplay 1:wait 5
40 next i
```

### Gotchas
- Incompatible with the STOS music functions: suspend music with `music freeze` before playing a sample and restart it with `music on` after the sample has completed.
- One sample at a time; starting a new sample cuts off the old one.

**See also:** SAMMUSIC, SAMBANK, SAMSTOP, SAMSPEED AUTO

## SAMSTOP
`SAMSTOP` — Terminate all current sampling operations.

Stops whatever the sampler is currently doing: playback (including loops and sweeps, which are otherwise unaffected by SAMLOOP OFF / SAMSWEEP OFF while running), SAMTHRU mode, or a SAMRECORD in progress.

### Example
```text
reserve as data 6,12000
bload "A:\sound\explsion.sam",6:rem Load a sample from the samples disc
```
```stos
10 click off:sound init:samspeed auto
20 samraw start(6),start(6)+length(6):rem Plays a sample
30 wait key:samstop
```

**See also:** SOUND INIT, SAMLOOP OFF, SAMTHRU, SAMRECORD

## SAMMUSIC
`SAMMUSIC n,"note"` — Play a sample as a musical note.

- **n**: sample number, 1 to 32, in the current memory bank
- **note**: string holding one of `C,C#,D,D#,E,F,F#,G,G#,A,A#,B`

Alters the tone of a sample when it is played, widening the scale of the sound to encompass the full range of musical notes. Specifically intended for samples representing a musical instrument; the current pitch of the sample is assumed to be middle C. A fuller example is PLAYER.BAS on the STOS Maestro program disc, which plays a sample from the keyboard — it assumes the sample is in raw form, so .MBK files created with the Maestro accessory must not be loaded into it.

### Example
```text
load "voices.mbk":rem Load some effects created previously
```
```stos
10 click off:sound init
20 for i=1 to 12
30 read n$:print "Key ";N$:sammusic 3,n$
40 wait key:rem Wait for the voice to be finished
50 next i
60 data "C","C#","D","D#","E","F","F#","G","G#","A","A#","B"
```

### Gotchas
- Same music-function incompatibility as SAMPLAY.
- Assumes the sample's natural pitch is middle C.

**See also:** SAMPLAY, SAMBANK, SAMSPEED

## SAMRAW
`SAMRAW start,end` — Play a sample straight from memory.

- **start**: address of the first byte of raw sample data
- **end**: address of the last byte

Plays a raw sample stored from address start to end. Raw samples can be placed anywhere in the ST's memory — it is perfectly possible to load a sample into a string and manipulate it with the normal string functions. Raw samples can also be looped, reversed and swept using SAMLOOP, SAMDIR and SAMSWEEP. The usual idiom for a sample held in a memory bank is `samraw start(bank),start(bank)+length(bank)`.

### Example
```stos
10 SOUND$=string$(chr$(0),12000)
20 bload "\VOICE\GAMEOVER.SAM",varptr(SOUND$)
30 samraw varptr(SOUND$),varptr(SOUND$)+len(SOUND$)
40 wait key
50 rem Chop the word "over" from "game over"
60 OVER$=right$(SOUND$,8000)
70 samraw varptr(OVER$),varptr(OVER$)+len(OVER$)
```
Load-and-play with file selector:
```stos
10 reserve as work 8,100000:rem Reserve 100k to hold samples
15 click off:sound init:samloop off:samsweep off
20 F$=file select$("*.sam","Load sample to play")
30 if F$="" then end
40 open in #1,F$:L=lof(#1):close #1:rem Get length of sample
50 bload F$,8:rem Load sample
60 input "Playback speed";S
70 if S<5 or S>22 then print "Invalid Speed":goto 60
80 samspeed S
90 samraw start(8),start(8)+L
100 print "Hit a key to continue":wait key:goto 20
```

### Gotchas
- No header or rate information is interpreted — set the speed explicitly with SAMSPEED, or use SAMSPEED AUTO only for data with an embedded Maestro rate code.

**See also:** SAMCOPY, SAMLOOP ON, SAMDIR BACKWARD, SAMSWEEP ON

## SAMBANK
`SAMBANK n` — Select the current bank for the SAMPLAY and SAMMUSIC commands.

- **n**: STOS memory bank number, 1 to 15

By default SAMPLAY and SAMMUSIC expect a list of previously created samples in memory bank number 5. SAMBANK changes that bank — necessary when bank 5 is already allocated (for example to one of the screens of an existing program), and also a way to incorporate more than the maximum of 32 samples in a program by switching banks. Check which banks a program already uses with LISTBANK before choosing one.

### Example
```text
load "effects.mbk",5
load "voices.mbk",6
```
```stos
10 click off:sound init:samspeed auto
20 sambank 6:rem Use bank number six
30 for i=1 to 5
40 samplay i:print "Hit a key to continue":wait key:rem Press a key
50 next i
60 sambank 5:rem Set bank back to 5
70 goto 30:rem Playback 5 sound effects
```

### Gotchas
- Default bank is 5; clashing with a bank already used by the program (screens, sprites, music) corrupts data.

**See also:** SAMPLAY, SAMMUSIC

## SAMCOPY
`SAMCOPY start,end,dest` — Copy a sample from one place to another.

- **start**: address of the beginning of the sample to be moved; any value, does not have to be even
- **end**: address of the end of the sample to be copied
- **dest**: destination address of the new sample

A special version of the standard STOS copy command which allows copying to start from an odd location — that is, from any location whether on a word boundary or not — where the standard copy only works on word boundaries for reasons of speed. (The manual here prints "SCREENCOPY"; see errata.md.)

### Example
```stos
10 reserve as work 10,30000:rem Reserve 30k
20 input "Place the sample disc in drive A";A$
30 samspeed 12
40 dir$="A:\VOICE\"
50 bload "gameover.sam",10:rem Load a sample
55 rem Make a second copy the sample in bank 10
60 samcopy start(10),start(10)+10000,start(10)+10001
65 rem Play the entire sample
70 samraw start(10),start(10)+length(10)
```

**See also:** SAMRAW

## SAMPLACE
`p=SAMPLACE` — Return the current position in the sample being played.

- **p**: position relative to the start of the sample, from 0 to the total sample size (in bytes)

Retrieves the present position in the sample which is currently being played — for a 20k sample, the halfway point returns a value of around 10000. Often used to determine when a sample has finished playing, which is essential when combining melodies produced from the MUSIC accessory with sampled sounds.

### Example
```stos
10 rem Simple tape counter
20 click off:sound init:curs off:hide
30 input "Sample number";N
40 input "Sample rate";S
50 samspeed S:samplay N
60 XC=xcurs:YC=ycurs:P=samplace/1000:print "Tape counter:";P;" ";:locate XC,YC:if inkey$="" then 60
70 goto 30
```
End-of-playback check while mixing STOS music with samples:
```text
load "music.mbk":rem Load from the STOS Basic accessory disc
load "effects.mbk":rem Created previously with MAESTRO accessory
```
```stos
10 click off:music 1:tempo 30
20 if rnd(10000)<>3 then 20:rem Produce random sound effects
30 music freeze:sound init:samplay 1
40 if samplace=11842 then samstop:music on:goto 20:rem Sample 10k long
50 goto 40
```

**See also:** SAMPLAY, SAMSTOP
