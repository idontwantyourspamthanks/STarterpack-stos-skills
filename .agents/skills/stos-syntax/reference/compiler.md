# STOS Compiler User Guide

The STOS Compiler transforms any existing STOS Basic program into machine code, giving you "all the speed of a language like C, with the ease of use you have come to expect from STOS Basic." Unlike compilers for other Basics, the STOS compiler is completely interactive — you can compile, run and test your programs directly from the STOS Basic editor. It can also produce standalone GEM-executable programs which can be run straight from the GEM desktop and freely distributed without copyright restrictions.

The compiler was designed with 520ST users in mind: full-sized STOS Basic programs can be compiled on an unexpanded machine with no disc swapping, and every program on the STOS Games disc can be compiled on the smallest system.

## Installation

Configuration is needed once before first use. The manual estimates it takes under ten minutes. Begin by making a backup of the compiler disc and using that backup for all subsequent compilation.

The package requires STOS Basic version 2.4 or higher; an upgrade is included on the compiler disc. The main improvements in v2.4 are:

- Better support for extension files.
- Floating point arithmetic now uses single precision, and is much faster.
- A few minor bugs have been fixed.

Ninety per cent of existing STOS Basic programs will be totally compatible with v2.4; the remainder (those using floating point arithmetic) must be converted with `CONVERT.BAS` (see [Floating point routines](#floating-point-routines)).

### Backing up the compiler disc

1. Slide the write-protect tab of the original disc so you can see through the hole (protecting against mistakes during copying).
2. Place a blank disc into drive A and format it in the normal way.
3. Put the compiler disc into drive A and drag its icon over drive B.
4. Follow the GEM dialogue-box prompts.

### Installing STOS v2.4 onto a floppy system

1. Boot STOS Basic as normal.
2. Place the compiler disc into drive A.
3. Enter the line:
   ```text
   run "stosv204.bas"
   ```
4. Select the current drive using the A and B keys, and hit G to load the new STOS files into memory. You can now place a disc containing STOS Basic into the appropriate drive. Update ALL your working copies of STOS to v2.4 to avoid mix-ups with the compiler — but do not update your original STOS language disc until AFTER you have successfully copied and tested one of your backups.
5. Repeat step 4 for all your working copies of STOS Basic.

### Installing STOS v2.4 on a hard disc

1. Create a floppy version of STOS v2.4 using the procedure above.
2. Copy the STOS folder onto the hard disc along with the `BASIC204.PRG` file.

### Auto-loading the compiler

The compiler is controlled through the accessory program `COMPILER.ACB`. To auto-load it at startup, edit the `EDITOR.ENV` file on the STOS boot disc:

1. Insert the original STOS language disc into drive A and run the configuration program:
   ```text
   run "config.bas"
   ```
2. When the main menu appears, click on the NEXT PAGE icon.
3. Click on the first free space in the accessory list and enter:
   ```text
   compiler.acb
   ```
4. Add these function-key definitions to simplify loading and saving compiled programs:
   ```text
   F14 (shift-F4)   fload "*.CMP"
   F15 (shift-F5)   fsave "*.CMP"
   ```
5. Save the new configuration file to your working copy of STOS Basic using the "SAVE ON DISC" command.
6. Copy the `COMPILER.ACB` file onto the language disc root directory so STOS Basic picks it up at boot.

### Using the compiler on different system configurations

The files in the `COMPILER` folder must be available from the current drive whenever the compiler runs. This keeps the resident part of the compiler down to around 25k and lets you compile large programs on a 520ST.

**512k ST with one floppy drive.** Keep a copy of the `COMPILER` folder on every disc used for compilation. A special `COMPCOPY` accessory is supplied for this. Insert the compiler disc into drive A and type:
```text
accload "compcopy"
```
Press HELP, select COMPCOPY with its function key, press G to load the folder into memory, then insert a blank disc when prompted; the compiler files are copied onto it. Depending on drive format you are left with either 200k or 480k of free space — adequate for all but the largest programs. Note that the compiler does NOT allow disc swapping during compilation, so on a single-drive system you cannot compile a program from drive A to drive B.

**512k ST with two floppy drives.** Place a disc containing the `COMPILER` folder in drive A and your program disc in drive B.

**With a ramdisc (1040ST or higher).** Copying the contents of the `COMPILER` folder to a ramdisc dramatically speeds up compilation. The supplied `STOSRAM.ACB` accessory creates one (see [Utility programs](#utility-programs)).

1. Load STOSRAM from the compiler disc:
   ```text
   accnew:accload "stosram.acb"
   ```
   Press HELP then F1 to enter the accessory.
2. Press S to choose the ramdisc size. The default of 150k is the minimum needed to hold the entire `COMPILER` folder.
3. Press C to set the source folder path name (default `A:\COMPILER`).
4. Insert a disc containing both STOS Basic and the `COMPILER` folder in drive A. Press G to add the ramdisc to the AUTO folder. The ramdisc will be created and loaded automatically whenever STOS Basic boots.

Typical compilation speeds with a ramdisc are around 10k per second — the BULLET program compiles in under 15 seconds. For single-density drive users, the STOS language disc and `COMPILER` folder will not both fit on a 320k disc; remove one picture file from the STOS folder (`PIC.P13` for colour monitors, `PIC.P11` for mono) before copying the `COMPILER` folder.

**On a hard disc.** The default path for the `COMPILER` folder is set from the first line of the compiler accessory and can be edited:
```text
load "compiler.acb"
10 COMPATH$="D:\STOS\UTILITY":rem Example path name
save "compiler.acb"
```

If `COMPATH$` is empty (the default), the accessory searches for the folder in this order:

1. The current directory.
2. The root directory of the current drive.
3. The root directories of all available drives from C upwards.

## The compiler accessory

After booting STOS Basic with the new configuration, the COMPILER accessory is loaded automatically. You can also load it directly from the compiler disc:
```text
accload "compiler"
```
Enter the accessory from the `<HELP>` menu. The control panel is driven by five "buttons" activated by moving the mouse pointer over them and clicking the left button.

### SOURCE

Toggles between compiling from memory or from disc:

- **MEMORY** — compile the program you are currently editing. Any of the four program segments may be compiled independently without affecting the others. Fast, but uses a lot of memory.
- **DISC** — compile from a file on disc. Slower, but needed for programs too large to compile from memory. Ensure the `COMPILER` folder is accessible from the current drive. DISC is selected automatically when memory runs short.

### DEST

Selects where the compiled program goes:

- **MEMORY** — compiled into memory that is completely separate from the source program, so you can save the compiled program without erasing your Basic listing.
- **DISC** — compiled straight into a file without consuming memory. Much slower than MEMORY, so only suitable for large programs.

### COMPILE

Click to start compilation. A horizontal bar grows across the screen as the program is compiled; when it reaches the edge, compilation has succeeded. If an error is detected the compiler terminates and returns you to the editor.

The compiler tests the whole program rather than the current line, so it can surface syntax errors that the interpreter misses because the affected line is rarely executed (the manual cites Zoltar as an example of a "bug-free" program that surfaces errors when compiled).

### QUIT

Exits the accessory and returns to the editor.

### DISC (BASIC / GEM)

Chooses whether the compiled program runs from inside STOS Basic or standalone from the GEM desktop:

- **BASIC** (default) — produces a `.CMP` file that runs only within the STOS Basic system.
- **GEM** — produces a `.PRG` file that runs independently of STOS Basic. Because it is pure machine code it cannot be listed or amended from STOS Basic. Programs in this format can be sold or distributed freely. The GEM-run version of a file is between 40 and 80k larger than the equivalent STOS-run program.

### OPTIONS

Clicking OPTIONS reads/writes configuration settings stored in an `OPTIONS.INF` file in the `COMPILER` folder. The options screen lets you fine-tune the eventual program.

**Compiler tests** — sets the frequency of the internal checks STOS performs for sprite updates, menu access and Control+C:

- **Compiler test OFF** — removes the tests entirely. The compiled program ignores Control+C, will not open menus, and does not auto-update moved sprites. The final code is roughly 10% faster.
- **Compiler test NORMAL** (default) — a check is performed before every branch (GOTO, NEXT, REPEAT, WEND, ELSE, THEN) and before slow instructions like PRINT and INPUT.
- **Compiler test ALWAYS** — adds a test before every Basic instruction, giving particularly smooth sprite movement at the cost of some speed.

These settings can also be changed from within a program (see [Extension commands](#extension-commands)).

**Gem-run options** (affect only programs compiled to run from the desktop):

- **Resolution mode** — choose low or medium resolution when run from a colour monitor. Ignored on a monochrome monitor.
- **Black and white environment** — chooses between NORMAL (white on black) and INVERSE ("paper white") on a monochrome monitor.
- **Default palette** — sets the initial 16 colours (4 in medium resolution). Increment/decrement the colour number, then adjust the red/green/blue components with the `+`/`-` buttons. Hold the right mouse button for rapid stepping, left button for single steps.
- **Function keys** — ON draws the function-key window at the top of the screen during initialisation; OFF omits it (useful for a more professional finish).
- **Cursor** — activates or deactivates the text cursor at startup (changeable later with `CURS ON`/`OFF`).
- **Mouse** — decides whether the mouse is on or off as a default (the program can re-enable it with SHOW).
- **Language** — ENGLISH or FRENCH system messages.

**Memory-tuning options** (be careful — improper use can crash the ST):

- **Loaded character sets** — the compiled program normally includes all three STOS character sets; if you will only run in a single resolution you can omit the others. Running in the wrong resolution after changing this will crash the ST.
- **Loaded mouse pointers** — same idea for mouse pointer data.
- **Window buffer size** — default 32k, adjustable in 1k steps. Each character position takes 2 bytes in medium/high resolution and 4 bytes in low resolution. Don't forget the function-key window and file selector, which together use about 8k.
- **Sprite buffer size** — before a sprite is copied to the screen it is drawn into a separate buffer; if you only use small sprites you can reduce this to around 1k.

Other buttons on the OPTIONS screen: **MAIN MENU** returns to the main compiler menu; **NEXT PAGE** shows the next page of options; **LOAD OPTIONS** loads an existing `OPTIONS.INF` from disc; **SAVE OPTIONS** saves current options to the `COMPILER` directory.

## Tutorial

### A first compile

Load the compiler accessory into memory:
```text
accload "compiler"
```
Enter this STOS program:
```stos
10 timer=0:for i=1 to 100000:next i
20 print "Loop took ";timer/50.0;" seconds"
```
This takes about seven seconds to run interpreted. Insert a disc containing the `COMPILER` folder in drive A and open the accessory via `<HELP>`. Click COMPILE: the disc spins as compiler libraries are loaded, and a horizontal bar shows progress. When it finishes you are offered the choice of GRABbing the compiled program into one of the four program segments (or saving it directly via the file selector).

Run the compiled program with `RUN`. It executes in around three seconds — over twice the speed of the interpreted version. Listing it produces:
```text
**********************************
*   COMPILED PROGRAM             *
*   Don't change line 65535!     *
**********************************
```
Line 65535 holds a special instruction that runs the compiled code; deleting it destroys the compiled program. (Mixing interpreted Basic lines into a compiled program is possible but not recommended.)

Compiled programs work with the normal LOAD and SAVE instructions, e.g.:
```text
save "loop.cmp"
```
A unique feature of the STOS compiler is that the interpreted source can stay in memory while you debug the compiled version, so you can flick back to the Basic code, fix bugs, and recompile in seconds without leaving STOS Basic.

### Compiling a full-sized game

Place the STOS games disc in drive A and load BULLET:
```text
dir : rem Update current disc directory
dir$="\bullet" : rem Enter Bullet directory
load "bullet.bas" : rem Load Bullet
```
Insert a copy of the compiler disc (one prepared with COMPCOPY if you are on an unexpanded 520ST). Open the COMPILER accessory, click the button below DEST to force output straight to disc (not needed on a 1040ST), then click COMPILE. You are prompted for a filename such as `BULLET.CMP`. After a few minutes, exit the accessory with QUIT and run the compiled file:
```text
accnew : rem Remove all accessories (520 users only)
load "bullet.cmp"
```
Place the STOS Games disc back in the drive and:
```text
dir : rem Update directory
dir$="\bullet"
run
```

### Compiling a GEM-run program

GEM-run programs can be distributed without the protection problems of run-only interpreted programs. Here is the manual's small example — a Neochrome picture viewer:
```stos
5 mode 0:flash off
10 F$=file select$("*.NEO","Display a NEOCHROME screen")
20 if F$="" or len(F$)<5 then end
30 if right$(F$,4)<>".NEO" then boom : goto 10
40 hide:load F$,back : rem Load screen
50 wait key:show
```

Put your working compiler disc in drive A, call up the compiler from `<HELP>`, click the box marked BASIC so it changes to GEM, then click COMPILE. After a short while you are prompted for a filename and the file is written to disc. To test it, leave STOS and run the program from the GEM desktop. Save your original interpreted program first.

For a full-sized example, the manual describes compiling the sprite editor (`sprite.acb`) into a standalone GEM program — there isn't enough memory to compile it to memory on a 520ST, so set SOURCE=memory/DEST=disc, toggle BASIC→GEM, and select COMPILE. The result is a self-contained sprite editor runnable outside STOS.

On average GEM-run programs are about 40k larger than the equivalent STOS-run compiled program, because they must incorporate library segments for sprites, windows, menus, music and floating point arithmetic. Once a program is compiled to GEM format it cannot be executed from STOS Basic, so always keep a copy of the original interpreted source.

## Extension commands

The compiler adds three extended commands to STOS Basic. These have no effect in interpreted programs — they only influence the behaviour of a compiled program. They give fine control over the internal tests that STOS normally performs at regular intervals:

- Sprite updates.
- Menu checks.
- Control+C tests.

### COMTEST ON

`COMTEST ON` — Restore the default interpreter-style testing in a compiled program.

Checks are carried out only before jump instructions (such as GOTO and WHILE) and especially slow commands like PRINT or WAIT. This is the default setting used by interpreted programs.

### COMTEST OFF

`COMTEST OFF` — Disable all internal tests in a compiled program for maximum speed.

Stops testing completely, improving speed by up to 10%. This lets you optimise time-critical sections of a compiled program — particularly useful for routines that perform large numbers of complex calculations in a short time, such as 3D graphics or fractal generators.

### Example
```stos
10 dim a(10000),b(10000)
20 for i=0 to 10000:a(i)=i:next i:rem Load an array
30 comptest off:timer=0:print "Compiler test off"
40 for i=0 to 10000:b(i)=a(i):next i
50 print "Loop executed in ";timer/50.0;" seconds"
60 comptest on:timer=0:print "Compiler test on"
70 for i=0 to 10000:b(i)=a(i):next i
80 print "Loop executed in ";timer/50.0;" seconds"
```

### Gotchas
- While tests are off, the program cannot be interrupted — an infinite loop will lock up the system and you will lose unsaved data. Get into the habit of saving your program before calling `COMTEST OFF`.
- If you try to stop the example above with Control+C after line 30, the program will not actually terminate until around line 60, which is the first point at which the Control+C test runs again.

### COMTEST ALWAYS

`COMTEST ALWAYS` — Insert a test before every STOS Basic instruction.

Results in slightly smoother sprite movement and finer control over the menus. The precise effect depends on the mix of instructions in your program: if the code makes heavy use of GOTO and FOR...NEXT the difference is barely noticeable, but if a calculation-heavy routine also uses sprites this instruction can be invaluable.

## Troubleshooting

### The compiler generates an out-of-memory error

Common when compiling a large (100k+) program on an unexpanded 520ST. The compiler offers four source/destination combinations; try them in this order (fastest first):

| SOURCE | DESTINATION | Comments |
| --- | --- | --- |
| MEMORY | MEMORY | Very fast, but uses the most memory. |
| DISC | MEMORY | Slower, but uses considerably less memory. |
| MEMORY | DISC | Slightly slower than DISC→MEMORY; memory use can occasionally be less. |
| DISC | DISC | Uses very little memory. The only limit is available disc space; slow on a single floppy. |

If none of those work, reduce the program size:

- Move permanent memory banks out of the program: define each screen bank with `RESERVE AS SCREEN`, load screens from disc with `LOAD`, define any DATA banks as WORK banks with `RESERVE AS WORK`, and load the external data from disc at startup. This can dramatically reduce size since memory banks make up a large percentage of many STOS programs.
- Split the program into overlays loaded with `RUN`. Compile each module separately — do not mix interpreted and compiled modules, or the program will fail when run from the desktop.

### Undimensioned array error for an array which is correctly dimensioned

The compiler requires the `DIM` statement to appear in the listing BEFORE the array is used. This example errors out:
```stos
10 gosub 1000
20 a(10)=50
30 end
1000 dim A(100):return
```
because at line 20 the compiler has not yet seen the `DIM` at line 1000. Fix it by dimensioning arrays at the top of the program (replace line 10 with `10 dim a(100)`).

### Syntax error at an ON...GOTO or ON...GOSUB

To optimise speed, the line numbers used by `ON GOTO` and `ON GOSUB` must be constants, not expressions. So this fails:
```text
on A goto 1000,10000+A*5,500
```
Replace with constant line numbers, e.g. `on A goto 1000,10010,500`.

### A previously error-free program returns a syntax error when compiled

This is simply the compiler's improved sensitivity to genuine syntax errors. The interpreter only checks the line currently being executed, so a typo in an unreached line is missed. For example:
```stos
10 print "hi there"
20 goto 10
30 prunt "This is an error"
```
The `prunt` at line 30 is never executed so the interpreter never reports it; the compiler scans every line and flags it immediately.

### Problems compiling with certain extension commands

Extensions that are to be compiled need a separate extension file with the extension `.ECN`, where N is the identifier of the extension file. The appropriate file is normally included with the extension and must be placed in the `COMPILER` folder.

### Colours of a GEM-run program differ from the interpreted version

Happens if the default colour settings have been altered in the options menu — once saved to disc, those settings affect all subsequent compilations. Restore the standard options from the original compiler disc to fix.

### A program that reserves a memory bank inside a FOR...NEXT loop crashes

Reserving a bank inside a `FOR...NEXT` loop behaves unpredictably if the bank number is held in an array — this can crash STOS Basic entirely:
```stos
10 dim b(15)
20 for b(3)=1 to 10
30 reserve as screen b(3)
40 next b(3)
```
Avoid by using a simple variable as the index, or by defining the banks explicitly outside the loop:
```stos
20 for i=1 to 10
30 reserve as screen i
40 next i
```

## Floating point routines

When STOS Basic was first designed it used the IEEE standard for floating point, supporting numbers between roughly -1.797692E+308 and +1.797693E+307, accurate to 16 decimal digits. In practice few programs need that accuracy — arcade games use integers, and programs that do need floating point (such as 3D graphics) need it to be fast.

STOS v2.4 therefore replaces the old format with single precision:

- Range: 1E-14 to 1E+15.
- Precision: seven significant digits.
- Speed: all floating point operations are roughly three times faster; trigonometric functions like SIN and COS run at more than thirty times their earlier speed.
- The improvement applies equally to interpreted and compiled programs.

The compiler is currently only compatible with the new single-precision system. Listing an old v2.3 program that uses real numbers displays:
```text
BAD FLOAT TRAP
```
To migrate them, run the supplied `CONVERT.BAS` utility from the compiler disc:
```text
run "convert.bas"
```
You are prompted for a v2.3 program; insert the appropriate disc and pick the program with the STOS file selector. It is converted to v2.4 format and copied back to the original file. Convert every STOS Basic program that uses real numbers to avoid future confusion.

## Technical details

### Improved garbage collection

Garbage collection is a problem in any language that manipulates variable-sized data such as strings. When a string grows, the extra characters cannot simply be tacked onto the end (they would overwrite neighbouring variables), so STOS instead defines a new string at the next free memory location and leaves the old characters behind as "garbage". Operations such as string concatenation and `SPACES` also generate intermediate garbage. Eventually STOS must reorganise memory to recover the unused space.

Because it is impossible to predict when memory will run out, garbage collection can happen at wildly unpredictable intervals and, in extreme cases, take several whole minutes. The worst problems occur in programs that do heavy string manipulation such as adventure games.

The compiler (and STOS v2.4) optimises all garbage collection routines for maximum speed. To illustrate, run this program:
```stos
10 dim a$(5000)
20 for x=0 to 5000
30 a$(x)=space$(3)+"a"+space$(2):rem This generates a lot of garbage
40 home:print x;
50 next x
100 timer=0
110 print free:rem Force a garbage collection
120 print timer/50.0
```
On STOS Basic v2.3 the garbage collection takes several minutes; on v2.4 it occurs almost instantaneously. So garbage collection will never be a significant problem for a compiled program.

### How the compiler works

The compiler was designed to use as little memory as possible — most of the memory it needs is borrowed from the sprite background screen, which is why the mouse disappears while it runs.

The compiler first reserves some memory in the current background screen and opens the main Basic library (`BASIC204.LIB`) from the `COMPILER` folder, loading the addresses of all the appropriate library routines. It then checks for extension files ending in `.EC` (one per extension identifier); each contains the information needed to compile that extension's commands. Whenever an extension is discovered, a full catalogue of its additional routines is added to the current list. Compilation then proceeds in three passes.

**PASS 0** — Checks the program for syntax errors and makes an initial attempt at converting it to machine code. No actual code is generated; the pass simply produces a full list of the library routines that will be called, allowing the compiler to estimate the final size and reserve precisely the right amount of memory.

**PASS 1** — Re-analyses the program using the same method, then converts the entire program to machine code and copies it to memory or disc. It builds several tables including the relocation table, then incorporates the library routines actually accessed by the program — only those routines that are genuinely used are included, which keeps the final code as small as possible. The following steps are then performed in quick succession:

1. If an extension command is used, the extension libraries are searched and the appropriate routines written into the compiled program.
2. The relocation table is copied in, allowing the program to be executed anywhere in the ST's memory.
3. The line-address table is added.
4. Any string constants are tagged onto the end of the program.
5. If the program is to be GEM-run, the library routines for sprites, windows, menus, music and floating point arithmetic are copied in. These add roughly 40k to the program length.

**PASS 2** — Explores the relocation table created in pass 1 and sets the required addresses in the compiled program. The compiler then closes all open disc files and transfers the program to the current program segment if needed.

The final size of a compiled program depends on the precise mix of STOS instructions used — there is no real relationship between complexity and code size. Some of the simplest Basic instructions are the hardest to compile (the STOS file selector alone is over 4k of machine code). As an illustration, the listing `plot 320,100,1` compiles to:
```text
move.l #1,-(a6)
move.l #100,-(a6)
move.l #320,-(a6)
jsr plot
```
The `plot` subroutine is a library routine merged into the compiled program.

### STOS-run programs

STOS-run (`.CMP`) programs have the standard Basic header plus a fake line 65535 with a single instruction that calls the compiled code. Memory banks are handled by the editor exactly as for an interpreted program, so you can BGRAB or SAVE them as usual. A compiled program can also be executed as a STOS accessory: load it into memory and re-save it with the extension `.ACB`.

### GEM-run programs

GEM-run (`.PRG`) programs use the same header format as TOS files. There is no TOS relocation table — the relocation address points to an empty table — and the start of the program is instead written in PC-relative code containing a small routine that relocates the main program using the STOS relocation table.

On startup a GEM-run program:

1. Finds the address of the top of memory using location `$42E`.
2. Subtracts 64k for the screens and moves any memory banks (which are normally chained to the compiled program) to the end of memory. This gives the program free space between itself and the banks.
3. Sets up the standard STOS environment: initialises all the TRAP routines (sprites, windows, music), activates the STOS interrupts and kills the GEM interrupts.
4. Erases the screen, activates the mouse pointer and starts executing the compiled program.

## Utility programs

The package includes several small accessory programs.

### STOSRAM (ramdisc accessory)

`STOSRAM` creates a ramdisc of any size up to the maximum available RAM. It is especially useful for 1040 users, who can copy the `COMPILER` folder into memory and dramatically speed up compilation (see [Installation](#using-the-compiler-on-different-system-configurations)).

The accessory works by adding a `STOSRAM.PRG` program to the current AUTO folder. This program runs every time STOS Basic boots, and is automatically loaded with the contents of any folder on the current disc.

Options:

- `<A>` or `<B>` — sets the drive on which the ramdisc program will be installed.
- `<S>` — chooses the size of the ramdisc in kilobytes. The default is 150k (just right for the `COMPILER` folder).
- `<C>` — selects the path name for the folder to be loaded into the ramdisc at startup. If this string is empty, or the requested folder cannot be found, the ramdisc is left vacant. Only individual files in the directory can be copied, not entire folders.
- `<G>` — creates a new ramdisc using the previously set options and copies `STOSRAM.PRG` into the current AUTO folder (creating the folder if needed).

The ramdisc is not removed from memory by resetting the computer — it must be completely powered off. If you reset and boot STOS again, another ramdisc will be created.

### FORMAT (disc formatter accessory)

`FORMAT` formats a disc directly from STOS Basic. Options:

- `<A>` or `<B>` — selects the current drive.
- `<1>` or `<2>` — toggles between 360k single-sided (1) and 720k double-sided (2) format.
- `<G>` — formats the disc in the current drive.
