#!/usr/bin/env python3
"""Check a built Hugo site for broken internal links, assets and anchors.

Usage: scripts/check-links.py <public-dir> [site-base-url]
Exits non-zero if any internal href/src/og:image target or #anchor is missing,
or if a content page does not have exactly one <h1>. Standard library only.
"""
import os
import sys
from html.parser import HTMLParser


class Page(HTMLParser):
    def __init__(self, base):
        super().__init__()
        self.base, self.ids, self.refs, self.h1, self.redirect = base, set(), [], 0, False

    def handle_starttag(self, tag, attrs):
        a = dict(attrs)
        if "id" in a:
            self.ids.add(a["id"])
        if tag == "h1":
            self.h1 += 1
        if tag == "meta" and a.get("http-equiv", "").lower() == "refresh":
            self.redirect = True
        values = [a.get("href"), a.get("src")]
        if tag == "meta" and a.get("property", "") == "og:image":
            values.append(a.get("content"))
        for v in values:
            if not v:
                continue
            if v.startswith(self.base):
                v = v[len(self.base):] or "/"
            if v.startswith("/") and not v.startswith("//"):
                self.refs.append(v)


def main():
    root = sys.argv[1].rstrip("/")
    base = (sys.argv[2] if len(sys.argv) > 2 else "https://dermduncan.com").rstrip("/")
    pages = {}
    for dirpath, _, files in os.walk(root):
        for f in files:
            if f.endswith(".html"):
                path = os.path.join(dirpath, f)
                p = Page(base)
                with open(path, encoding="utf-8") as fh:
                    p.feed(fh.read())
                pages[path] = p
    problems = []
    for path, p in pages.items():
        rel = path[len(root):]
        if not p.redirect and rel not in ("/404.html",) and not rel.startswith("/admin/") and p.h1 != 1:
            problems.append(f"{rel}: expected one <h1>, found {p.h1}")
        for ref in p.refs:
            target, _, frag = ref.split("?")[0].partition("#")
            fp = root + target + ("index.html" if target.endswith("/") else "")
            if not os.path.exists(fp):
                problems.append(f"{rel}: missing {ref}")
            elif frag and fp in pages and frag not in pages[fp].ids:
                problems.append(f"{rel}: missing anchor {ref}")
    for line in sorted(set(problems)):
        print(line)
    print(f"links: checked {len(pages)} pages, {len(set(problems))} problem(s)")
    sys.exit(1 if problems else 0)


if __name__ == "__main__":
    main()
