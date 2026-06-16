---
name: trend-research
description: Discover what's trending — viral content, rising hashtags, hot sounds, and ranking boards — on TikTok, Douyin, Twitter/X, and more. Use when the user asks "what's trending", "viral right now", "hot hashtags/sounds", "rising creators", or wants a trend report for a region/niche.
---

# Trend Research

Surface trending content, hashtags, sounds, and rankings, optionally scoped to a region or niche.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Sources by platform

| Platform | What | Endpoint |
|---|---|---|
| TikTok | Popular trends | `GET /api/v1/tiktok/ads/get_popular_trends` (`period`, `country_code`) |
| TikTok | Trending hashtags | `GET /api/v1/tiktok/ads/get_trends_hashtag_list` |
| TikTok | Hot sounds | `GET /api/v1/tiktok/ads/get_sound_rank_list` |
| Twitter/X | Trending topics | `GET /api/v1/twitter/web/fetch_trending` (`country`) |

For niche trends, also run keyword/hashtag search on the relevant platform skill. For other
platforms' trend sources, use `tikhub-find-endpoint "<goal>" --platform <slug>`.

## Workflow

1. Clarify scope: platform(s), region/country, niche/keyword, time window.
2. Pull the relevant trend boards above (one call each).
3. Normalize into a single ranked list (rank, name, volume/score, example content, platform).
4. Deliver a trend report; optionally drill into a hot hashtag via `hashtag-research`.

## Cost awareness

Each board is 1 call. A multi-platform report is a handful of calls — cheap. Drilling into many
hashtags/posts multiplies calls; warn before deep dives.

## Verification gate

1. Each board returns a non-empty ranked list.
2. Region/period filters were actually applied (echo them in the report).

## Red flags

- Presenting Ads-API "trends" as organic virality without noting the source.
- Mixing regions/time windows in one ranked table without labeling them.
