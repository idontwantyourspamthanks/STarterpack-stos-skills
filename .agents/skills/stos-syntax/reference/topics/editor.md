# The STOS editor

On loading STOS Basic you are presented with two windows: a thin strip across the top listing the current function-key assignments, and the larger editor window below it where you create and manipulate programs. The text cursor marks the position of the next character to be typed and also marks the current line, which is sent to the editor by pressing Return.

## Editing lines

As you type, characters appear under the cursor and the cursor advances. The arrow keys move the cursor within the current line, and clicking the left mouse button jumps the cursor to the pointer's position. Backspace deletes the character to the left of the cursor; Delete deletes the character under the cursor; Shift+Delete erases the entire line under the cursor; Control+J joins two lines into one.

The editor has two modes. **Replace mode** (the default) overwrites existing text as you type. **Insert mode** opens a space for each new character at the cursor and is shown by a thicker cursor; toggle it with the Insert key. Replace mode is re-entered automatically whenever the system is reset by the `RUN` command.

## Function keys

The top window lists the current function-key assignments. Pressing a function key enters its assigned string at the cursor, exactly as if you had typed it. The shifted versions of the keys are numbered f11-f20; the f1 key is special — it always holds a copy of your last editor command, so its contents change continually as you work.

Assignments are changed with the `KEY` function, where `'` denotes Return:

```text
key(3)="boom"'
f3
```

`KEYLIST` (shift+f20) prints the full list of current assignments.

## Control keys

These keys issue commands directly to the editor:

- **Help** — opens a dialogue box listing the four program slots (current one highlighted), the loaded accessories and the free memory remaining. The program cursor is moved with the up/down arrow keys; pressing Help again enters the chosen slot.
- **Control+C** — terminates any running program and returns to the editor.
- **Undo** (pressed twice) — redraws the screen and reinitialises the editor; recovers from a corrupted editor screen or shows the line at which an error halted execution.
- **Clr** — clears the editor window (same as `CLW`).
- **Home** — moves the cursor to the top-left of the screen.
- **Esc** — enters multi-mode display.
- **Spacebar** — suspends a listing; press again to resume. Listings can be aborted with Esc or Control+C.

The arrow keys, Return (also achievable by double-clicking the left mouse button), Delete, Shift+Delete and Backspace behave as in any text editor.

## Customising the editor

The default colours are white on black. The `ENV` instruction (shift+f9) pages through 14 preset colour schemes; the choice survives `Undo` and `DEFAULT` but is lost when you leave STOS. For permanent control — boot resolution, language, pen/paper colours picked from the full 512-colour RGB palette (each component 0-7), default function-key assignments and the accessories auto-loaded at startup — run the supplied configuration program with `run "CONFIG.BAS"`, pick items with the mouse, then **Save on Disk** so the settings take effect on every subsequent boot.

## Loading, saving and running

`LOAD "filename"` loads a program whose name you know. `FLOAD "*.bas"` (f4) opens a file-selector dialogue to pick a file from disc; it has Up/Down buttons for paging through the directory, a Dir button to refresh the listing after a disc change, and a Previous button to leave a folder (folders are marked with a `*`). `FSAVE "*.bas"` (f5) saves the current program through the same selector.

Programs are executed with `RUN`, `RUN line` (begin at a specific line) or `RUN file$` (chain to another program). A program halted by Control+C or `STOP` can be restarted at the next instruction with `CONT`, provided the listing has not been edited in the meantime.

## Direct mode and program entry

STOS Basic distinguishes **direct** commands (which tell the editor to do something, such as `LIST` or `FLOAD`) from **interpreted** instructions (which run as part of a program, such as `IF` or `GOSUB`). The first few characters of the line decide which mode you are in: if the line begins with a line number, you are in interpreted mode and most direct commands will error. `AUTO` generates line numbers automatically so long listings can be typed without re-entering them; press Return on a blank line to exit. `AUTO start` and `AUTO start,inc` pick the first line number and the increment.

```text
auto
10 print "Test of AUTO"
20 goto 10
30
```

## Tidying and searching listings

- `RENUM` renumbers the program and rewrites every `GOTO`/`GOSUB` destination to match. The four forms — `RENUM`, `RENUM number`, `RENUM number,inc`, `RENUM number,inc,start-end` — let you renumber the whole program or a range; existing lines will not be overwritten.
- `LIST`, `LIST first-`, `LIST -last`, `LIST first-last` list part or all of the program to the screen followed by the banks in use. Press space to pause, Esc or Control+C to stop.
- `SEARCH "print"` finds every occurrence of a string in the listing; `SEARCH` alone repeats the last search, and an optional range `SEARCH a$,start-end` restricts the scan. Useful for navigating the supplied example programs — load `SPRITE.ACB` and `SEARCH "anim"` to jump straight to the animation code.
- `CHANGE "AX15B" TO "COUNT"` replaces every occurrence of one string with another; the same optional range works as for `SEARCH`.
- `DELETE first-last` removes a range of lines. If neither endpoint exists, nothing happens.
- `MERGE file$` loads a saved program into the current one; lines with the same number overwrite existing lines, making `MERGE` the usual way to pull a library of subroutines into a work in progress.

A useful trick for navigating a big listing is to start each major routine with a `rem` line such as `999 rem Define sprite` and jump back to it with `SEARCH`.

## Debugging with FOLLOW

