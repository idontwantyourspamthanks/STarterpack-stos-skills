# STOS commands: editor

## KEYLIST
`KEYLIST` — List the current function key assignments.

KEYLIST prints out a full list of the strings associated with each of the function keys. The shifted versions of these keys are given numbers from 11-20. Stop listing using either the spacebar, Esc, or Control+C.

### Example
```text
f1: KEY LIST'          Last line entered into the system.
f2: list               Lists all or part of a program.
f3: listbank'          Lists banks used by the program.
f4: fload"*.bas"'      Load a Basic program with the file selector.
f5: fsave"*.bas"'      Saves a file using the file selector.
f6: run'               Runs the Basic program.
f7: dir'               Prints out directory of the current disc
f8: dir$=dir$+"\"      Selects a subdirectory. See Chapter 10.
f9: previous           Selects next outer directory.
f10:off'               Turns off sprites.
f11:full'              Sets the editor window to the full screen.
f12:multi 2'           Installs two editor windows.
f13:multi 3'           Installs three editor windows.
f14:multi 4'           Installs four editor windows.
f15:mode 0'            Enter low resolution mode.
f16:mode 1'            Enter medium resolution mode.
f17:accnew:accload "*"' Deletes the current accessories and loads a new set off the disc.
f18:default'           Re-initialise editor screen.
f19:env'               Change colours used by editor.
f20:key list'          List function keys.
```

### Gotchas
- The ' character is used in these assignments to denote Return.
- The f1 key always holds a copy of your last editor command, so its string continually changes.

## FLOAD
`FLOAD path$` — Load a file using the file selector.

- **path$**: a string containing the search path. (See DIR)

FLOAD chooses a file to load using a special file selector. A dialogue box is displayed; you can choose a file by clicking on a filename or typing a name into the choice box, then load it by double clicking on the file, clicking on the Return box, or pressing Return. Unlike the Gem file selector there is no scroll bar: you page through the directory by clicking on the Up and Down buttons, and the Dir button gives a directory listing of the current disc at any time (useful after changing discs). A * at the front of an item denotes a folder, entered by clicking on its name; the Previous button exits back to the outer directory.

### Example
```text
fload "*.bas"
```
Choose a Basic file to load. Assigned to f4.

**See also:** LOAD, DIR

## FSAVE
`FSAVE path$` — Save a Basic file chosen with the file selector.

- **path$**: denotes the type of program you wish to save.

FSAVE allows you to save a program chosen from a file selector box. You are presented with the standard file selector; enter the name of your new file (the filename is displayed in the current file box and can be edited in the normal way), then press Return to save the file to disc.

### Example
```text
new
10 print "Executing Line 10"
20 print "Executing Line 20"
30 print "Executing Line 30"
```
Now enter the line:
```text
fsave "*.bas"
```
or press function key f5.

## RUN
`RUN` — Execute the current STOS Basic program.

There are three versions of this instruction:

- `RUN` — Run the program starting from the first line.
- `RUN no` — Run the program starting from line number *no*.
- `RUN file$` — Load and run the Basic program stored in *file$*.

You can also use the RUN command from inside a program. This allows you to chain a number of programs together. Any program executed in this way can be terminated using Control+C, and restarted with the CONT command.

### Example
Assuming you saved the example file from FSAVE under the filename TEST.BAS, load the file with:
```text
load "TEST.BAS"
run
Executing Line 10
Executing Line 20
Executing Line 30

Ok

run 20
Executing Line 20
Executing Line 30

new
run "TEST.BAS"
Executing Line 10
Executing Line 20
Executing Line 30
```
Chaining programs from inside a program:
```text
new
10 print "Executing Test"
20 run "TEST.BAS"
30 print "This line is never executed"
```

### Gotchas
- Replace mode is re-entered whenever the system is reset by the RUN command.

**See also:** CONT

## CONT
`CONT` — Restart a program exited by STOP or Control+C.

CONT re-enters an interrupted program starting from the next instruction. In order for the program to be continued, it must not have been changed in the interval between executing the STOP and the CONT.

### Example
```text
new
10 for i=1 to 100000
20 print i;
30 next i

run
Control+C        Interrupt the program after a few seconds.
cont             Restart program in the middle of the FOR...NEXT loop.
```

### Gotchas
- The program must not have been changed between the STOP (or Control+C) and the CONT, otherwise it cannot be continued.

