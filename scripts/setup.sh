#!/usr/bin/env bash
# (Re)build the emulated hard-drive image and boot media from the raw STOS
# materials shipped in this repo. Idempotent: safe to re-run.
#
# Layout produced:
#   dev/roms/tos.img          TOS ROM (default tos/TOS_1_04.img)
#   dev/disks/blank-a.st      blank, present-but-non-bootable floppy for A:
#   dev/gemdos/               GEMDOS hard drive = drive C: under emulation
#       BASIC208.TOS          STOS loader (auto-started via Hatari --auto)
#       STOS/                 interpreter + extensions + fonts
#       ACB/                  accessories (load with:  accload "C:ACB\x.ACB")
#       COMPILER/             STOS compiler program + libraries
#       _AUTOEXEC_COMPILER.BAS  opt-in autoexec (renamed so it does NOT auto-run)
set -euo pipefail
cd "$(dirname "$0")/.."

RAW=${STOS_RAW:-Stos and Compiler}
TOSSRC=${STOS_TOS_SRC:-tos/TOS_1_04.img}
export MTOOLS_SKIP_CHECK=1   # mtools rejects Atari media bytes otherwise

if [[ ! -d "$RAW/STOS" ]]; then
  echo "setup.sh: raw STOS materials not found under '$RAW'" >&2
  exit 1
fi

mkdir -p dev/gemdos dev/disks dev/roms

echo "setup: copying STOS system -> dev/gemdos (drive C:)"
cp -f  "$RAW/BASIC208.TOS" dev/gemdos/
cp -rf "$RAW/STOS"         dev/gemdos/STOS
cp -rf "$RAW/ACB"          dev/gemdos/ACB
cp -rf "$RAW/COMPILER"     dev/gemdos/COMPILER
# put the compiler accessory on the C: root for easy accload (setup.sh rebuilds wipe it otherwise)
cp -f  "$RAW/ACB/COMPILER.ACB" dev/gemdos/ 2>/dev/null || true
# keep the compiler-auto-loading autoexec around, but disabled (STOS only
# auto-runs a file named exactly AUTOEXEC.BAS)
cp -f  "$RAW/AUTOEXEC.BAS" dev/gemdos/_AUTOEXEC_COMPILER.BAS

echo "setup: staging TOS ROM ($TOSSRC -> dev/roms/tos.img)"
cp -f "$TOSSRC" dev/roms/tos.img

echo "setup: building blank drive-A floppy (kills the empty-drive white wait)"
dd if=/dev/zero of=dev/disks/blank-a.st bs=1024 count=720 status=none
mformat -i dev/disks/blank-a.st -t 80 -h 2 -s 9 -n 9 :: >/dev/null

echo "setup: drive C: root now contains:"
ls -1 dev/gemdos
echo "setup: done."