`FOLLOW` is STOS Basic's trace command. On its own it halts the program after every instruction and prints the current line number; press any key to step. `FOLLOW X,Y` additionally prints the named variables after each step, and `FOLLOW X,Y,first-last` only traces while execution is inside that line range. `FOLLOW OFF` turns the trace off. The display has minimal impact on the editor screen and does not move the text cursor.

## Multiple programs and split windows

Up to four independent programs can coexist in memory, each with its own set of memory banks. The Help menu's program cursor highlights the slot being edited; move it with the up/down arrows and press Help again to switch.

`MULTI n` divides the editor window into `n` panes (n = 2, 3 or 4), one per program:

- `MULTI 2` — top/bottom split (shift+f2)
- `MULTI 3` — top half plus two panes below (shift+f3)
- `MULTI 4` — four quarters (shift+f4)

`FULL` (f11) expands the current window to fill the screen without disturbing the others. Click inside any pane with the left mouse button to activate it.

A single program can also be split across windows: in the Help menu, position the program cursor on program 1 and use the left/right arrow keys to move between the four boxes on the program line. Typing a line number into a box and pressing Return sets a split point; subsequent `MULTI` commands then show different parts of the same listing in each pane — handy for keeping an init routine and a main loop on screen at once.

`GRAB n` copies program segment `n` into the current program, and `GRAB n,first-last` copies just a range. Develop and test subroutines in their own segments, then `GRAB` them together into one executable.

## System commands

- `SYSTEM` — quits to GEM; any unsaved program is lost.
- `RESET` — reinitialises the editor and redraws the screen.
- `DEFAULT` — like `RESET` but usable from a program, so it can return to the editor at the end of a listing. Pressing Undo twice has the same effect.
- `NEW` — erases the current program only; other program segments are untouched.
- `UNNEW` — recovers a program after an accidental `NEW`, provided no Basic lines have been typed since.
- `CLEAR` — wipes all variables and memory banks and repositions the READ pointer at the first `DATA` statement.
- `FREE` — returns the bytes free and forces a garbage collection on the string pool. Garbage collection can take seconds or minutes for large string arrays, so calling `FREE` at a quiet moment avoids a stall later. Equivalent to `FRE(0)` in other Basics.
- `ENGLISH` / `FRANCAIS` — choose the language for system messages.
- `FREQUENCY` — switches the scan rate from 50 to 60 Hz for multisync monitors. Do not use with a normal TV set.
- `UPPER` lists instructions in upper case and variables in lower case; `LOWER` restores the default.

## String manipulation

String variables carry the `$` suffix and may hold up to 65500 characters. As well as concatenating strings with `+`, STOS Basic lets you subtract: the right-hand string is removed everywhere it occurs in the left-hand one. So `"STOS BASIC" - "S"` produces `TO BAIC`, and `"A string of characters" - " "` strips out every space.

Comparisons between two strings are made character by character using ASCII codes, so `"HELLO" < "hello"` (uppercase precedes lowercase) and `"AA" < "BB"`.

### Substring functions

`LEFT$`, `RIGHT$` and `MID$` each exist as both a function and an instruction. As functions they return part of a string: `left$("STOS Basic",4)` returns `STOS`, `right$("STOS Basic",5)` returns `Basic`, `mid$("STOS Basic",6)` returns everything from position 6 onwards (`Basic`), and `mid$("STOS Basic",6,3)` returns `Bas`. As instructions, the same names replace part of a string variable in place; if the replacement is longer than the slot, it is truncated.

```stos
10 a$="**** Basic"
20 left$(a$,4)="STOS"
30 print a$
```

### INSTR

`INSTR(d$,s$)` returns the position of the first occurrence of `s$` inside `d$`, or zero if it is not found. `INSTR(d$,s$,p)` starts the search at position `p`. INSTR is the standard tool for splitting a sentence into words — loop calling INSTR for the space character and slice each word out with `MID$`:

```stos
10 input "Type a sentence";p$
20 p=1:i=0
30 repeat
40 p1=instr(p$," ",p)
50 if p1<>0 then l=p1-p else l=len(p$)-p+1
60 print "Word";i;" = ";mid$(p$,p,l):p=p1+1:inc i
70 until p1=0
```

### SORT and MATCH

`SORT a$(0)` sorts every element of an array into ascending order. The array may hold strings, integers or floating-point numbers, and the argument is always element zero — the first item in the table.

```stos
10 dim a(25)
20 p=0
30 repeat
40 input "Input a number (0 to stop)";a(p)
50 inc p
60 until a(p-1)=0 or p>25
70 sort a(0)
80 for i=0 to p-1
90 print a(i)
100 next i
```

`MATCH(t(0),s)` performs a binary search on a sorted array and returns the index where `s` was found, or a negative number whose absolute value is the index of the first item greater than `s`. `MATCH` therefore requires a prior `SORT`. The manual demonstrates this by sorting a list of science-fiction authors and looking one up by name; combined with `INSTR`, the same technique makes a simple parser suitable for an adventure game.

> [!NOTE] Unverified: the MATCH example in the source (pages 50-51) is split across two pages with several OCR artefacts in the `data` statements and print strings (`MfountT`, `PO$`, `lO^adams`). The full listing is not reproduced here; the underlying demonstration — sort an array, then call `MATCH` to look up a name — is unambiguous from the surrounding prose.