## AUTO
`AUTO` — Automatic line numbering.

The AUTO command is a direct instruction which automatically prints out a new line number every time you press Return. This enables you to enter long Basic programs without having to continually type in the line numbers. As a default, AUTO starts off at line 10 and increments the line in units of 10. Pressing Return on an otherwise empty line exits from AUTO; typing AUTO again resumes numbering from the point you left off.

Other possible formats:

- `AUTO start` — Starts automatic line numbering from line number *start*.
- `AUTO start,inc` — Starts from line *start* and increments each successive line by the number *inc*.

### Example
```text
auto
10 print "Test of AUTO"
20 goto 10
30 <Return>
run
```
(The manual underlines text typed in by the user; the Return in line 30 was used to exit from this AUTO statement.)
```text
auto
30 print "This line is never reached"
40 <Return>
```
```text
auto 50
50 print "Test of AUTO"
60

auto 10,1
10 rem First line
11 rem Second line
12
```

### Gotchas
- AUTO places you in interpret mode: any direct mode instructions (including all the normal screen editing operations) will cause an error. If you discover a mistake in a line you have just entered, you must exit back to the editor in order to correct it.

## RENUM
`RENUM` — Renumber all or part of a program.

The RENUM command tidies up a program by neatly renumbering any or all of its lines. The destinations of any GOSUBs or GOTO instructions in the program are automatically amended to take the new line numbers into account. There are four different ways of using this command:

- `RENUM` — Starts by setting the first line in your program to 10, and then renumbers each succeeding line in units of 10.
- `RENUM number` — Sets the first program line to *number*, and renumbers all the other lines in increments of 10.
- `RENUM number,inc` — Starts at line *number* and increments each successive line by *inc*.
- `RENUM number, inc, start-end` — Renumbers lines from *start* to *end*, beginning with line *number*, and incrementing each proceeding line by *inc*.

### Example
```text
new
10 print "Example of renumber"
20 goto 50
30 gosub 70
40 stop
50 print " Destination of goto"
60 goto 30
70 print " Destination of gosub"
80 return

renum
list
```

### Gotchas
- STOS Basic will not allow RENUM to overwrite any existing parts of the current program.

## LIST
`LIST` — List the lines of a Basic program to the screen.

The LIST command is used to list part or all of the current program to the ST's screen. The format of the instruction is:

- `LIST` — Lists the entire program.
- `LIST first-` — Lists all the lines in the program starting from the line *first*.
- `LIST -last` — Lists the lines from the start of the program to line *last*.
- `LIST first-last` — Lists lines from *first* to *last*.

### Gotchas
- You can temporarily halt the listing at any time by pressing the spacebar, and stop it completely using either Esc or Control+C.
- At the end of the listing, a list of the banks used by the Basic program is appended.

**See also:** LLIST

## SEARCH
`SEARCH s$` — Searches for a string in a Basic program.

- **s$**: the search string; this can include any STOS Basic instructions.

SEARCH allows you to find the position of a string contained within a Basic program. In order to find the next occurrence of the string, you simply type the SEARCH command on its own. You can also restrict your search to a specific part of the program by adding an optional starting and ending point:

`SEARCH a$,start-end`

- **start**: the line at which the search should begin.
- **end**: the line at which it should finish.

### Example
```text
load "CONFIG.BAS"
search "print"
3100 paper 1:pen 0:windopen 1,20,6,40,6,10:curs off:print:centre "Please insert a disc including":print:centre"the stos folder.":print
```
In order to find the next occurrence of the string, you simply type the SEARCH command on its own:
```text
search
```
Searching the example programs supplied on the STOS Basic disc:
```text
load "SPRITE.ACB"
search "anim"
7050 M=0 : gosub 10700 : anim off : sprite off : update : gosub 7325 : loke start(1)+4,$12 : erase 8 : update off
```
Another trick is to start any important sections of your program with a line like:
```stos
999 rem Define sprite
```
This allows you to find the exact position of your routine at any time without having to list through the entire program.

## CHANGE
`CHANGE a$ TO b$ [,start-end]` — Change all occurrences of a string in a program.

- **a$**: the string to be replaced.
- **b$**: the replacement string.
- **start-end**: optional start and end points defining the section of the program which should be changed.

The CHANGE command searches through a program and replaces any occurrences of the first string with the second.

