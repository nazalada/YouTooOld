#!/usr/bin/env bash
# Apply project.pbxproj fix: use Interface.storyboardc instead of Interface.storyboard
# so Xcode 26 doesn't try to open/compile the storyboard (which causes "interfaceController" error).
# Run this on your Mac (in the project root) if you can't edit the file from Windows.
# After running, you still need Interface.storyboardc (from CI workflow or build on Xcode 15).

set -e
PBX="YouTooOld.xcodeproj/project.pbxproj"
if [ ! -f "$PBX" ]; then
  echo "Run from project root (parent of YouTooOld.xcodeproj)"
  exit 1
fi

# Replace storyboard with storyboardc (same 4 edits as in the repo)
sed -i '' 's|A1B101382F50D35600093105 /\* Interface.storyboard in Resources \*/|A1B101512F50D35600093105 /* Interface.storyboardc in Resources */|g' "$PBX"
sed -i '' 's|A1B101062F50D35600093105 /\* Interface.storyboard \*/|A1B101502F50D35600093105 /* Interface.storyboardc */|g' "$PBX"
sed -i '' 's|lastKnownFileType = file.storyboard; path = Interface.storyboard|lastKnownFileType = folder; path = Interface.storyboardc|g' "$PBX"
sed -i '' 's|A1B101382F50D35600093105 /\* Interface.storyboard in Resources \*/|A1B101512F50D35600093105 /* Interface.storyboardc in Resources */|g' "$PBX"

echo "Done. project.pbxproj now references Interface.storyboardc."
echo "Get Interface.storyboardc by running the GitHub Actions workflow or building once on Xcode 15."
