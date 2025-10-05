#!/usr/bin/env bash
set -e

today="$(date +%Y-%m-%d)"
log_dir="logs/standup"
mkdir -p "$log_dir"

log_file="$log_dir/$today.md"

# collect milestones from yesterday to today
yesterday=$(date -d "yesterday" +%Y-%m-%d 2>/dev/null || date -v -1d +%Y-%m-%d)
milestones=$(grep "^$today\|^$yesterday" docs/capsule_fingerprint.log || true)

cat > "$log_file" <<MD
# 🐓 RoosterOps Daily Standup
Date: $today  
Commander: @kendomaschk

## Yesterday
- Mesh continued operations (auto-log container state)

## Today
- Continue Mesh Ops
- Track milestones & Capsule loops
- Retro + optimization

## Blockers
- None logged

## Milestones (ClauseWitch feed)
$milestones

## Retro / Continuous Improvement
- Bots reflect on learnings
- Self-healing mechanisms applied
- New optimizations planned for next loop
MD

git add "$log_file"
git commit -m "[RoosterOps] Standup + Retro logged ($today)" || true
git push

echo "[RoosterOps] ✅ Standup + Retro for $today logged at $log_file"

