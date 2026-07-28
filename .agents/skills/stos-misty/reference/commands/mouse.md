# Misty commands: Mouse

## MOUSEOFF
`MOUSEOFF` — COMPLETELY disable mouse reporting.

A very useful command for demo-coders. The `hide on` command merely hides the pointer, but if you waggle the mouse around it will still use up to 30% processor time to move a non-existent pointer! With MOUSEOFF, if your screen/game is just at the bottom of a vbl, you don't need to worry about someone waggling the mouse around and making it go all flickery.

### Example
```stos
10 showon
20 print "Move the mouse, then press space"
30 repeat : until inkey$=" "
40 mouseoff
50 print "Move the mouse again, then press space"
60 repeat : until inkey$=" "
70 mouseon
```

**See also:** MOUSEON

## MOUSEON
`MOUSEON` — Enables mouse reporting after a call to MOUSEOFF.

### Example
See MOUSEOFF.

**See also:** MOUSEOFF
