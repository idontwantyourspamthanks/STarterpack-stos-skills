# The MAKER utility (Maker.bas V2.5)

MAKER builds the **image banks** and **font banks** used by the Control
extension's `IMAGE PUT`, `FONT`, `QUICK SCREEN$` and mapping commands. All
images are **pre-shifted** (like Missing Link bobs): fast to draw, but large
in memory. On a 512K machine, remove unnecessary accessories/programs first.

## Main menu options

- **Make sprites into image bank** — load a sprite `.mbk`, convert it to an
  image bank.
- **Grab images from picture** — load a picture file and pick images off it.
- **Make an alphanumeric fontbank** — pick letters and numbers from a picture.
- **Make a letters only fontbank** — pick letters only.
- **Make Bob's into images** — converts a Missing Link bob `.mbk` (requires
  the Missing Link extension to be installed).

Image width and height are adjusted with the on-screen arrows. Supported
picture formats: `.pi1`, `.neo`, `.ca1` (Crack Art) and `.mbk` (compressed
screen banks); with Missing Link installed, `.pc1` works too.

## Image copies (placement accuracy)

The *number of image copies* is the horizontal placement accuracy: 16 = place
images every pixel, 8 = every 2 pixels, 4 = every 4 pixels, and so on. More
copies = more pre-shifted versions stored = more memory.

## Grabbing from a picture

For any option other than sprite/bob conversion, the loaded picture is shown
with a grab box. All images in one bank must be the same size, and images can
only be grabbed on **word boundaries**. Movement is normally locked to
vertical steps of the image height (Y-Lock), toggleable from the main screen
or the keyboard.

### Keyboard shortcuts

| Key | Action |
|-----|--------|
| `1`/`2` | scroll 1 pixel left / right |
| `3`/`4` | scroll 1 pixel down / up |
| `F` | load new picture file |
| `X` | increase grab width by 16 |
| `Y` | increase grab height by 16 |
| `L` | toggle Y-Lock |
| `N` | grab image, move to next (left) |
| `Q` | abort, back to main screen |
| `Backspace` | go back one image |
| `Space` | finish (in "Grab images from picture" mode) |

Example `.mbk` practice banks ship in the extension's fonts directory.

> Source: MAKER.DOC V2.5 (L.J. Greenhalgh). For the tile maps used by
> `IMAGE MAP`/`MAP WRITE`, see the STOS Mapper tool (MAPPER.DOC in
> `extensions/control/`).
