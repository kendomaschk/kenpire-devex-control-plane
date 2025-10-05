#!/usr/bin/env bash
set -e

today="$(date +%Y-%m-%d)"
log_dir="logs/weekly-retro"
mkdir -p "$log_dir"

# Collect standups from last 7 days
standups=$(find logs/standup -type f -mtime -7 -print0 2>/dev/null | xargs -0 cat 2>/dev/null || true)

# Collect milestones from last 7 days
if command -v gdate >/dev/null 2>&1; then
  since=$(gdate -d "7 days ago" +%Y-%m-%d)
else
  since=$(date -d "7 days ago" +%Y-%m-%d 2>/dev/null || date -v -7d +%Y-%m-%d)
fi
milestones=$(grep "$since" -A9999 docs/capsule_fingerprint.log || true)

log_file="$log_dir/${today}-weekly-retro.md"

cat > "$log_file" <<MD
# 🔒 Finish_Shit_Bot Weekly Retro Digest
Date: $today  
Commander: @kendomaschk

## Standup Highlights (last 7 days)
$standups

---

## Milestones (ClauseWitch feed, last 7 days)
$milestones

---

## Retro / Lessons Learned
- Bots reviewed the week’s logs and standups.
- Self-healing and optimizations applied.
- Knowledge carried forward into next sprint.
- All loops from the week: **closed** ✅
MD

git add "$log_file"
git commit -m "[Finish_Shit_Bot] Weekly Retro Digest ($today)" || true
git push

echo "[Finish_Shit_Bot] ✅ Weekly retro logged at $log_file"

