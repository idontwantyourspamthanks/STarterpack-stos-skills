# Maestro file formats and playback engine

Sources: `extensions/maestro/SOURCE.S` (New Dimensions / Mandarin 1989, playback and record routines by Jon Wheatman) and the STOS Maestro manual (chapter 3 and technical appendix).

## .SAM sample files

A raw 8-bit sample, optionally self-describing:

- Bytes 0-2: ASCII code `JON` — present in every file saved by STOS Maestro.
- Byte 3: sample rate (KHz), used by SAMSPEED AUTO / AUTO_ON.
- Remaining bytes: unsigned 8-bit sample data, silence centred on 0x80.

The playback engine checks for the `JON` code only in AUTO mode; if it is absent (e.g. a REPLAY or PRO-SOUND file) the machine-level routine falls back to the current rate, while the STOS SAMSPEED AUTO command reports an error (see errata.md). The manual's LOAD SAMPLE option also accepts foreign sampler files with extensions like .SAM, .SMP or .SND.

## .MBK sample banks

- Created by the Maestro accessory (MAESTRO.ACB, entered with `accload "basic\maestro"`).
- Combines up to 32 separate named samples into a single STOS memory bank.
- Saved with the accessory's SAVE SAMPLE.MBK option; loaded with `load "name.mbk"` (into bank 5 by default) or `load "name.mbk",n`.
- Bank 5 is the default bank expected by SAMPLAY and SAMMUSIC; change it with SAMBANK (1-15).
- Accessory menu options include DELETE SAMPLE (erases one of the 32 samples by number), RENAME, and PLAY SAMPLE (speed entered as 5-22).

## Playback engine notes (SOURCE.S)

- Playback and recording are driven by a Timer-A interrupt; output goes to the PSG ($FF8800) via a 256-entry volume conversion table (VOLDAT2), three PSG writes per sample byte.
- Five play types, selected by the mode commands: 1 = forward, 2 = backward, 3 = forward loop, 4 = backward loop, 5 = sweep (implemented by alternating the forward/backward interrupt vectors).
- SAMLOOP/SAMDIR/SAMSWEEP only change the type used by the NEXT play call — hence the manual's rule that they do not affect the currently-playing sample.
- SPEED byte: 5-32 (KHz) at machine level via the HERTZ conversion table (+19 timer ticks); STOS Basic caps SAMSPEED at 22 KHz. SPEED is ignored when AUTO_ON = 1.
- SOUND INIT initialises the PSG through XBIOS DO_SOUND (all channels silent).
- SAMSTOP simply clears the Timer-A interrupt (mask, pending, in-service, enable).
- Recording reads the cartridge ADC at $FB0001 (ROM-SEL 3 on the cartridge port) on each Timer-A tick and simultaneously echoes it to the PSG — this is also how SAMTHRU works.
- The appendix gives the cartridge specification: 8-bit resolution, +/-0.5 LSB linearity, 2.5 V RMS peak-to-peak max input, anti-aliasing filter, maximum frequency 98.5 KHz (not guaranteed), 30.48 dB signal-to-noise ratio.
- The routines are also usable from assembler via MAESTRO.OBJ (`incbin "maestro.obj"`): SAMINIT $000, SAMPLAY $020, SAMSTOP $370, AUTO $3A2, TYPE $3A8, SPEED $3AA; supervisor mode required.
