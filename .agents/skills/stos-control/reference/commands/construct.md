# Control commands: Construct

The switch construct replaces chains of `IF select=n THEN GOSUB ...` (or `ON ... GOSUB`) when the value being tested does not hold consecutive values. `SWITCH ON` stores the value in an internal store; `CASE` and `OTHERWISE` are functions that compare against it. Integers only. Source: CONTREG.DOC (V3.6b); CONTROL35.DOC (V3.5a) is identical for all of these commands.

## CTRL
`ctrl` — show the extension's command list.

Prints a list of the Control extension's commands. Intended as a quick reference from the editor.

### Gotchas
- Does nothing in compiled programs.

**See also:** SWITCH ON

## SWITCH ON
`Switch on (INTEGER)` — store an integer value for testing by CASE/OTHERWISE.

- **INTEGER**: the value (or variable) to test.

Stores the value of INTEGER in an internal store for accessing by the CASE and OTHERWISE commands. Typical use is to store the result of a zone click in a variable (e.g. `select`) and then dispatch on it.

### Example
```stos
90 select=zone(0)
100 switch on(select)
110 if case(1) then gosub 1200 : rem do loading
120 if case(3) then gosub 4000 : rem do saving
130 if case(4) then gosub 500 : rem ...
140 if case(7) then gosub 6000 : rem do something else
150 if otherwise then gosub 2000 : rem we didn't select 1,3,4 or 7
160 switch off
```

### Gotchas
- Integers only — you cannot switch on strings or floats.
- Case structures can be nested up to a depth of 3.
- The advantage over `ON variable GOSUB` is that the tested value does not have to hold consecutive values.

**See also:** CASE, OTHERWISE, SWITCH OFF

## CASE
`Case(INTEGER)` — true if INTEGER equals the value stored by the preceding SWITCH ON.

- **INTEGER**: the value to compare against the stored switch value.

Returns true if INTEGER is the same as the value of the preceding SWITCH ON, otherwise returns false. Used inside an IF, as in the SWITCH ON example above.

**See also:** SWITCH ON, OTHERWISE, SWITCH OFF

## SWITCH OFF
`Switch off` — end the current switch construct.

Terminates the innermost active SWITCH ON block. See the SWITCH ON example above.

**See also:** SWITCH ON, CASE, OTHERWISE

## OTHERWISE
`otherwise` — true if none of the preceding CASE tests were true.

Returns true if none of the preceding CASE statements in the current switch construct were true, otherwise returns false. The equivalent of the `flag=false` fallthrough test in the ON...GOSUB style the construct replaces.

**See also:** SWITCH ON, CASE, SWITCH OFF
