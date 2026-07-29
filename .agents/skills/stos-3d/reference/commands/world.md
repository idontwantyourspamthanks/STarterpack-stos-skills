# STOS 3D commands: World, display and system

A 3D world is built from object instances: object 0 is the viewpoint (the camera) and objects 1-20 are scene objects created with Td OBJECT from definitions loaded with Td LOAD. Nothing is drawn until Td REDRAW is executed, so every 3D program is built around a redraw loop: position objects, Td CLS, Td REDRAW, Screen Swap. Positions are world coordinates in VLUs (a typical object is 500-2000 VLUs across; the OM standard cube is 360 VLUs a side, and the world is a 16,000,000 VLU box centred on the origin). 3D draws objects in colours 8-14; colour 15 is reserved for your own graphics.

## TD SCREEN HEIGHT
`Td SCREEN HEIGHT n` — Set the screen height for 3D drawing.

- **n**: screen height in raster lines

Sets the height of the 3D display area; the view from the viewpoint (object 0) can be displayed on a 16 colour screen up to 200 lines high. Bigger screens mean slower graphics, although in many situations there may not be a very great difference.

### Example
```text
Td SCREEN HEIGHT 130
```

### Gotchas
- Valid heights are 1 to 200 lines; anything else gives an `Invalid 3d screen size` error.
- You must kill off all your objects before changing the screen size, otherwise: `Can't change screen size while objects exist`.

**See also:** TD CLS, TD REDRAW

## TD REDRAW
`Td REDRAW screen address (usually logic)` — Draw all current visible 3D objects.

- **screen address**: screen to draw to, usually `logic`

Draws all current visible 3D objects and any background. You must explicitly tell 3D to refresh the display: all your calculations and object movements must be done in a loop.

### Example
(typical redraw loop from the manual)
```stos
10 rem Redraw Loop
20 Logic = Back
30 Repeat
40 rem Do all your calculations and object positioning here
50 Wait Vbl : rem This command is optional
60 Td CLS Logic
70 Td Redraw Logic
80 rem You can draw on top of the 3D objects here
90 Screen Swap
100 Until False
```

### Gotchas
- The Wait Vbl is sometimes required to prevent flicker in simple programs; with several objects it can be dispensed with.
- If you draw in colours 8-15 before Td REDRAW, 3D places objects behind your image and does not overwrite it — bitplane 3 is used as a mask by 3D (see TD BACKGROUND).

**See also:** TD CLS, TD SCREEN HEIGHT, TD BACKGROUND, TD VISIBLE

## TD CLS
`Td CLS screen address (usually logic)` — Clear the 3D display area with extra speed.

- **screen address**: screen to clear, usually `logic`

A fast screen clear for the part of the current screen specified in Td SCREEN HEIGHT.

### Example
```text
Td CLS Logic
```

### Gotchas
- Because only the 3D area is cleared, you can keep 2D graphics (such as a control panel) below the 3D display without erasing them.

**See also:** TD REDRAW, TD SCREEN HEIGHT

## TD DIR
`Td DIR folder$` — Set the object directory name.

- **folder$**: valid pathname of the folder holding the object files

Tells 3D to look in folder$ for object files. By default object files are held in the directory OBJECTS, which must be in the current directory.

### Example
```text
Td DIR "OBJECTS2"
```

### Gotchas
- An over-long pathname gives a `Directory string too long` error.
- Compiled programs also need C3D.PRG (the 3D run-time library) in the root directory of the disc, or 3D will not work.

**See also:** TD LOAD, TD CLEAR ALL

## TD LOAD
`Td LOAD file$` — Load the named object.

- **file$**: object name, the same one chosen when the object was designed in OM

Loads the named object. Nothing is displayed: to display a loaded object use Td OBJECT and Td REDRAW. Although you supply a single name, 3D may load several files (object, template and surface); this is completely automatic.

### Gotchas
- Errors: `Object file not found` (check the name and the Td DIR directory), `Object already loaded` (the same object loaded twice), `Bad Object/Template/Surface file` (corrupt or non-3D file).

**See also:** TD OBJECT, TD DIR, TD CLEAR ALL

