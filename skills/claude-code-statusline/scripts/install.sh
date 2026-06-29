#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$HOME/.claude"
STATUSLINE_SRC="$SCRIPT_DIR/statusline.sh"
STATUSLINE_DEST="$CLI_DIR/statusline.sh"
TOGGLE_SRC="$SCRIPT_DIR/toggle.sh"
TOGGLE_DEST="$CLI_DIR/toggle-statusline.sh"
BACKUP_FILE="$CLI_DIR/statusline-backup.json"
SETTINGS_FILE="$CLI_DIR/settings.json"

echo "=== Claude Code Custom Statusline Installer ==="
echo ""

# 1. Copy statusline.sh
echo "[1/4] Installing status line script..."
mkdir -p "$CLI_DIR"
cp "$STATUSLINE_SRC" "$STATUSLINE_DEST"
chmod +x "$STATUSLINE_DEST"
echo "  -> $STATUSLINE_DEST"

# 2. Copy toggle.sh
echo "[2/4] Installing toggle script..."
cp "$TOGGLE_SRC" "$TOGGLE_DEST"
chmod +x "$TOGGLE_DEST"
echo "  -> $TOGGLE_DEST"

# 3. Save statusLine config as backup (OFF by default — not added to settings.json)
echo "[3/4] Saving status line config (off by default)..."
cat > "$BACKUP_FILE" << 'EOF'
{
  "type": "command",
  "command": "/Users/alex/.claude/statusline.sh"
}
EOF
# Replace hardcoded path with actual home
python3 -c "
import json
with open('$BACKUP_FILE') as f:
    sl = json.load(f)
sl['command'] = sl['command'].replace('/Users/alex/', '$HOME/')
with open('$BACKUP_FILE', 'w') as f:
    json.dump(sl, f, indent=2)
"
echo "  -> $BACKUP_FILE (toggle with ccsl)"

# 4. Add ccsl alias to ~/.zshrc if not present
echo "[4/4] Adding ccsl alias..."
if grep -q "alias ccsl=" "$HOME/.zshrc" 2>/dev/null; then
  echo "  -> alias ccsl already exists in ~/.zshrc, skipping"
else
  cat >> "$HOME/.zshrc" << 'EOF'

# Claude Code statusline toggle
alias ccsl='bash ~/.claude/toggle-statusline.sh'
EOF
  echo "  -> added 'alias ccsl' to ~/.zshrc"
fi

echo ""
echo "=== Installation complete ==="
echo ""
echo "Usage:"
echo "  ccsl        Toggle custom status line on/off"
echo "  source ~/.zshrc   (if ccsl not found)"
echo ""
echo "Note: restart Claude Code after toggling for changes to take effect."
