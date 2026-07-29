# STOS 3D commands: Objects and surfaces

Objects are designed with Object Modeller (OM) and saved as packed Object Definitions. Td LOAD loads a definition; Td OBJECT then creates an Object Instance — a version of the object optimised for speed — which is what all the other Td commands address. You can have several independent instances of one definition (load a missile once, display many). Object numbers run from 1 to 20, your choice; object 0 is the viewpoint. Angles A, B and C (rotations about the object's own x, y and z axes) are in VRUs: 65,536 VRUs per circle, 90 degrees = 16384 VRUs.

## TD OBJECT
`Td OBJECT n,name,x,y,z,A,B,C` — Create an object.

- **n**: the object number (between 1 and 20, your choice)
- **name**: the name of the object
- **x,y,z**: the world coordinates of the object's starting position
- **A,B,C**: the attitude of the object

Creates an object instance based on a previously loaded object definition, with the given starting position and attitude. No objects are drawn until you execute Td REDRAW. Remember that object zero is the viewpoint.

### Example
(place an object at (1000,2000,3000) pointing straight up — 90 degrees = 16384 VRUs)
```text
Td OBJECT 1,"object-name",1000,2000,3000,16384,0,0
```

### Gotchas
- The quick reference spells the second parameter `name$`; the main text uses `name`. Either way it is a string. See errata-a.md.
- Errors: `Invalid object number` (valid numbers are 0-20, and object 0 can't be created or killed), `Object already exists` (invoking an instance number already in use).

**See also:** TD LOAD, TD KILL, TD CLEAR ALL, TD REDRAW

## TD FACE
`Td FACE n1,n2` / `Td FACE n,x,y,z` — Point an object at another object or at a point.

- **n1,n2**: object numbers (either may be object 0, the viewpoint)
- **n**: object number
- **x,y,z**: a point in world coordinates

Td FACE is just like Td BEARING: it calculates the bearing angles A, B and the range R between two objects (or an object and a point) — but it also rotates the first object so that it points at the second object (or point). The first form points object n1 at object n2; the second points object n at the point (x,y,z). You can get exactly the same effect by using Td BEARING to find A and B and then using Td ANGLE.

### Gotchas
- After using Td FACE you can read A, B or R with the dummy-parameter forms Td BEARING A(0), Td BEARING B(0) and Td BEARING R(0), just as if you had called Td BEARING.

**See also:** TD BEARING A, TD ANGLE, TD RANGE

## TD SURFACE
`Td SURFACE name1,b1,f1,n2,b2,f2,rt` — Copy a surface.

- **name1**: the name of the source object (the one containing the surface to be copied)
- **b1**: the block number within name1
- **f1**: the face number within b1
- **n2**: the object number of the destination object
- **b2**: the block number within n2
- **f2**: the face number within b2
- **rt**: rotation angle; legal values range between 0 and 3

The surface copying command, used for surface animation — for example attaching a pre-designed "damage" surface to a ship. The source object is referred to by name, so surfaces can be copied from objects that are merely loaded, not displayed, saving memory; a cube (which holds up to six surfaces) makes a good store. The destination is referred to by its Td OBJECT object number. As soon as you copy the surface it appears. In OM you can find a face's block and face numbers by selecting the face and using the Info tool (e.g. face 3 of block 2); the first number shown is the object's radius, which you don't need.

### Gotchas
- For flat blocks, 3D automatically fixes the four surface detail anchor points so they are evenly distributed around the block; use TD SURFACE POINTS first if you want to control which anchor points are used.
- The quick reference prints the syntax as `Td SURFACE name1,b1,f1 to n2,b2,f2,rt`; the main text uses commas throughout. See errata-a.md.
- Errors: `Block does not exist`, `Face does not exist`.

**See also:** TD SURFACE POINTS, TD LOAD, TD ANIM

## TD SURFACE POINTS
`Td SURFACE POINTS p0,p1,p2,p3` — Set surface detail anchor points.

- **p0,p1,p2,p3**: point numbers to use as anchor points

Specifies that point numbers p0, p1, p2, p3 are to be used as anchor points for all future surface animation on flat blocks. (See the Object Modeller Surface Detail section of the manual for an explanation of surface anchor points.)

### Gotchas
- If you specify a point that does not exist in the block, the error is only detected when you try to apply the surface using Td SURFACE.

**See also:** TD SURFACE
