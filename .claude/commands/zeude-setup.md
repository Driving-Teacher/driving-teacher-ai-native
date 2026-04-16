---
name: zeude-setup
description: Zeude 대시보드 셋업. agent_key를 입력하면 로컬 설정 + /zeude 스킬 설치까지 자동으로 완료.
allowed-tools: Bash, Read, Write
---

Zeude 모니터링 대시보드를 셋업한다.

## 진행

1. 사용자에게 agent_key를 물어본다:
   - "초대 링크에서 받은 agent_key를 붙여넣어주세요 (zd_로 시작하는 키)"
   - 입력값이 `zd_`로 시작하고 67자(zd_ + 64 hex)인지 검증

2. `~/.zeude/` 디렉토리에 설정 파일 생성:

```bash
mkdir -p ~/.zeude
echo "agent_key=<입력받은키>" > ~/.zeude/credentials
chmod 600 ~/.zeude/credentials
cat > ~/.zeude/config << 'EOF'
dashboard_url=https://zeude.vercel.app
EOF
```

3. `/zeude` 스킬 설치 (`~/.claude/commands/zeude.md`):

```bash
mkdir -p ~/.claude/commands
cat > ~/.claude/commands/zeude.md << 'SKILL_EOF'
---
name: zeude
description: Open Zeude dashboard (auto-login)
allowed-tools: Bash, Read
---

Open the Zeude monitoring dashboard in your browser with automatic authentication.

## Steps

1. Read agent key from `~/.zeude/credentials` (agent_key=zd_xxx)
2. Read dashboard_url from `~/.zeude/config`
3. POST to `{dashboard_url}/api/auth/ott` with `{"agentKey": "<agent_key>"}` → extract `token`
4. Open `{dashboard_url}/auth?ott={token}` in browser (`open` on macOS, `xdg-open` on Linux)

```bash
AGENT_KEY=$(grep "^agent_key=" ~/.zeude/credentials | cut -d'=' -f2)
DASHBOARD_URL=$(grep "^dashboard_url=" ~/.zeude/config 2>/dev/null | cut -d'=' -f2)
DASHBOARD_URL=${DASHBOARD_URL:-https://zeude.vercel.app}
OTT=$(curl -s -X POST "$DASHBOARD_URL/api/auth/ott" \
  -H "Content-Type: application/json" \
  -d "{\"agentKey\": \"$AGENT_KEY\"}" | jq -r '.token')
open "$DASHBOARD_URL/auth?ott=$OTT"
```

Execute these steps now. If any step fails, explain the error.
SKILL_EOF
```

4. 설치 확인 — OTT 발급 테스트:

```bash
AGENT_KEY=$(grep "^agent_key=" ~/.zeude/credentials | cut -d'=' -f2)
RESULT=$(curl -s -X POST "https://zeude.vercel.app/api/auth/ott" \
  -H "Content-Type: application/json" \
  -d "{\"agentKey\": \"$AGENT_KEY\"}")
echo "$RESULT" | jq .
```

- `token` 필드가 있으면 성공
- `error` 필드가 있으면 agent_key가 잘못된 것 → 다시 입력 안내

5. 성공 시 브라우저로 대시보드 열기:

```bash
OTT=$(echo "$RESULT" | jq -r '.token')
open "https://zeude.vercel.app/auth?ott=$OTT"
```

6. 완료 메시지:
```
셋업 완료!
- /zeude : 대시보드 열기 (자동 로그인)
- 세션은 7일간 유지됩니다
```