### Example
```stos
10 AX15B=1
20 for I=1 to 10
30 AX15B=AX15B+AX15B
40 print "The value of variable AX15B is ";AX15B
50 next i
```
Since we've used a rather horrible variable name in this program, we can now change all occurrences of AX15B into COUNT using the line:
```text
change "AX15B" to "COUNT"
```
Listing the program now gives:
```stos
10 COUNT=1
20 for I=1 to 10
30 COUNT=COUNT+COUNT
40 print "The value of variable COUNT is ";COUNT
50 next I
```

**See also:** SEARCH

## DELETE
`DELETE first-last` — Delete some or all lines of a program.

- **first**: first line of the section to erase.
- **last**: last line of the section to erase.

The DELETE command is used to selectively erase sections of your Basic programs. If lines *first* and *last* do not exist then this delete operation is not performed.

### Example
```text
new
10 rem Line 10
20 rem Line 20
30 rem Line 30
40 rem Line 40

delete 20-30
list
10 rem Line 10
40 rem Line 40
```
Typing a line like:
```text
delete 11-31
```
has no effect.

## MERGE
`MERGE file$` — Merge a file into the current program.

- **file$**: the file holding the program to be merged.

The MERGE command combines a program stored in the file *file$* with the current program. Existing lines will be overwritten by any new lines with the same number. This instruction is often used to merge a set of subroutines into one complete program.

## FOLLOW
`FOLLOW` — Track through a STOS Basic program.

Many Basics include a special TRACE command which steps through a program one instruction at a time. The STOS Basic version is more powerful as it also allows you to track the contents of a list of variables. There are five possible formats:

- `FOLLOW` — Used on its own, the program will halt after every instruction and list the number of the current line. The next line in the program can be stepped through by pressing any key.
- `FOLLOW first-last` — Only follows the program when the lines between *first* and *last* are being executed.
- `FOLLOW variable list` — Takes a list of variables separated by commas and prints them out after every instruction has executed. As before, you can step through the program by pressing any key.
- `FOLLOW variable list, first-last` — Identical to the instruction above, but the variables are only followed when the lines between *first* and *last* are being interpreted.
- `FOLLOW OFF` — Turns off the action of the FOLLOW command.

### Example
```text
new
10 for X=0 to 10
20 for Y=0 to 10
30 next Y
40 next X
follow X,Y
run
```
Page through the program by pressing any key. To abort the program simply press Control+C.

### Gotchas
- The FOLLOW instruction has a minimal effect on the current screen, and does not change the position of the text cursor.

## MULTI
`MULTI n` — Display a number of programs simultaneously.

- **n**: the number of editor window segments; can only take values between 2-4.

The MULTI command simplifies the process of using multiple programs by dividing the editor window into separate segments, one per program. These programs can be entered with the Help key as before. MULTI can also be used to split a single program into a number of separate sections (set the end points with the Help menu, using the left and right arrow keys to move between the four boxes on the program line).

### Example
```text
MULTI 2            Splits the editor window in two.
                   Top section = Window 1 = Program 1
                   Bottom section = Window 2 = Program 2
                   This instruction is assigned to Shift+f2

MULTI 3            Splits the editor into three sections.
                   Top section = Window 1 = Program 1
                   Bottom left section = Window 2 = Program 3
                   Bottom right section = Window 3 = Program 4
                   MULTI 3 is assigned to Shift+f3

MULTI 4            Divides the editor into four quarters. Each window has its own
                   program. Also assigned to Shift+f4
```
As a further example, select segment number 1 with Help and type in:
```text
load "CONFIG.BAS"
list
```
Now type:
```text
multi 2
```
which splits the window into two and redraws the listing. You can continue this experiment by typing `multi 3` and `multi 4`.

### Gotchas
- *n* can only take values between 2-4.

## FULL
`FULL` — Expand current window into the full screen area.

In expanding the current edit window, Full does not effect the status of any of the other programs.

## GRAB
`GRAB n` — Copy all or part of a program segment into the current program.

- **n**: the program number to copy from; ranges from 1 to 4.
- **first-last**: optional line range restricting which lines are copied.

The GRAB command allows you to combine a number of subroutines stored in separate program segments into one complete program. This enables you to test each subroutine in your program independently. The second format is:

`GRAB n, first-last` — Only copies the lines between *first* and *last* into the current program.

### Gotchas
- Any attempt to use the number of the current program in this instruction will naturally generate an error message.

**See also:** MERGE

