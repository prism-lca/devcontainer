# Shared PRISM dev container image: the agent CLIs plus Python, charting and
# slide tooling, so codespaces don't spend minutes installing them.
# Repo-specific setup (MCP servers, skills, agents) stays in each repo.
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Node.js (with npm and npx) from the official image.
COPY --from=node:24-bookworm-slim /usr/local/ /usr/local/

# The system Python is externally managed (PEP 668), so packages come from apt.
# LibreOffice renders decks to PDF and poppler splits them into PNGs, so agents
# can check slides visually; Liberation fonts match Arial metrics.
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      gh python3-pip python3-matplotlib python3-pandas \
      libreoffice-impress poppler-utils fonts-liberation \
 && rm -rf /var/lib/apt/lists/*

# CLIs and python-pptx go into vscode's home, so the user can update them
# without sudo (Claude Code updates itself in place).
USER vscode
ENV NPM_CONFIG_PREFIX=/home/vscode/.npm-global
ENV PATH=/home/vscode/.npm-global/bin:/home/vscode/.local/bin:$PATH
RUN npm install -g @anthropic-ai/claude-code @openai/codex opencode-ai \
 && python3 -m pip install --user --break-system-packages --no-cache-dir python-pptx
USER root
