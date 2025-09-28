#!/usr/bin/env bash
set -e

# ClauseWitch™ Milestone Logger
# Usage: ./scripts/milestone-log.sh "v0.1 Release" (quotes recommended)

if [ -z "$1" ]; then
  echo "Usage: $0 \"Milestone Title\""
  exit 1
fi

milestone="$1"
today="$(date +%Y-%m-%d)"
log_dir="logs/milestones"
mkdir -p "$log_dir" docs

# slug for filename (lowercase, alnum + dashes)
slug="$(echo "$milestone" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')"
log_file="$log_dir/${today}-${slug}.md"

# write milestone log
cat > "$log_file" <<MD
# 🚀 Milestone: $milestone
Date: $today

## Summary
- Milestone declared: $milestone
- Commander: @kendomaschk
- Logged by: ClauseWitch™

## Artifacts
- Fingerprint appended to: docs/capsule_fingerprint.log
MD

# compute fingerprint and append to docs
hash="$(sha256sum "$log_file" | awk '{print $1}')"
echo "$today [$milestone] -> $hash  ($log_file)" >> docs/capsule_fingerprint.log

# add hash back into milestone file
cat >> "$log_file" <<MD

## Fingerprint
SHA256: \`$hash\`
MD

# commit + push
git add "$log_file" docs/capsule_fingerprint.log
git commit -m "[ClauseWitch] Milestone logged: $milestone ($today)" || true
git push

echo "[ClauseWitch] ✅ Milestone '$milestone' logged at: $log_file"
echo "[ClauseWitch] 🔒 SHA256: $hash"
