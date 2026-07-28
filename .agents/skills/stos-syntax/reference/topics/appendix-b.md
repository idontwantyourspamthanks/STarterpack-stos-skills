# Appendix B: Creating a runtime disc

A "runtime disc" boots and runs a STOS Basic program straight from the GEM desktop, without first loading the STOS Basic editor. This appendix walks through making one, protecting it for commercial release, dressing it up with a title screen, and chaining several Basic programs together into an integrated suite.

## Formatting and copying the system files

1. Format a blank disc, then load STOS Basic.
2. Load the `STOSCOPY.ACB` accessory and run it from the `<HELP>` menu:
   ```text
   accload "STOSCOPY.ACB"
   ```
   Press the `HELP` key and select the STOSCOPY accessory with the appropriate function key. STOSCOPY then copies the required files from your STOS Basic master disc onto the newly formatted disc.
3. Load your Basic program and save it out as a `.PRG` file:
   ```text
   save "myprog.prg"
   ```
   The filename may be any eight-character string, but the `.prg` extension is mandatory. STOS will prompt you to insert a disc containing the `STOS` folder — this is the disc you have just prepared with STOSCOPY.
4. STOS now writes your program in a special format that turns it into a proper GEM-executable `.PRG` file.

## Auto-booting

If you want the program to load the moment the ST is switched on, create a folder called `AUTO` on the runtime disc and copy your `.PRG` file into it. Thereafter, whenever the disc is in drive A at power-on, the program will load and run automatically.

## Commercial release

A runtime file still contains a complete copy of STOS Basic, so a program intended for commercial release must be protected first — otherwise you are giving a working copy of STOS Basic away with every sale. The `PROTECT.BAS` program on the STOS Basic disc saves out a special version of Basic with the editor commands removed, so other ST owners cannot alter your program or wipe it with `NEW`.

Three rules apply to any STOS program destined for commercial release:

- All programs must be protected using `PROTECT.BAS`.
- The program must state that it was written in STOS Basic. A ready-made sprite using the STOS logo lives in `SPRDEMO.MBK`, a STOS icon logo is in `ICONS.MBK`, and the picture files inside the `STOS` folder may also be used.
- The program must be entirely your own work, and must not be copied in whole or part from the Basic files on the Accessories or Games discs. No royalty is payable to Mandarin Software, so you are free to do as you wish with anything you write.

## Adding a title screen

When a runtime file boots, it searches the `STOS` folder for a Degas picture file named `pic.pi1` or `pic.pi3`. If it finds one, it spins the picture onto the screen in the same way STOS Basic displays its own title page — giving your program a professional look and something to display while the system files load.

## Chaining programs

Once the runtime copy of your program has loaded, it can load and execute any other Basic program with `run`:
```text
run "demo.bas"
```
The named file is loaded into memory and run. This lets a small loader pull in further programs on demand. The following line fades the screen down, switches to mode 0, and then loads the sprite editor:
```stos
10 fade 3: wait 21: mode 0 : run "sprite.bas"
```
The chained file (here `sprite.bas`) must be saved onto the same disc as a `.bas` file. Using this technique you can build integrated suites of programs that call one another.

## Sending programs to Mandarin

Mandarin Software are always looking for new and original programs. If you develop a top-quality product — or have any interesting ideas — they will be pleased to hear from you. Send your disc with a stamped addressed envelope to:

```text
The Software Manager
Mandarin Software
Europa House
Adlington Park
Adlington
Macclesfield SK10 4NP
```
