#!/usr/bin/env bash
# Launch Hatari with the STOS system on a GEMDOS hard drive (C:) and auto-start
# the interpreter after TOS boots. A blank floppy sits in A: only to skip TOS's
# empty-drive search (the white screen); the real system lives on C:.
#
# Once STOS shows its "Ok" prompt, run your synced source with:
#     NEW  (only if a program is already loaded)
#     LOAD "C:HELLO.ASC"
#     RUN
# Extra args are forwarded to Hatari (e.g. --cmd-fifo for scripting).
set -euo pipefail
cd "$(dirname "$0")/.."

HATARI=${HATARI:-hatari}
ROM=${STOS_TOS:-dev/roms/tos.img}
MACHINE=${STOS_MACHINE:-st}      # use ste if you need STE sound/graphics
MEM=${STOS_MEM:-1}               # MiB; bump to 2-4 for big programs

if [[ ! -f "$ROM" ]]; then
  echo "hatari.sh: TOS ROM not found at $ROM (run scripts/setup.sh)" >&2
  exit 1
fi

exec "$HATARI" \
  --machine "$MACHINE" \
  --tos "$ROM" \
  --memsize "$MEM" \
  --monitor rgb `# STOS needs a colour monitor; the host's global hatari.cfg may say mono, which makes MODE 0 fail with "Resolution not allowed"` \
  --fast-boot true \
  --harddrive "$PWD/dev/gemdos" \
  --disk-a "$PWD/dev/disks/blank-a.st" \
  --auto 'C:\BASIC208.TOS' \
  --gemdos-case upper \
  --gemdos-time host \
  --statusbar on \
  --confirm-quit false \
  "$@"
