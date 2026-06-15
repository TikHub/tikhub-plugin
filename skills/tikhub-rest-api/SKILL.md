---
name: tikhub-rest-api
description: Call the TikHub REST API directly with curl/HTTP. Use for zero-install scripting, CI, non-Python environments, or when the MCP path is unavailable. Covers base URLs, Bearer auth, the /api/v1/{platform}/... path scheme, pagination, rate limits, retries, error handling, and credit/cost awareness.
---

# TikHub — REST API

Direct HTTP access to all 1,100+ TikHub endpoints. Use `tikhub-endpoint-discovery` to find the
right path, then call it here.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Essentials

- **Base URL:** `https://api.tikhub.io` (Mainland China mirror: `https://api.tikhub.dev`).
- **Auth header:** `Authorization: Bearer $TIKHUB_API_KEY`.
- **Path scheme:** `/api/v1/{platform}/{api}/{action}` — e.g. `/api/v1/tiktok/app/v3/fetch_one_video`.
- **Most reads are GET** with query params; batch/multi endpoints are POST with a JSON body.

## Action — example calls

```bash
# TikTok: one video by id
curl -s "https://api.tikhub.io/api/v1/tiktok/app/v3/fetch_one_video?aweme_id=7372484719365098283" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"

# Instagram: user info
curl -s "https://api.tikhub.io/api/v1/instagram/v2/fetch_user_info?username=instagram" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"

# Twitter: search timeline
curl -s "https://api.tikhub.io/api/v1/twitter/web/fetch_search_timeline?keyword=ai&search_type=Top" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"

# Batch (POST) — body is a RAW JSON ARRAY of ids (not an object; an object body returns HTTP 422)
curl -s -X POST "https://api.tikhub.io/api/v1/tiktok/app/v3/fetch_multi_video" \
  -H "Authorization: Bearer $TIKHUB_API_KEY" -H "Content-Type: application/json" \
  -d '["7372484719365098283","7372484719365098284"]'
```

## Pagination (param name varies by platform)

| Platform | Cursor param | Notes |
|---|---|---|
| TikTok / Douyin | `max_cursor` / `cursor` | response returns next cursor + `has_more` |
| Instagram | `pagination_token` | pass the token from the previous response |
| YouTube | `continuation_token` | pass to `..._replies` / next-page endpoints |
| Twitter | `cursor` | from previous timeline response |
| Xiaohongshu | `cursor` (+ `index`) | |

Loop until the response's `has_more` is false or no next cursor is returned. **Each page is a
billed call — cap pages and warn the user before large pulls** (hand off to `bulk-data-export`
for big jobs).

## Rate limits, retries, region

- **QPS 10/sec.** Add a small delay or a concurrency cap (≤4) in loops.
- **Retry** transient 429/5xx up to 3× with exponential backoff (1s, 2s, 4s).
- Use `api.tikhub.dev` from Mainland China.

## Cost awareness

Pricing is per-endpoint and credit-based with daily-volume tier discounts. Account/cost endpoints
under **TikHub-User-API**:

- `GET /api/v1/tikhub/user/get_user_info` — account info / balance.
- `GET /api/v1/tikhub/user/get_user_daily_usage` — today's usage (note: this call is itself billed).
- `GET /api/v1/tikhub/user/calculate_price?endpoint=<path>&request_per_day=<n>` — estimate a run's cost.
- `GET /api/v1/tikhub/user/get_endpoint_info?endpoint=<path>` — the price/details of one endpoint.

Check balance and estimate cost before bulk runs.

## Verification gate

Before claiming success:
1. HTTP 200 and body is valid JSON.
2. Not an auth/credit error (`code` indicating 401/insufficient balance).
3. Expected fields present (e.g. a video fetch returns a play/download URL).

## Red flags

- Hardcoding the API key in code/commits — always read `$TIKHUB_API_KEY`.
- Unbounded pagination loops (runs up credits).
- Ignoring `has_more` / next-cursor and re-fetching page 1.
