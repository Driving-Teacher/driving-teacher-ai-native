#!/bin/bash
# Hackle MCP 셋업 스크립트
# 실행: bash scripts/setup-hackle-mcp.sh
# Claude Code 안에서: ! bash scripts/setup-hackle-mcp.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
MCP_JSON="$REPO_DIR/.mcp.json"
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
read -p "  API Key: " API_KEY

if [ -z "$API_KEY" ]; then
    echo "  ❌ API Key가 입력되지 않았습니다."
    exit 1
fi

# 3. .mcp.json에 hackle-mcp 추가
echo ""
echo "[ 3/4 ] Hackle MCP 서버 등록..."

if [ ! -f "$MCP_JSON" ]; then
    echo '{"mcpServers":{}}' > "$MCP_JSON"
fi

node -e "
const fs = require('fs');
const data = JSON.parse(fs.readFileSync('$MCP_JSON', 'utf8'));
data.mcpServers = data.mcpServers || {};
data.mcpServers['hackle-mcp'] = {
  type: 'stdio',
  command: 'npx',
  args: ['-y', '@hackle-io/hackle-mcp@latest'],
  env: { API_KEY: '$API_KEY' }
};
fs.writeFileSync('$MCP_JSON', JSON.stringify(data, null, 2) + '\n');
"
echo "  ✅ .mcp.json에 hackle-mcp 등록 완료"

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
