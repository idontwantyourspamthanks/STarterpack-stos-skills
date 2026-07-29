---
name: stos-3d
description: STOS Basic programming with the STOS 3D extension (Voodoo Software / Europress, 1991-92) - real-time 3D worlds with 20 objects plus a viewpoint, filled-surface rendering, zones, animation and collision detection. Use ONLY when the user has said the STOS 3D extension is installed/loaded; vanilla STOS does not have these commands.
---

# STOS 3D

STOS 3D (Anthony Wilkes and Richard Lewis of Voodoo Software, for
Europress/Mandarin, 1991-92) is a full real-time 3D system for STOS Basic:
a world of up to 20 objects plus the viewpoint (object 0), rendered with the
"Simula" graphics system, with zones, keyframe animation, collision
detection and a companion Object Modeller (OM) for building 3D shapes.

## GATE - read first

These commands exist ONLY when the STOS 3D extension is installed and loaded.
Vanilla STOS does not have them. If the user has not said the extension is
loaded, ask - or use vanilla STOS (see the stos-syntax skill).

The extension ships in this repo: `extensions/stos-3d/Extensions/Stos/3D.EXS`
(interpreter, goes in the STOS folder) and
`extensions/stos-3d/Extensions/Compiler/C3DLIB.ECS` (compiler; compiled
programs also need `extensions/stos-3d/C3D.PRG` in their root dir). The Object
Modeller is at `extensions/stos-3d/OM.PRG`. Documented from the official
110-page scanned manual (`extensions/stos-3d/stos_3d_manual.pdf`).

## Key concepts

- All commands are prefixed `Td` (TD INIT, TD LOAD, TD OBJECT...).
- The world holds objects 1-20 plus object 0, which is the VIEWPOINT (camera).
  Camera moves use the same motion commands with n=0.
- TD POSITION/ATTITUDE are read functions; TD MOVE/TD ANGLE set absolute
  values; the REL variants are relative to the object's own current state.
- Objects are built with the Object Modeller (OM) or converted from CAD-3D
  files; shapes load with TD LOAD.
- TD ANIM is VERTEX animation (move a surface point absolutely or by delta),
  not a recorded-path player.
- TD PRIORITY and TD SET COLOUR were late additions (addendum page, not in
  the printed manual body); TD DEBUG is in the binary but undocumented.

## How to look things up

- Syntax of an extension command: find it in `reference/index.md`, then the
  linked `reference/commands/<topic>.md` (world, surface, position, motion,
  animation).
- Source discrepancies and manual typos: `reference/errata.md`.
- Vanilla STOS commands: the stos-syntax skill. Other extensions:
  stos-missing-link, stos-misty, stos-control, stos-ste, stos-blitter,
  stos-maestro, stos-gbp.
