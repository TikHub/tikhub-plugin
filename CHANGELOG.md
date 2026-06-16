# Changelog

All notable changes to the TikHub plugin are documented here.

## 1.1.0

Endpoint surface revision (all changes live-tested against the API).

- **Account/cost:** added `tikhub/user/get_user_info` and `get_endpoint_info` (per-endpoint pricing).
- **TikTok:** added video/user search, `fetch_video_comments`, `fetch_hashtag_video_list`, and
  `shop/web/fetch_product_detail_v3`; removed the old general-search endpoint. Documented that
  `fetch_multi_video` takes a raw JSON array body.
- **Douyin:** switched to `fetch_one_video_v2`; adopted the dedicated Douyin **Search series**
  (`/douyin/search/*`, POST); added `fetch_video_comments`; **removed the Billboard endpoints**
  and the Index/Xingtu endpoints (reach them via discovery).
- **Instagram:** added `fetch_post_info`, `fetch_user_stories`, `fetch_user_reels`.
- **YouTube:** switched downloads to `get_video_streams_v2`; added `get_channel_id`.
- **Downloader:** removed the universal `hybrid/video_data` endpoint; now dispatches to the
  correct per-platform media endpoint (verified to return real media URLs on all six platforms).
- **Xiaohongshu:** added the `search_images` row.

## 1.0.0

Initial release.

- **Foundation skills:** `tikhub-onboarding`, `tikhub-mcp` (bridges TikHub's hosted MCP),
  `tikhub-rest-api`, `tikhub-python-sdk`, `tikhub-endpoint-discovery` (searches 1,100+ endpoints
  via `bin/tikhub-find-endpoint`).
- **Platform skills:** `tiktok`, `douyin`, `instagram`, `youtube`, `twitter-threads`,
  `xiaohongshu`.
- **Task skills:** `social-media-downloader`, `creator-analytics`, `trend-research`,
  `social-listening`, `competitor-analysis`, `hashtag-research`, `comments-analysis`,
  `bulk-data-export`.
- `.mcp.json` wires seven platform servers (Core-6 + Threads) to `mcp.tikhub.io` via `mcp-remote`.
- Bundled trimmed OpenAPI index and structural validation harness.
