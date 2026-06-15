# Security Policy

## API keys

This plugin talks to [TikHub](https://tikhub.io) using **your** API key. Handle it carefully:

- The key is read **only** from the `TIKHUB_API_KEY` environment variable at runtime. It is never
  hardcoded, logged, or committed by this plugin.
- **Never** paste your key into a skill file, a commit, an issue, or a PR. If a key is exposed,
  rotate it immediately at <https://user.tikhub.io> (you can keep up to 20 keys and revoke any).
- In `.mcp.json`, the key is passed via `${TIKHUB_API_KEY}` substitution — keep it that way; do not
  inline a literal key.
- The repository's `.gitignore` excludes local state (`.claude/`, `.venv/`, `.idea/`). Do not
  remove those exclusions or add files that may contain credentials.

## Scope

This plugin is a connector: it ships Markdown skills, a small endpoint-search CLI, and an
OpenAPI-derived index. It performs no network calls on its own — requests are made by `curl`, the
`tikhub` SDK, or TikHub's hosted MCP, all driven by the user. Data returned by TikHub is subject to
TikHub's terms and the source platforms' terms of service.

## Reporting a vulnerability

If you find a security issue in this plugin (e.g. a skill that could leak a key, or a flaw in the
helper scripts):

1. **Do not** open a public issue with exploit details.
2. Email **tikhub.io@proton.me** with a description, affected files, and reproduction steps.
3. We aim to acknowledge within a few business days and will coordinate a fix and disclosure.

For vulnerabilities in the **TikHub API, SDK, or hosted MCP** (not this plugin), report them
through TikHub's official channels at <https://tikhub.io>.

## Supported versions

Only the latest released version of the plugin receives security fixes.