## TD CLEAR ALL
`Td CLEAR ALL` — Remove any loaded objects.

Removes any instances of the loaded objects, then removes all the object definitions. If you have been loading many objects and are no longer using some of them, use this command and reload the ones you need; this ensures the maximum amount of memory is free.

### Gotchas
- Not the same as using Td KILL on every instance: Td KILL removes only the instances, not the object definitions.

**See also:** TD LOAD, TD KILL

## TD RANGE
`=Td RANGE(n1,n2)` — Return only the range between two objects.

- **n1,n2**: object numbers (either may be object 0, the viewpoint)

Returns the distance between objects n1 and n2, without calculating any angles. If you need the range and the bearing between two objects, use Td BEARING (which calculates both) instead.

**See also:** TD BEARING A, TD FACE

## TD SCREEN X
`=Td SCREEN X(x,y,z)` — Convert world coordinates to screen coordinates (x).

- **x,y,z**: a point in world coordinates

Converts the point (x,y,z) in world coordinates to STOS screen coordinates. 3D works out both X and Y values automatically when you call one of these functions, so the quickest way to calculate both is one full call followed by a dummy call.

### Example
```text
SCX=Td Screen X(10,10,1000)
SCY=Td Screen Y(0)
```

### Gotchas
- The dummy-parameter form Td SCREEN X(0) / Td SCREEN Y(0) returns the value from the last full call.

**See also:** TD SCREEN Y, TD WORLD X, TD VIEW X

## TD SCREEN Y
`=Td SCREEN Y(x,y,z)` — Convert world coordinates to screen coordinates (y).

- **x,y,z**: a point in world coordinates

See TD SCREEN X.

**See also:** TD SCREEN X

## TD WORLD X
`=Td WORLD X(n,x,y,z)` — Convert local coordinates to world coordinates (x).

- **n**: object whose local coordinate system the point is expressed in
- **x,y,z**: the point in local coordinates relative to object n

Converts a point expressed in the local coordinate system of object n to world coordinates. n does not have to be the viewpoint (object 0): you can use Td WORLD to get the world coordinates of any point as seen from any object's point of view, e.g. to make debris from a ship's engines trail behind it. All three values are generated by one call; read the others with dummy calls.

### Example
```text
ZW=Td World Z(5,x5,y5,z5)
XW=Td World X(0)
YW=Td World Y(0)
```

**See also:** TD WORLD Y, TD WORLD Z, TD VIEW X

## TD WORLD Y
`=Td WORLD Y(n,x,y,z)` — Convert local coordinates to world coordinates (y).

- **n**: object whose local coordinate system the point is expressed in
- **x,y,z**: the point in local coordinates relative to object n

See TD WORLD X.

**See also:** TD WORLD X, TD WORLD Z

## TD WORLD Z
`=Td WORLD Z(n,x,y,z)` — Convert local coordinates to world coordinates (z).

- **n**: object whose local coordinate system the point is expressed in
- **x,y,z**: the point in local coordinates relative to object n

See TD WORLD X.

**See also:** TD WORLD X, TD WORLD Y

## TD VIEW X
`=Td VIEW X(n,x,y,z)` — Convert world coordinates to local coordinates (x).

- **n**: object into whose local coordinate system the point is converted
- **x,y,z**: the point in world coordinates

The opposite of Td WORLD: converts a point in world coordinates to local coordinates relative to object n. Most often used with object zero, the viewpoint (hence its name), but it can be used with any object. All three values are worked out with a call to any of these functions.

### Example
```text
ZV=Td View Z(3,x3,y3,z3)
YV=Td View Y(0)
XV=Td View X(0)
```

**See also:** TD VIEW Y, TD VIEW Z, TD WORLD X

## TD VIEW Y
`=Td VIEW Y(n,x,y,z)` — Convert world coordinates to local coordinates (y).

- **n**: object into whose local coordinate system the point is converted
- **x,y,z**: the point in world coordinates

See TD VIEW X.

**See also:** TD VIEW X, TD VIEW Z

## TD VIEW Z
`=Td VIEW Z(n,x,y,z)` — Convert world coordinates to local coordinates (z).

- **n**: object into whose local coordinate system the point is converted
- **x,y,z**: the point in world coordinates

