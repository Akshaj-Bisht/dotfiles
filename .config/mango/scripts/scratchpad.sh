#!/usr/bin/bash
set -euo pipefail

mmsg dispatch toggle_named_scratchpad,scratch-foot,none,foot --class scratch-foot

# check if scratchpad is running and visible
state=$(mmsg get all-clients 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
except:
    print('?')
    exit()
for c in data.get('clients', []):
    if c.get('appid') == 'scratch-foot':
        tid = c.get('tags', [])
        print('shown' if tid else 'hidden')
        exit()
print('opened')
")

notify-send "Scratchpad" "$state" -h string:x-canonical-private-synchronous:scratch
