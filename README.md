# TikHub Plugin for Claude Code

Social-media data for Claude — download media and fetch posts, profiles, comments, search,
trends, and analytics across **TikTok, Douyin, Instagram, YouTube, Twitter/X, Threads,
Xiaohongshu**, and 9+ more platforms, powered by [TikHub](https://tikhub.io).

19 skills across three layers: integration (MCP / REST / SDK), per-platform coverage, and
ready-made task workflows.

## Quick start

1. **Get an API key** at <https://user.tikhub.io> (free daily check-in credits available).
2. **Export it:**
   ```bash
   export TIKHUB_API_KEY="your_api_key_here"
   ```
3. **Install** from the marketplace, or test locally:
   ```bash
   claude --plugin-dir /path/to/tikhub-plugin
   ```
4. Ask Claude something like *"Download this TikTok video"* or *"Analyze @nasa on Instagram"*.

## Three ways it connects

| Path | Best for | Owned by skill |
|------|----------|----------------|
| **MCP (default)** | Claude calling TikHub directly as tools | `tikhub-mcp` (bridges hosted `mcp.tikhub.io`) |
| **REST API** | Scripts, CI, zero-install | `tikhub-rest-api` |
| **Python SDK** | Apps & pipelines (`pip install tikhub`) | `tikhub-python-sdk` |

## Skills

### Foundation
| Skill | What it does |
|-------|--------------|
| `tikhub-onboarding` | Entry point: get a key, set `TIKHUB_API_KEY`, pick a path, route to the right skill |
| `tikhub-mcp` | Connect to TikHub's hosted MCP; add platforms; self-host fallback |
| `tikhub-rest-api` | REST best practices: auth, paths, pagination, rate limits, cost |
| `tikhub-python-sdk` | The official `tikhub` SDK: install, namespaces, errors |
| `tikhub-endpoint-discovery` | Search 1,100+ endpoints with `tikhub-find-endpoint` |

### Platforms
| Skill | Coverage |
|-------|----------|
| `tiktok` | Videos, users, search, ads/trends, creator analytics, shop |
| `douyin` | Videos, users, search, Billboard, Xingtu KOL, trend index |
| `instagram` | Users, posts, search, comments, hashtags (V2) |
| `youtube` | Video info, streams, captions, comments, search (Web-V2) |
| `twitter-threads` | Tweets/posts, profiles, timelines, search, trends |
| `xiaohongshu` | Note details, users, search, comments (App-V2) |

### Tasks
| Skill | Outcome |
|-------|---------|
| `social-media-downloader` | Download video/audio/images (no-watermark) from any URL |
| `creator-analytics` | Profile + engagement + cadence + top content for an account |
| `trend-research` | Trending content, rising hashtags, hot sounds, ranking boards |
| `social-listening` | Mentions → sentiment → themes → cited digest |
| `competitor-analysis` | Benchmark multiple accounts side by side |
| `hashtag-research` | Hashtag volume, top content, related tags |
| `comments-analysis` | Comment sentiment, themes, top comments for a post |
| `bulk-data-export` | Paginate large lists → dedup → CSV/JSON, with cost estimate |

## Examples

```text
You: Download https://www.tiktok.com/@nasa/video/7372484719365098283 without watermark
→ social-media-downloader parses the URL and saves the no-watermark MP4.

You: How is @nasa doing on Instagram?
→ creator-analytics pulls the profile + recent posts and reports engagement rate & top content.

You: What's trending on TikTok in the US right now?
→ trend-research pulls popular trends, hashtags, and hot sounds for the US.

You: What are people saying about "Claude AI" across platforms?
→ social-listening searches each platform, classifies sentiment, and returns a cited digest.
```

## Notes

- The MCP path needs Node.js (`npx`). No Node? Use REST/SDK, or self-host (`pip install tikhub-mcp`).
- TikHub bills per API call. Task skills estimate cost before large pulls and cap pagination.
- China users can switch the base URL to `https://api.tikhub.dev`.

## Links

- Website <https://tikhub.io> · API docs <https://docs.tikhub.io> · Hosted MCP <https://tikhub.io/mcp>
- OpenAPI <https://api.tikhub.io/openapi.json>

## License

MIT — see [LICENSE](LICENSE).
