---
name: tikhub-mcp
description: Connect to and orchestrate TikHub's official hosted MCP server (mcp.tikhub.io). Use when the user wants Claude to call TikHub directly as tools, asks to enable more TikHub platforms, or hits MCP connection/auth issues. This plugin does NOT build its own MCP — it bridges TikHub's hosted MCP via npx mcp-remote.
---

# TikHub — Hosted MCP

TikHub runs an **official hosted MCP**: 16 platform-based servers exposing 900+ tools at
`https://mcp.tikhub.io/{platform}/mcp`. This plugin's `.mcp.json` already wires the Core-6
platforms. This skill covers adding platforms, the self-host fallback, and troubleshooting.

## Setup gate

```bash
[ -z "${TIKHUB_API_KEY:-}" ] && echo "Set TIKHUB_API_KEY first (see tikhub-onboarding)."
command -v npx >/dev/null 2>&1 || echo "npx (Node.js) not found — the hosted MCP path needs it. Use REST/SDK or self-host instead."
```

## How it's wired

The plugin ships `.mcp.json` with one entry per Core-6 platform, each bridging the hosted
endpoint through `mcp-remote`:

```json
{
  "command": "npx",
  "args": ["-y", "mcp-remote", "https://mcp.tikhub.io/tiktok/mcp",
           "--header", "Authorization: Bearer ${TIKHUB_API_KEY}"]
}
```

`${TIKHUB_API_KEY}` is expanded from the environment. After enabling the plugin run
`/reload-plugins`; the `tikhub-*` tools then appear to Claude.

## Add more platforms

Available slugs and approximate tool counts:

| Slug | Tools | Slug | Tools |
|------|-------|------|-------|
| `tiktok` | 204 | `zhihu` | 32 |
| `douyin` | 247 | `linkedin` | 25 |
| `instagram` | 56 | `reddit` | 24 |
| `xiaohongshu` | 50 | `youtube` | 21 |
| `weibo` | 64 | `wechat` | 19 |
| `bilibili` | 38 | `twitter` | 13 |
| `kuaishou` | 33 | `threads` | 11 |
| `others` (Lemon8/PiPiXia/Xigua/Toutiao/Sora2) | 64 | `tikhub` (account/downloader/health) | 23 |

To enable one, add another `mcpServers` entry to `.mcp.json` with the slug swapped into the URL,
then `/reload-plugins`. Keep the enabled set lean — each platform adds many tools to context.

## Self-host fallback (no Node / air-gapped)

```bash
pip install tikhub-mcp
export TIKHUB_API_KEY=your_key
tikhub-mcp --platform tiktok --transport stdio        # single platform for Claude
tikhub-mcp --transport http --port 8000               # all platforms at http://localhost:8000/{platform}/mcp
```
Point `.mcp.json` at the local command instead of `mcp-remote`. Source: `~/PycharmProjects/TikHub_MCP`.

## Troubleshooting

- **401 / unauthorized** → `TIKHUB_API_KEY` missing/invalid, or out of credits (check user.tikhub.io).
- **`npx: command not found`** → install Node.js, or use the self-host / REST paths.
- **Tools don't appear** → run `/reload-plugins`; confirm `.mcp.json` is valid JSON.
- **Too many tools / context bloat** → enable fewer platforms.

## Red flags

- Trying to build or vendor an MCP server — don't; use the hosted one.
- Enabling all 16 platforms by default — bloats the tool surface.
