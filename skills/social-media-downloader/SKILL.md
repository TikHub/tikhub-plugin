---
name: social-media-downloader
description: Download video, audio, or images (no-watermark where available) from a social-media URL or list of URLs. Use when the user pastes a TikTok/Douyin/Instagram/YouTube/Twitter/Xiaohongshu link and wants the media file, or says "download this video", "save without watermark", "grab the audio". Dispatches to the right per-platform TikHub endpoint.
---

# Social Media Downloader

Turn a post URL into a saved media file by routing it to the correct platform endpoint, extracting
the media URL from the response, and downloading it.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Step 1 — Detect the platform from the URL and pick the endpoint

| Platform | Endpoint | Input | Media field |
|---|---|---|---|
| TikTok | `GET /api/v1/tiktok/app/v3/fetch_one_video_by_share_url` | `share_url` | no-watermark `play_addr` / `download_addr` `url_list` |
| TikTok (by id) | `GET /api/v1/tiktok/app/v3/fetch_one_video` | `aweme_id` | `url_list` |
| Douyin | `GET /api/v1/douyin/app/v3/fetch_one_video_by_share_url` | `share_url` | video `url_list` |
| Douyin (by id) | `GET /api/v1/douyin/app/v3/fetch_one_video_v2` | `aweme_id` | video `url_list` |
| YouTube | `GET /api/v1/youtube/web_v2/get_video_streams_v2` | `video_id` \| `video_url` | stream URLs (pick resolution) |
| Instagram | `GET /api/v1/instagram/v2/fetch_post_info` | `code_or_url` | media URL(s) |
| Xiaohongshu | `GET /api/v1/xiaohongshu/app_v2/get_video_note_detail` (video) / `get_image_note_detail` (images) | `note_id` | video / image URLs |
| Twitter/X | `GET /api/v1/twitter/web/fetch_tweet_detail` | `tweet_id` | media `url_list` |

For TikTok/Douyin, the `*_by_share_url` endpoints take the raw URL directly — no need to extract an
id. For the others, pull the id/code from the URL (or resolve it via the platform skill).

## Step 2 — Call the endpoint

```bash
# TikTok by share URL (simplest — pass the URL straight through)
URL="https://www.tiktok.com/@nasa/video/7650608519288245534"
curl -s "https://api.tikhub.io/api/v1/tiktok/app/v3/fetch_one_video_by_share_url?share_url=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=''))" "$URL")" \
  -H "Authorization: Bearer $TIKHUB_API_KEY" -o /tmp/media.json

# YouTube streams
curl -s "https://api.tikhub.io/api/v1/youtube/web_v2/get_video_streams_v2?video_id=dQw4w9WgXcQ" \
  -H "Authorization: Bearer $TIKHUB_API_KEY" -o /tmp/media.json
```

## Step 3 — Extract the media URL, then download

Parse the response for the highest-quality (no-watermark, for TikTok/Douyin) media URL — usually a
`url_list` array or a stream URL — then save it:

```bash
curl -L "<media_url_from_response>" -o video.mp4
file video.mp4   # confirm it's a real media container
```

## Batch downloads

Loop over a URL list, **one at a time with a small delay** (respect QPS 10/sec). Each parse is one
billed call — warn the user for large batches and hand off to `bulk-data-export` for big jobs.

## Verification gate

1. Response is `code: 200` and contains a non-empty media URL.
2. Downloaded file is non-empty and the expected type (`file video.mp4` shows a video container).
3. Not an auth/credit error.

## Red flags

- Claiming a download succeeded without checking the file is non-empty/valid.
- Using the wrong platform endpoint for a URL — detect the platform first.
- Unbounded batch loops (credit burn + rate limits).
- Re-hosting/redistributing copyrighted media — respect platform ToS and the user's rights.
