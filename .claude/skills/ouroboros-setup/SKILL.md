---
name: ouroboros-setup
description: Ouroboros 플러그인 설치 + 첫 사용. 인터뷰로 내 일을 명세화하고 에이전트로 만든다. "/ouroboros-setup" 또는 "오우로보로스 설치", "ouroboros 셋업" 요청에 사용.
---

# Ouroboros 셋업 — 내 일을 에이전트가 알게 만들기

> Ouroboros는 "막연한 내 일"을 인터뷰로 끌어내서 **PRD/Seed**로 만들고, AI가 그 명세대로 실행하게 만드는 도구.
> 이 스킬은 **설치 + 첫 호출**까지만 다룬다. 인터뷰/Seed 작성은 워크샵에서 라이브로.

---

## 정보

- **Marketplace**: `Q00/ouroboros` (GitHub 공개 repo)
- **Plugin slug**: `ouroboros@ouroboros`
- **사전 요구사항**: Claude Code **v2.0 이상** 설치됨 (`claude` 명령어 동작)
- **소요 시간**: 설치만 ~5분 / 튜토리얼 포함 ~15분
- **OS**: macOS / Linux / Windows 모두 지원

---

## STOP PROTOCOL

> 한 단계가 완료될 때까지 다음 단계를 시작하지 않는다.
> 막히면 Block 6(트러블슈팅)으로 가고, 그래도 안 풀리면 슬랙 `#ai-native`.

---

## Block 1: Claude Code 버전 확인 (~1분)

```bash
claude --version
```

**최소 요구**: `2.0.0` 이상. (Plugin 시스템은 2.x부터 안정 동작)

```json
AskUserQuestion({
  "questions": [{
    "question": "claude --version 출력이 어떻게 나오나요?",
    "header": "버전 확인",
    "options": [
      {"label": "2.0 이상이다", "description": "Block 2로"},
      {"label": "1.x 또는 더 낮다", "description": "업그레이드 필요"},
      {"label": "claude 명령어 자체가 없다", "description": "Claude Code 신규 설치 필요"}
    ]
  }]
})
```

### 업그레이드 (필요 시)

**Mac / Linux**

```bash
npm i -g @anthropic-ai/claude-code@latest
# 또는 pnpm
pnpm add -g @anthropic-ai/claude-code@latest
# 또는 Homebrew (Mac)
brew upgrade claude-code
```

**Windows (PowerShell)**

```powershell
npm i -g @anthropic-ai/claude-code@latest
```

