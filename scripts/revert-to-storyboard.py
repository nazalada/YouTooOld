#!/usr/bin/env python3
"""Revert project.pbxproj to compile Interface.storyboard (for CI build)."""
import os
import re
import sys

def main():
    if len(sys.argv) < 2:
        print("Usage: revert-to-storyboard.py <path-to-project.pbxproj>", file=sys.stderr)
        sys.exit(1)
    path = sys.argv[1]
    if not os.path.isfile(path):
        print(f"Error: file not found: {path}", file=sys.stderr)
        sys.exit(1)
    with open(path, "r", encoding="utf-8", newline=None) as f:
        content = f.read()
    content = content.replace("\r\n", "\n").replace("\r", "\n")

    if "A1B101472F50D35600093105" not in content:
        print("Project already compiles storyboard, skipping revert.")
        return

    original = content

    # 1. Remove PBXFileReference line for Interface.storyboardc (any line ending)
    content = re.sub(
        r"\n\t\tA1B101472F50D35600093105 /\* Interface\.storyboardc \*/ = \{isa = PBXFileReference;[^}]+\};",
        "",
        content,
        count=1,
    )

    # 2. Replace PBXBuildFile storyboardc with storyboard
    content = content.replace(
        "\t\tA1B101482F50D35600093105 /* Interface.storyboardc in Resources */ = {isa = PBXBuildFile; fileRef = A1B101472F50D35600093105 /* Interface.storyboardc */; };",
        "\t\tA1B101382F50D35600093105 /* Interface.storyboard in Resources */ = {isa = PBXBuildFile; fileRef = A1B101062F50D35600093105 /* Interface.storyboard */; };",
    )

    # 3. In group: replace storyboardc with storyboard
    content = content.replace(
        "A1B101472F50D35600093105 /* Interface.storyboardc */,",
        "A1B101062F50D35600093105 /* Interface.storyboard */,",
        1,
    )

    # 4. In Resources phase: replace storyboardc with storyboard
    content = content.replace(
        "A1B101482F50D35600093105 /* Interface.storyboardc in Resources */,",
        "A1B101382F50D35600093105 /* Interface.storyboard in Resources */,",
        1,
    )

    if content == original:
        print("Warning: revert did not change the file (format may differ). Continuing anyway.", file=sys.stderr)
    else:
        with open(path, "w", encoding="utf-8") as f:
            f.write(content)
        print("Reverted project to compile Interface.storyboard")

if __name__ == "__main__":
    main()
