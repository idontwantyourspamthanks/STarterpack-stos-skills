# Writing a game

There are no fixed rules for writing a game, but this chapter walks through the workflow the STOS authors recommend: plan first, program in a structured way, add graphics, then optimise. The advice is illustrated with examples drawn from the three supplied games — Orbit, Zoltar and Bullet Train.

## Planning

The most important stage is the initial specification. Decide what the game should do and lay out every detail before writing any code. A game that is planned up front takes much less time to write.

### Finding and shaping the idea

The initial idea may come quickly, but the interesting features take longer. A thesaurus is a useful tool for both naming and expanding a concept. The authors named *Orbit* by starting from the word *ball* and working outwards until they found something apt and original. For a game called *Haunted House* you might look up *ghost* or *ghoul* and gather related ideas from section to section.

### Modularising

Once the ideas are on paper, split the game into **modules** — independent areas that do not rely on other sections to work. *Orbit* is the worked example: the bouncing ball is one module, the player's bat another, the bricks a third. Each module can be designed and tested on its own.

### Screen designs

Lay screens out accurately and with STOS Basic's commands in mind. A badly designed screen causes programming problems later and usually has to be re-vamped, wasting time.

## Programming

Programming takes the largest share of development time. The emphasis for games is **speed** — a beautifully animated game is no use if it responds too slowly.

The key word is **structure**. A structured program should be:

- **Readable** — easy logic to follow.
- **Reliable** — does what was intended.
- **Adaptable** — open to later modification.

### Subroutines as building blocks

Write each module from the planning stage as a subroutine, and split modules further into sections. Pass data into subroutines through **variables rather than constants** so they can be reused. This short example draws an equilateral triangle from the variables `X1`, `Y1` and `TRISIZE`:

```stos
10 X1=50:Y1=50:TRISIZE=20:gosub 50
30 end
49 rem * Draw a triangle at X1,Y1 with sides TRISIZE long *
50 plot x1,y1
60 draw to x1+TRISIZE,Y1+TRISIZE
70 draw to x1-TRISIZE,Y1+TRISIZE
80 draw to x1,y1
90 return
```

> [!NOTE] Unverified: lines 50 and 80 are reconstructed from OCR. The source reads `plot x1vy1` and `draw to x1ry1`, which are not valid STOS; the comma form `plot x1,y1` / `draw to x1,y1` fits both the triangle's geometry (closing back to the top vertex) and the syntax of [`plot`](../commands/graphics.md) and `draw to`.

Calling the same subroutine with different variables produces a triangle in a new place at a new size:

```stos
20 X1=10:Y1=100:TRISIZE=80:gosub 50
```

The comment at line 49 documents what the routine does and which variables it needs, which aids readability and adaptability. Because line 50 (not 49) is the target of the `gosub`, the comment can be deleted if memory runs short.

### Layout and testing

Keep related commands grouped on a single line, but be careful with multiple-statement lines — they are sometimes hard to read and may need splitting. Test each module by feeding it **dummy data** and examining the results; small modules test easily, larger ones need more attention. "It's the quality not the quantity that makes a good game."

### The three-section structure

Most programs fall into three sections:

1. **Initialisation** — set up defaults: screen colours, variables, arrays.
2. **Main loop** — a list of [`gosub`](../commands/other-commands.md) instructions that call each module of the game, then restart the loop.
3. **Quit** — reset the screen and return control to the user. Most games never stop, so this section is often omitted.

## Adding graphics

Graphics are what transform a simple idea into a professional product. If your own artwork is weak, get help from someone who can draw. STOS graphics fall into three groups:

- **Pictures** — files saved from [Neochrome](https://en.wikipedia.org/wiki/NeoChroma) or Degas can be loaded straight in. Both packages are widely used and well-designed.
- **Geometry** — a mathematical form of graphics using STOS's drawing commands on a coordinate system; no artistic talent required.
- **Sprites** — the most important for animation. The size and number of sprites are critical decisions when designing a game.

## Techniques

### Speedy sprites

STOS sprites are **software sprites** — the computer does all the work of calculating positions and drawing them. Small sprites move faster than large ones, so consider:

- **Number** — a couple of sprites can be large; if you use all 15 they must be small. For many sprites, use the copy techniques from Chapter 4.
- **Size** — bigger sprites move slower. Missiles in a game, for example, should be small narrow sprites that take little of the computer's time.

### Scrolling the screen

Horizontal scrolling is expensive because of the number of calculations involved. The fastest way to scroll left or right is on **16-bit (word) boundaries, in steps of 16 pixels**. The larger the area being scrolled, the slower the scroll. See [`scroll`](../commands/screen.md).

### Collisions

In a fast-moving game, collisions must be checked **as often as possible**. Checking only once a second in a shoot-'em-up lets missiles fly past aliens without hitting them. The [`set zone`](../commands/sprites.md) command lets you define regions of the screen and ask which zones your sprites are currently in — a powerful shortcut that saves a lot of manual collision work.

## Learning from the supplied games

If you are unsure how best to link commands together, read through the three game listings supplied with STOS. All three were written by the author of STOS Basic, so they are prime examples of well-written code. Use [`search`](../commands/editor.md) to find examples of particular commands, and pick up shortcuts and techniques by examining the listings.

## Optimising your programs

When the program is nearly finished you can trade a little readability for memory and speed.

**Combine related lines.** A simple loop:

```stos
10 for A=1 to 10
20 print A
30 next A
```

can be collapsed to a single line. This saves the memory of lines 20-30 and speeds up the loop because the commands are grouped:

```stos
10 for A=1 to 10:print A:next A
```

**Use STOS's faster instructions.** The standard increment:

```stos
10 A=A+1
```

is quicker and smaller as:

```stos
10 inc A
```

[`inc`](../commands/editor.md) replaces the `A=A+1` expression with a single 68000 instruction.
