---
name: twitter-threads
description: Work with Twitter/X and Threads data via TikHub — fetch tweet/post detail, user profiles, user timelines, followers/following, search timelines, comments/replies, and X trending topics. Use when the task targets Twitter/X or Threads. Covers the Twitter-Web and Threads-Web APIs.
---

# Twitter / X & Threads (via TikHub)

Coverage of Twitter/X and Threads (both microblog platforms). Exhaustive endpoints:
`tikhub-find-endpoint "<goal>" --platform twitter` or `--platform threads`.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

**Coverage:** Twitter-Web, Threads-Web.

## Twitter / X endpoints

| Goal | Method + path | Key params |
|---|---|---|
| Tweet detail | `GET /api/v1/twitter/web/fetch_tweet_detail` | `tweet_id` |
| User profile | `GET /api/v1/twitter/web/fetch_user_profile` | `screen_name` \| `rest_id` |
| User tweets | `GET /api/v1/twitter/web/fetch_user_post_tweet` | `screen_name`, `cursor` |
| Search timeline | `GET /api/v1/twitter/web/fetch_search_timeline` | `keyword`, `search_type`, `cursor` |
| Tweet comments | `GET /api/v1/twitter/web/fetch_post_comments` | `tweet_id`, `cursor` |
| Trending | `GET /api/v1/twitter/web/fetch_trending` | `country` |
| Followers | `GET /api/v1/twitter/web/fetch_user_followers` | `screen_name`, `cursor` |
| Following | `GET /api/v1/twitter/web/fetch_user_followings` | `screen_name`, `cursor` |

## Threads endpoints

| Goal | Method + path | Key params |
|---|---|---|
| User info | `GET /api/v1/threads/web/fetch_user_info` | `username` |
| User posts | `GET /api/v1/threads/web/fetch_user_posts` | `user_id`, `end_cursor` |
| Search (top) | `GET /api/v1/threads/web/search_top` | `query`, `end_cursor` |
| Search (recent) | `GET /api/v1/threads/web/search_recent` | `query`, `end_cursor` |
| Post comments | `GET /api/v1/threads/web/fetch_post_comments` | `post_id`, `end_cursor` |

## Example

```bash
curl -s "https://api.tikhub.io/api/v1/twitter/web/fetch_search_timeline?keyword=ai&search_type=Top" \
  -H "Authorization: Bearer $TIKHUB_API_KEY"
```

## Pagination

Twitter/X uses `cursor`; Threads uses `end_cursor`. Pass the value returned by the previous
response; stop when none is returned. **Each page is billed — cap it.**

## Hand off to task skills

- Analyze an account → `creator-analytics`
- Trending/search → `trend-research`, `social-listening`
- Comment/reply mining → `comments-analysis`
- Competitor benchmarking → `competitor-analysis`
- Large pulls → `bulk-data-export`

## Red flags

- Twitter user endpoints accept `screen_name` or `rest_id`; Threads user posts need the numeric
  `user_id` (resolve via `fetch_user_info` first).
- Don't mix the two cursor params — `cursor` (Twitter) vs `end_cursor` (Threads).
