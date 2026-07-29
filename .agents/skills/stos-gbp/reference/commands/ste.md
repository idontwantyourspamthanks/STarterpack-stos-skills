# GBP extension commands: ste

These commands need STE hardware (or a machine with the extended sound capability for the audio commands).

## DAC VOLUME
`DAC VOLUME VOL` — set the main volume of the STE sound output.

- **VOL**: volume, 0 - 40 (40 being the loudest).

### Example
STE fade out:
```stos
10 rem ** STE fade out
20 for LP=40 to 0 step -1
30 for LP2=0 to 15 : wait vbl : next LP2
40 dac volume LP : next LP
```

**See also:** TREBLE, BASS

## TREBLE
`TREBLE TREB` — set the amount of treble in the STE sound output.

- **TREB**: 0 - 12 (0 = -12dB, 6 = 0dB, 12 = +12dB).

**See also:** DAC VOLUME, BASS

## BASS
`BASS BAS` — set the amount of bass in the STE sound output.

- **BAS**: 0 - 12 (0 = -12dB, 6 = 0dB, 12 = +12dB), same range as TREBLE.

**See also:** DAC VOLUME, TREBLE

## EPLAY
`EPLAY STRT,LENGTH,SPEED,MODE,PLAYMODE` — play a sample through the STE hardware sound.

- **STRT**: actual start address of the sample (e.g. `start(bank)`, never a bare bank number).
- **LENGTH**: length of the sample.
- **SPEED**: replay speed — 0 = 6.258 kHz, 1 = 12.517 kHz, 2 = 25.033 kHz, 3 = 50.066 kHz.
- **MODE**: 0 = stereo, 1 = mono.
- **PLAYMODE**: 0 = stop, 1 = play once, 3 = loop forever.

Hardware sample playing on STE machines, or machines with the extended sound capability. Replay can be stopped by EPLAY with PLAYMODE 0, or with the ESTOP command.

### Gotchas
- STRT must be an actual address. The doc is emphatic: `Eplay 10,length(10),0,0,1` plays from memory address 10, not bank 10 — use `Eplay start(10),length(10),0,0,1`.
- The doc's own intro example reads `Eplay start(10),length(10),0,01` with only four parameters; the command takes five. See errata.

**See also:** ESTOP, EPLACE

## ESTOP
`ESTOP` — stop the hardware sample replay interrupt.

Stops ANY sample that is playing under STE hardware.

**See also:** EPLAY, EPLACE

## EPLACE
`X=EPLACE` — return the address in memory currently being played by the STE hardware.

- **X**: current replay address.

Does the same as the existing STOS `SAM PLACE` command, but for the STE hardware sample replay. Can be used for effects such as frequency meters or oscilloscopes.

### Example
Oscilloscope routine (sample in bank 10, played looping):
```stos
10 rem ** Oscilloscope routine
20 key off : curs off : hide : mode 1
30 :
40 eplay start(10),102400,1,0,3 : rem ** Play sample, looping
50 :
60 repeat : fastwipe physic
70 for LP=0 to 50 : X=peek(eplace)
80 if X>128 then X=X-255
90 X=X/8 : plot LP,100+X,1 : rem ** Plot sample byte
100 next LP
110 until false
```

**See also:** EPLAY, ESTOP, FASTWIPE

## JAR
`X=JAR` — check whether a "Cookie Jar" exists on the computer.

- **X**: TRUE (-1) if a cookie jar exists, 0 otherwise.

To be used in conjunction with the COOKIE command.

### Gotchas
- Documented in GBP.DOC and present in the COMPILER.S source, but the V4.7 `GBP.EXP` token table has no `jar` token — JAR cannot be used with the V4.7 interpreter extension. See errata.

**See also:** COOKIE

## COOKIE
`X=COOKIE(STR$)` — read the value of an Atari cookie from the cookie jar.

- **STR$**: one of the official Atari cookie names; anything else returns no value.
- **X**: the cookie's value.

Recognised cookies and their values:

- **_CPU**: decimal value of the last two digits of the 68000-family processor present: 00, 10, 20, 30 (e.g. 30 = 68030).
- **_VDO**: high word is 0 - 2, the video shifter fitted: 0 = standard ST, 1 = STE, 2 = TT graphic chip.
- **_SND**: bit flags for sound hardware: bit 0 set = Yamaha sound chip present, bit 1 set = DMA sound chip present.
- **_MCH**: high word describes the overall machine (low word is for version changes): 0 = standard ST, 1 = STE, 2 = Mega ST, 3 = TT.
- **_SWI**: positions of the configuration switches on Mega STEs and TTs (at present these switches are unused).
- **_FRB**: longword address of the FASTRAM buffer, or 0 if no FASTRAM buffers are fitted; not found on normal ST and STE machines.

### Example
```stos
10 if jar then X=cookie("_CPU")
20 print "You have a 680";using "##";x;" Processor"
```

**See also:** JAR

## XPEN
`X=XPEN` — return the X screen position of the STE light pen/gun.

- **X**: horizontal screen position of the light pen/gun.

**See also:** YPEN

## YPEN
`Y=YPEN` — return the Y screen position of the STE light pen/gun.

- **Y**: vertical screen position of the light pen/gun.

### Example
```stos
10 repeat
20 if fire then plot xpen,ypen : shoot
30 until false
```

**See also:** XPEN
