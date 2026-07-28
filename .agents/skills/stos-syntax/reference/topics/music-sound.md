# Music and sound

The Atari ST's sound chip can play up to three notes simultaneously, each on a separate **voice**. STOS Basic exposes two layers on top of it: the foreground `PLAY` command, which blocks the program for the length of each note, and the interrupt-driven `MUSIC` system, which plays whole tunes in the background while the program runs at full speed. Tunes are composed interactively in the Music definer accessory and stored in bank 3; sound effects come either ready-made (`BOOM`, `SHOOT`, `BELL`) or shaped from raw noise with `NOISE` and `ENVEL`.

## PLAY — single notes

```text
PLAY [voice,]pitch,duration
```

`pitch` runs from 1 to 96 and is mapped onto the twelve notes of the chromatic scale (C, C#, D, D#, E, F, F#, G, G#, A, A#, B) across eight octaves (0 to 7). Each octave is a cycle of twelve semitones, so middle C (octave 0) is pitch 1 and the B at the top of octave 7 is pitch 96. A pitch of 0 produces no sound — `PLAY` simply waits. `duration` is in 50ths of a second (0 = silence). The optional `voice` (1-3) selects the channel; if it is omitted the note sounds on all three voices at once.

```stos
10 rem Random music on a single voice
20 click off : rem Turn off keyboard click
30 T=rnd(96) : P=rnd(32) : play T,P : goto 30
```

## VOLUME and CLICK

`VOLUME [v,]intensity` sets the loudness of subsequent sounds, from 0 (silent) to 15 (very loud). As with `PLAY`, an optional voice 1-3 can be supplied; otherwise all three voices are affected. The special value **16** routes the sound through the envelope generator instead of the normal volume control — this is required when using `ENVEL` (see [Defining your own effects](#defining-your-own-effects)).

One snag with `PLAY` is that the keyboard click cuts a sounding note off dead. `CLICK OFF` disables the click and `CLICK ON` restores it. (Music played through the `MUSIC` accessory is unaffected, because it does not share the same channel.)

```text
click off
volume 10 : play 40,1000 : rem 20-second tone
```

## Background music with MUSIC

The `MUSIC` command plays tunes from **bank 3** under interrupt control. Tunes are composed in the Music definer accessory (below) and loaded into the bank from disc as `.MBK` files:

```text
load "music.mbk"
music 1
```

The music then plays independently — you can list, run or load programs without disturbing it. The `MUSIC` family is:

- `MUSIC n` — play tune number *n* (1 to 32).
- `MUSIC OFF` — stop the current tune; `MUSIC ON` restarts it from the beginning.
- `MUSIC FREEZE` — pause the tune temporarily; `MUSIC ON` resumes from the exact point it stopped. Use this before a sound effect so the music is not distorted.
- `MUSIC ON` — resume after `MUSIC OFF` or `MUSIC FREEZE`.

`TEMPO s` (1 very slow, 100 very fast) changes the speed of the current piece. `TRANSPOSE df` shifts the pitch by *df* semitones (range -90 to +90); each increment of 1 is one semitone, so `TRANSPOSE 10` lifts the tune by ten semitones and `TRANSPOSE -20` drops it by twenty.

### Tracking and muting individual voices

`PVOICE(v)` is a function returning the memory address of the note currently playing on voice *v* (1-3); a return value of 0 means no music is playing on that voice. Use it to detect when the tune has reached a particular bar:

```stos
10 load "music.mbk"
20 music 2
30 tempo 5
40 home : print pvoice(1),pvoice(2),pvoice(3)
50 if inkey$="" then 40
60 music off
```

This displays a number denoting the note currently being played. The manual then amends the program to stop the music at a specific stage:

```stos
30 tempo 40
45 if pvoice(1)=118 then 60
```

Run this way, the music is halted when `PVOICE(1)` reaches position 118.

`VOICE OFF [v]` and `VOICE ON [v]` mute or restore individual voices (1-3); with no voice number, all three are affected.

## The Music definer accessory

Real music is composed interactively in the `MUSIC.ACB` accessory, never typed in as Basic data. Load it and enter it with `<HELP><F1>` (it is a large program — on a 520ST, remove other accessories first):

```text
accnew : accload "music.acb"
```

The screen has three windows — one per voice — with a musical-stave display above. Move between windows with the mouse or the left/right cursor keys; `F1` to `F4` page to the previous page, next page, start and end of the music. The `Insert` key opens a space at the cursor (shifting the music down) and `Delete` removes the note under the cursor.

### Writing a music string

Each note is a single string of three parts — the note name, an octave and a duration:

| Part | Values |
| --- | --- |
| Note | `C,C#,D,D#,E,F,F#,G,G#,A,A#,B` |
| Octave | `0` (very low) to `7` (very high) |
| Duration | `WN HN QN EN SN TN` (whole, half, quarter, eighth, sixteenth, thirty-second) |

A trailing `.` adds a half-note (HN) to the duration, except after `SN` — so `QN.` is a quarter plus a half, i.e. three-quarters of a note. A rest is `PA` followed by a duration, e.g. `PA HN`. The string `F#3TN` therefore means F-sharp, octave 3, lasting a thirty-second note.

### Music instructions

Beyond notes, the definer understands these instructions, which appear on their own lines in the voice windows:

- `VOLUME v` — set the voice's volume (0-15); defaults to 15.
- `ENVEL e` — choose envelope (waveform) *e* for this voice. **Every piece of music must begin with an `ENVEL` instruction, or it will not play at all.**
- `TREMOLO t` / `STOP TREMOLO` — apply or remove a pitch waver (vibrato).
- `NOISE n` / `STOP NOISE` — layer a hiss of pitch *n* (0-31) over the voice.
- `NOISE ONLY` — play each subsequent note as noise rather than a pure tone (good for percussion). The definer's own `MUSIC` instruction switches the voice back to pure tones; do not confuse it with the Basic `MUSIC` command.
- `REPEAT n,p` — repeat from instruction number *p* through to the end of the voice, *n* times. Use `n=0` to loop forever. This instruction must appear *before* the section it repeats, and *p* counts every line including any `ENVEL` or `REPEAT` above the target.

### The Envelope editor

Envelopes shape a note by changing its volume over time, letting you imitate different instruments; tremolos do the same for pitch. Both share one utility, reached from the **TOOLS** menu (`FIX ENVELOPE` / `FIX TREMOLO`). An envelope is built from up to eight **phases**, each with three columns: **Speed** (1-100, the delay between steps — type `END` to terminate here or `LOOP` to repeat the envelope forever), **Step** (-16 to 16, the volume change per step) and **Number** (0-255, how many times this phase runs; 0 is infinite). `F1`/`F2` cycle through envelope numbers; the spacebar plays the current one.

### The pull-down menus

- **STOS** — `QUIT` returns to the editor; `QUIT AND GRAB` also copies the current music into bank 3.
- **BANK** — `LOAD MUSIC BANK` and `SAVE MUSIC BANK` (the filename must end in `.MBK`), `GRAB` music from the current STOS program, and `ERASE MUSIC BANK`. Loading a bank does not affect the music being edited, so two pieces can be merged.
- **MUSIC** — `NEW`, `RENAME`, `PUT` (copy the edited tune into one of the 32 bank slots — this slot number is what later gets passed to `MUSIC`; the definer only saves what is in bank 3, so you must `PUT` before saving or your edits are lost), `GET` (load a slot back into the editor), `ERASE`, `PLAY`, the one-shot `PUT AND PLAY`, and `PRINT` (dump all three voices to a printer).
- **BLOCK** — `START BLOCK` / `END BLOCK` mark a region (shown in inverse video) which can then be copied, erased, or transposed by -90 to +90 semitones; `CANCEL BLOCK` aborts.
- **TOOLS** — `FIX ENVELOPE`, `FIX TREMOLO`, `ERASE ENV/TREM`.

## Creating a piece of music — workflow

1. Enter the definer (`<HELP><F1>`), move the cursor to voice 1, and start with an envelope line. You will be prompted for an eight-character name for the tune:
   ```text
   ENVEL 1
   ```
2. Move down a line and enter each note on its own line. These five notes form the motif from *Close Encounters of the Third Kind*:
   ```text
   D3WN
   E3WN
   C3WN
   C2WN
   G2WN
   ```
3. Use `PUT MUSIC` to copy the tune into bank 3 slot 1 — the number later passed to `MUSIC`. `PLAY MUSIC` plays it back; `+`/`-` change the speed and `*`/`/` change the pitch while it plays. Escape returns to the main screen.
4. To loop the tune, move to the first note line, press `Insert`, and add `REPEAT 0,3`. The first number is the repeat count (0 = forever); the second is the starting instruction number, *including* any `ENVEL` or `REPEAT` lines above it — hence 3 for the first note after an `ENVEL` at 1 and the new `REPEAT` at 2. `PUT AND PLAY` then puts and plays in one step.
5. Experiment by inserting `NOISE ONLY`, `ENVEL 5` or `TREMOLO 2` directly after the `REPEAT` line and using `PUT AND PLAY`.
6. Save with `SAVE MUSIC BANK`, or grab the tune into the current program with `QUIT AND GRAB`, which loads it straight into bank 3.

From Basic, play the tune with `MUSIC 1` and stop it with `MUSIC OFF`. To add a second or third voice, move the cursor to the next window and type notes there with its own `VOLUME` and `ENVEL` lines — each window is an independent component, and the three play together as a harmony.

## Predefined sound effects

For games, three ready-made effects are provided: `BOOM` (an explosion), `SHOOT` (a gun firing) and `BELL` (a simple bell). The keyboard click interferes with them, so wrap calls in `CLICK OFF` / `CLICK ON`:

```stos
10 click off
20 boom
30 print "You're DEAD!"
40 click on
```

Any music playing will be distorted by these effects too, so call `MUSIC FREEZE` before the effect and `MUSIC ON` afterwards — the music then resumes from the exact point it left off.

## Defining your own effects

`NOISE v,p` produces a hissing "rushing wind" sound. `p` is the pitch (1 very high to 31 very low); the optional `v` (1-3) is the voice, defaulting to all three. Like `MUSIC`, `NOISE` runs in the background and can play continuously while a program runs.

`ENVEL type,speed` activates one of the ST's 16 envelopes, which periodically alter the volume of a sound from `NOISE` or `PLAY`. `type` is 1-15 and `speed` (1 very fast to 65535 very slow) sets the length of the sound. First set the volume to **16** with `VOLUME` so the sound is routed through the envelope generator rather than the normal volume control:

```text
volume 16       : rem Route through the envelope generator
noise 10        : rem Create a noise of pitch 10
envel 10,100    : rem Shape the sound
envel 10,1000   : rem Slower envelope - helicopter
```

The same envelopes shape a pure `PLAY` tone:

```text
click off
volume 16
envel 8,100
play 37,30
```

As a rule of thumb, `NOISE` suits mechanical sounds such as engines and machine guns, while `PLAY` suits unusual tonal effects like laser beams and alarms. The cleanest way to find useful combinations is to cycle through every noise pitch against every envelope type, waiting on a keypress between each and noting down the ones you want to keep.
