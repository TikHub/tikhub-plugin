---
name: douyin
description: Work with Douyin (抖音) data via TikHub — fetch videos, user profiles and post lists, run video/user/live/music/hashtag search, pull Billboard hot lists and rankings, Xingtu KOL/influencer data, and trend indices. Use when the task targets Douyin. Covers App-V3, Search, Billboard, Xingtu (+V2), and Index APIs.
---

# Douyin / 抖音 (via TikHub)

Deep coverage of Douyin. Exhaustive endpoints: `tikhub-find-endpoint "<goal>" --platform douyin`.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

**Coverage:** App-V3, Search, Billboard, Xingtu (+V2), Index. (Douyin-Web and the Douyin-Creator
APIs are de-scoped — reach them via discovery.)

## Key endpoints

| Goal | Method + path | Key params |
|---|---|---|
| One video | `GET /api/v1/douyin/app/v3/fetch_one_video` | `aweme_id` |
| Video by share URL | `GET /api/v1/douyin/app/v3/fetch_one_video_by_share_url` | `share_url` |
| User profile | `GET /api/v1/douyin/app/v3/handler_user_profile` | `sec_user_id` |
| User's videos | `GET /api/v1/douyin/app/v3/fetch_user_post_videos` | `sec_user_id`, `max_cursor`, `count` |
| Video search | `GET /api/v1/douyin/app/v3/fetch_video_search_result` | `keyword`, `offset`, `count` |
| User search | `GET /api/v1/douyin/app/v3/fetch_user_search_result` | `keyword`, `offset`, `count` |
| Hashtag search | `GET /api/v1/douyin/app/v3/fetch_hashtag_search_result` | `keyword`, `offset`, `count` |
| Hot search board | `POST /api/v1/douyin/billboard/fetch_hot_total_search_list` | JSON body |
| Rising hot list | `GET /api/v1/douyin/billboard/fetch_hot_rise_list` | `page`, `page_size`, `order` |
| Hot categories | `GET /api/v1/douyin/billboard/fetch_hot_category_list` | `billboard_type`, `start_date`, `end_date` |
| Item trend curve | `GET /api/v1/douyin/billboard/fetch_hot_item_trends_list` | `aweme_id`, `date_window` |
| Xingtu KOL search | `GET /api/v1/douyin/xingtu/search_kol_v2` | `keyword`, `followerRange`, `contentTag` |
| Xingtu ranking data | `GET /api/v1/douyin/xingtu_v2/get_ranking_list_data` | `code`, `period`, `date` |
| Keyword hot trend | `POST /api/v1/douyin/index/fetch_multi_keyword_hot_trend` | `keyword_list`, `start_date`, `end_date` |

## Example

```bash
curl -s "https://api.tikhub.io/api/v1/douyin/app/v3/fetch_video_search_result?keyword=美食&offset=0&count=20" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"
```

## Pagination

App-V3 lists use `max_cursor`/`offset` + `count`; Billboard list endpoints use `page`/`page_size`.
Loop on the returned cursor/`has_more`. **Cap pages — each is billed.**

## Hand off to task skills

- Download videos → `social-media-downloader`
- Analyze an account → `creator-analytics`
- Billboard/Xingtu trends & rankings → `trend-research`
- KOL/influencer or competitor benchmarking → `competitor-analysis`
- Hashtag work → `hashtag-research`
- Large pulls → `bulk-data-export`

## Red flags

- User endpoints need `sec_user_id`; resolve it first if you only have a share URL/nickname.
- Many Billboard/Index endpoints are POST with date ranges — pass ISO dates in the body.
