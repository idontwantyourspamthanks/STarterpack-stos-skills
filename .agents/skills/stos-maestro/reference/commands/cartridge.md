# Maestro commands: Cartridge (Maestro Plus hardware)

These functions are designed solely for use with the STOS Maestro Plus cartridge (or equivalent). They give complete control over the sampler hardware from STOS Basic, allowing customized sampling programs — from speech synthesizers to simple speech-recognition systems.

## SAMRECORD
`SAMRECORD start,end` — Record a sample from the sound cartridge.

- **start**: address of the start of the sample, usually a memory bank
- **end**: address of the end of the sample; when this point is reached, recording terminates automatically

Starts the sampler running and records a sample using the current speed setting (set with SAMSPEED n), entered directly into the memory locations between start and end. While recording, the sampled sound is continuously played through the TV or monitor. Recording can be aborted at any time with SAMSTOP. Samples created with SAMRECORD can be saved to disc and accessed directly from either the Maestro program or SAMRAW.

SAMRECORD does NOT store the recording speed as part of the sample — playing such a sample back with SAMSPEED AUTO therefore generates an error. (The manual prints "does store" here, contradicting itself and the SAMSPEED AUTO section; see errata.md.)

### Example
```stos
10 rem Recording a sample
20 click off:sound init
30 reserve as work 6,1024*50:rem Reserve 50k for sample
40 input "Sample speed";S
50 if S<5 or S>22 then print "Invalid speed":goto 40
60 samspeed S
70 print "Prepare your recorder"
80 samthru:input "Hit return to start sampling";R$
85 print "Recording sample"
90 samrecord start(6),start(6)+1024*50
100 if samplace<49999 then 100:rem Wait until recording finished
110 print "Playing back sample"
120 samraw start(6),start(6)+length(6):rem Play sample
130 if samplace<1024*50 then 130:rem Wait until playback finished
140 input "Play again Y/N";A$:if A$="Y" or A$="y" then 120
150 goto 40
```

### Gotchas
- **Maestro Plus cartridge required.**
- Recorded samples carry no speed information, so SAMSPEED AUTO errors on them; always play them at an explicit SAMSPEED n.

**See also:** SAMTHRU, SAMPLE, SAMSPEED, SAMSTOP

## SAMTHRU
`SAMTHRU` — Play the input from the sampler through the monitor's speaker.

Simply pipes the current sound output through the TV speaker, allowing the input to be heard without creating an actual sample. THRU mode can be interrupted at any time using SAMSTOP.

### Example
Place a tape in your recorder and press PLAY. Now type:
```text
click off:sound init:samthru
```

### Gotchas
- **Maestro Plus cartridge required.**
- Runs until stopped with SAMSTOP.

**See also:** SAMRECORD, SAMPLE, SAMSTOP

## SAMPLE
`s=SAMPLE` — Read the sample value directly from the cartridge port.

- **s**: value from -127 to +127 representing the volume of the sound in digital form

The STOS Maestro Plus cartridge reads this value thousands of times per second and uses it to create a digital representation of the sampled sound. SAMPLE allows the ADC to be polled directly, e.g. for oscilloscope-style displays.

### Example
```stos
10 click off:sound init:I=0:mode 1:cls physic:cls back
20 ink 1:hide:samthru
30 S=sample/2:draw I,100 to I,100-S:inc I
40 if I>=640 then I=0:cls physic:goto 30 else 30
```

### Gotchas
- **Maestro Plus cartridge required.**

**See also:** SAMRECORD, SAMTHRU
