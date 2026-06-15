---
name: bulk-data-export
description: Fetch large lists from TikHub (posts, followers, search results, comments) with safe pagination, dedup, and export to CSV or JSON for downstream analysis. Use when the user wants "all posts", "export to CSV/JSON", "scrape N results", "a dataset of", or any large repeated-pull job.
---

# Bulk Data Export

Paginate a list endpoint at scale, dedup, and write a clean dataset — safely and with a cost
estimate up front.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Step 1 — Estimate cost FIRST (mandatory)

Bulk pulls are the biggest credit spender. Before fetching:

```bash
# pages = ceil(target_rows / page_size)
curl -s "https://api.tikhub.io/api/v1/tikhub/user/calculate_price?endpoint=<ENDPOINT_PATH>&request_per_day=<PAGES>" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"
curl -s "https://api.tikhub.io/api/v1/tikhub/user/get_user_daily_usage" -H "Authorization: Bearer $TIKHUB_API_KEY"
```

State the estimated calls + cost and get the user's go-ahead before running.

## Step 2 — Paginate safely

- Use the platform's cursor (`max_cursor` / `pagination_token` / `continuation_token` / `cursor` /
  `cursor`+`index`) — see `tikhub-rest-api` and the platform skill.
- Loop until `has_more` is false **or** the user's target row count is reached (hard cap).
- Add a short delay / concurrency cap ≤4 (QPS 10/sec). Retry transient 429/5xx with backoff.
- Dedup by stable id (e.g. `aweme_id` / post id) as you go.

## Step 3 — Export

- **JSON:** write the deduped array to `output.json`.
- **CSV:** flatten the fields the user cares about (id, author, text, likes, comments, shares,
  timestamp, url) into `output.csv`.
- Report row count, pages fetched, duplicates removed, and the file path.

## Verification gate

1. Row count ≈ requested (note if the source ran out early).
2. No duplicate ids in the output.
3. File written and non-empty; CSV header matches columns.

## Red flags

- Skipping the cost estimate — never start a bulk pull without one.
- Ignoring the user's row cap / `has_more` (infinite loop, credit burn).
- Silent truncation — always report how many rows were actually fetched vs. requested.
