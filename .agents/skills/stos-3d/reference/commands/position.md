# STOS 3D commands: Position and attitude

Object numbers: object 0 is the viewpoint; objects 1-20 are scene object instances created with Td OBJECT. Positions are world coordinates in VLUs; attitudes are the angles A, B and C (rotations about the object's own x, y and z axes), measured in VRUs — 65,536 VRUs per full circle, so 90 degrees = 16384 VRUs.

## TD POSITION X
`=Td POSITION X(n)` — Return an object's world x coordinate.

- **n**: object number (the one supplied in Td OBJECT)

Td POSITION is a function; the form used (X, Y or Z) selects which world coordinate is returned.

### Gotchas
- Returns world coordinates; convert them to an object's local coordinates with Td VIEW.

**See also:** TD POSITION Y, TD POSITION Z, TD VIEW, TD OBJECT

## TD POSITION Y
`=Td POSITION Y(n)` — Return an object's world y coordinate.

- **n**: object number (the one supplied in Td OBJECT)

See TD POSITION X.

**See also:** TD POSITION X, TD POSITION Z, TD VIEW

## TD POSITION Z
`=Td POSITION Z(n)` — Return an object's world z coordinate.

- **n**: object number (the one supplied in Td OBJECT)

See TD POSITION X.

**See also:** TD POSITION X, TD POSITION Y, TD VIEW

## TD ATTITUDE A
`=Td ATTITUDE A(n)` — Return an object's attitude angle A.

- **n**: object number (the one supplied in Td OBJECT)

Td ATTITUDE is a function. It returns an angle A, B or C — the rotations the object makes with the world x, y and z axes — depending on which form you use.

**See also:** TD ATTITUDE B, TD ATTITUDE C, TD ANGLE

## TD ATTITUDE B
`=Td ATTITUDE B(n)` — Return an object's attitude angle B.

- **n**: object number (the one supplied in Td OBJECT)

See TD ATTITUDE A.

**See also:** TD ATTITUDE A, TD ATTITUDE C, TD ANGLE

## TD ATTITUDE C
`=Td ATTITUDE C(n)` — Return an object's attitude angle C.

- **n**: object number (the one supplied in Td OBJECT)

See TD ATTITUDE A.

**See also:** TD ATTITUDE A, TD ATTITUDE B, TD ANGLE