## SYSTEM
`SYSTEM` — Exit back to Gem.

The SYSTEM instruction is used to quit from STOS Basic.

### Gotchas
- Any programs loaded in STOS Basic which have not been saved to disc will be LOST! You should therefore think carefully before confirming this option with Y.

## RESET
`RESET` — Reset the editor.

RESET simply reinitialises the editor and redraws the current screen.

## DEFAULT
`DEFAULT` — Reset the editor and redraw current windows.

DEFAULT redraws any currently defined windows on the screen, and resets the STOS Basic editor. Unlike RESET, DEFAULT can be used either in direct or interpreted mode. This allows it to be utilised at the end of a Basic program to jump back to the editor. The effect of this instruction can also be achieved from the editor by pressing the Undo key twice.

### Gotchas
- Do not confuse this with the DEFAULT function.

## NEW
`NEW` — Erase the current program.

This command deletes the current program from the ST's memory. It has no effect on any other programs stored in different program segments.

**See also:** UNNEW

## UNNEW
`UNNEW` — Recover from a NEW and restore the current program.

UNNEW attempts to recover from the effects of a NEW command, and restore your current program back from the dead. It will only work providing you have not entered any further Basic program lines since the original NEW.

### Example
```text
10 rem This line is dead
new
list
unnew
list
```

### Gotchas
- Only works if you have not entered any further Basic program lines since the original NEW.

**See also:** NEW

## CLEAR
`CLEAR` — Clear all the program variables.

The CLEAR instruction erases all the variables and all the memory banks defined by the current program. It also repositions the READ pointer to the first DATA statement in the program.

## FREE
`FREE` — Return the amount of free memory.

FREE returns the number of bytes of memory which is currently available for use by your Basic program. In addition it reorganises the memory space used to hold your string variables. The technical term for this process is garbage collection. Note that FREE is equivalent to the FRE(0) function found in many other Basics.

### Example
```text
print free
707536
100 print "Thinking":x=free
```

### Gotchas
- The time taken by garbage collection varies exponentially with the number of strings you have defined: from mere milliseconds for small numbers of strings, to several minutes for large string arrays with several thousand elements.
- Garbage collection also occurs automatically while your program is running, which could lead to your program unexpectedly halting for several minutes. The solution is to call FREE and force this reorganisation when it will cause the least amount of harm.

## ENGLISH
`ENGLISH` — Choose the language to be used.

Since STOS Basic originates from France, all system messages are provided in both French and English. ENGLISH uses English for any messages (Default).

**See also:** FRANCAIS

## FRANCAIS
`FRANCAIS` — Choose the language to be used.

Since STOS Basic originates from France, all system messages are provided in both French and English. FRANCAIS uses French for all subsequent dialogue.

**See also:** ENGLISH

## FREQUENCY
`FREQUENCY` — Change scan rate from 50 to 60 Hertz.

This function is only useful if you have a medium resolution monitor capable of scan rates higher than the normal 50 frames per second. If you have a multi-sync monitor, you can use FREQUENCY to improve the quality of the screen display considerably.

### Gotchas
- FREQUENCY also changes the frequency of any interrupts used by STOS Basic to 60 times a second.
- DO NOT USE THIS FUNCTION WITH A NORMAL TV SET.

## UPPER
`UPPER` — Change listing mode to uppercase.

Normally, any instructions you type into a STOS Basic program are listed in lower case, and any variables in upper case. The UPPER directive reverses this format.

### Example
```text
new
10 n=10
20 PRINT "The Value of N is ",n

list
10 N=10
20 print "The Value of N is ",N

upper
list
10 n=10
20 PRINT "The Value of N is ",n
```

**See also:** LOWER

## LOWER
`LOWER` — Change Editor mode to lower case.

LOWER returns the listing format back to the default case. Any variables will now be listed to the screen or printer in upper case, and instructions will be output in lower case.

**See also:** UPPER

## DIM
`DIM` — Dimension an array.

DIM is used to set up a table of variables (an array). These tables may consist of any number of dimensions you like, but each dimension is limited to a maximum of 65535 elements. In order to access an individual element in this array, you simply type the array name followed by the index number enclosed between round brackets ().

### Example
```stos
10 dim A$(10),B(10,10),C#(10,10,10)
```
```text
new
10 dim NAME$(10),AGE(10)
20 for I=0 to 10
30 input "What is your Name";NAME$(I)
40 input "What is your Age";AGE(I)
50 next I
60 print "NAME AGE"
70 print "======================"
80 for I=0 to 10
90 print NAME$(I),AGE(I)
100 next I
```

