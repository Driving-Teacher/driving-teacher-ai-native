#!/bin/bash
# Google Drive MCP 셋업 스크립트
# 한 번만 실행하면 됩니다

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
CREDS_DIR="$HOME/.config/mcp-gdrive"

echo "=== Google Drive MCP 설정 ==="
echo ""

# 1. 디렉토리 생성
mkdir -p "$CREDS_DIR"

# 2. OAuth 키 복사
cp "$REPO_DIR/configs/gcp-oauth.keys.json" "$CREDS_DIR/gcp-oauth.keys.json"
echo "✓ OAuth 키 복사 완료"

# 3. 인증 플로우 실행
echo ""
echo "브라우저가 열립니다. Google 계정으로 로그인 후 승인해주세요."
echo ""
GDRIVE_OAUTH_PATH="$CREDS_DIR/gcp-oauth.keys.json" \
GDRIVE_CREDS_DIR="$CREDS_DIR" \
npx -y @modelcontextprotocol/server-gdrive auth

echo ""
echo "✓ 설정 완료! Claude Code를 재시작하면 Google Drive MCP를 사용할 수 있습니다."
