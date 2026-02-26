#!/usr/bin/env bash
# Updates project.pbxproj to use pre-compiled Interface.storyboardc instead of
# compiling Interface.storyboard. Run from repo root after copying storyboardc
# into YouTooOld/YouTooOld WatchKit App/.

set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PBXPROJ="$REPO_ROOT/YouTooOld/YouTooOld.xcodeproj/project.pbxproj"

if [ ! -f "$PBXPROJ" ]; then
  echo "Error: $PBXPROJ not found." >&2
  exit 1
fi

cd "$REPO_ROOT"
python3 "$REPO_ROOT/scripts/switch-to-storyboardc.py" "$PBXPROJ"