### Gotchas
- The element numbers of these arrays always start from zero.

**See also:** MATCH, SORT

## INC
`INC var` — Add 1 to an integer variable.

- **var**: an integer variable.

INC adds one to an integer variable using a single 68000 instruction. It is logically equivalent to the expression *var=var+1*, but is much faster.

### Example
```text
new
10 timer=0
20 print "Increment A with A=A+1"
30 for I=1 to 10000
40 A=A+1
50 next I
60 print "Took ";timer/50.0;" Seconds"
70 timer=0
80 print "Increment A with INC instruction"
90 for I=1 to 10000
100 inc A
110 next I
120 print "Took ";timer/50.0;" Seconds";

run
```
It should be apparent that the second version of the FOR...NEXT loop executes considerably faster.

**See also:** DEC

## DEC
`DEC var` — Subtract 1 from an integer variable.

- **var**: an integer variable.

This instruction subtracts one from the integer variable *var*.

### Example
```text
A=2
dec A
print A
1
```

**See also:** INC

## LEFT$
`LEFT$(v$,n)` — Return the leftmost characters of a string.

- **v$**: a string expression (function form) or string variable (instruction form).
- **n**: the number of characters.
- **t$**: the replacement string (instruction form).

There are two distinct forms of this command. The first version of LEFT$ is configured as a function and returns the first *n* characters in the string expression *v$*. There's also a different variant of LEFT$ implemented as an instruction:

`LEFT$(v$,n)=t$` — This instruction sets the leftmost *n* characters in *v$* to *t$*. If *t$* is longer than *n*, it is truncated to the appropriate length. Note that unlike the LEFT$ function *v$* must be a string variable rather than an expression.

### Example
```text
print left$("STOS Basic",4)
STOS
a$=left$("0123456789ABCDEF",10)
print A$
0123456789
```
```stos
10 input "Input a string";V$
20 input "Number of characters";N
30 print left$(V$,N)
40 goto 10
```
Instruction form:
```text
10 A$="** Basic"
20 left$(A$,4)="STOS"
30 print A$
run
STOS Basic
```

**See also:** RIGHT$, MID$

## RIGHT$
`RIGHT$(v$,n)` — Return the rightmost character of a string.

- **v$**: a string expression (function form) or string variable (instruction form).
- **n**: the number of characters.
- **t$**: the replacement string (instruction form).

RIGHT$ is a function which reads *n* characters from the string expression *v$* starting from the right. As with LEFT$ there's also another version of RIGHT$ set up as a Basic instruction:

`RIGHT$(v$,n)=t$` — Set rightmost *n* characters of *v$* to *t$*. Note that *v$* should always be a string variable, and that excess characters in *t$* are omitted.

### Example
```text
print right$("STOS Basic",5)
Basic

A$=right$("0123456789ABCDEF",10)
print A$
6789ABCDEF
```
```text
new
10 input "Input a string";V$
20 input "Number of characters";N
30 print right$(V$,N)
40 goto 10
```
Instruction form:
```text
new
10 A$="STOS **"
20 right$(A$,5)="Basic"
30 print A$

run
STOS Basic
```

**See also:** LEFT$, MID$

## MID$
`MID$(v$,s,n)` — Return a string of characters from within a string expression.

- **v$**: the string expression (function form) or string variable (instruction form).
- **s**: the number of the character at the start of the substring.
- **n**: the number of characters to be fetched; if not specified, the characters are read up to the end of the string *v$*.
- **t$**: the replacement string (instruction form).

The MID$ function returns the middle section of the string *v$. There's also a MID$ instruction:

`MID$(v$,s,n)=t$` — This version of MID$ sets *n* characters in *v$* starting from *s* in the string *t$*. If a value of *n* is not included in this instruction, then the characters are replaced up to the end of *v$*.

### Example
```text
print mid$("STOS Basic",6)
Basic
print mid$("STOS Basic",6,3)
Bas
```
```text
new
10 input "Input a string ";V$
20 input "Starting Position, Number of characters";S,N
30 print mid$(V$,S,N)
40 goto 10
```
Instruction form:
```text
A$="STOS **"
mid$(A$,6)="Magic"
print A$
STOS Magic

mid$(A$,6,3)="Bas"
print A$
STOS Basic
```
```text
new
10 input "Input a target string";V$
20 input "Input a substring";T$
30 input "Starting Position, Number of characters";S,N
40 mid$(V$,S,N)=T$
50 print V$
60 goto 10
```

