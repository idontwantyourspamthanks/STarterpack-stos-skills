# STOS 3D commands: Motion

Object numbers: object 0 is the viewpoint; objects 1-20 are scene object instances created with Td OBJECT. Camera motion therefore uses these same commands with n=0. Positions are in VLUs; angles A, B and C (rotations about the object's own x, y and z axes) are in VRUs — 65,536 VRUs per circle, 90 degrees = 16384 VRUs. Aside from Td OBJECT, which sets an object's initial position and attitude, Td MOVE and Td ANGLE are the only commands that set absolute values; all the other movement and angle commands are relative to the object's current state.

## TD MOVE
`Td MOVE n,x,y,z` — Move an object.

- **n**: object number
- **x,y,z**: absolute position in world coordinates

Moves object n to the absolute position (x,y,z) in world coordinates. There is also a string form of Td MOVE (see TD MOVE X/Y/Z).

### Example
```text
Td Move 4,100,100,3000
```

**See also:** TD MOVE REL, TD MOVE X, TD FORWARD, TD POSITION X

## TD MOVE REL
`Td MOVE REL n,dx,dy,dz` — Move an object relative to its current position.

- **n**: object number
- **dx,dy,dz**: change to apply to the object's current position

Operates like Td MOVE, but the movement is relative to the object's current position; the change is made every time the command is executed. Placed in the main redraw loop it moves the object with constant speed.

### Example
```text
Td Move Rel 2,0,100,0
```

### Gotchas
- The example above moves object 2 a hundred VLUs upwards each time it runs — but the apparent on-screen direction depends on the viewpoint: the object only moves up the screen if the viewpoint is behind it and pointing in the (0,0,0) direction; viewed from above it will appear to be coming straight at you.

**See also:** TD MOVE, TD FORWARD, TD ANGLE REL

## TD FORWARD
`Td FORWARD n,d` — Move an object forwards.

- **n**: object number
- **d**: distance in VLUs

Moves object n forward d VLUs each time it is executed; in the main object loop this gives constant-speed motion. "Forward" is the direction the object is pointing: when you design an object in OM you should save it front forward, pointing straight at you — the attitude of the object when it is saved defines the forward direction.

### Gotchas
- Because Td FORWARD always moves an object in the direction it is pointing, you can make objects execute smooth turns simply by changing the attitude gradually with Td ANGLE or Td ANGLE REL.

**See also:** TD MOVE REL, TD ANGLE, TD ANGLE REL, TD BEARING A

## TD ANGLE
`Td ANGLE n,a,b,c` — Set an object's attitude.

- **n**: object number supplied in Td OBJECT
- **a**: angle made with the world x axis
- **b**: angle made with the world y axis
- **c**: angle made with the world z axis

Gives object n the absolute attitude (a,b,c). There is also a string form of Td ANGLE (see TD ANGLE A/B/C).

### Example
(from the TDLOOP.BAS tutorial: rotate the disc about the x axis)
```stos
110 Td ANGLE 1,A,0,0
120 A=A+1000
```

**See also:** TD ANGLE REL, TD ANGLE A, TD ATTITUDE A, TD FORWARD

## TD ANGLE REL
`Td ANGLE REL n,dA,dB,dC` — Change an object's current attitude.

- **n**: object number
- **dA,dB,dC**: change to apply to the object's current attitude angles

Changes an object's current attitude by dA, dB and dC every time it is executed. Placed in the main redraw loop the object will rotate smoothly.

**See also:** TD ANGLE, TD FORWARD, TD MOVE REL

## TD MOVE X
`Td MOVE X n,string` — Set up an animation movement string (x axis).

- **n**: object number
- **string**: movement string, same rules as for STOS sprites (see page 82 of the STOS manual)

Acts on object n and applies the movement command in string to the x coordinate. There is a separate command for x, y and z.

### Example
```stos
10 Td Object 1,"cube",0,0,2000,10000,10000,10000
20 Td Move Z 1,"(1,-100,18)(1,100,18)L"
30 Rem Place your redraw loop here
```

### Gotchas
- Unlike sprites, it is inappropriate to change the positions and angles of objects under interrupts; the 3D string commands change the positions and angles of objects every time Td REDRAW is called.

**See also:** TD MOVE Y, TD MOVE Z, TD MOVE, TD ANGLE A

## TD MOVE Y
`Td MOVE Y n,string` — Set up an animation movement string (y axis).

- **n**: object number
- **string**: movement string, same rules as for STOS sprites

Like TD MOVE X, but applies the movement string to the y coordinate.

**See also:** TD MOVE X, TD MOVE Z

## TD MOVE Z
`Td MOVE Z n,string` — Set up an animation movement string (z axis).

- **n**: object number
- **string**: movement string, same rules as for STOS sprites

Like TD MOVE X, but applies the movement string to the z coordinate.

**See also:** TD MOVE X, TD MOVE Y

## TD ANGLE A
`Td ANGLE A n,angle$` — Set up an angle animation string (angle A).

- **n**: object number
- **angle$**: movement string, same rules as for STOS sprites (see page 79 of the STOS manual)

Applies the changes specified by the movement string angle$ to attitude angle A. There is a separate command for A, B and C.

### Gotchas
- As with the Td MOVE string commands, the changes are applied every time Td REDRAW is called and should not be run under interrupts.

**See also:** TD ANGLE B, TD ANGLE C, TD ANGLE, TD MOVE X

## TD ANGLE B
`Td ANGLE B n,angle$` — Set up an angle animation string (angle B).

- **n**: object number
- **angle$**: movement string, same rules as for STOS sprites

Like TD ANGLE A, but applies the movement string to attitude angle B.

**See also:** TD ANGLE A, TD ANGLE C

## TD ANGLE C
`Td ANGLE C n,angle$` — Set up an angle animation string (angle C).

- **n**: object number
- **angle$**: movement string, same rules as for STOS sprites

Like TD ANGLE A, but applies the movement string to attitude angle C.

**See also:** TD ANGLE A, TD ANGLE B

## TD BEARING A
`=Td BEARING A(n1,n2)` or `=Td BEARING A(n,x,y,z)` — Return a bearing and range.

- **n1,n2**: object numbers; either can be object 0, the viewpoint
- **n**: object number
- **x,y,z**: a point in world coordinates

The bearing of one point from another is the direction of the second point as seen from the first; the range is the distance between them. A bearing in 3D space needs only two angles: B (the swivel angle, like a rotating gun turret) and A (the angle of elevation between the ground and the line of sight). The first form returns the bearing/range of object n2 from object n1; the second returns the bearing/range of the point (x,y,z) from object n. Each form returns A, B or R (the range) depending on which letter you use.

Whichever form you call, Td BEARING actually works out all three of A, B and R (they are interdependent) and remembers the others; read them back with a single dummy parameter — `Td BEARING A(0)` returns A as it was the last time Td BEARING was used in full, and likewise for B and R. The same values are also calculated by Td FACE.

### Example
```stos
10 B1=Td Bearing A(2,3)
20 B2=Td Bearing B(0)
30 B3=Td Bearing R(0)
```

### Gotchas
- The bearing/range calculation is quite a long one, so the dummy-parameter recall is well worth doing: all bearings can be worked out with just one full call.
- Once you have A and B it is easy to make an object (e.g. a missile) fly to the target: just use `Td ANGLE A,B,0` and then Td FORWARD.
- If you need only the distance, use Td RANGE — it does not calculate any angles.

**See also:** TD BEARING B, TD BEARING R, TD FACE, TD RANGE, TD ATTITUDE A

## TD BEARING B
`=Td BEARING B(n1,n2)` or `=Td BEARING B(n,x,y,z)` — Return bearing angle B (the swivel angle).

Parameters and behaviour as for TD BEARING A; returns B instead of A, or the remembered B when called as `Td BEARING B(0)`.

**See also:** TD BEARING A, TD BEARING R, TD FACE

## TD BEARING R
`=Td BEARING R(n1,n2)` or `=Td BEARING R(n,x,y,z)` — Return the range (distance) component of a bearing.

Parameters and behaviour as for TD BEARING A; returns R, the distance between the two points, or the remembered R when called as `Td BEARING R(0)`.

**See also:** TD BEARING A, TD BEARING B, TD RANGE
