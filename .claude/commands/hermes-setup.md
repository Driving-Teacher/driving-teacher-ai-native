---
name: hermes-setup
description: Hermes Agent 셋업. Slack 봇 + AI 에이전트를 내 PC에 설치. Mac/Windows 모두 지원.
allowed-tools: Bash, Read
---

Hermes Agent를 내 PC에 설치하고 Slack 봇으로 연결한다.

## 사전 준비 (수업 전 Admin이 안내)

팀원에게 미리 안내할 것:
1. Slack App 만들기 (아래 가이드 참고)
2. OpenRouter 계정 + 크레딧 ($5)

> 주의: API 키를 채팅창에 직접 입력하지 마세요! .env 파일에 직접 넣거나 hermes setup 명령어를 사용하세요.

## 진행

### Step 0: OS 확인

사용자에게 OS를 물어본다.

### Step 1: Hermes 설치

**Mac:**
```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup
source ~/.zshrc
```

**Windows (WSL 필요):**
```
먼저 WSL이 설치되어 있는지 확인하세요.

1. PowerShell(관리자)에서: wsl --install
2. 재부팅 후 Ubuntu 터미널 열기
3. Ubuntu 안에서 아래 실행:

curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup
source ~/.bashrc
```

### Step 2: Slack App 만들기

이 과정은 브라우저에서 해야 한다. 사용자에게 안내:

```
Slack App 만들기 (5분):

1. https://api.slack.com/apps → Create New App → From scratch
2. 이름: 자유 (예: 내이름-hermes), 워크스페이스: 회사 슬랙

3. App Home (왼쪽 메뉴):
   - App Display Name → Edit → 이름/username 입력 → Save

4. Socket Mode (왼쪽 메뉴):
   - Enable Socket Mode → 토큰 이름 입력 (예: hermes) → Generate
   - xapp-... 토큰 복사해두기

5. OAuth & Permissions (왼쪽 메뉴):
   - Bot Token Scopes에 추가:
     chat:write, im:history, im:read, im:write, app_mentions:read
   - 페이지 상단 Install to Workspace → 허용
   - xoxb-... 토큰 복사해두기

6. Event Subscriptions (왼쪽 메뉴):
   - Enable Events → On
   - Subscribe to bot events: message.im, app_mention
   - Save Changes
```

### Step 3: API 키 설정

사용자에게 어떤 API 키가 있는지 물어본다:
- OpenAI 키 (sk-...) → https://platform.openai.com/api-keys
- 또는 OpenRouter 키 (sk-or-...) → https://openrouter.ai/keys
- 또는 Anthropic 키 → https://console.anthropic.com/

키 3개를 ~/.hermes/.env에 넣는다:

```bash
# .env 파일 열기
cat >> ~/.hermes/.env << 'EOF'

# Slack
SLACK_BOT_TOKEN=<xoxb-... 토큰>
SLACK_APP_TOKEN=<xapp-... 토큰>

# LLM API 키 (아래 중 하나만 있으면 됨)
OPENAI_API_KEY=<sk-... 키>

# 모든 유저 허용
GATEWAY_ALLOW_ALL_USERS=true
EOF
```

> 주의: 위 명령어에서 <...> 부분을 실제 값으로 교체해야 한다. 사용자에게 각 값을 물어보고 대신 입력해준다.
> API 키는 Claude Code 채팅창에 절대 입력하지 말 것! .env 파일에 직접 넣는다.

OpenAI 키를 사용하는 경우, config.yaml에서 provider와 모델도 변경한다:

```bash
sed -i.bak 's|default: "anthropic/claude-opus-4.6"|default: "gpt-4o"|' ~/.hermes/config.yaml
sed -i.bak 's|provider: "auto"|provider: "openai"|' ~/.hermes/config.yaml
sed -i.bak 's|base_url: "https://openrouter.ai/api/v1"|base_url: "https://api.openai.com/v1"|' ~/.hermes/config.yaml
```

### Step 4: Gateway 시작

```bash
hermes gateway install
hermes gateway start
```

### Step 5: 테스트

사용자에게 슬랙에서 봇한테 DM으로 "안녕"을 보내라고 한다.

- 응답이 오면 → 성공!
- "No home channel" 메시지가 오면 → /sethome 입력
- 402 에러 → OpenRouter 크레딧 부족. 충전 안내.
- 응답 없음 → `hermes gateway status`로 상태 확인

### 완료 메시지

```
Hermes 셋업 완료!

슬랙에서 봇한테 DM으로 뭐든 요청하세요:
- "오늘 할 일 정리해줘"
- "이 코드 리뷰해줘"
- "매일 아침 9시에 날씨 알려줘" (자동 예약!)

유용한 명령어:
- hermes         : 터미널에서 직접 대화
- hermes gateway status : 봇 상태 확인
- hermes update   : 업데이트
```
