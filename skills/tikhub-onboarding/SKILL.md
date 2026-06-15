---
name: tikhub-onboarding
description: Entry point for using TikHub social-media data in Claude. Use when the user first mentions TikHub, asks to download/fetch TikTok/Douyin/Instagram/YouTube/Twitter/Xiaohongshu data, or hasn't set up access yet. Walks through getting an API key, setting TIKHUB_API_KEY, choosing a path (hosted MCP / REST / Python SDK), and routes to the right skill.
---

# TikHub — Onboarding & Routing

TikHub is a unified API for social-media data across 16+ platforms (TikTok, Douyin,
Instagram, YouTube, Twitter/X, Threads, Xiaohongshu, Weibo, Bilibili, Reddit, LinkedIn,
and more): download media, fetch posts/profiles/comments, search, trends, and analytics.

Read this once, get the user set up, then **hand off to the skill that owns the task.**

## Step 1 — Get an API key (one time)

Send the user to <https://user.tikhub.io>: register (email verification), open the API Keys
page, and create a key. Free trial credits are available via the daily check-in. Pricing is
per-endpoint, credit-based.

## Step 2 — Set the key in the environment

Every path reads `TIKHUB_API_KEY` from the environment:

```bash
export TIKHUB_API_KEY="your_api_key_here"
# persist it: add the line to ~/.zshrc or ~/.bashrc
```

## Step 3 — Pick a path and hand off

| If the user wants… | Path | Hand off to |
|---|---|---|
| Claude to call TikHub directly as tools (default) | Hosted MCP | `tikhub-mcp` |
| To script/curl it, CI, or no Python/Node | REST API | `tikhub-rest-api` |
| To build an app or pipeline in Python | Python SDK | `tikhub-python-sdk` |
| To find which endpoint does X (1,100+ exist) | Discovery | `tikhub-endpoint-discovery` |
| A finished outcome (download, analyze a creator, trends, listening…) | Task skill | `social-media-downloader`, `creator-analytics`, `trend-research`, `social-listening`, `competitor-analysis`, `hashtag-research`, `comments-analysis`, `bulk-data-export` |
| Deep work on one platform | Platform skill | `tiktok`, `douyin`, `instagram`, `youtube`, `twitter-threads`, `xiaohongshu` |

## Setup gate (run before any TikHub call)

```bash
if [ -z "${TIKHUB_API_KEY:-}" ]; then
  echo "TIKHUB_API_KEY is not set — get a key at https://user.tikhub.io then: export TIKHUB_API_KEY=..."
fi
```

If unset, halt and walk the user through Steps 1–2 before proceeding.

## Red flags

- Calling endpoints before `TIKHUB_API_KEY` is set (every call 401s).
- Forgetting that calls cost credits — warn before large/bulk pulls.
