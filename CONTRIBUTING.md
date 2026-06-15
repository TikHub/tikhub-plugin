# Contributing to the TikHub Plugin

Thanks for helping improve the TikHub plugin for Claude Code! This plugin is a thin connector
over [TikHub](https://tikhub.io)'s API — most contributions are new/updated **skills** (Markdown)
and small helper scripts.

## Project layout

```
.claude-plugin/        plugin.json + marketplace.json (manifests — required)
.mcp.json              hosted-MCP server wiring (npx mcp-remote)
skills/<name>/SKILL.md  one folder per skill
bin/tikhub-find-endpoint     endpoint search CLI
scripts/validate-skills.sh   structural validator (run before every commit)
scripts/build-openapi-index.py   regenerates the bundled endpoint index
scripts/test-find-endpoint.sh    test for the search CLI
skills/tikhub-endpoint-discovery/references/openapi-index.json  bundled index
```

## Quick start for contributors

```bash
git clone <your-fork-url> && cd tikhub-plugin
export TIKHUB_API_KEY="your_key"          # only needed to call the API, not to edit skills
./scripts/validate-skills.sh              # must print "N passed, 0 failed"
claude --plugin-dir .                     # load the plugin locally to test
```

## Adding or editing a skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter:
   ```markdown
   ---
   name: <skill-name>          # must equal the folder name
   description: <trigger-rich one-liner — when should Claude use this?>
   ---
   ```
2. Follow the house structure used by existing skills: **Setup gate → action/workflow →
   verification gate → red flags → handoffs.** Every skill that calls the API must check
   `TIKHUB_API_KEY` in its setup gate.
3. Use **real, verified endpoints**. Find paths and params with:
   ```bash
   ./bin/tikhub-find-endpoint "<goal>" --platform <slug>
   ```
4. Keep pagination params accurate per platform (`max_cursor`/`offset`, `pagination_token`,
   `continuation_token`, `cursor`, `end_cursor`, `cursor`+`index`).
5. Add cost-awareness for anything that paginates or batches — TikHub bills per call.

### Adding a new platform skill

The de-scoped platforms (LinkedIn, Reddit, Bilibili, Weibo, WeChat, Kuaishou, Zhihu, Lemon8,
Toutiao, Xigua, PiPiXia) are reachable today via `tikhub-endpoint-discovery`. To promote one to a
dedicated skill, mirror an existing platform skill (e.g. `skills/instagram/SKILL.md`) and, if it
should be MCP-enabled by default, add its server entry to `.mcp.json` (slug from the `tikhub-mcp`
skill's table).

## Refreshing the endpoint index

When TikHub bumps the API version, regenerate the bundled index:

```bash
python3 scripts/build-openapi-index.py            # fetches the live spec
# offline fallback:
# python3 scripts/build-openapi-index.py --spec /path/to/openapi.json
```

Commit the updated `skills/tikhub-endpoint-discovery/references/openapi-index.json`.

## Before you open a PR

- [ ] `./scripts/validate-skills.sh` → `0 failed`
- [ ] `./scripts/test-find-endpoint.sh` → `all passed`
- [ ] `claude plugin validate .` → passes
- [ ] No secrets/API keys committed (keys come from `$TIKHUB_API_KEY` at runtime only)
- [ ] One logical change per commit, with a clear message

## Conventions

- Skills are Markdown only — no secrets, no network calls baked into examples beyond `curl`/SDK
  snippets the user runs themselves.
- Match the tone and section structure of existing skills.
- Bump `version` in both `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
  (metadata + plugin) for releases, and add a `CHANGELOG.md` entry.

## License

By contributing, you agree your contributions are licensed under the [MIT License](LICENSE).
