#!/bin/bash

cat <<EOF
📘 TMUX KEYBIND CHEAT SHEET 📘

--- Prefix: Ctrl + Space ---

🧭 Navigation:
  Alt + ←/→/↑/↓       → Move between panes (no prefix)
  Prefix + h/j/k/l    → Move between panes (vim-style)
  Prefix + H / L      → Previous / Next window
  Prefix + ← / →      → Previous / Next window (arrow fallback)

🔳 Splits:
  Prefix + "          → Horizontal split (same dir)
  Prefix + %          → Vertical split (same dir)

🪟 Windows:
  Alt + 1..9 / 0      → Jump to window (or create if missing)

💾 Session Management:
  Prefix + s          → Save session (resurrect)
  Prefix + r          → Restore session
  Prefix + x          → SessionX fuzzy menu
  Prefix + S          → Session Manager

🔍 FZF Utilities:
  Prefix + F          → FZF: switch window
  Prefix + P          → FZF: switch pane
  Prefix + T          → FZF: switch session

📋 Copy Mode (vi-style):
  Prefix + [          → Enter copy mode
  v                   → Begin selection
  Ctrl + v            → Rectangle selection
  y                   → Copy selection and exit

⚙️ Misc:
  Prefix + d          → Detach session
  Prefix + :          → Command prompt
  Prefix + R          → Reload config
EOF
