---
name: tiktok
description: Work with TikTok data via TikHub — fetch videos, user profiles and post lists, run search, pull trends/ads insights, creator analytics, comment keywords, and shop search. Use when the task targets TikTok specifically. Covers the App-V3, Ads, Creator, Analytics, and Shop APIs.
---

# TikTok (via TikHub)

Deep coverage of TikTok. For exhaustive endpoints use `tikhub-endpoint-discovery`
(`tikhub-find-endpoint "<goal>" --platform tiktok`). For outcomes (download, analyze a creator,
trends), hand off to the task skills noted below.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

**Coverage:** App-V3, Ads, Creator, Analytics, Shop-Web. (TikTok-Web is de-scoped — reach it via discovery.)

## Key endpoints

| Goal | Method + path | Key params |
|---|---|---|
| One video | `GET /api/v1/tiktok/app/v3/fetch_one_video` | `aweme_id` |
| Video by share URL | `GET /api/v1/tiktok/app/v3/fetch_one_video_by_share_url` | `share_url` |
| User profile | `GET /api/v1/tiktok/app/v3/handler_user_profile` | `sec_user_id` \| `unique_id` |
| User's videos | `GET /api/v1/tiktok/app/v3/fetch_user_post_videos` | `sec_user_id`, `max_cursor`, `count` |
| Video search | `GET /api/v1/tiktok/app/v3/fetch_video_search_result` | `keyword`, `offset`, `count`, `sort_type`, `publish_time` |
| User search | `GET /api/v1/tiktok/app/v3/fetch_user_search_result` | `keyword`, `offset`, `count` |
| Video comments | `GET /api/v1/tiktok/app/v3/fetch_video_comments` | `aweme_id`, `cursor`, `count` |
| Hashtag video list | `GET /api/v1/tiktok/app/v3/fetch_hashtag_video_list` | `ch_id`, `cursor`, `count` |
| Popular trends | `GET /api/v1/tiktok/ads/get_popular_trends` | `period`, `country_code`, `page`, `limit` |
| Trending hashtags | `GET /api/v1/tiktok/ads/get_trends_hashtag_list` | `time_range`, `country_code`, `page` |
| Hashtag detail | `GET /api/v1/tiktok/ads/get_trends_hashtag_detail` | `hashtag_id`, `country_code` |
| Sound rank | `GET /api/v1/tiktok/ads/get_sound_rank_list` | `period`, `rank_type`, `page` |
| Search creators | `GET /api/v1/tiktok/ads/search_creators` | `keyword`, `sort_by`, `creator_country` |
| Creator video analytics | `POST /api/v1/tiktok/creator/get_video_analytics_summary` | JSON body |
| Comment keywords | `GET /api/v1/tiktok/analytics/fetch_comment_keywords` | `item_id` |
| Product detail | `GET /api/v1/tiktok/shop/web/fetch_product_detail_v3` | `product_id`, `region` |

## Example

```bash
curl -s "https://api.tikhub.io/api/v1/tiktok/app/v3/fetch_user_post_videos?sec_user_id=SEC_UID&count=20&max_cursor=0" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"
```

## Pagination

User/video lists use `max_cursor` (start `0`) + `count`; search uses `offset` + `count`; comments
and hashtag video lists use `cursor` + `count`. Read the next cursor and `has_more` from the
response; loop until exhausted. **Each page is billed — cap it.**

## Hand off to task skills

- Download videos → `social-media-downloader`
- Analyze an account → `creator-analytics`
- Trends/hashtags/sounds → `trend-research`, `hashtag-research`
- Comment mining → `comments-analysis`
- Large list pulls → `bulk-data-export`

## Red flags

- Need `sec_user_id` (not the @handle) for user endpoints — resolve via `handler_user_profile` with `unique_id` first.
- Unbounded `max_cursor` loops burn credits.
