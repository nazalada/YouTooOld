#!/usr/bin/env python3
"""Update project.pbxproj to use Interface.storyboardc instead of compiling Interface.storyboard."""
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: switch-to-storyboardc.py <path-to-project.pbxproj>", file=sys.stderr)
        sys.exit(1)
    path = sys.argv[1]
    with open(path, "r", encoding="utf-8") as f:
        content = f.read()

    # Already updated?
    if "A1B101472F50D35600093105" in content:
        print("Project already uses Interface.storyboardc, skipping.")
        return

    original = content

    # 1. Add PBXFileReference for Interface.storyboardc (after Interface.storyboard line)
    content = content.replace(
        '\t\tA1B101062F50D35600093105 /* Interface.storyboard */ = {isa = PBXFileReference; lastKnownFileType = file.storyboard; path = Interface.storyboard; sourceTree = "<group>"; };',
        '\t\tA1B101062F50D35600093105 /* Interface.storyboard */ = {isa = PBXFileReference; lastKnownFileType = file.storyboard; path = Interface.storyboard; sourceTree = "<group>"; };\n'
        '\t\tA1B101472F50D35600093105 /* Interface.storyboardc */ = {isa = PBXFileReference; lastKnownFileType = folder.storyboardc; path = Interface.storyboardc; sourceTree = "<group>"; };'
    )

    # 2. Add PBXBuildFile for Interface.storyboardc, then remove the storyboard one
    content = content.replace(
        '\t\tA1B101382F50D35600093105 /* Interface.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = A1B101062F50D35600093105 /* Interface.storyboard */; };',
        '\t\tA1B101482F50D35600093105 /* Interface.storyboardc in Resources */ = {isa = PBXBuildFile; fileRef = A1B101472F50D35600093105 /* Interface.storyboardc */; };'
    )

    # 3. In WatchKit App group: replace storyboard ref with storyboardc
    content = content.replace(
        'A1B101062F50D35600093105 /* Interface.storyboard */,',
        'A1B101472F50D35600093105 /* Interface.storyboardc */,',
        1
    )

    # 4. In WatchKit App Resources phase: replace build file ref
    content = content.replace(
        'A1B101382F50D35600093105 /* Interface.storyboard in Resources */,',
        'A1B101482F50D35600093105 /* Interface.storyboardc in Resources */,',
        1
    )

    if content == original:
        print("Error: project.pbxproj was not modified (replacements did not match).", file=sys.stderr)
        sys.exit(1)
    if "A1B101472F50D35600093105" not in content:
        print("Error: storyboardc ref was not added.", file=sys.stderr)
        sys.exit(1)

    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    print("Updated project to use Interface.storyboardc")

if __name__ == "__main__":
    main()