See TD VIEW X.

**See also:** TD VIEW X, TD VIEW Y

## TD VISIBLE
`=Td VISIBLE(n)` — Return whether an object is visible.

- **n**: object number

Returns 1 if object n (or any part of it) is on screen and 0 if it is not. 3D objects take a long time to process, and it takes time even to decide an object cannot be seen, so if an object is not going to be visible you may be able to delete it and save 3D time.

### Gotchas
- It is surprisingly easy to leave objects hanging around after they have served their useful purpose — don't. If an object is miles away, kill it off or move it in one jump to a position just off stage.

**See also:** TD REDRAW, TD KILL

## TD SET ZONE
`Td SET ZONE n,zone,x,y,z,r` — Define a zone.

- **n**: the object number
- **zone**: the zone number — 0 for the first zone, 1 for the second and so on
- **x,y,z**: the position of the centre of the zone, in the object's local coordinate system
- **r**: the zone radius

Defines an invisible spherical zone around an object, used for collision detection with Td COLLIDE. Because the zone is defined relative to the object, x, y and z are chosen so the zone surrounds the part of the object you want to be sensitive to collisions; if you are setting a single zone for each object, x, y and z should probably all be zero. When you rotate an object with one of the Angle commands, 3D automatically rotates the centres of all its zones as well.

### Gotchas
- Several zones per object make a compound zone that hugs the shape, but collision detection takes time: the more zones, the slower the program.
- 3D can only check zones once per frame; if objects pass through one another between frames, make the zones bigger.
- Object 0 is the viewpoint: you can set zones around it just like any other object.

**See also:** TD ZONE X, TD DELETE ZONE, TD COLLIDE

## TD ZONE X
`=Td ZONE X(n,z)` — Return the x coordinate of a zone's centre.

- **n**: object number
- **z**: zone number

Returns the x coordinate of the centre of zone z on object n, in world coordinates. Td ZONE is very useful if you want to draw zone circles around objects when debugging your program.

**See also:** TD ZONE Y, TD ZONE Z, TD ZONE R, TD SET ZONE

## TD ZONE Y
`=Td ZONE Y(n,z)` — Return the y coordinate of a zone's centre.

- **n**: object number
- **z**: zone number

Returns the y coordinate of the centre of zone z on object n, in world coordinates. See TD ZONE X.

**See also:** TD ZONE X, TD ZONE Z, TD ZONE R

## TD ZONE Z
`=Td ZONE Z(n,z)` — Return the z coordinate of a zone's centre.

- **n**: object number
- **z**: zone number

Returns the z coordinate of the centre of zone z on object n, in world coordinates. See TD ZONE X.

**See also:** TD ZONE X, TD ZONE Y, TD ZONE R

## TD ZONE R
`=Td ZONE R(n,z)` — Return a zone's radius.

- **n**: object number
- **z**: zone number

Returns the radius of zone z on object n. See TD ZONE X.

**See also:** TD ZONE X, TD SET ZONE

## TD DELETE ZONE
`Td DELETE ZONE n,zn` — Remove a previously defined zone.

- **n**: object number
- **zn**: zone number to remove, or a negative value to remove all zones

Removes zones set up with Td SET ZONE. If zn is positive or zero the command removes zone number zn from object n; if zone zn does not exist an STOS error occurs. If zn is negative, 3D removes all the collision zones from the object, and no error occurs if no zones exist.

### Gotchas
- The manual's syntax line prints `Td DELETE ZONE on, zn` — the `on` is a misprint; the quick reference gives `n, zn`. See errata-a.md.

**See also:** TD SET ZONE, TD ZONE X

## TD BACKGROUND
`Td BACKGROUND bank, offset, screen, X, Y, width, height` — Display a background.

- **bank**: bank reserved as screen, containing the background image
- **offset**: offset in bytes into the background bank, for multiple or offset images
- **screen**: screen to write to
- **X,Y**: screen coordinates of the image; can be completely off-screen
- **width,height**: size of the image

