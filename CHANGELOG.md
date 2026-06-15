# Changelog

All notable changes to the TikHub plugin are documented here.

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
