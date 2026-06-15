---
name: youtube
description: Work with YouTube data via TikHub — fetch video info, downloadable stream URLs, captions/subtitles, comments and replies, channel info, and run general/shorts search. Use when the task targets YouTube. Covers the YouTube Web-V2 API.
---

# YouTube (via TikHub)

Deep coverage of YouTube via the Web-V2 API. Exhaustive endpoints:
`tikhub-find-endpoint "<goal>" --platform youtube`.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

**Coverage:** YouTube-Web-V2. (The older YouTube-Web API is de-scoped — reach it via discovery.)

## Key endpoints

| Goal | Method + path | Key params |
|---|---|---|
| Video info | `GET /api/v1/youtube/web_v2/get_video_info` | `video_id`, `language_code` |
| Video info by URL | `GET /api/v1/youtube/web_v2/get_video_info_v2` | `video_url` |
| Download streams | `GET /api/v1/youtube/web_v2/get_video_streams` | `video_id` \| `video_url` |
| Captions/subtitles | `GET /api/v1/youtube/web_v2/get_video_captions` | `video_id`, `language_code`, `format` |
| Video comments | `GET /api/v1/youtube/web_v2/get_video_comments` | `video_id`, `sort_by`, `continuation_token` |
| Comment replies | `GET /api/v1/youtube/web_v2/get_video_comment_replies` | `continuation_token` |
| Channel info | `GET /api/v1/youtube/web_v2/get_channel_description` | `channel_id`, `continuation_token` |
| General search | `GET /api/v1/youtube/web_v2/get_general_search` | `search_query`, `upload_time` |
| Shorts search | `GET /api/v1/youtube/web_v2/get_shorts_search` | `search_query`, `upload_time` |

## Example

```bash
curl -s "https://api.tikhub.io/api/v1/youtube/web_v2/get_video_info?video_id=dQw4w9WgXcQ" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"
```

## Pagination

Comments, replies, channel feeds, and the `*_v2` search endpoints use `continuation_token` — pass
the token from the previous response; stop when none is returned. **Each page is billed — cap it.**

## Hand off to task skills

- Download videos / captions → `social-media-downloader`
- Analyze a channel → `creator-analytics`
- Comment mining → `comments-analysis`
- Search/listening → `social-listening`
- Large pulls → `bulk-data-export`

## Red flags

- Use `get_video_streams` for downloadable media URLs; `get_video_info` is metadata only.
- A `video_id` is the 11-char id; pass full URLs to the `*_v2` variants.
