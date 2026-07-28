# STOS commands: music-sound

## PLAY
`PLAY [voice,]pitch,duration` — Plays a pure note through the loudspeaker of your TV or monitor.

- **voice**: optional voice number (1-3); if omitted, the note is sounded on all three voices at once.
- **pitch**: tone of the sound, ranging from 0 (low) to 96 (high). Each pitch is associated with one of the notes (A, B, C, D, E, F, G) — see the table below. A pitch of 0 produces no sound and PLAY simply waits for the duration.
- **duration**: length of time the note is to be played, in 50ths of a second. A duration of zero means the sound will not be generated.

The ST's sound chip can play up to three notes simultaneously, each on a separate voice. By combining these voices, you can generate attractive harmonics. The notes go up in a cycle of 12, known as an octave.

Pitch values by note and octave:

| Note | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|------|---|---|---|---|---|---|---|---|
| C    | 1 | 13 | 25 | 37 | 49 | 61 | 73 | 85 |
| C#   | 2 | 14 | 26 | 38 | 50 | 62 | 74 | 86 |
| D    | 3 | 15 | 27 | 39 | 51 | 63 | 75 | 87 |
| D#   | 4 | 16 | 28 | 40 | 52 | 64 | 76 | 88 |
| E    | 5 | 17 | 29 | 41 | 53 | 65 | 77 | 89 |
| F    | 6 | 18 | 30 | 42 | 54 | 66 | 78 | 90 |
| F#   | 7 | 19 | 31 | 43 | 55 | 67 | 79 | 91 |
| G    | 8 | 20 | 32 | 44 | 56 | 68 | 80 | 92 |
| G#   | 9 | 21 | 33 | 45 | 57 | 69 | 81 | 93 |
| A    | 10 | 22 | 34 | 46 | 58 | 70 | 82 | 94 |
| A#   | 11 | 23 | 35 | 47 | 59 | 71 | 83 | 95 |
| B    | 12 | 24 | 36 | 48 | 60 | 72 | 84 | 96 |

### Example
```stos
10 rem Random Music on a single voice
20 click off:rem Turn off keyboard click
30 T=rnd(96): P=rnd(32): play T,P : goto 30
```
```stos
10 rem Random Music on all three voices
20 click off:rem Turn off Keyboard click
30 volume 1,14: volume 2,14: volume 3,14
40 V=rnd(2)+1: T=rnd(96): P=rnd(40): play V,T,P: goto 40
```
```stos
10 rem Example of Play
20 rem Define note arrays
30 dim A(7),A#(7),B(7),C(7),C#(7)
40 dim D(7),D#(7),E(7),F(7),F#(7)
50 dim G(7),G#(7)
60 for I=0 to 7
70 P=I*12: C(I)=P+1: C#(I)=P+2: D(I)=P+3: D#(I)=P+4
80 E(I)=P+5: F(I)=P+6 : F#(I)=P+7 : G(I)=P+8: G#(I)=P+9
90 A(I)=P+10 : A#(I)=P+11: B(I)=P+12
100 next I
110 rem Define time variables
120 WN=32: HN=16 : QN=8 : EN=4 : SN=2: TN=1
130 rem Turn off key click
140 click off
150 rem Set volume
160 volume 15
170 rem Read note
180 read N,T: if N<0 then 230
190 rem Play note
200 play N,T
210 goto 180
220 rem Turn off sound
230 volume 0
240 click on
250 end
260 rem Music
270 data D(3),WN,E(3),WN,C(3),WN,C(2),WN,G(2),WN,-1,-1
```

**See also:** CLICK OFF, VOLUME

## VOLUME
`VOLUME [v,]intensity` — Change the sound volume.

- **v**: optional voice number (1-3); if omitted, all three voices are affected.
- **intensity**: loudness of this sound, from 0 (silent) to 15 (very loud). A special setting of 16 engages the envelope generator — see ENVEL.

Allows you to change the volume of any subsequently generated sounds.

### Example
```text
click off
volume 15
play 40,10
volume 5
play 40,10
```
```stos
10 for i=0 to 15
20 volume i
30 print "VOLUME";i
40 play 60,10
50 next i
```

