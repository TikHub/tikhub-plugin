---
name: tikhub-endpoint-discovery
description: Find the right TikHub endpoint among 1,100+ across 16+ platforms. Use when you know the goal (e.g. "get a user's posts on Douyin") but not the exact API path, or when a platform has no dedicated skill (LinkedIn, Reddit, Bilibili, Weibo, WeChat, Kuaishou, Zhihu, Lemon8, etc.). Searches a bundled index and maps results to REST/SDK/MCP.
---

# TikHub — Endpoint Discovery

TikHub has 1,100+ endpoints. This skill finds the one you need, then hands off to a calling path.

## Use the bundled search CLI

`bin/tikhub-find-endpoint` (on PATH when the plugin is enabled) searches a trimmed index of
every endpoint (method, path, tag, summary, params):

```bash
# goal-based search, scoped to a platform
tikhub-find-endpoint "one video" --platform tiktok
tikhub-find-endpoint "user posts" --platform douyin
tikhub-find-endpoint "comments" --platform youtube --method GET

# no platform filter — search everything
tikhub-find-endpoint "trending hashtag"
tikhub-find-endpoint "price calculate"        # find the pricing/credit endpoints
```

Output lines look like:
```
GET  /api/v1/tiktok/app/v3/fetch_one_video  [TikTok-App-V3-API]  params: aweme_id
```

The index lives at `references/openapi-index.json` and is regenerated with
`python3 scripts/build-openapi-index.py` when the API version changes.

## Map a result to a calling path

Given `GET /api/v1/{platform}/{api}/{action}`:
- **REST** → `curl "https://api.tikhub.io{path}?param=..." -H "Authorization: Bearer $TIKHUB_API_KEY"` (see `tikhub-rest-api`).
- **SDK** → `client.{platform}_{api}.{action}(...)` (see `tikhub-python-sdk`).
- **MCP** → the matching `tikhub-{platform}` server tool, if that platform is enabled (see `tikhub-mcp`).

## Platforms without a dedicated skill

For LinkedIn, Reddit, Bilibili, Weibo, WeChat, Kuaishou, Zhihu, Lemon8, Toutiao, Xigua,
PiPiXia, and Temp-Mail, discovery + REST/SDK/MCP is the path — there are no v1 platform skills.

## Red flags

- Guessing endpoint paths instead of searching the index (paths and param names are specific).
- Forgetting param names — the CLI prints them; pass them exactly.
