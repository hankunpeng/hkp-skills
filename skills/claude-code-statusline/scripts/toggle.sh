#!/bin/bash
# Toggle Claude Code custom status line: native <-> custom
# Requires statusline-backup.json in ~/.claude/

SETTINGS="$HOME/.claude/settings.json"
BACKUP="$HOME/.claude/statusline-backup.json"

python3 -c "
import json

with open('$SETTINGS') as f:
    d = json.load(f)

if 'statusLine' in d:
    # Currently ON — remove it (go native)
    sl = d.pop('statusLine')
    with open('$BACKUP', 'w') as f:
        json.dump(sl, f, indent=2)
    with open('$SETTINGS', 'w') as f:
        json.dump(d, f, indent=2)
    print('OFF — native status line')
else:
    # Currently OFF — restore from backup (go custom)
    with open('$BACKUP') as f:
        sl = json.load(f)
    d['statusLine'] = sl
    with open('$SETTINGS', 'w') as f:
        json.dump(d, f, indent=2)
    print('ON  — ~/path | CW: X% | model')
"
