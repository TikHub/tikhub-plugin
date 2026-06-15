---
name: hashtag-research
description: Research a hashtag or keyword — volume/popularity signals, top and recent content, and related hashtags — on TikTok, Douyin, Instagram, Xiaohongshu, and more. Use when the user asks "research #hashtag", "how big is this hashtag", "related tags", "best hashtags for X", or wants content ideas around a tag.
---

# Hashtag Research

Assess a hashtag/keyword and surface its top content and related tags.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Workflow

1. **Pick platform(s)** and the hashtag/keyword.
2. **Pull signals + content:**
   - TikTok: `ads/get_trends_hashtag_detail` (`hashtag_id`) and `ads/get_trends_hashtag_list`.
   - Douyin: `app/v3/fetch_hashtag_search_result`.
   - Instagram: `v2/search_hashtags` + `v2/fetch_hashtag_posts`.
   - Xiaohongshu: `app_v2/search_notes` (keyword).
   - Discover exact paths: `tikhub-find-endpoint "hashtag" --platform <slug>`.
3. **Summarize**: estimated popularity/volume, top posts (engagement), recent momentum, and a list
   of related/co-occurring hashtags pulled from the top posts.
4. **Recommend** a tag set for the user's niche.

## Cost awareness

Detail/list calls are 1 each; pulling top-posts pages multiplies calls. Cap and warn for deep pulls.

## Verification gate

1. Hashtag resolved (or clearly report "no data / low volume").
2. Top posts are actually tagged with the hashtag.
3. Related tags derived from real co-occurrence, not guessed.

## Red flags

- Inventing volume numbers — only report what the API returns; otherwise say "not available".
- Recommending banned/irrelevant tags.
