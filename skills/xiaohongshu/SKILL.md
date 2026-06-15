---
name: xiaohongshu
description: Work with Xiaohongshu / RedNote (小红书) data via TikHub — fetch image and video note details, user info and posted notes, search notes/users/products/images, and pull note comments and sub-comments. Use when the task targets Xiaohongshu. Covers the Xiaohongshu App-V2 API.
---

# Xiaohongshu / RedNote / 小红书 (via TikHub)

Coverage via the App-V2 API. Exhaustive endpoints:
`tikhub-find-endpoint "<goal>" --platform xiaohongshu`.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

**Coverage:** Xiaohongshu-App-V2. (Web V1/V2/V3 and App V1 are de-scoped — reach them via discovery.)

## Key endpoints

| Goal | Method + path | Key params |
|---|---|---|
| Video note detail | `GET /api/v1/xiaohongshu/app_v2/get_video_note_detail` | `note_id`, `share_text` |
| Image note detail | `GET /api/v1/xiaohongshu/app_v2/get_image_note_detail` | `note_id`, `share_text` |
| User info | `GET /api/v1/xiaohongshu/app_v2/get_user_info` | `user_id`, `share_text` |
| User's notes | `GET /api/v1/xiaohongshu/app_v2/get_user_posted_notes` | `user_id`, `cursor` |
| Search notes | `GET /api/v1/xiaohongshu/app_v2/search_notes` | `keyword`, `page`, `sort_type`, `note_type` |
| Search users | `GET /api/v1/xiaohongshu/app_v2/search_users` | `keyword`, `page` |
| Search products | `GET /api/v1/xiaohongshu/app_v2/search_products` | `keyword`, `page` |
| Note comments | `GET /api/v1/xiaohongshu/app_v2/get_note_comments` | `note_id`, `cursor`, `index` |
| Note sub-comments | `GET /api/v1/xiaohongshu/app_v2/get_note_sub_comments` | `note_id`, `comment_id`, `cursor` |

## Example

```bash
curl -s "https://api.tikhub.io/api/v1/xiaohongshu/app_v2/search_notes?keyword=护肤&page=1&sort_type=general" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"
```

## Pagination

Note/comment lists use `cursor` (+`index` for comments); search uses `page`. Loop until the
response signals no more results. **Each page is billed — cap it.**

## Hand off to task skills

- Download note media → `social-media-downloader`
- Analyze a creator → `creator-analytics`
- Search/product/keyword research → `hashtag-research`, `social-listening`
- Comment mining → `comments-analysis`
- Large pulls → `bulk-data-export`

## Red flags

- Many App-V2 endpoints accept a `share_text` (the shared note text/URL) as an alternative to ids
  — pass whichever you have.
- Comment paging needs both `cursor` and `index`.
