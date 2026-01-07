#!/usr/bin/env python3
"""
Generate a meta.json file by querying Typst frontmatter.

Usage:
  python scripts/gen_meta.py --out meta.json --root . --features html content/article/foo.typ ...
"""

import argparse
import json
import subprocess
import sys
from pathlib import Path


def parse_json_line(stdout: str) -> object:
  """Pick the first non-empty line that parses as JSON."""
  for line in stdout.splitlines():
    s = line.strip()
    if not s:
      continue
    try:
      return json.loads(s)
    except json.JSONDecodeError:
      continue
  raise ValueError("No JSON payload found in typst query output")


def query_frontmatter(path: Path, root: Path, features: str) -> dict:
  """Run `typst query` for <frontmatter> and return the first object."""
  cmd = [
    "typst",
    "query",
    str(path),
    "<frontmatter>",
    "--field",
    "value",
    "--root",
    str(root),
  ]
  if features:
    cmd += ["--features", features]

  result = subprocess.run(cmd, capture_output=True, text=True)
  if result.stderr:
    sys.stderr.write(result.stderr)
  if result.returncode != 0:
    raise RuntimeError(f"typst query failed for {path} (exit {result.returncode})")

  payload = parse_json_line(result.stdout)
  if isinstance(payload, list) and payload:
    first = payload[0]
    return first if isinstance(first, dict) else {}
  if isinstance(payload, dict):
    return payload
  return {}


def main(argv) -> int:
  parser = argparse.ArgumentParser()
  parser.add_argument("--out", required=True, help="Output JSON path")
  parser.add_argument("--root", default=".", help="Typst project root")
  parser.add_argument("--features", default="html", help="Features flag for typst query")
  parser.add_argument("--html-dir", default="html", help="Directory containing generated HTML (one subdir per slug)")
  parser.add_argument("files", nargs="+", help="Typst source files")
  args = parser.parse_args(argv)

  root = Path(args.root)
  out_path = Path(args.out)
  out_path.parent.mkdir(parents=True, exist_ok=True)

  meta = {}
  for src in args.files:
    path = Path(src)
    slug = path.stem
    meta[slug] = query_frontmatter(path, root, args.features)

  # Add any manual/generated HTML folders not covered by Typst sources.
  html_dir = Path(args.html_dir)
  if html_dir.exists():
    for html_subdir in html_dir.iterdir():
      if not html_subdir.is_dir():
        continue
      index_path = html_subdir / "index.html"
      if not index_path.exists():
        continue
      slug = html_subdir.name
      if slug in meta:
        continue
      # Default metadata when no frontmatter is available.
      mtime = index_path.stat().st_mtime
      meta[slug] = {
        "title": slug.replace("-", " ").replace("_", " ").title(),
        "author": "",
        "desc": "",
        "date": __import__("datetime").datetime.fromtimestamp(mtime).isoformat(),
        "updatedDate": "",
        "tags": [],
      }

  with out_path.open("w", encoding="utf-8") as f:
    json.dump(meta, f, indent=2, ensure_ascii=False)
    f.write("\n")

  return 0


if __name__ == "__main__":
  raise SystemExit(main(sys.argv[1:]))