Lets you place a background behind all your 3D objects, or create a landscape or horizon. To draw the background behind 3D objects, use Td BACKGROUND after the Td REDRAW instruction. To draw an image in front of 3D objects (for example the circular windscreen of a spaceship), use Td BACKGROUND before Td REDRAW; the image must contain only colours 8-15 and 0, and you will see your 3D objects where the image is colour 0.

### Gotchas
- The byte offset must be even and the width must be a multiple of 16 pixels; violating either invokes a BASIC error (the manual jokes that it will result in "total destruction of the computer").
- Maximum image size is 320 x 200, and only data inside a bank reserved as screen can be used as image data.
- The source screen can't be the current screen: `3d background source screen is current screen`.
- Backgrounds can be drawn in any colours; 3D draws objects in colours 8-14 and colour 15 is reserved for your special graphics (for example sights).

**See also:** TD REDRAW, TD CLS

## TD INIT
`Td INIT bytes` — Define the size of the memory bank reserved for 3D.

- **bytes**: size of the STOS memory bank set aside for 3D

3D needs about 100K of memory; the basic memory is allocated (if not allocated already) by the first use of a 3D command. Td INIT lets you change the size of the reserved bank according to the screen size, number of objects loaded/used, etc. In the interpreter version the default is about 50K and Td INIT is optional. The bank needs to be at least twice the size of the screen used for 3D; if it is too small a STOS `Out of memory` error is generated.

### Gotchas
- Td INIT can only be used once in a program and, if used, must be the first 3D command (`Td init not the first 3D instruction`).
- In the compiler version Td INIT MUST be called as the first 3D command (`Td init must be the first 3D instruction in compiled programs`).

**See also:** TD ADVANCED

## TD ADVANCED
`=Td ADVANCED n` — Access to the object structures.

- **n**: object number, or 0 for the 3D data segment

Provided for advanced programmers who wish to experiment with the actual 3D object structures in memory. Td OBJECT builds a structure called an Object Frame for each instance, containing a basic block of data defining the instance, including a pointer to each block structure (the Layers). If n is zero the function returns the 3D data segment address; otherwise it returns the address of the Frame for object n.

### Gotchas
- Needless to say, the authors can't predict the results of monkeying with the 3D structures.

**See also:** TD OBJECT, TD INIT

## TD PRIORITY
`Td PRIORITY n,p` — Define the order in which objects are drawn.

- **n**: object number
- **p**: object drawing priority

Specifies the order in which objects are drawn by the 3D system; objects that are drawn first appear in front of other objects:

- **p = 0**: draw the object in the normal way (by depth)
- **p > 0**: draw the object in front of all other objects with a lower priority
- **p < 0**: draw the object behind all other objects with a higher priority

By default all objects have a priority of 0. If two objects have non-zero priority, the one with the highest priority is drawn first (in front).

### Gotchas
- Normally objects are ordered by an approximate method based on each object's centre of gravity: if the centre of one object is further away than another's, it is drawn behind. When this produces incorrect results, use Td PRIORITY — or move the offending object's centre (OM's Centring tool), which can be anywhere, even outside the object.
- This command appears on the manual's addendum-style page 87 (typeset differently from the rest of the manual) and is absent from the quick reference. See errata-a.md.

**See also:** TD SET COLOUR, TD REDRAW

## TD SET COLOUR
`Td SET COLOUR n,b,c` — Set a specified object's block colour.

- **n**: object number
- **b**: block number
- **c**: colour combination code of the block (same as in OM)

Sets the colour combination code of the specified block. Valid colour numbers range from 0 to 15: colour combinations 0 to 9 are the same as in OM, colour combinations 10-15 are new. An out-of-range colour code is truncated to the nearest valid code without causing an error.

### Gotchas
- Like TD PRIORITY, this command appears only on the manual's addendum-style page 87 and is absent from the quick reference. See errata-a.md.

**See also:** TD PRIORITY, TD OBJECT

## TD DEBUG

> [!NOTE] Unverified: TD DEBUG exists in the extension's token table (3D.EXS version 1.1) but is documented nowhere in the scanned manual — not in the command chapters, the quick reference (page 110) or the error-message appendix — and no disk README survives in this copy. No syntax, parameters or description can be recovered, so nothing further can be stated with confidence. See errata-a.md.

**See also:** TD INIT, TD ADVANCED
