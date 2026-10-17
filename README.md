# devcontainer

Shared dev container image for PRISM repos: Claude Code, Codex, opencode,
Node.js, the GitHub CLI, Python with matplotlib and pandas, python-pptx,
LibreOffice Impress and poppler.

Use it from a repo's `.devcontainer/devcontainer.json`:

```json
{
  "image": "ghcr.io/prism-lca/prism-devcontainer:latest"
}
```

Pin a dated tag (e.g. `:2026-10-17`) instead of `:latest` to stop updates.

The image is rebuilt on every change to the `Dockerfile` and weekly.
Repo-specific setup (MCP servers, skills, agents) belongs in each repo, not here.
