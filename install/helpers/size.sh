export LOGO_PATH="$OMARCHY_PATH/logo.txt"
export LOGO_WIDTH=$(awk '{ if (length > max) max = length } END { print max+0 }' "$LOGO_PATH" 2>/dev/null || echo 0)
export LOGO_HEIGHT=$(wc -l <"$LOGO_PATH" 2>/dev/null || echo 0)
export TERM_WIDTH=$(tput cols 2>/dev/null || echo ${COLUMNS:-80})
export TERM_HEIGHT=$(tput lines 2>/dev/null || echo ${LINES:-24})
export PADDING_LEFT=$((($TERM_WIDTH - $LOGO_WIDTH) / 2))
export PADDING_LEFT_SPACES=$(printf "%*s" $PADDING_LEFT "")
