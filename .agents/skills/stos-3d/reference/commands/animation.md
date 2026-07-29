# STOS 3D commands: Animation

In STOS 3D "animation" means something that changes the appearance of an object, not simply movement. The commands here cover shape animation (moving an object's vertices, called points) plus object removal and collision detection. Point coordinates are in the object's local system. Object numbers: object 0 is the viewpoint; objects 1-20 are scene object instances.

## TD KILL
`Td KILL n` — Remove an object.

- **n**: object number supplied when the instance was created with Td OBJECT

Removes an object instance from the world. Only the instance is removed, not the object definition; to remove all instances and all object definitions use Td CLEAR ALL.

### Gotchas
- Td KILLing every instance is not the same as Td CLEAR ALL — killed objects' definitions stay in memory. If you have been loading many objects and no longer use some, Td CLEAR ALL and reload the ones you need to free the maximum memory.

**See also:** TD OBJECT, TD CLEAR ALL, TD LOAD

## TD COLLIDE
`=Td COLLIDE(n1,n2)` or `=Td COLLIDE(n)` — Detect a collision.

- **n1,n2**: object numbers
- **n**: object number

3D collision detection works using zones — spheres whose centres are attached to an object, defined with Td SET ZONE (at least once for each object). The first form tells you whether objects n1 and n2 have collided: if they have, the function returns n2, otherwise -1. The second form tells you whether any object has collided with object n, returning the number of the object it collided with or -1; it is equivalent to calling the first form once for each object other than n.

### Gotchas
- You must set up zones with Td SET ZONE before Td COLLIDE can register anything.
- 3D can only check the zones once per frame — once each time you call Td COLLIDE. If objects move so fast that they pass through one another between frames, the overlap may not register; make your zones bigger.
- The second form takes longer the more objects you have, and it is wasteful when some objects are nowhere near object n: it takes 3D as long to decide a pair has not collided as to register a collision.
- Zones are also useful beyond collisions: a very large zone around two objects lets you detect when they come within a certain range (strategy routines).
- Object 0 is the viewpoint — you can set zones around the viewpoint just like any other object.

**See also:** TD SET ZONE, TD ZONE X, TD DELETE ZONE, TD RANGE

## TD ANIM REL
`Td ANIM REL n,p,x,y,z,finished_flag` — Apply a change to a point, relative to the point's position.

- **n**: object number
- **p**: point number (find it in OM with the Selection and Info tools, shown as e.g. `P(3,10)` — the second number is the point number)
- **x,y,z**: the change (delta) to apply to the point
- **finished_flag**: 0 = more ANIMs coming, 1 = no more ANIMs — process all the points together

Applies a change (a delta), specified by x, y and z, to point p of object n. The change is applied to the object as it was saved under OM; if you have rotated the object in your program, Td ANIM REL rotates the change too, so the effect on the object is the same. For example, to pull the top vertex of a pyramid up a little, specify a change of (0,50,0); to pull it left use (-50,0,0). To move a whole block (e.g. slide a hatch open on a spaceship) use the same Td ANIM command for each of its points.

### Gotchas
- finished_flag should be zero except on the last Td ANIM REL of a group; every object has its own finished flag. If you are about to change the object's attitude before the next Td REDRAW you can keep finished_flag zero even on the last point and save a little time.
- OM applies rules to keep faces flat, but there are no such checks on Td ANIM REL — 3D does exactly what you ask, however silly. Moving a single point of a cube bends at least one face, which confuses 3D and may give unexpected results. Try an animation out under OM first.

**See also:** TD ANIM, TD ANIM POINT X

## TD ANIM
`Td ANIM n,p,x,y,z,finished_flag` — Apply a change to a point.

- **n**: object number
- **p**: point number
- **x,y,z**: new coordinates for the point
- **finished_flag**: same as the flag in Td ANIM REL

Moves point number pn in object n to coordinates x,y,z.

### Gotchas
- Same warnings as Td ANIM REL: big changes to an object may not work; experiment to find out what you can and can't do.

**See also:** TD ANIM REL, TD ANIM POINT X

## TD ANIM POINT X
`=Td ANIM POINT X(n,pn)` — Return the position of a point.

- **n**: object number
- **pn**: point (vertex) number

Returns the X coordinate of animation point pn in object n. Before you animate an object, its points are always in the position they were in when the object was saved by OM, regardless of the object's rotation.

### Gotchas
- X, Y and Z are coordinates in the object's local system; they don't change when you move or rotate the object, only when you change its shape.

**See also:** TD ANIM POINT Y, TD ANIM POINT Z, TD ANIM

## TD ANIM POINT Y
`=Td ANIM POINT Y(n,pn)` — Return the Y coordinate of a point.

- **n**: object number
- **pn**: point (vertex) number

See TD ANIM POINT X.

**See also:** TD ANIM POINT X, TD ANIM POINT Z

## TD ANIM POINT Z
`=Td ANIM POINT Z(n,pn)` — Return the Z coordinate of a point.

- **n**: object number
- **pn**: point (vertex) number

See TD ANIM POINT X.

**See also:** TD ANIM POINT X, TD ANIM POINT Y
