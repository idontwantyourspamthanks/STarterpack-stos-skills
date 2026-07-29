# Ninja Tracker commands: Playback

The Ninja Tracker extension (V1.05, L.J. Greenhalgh 1994/95) plays four-channel ProTracker mods and the vast majority of chip music formats in the background at up to 21 kHz, while your STOS program carries on. **Hardware: 1 meg STE/TT/Falcon only.** Unlike the STOS tracker there is no pre-conversion step — just load the mod you want into a bank and play it. The interpreter plays the mod from the bank as-is.

## TRACK PLAY
`trackplay ADDRESS` — Start playing the mod at ADDRESS; if a mod is already playing, this same command stops it.

- **ADDRESS**: address of the mod in memory (the bank you loaded it into)

No pre-conversion is needed — point it at the raw mod file loaded into a bank and off you go. The mod plays in the background while the rest of your STOS program runs.

### Gotchas
- The bank you allocate for the mod must be at least 20K larger than the largest mod you will load — the routine needs workspace.
- Don't stop a mod and then restart it — that screws it up. Reload the mod into the bank again instead.
- The keyboard can't be read as usual while a mod is playing; peek $FFFC02, use Misty's HARDKEY, or use TRACK KEY.

**See also:** TRACK FREQUENCY, TRACK POS, TRACK PATTERN, TRACK KEY

## VU METER
`VALUE=vu meter(INTEGER)` — Get the volume of any of the 4 channels.

- **INTEGER**: channel number, in the range 1-4

Returns the current volume level of the given mod channel — useful for driving VU-meter-style on-screen displays while a mod plays.

**See also:** TRACK PLAY

## TRACK FREQUENCY
`track frequency INTEGER` — Set the replay frequency of the mod player.

- **INTEGER**: one of 5000, 8500, 12000, 14000 or 21000

The extension is initially set up to play mods at 16 kHz; this command changes the rate. The higher the frequency, the better the mods sound — but the less CPU time is left for the rest of your program.

### Gotchas
- Only the five listed values are allowed; anything else is not a valid frequency.

**See also:** TRACK PLAY

## TRACK POS
`VALUE=track pos` — Get the current mod's position.

Returns the current song position of the mod being played.

**See also:** TRACK PATTERN, TRACK PLAY

## TRACK PATTERN
`VALUE=track pattern` — Get the current mod's pattern.

Returns the number of the pattern currently being played.

**See also:** TRACK POS, TRACK PLAY
