#!/bin/bash
# Hackle MCP 서버 wrapper
# API 키는 레포 밖 사용자 로컬 파일(~/.config/hackle-mcp/api_key)이나
# HACKLE_API_KEY 환경변수에서 읽습니다. (설정: bash scripts/setup-hackle-mcp.sh)
KEY_FILE="$HOME/.config/hackle-mcp/api_key"

if [ -z "$HACKLE_API_KEY" ] && [ -f "$KEY_FILE" ]; then
    HACKLE_API_KEY="$(tr -d '\r\n' < "$KEY_FILE")"
fi

if [ -z "$HACKLE_API_KEY" ]; then
    echo "Hackle API 키가 없습니다. bash scripts/setup-hackle-mcp.sh 를 먼저 실행하세요." >&2
    exit 1
fi

export API_KEY="$HACKLE_API_KEY"
exec npx -y @hackle-io/hackle-mcp@latest "$@"
