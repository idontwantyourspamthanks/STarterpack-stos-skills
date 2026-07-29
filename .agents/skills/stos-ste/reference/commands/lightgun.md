# STE extension commands: Light gun/pen

If you've got a light gun or pen plugged into the STE's side ports, you can write a shoot-'em-up for it.

## LIGHT X
`x = LIGHT X` — Returns the x co-ordinate of the light gun or pen.

The co-ordinate is read when the fire button is pressed and held until it is pressed again. Check the button with `FSTICK (3)` — the gun/pen button is returned as joystick three.

**See also:** LIGHT Y, FSTICK

## LIGHT Y
`y = LIGHT Y` — Returns the y co-ordinate of the light gun or pen.

Read and held in the same way as LIGHT X; check the button with `FSTICK (3)`.

**See also:** LIGHT X, FSTICK
