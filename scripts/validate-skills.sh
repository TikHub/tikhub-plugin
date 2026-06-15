#!/usr/bin/env bash
# Structural validator for tikhub-plugin.
# Exit 0 = all checks pass. Used by every plan and in CI.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT" || exit 2

pass=0
fail=0
check() {
  # $1 = exit status of the test, $2 = human description
  if [ "$1" -eq 0 ]; then
    pass=$((pass + 1)); echo "PASS: $2"
  else
    fail=$((fail + 1)); echo "FAIL: $2"
  fi
}

# 1. plugin.json: valid JSON with name, version, description
python3 -c "import json; d=json.load(open('.claude-plugin/plugin.json')); assert d.get('name') and d.get('version') and d.get('description')" 2>/dev/null
check $? ".claude-plugin/plugin.json valid JSON with name + version + description"

# 2. marketplace.json: valid JSON with a non-empty plugins array
python3 -c "import json; d=json.load(open('.claude-plugin/marketplace.json')); assert isinstance(d.get('plugins'), list) and len(d['plugins']) >= 1" 2>/dev/null
check $? ".claude-plugin/marketplace.json valid JSON with non-empty plugins array"

# 3. .mcp.json: valid JSON with a non-empty mcpServers object
python3 -c "import json; d=json.load(open('.mcp.json')); assert isinstance(d.get('mcpServers'), dict) and len(d['mcpServers']) >= 1" 2>/dev/null
check $? ".mcp.json valid JSON with non-empty mcpServers"

# 4. Each skill: SKILL.md has YAML frontmatter with a description
shopt -s nullglob
for sk in skills/*/SKILL.md; do
  if head -1 "$sk" | grep -q '^---$' && awk 'NR>1 && /^---$/{exit} /^description:/{found=1} END{exit !found}' "$sk"; then
    check 0 "$sk has frontmatter with description"
  else
    check 1 "$sk has frontmatter with description"
  fi
done

# 5. Each reference path mentioned in a SKILL.md exists
for sk in skills/*/SKILL.md; do
  skdir="$(dirname "$sk")"
  while IFS= read -r ref; do
    [ -z "$ref" ] && continue
    if [ -e "$skdir/$ref" ]; then
      check 0 "$sk -> $ref exists"
    else
      check 1 "$sk -> $ref exists"
    fi
  done < <(grep -oE 'references/[A-Za-z0-9._/-]+' "$sk" | sort -u)
done

echo "----"
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
