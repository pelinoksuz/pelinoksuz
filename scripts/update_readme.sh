#!/usr/bin/env bash
set -euo pipefail

# Istanbul timezone
export TZ="Europe/Istanbul"

HOUR=$(date +%H)
DATE_HUMAN=$(date +"%d %B %Y, %H:%M")

# Greeting + theme by hour (customize freely)
if [ "$HOUR" -ge 5 ] && [ "$HOUR" -le 11 ]; then
  GREETING="☀️ **Good Morning** from Istanbul!"
  THEME="radical"
elif [ "$HOUR" -ge 12 ] && [ "$HOUR" -le 17 ]; then
  GREETING="🌤️ **Good Afternoon** from Istanbul!"
  THEME="tokyonight"
elif [ "$HOUR" -ge 18 ] && [ "$HOUR" -le 22 ]; then
  GREETING="🌆 **Good Evening** from Istanbul!"
  THEME="dracula"
else
  GREETING="🌙 **Good Night** from Istanbul!"
  THEME="github_dark"
fi

DYNAMIC_BLOCK=$(cat <<EOF
$GREETING  
_Local time:_ **$DATE_HUMAN (TRT)**

\`\`\`diff
+ Building fast, reliable, and beautiful frontends ✨
\`\`\`

![Pelin's GitHub stats](https://github-readme-stats.vercel.app/api?username=pelinoksuz&show_icons=true&theme=$THEME)
![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=pelinoksuz&layout=compact&theme=$THEME)
EOF
)

READ_ME="README.md"
START="<!-- DYNAMIC-GREETING:START -->"
END="<!-- DYNAMIC-GREETING:END -->"

awk -v start="$START" -v end="$END" -v repl="$DYNAMIC_BLOCK" '
  $0 ~ start { print; print repl; inblock=1; next }
  $0 ~ end   { inblock=0 }
  !inblock
' "$READ_ME" > README.tmp && mv README.tmp "$READ_ME"
