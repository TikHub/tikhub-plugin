#!/usr/bin/env python3
"""Build a trimmed endpoint index from TikHub's OpenAPI spec.

Output: skills/tikhub-endpoint-discovery/references/openapi-index.json
Each record: {"method","path","tag","summary","params"} — small enough to ship in-repo.
Usage: python3 scripts/build-openapi-index.py [--spec URL_OR_PATH]
"""
import argparse
import json
import os
import sys
import urllib.request

DEFAULT_SPEC = "https://api.tikhub.io/openapi.json"
OUT = os.path.join(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
    "skills", "tikhub-endpoint-discovery", "references", "openapi-index.json",
)


def load_spec(src: str) -> dict:
    if src.startswith("http://") or src.startswith("https://"):
        with urllib.request.urlopen(src, timeout=60) as r:
            return json.load(r)
    with open(src) as f:
        return json.load(f)


def build(spec: dict) -> list:
    out = []
    for path, methods in spec.get("paths", {}).items():
        for method, op in methods.items():
            if method not in ("get", "post", "put", "delete", "patch"):
                continue
            tags = op.get("tags") or ["Untagged"]
            params = [p.get("name") for p in op.get("parameters", []) if p.get("name")]
            out.append({
                "method": method.upper(),
                "path": path,
                "tag": tags[0],
                "summary": (op.get("summary") or "")[:120],
                "params": params,
            })
    out.sort(key=lambda r: (r["tag"], r["path"]))
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--spec", default=DEFAULT_SPEC)
    args = ap.parse_args()
    spec = load_spec(args.spec)
    index = build(spec)
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    with open(OUT, "w") as f:
        json.dump(index, f, ensure_ascii=False, separators=(",", ":"))
    print(f"wrote {len(index)} endpoints -> {OUT}")
    return 0 if index else 1


if __name__ == "__main__":
    sys.exit(main())
