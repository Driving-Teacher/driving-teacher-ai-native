#!/bin/bash
# Hackle MCP 셋업 스크립트
# 실행: bash scripts/setup-hackle-mcp.sh
# Claude Code 안에서: ! bash scripts/setup-hackle-mcp.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
KEY_DIR="$HOME/.config/hackle-mcp"
KEY_FILE="$KEY_DIR/api_key"
SETTINGS_LOCAL="$REPO_DIR/.claude/settings.local.json"

echo "=== Hackle MCP 설정 ==="
echo ""

# 1. Node.js 확인
echo "[ 1/4 ] Node.js 확인..."
if command -v node &> /dev/null; then
    echo "  ✅ Node.js $(node --version)"
else
    echo "  ❌ Node.js가 설치되어 있지 않습니다."
    echo "  먼저 bash scripts/setup-mac.sh 를 실행해주세요."
    exit 1
fi

# 2. API Key 입력받기
echo "[ 2/4 ] Hackle API Key 입력..."
echo ""
echo "  Hackle 대시보드 → 설정 → API 키에서 확인할 수 있습니다."
echo "  (팀 슬랙에서 공유받은 키를 붙여넣으세요)"
echo ""
read -r -s -p "  API Key: " API_KEY
echo ""

if [ -z "$API_KEY" ]; then
    echo "  ❌ API Key가 입력되지 않았습니다."
    exit 1
fi

# 3. API Key를 레포 밖 로컬 파일에 저장 (.mcp.json 은 scripts/hackle-mcp.sh 가 이 파일을 읽음)
echo ""
echo "[ 3/4 ] API Key 로컬 저장..."

mkdir -p "$KEY_DIR"
chmod 700 "$KEY_DIR"
( umask 077 && printf '%s' "$API_KEY" > "$KEY_FILE" )
echo "  ✅ $KEY_FILE 에 저장 완료 (레포에는 기록하지 않습니다)"

# 4. settings.local.json에서 활성화
echo "[ 4/4 ] MCP 서버 활성화..."

if [ ! -f "$SETTINGS_LOCAL" ]; then
    mkdir -p "$(dirname "$SETTINGS_LOCAL")"
    echo '{}' > "$SETTINGS_LOCAL"
fi

node -e "
const fs = require('fs');
const data = JSON.parse(fs.readFileSync('$SETTINGS_LOCAL', 'utf8'));
const servers = data.enabledMcpjsonServers || [];
if (!servers.includes('hackle-mcp')) {
  servers.push('hackle-mcp');
  data.enabledMcpjsonServers = servers;
  fs.writeFileSync('$SETTINGS_LOCAL', JSON.stringify(data, null, 2) + '\n');
  console.log('  ✅ settings.local.json에 hackle-mcp 활성화 완료');
} else {
  console.log('  ✅ 이미 활성화되어 있습니다');
}
"

echo ""
echo "=== 설정 완료! ==="
echo ""
echo "다음 단계:"
echo "  1. Claude Code를 재시작하세요 (Cmd+R 또는 claude 다시 실행)"
echo "  2. /experiment-share 를 입력하면 실험 결과를 조회·공유할 수 있습니다"
echo ""
