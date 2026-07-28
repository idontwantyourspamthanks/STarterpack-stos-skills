# STOS commands: appendix-e

## PSG
`PSG(r)` — Access Programmable sound generator.

- **r**: sound register number; the sound registers are numbered from 0-13

The Atari ST incorporates a special piece of circuitry which it uses to generate the wide range of different sounds which can be played through your monitor or television set. This circuit is built around a single microchip known as the YAMAHA YM 2149. It possesses the following general characteristics:

- 3 separate frequency generators (One for each VOICE)
- 1 noise generator (Used by STOS Basic's NOISE command)
- 15 different volume levels (See VOLUME)
- 16 preprogrammed envelopes (Accessed by ENVEL)

The precise sound produced by the circuit is determined by the contents of 14 different SOUND REGISTERS numbered from 0-13. You can access these registers directly using the PSG command. PSG is effectively an array which holds a copy of the current contents of the sound registers. Whenever you assign a value to one of the elements in the PSG array, this will be automatically loaded into the appropriate register.

Sound registers and their uses:

| Register | Function |
|---|---|
| 0 | Bits 0-7 set the pitch in units of a single step for voice 1. |
| 1 | Bits 0-3 set the size of each frequency step. |
| 2 | Fine control for voice 2. Format as Register 0 |
| 3 | Coarse control for voice 2. As register 1 |
| 4 | Controls pitch of voice 3 in the same fashion as register 0 |
| 5 | Coarse control of the pitch of voice 3 |
| 6 | Bits 0-4 control the pitch of the noise generator. The higher the value the lower the tone. |
| 7 | Control register for sound chip. Bit 0: Play pure note on voice 1 ON/OFF (1 for ON, 0 for OFF); Bit 1: Voice 2 tone ON/OFF; Bit 2: Voice 3 tone ON/OFF; Bit 3: Play NOISE on voice 1 (1 for ON, 0 for OFF); Bit 4: Voice 2 noise ON/OFF; Bit 5: Voice 3 noise ON/OFF |
| 8 | Bits 0-3 control volume of voice 1. If bit 4 is set to one then the envelope generator is being used, and the volume bits are ignored. Since this corresponds to a volume of 16, this explains why you need to set VOLUME to 16 before you can use the ENVEL command. |
| 9 | As Register 8 but for Voice 2 |
| 10 | As Register 9 but for Voice 3 |
| 11 | Bits 0-8 provide fine control of the length of the envelope |
| 12 | This register provides coarse control of the length of the envelope |
| 13 | Bits 0-3 choose which of the 16 possible envelope types is to be used. |

### Example
```text
print psg(1)
```

### Gotchas
- WARNING: This function is DANGEROUS! Incorrect usage can cause serious damage to any disc in the current drive. This is because part of the sound chip is also utilised by the ST's disc system. You should therefore take extreme care when attempting to use this command.

**See also:** VOICE, NOISE, VOLUME, ENVEL

