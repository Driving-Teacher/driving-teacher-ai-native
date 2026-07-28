---
name: hermes-setup
description: Hermes Agent 셋업. Slack 봇 + AI 에이전트를 내 PC에 설치. Mac/Windows 모두 지원.
allowed-tools: Bash, Read, AskUserQuestion
---

Hermes Agent를 내 PC에 설치하고 Slack 봇으로 연결한다.

> **소요 시간**: 처음 셋업 ~30분 (Slack App 만들기 5분 + Hermes 설치/설정 15분 + 테스트 10분)
> **막히면**: 슬랙 `#ai-native` 에 OS + 어느 Step + 에러 메시지 캡처

## 사전 준비

팀원에게 미리 안내할 것:
1. Slack 워크스페이스 admin 권한 (또는 admin이 사전에 App 등록 허용)
2. **API 키 1개** — 아래 중 하나만:
   - OpenAI 키 (sk-...) → https://platform.openai.com/api-keys
   - OpenRouter 키 (sk-or-...) → https://openrouter.ai/keys + 크레딧 $5
   - Anthropic 키 (sk-ant-...) → https://console.anthropic.com/

> 🚨 **API 키는 채팅창에 직접 입력 금지** — `.env` 파일에만 저장. 슬랙 공개 채널 X.

## 진행

### Step 0: OS 확인 + 사전 점검

```json
AskUserQuestion({
  "questions": [{
    "question": "OS 알려주세요.",
    "header": "OS",
    "options": [
      {"label": "Mac (Intel/Apple Silicon)", "description": "표준 흐름"},
      {"label": "Windows + WSL Ubuntu", "description": "WSL 안에서 Mac과 동일하게 진행"},
      {"label": "Windows native (WSL X)", "description": "WSL 먼저 설치 필요"}
    ],
    "multiSelect": false
  }]
})
```

**Windows native 선택 시**: Step 0.5로 분기 → WSL 설치 (`wsl --install`) → 재부팅 → Ubuntu 터미널에서 다시 시작.

### Step 1: Hermes 설치

**Mac:**
```bash
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup
source ~/.zshrc
hermes --version    # 검증 — 버전 출력되어야 OK
```

**Windows (WSL Ubuntu):**
```bash
# WSL Ubuntu 안에서
curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash -s -- --skip-setup
source ~/.bashrc
hermes --version    # 검증
```

> ❌ **`hermes --version` 이 "command not found"** → PATH 문제. 새 터미널 열고 재시도. 그래도 안 되면 `which hermes` 또는 `~/.hermes/bin/` 확인.

### Step 2: Slack App 만들기 (브라우저, ~5분)

```
1. https://api.slack.com/apps → Create New App → From scratch
2. 이름: 자유 (예: 내이름-hermes), 워크스페이스: 회사 슬랙
3. App Home (왼쪽 메뉴):
   - App Display Name → Edit → 이름/username 입력 → Save
4. Socket Mode:
   - Enable Socket Mode → 토큰 이름 (예: hermes) → Generate
   - xapp-... 토큰 안전하게 복사 (메모장 X, .env 직행)
5. OAuth & Permissions:
   - Bot Token Scopes 추가: chat:write, im:history, im:read, im:write, app_mentions:read
   - 페이지 상단 Install to Workspace → 허용
   - xoxb-... 토큰 복사
6. Event Subscriptions:
   - Enable Events → On
   - Subscribe to bot events: message.im, app_mention
   - Save Changes
   - ⚠️ scopes 변경 후 OAuth 페이지에서 "Reinstall to Workspace" 한 번 더 (안 하면 권한 미반영)
```

### Step 3: API 키 설정 (.env)

> 🚨 **다시 강조**: 아래 명령은 PC 터미널에서 직접 실행. **<...> 부분을 실제 키로 교체**해서 입력. Claude Code 채팅창 X.

#### Mac / WSL Ubuntu

```bash
# 기존 .env 백업 (덮어쓰기 방지)
cp ~/.hermes/.env ~/.hermes/.env.bak 2>/dev/null

# .env 파일 새로 작성 (중복 방지 — append X)
cat > ~/.hermes/.env << 'EOF'
# Slack
SLACK_BOT_TOKEN=<여기에 xoxb-... 붙여넣기>
SLACK_APP_TOKEN=<여기에 xapp-... 붙여넣기>

# LLM API 키 (아래 중 하나만, 나머지는 # 주석 처리)
OPENAI_API_KEY=<sk-... 또는 비워둠>
# OPENROUTER_API_KEY=<sk-or-... 키>
# ANTHROPIC_API_KEY=<sk-ant-... 키>

# 게이트웨이 보안
# GATEWAY_ALLOW_ALL_USERS=true 는 워크스페이스의 모든 슬랙 사용자가 봇에 DM 가능
# 회사 워크스페이스라면 OK. 외부 인원 섞여있으면 false 또는 ALLOWED_USERS 화이트리스트 사용
GATEWAY_ALLOW_ALL_USERS=true
EOF

# 권한 잠그기 (다른 사용자가 못 읽게)
chmod 600 ~/.hermes/.env
```

#### Windows native PowerShell (WSL 안 쓰는 경우)

> 권장 X — WSL 사용 추천. 그래도 native 선택 시:

