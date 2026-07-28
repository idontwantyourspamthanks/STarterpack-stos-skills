# STOS commands: appendix-d

## CALL
`CALL address` — Calls a machine-code program.

- **address**: either the absolute location of your code or the number of one of STOS Basic's 16 memory banks.

CALL allows you to execute any assembly language program held in the ST's memory. The manual describes a four-step procedure for calling a machine-code program: (1) reserve some memory for your routine using RESERVE AS DATA (this only needs to be done once, as DATA banks are always saved along with your Basic program; alternatively you can place your code in a previously defined string variable, provided it is completely relocatable); (2) load the program, which must be in TOS relocatable format; (3) pass any input parameters using the pseudo variables DREG(0)-DREG(7) and AREG(0)-AREG(7); (4) call your program.

### Example
Step 1 — reserve 10,000 bytes in bank 7 for your routine:
```stos
10 RESERVE AS DATA 7,10000
```
Step 2 — load the program using a line like:
```text
load "file.prg",7
```
Step 4 — call your program using a line like:
```stos
10 call 7
```

### Gotchas
- The program must be in TOS relocatable format in order to be usable from STOS.
- The extension used for the file should always be PRG; any other extension will generate an error message.
- Never try to call a Gem program from STOS Basic or the system will crash completely!
- Your assembly language program may change any 68000 registers it likes with the sole exception of A7, and must always be terminated with an RTS instruction.
- It must never call the Gemdos traps SET BLOCK, MALLOC, MFREE, KEEP PROCESS or any other memory management function.

## AREG
`AREG(r)` — Variable used to pass information to the 68000's address registers.

- **r**: may range from 0-7 and indicates the number of the address register which is stored in the variable.

AREG is an array of eight PSEUDO variables which are used to hold a copy of the 68000's eight address registers. This enables you to pass information to and from a machine code function executed by either the CALL or the TRAP instructions. Whenever the CALL or the TRAP commands are executed, the contents of this array are loaded automatically into address registers A0-A7. At the end of the function call they are loaded back with any new information which has been placed in these registers.

**See also:** DREG, TRAP, CALL

## DREG
`DREG(r)` — Variable used to pass information to the 68000's data registers.

- **r**: refers to the register number and can range from 0-7 for registers D0-D7.

This is an array of eight elements which hold a copy of the contents of the 68000 data registers. The number r refers to the register number and can range from 0-7 for registers D0-D7. See TRAP for an example of this function in action.

**See also:** TRAP

## TRAP
`TRAP n [,parameters]` — Calls a 68000 trap function.

- **n**: the number of the TRAP; may range from 0 to 15. Not all of the 16 possible TRAPs have been currently installed into the STOS system. The available numbers are 0,1,13,14 (the Gemdos functions) and 3,5,6,7 (the STOS functions).
- **parameters**: optional data which is to be placed on the 68000's stack before the TRAP function is executed. As a default these are assumed to be of size WORD.

TRAP allows you to call one of the numerous 68000 TRAP functions. These traps are really just large libraries of assembly language functions which are available from a single machine-code instruction. You can utilise the TRAP command to give you complete control over the inner workings of your STOS Basic programs. A list of the various Gemdos functions can be found in any good book of machine-code programming on the ST.

You can set the parameter size directly from the TRAP instruction using a statement such as `W,expression` (sets the size to WORD) or `L,expression` (sets the size to LONG WORD). expression can be any list of WORDS or LONG WORDS which need to be loaded onto the stack when the function is called. You can also include a string variable in the expression, such as A$; in this case only the ADDRESS of the string is placed on the stack, and a chr$(0) is automatically added to the end of the variable to convert it into the correct format. Another way of passing information to the TRAP is using the PSEUDO registers AREG and DREG.

### Example
```stos
10 trap 14,33,4:rem Set printer type to EPSON
```
```stos
10 dreg(0)=44:dreg(1)=100:dreg(2)=100: trap 5:rem Move mouse to 100,100
```

### Gotchas
- You are effectively programming in machine code; if you play around with the TRAP instruction indiscriminately, you will almost certainly CRASH the ST.

**See also:** AREG, DREG, CALL