**See also:** LEFT$, RIGHT$

## INSTR
`INSTR(d$,s$)` / `INSTR(d$,s$,p)` — search for occurrences of one string inside another.

- **d$**: the string to be searched
- **s$**: the substring to find
- **p**: character number in d$ at which to start the search (second form only)

INSTR allows you to search for all occurrences of one string inside another. It is
especially useful for adventure games as it enables you to split a line of text into
its individual words. There are two forms of the INSTR function.

`INSTR(d$,s$)` searches for the first occurrence of s$ in d$. If the string is found,
the position of this substring is returned by the function, otherwise a value of 0 is
returned.

`INSTR(d$,s$,p)` finds the first occurrence of s$ in d$ starting from character
number p.

### Example
Direct-mode examples of the first form:

```text
print instr("STOS Basic","STOS")
1
print instr("STOS Basic","S")
1
print instr("STOS Basic","FAST")
0
```

```text
new
```

```stos
10 input "String to be searched";D$
20 input "String to be found";S$
30 X=instr(D$,S$)
40 if X=0 then print S$;" not found"
50 if X<>0 then print S$;" found at position ";X
60 goto 10
```

Direct-mode example of the second form:

```text
print instr("STOS BASIC","S",2)
4
```

You can change the above program example to this new form of INSTR by typing the
lines:

```stos
25 input "Starting position";P
30 X=instr(D$,S$,P)
```

An example which splits a line of text separated by spaces into its component words:

```stos
10 print "Please type a string of characters" : input P$
20 I=0
30 repeat
40 P1=instr(P$," ",P)
50 if P1<>0 then L=P1-P else L=len(P$)-P+1
60 print "Word number ", I;" = ";mid$(P$,P,L) : P=P+1 : inc I
70 until P1=0
```

### Gotchas
- INSTR returns 0 when the substring is not found.

## SORT
`SORT a$(0)` — sorts all elements in an array.

- **a$(0)**: the starting point of the table to be sorted; must always be set to the
  first item in the array (item zero)

The SORT instruction allows you to sort all the elements in an array into ascending
order amazingly quickly. This array can be composed of either strings, integers, or
floating point numbers.

SORT is often used in conjunction with the MATCH instruction to perform complex
string searches.

### Example
```stos
10 dim A(25)
20 P=0
30 repeat
40 input "Input a number (0 to stop)";A(P)
50 inc P
60 until A(P-1)=0 or P>25
70 sort A(0)
80 for I=0 to P-1
90 print A(I)
100 next I
```

### Gotchas
- The starting point of the sort must always be the first item in the array (item
  zero).

**See also:** MATCH

## MATCH
`MATCH (t(0),s)` — find the closest match to a value in an array.

- **t(0)**: the sorted table to search (referenced by its first item)
- **s**: the value to look for

The MATCH function searches through a sorted table, and returns the item number in
which the value s was found. If s is not found, then MATCH returns a negative number.
The absolute value of this number contains the index of the first item which was
greater than s. Providing the array is of only one dimension, it can be of type
string, integer or real.

The MATCH instruction could be used in conjunction with INSTR to provide a powerful
PARSER routine which could form the basis of an Adventure game.

### Example
```text
new
```

```stos
10 read N
20 dim D$(N)
30 for I=1 to N
40 read D$(I)
50 next I
60 sort D$(0)
70 input A$
80 if A$="I" then for I=1 to N : print D$(I) : next I : goto 70
90 POS=match(D$(0),A$)
100 if POS>0 then print "found",D$(POS);" in record ";POS
110 if POS<0 and abs(POS)<=N then print A$,"not found. Closest to ",D$(abs(POS))
120 if POS<0 and abs(POS)>N then print A$,"not found. Closest to";D$(N)
130 goto 70
140 data 10,"adams","asimov","shaw","heinlien","zelazny","foster","niven"
150 data "harrison","pratchet","dickson"
```

### Gotchas
- Before MATCH can be used the array should always be sorted using the SORT command.
- The array must be of only one dimension.
- A negative return value means s was not found; abs() of it is the index of the
  first item greater than s.

**See also:** SORT, INSTR