→ npm이 없다고 나오면 먼저 [Node.js](https://nodejs.org) 설치 (LTS 버전) 후 PowerShell **완전 종료 → 재시작** → 위 명령 다시.

---

## Block 2: Marketplace 등록 (~1분)

Claude Code 켜고:

```
/plugin marketplace add Q00/ouroboros
```

### 정상 응답 예시

```
✓ Added marketplace "ouroboros"
```

### 응답이 모호하거나 멈춘 것 같다면

- 30초 기다려도 응답 없으면 Ctrl+C → 다시 시도
- "marketplace not found" / 빨간 에러 → Block 6
- 응답이 한 줄도 없이 그냥 프롬프트로 돌아옴 → `/plugin marketplace list` 로 등록됐는지 확인. `ouroboros` 가 목록에 보이면 OK.

---

## Block 3: Plugin 설치 (~1분)

같은 Claude Code 세션에서:

```
/plugin install ouroboros@ouroboros
```

→ 설치 메시지 + 의존성 자동 설치 안내가 나옴. 이어서:

```
/reload-plugins
```

이러면 재시작 없이 바로 활성화됨. (`/reload-plugins` 가 "loaded N plugins" 같은 카운트 출력하면 성공)

---

## Block 4: 설치 검증 (~1분)

같은 세션에서 (재시작 안 해도 됨):

```
/ouroboros:welcome
```

### 성공 화면 예시

```
🐍 Welcome to Ouroboros
   Stop prompting. Start specifying.

   Available commands:
   • /ouroboros:tutorial   - 5-min hands-on
   • /ouroboros:interview  - clarify a vague task
   • /ouroboros:seed       - generate a spec
   ...
```

스킬 목록에 `ouroboros:welcome`, `ouroboros:interview`, `ouroboros:seed`, `ouroboros:tutorial` 같은 항목이 보이면 OK.

**안 보이면** → Block 6.

---

## Block 5: 첫 사용 — 어디서부터?

```json
AskUserQuestion({
  "questions": [{
    "question": "지금 ouroboros 어디까지 해볼까요?",
    "header": "첫 사용",
    "options": [
      {"label": "설치만 끝냄, 워크샵에서 실습", "description": "발표날 호스트와 같이 인터뷰 진행"},
      {"label": "튜토리얼 한 번 돌려보고 싶음 (추천)", "description": "/ouroboros:tutorial 실행 — 5~10분"},
      {"label": "바로 인터뷰 시작", "description": "/ouroboros:interview 로 내 일 명세화"}
    ]
  }]
})
```

**추천**: 워크샵 전 `/ouroboros:tutorial` 한 번 돌려두면 발표 날 진도 훨씬 빠름.

---

## Block 6: 트러블슈팅

### ❌ `/plugin` 명령어가 없다고 나옴

1. **버전 재확인**: `claude --version` → 2.0 미만이면 Block 1 업그레이드
2. **이미 2.0 이상인데도 없다면**:
   - Mac/Linux: `which claude` — 설치 경로 확인. `/usr/local/bin/claude` 가 아니면 PATH 충돌 의심. `npm root -g` 하위 경로 우선
   - Windows: 새 PowerShell **관리자 권한**으로 다시 열고 `where.exe claude` 실행. 여러 경로 잡히면 구버전 우선일 수 있음
3. 그래도 안 되면 Claude Code 완전 재설치 (`npm uninstall -g @anthropic-ai/claude-code` → `npm i -g @anthropic-ai/claude-code@latest`)

### ❌ Marketplace add 가 안 됨

- **GitHub 접근**: 사내 VPN/방화벽 확인
- **진단 (Mac/Linux)**: `curl -s https://api.github.com/repos/Q00/ouroboros | head -5` — repo 정보 나오면 GitHub 자체는 OK
- **진단 (Windows PowerShell)**: `Invoke-WebRequest https://api.github.com/repos/Q00/ouroboros | Select-Object -First 1 StatusCode` — `200` 이면 OK
- **403 / rate limit** 응답 → 잠시 후(~10분) 재시도, 또는 GitHub 로그인된 토큰 환경변수 (`GH_TOKEN`) 설정

### ❌ `/ouroboros:welcome` 호출했는데 스킬 목록에 안 보임

1. `/reload-plugins` 한 번 더 실행
2. settings.json에 enable 됐는지 확인:
   - **Mac/Linux**: `cat ~/.claude/settings.json | grep ouroboros`
   - **Windows (PowerShell)**: `Get-Content $env:USERPROFILE\.claude\settings.json | Select-String ouroboros`
   - `"ouroboros@ouroboros": true` 가 보여야 함. 없으면 Block 3 재시도
3. **마지막 수단**: Claude Code 완전 종료 (Ctrl+D 또는 `exit`) 후 새 세션. Windows VSCode에서 쓰는 분은 **VSCode 자체 재시작**

### 🔁 다시 받고 싶을 때 (제거 후 재설치)

```
/plugin uninstall ouroboros@ouroboros
/plugin marketplace update ouroboros
/plugin install ouroboros@ouroboros
/reload-plugins
```

---

## Block 7: 완료 보고 + 마무리

설치 다 끝났으면 슬랙 `#ai-native` 에 이 한 줄 보고:

```
✅ /ouroboros-setup 완료 — [내 이름] / [Mac or Windows]
```

### 마무리 안내

```
설치 완료. Ouroboros가 준비됐습니다.

기억할 것 3개:
  1. ouroboros:interview — 막연한 내 일을 끌어낸다
  2. ouroboros:seed — 인터뷰 결과를 실행 가능한 명세로
  3. ouroboros:run — 명세대로 AI가 실행

워크샵 전 /ouroboros:tutorial 한 번 돌려보면
발표 날 진도가 훨씬 빨라집니다.
```

---

## 부록: 인터뷰가 길어지는 건 정상

> ⚠️ 이건 오류가 아니라 정상 동작.

처음 인터뷰는 30분 이상 걸릴 수 있음. Ouroboros가 세션 상태 보존하니 휴식 후 이어가도 됨.
짧게 끝내고 싶으면 워크샵 라이브에서 호스트 가이드 흐름 따라하기.

---

## 호스트(승아) 메모

- **이 스킬은 설치까지만.** 인터뷰/Seed/Run 워크플로우는 워크샵 라이브에서 시연
- **발표 초반 (slide 02 셋업 시간)에 백그라운드로 진행** — cliproxy OAuth와 동시에. 깔리는 동안 회고/본론 진행
- 5.15 핸즈온 시작 전까지 끝나야 함. 못 끝낸 분 → 페어로 같이
- **막힌 사람 처리**:
  - 1순위: 같은 OS 사용자 페어로 같이 보기
  - 2순위: 슬랙 `#ai-native` 에 화면 캡처 + 에러 메시지 공유 → 호스트가 직접 봄
  - 3순위: cliproxy 환경변수 충돌 의심 (Block 6의 PATH 진단 같이)
- Marketplace `Q00/ouroboros` 는 GitHub 공개 repo. 별도 권한 부여 필요 없음
- Windows 사용자는 **PowerShell 관리자 모드** + **세션 완전 종료**가 함정. 미리 멘트 준비
- **사전 숙제로 돌리는 옵션도 가능** — 1주 전 슬랙 안내 + 완료 보고. 단, 발표날 안 한 사람 있을 수 있으니 발표 초반 백그라운드 셋업이 안전
