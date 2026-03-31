#!/bin/bash
# Google Drive MCP 서버 wrapper
# 사용자별 홈 디렉토리를 자동으로 사용합니다
export GDRIVE_OAUTH_PATH="$HOME/.config/mcp-gdrive/gcp-oauth.keys.json"
export GDRIVE_CREDS_DIR="$HOME/.config/mcp-gdrive"
exec npx -y @modelcontextprotocol/server-gdrive "$@"
