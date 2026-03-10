FROM node:20-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl sudo ca-certificates \
    wget \
    gnupg2 \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ=Asia/Tokyo

COPY package.json tsconfig.json ./
RUN npm install

# ============================================
# AI CLIツールのインストール
# ============================================
# 注意: ツールの管理方法
# - Claude Code: devcontainer.jsonのfeaturesで管理（公式Feature使用）
# - Gemini CLI: devcontainer.jsonのpostCreateCommandでnpm経由インストール
# - Codex CLI: devcontainer.jsonのpostCreateCommandでnpm経由インストール
# ============================================

RUN groupmod -n appuser node \
  && usermod -l appuser -d /home/appuser -m -s /bin/bash node \
  && echo "appuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/99-appuser \
  && chmod 440 /etc/sudoers.d/99-appuser \
  && chown -R appuser:appuser /app

USER appuser

RUN echo "" >> ~/.bashrc \
  && echo "if [ -f /app/.bashrc_aliases ]; then" >> ~/.bashrc \
  && echo "    . /app/.bashrc_aliases" >> ~/.bashrc \
  && echo "fi" >> ~/.bashrc

CMD ["sleep", "infinity"]