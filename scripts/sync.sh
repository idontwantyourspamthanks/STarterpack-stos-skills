#!/usr/bin/env bash
# Convert editable STOS source (src/*.bas) into Atari-ready ASCII listings
# (dev/gemdos/<NAME>.ASC) that STOS can LOAD. See docs/setup-notes.md.
#
# STOS stores its own programs tokenized (.BAS). Plain-text source must be
# loaded with the .ASC extension via:  NEW  then  LOAD "C:NAME.ASC"  then  RUN
# (LOADing .ASC *merges* into the current program, hence the NEW first.)
set -euo pipefail
cd "$(dirname "$0")/.."

SRC_DIR=${STOS_SRC:-src}
OUT_DIR=${STOS_OUT:-dev/gemdos}

# Line terminator written into the .ASC file. Verified against STOS 2.06's own
# SAVE "REF.ASC" output: lines end CRLF (0D 0A), the file ends with a final
# CRLF, and there is no EOF marker byte. Its ASCII loader expects the same:
# CR-only and LF-only both make LOAD "x.ASC" abort mid-file with a spurious
# "Disc error" (a parse/merge failure, not I/O). Do not change this lightly.
EOL=${STOS_EOL:-crlf}

mkdir -p "$OUT_DIR"
shopt -s nullglob
files=("$SRC_DIR"/*.bas)
shopt -u nullglob

if [[ ${#files[@]} -eq 0 ]]; then
  echo "sync: no *.bas files in $SRC_DIR" >&2
  exit 1
fi

for f in "${files[@]}"; do
  base=$(basename "$f" .bas)
  # 8.3 uppercase Atari filename (no spaces/dots in the stem)
  up=$(printf '%s' "$base" | tr 'a-z' 'A-Z' | tr -d ' .' | cut -c1-8)
  up=${up%_}
  out="$OUT_DIR/$up.ASC"

  # strip UTF-8 BOM -> transliterate to plain ASCII -> normalize to one
  # statement per line with the chosen EOL; drop blank lines (a line with no
  # leading line number would break the ASCII loader); warn on un-numbered lines.
  sed $'1s/^\xEF\xBB\xBF//' "$f" \
    | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null \
    | awk -v eol="$EOL" '
        BEGIN { ORS = (eol == "crlf" ? "\r\n" : (eol == "lf" ? "\n" : "\r")) }
        {
          gsub(/\r/, ""); gsub(/\t/, " "); sub(/[[:space:]]+$/, "")
          if ($0 ~ /^[[:space:]]*$/) next
          if ($0 !~ /^[0-9]/) print "sync: WARN " FILENAME ": no line number: " $0 > "/dev/stderr"
          print
        }' > "$out"

  printf 'sync: %-22s -> %s  (%s)\n' "$f" "$out" "$(file -b "$out")"
done
