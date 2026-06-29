#!/bin/bash
set -e

CLI_DIR="$HOME/.claude"
SETTINGS_FILE="$CLI_DIR/settings.json"

echo "=== Claude Code Custom Statusline Uninstaller ==="
echo ""

# 1. Remove statusLine block from settings.json (if present)
echo "[1/4] Removing statusLine from settings.json..."
python3 -c "
import json
with open('$SETTINGS_FILE') as f:
    d = json.load(f)
if 'statusLine' in d:
    del d['statusLine']
    with open('$SETTINGS_FILE', 'w') as f:
        json.dump(d, f, indent=2)
    print('  -> statusLine block removed')
else:
    print('  -> no statusLine block found, skipping')
"

# 2. Remove installed files
echo "[2/4] Removing installed files..."
for f in "$CLI_DIR/statusline.sh" "$CLI_DIR/toggle-statusline.sh" "$CLI_DIR/statusline-backup.json"; do
  if [ -f "$f" ]; then
    rm "$f"
    echo "  -> removed $f"
  else
    echo "  -> $f not found, skipping"
  fi
done

# 3. Remove ccsl alias from ~/.zshrc
echo "[3/4] Removing ccsl alias from ~/.zshrc..."
if grep -q "alias ccsl=" "$HOME/.zshrc" 2>/dev/null; then
  # Remove the alias line and the preceding comment line if it's our comment
  python3 -c "
lines = open('$HOME/.zshrc').readlines()
filtered = []
skip_next = False
for i, line in enumerate(lines):
    if 'alias ccsl=' in line:
        # Also skip the preceding comment line if it's '# Claude Code statusline toggle'
        if filtered and '# Claude Code statusline toggle' in filtered[-1]:
            filtered.pop()
        continue
    filtered.append(line)
open('$HOME/.zshrc', 'w').writelines(filtered)
"
  # Remove trailing blank lines left by removal
  python3 -c "
lines = open('$HOME/.zshrc').readlines()
while lines and lines[-1].strip() == '':
    lines.pop()
lines.append('\n')
open('$HOME/.zshrc', 'w').writelines(lines)
"
  echo "  -> ccsl alias removed"
else
  echo "  -> ccsl alias not found, skipping"
fi

echo "[4/4] Done."
echo ""
echo "=== Uninstall complete ==="
echo "Restart Claude Code to see the native status line."
