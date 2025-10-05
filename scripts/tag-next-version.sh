#!/usr/bin/env bash
set -e

# --- CONFIG ---
PREFIX="v"                          # version prefix
BRANCH="main"                       # branch to base new tag on
REMOTE="origin"

# --- FUNCTIONS ---
get_latest_tag() {
  git fetch --tags >/dev/null 2>&1
  git tag --sort=-v:refname | head -n1
}

bump_version() {
  local current="$1"
  IFS='.' read -r major minor patch <<<"${current#${PREFIX}}"
  patch=$((patch + 1))
  echo "${PREFIX}${major}.${minor}.${patch}"
}

# --- MAIN ---
latest_tag=$(get_latest_tag)
if [ -z "$latest_tag" ]; then
  new_tag="${PREFIX}1.0.0"
else
  new_tag=$(bump_version "$latest_tag")
fi

echo "Latest tag: $latest_tag"
echo "Next tag:   $new_tag"

read -rp "Proceed to tag and push $new_tag? [y/N]: " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }

git checkout "$BRANCH"
git pull "$REMOTE" "$BRANCH"

git tag "$new_tag"
git push "$REMOTE" "$new_tag"

echo "✅ Tagged and pushed $new_tag — Milestone Logger workflow will run automatically."
