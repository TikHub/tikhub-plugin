---
name: competitor-analysis
description: Benchmark multiple accounts/competitors side by side on one or more platforms — followers, engagement rate, posting cadence, top content, and growth signals. Use when the user says "compare these accounts", "us vs competitors", "benchmark @a @b @c", or wants a competitive landscape.
---

# Competitor Analysis

Compare several accounts head-to-head. For a single account, use `creator-analytics`.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
```

## Workflow

1. **Collect the account list** (handles/URLs) and the platform(s).
2. **For each account, run the `creator-analytics` workflow** (resolve → profile → recent posts →
   metrics). Use the same post-count cap for every account so the comparison is fair.
3. **Build a comparison table**: followers, avg engagement, engagement rate, posts/week, top post,
   median views. One row per account.
4. **Rank and summarize**: who leads on reach vs. engagement vs. consistency; notable content
   strategies; gaps/opportunities.

## Cost awareness

Cost ≈ (1 profile + N post-pages) × number of accounts. Multiply it out and state the total before
running; cap pages and account count. Use `calculate_price` for an estimate.

## Verification gate

1. Every account resolved and has a non-empty post sample.
2. Same sample size/time window across accounts (note any account with fewer posts).
3. Rates within sane bounds.

## Red flags

- Comparing accounts with wildly different sample sizes or date ranges — normalize first.
- Treating follower count alone as "winning" — lead with engagement rate.
