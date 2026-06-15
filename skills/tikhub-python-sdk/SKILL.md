---
name: tikhub-python-sdk
description: Build with the official TikHub Python SDK (pip install tikhub). Use when the user is writing a Python app, script, or data pipeline against TikHub. Covers install, client init from TIKHUB_API_KEY, the platform namespaces, sync/async, pagination, and error handling.
---

# TikHub — Python SDK

The official `tikhub` package wraps all TikHub endpoints with a namespaced client, retries with
backoff, and a structured error hierarchy.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
python3 -c "import tikhub" 2>/dev/null || echo "Install: pip install tikhub"
```

## Install

```bash
pip install tikhub
```

## Minimal usage

```python
import os
from tikhub import TikHub

with TikHub(api_key=os.environ["TIKHUB_API_KEY"]) as client:
    video = client.tiktok_app_v3.fetch_one_video(aweme_id="7372484719365098283")
    print(video)
```

## Namespaces (one per platform/API family)

The client exposes ~54 resources, named `{platform}_{api}`. Common ones:

- TikTok: `tiktok_app_v3`, `tiktok_ads`, `tiktok_creator`, `tiktok_analytics`, `tiktok_shop_web`
- Douyin: `douyin_app_v3`, `douyin_search`, `douyin_billboard`, `douyin_xingtu`
- Instagram: `instagram_v1`, `instagram_v2`, `instagram_v3`
- YouTube: `youtube_web`, `youtube_web_v2`
- Twitter/Threads: `twitter_web`, `threads_web`
- Xiaohongshu: `xiaohongshu_web`, `xiaohongshu_app`
- Others: `weibo_web`, `bilibili_web`, `reddit_app`, `linkedin_web`, `kuaishou_web`, `zhihu_web`, `wechat_channels`, `lemon8_app`
- Account: `tikhub_user` (usage, balance, pricing)

If unsure which method/namespace serves a task, use `tikhub-endpoint-discovery` to find the
REST path, then map `/{platform}/{api}/{action}` → `client.{platform}_{api}.{action}(...)`.

## Pagination

Pass the cursor/token from the previous response (`pagination_token`, `continuation_token`,
`max_cursor`, or `cursor` depending on platform) and loop until exhausted. Cap pages — each call
costs credits.

## Error handling

```python
from tikhub import TikHub
# SDK raises structured exceptions (auth, rate-limit, insufficient-balance, API errors).
try:
    with TikHub(api_key=os.environ["TIKHUB_API_KEY"]) as client:
        data = client.instagram_v2.fetch_user_info(username="instagram")
except Exception as e:
    # inspect e for status/code; back off on rate-limit, stop on auth/balance errors
    print("TikHub call failed:", e)
```

## Red flags

- Committing the API key — always read `os.environ["TIKHUB_API_KEY"]`.
- Tight loops without backoff (QPS 10/sec) or page caps (credit burn).
