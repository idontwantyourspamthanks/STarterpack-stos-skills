#!/usr/bin/env bash
# Install STOS extensions from extensions/<name>/Extensions/ into the emulated
# C: drive (dev/gemdos/STOS for the interpreter, dev/gemdos/COMPILER for the
# compiler versions).
#
# Usage:
#   scripts/install-extension.sh             list available extensions, slots,
#                                            and what is already installed
#   scripts/install-extension.sh NAME ...    install the named extensions
#   scripts/install-extension.sh --all       install everything conflict-free
#
# Notes:
# - Run AFTER scripts/setup.sh (setup rebuilds dev/gemdos from scratch, so
#   extensions must be reinstalled afterwards).
# - STOS extensions live in slot letters A-Z (the last letter of the EX?/EC?
#   filename). Two extensions can never share a slot; conflicts are skipped
#   with a warning.
set -euo pipefail
cd "$(dirname "$0")/.."

STOS_DIR=dev/gemdos/STOS
COMP_DIR=dev/gemdos/COMPILER

slot_of() { # filename -> slot letter (last char of the name, e.g. LINK1.EXQ -> Q)
  local b; b=$(basename "$1")
  echo "${b: -1}"
}

installed_in_slot() { # slot letter dir -> filename occupying it (or empty)
  find "$2" -maxdepth 1 \( -iname "*.EX$1" -o -iname "*.EC$1" \) -printf '%f\n' 2>/dev/null | head -1
}

list() {
  printf '%-14s %-6s %-10s %s\n' "extension" "slot" "installed" "source"
  for d in extensions/*/Extensions/Stos; do
    [ -d "$d" ] || continue
    name=$(basename "$(dirname "$(dirname "$d")")")
    for f in "$d"/*.EX?; do
      [ -e "$f" ] || continue
      s=$(slot_of "$f")
      occ=$(installed_in_slot "$s" "$STOS_DIR")
      printf '%-14s %-6s %-10s %s\n' "$name" "$s" "${occ:--}" "$(basename "$f")"
    done
  done
}

install_one() {
  local name="$1"
  local d="extensions/$name/Extensions"
  [ -d "$d" ] || { echo "install: no such extension: $name" >&2; return 1; }
  local f s occ
  for f in "$d"/Stos/*.EX?; do
    [ -e "$f" ] || continue
    s=$(slot_of "$f")
    occ=$(installed_in_slot "$s" "$STOS_DIR")
    if [ -n "$occ" ] && [ "$occ" != "$(basename "$f")" ]; then
      echo "install: SKIP $(basename "$f") - slot $s already held by $occ" >&2
      continue
    fi
    cp -f "$f" "$STOS_DIR/"
    echo "install: $(basename "$f") -> $STOS_DIR (slot $s)"
  done
  for f in "$d"/Compiler/*.EC?; do
    [ -e "$f" ] || continue
    s=$(slot_of "$f")
    occ=$(installed_in_slot "$s" "$COMP_DIR")
    if [ -n "$occ" ] && [ "$occ" != "$(basename "$f")" ]; then
      echo "install: SKIP $(basename "$f") - compiler slot $s already held by $occ" >&2
      continue
    fi
    cp -f "$f" "$COMP_DIR/"
    echo "install: $(basename "$f") -> $COMP_DIR (slot $s)"
  done
}

[ -d "$STOS_DIR" ] || { echo "install: $STOS_DIR missing - run scripts/setup.sh first" >&2; exit 1; }

if [ $# -eq 0 ]; then
  list
elif [ "$1" = "--all" ]; then
  for d in extensions/*/; do
    [ -d "$d/Extensions" ] && install_one "$(basename "$d")"
  done
else
  for name in "$@"; do
    install_one "$name"
  done
fi
