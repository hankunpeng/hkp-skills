---
name: claude-code-statusline
description: Installs a toggleable custom Claude Code status line showing the current working directory, context window usage percentage, and model name. Use when the user wants to customize, install, update, toggle, or remove the Claude Code status bar. Also use when the user mentions statusline, status line, or wants to see context window info in the footer.
---

# Claude Code Custom Statusline Skill

This skill installs a custom status line for Claude Code that shows folder icon, home-abbreviated current working directory, context window usage percentage, and model name. The custom status line is **off by default** — the user toggles it on/off with `ccsl`.

## Features

- **Toggle by default**: After installation, the custom status line is off. Use `ccsl` to switch between native and custom.
- **Single-line display**: `~/path/to/project | CW: 12% | Model Name`
- **Home abbreviation**: Full paths are shortened with `~` (e.g., `/Users/alex/projects` → `~/projects`)
- **Context window percentage**: Shows the percentage of the context window currently in use
- **Auto-hides when no data**: If context window percentage is unavailable (early session), it falls back to `path | model`

## Files

- `scripts/statusline.sh`: The inline command that Claude Code executes to render the status line (stored as the `statusLine.command` in settings.json).
- `scripts/toggle.sh`: Toggles the custom status line on/off by adding or removing the `statusLine` block from `~/.claude/settings.json`.
- `scripts/install.sh`: Copies files into place, saves the status line config to `~/.claude/statusline-backup.json` (off by default), and adds the `ccsl` alias to `~/.zshrc`.
- `scripts/uninstall.sh`: Removes all installed files, the `statusLine` block from settings, and the `ccsl` alias from `~/.zshrc`.

## Usage

**Install or update:**
```bash
<skill_dir>/scripts/install.sh
```

**Toggle on/off:**
```bash
ccsl
```

**Uninstall:**
```bash
<skill_dir>/scripts/uninstall.sh
```

After toggling, restart Claude Code for the change to take effect.
