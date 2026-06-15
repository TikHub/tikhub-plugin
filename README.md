# TikHub Plugin for Claude Code

Social-media data for Claude — download media and fetch posts, profiles, comments,
search, trends, and analytics across **TikTok, Douyin, Instagram, YouTube, Twitter/X,
Threads, Xiaohongshu**, and 9+ more platforms, powered by [TikHub](https://tikhub.io).

> **Status:** scaffold (v0.1.0). Skills are added in subsequent releases — see `plans/`.

## Three ways to use it

| Path | Best for | How |
|------|----------|-----|
| **MCP (default)** | Letting Claude call TikHub directly as tools | This plugin's `.mcp.json` connects to TikHub's hosted MCP (`mcp.tikhub.io`) via `npx mcp-remote`. |
| **REST API** | Scripts, CI, zero-install | `curl` with `Authorization: Bearer $TIKHUB_API_KEY` against `https://api.tikhub.io`. |
| **Python SDK** | Building apps/pipelines | `pip install tikhub`. |

## Quick start

1. **Get an API key** at <https://user.tikhub.io> (free daily check-in credits available).
2. **Export it** so the MCP servers can authenticate:
   ```bash
   export TIKHUB_API_KEY="your_api_key_here"
   ```
3. **Install the plugin** from the marketplace, or test locally:
   ```bash
   claude --plugin-dir /path/to/tikhub-plugin
   ```
4. The MCP path requires Node.js (`npx`). No Node? Use the REST or Python SDK paths, or self-host
   the MCP with `pip install tikhub-mcp`.

## Enabled MCP platforms

By default this plugin enables the Core-6 platform MCP servers: `tiktok`, `douyin`, `instagram`,
`youtube`, `twitter`, `threads`, `xiaohongshu`. TikHub's hosted MCP also offers `weibo`,
`bilibili`, `kuaishou`, `zhihu`, `linkedin`, `reddit`, `wechat`, `others`, and `tikhub` — add
them to `.mcp.json` following the same pattern (see the `tikhub-mcp` skill).

## Links

- Website: <https://tikhub.io> · API docs: <https://docs.tikhub.io>
- Hosted MCP: <https://tikhub.io/mcp>
- OpenAPI spec: <https://api.tikhub.io/openapi.json>

## License

MIT — see [LICENSE](LICENSE).
