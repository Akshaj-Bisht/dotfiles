#!/usr/bin/bash
set -euo pipefail

mmsg dispatch switch_layout

mon=$(mmsg get focusing-client | python3 -c "import sys,json; print(json.load(sys.stdin).get('monitor',''))")
layout=$(mmsg get tags "$mon" | python3 -c "
import sys, json
data = json.load(sys.stdin)
names = {'T':'Tile','S':'Scroller','D':'Dwindle','G':'Grid','M':'Monocle','C':'Center Tile'}
for t in data.get('tags', []):
    if t.get('is_active'):
        print(names.get(t['layout'], t['layout']))
        exit()
")

notify-send "Layout" "$layout" -h string:x-canonical-private-synchronous:layout
