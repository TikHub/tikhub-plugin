---
name: social-media-downloader
description: Download video, audio, or images (no-watermark where available) from a social-media URL or list of URLs. Use when the user pastes a TikTok/Douyin/Instagram/YouTube/Twitter/Xiaohongshu link and wants the media file, or says "download this video", "save without watermark", "grab the audio". Works across platforms via TikHub's hybrid parser.
---

# Social Media Downloader

Turn a post URL into a saved media file. One universal endpoint handles most platforms; fall back
to platform-specific media endpoints when needed.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Step 1 — Universal parse (works for most platforms)

`GET /api/v1/hybrid/video_data` accepts a post URL and returns the media metadata, including
direct (often no-watermark) download URLs:

```bash
URL="https://www.tiktok.com/@user/video/7372484719365098283"
curl -s "https://api.tikhub.io/api/v1/hybrid/video_data?url=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$URL")&minimal=true" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"
```

- `minimal=true` returns a lean payload (faster, just the essentials).
- If the URL has query params, URL-encode it (as above) or use `base64_url`.

## Step 2 — Extract the media URL, then download

Parse the returned JSON for the highest-quality no-watermark video URL (or image list / audio
URL), then save it:

```bash
curl -L "<media_url_from_response>" -o video.mp4
```

## Step 3 — Platform fallbacks (if hybrid can't parse)

| Platform | Endpoint | Field |
|---|---|---|
| TikTok / Douyin | `app/v3/fetch_one_video` (`aweme_id`) | no-watermark `play_addr` / video URL |
| YouTube | `youtube/web_v2/get_video_streams` (`video_id`) | stream URLs (pick resolution) |
| Instagram | `instagram/v2/fetch_user_posts` / post detail | media URL(s) |
| Xiaohongshu | `xiaohongshu/app_v2/get_video_note_detail` (`note_id`) | video/image URLs |

Find exact paths with `tikhub-find-endpoint "<platform> video" --platform <slug>`.

## Batch downloads

Loop over a URL list, **one at a time with a small delay** (respect QPS 10/sec). Each parse is one
billed call — warn the user for large batches and hand off to `bulk-data-export` for big jobs.

## Verification gate

1. Response JSON contains a non-empty media URL.
2. Downloaded file is non-empty and the expected type (`file video.mp4` shows a video container).
3. Not an auth/credit error.

## Red flags

- Claiming a download succeeded without checking the file is non-empty/valid.
- Unbounded batch loops (credit burn + rate limits).
- Re-hosting/redistributing copyrighted media — respect platform ToS and the user's rights.
