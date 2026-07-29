# STE extension commands: Joysticks

Your STE has the ability to use up to six joysticks. Joysticks one and two are read through the twin-joystick interrupt routine (STICKS ON), which is fully compatible with the separate Twin Sticks extension.

## LSTICK
`x= LSTICK (j)` — Returns the current status of the joystick's left position.

- **j**: joystick number, one to six

`x` holds -1 if the joystick is in the left position, or zero if it isn't.

**See also:** RSTICK, USTICK, DSTICK, FSTICK

## RSTICK
`x= RSTICK (j)` — Returns the current status of the joystick's right position.

- **j**: joystick number, one to six

Works exactly the same way as LSTICK, for the right direction: -1 if held right, zero if not.

**See also:** LSTICK, USTICK, DSTICK, FSTICK

## USTICK
`x= USTICK (j)` — Returns the current status of the joystick's up position.

- **j**: joystick number, one to six

Works exactly the same way as LSTICK, for the up direction: -1 if held up, zero if not.

**See also:** LSTICK, RSTICK, DSTICK, FSTICK

## DSTICK
`x= DSTICK (j)` — Returns the current status of the joystick's down position.

- **j**: joystick number, one to six

Works exactly the same way as LSTICK, for the down direction: -1 if held down, zero if not.

**See also:** LSTICK, RSTICK, USTICK, FSTICK

## FSTICK
`x= FSTICK (j)` — Returns the current status of the joystick's fire button.

- **j**: joystick number, one to six

Works exactly the same way as LSTICK, for the fire button: -1 if pressed, zero if not. The light gun/pen button is read with `FSTICK (3)` — see LIGHT X.

**See also:** LSTICK, RSTICK, USTICK, DSTICK, LIGHT X, LIGHT Y

## STICKS ON
`STICKS ON` — Activates the interrupt routine for twin joystick control on the ST and STE.

Also disables the mouse. Needed to access joysticks one and two (via STICK1 and STICK2).

### Gotchas
- Disables the mouse while active; call STICKS OFF to get it back.

**See also:** STICKS OFF, STICK1, STICK2

## STICKS OFF
`STICKS OFF` — De-activates the twin joystick interrupt routine and reactivates the mouse.

**See also:** STICKS ON

## STICK1
`x =STICK1` — Returns the status of joystick 1.

The variable holds one byte laid out as follows:

| Bit | Description |
| --- | ----------- |
| 0 | UP if bit set |
| 1 | DOWN if bit set |
| 2 | LEFT if bit set |
| 3 | RIGHT if bit set |
| 4 | UNUSED |
| 5 | UNUSED |
| 6 | UNUSED |
| 7 | FIRE if bit set |

The STE extension is completely compatible with the Twin Sticks extension, so if you have that you can use the same commands without any bother; they are included in the STE extension to maintain compatibility. Requires STICKS ON.

### Gotchas
- The doc itself calls decoding the byte "a bit of a bind" and recommends sticking with the easier LSTICK/RSTICK/USTICK/DSTICK/FSTICK functions.

**See also:** STICK2, STICKS ON, LSTICK

## STICK2
`x =STICK2` — Returns the status of joystick 2.

Same one-byte bit layout as STICK1 (bits 0-3 = up/down/left/right, bits 4-6 unused, bit 7 = fire). Requires STICKS ON.

**See also:** STICK1, STICKS ON

## General gotchas
- The extra STE joystick ports on the side of the machine are non-standard analogue ports, and Atari never released analogue joysticks for them (noted in J.J.'s tutorial).
