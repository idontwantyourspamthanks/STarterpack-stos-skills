# STE extension commands: System

Every command in this extension requires STE hardware. Use STE to test for the machine type so your program can offer STE owners the extra features while remaining compatible with all STs.

## STE
`x = STE` — Returns 1 if the machine is an STE or 0 if it isn't.

You can test to see if it's an STE or not and adjust your game to suit, giving STE owners the extra features but still making the program compatible with all STs.

### Gotchas
- The official doc writes this function without parentheses (`x = STE`), unlike the extension's other functions such as `x= LSTICK (j)`.
