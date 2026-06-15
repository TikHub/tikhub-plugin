---
name: social-listening
description: Monitor what people say about a brand, product, person, or keyword across platforms — collect mentions, classify sentiment, cluster themes, and deliver a cited digest. Use when the user says "what are people saying about X", "monitor mentions", "brand sentiment", "track this keyword", or wants social listening.
---

# Social Listening

Collect mentions of a brand/keyword across platforms, then analyze sentiment and themes.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Workflow

1. **Define the query**: brand/keyword(s), platforms to cover, time window, target volume
   (e.g. ~100 mentions).
2. **Search each platform** using its search endpoint (one query → paginate to the target volume):
   - TikTok `app/v3/fetch_video_search_result`, Douyin `search/fetch_general_search_v2` (POST body),
     Instagram `v2/general_search`, Twitter `web/fetch_search_timeline`, YouTube
     `web_v2/get_general_search`, Xiaohongshu `app_v2/search_notes`.
   - Find exact paths via `tikhub-find-endpoint "search" --platform <slug>`.
3. **Collect** posts/comments into one list (author, text, platform, url, timestamp, engagement).
4. **Classify sentiment** (positive / neutral / negative) per mention — reason over the text.
5. **Cluster themes** (recurring topics, complaints, praise) and pull representative quotes.
6. **Deliver a digest**: volume, sentiment breakdown, top themes with cited example posts (link
   each claim to a source URL), and 2–3 recommendations.

## Cost awareness — IMPORTANT

This is the most call-heavy skill: every search page on every platform is a billed call.
**State an estimated call count and cost before running**
(`GET /api/v1/tikhub/user/calculate_price?endpoint=<path>&request_per_day=<pages>`), cap pages per
platform, and check balance with `get_user_daily_usage`.

## Verification gate

1. Mentions actually match the query (filter false positives).
2. Every theme/claim in the digest cites a real source URL.
3. Sentiment labels are justified by the quoted text.

## Red flags

- Unbounded multi-platform pagination — runs up credits fast; always cap and warn.
- Reporting sentiment without citations.
- Counting unrelated keyword collisions as mentions.