**See also:** ENVEL, PLAY

## CLICK OFF/ON
`CLICK OFF` / `CLICK ON` — Turn the keyboard click off or on.

One minor problem you may encounter when using PLAY is that the keyboard beeps tend to interfere with the note. Try typing the following line:

```text
volume 10: play 40,1000:rem Generate a tone 20 seconds long
```

If you now hit one of the keys while the note is playing, the note will immediately stop. Since this could be very inconvenient, STOS Basic allows you to turn off the keyboard click at any time with the instruction:

```text
click off
```

As you might expect, the click can be reactivated by CLICK ON. Incidentally, it is important to note that this problem does not occur when using music created by the MUSIC accessory.

## MUSIC
`MUSIC n` — Play a piece of music using interrupts.

Plays some music which has been previously composed using the MUSIC.ACB accessory. This music is always placed by the system into bank number three. Unlike PLAY, the music is played automatically by the system, without slowing down your program in the slightest. There are four different forms of the MUSIC statement:

- `MUSIC n` — The standard MUSIC instruction plays a tune in bank 3 specified by the number *n*. *n* can range from 1 to the number of tunes which are currently installed (up to a maximum of 32).
- `MUSIC OFF` — Stops a piece of music which is currently being played. You can restart this music from the beginning with MUSIC ON.
- `MUSIC FREEZE` — Unlike MUSIC OFF, this instruction only halts the music temporarily. If it is re-entered using MUSIC ON, the music is continued from the point it was frozen. The most common use of MUSIC FREEZE is to stop a piece of music before you generate another sound effect such as an explosion. (See BANG, SHOOT, BELL, NOISE, ENVEL.)
- `MUSIC ON` — Resumes the current music halted by either the MUSIC OFF or the MUSIC FREEZE commands.

### Example
First load a melody from the accessory disc with the line:

```text
load "music.mbk"
```

You can play this with the MUSIC instruction like so:

```text
music 1
```

This music will now play in the background independently of the rest of STOS Basic. You can run, list, or even load a program without interfering with it in any way. The MUSIC command can therefore be used to add an attractive soundtrack to any of your programs. Examples of this technique can be found in the games Zoltar and Bullet Train.

Demonstrating OFF, ON and FREEZE:

```text
load "music.mbk":rem If it has already been loaded, omit this step
music 1:rem Play music
music off
music on:rem Restart music from the begining
music freeze
music on
```

**See also:** TEMPO, TRANSPOSE, ENVEL

## TEMPO
`TEMPO s` — Change the speed of a piece of music played with MUSIC.

- **s**: the new speed, from 1 (very slow) to 100 (very fast).

### Example

Place the accessory disc in the current drive and type:

```text
new
load "music.mbk":rem Load music
music 1:rem Play music
tempo 100:rem Set music playing very fast
tempo 10:rem Start music playing very slow
```

**See also:** MUSIC, TRANSPOSE

## TRANSPOSE
`TRANSPOSE df` — Change the pitch of a piece of music.

- **df**: value added to each note before it is played, from -90 to +90. Negative numbers lower the note and positive numbers increase it. A *df* increment of 1 corresponds to a single semi-tone.

### Example

Load the music demo with the lines:

```text
load "music.mbk"
```

Now play the music and use TRANSPOSE:

```text
music 1
transpose 1:rem Increase the pitch by one semi-tone
transpose 10:rem Increase pitch by 10 semi-tones
transpose -20:rem Lower the pitch by 20 semi-tones
```

**See also:** MUSIC, TEMPO

## PVOICE
`p=PVOICE(v)` — Return the current position in a piece of music.

- **v**: the voice you wish to test (1-3).
- **p**: the position returned. Note that *p* is set to a number representing the address of the note and not the note itself. A value of 0 means no music is being played on voice *v*.

PVOICE enables you to determine when the music reaches a particular point and stop it if required.

### Example

Put the accessory disc into the drive and type:

```stos
10 load "music.mbk"
20 music 2
30 tempo 5
40 home : print pvoice(1),pvoice(2),pvoice(3)
50 if inkey$="" then 40
60 music off
```

