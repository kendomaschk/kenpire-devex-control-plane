#!/usr/bin/env python3
import pathlib, hashlib, datetime

ROOT = pathlib.Path(__file__).resolve().parents[1]
STAMP = f"KenPire DevEx Control Plane Repo™ v0.1 | {datetime.datetime.utcnow().isoformat()}Z"
FPL = ROOT/"docs/capsule_fingerprint.log"
TARGET = ROOT/"docs/devex_control_plane.md"

def hash_file(p):
    h = hashlib.sha256()
    h.update(p.read_bytes())
    return h.hexdigest()

txt = TARGET.read_text(encoding="utf-8")
if "KenPire DevEx Control Plane Repo™" not in txt:
    raise SystemExit("❌ Missing watermark in one-pager!")

with FPL.open("a", encoding="utf-8") as fp:
    fp.write(f"[{STAMP}] {TARGET.relative_to(ROOT)} sha256={hash_file(TARGET)}\n")

print("✅ ClauseWitch watermark/fingerprint updated.")
