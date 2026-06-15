---
name: douyin
description: Work with Douyin (抖音) data via TikHub — fetch videos, user profiles and post lists, video comments, run video/user/general search via Douyin's dedicated search series, and pull Billboard hot lists & rankings. Use when the task targets Douyin. Covers App-V3, the Douyin Search series, and Billboard.
---

# Douyin / 抖音 (via TikHub)

Deep coverage of Douyin. Exhaustive endpoints: `tikhub-find-endpoint "<goal>" --platform douyin`.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

**Coverage:** App-V3 (video/user/comments), the dedicated Douyin **Search** series, and Billboard
(trends). (Douyin-Web, Douyin-Creator, Douyin-Index, and Xingtu are de-scoped — reach them via
discovery.)

> **Search note:** Douyin has its own specialized search series (`/douyin/search/...`, POST with a
> JSON body). Prefer it over the App-V3 search endpoints.

## Key endpoints

| Goal | Method + path | Key params |
|---|---|---|
| One video | `GET /api/v1/douyin/app/v3/fetch_one_video_v2` | `aweme_id` |
| Video by share URL | `GET /api/v1/douyin/app/v3/fetch_one_video_by_share_url` | `share_url` |
| User profile | `GET /api/v1/douyin/app/v3/handler_user_profile` | `sec_user_id` |
| User's videos | `GET /api/v1/douyin/app/v3/fetch_user_post_videos` | `sec_user_id`, `max_cursor`, `count` |
| Video comments | `GET /api/v1/douyin/app/v3/fetch_video_comments` | `aweme_id`, `cursor`, `count` |
| Video search | `POST /api/v1/douyin/search/fetch_video_search_v2` | body: `keyword`, `cursor`, `sort_type`, `publish_time` |
| User search | `POST /api/v1/douyin/search/fetch_user_search_v2` | body: `keyword`, `cursor` |
| General search | `POST /api/v1/douyin/search/fetch_general_search_v2` | body: `keyword`, `cursor`, `sort_type` |
| Hot search board | `POST /api/v1/douyin/billboard/fetch_hot_total_search_list` | JSON body |
| Rising hot list | `GET /api/v1/douyin/billboard/fetch_hot_rise_list` | `page`, `page_size`, `order` |
| Hot categories | `GET /api/v1/douyin/billboard/fetch_hot_category_list` | `billboard_type`, `start_date`, `end_date` |
| Item trend curve | `GET /api/v1/douyin/billboard/fetch_hot_item_trends_list` | `aweme_id`, `date_window` |

## Example

```bash
# Video search — POST with a JSON body
curl -s -X POST "https://api.tikhub.io/api/v1/douyin/search/fetch_video_search_v2" \
  -H "Authorization: Bearer $TIKHUB_API_KEY" -H "Content-Type: application/json" \
  -d '{"keyword": "美食"}'

# One video by id
curl -s "https://api.tikhub.io/api/v1/douyin/app/v3/fetch_one_video_v2?aweme_id=7637462264047710705" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"
```

## Pagination

App-V3 user/video lists use `max_cursor` + `count`; comments use `cursor` + `count`; the Search
series pages via a `cursor` field in the JSON body; Billboard endpoints use `page`/`page_size`.
Loop on the returned cursor/`has_more`. **Cap pages — each is billed.**

## Hand off to task skills

- Download videos → `social-media-downloader`
- Analyze an account → `creator-analytics`
- Billboard trends → `trend-research`
- Competitor benchmarking → `competitor-analysis`
- Hashtag/keyword work → `hashtag-research`
- Comment mining → `comments-analysis`
- Large pulls → `bulk-data-export`

## Red flags

- The Search series is **POST with a JSON body** (`keyword`, `cursor`) — not GET query params.
- User endpoints need `sec_user_id`; resolve it first if you only have a share URL/nickname.
- Some Billboard endpoints are POST with date ranges — pass ISO dates in the body.
