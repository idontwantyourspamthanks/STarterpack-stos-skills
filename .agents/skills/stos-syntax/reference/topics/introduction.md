# Introduction

STOS — *The Game Creator* — is a development package built around STOS Basic, a language of 340 commands (many with several uses) aimed squarely at writing arcade-style games on the Atari ST. This chapter introduces the package, explains how to back up the supplied discs, and describes how to turn a finished program into something you can publish.

## What makes STOS different

STOS Basic is **not a GEM-based language**. Bypassing GEM gives it two practical advantages over other ST Basics:

- It runs considerably faster.
- It is not tied to a single screen resolution — you can switch between all three ST modes from within a program with [`mode`](../commands/graphics.md).

In place of the GEM user-interface routines, STOS provides its own equivalents: a powerful windowing system, easy-to-build drop-down menus, and a built-in file selector. These are documented later in the manual.

## What's in the box

STOS is supplied on three discs:

- **STOS Basic** — the language itself.
- **Accessories** — small programs that run alongside your own code to speed up development. The bundle includes a Sprite Definer, Music Editor, Character Editor, Icon Editor and more.
- **Games** — three complete games written in STOS Basic, supplied as both entertainment and reference:
    - **Bullet Train** — fast horizontal scrolling.
    - **Zoltar** — a Galaxian-style shoot-'em-up written in three days.
    - **Orbit** — a feature-packed bat-and-ball game.

STOS is described in the manual as a full-blown developer's kit rather than "just another Basic", and there were plans for a number of extension discs adding new commands.

## A note on game design

The manual stresses that programming skill is less important than the strength of your ideas. Several classic games are cited as uncomplicated programs with one or two strong features — Confuzion, Zenji, Tetris and Split Personalities. If you have never written a game before, do not be daunted.

## Making a back-up

The STOS discs are unprotected, so you can copy them to fresh floppies or upload them to a hard drive. Mandarin Software asks that you do not give copies to other people — sales fund further extension discs and accessories.

The three supplied discs are your **master discs**. Copy each one to a freshly formatted working disc, then store the masters somewhere safe. If a working disc is damaged, corrupted, or has files deleted from it, you can produce a new copy from the master.

The backup procedure from the GEM desktop:

1. Boot the GEM desktop.
2. Place a blank disc in drive A and format it using the desktop menu command.
3. Place the master disc in drive A and drag the drive A icon onto the drive B icon.
4. Follow the instructions in the dialogue boxes.
5. Repeat steps 2–4 for the other two discs.
6. Once the copy is complete, store the master discs somewhere safe.

If you have trouble with the copying step, refer to your Atari ST manuals.

## Distributing your programs

When you have written a program you want to publish, STOS lets you save it with a `.PRG` extension to produce a file that can be booted directly from the GEM desktop. The manual asks that you credit STOS on the loading screen of any released game. Technical details of this process are covered in Chapter 3 and Appendix B.

Mandarin Software actively invited submissions written in STOS. If you protect your game commercially, they suggest allowing other STOS users to examine and modify your sprite and music banks — this makes the game more interesting to the STOS community and could increase sales.

Fill in the registration form enclosed in the STOS packaging to join their user database and enter the monthly prize draw.

## Using this manual

The manual is organised around STOS Basic's special functions rather than as a primer on Basic itself. If you have never programmed in any dialect of Basic, the authors recommend an introductory textbook such as *Alcock's Illustrating Basic* (Cambridge University Press). It is possible to pick up Basic from this manual alone, but some general techniques will not be obvious from STOS-specific examples.

A few points to bear in mind when working through the examples:

- The manual is set out in tutorial fashion, with example programs demonstrating each instruction.
- Example programs are written for **low resolution mode** on colour monitors, the mode used by most commercial games. STOS itself runs in all three resolutions, so monochrome-monitor owners can still use the language.
- Get into the habit of booting STOS directly from disc rather than launching it from GEM. This frees an extra 32k of memory for your programs.

A comprehensive appendix covers technical information aimed at experienced programmers.
