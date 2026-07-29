# STE extension commands: DAC and Microwire interface

The DAC (Digital to Analogue Converter) is one of the best things added to the STE. It plays raw sample sound in stereo, and with the Microwire interface you can set left and right volume as well as treble and bass. Once a sample is set up and playing it takes zero processor time, so graphics and calculations don't slow down.

## DAC CONVERT
`DAC CONVERT start address of sample, end address of sample` — Converts a Maestro-format sample to raw data for the DAC.

Because the STE DAC plays raw sampled sound you'll need to convert your Maestro samples. DAC CONVERT does the job almost instantly. Ideal for using the same sample data for the ST and STE. Load your sample as usual, then use this command before your main loop; once converted it will replay perfectly.

### Gotchas
- Do your sampling at a rate the DAC can replay (6, 12.5 or 25 Khz); the DAC cannot replay a sample at the same speed it was sampled at with, for example, Master Sound (J.J.'s tutorial).

**See also:** DAC RAW, DAC SPEED

## DAC SPEED
`DAC SPEED` — Sets the speed of sample replay.

Speeds 0 to 4: 0 = 6 Khz, 1 = 12.5 Khz, 2 = 25 Khz, up to a pretty amazing 50 Khz.

### Gotchas
- The official doc skips a number: it lists 0, 1, 2 and then "4 is a pretty amazing 50Khz". J.J.'s tutorial lists 3 = 50 Khz. Treat the valid range as 0-4 (see errata).

**See also:** DAC RAW, DAC CONVERT

## DAC RAW
`DAC RAW start address of sample,end address of sample` — Plays your raw sample.

Once this command has been used, the sample will play until it is stopped by calling DAC STOP or until the end of the sample is reached (unless looping — see DAC LOOP ON).

To hold many samples in one bank, store them one after another, note the offset of each in your sampler package, and add the offsets to the bank start:

```text
dac raw start(10)+19239,start(10)+23958
```

### Example
From the STE_DAC.doc tutorial (extension version of the STORM sample routine):
```stos
10 rem STE DAC routine, as used in STORM by Fugitive Freelancers
20 if length(10)=0 then reserve as data 10,23634 : bload "sample.sam",10
30 dac speed 0 : rem set replay speed
40 dac loop on : rem loop sample on/off
50 dac mono : rem sample mono or stereo
60 dac m volume 40 : rem set main volume
70 dac l volume 20 : rem set left volume
80 dac r volume 20 : rem set right volume
90 dac treble 12 : rem set treble
100 dac bass 8 : rem set bass
110 dac mix on : rem mix with normal ST sound on/off
120 dac raw start(10)+90,start(10)+length(10)-99
130 rem DAC STOP will halt the sample
```

### Gotchas
- The tutorial's example uses `dac m volume 40` and left/right volumes of 20, exceeding the 0-12 range the official doc gives for all volumes (see DAC M VOLUME gotcha and errata).

**See also:** DAC CONVERT, DAC SPEED, DAC STOP, DAC LOOP ON

## DAC MONO
`DAC MONO` — Sets the sample to be mono.

Usually mono is what you want.

**See also:** DAC STEREO

## DAC STEREO
`DAC STEREO` — Sets the sample to be stereo.

### Gotchas
- If you use stereo with mono samples you will notice a change of replay speed, but no problems — just amend the replay speed accordingly to what you use and the effect you want to achieve (J.J.'s tutorial).

**See also:** DAC MONO, DAC SPEED

## DAC LOOP ON
`DAC LOOP ON` — Sets the loop function on, for an endless wall of noise.

**See also:** DAC LOOP OFF

## DAC LOOP OFF
`DAC LOOP OFF` — Sets the loop function off; the sample ends after playing once.

**See also:** DAC LOOP ON

## DAC M VOLUME
`DAC M VOLUME volume` — Sets the master volume.

- **volume**: 0 to 12

### Gotchas
- Range conflict in the sources: the official doc gives 0-12 for all volumes, but the STE_DAC.doc example sets master volume to 40 and J.J.'s tutorial states the master volume range is 0 to 40. See errata.

**See also:** DAC L VOLUME, DAC R VOLUME, DAC TREBLE, DAC BASS

## DAC L VOLUME
`DAC L VOLUME volume` — Sets the left channel volume (when in stereo).

- **volume**: 0 to 12

### Gotchas
- The tutorial sources use left/right volumes up to 20, conflicting with the official doc's 0-12. See errata.

**See also:** DAC M VOLUME, DAC R VOLUME

## DAC R VOLUME
`DAC R VOLUME volume` — Sets the right channel volume (when in stereo).

- **volume**: 0 to 12

Same range conflict as DAC L VOLUME.

**See also:** DAC M VOLUME, DAC L VOLUME

## DAC TREBLE
`DAC TREBLE volume` — Sets the treble.

- **volume**: 0 to 12 (for maximum effect)

**See also:** DAC BASS, DAC M VOLUME

## DAC BASS
`DAC BASS volume` — Sets the bass.

- **volume**: 0 to 12 (for maximum effect)

**See also:** DAC TREBLE, DAC M VOLUME

## DAC MIX ON
`DAC MIX ON` — Allows you to mix the PSG sound chip with the STE's DAC.

Useful if using chip music for a game and playing DAC samples for the effects.

**See also:** DAC MIX OFF

## DAC MIX OFF
`DAC MIX OFF` — Turns off mixing of the PSG sound chip with the DAC output.

**See also:** DAC MIX ON

## DAC STOP
`DAC STOP` — Stops the DAC.

Tricky one this, it er, stops the DAC.

**See also:** DAC RAW, DAC LOOP ON

## General gotchas
- You can edit values such as volume and bass while the sample is playing — fade a sample in by raising the volume in a small loop, or in stereo fade it from left to right (J.J.'s tutorial).
