---
name: creator-analytics
description: Analyze a creator/account on any supported platform — profile stats, recent post performance, engagement rate, posting cadence, and top content. Use when the user says "analyze this creator/account/channel", "how is @handle doing", "engagement rate", or wants a performance summary for a profile.
---

# Creator Analytics

Profile a single account and summarize its performance. For comparing multiple accounts, use
`competitor-analysis`.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Workflow

1. **Identify platform + handle** from the user's input (URL or @handle).
2. **Resolve the user** to the id the API needs (e.g. TikTok/Douyin `sec_user_id` via
   `handler_user_profile`; Twitter `screen_name`/`rest_id`; Instagram `username`). See the
   platform skill for the exact endpoint.
3. **Fetch the profile** (followers, following, total likes/posts, bio) — the user-info endpoint.
4. **Fetch recent posts** (e.g. last 30–100) via the user's post-list endpoint, paginating with
   the platform's cursor. **Cap the page count** and tell the user the cost.
5. **Compute metrics** from the posts:
   - Engagement rate ≈ avg(likes + comments + shares) / followers.
   - Posting cadence (posts/week from timestamps).
   - Top 5 posts by engagement; median vs. top performance.
   - Trend over time (rising/declining views).
6. **Deliver** a concise report: headline stats, engagement rate, cadence, top content, and 2–3
   observations.

## Endpoint pointers (per platform)

Use `tikhub-find-endpoint "user info" --platform <slug>` and `"user posts" --platform <slug>`, or
the platform skill: `tiktok`, `douyin`, `instagram`, `youtube`, `twitter-threads`, `xiaohongshu`.

## Cost awareness

Profile = 1 call; each page of posts = 1 call. Estimate before running:
`GET /api/v1/tikhub/user/calculate_price?endpoint=<path>&request_per_day=<n>`. Warn the user
before pulling many pages.

## Verification gate

1. Profile resolved (non-empty follower/post counts).
2. Post list non-empty and timestamps parse.
3. Engagement math sanity-checked (rates between 0–100%).

## Red flags

- Reporting an engagement rate from too few posts — note the sample size.
- Forgetting to resolve `sec_user_id`/numeric id before the post-list call.
