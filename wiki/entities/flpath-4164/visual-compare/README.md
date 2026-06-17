---
type: Reference
title: FLPATH-4164 — Visual compare assets
description: Directory structure and git-ignore policy for cluster screenshots used in FLPATH-4164 visual sign-off.
tags: [flpath-4164, visual-compare, screenshots]
timestamp: 2026-06-17T00:00:00Z
---

# Visual compare assets

| Directory | Git |
|-----------|-----|
| `cluster/` | **Ignored** — workshop cluster screenshots; may contain account/org context. Capture locally; link from [VISUAL_SIGNOFF.md](VISUAL_SIGNOFF.md) without committing PNGs. |
| `storybook/` | Optional — Storybook baseline captures (lower PII risk). |
| `VISUAL_SIGNOFF.md` | Tracked — use placeholders for personal Quay and cluster URLs (see [public-repo-hygiene.md](../../workspace/public-repo-hygiene.md)). |