This displays a number denoting the note which is being currently played. See how the TEMPO command was used to slow things down. You can amend the program to stop the music at a specific stage like this:

```stos
30 tempo 40
45 if pvoice(1)=118 then 60
```

If you run this program, the music is halted when PVOICE(1) reaches position 118.

## VOICE
`VOICE OFF [v]` / `VOICE ON [v]` — Turn off or on one or more voices of a tune played by MUSIC.

- **v**: optional voice number (1-3). If included, only that single component of the music is suspended (or restarted). If omitted, all three voices are affected.

`VOICE OFF` lets you turn off one or more voices of a tune played by MUSIC. `VOICE ON` restarts some music halted by the VOICE OFF instruction.

### Example

Place the accessory disc into the drive and type:

```text
new
load "music.mbk"
music 1
voice off 1
voice off 2
voice off 3
voice on 2
voice on 1
voice on 3
```

## BOOM
`BOOM` — Generate a noise sounding like an explosion.

As the keyboard click interferes with this sound, it's a good idea to turn it off with CLICK OFF. You should also halt any music which is currently being played, because this will be distorted by the boom. Use the command MUSIC FREEZE for this purpose.

### Example
```stos
10 click off
20 boom
30 print "You're DEAD!"
40 click on
```

## SHOOT
`SHOOT` — Create a noise like a gun firing.

SHOOT simply produces a sound of a shot being fired.

### Example
```stos
10 click off
20 shoot
30 print "You're DEAD!"
40 click on
```


## BELL
`BELL` — Simple bell sound.

### Example
```text
bell
```

## NOISE
`NOISE v,p` — Generate a sound like a rushing wind.

- **v**: the voice which the noise is to be played on (1-3). If it is not included, the noise is output to all three voices simultaneously.
- **p**: the pitch of the noise, from 1 (very high) to 31 (very low).

Any noise generated with this command can be played continually while a program is running — just like the MUSIC command. The NOISE command really comes into its own when used in conjunction with the ENVEL instruction.

### Example
```stos
10 click off
20 for i=1 to 32
30 noise I
40 wait key
50 next i
```

**See also:** ENVEL

## ENVEL
`ENVEL type,speed` — Activate one of the ST's 16 envelopes.

- **type**: the envelope to be used, from 1 to 15.
- **speed**: the length of the sound, from 1 (very fast) to 65535 (very slow).

ENVEL activates one of the ST's 16 different envelopes. These periodically alter the volume of a sound created with either NOISE or PLAY. Before you can use this feature, you must first set the volume to 16 with VOLUME.

### Example
```text
volume 16:rem Set volume
noise 10:rem Create a noise of pitch 10
envel 10,100:rem Shape the sound using envelope 10
envel 10,1000:rem Helicopter sound
```

As you can see, it is possible to utilise ENVEL to produce a number of interesting effects. Here is a small program to help you to explore the various possibilities of this instruction:

```stos
10 rem Program to experiment with the NOISE
20 rem and the ENVEL instructions
30 cls
35 locate 0,0: input "Input length of the sound from 1-10000";T
40 locate 0,0: print "Press a key to scroll through the sounds "
50 click off
60 for J=0 to 15
70 envel J,T
80 for I=1 to 31
90 noise I
100 locate 10,10: print "Envelope";J;" ";
110 locate 10,11: print "pitch ";I;" ";
120 wait key
130 next I
140 next J
150 input "Continue Y or N";A$
160 if A$="Y" or A$="y" then 35
```

These envelopes can also be used to shape the pure tones generated by a PLAY command.

```text
click off
volume 16
envel 8,100
play 37,30
```

You can explore these effects using the program above by typing the following lines (these replace or extend the lines of the original program):

```stos
35 locate 0,0: input "Input length of sound from 1-100";T
36 input "Starting envelope 1-15";S
37 if S<1 or S>15 then print "Bad Envelope number " : goto 36
60 for J=S to 15
80 for I=1 to 96 step 3
90 play I,T
```

As a general rule, NOISE is best suited for the creation of mechanical sounds such as engines and machine guns. PLAY can generate more unusual effects — like laser beams and alarms.

**See also:** NOISE, PLAY, VOLUME

