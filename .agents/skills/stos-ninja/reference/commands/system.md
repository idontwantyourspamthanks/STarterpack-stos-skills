# Ninja Tracker commands: System

System-level commands of the Ninja Tracker extension (V1.05, L.J. Greenhalgh 1994/95). **Hardware: 1 meg STE/TT/Falcon only.**

## TRACK KEY
`Integer=track key` — Get the value of the ACIA at $FFFC02, i.e. read the keyboard.

Returns the raw keyboard value straight from the keyboard ACIA register. This exists because the keyboard cannot be read in the usual way while a mod is playing. Alternatives are peeking $FFFC02 yourself or using Misty's HARDKEY command.

### Gotchas
- Only needed while a mod is playing; with no mod playing the normal STOS input commands (inkey$, etc.) work as usual.

**See also:** TRACK PLAY

## TRACK INFO
`track info` — Display the command list.

Prints the extension's command list to the screen.

### Gotchas
- **This command does not exist in compiled form** — do not try to compile a program containing it.

**See also:** TRACK PLAY
