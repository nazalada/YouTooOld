#!/usr/bin/env python3
"""Revert project.pbxproj to compile Interface.storyboard (for CI build on macos-13)."""
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: revert-to-storyboard.py <path-to-project.pbxproj>", file=sys.stderr)
        sys.exit(1)
    path = sys.argv[1]
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    if "A1B101472F50D35600093105" not in content:
        print("Project already compiles storyboard, skipping revert.")
        return

    original = content

    # 1. Remove PBXFileReference for Interface.storyboardc
    content = content.replace(
        '\n\t\tA1B101472F50D35600093105 /* Interface.storyboardc */ = {isa = PBXFileReference; lastKnownFileType = folder.storyboardc; path = Interface.storyboardc; sourceTree = "<group>"; };',
        ''
    )

    # 2. Replace PBXBuildFile storyboardc with storyboard
    content = content.replace(
        '\t\tA1B101482F50D35600093105 /* Interface.storyboardc in Resources */ = {isa = PBXBuildFile; fileRef = A1B101472F50D35600093105 /* Interface.storyboardc */; };',
        '\t\tA1B101382F50D35600093105 /* Interface.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = A1B101062F50D35600093105 /* Interface.storyboard */; };'
    )

    # 3. In group: replace storyboardc with storyboard
    content = content.replace(
        'A1B101472F50D35600093105 /* Interface.storyboardc */,',
        'A1B101062F50D35600093105 /* Interface.storyboard */,',
        1
    )

    # 4. In Resources phase: replace storyboardc with storyboard
    content = content.replace(
        'A1B101482F50D35600093105 /* Interface.storyboardc in Resources */,',
        'A1B101382F50D35600093105 /* Interface.storyboard in Resources */,',
        1
    )

    if content == original:
        print("Error: project.pbxproj was not modified (revert replacements did not match).", file=sys.stderr)
        sys.exit(1)

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    print("Reverted project to compile Interface.storyboard")

if __name__ == "__main__":
    main()
