# Missing Link: the MAKE utility (MAKE.DOC distilled)

MAKE v1.0 converts STOS files into Missing Link data formats. It has four drop-down menus: Desk (info/quit), Make (the converters), Load and Save. Load reads STOS sprite banks or map-data; Save writes out the files you create.

## Key concept: images (pre-shifting)

The ST screen is broken into vertical 16-pixel strips, so graphics can only be *drawn* on 16-pixel X boundaries. To draw at any other X position the image must be shifted sideways first. STOS sprites do this shifting in real time (slow, little memory); Missing Link graphics use **pre-shifting**: every shift of the image is prepared in advance (fast, but memory-hungry).

To save memory you choose how many shifted **images** of each sprite are stored — 8, 4, 2 or 1. More images = smoother movement; fewer = less RAM. Rules of thumb from the doc:

- A sprite that never moves horizontally (e.g. a Defender-style ship moving only vertically) needs just 1 image.
- A landscape scrolling horizontally at 4 pixels per step needs 4 images (16/4).
- Sprites moving over that landscape in 2-pixel steps need 8 images — but if they move in 16-pixel steps they *still* need 4 images, or they drift out of sync with the scrolling background.

If in doubt, experiment: if movement looks wrong, change the image count.

## Make menu

### BOBS — sprite bank to bob bank
Converts a STOS sprite bank into the bob bank required by the BOB command. Three options on a sub-screen:

- **MAKE BOBS** — actually creates the bob data.
- **IMAGES** — step through the sprites and choose how many pre-shifted images to store for each one. To give every sprite the same count, click COPY TO ALL with the left AND right mouse buttons simultaneously. EXIT when done.
- **QUIT** — back to the main menu.

Bob images are **renumbered from 0**: sprite 1 becomes bob 0, sprite 2 becomes bob 1, etc.

### JOEYS
Exactly the same workflow as BOBS, but creates JOEY data (same image renumbering from 0).

### WORLD BLOCKS
Creates the tile-block data for the WORLD command. Options: MAKE BLOCKS (build the data), IMAGES (left/right mouse buttons increase/decrease the image count), QUIT. Blocks are 16x16 tiles renumbered from 0.

### LANDSCAPE BLOCKS
Creates the block data for the LANDSCAPE command. Options: MAKE BLOCKS and QUIT only (no per-block image choice).

### PICTURE
Turns a sprite bank into a picture. Assumes your sprites are 16x16 pixels — lay the picture out as a grid of 16x16 sprites first (GRAB.BAS can help).

### DIGIBANK — build a sample bank for DIGIPLAY
A digibank holds **up to 50 samples in one file, numbered from 0** (sample 1 becomes 0, sample 2 becomes 1...). To play sample N from the bank: `digiplay 1,start(bank),N,freq,loop` — a third parameter of 50 or less means "digibank sample number" rather than byte size. Options:

- **LOAD SAMPLE** — add a sample to the bank.
- **SAVE SAMPLE** — save one sample back out of the bank.
- **LOAD A DIGIBANK** / **SAVE A DIGIBANK** — load or save the whole bank.
- **CLEAR BANK** — delete the entire current bank.
- **DELETE SAMPLE** — remove one sample.
- **PLAY SAMPLE** — audition a sample.
- **(UN)SIGN SAMPLE** — convert a sample between signed and unsigned format (the same conversion SAMSIGN performs; use it if a sample plays distorted).
- **EXIT** — back to the main menu.

## Other MAKE-related programs

### GRAB.BAS
Grabs a series of sprites from a picture — much easier than using the sprite editor's grab option. The only documented quirk: you have to click on MAKE SPRITES twice.

### MAKEFBNK.BAS
Builds the ".BNK" file archives used by the BANK LOAD / BANK COPY / BANK LENGTH / BANK SIZE commands. It reads in an entire directory, lets you sort the files into the order you need, then saves the archive. Files inside the bank are numbered from 0. The built-in sort is poor, so the easiest workflow is to copy the files into the directory in the order you want them in the archive *before* running MAKEFBNK. The doc notes the registration package was intended to include a better version along the lines of the digibank maker.

**See also:** commands/files.md (BANK LOAD, BANK COPY), commands/sound.md (DIGIPLAY, SAMSIGN)
