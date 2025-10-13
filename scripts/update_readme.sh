#!/usr/bin/env bash
set -euo pipefail

# İstanbul saat dilimini kullan
export TZ="Europe/Istanbul"

HOUR=$(date +%H)
DATE_HUMAN=$(date +"%d %B %Y, %H:%M")

# Saat aralıklarına göre selamlama
if [ "$HOUR" -ge 5 ] && [ "$HOUR" -le 11 ]; then
  GREETING="☀️ **Good Morning** from Istanbul!"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -le 17 ]; then
  GREETING="🌤️ **Good Afternoon** from Istanbul!"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -le 22 ]; then
  GREETING="🌆 **Good Evening** from Istanbul!"
else
  GREETING="🌙 **Good Night** from Istanbul!"
fi

# README'ye eklenecek içerik
DYNAMIC_BLOCK=$(cat <<EOF
$GREETING  
_Local time:_ **$DATE_HUMAN (TRT)**
EOF
)

READ_ME="README.md"
START="<!-- DYNAMIC-GREETING:START -->"
END="<!-- DYNAMIC-GREETING:END -->"

# START ve END arasını güncelle
awk -v start="$START" -v end="$END" -v repl="$DYNAMIC_BLOCK" '
  $0 ~ start { print; print repl; inblock=1; next }
  $0 ~ end   { print; inblock=0; next }
  !inblock
' "$READ_ME" > README.tmp && mv README.tmp "$READ_ME"
