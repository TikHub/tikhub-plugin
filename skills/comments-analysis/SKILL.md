---
name: comments-analysis
description: Pull and analyze the comments on a post/video — sentiment breakdown, recurring themes/keywords, top comments, and notable questions or complaints. Use when the user says "analyze the comments", "what are people saying on this post", "comment sentiment", or pastes a post URL and wants the discussion summarized.
---

# Comments Analysis

Mine a single post's comment section for sentiment and themes.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Workflow

1. **Identify the post** (platform + id/URL).
2. **Fetch comments**, paginating to a target count (cap it):
   - TikTok: `app/v3/fetch_video_comments` (`aweme_id`, `cursor`). Douyin: `app/v3/fetch_video_comments` (`aweme_id`, `cursor`).
   - Instagram: `v2/fetch_post_comments` (+ `fetch_comment_replies`).
   - YouTube: `web_v2/get_video_comments` (+ `get_video_comment_replies`).
   - Twitter: `web/fetch_post_comments`. Xiaohongshu: `app_v2/get_note_comments`.
3. **Optional fast keywords:** TikTok `analytics/fetch_comment_keywords` (`item_id`) gives a
   comment keyword summary directly.
4. **Analyze:** sentiment breakdown, top themes with example quotes, most-liked comments, and any
   recurring questions/complaints.
5. **Deliver** a summary with cited example comments.

## Cost awareness

Each comment page (and reply page) is a billed call. Cap pages; warn for viral posts with huge
threads. Estimate via `calculate_price`.

## Verification gate

1. Comments fetched and tied to the right post.
2. Themes/sentiment backed by quoted comments.
3. Report the sample size (comments analyzed vs. total).

## Red flags

- Summarizing 50 comments on a 50k-comment post as representative — disclose the sample.
- Unbounded reply pagination.
