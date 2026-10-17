# Shared PRISM dev container image: the agent CLIs plus Python, charting and
# slide tooling, so codespaces don't spend minutes installing them.
# Every new codespace downloads the whole image, so keep it small.
# Repo-specific setup (MCP servers, skills, agents) stays in each repo.
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Node.js (with npm and npx) from the official image.
COPY --from=node:24-bookworm-slim /usr/local/ /usr/local/

# The system Python is externally managed (PEP 668), so packages come from apt.
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      gh python3-pip python3-matplotlib python3-pandas \
 && rm -rf /var/lib/apt/lists/*

# CLIs and python-pptx go into vscode's home, so the user can update them
# without sudo (Claude Code updates itself in place).
USER vscode
ENV NPM_CONFIG_PREFIX=/home/vscode/.npm-global
ENV PATH=/home/vscode/.npm-global/bin:/home/vscode/.local/bin:$PATH
# Lets scripts require() global packages such as pptxgenjs.
ENV NODE_PATH=/home/vscode/.npm-global/lib/node_modules
# npm also installs opencode's "baseline" build for CPUs without AVX2, which
# codespace machines don't need, and keeps every tarball in its cache.
RUN npm install -g @anthropic-ai/claude-code @openai/codex opencode-ai pptxgenjs \
 && rm -rf "$NPM_CONFIG_PREFIX"/lib/node_modules/opencode-linux-*-baseline* \
      "$NPM_CONFIG_PREFIX"/lib/node_modules/opencode-ai/node_modules/opencode-linux-*-baseline* \
 && npm cache clean --force \
 && python3 -m pip install --user --break-system-packages --no-cache-dir python-pptx
USER root