```powershell
# 폴더 만들기
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.hermes"

# 메모장으로 .env 직접 만들기
notepad "$env:USERPROFILE\.hermes\.env"
# → 위 EOF 블록 내용을 그대로 붙여넣고 저장
```

### Step 3.5: API 키별 config.yaml 분기

#### OpenAI 키 (sk-...) 사용 시

```bash
sed -i.bak 's|default: "anthropic/claude-opus-4.6"|default: "gpt-4o"|' ~/.hermes/config.yaml
sed -i.bak 's|provider: "auto"|provider: "openai"|' ~/.hermes/config.yaml
sed -i.bak 's|base_url: "https://openrouter.ai/api/v1"|base_url: "https://api.openai.com/v1"|' ~/.hermes/config.yaml
```

#### Anthropic 키 (sk-ant-...) 사용 시

```bash
sed -i.bak 's|default: ".*"|default: "anthropic/claude-sonnet-4-5"|' ~/.hermes/config.yaml
sed -i.bak 's|provider: ".*"|provider: "anthropic"|' ~/.hermes/config.yaml
sed -i.bak 's|base_url: ".*"|base_url: "https://api.anthropic.com/v1"|' ~/.hermes/config.yaml
```

#### OpenRouter 키 (sk-or-...) 사용 시

```bash
# config.yaml 기본값이 OpenRouter라 변경 불필요
# 키만 .env에 OPENROUTER_API_KEY 로 박으면 OK
```

> 💡 **`sed -i.bak`** 은 Mac/Linux 둘 다 동작. `.bak` 백업 파일 자동 생성됨 (지워도 됨).

### Step 4: Gateway 시작

```bash
hermes gateway install
hermes gateway start
```

> **`hermes gateway install`** = OS 서비스 등록 (Mac launchd / Linux systemd). 재부팅해도 자동 시작.
> Windows WSL: WSL 시작 시 자동 실행 안 됨 → 매번 `wsl` 켜고 `hermes gateway start` 수동.

### Step 5: 테스트

```bash
# 상태 확인 (먼저)
hermes gateway status
# → "running" 이면 OK. 아니면 다음 단계 안 됨.
```

상태 OK면 슬랙에서 봇한테 **DM**으로 "안녕" 보내기:

| 결과 | 의미 / 다음 행동 |
|---|---|
| 봇 응답 옴 | ✅ 성공! Step 6 (주의사항) |
| "No home channel" | `/sethome` 입력 |
| 402 에러 | API 크레딧 부족 — OpenAI/OpenRouter 잔액 충전 |
| 응답 없음 (~30초 대기 후) | `hermes gateway status` 재확인 → 슬랙 #ai-native |

### Step 6: 주의사항

```
주의사항:

1. API 키 보안
   - .env 파일에만 저장. 슬랙/메모장 X
   - chmod 600 ~/.hermes/.env 권한 잠금

2. PC 꺼지면 봇도 꺼짐
   - Hermes는 내 PC에서 돌아감
   - PC 끄거나 재부팅하면 봇 응답 X
   - 자동 시작: hermes gateway install (한 번만)
   - 수동 시작: hermes gateway start

3. 크레딧 관리
   - OpenAI/OpenRouter 크레딧 떨어지면 402 에러
   - 잔액 확인: platform.openai.com/usage

4. Slack App 관련
   - scopes 추가하면 반드시 Reinstall to Workspace
   - Socket Mode 꺼지면 봇 메시지 못 받음
   - Event Subscriptions에서 message.im 빠뜨리면 DM 작동 X

5. GATEWAY_ALLOW_ALL_USERS
   - true: 회사 워크스페이스 전체가 봇에 DM 가능 (OK)
   - 외부 인원 섞인 워크스페이스라면 false + ALLOWED_USERS 명시
```

### 완료 메시지

```
✅ Hermes 셋업 완료!

슬랙에서 봇한테 DM으로 뭐든 요청하세요:
- "오늘 할 일 정리해줘"
- "이 코드 리뷰해줘"
- "매일 아침 9시에 날씨 알려줘" (자동 예약!)

유용한 명령어:
- hermes                  : 터미널에서 직접 대화
- hermes gateway start    : 봇 시작 (PC 재부팅 후)
- hermes gateway status   : 봇 상태 확인
- hermes update           : 업데이트

더 많은 유스케이스: /hermes-usecases

막히면 슬랙 #ai-native 에 OS + Step + 에러 메시지 공유.
```

---

## 호스트(승아) 메모

- 신규 입사자 같은 신입은 Step 0에서 OS 확인 → Mac/WSL/Windows native 분기 명확히
- **Windows native는 권장 X** — WSL Ubuntu가 훨씬 안정적
- API 키 발급은 본인 책임. Anthropic 키 받기 어려우면 OpenAI/OpenRouter 추천 (둘 다 카드 등록만)
- Slack App "Reinstall to Workspace"가 가장 자주 빠뜨리는 부분
- 막힌 사람 처리:
  1. `hermes gateway status` 출력 + `cat ~/.hermes/.env` 출력 (키 가린 채) 슬랙 공유
  2. `tail ~/.hermes/logs/gateway.log` 마지막 50줄
  3. 같은 OS 페어 호출 또는 호스트 화면 공유
