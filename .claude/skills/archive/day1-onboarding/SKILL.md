---
name: day1-onboarding
description: AI Native Camp Week 1 실습. Claude Code 체험 → MCP 연결 → 나만의 첫 스킬 만들기. "1일차", "Day 1", "온보딩" 요청에 사용.
---

# Week 1: 체험 + MCP + 첫 스킬

이 스킬이 호출되면 아래 3개 Block을 **순서대로** 진행한다.
각 Block이 끝나면 **AskUserQuestion**으로 다음으로 넘어갈지 물어본다.

---

## STOP PROTOCOL

> **절대 한 번에 여러 Block을 진행하지 않는다.**
> 하나의 Block이 완료될 때까지 다음 Block을 시작하지 않는다.
> 사용자의 응답을 기다린 후에만 진행한다.
> **막히면 5분 이상 붙잡지 않고 다음으로** — 호스트(승아)에게 슬랙 #ai-native-camp DM.

---

## Block 0: 사전 점검 (~2분)

> 박주영처럼 Claude Code 처음 켜는 분이라면 이 Block부터.

### 1. 환경 확인

```json
AskUserQuestion({
  "questions": [{
    "question": "현재 환경 알려주세요.",
    "header": "OS/도구",
    "options": [
      {"label": "Mac, 터미널에서 claude 실행 중", "description": "표준 흐름"},
      {"label": "Windows, PowerShell에서 claude 실행 중", "description": "OS 분기 활성화"},
      {"label": "VSCode 확장에서 Claude Code 사용 중", "description": "터미널이 VSCode 안에 있음"},
      {"label": "터미널 켜본 적 없음", "description": "호스트에게 도움 요청 필요"}
    ],
    "multiSelect": false
  }]
})
```

마지막 옵션이면 "호스트에게 화면 공유 요청" 안내 후 일시 정지.

### 2. claude 명령어 동작 확인

```bash
claude --version
```

→ `2.0.0` 이상이면 OK. 미만이거나 명령어 없음 → 슬랙 #ai-native-camp 에 OS와 함께 보고. 호스트가 화면 공유로 도움.

### 3. 작업 폴더 확인

박주영이 어느 폴더에서 시작할지 정함:

- **Mac/Linux**: `~/Documents/driving-teacher-day1` (호스트가 사전 안내)
- **Windows**: `%USERPROFILE%\Documents\driving-teacher-day1`

```bash
mkdir -p ~/Documents/driving-teacher-day1 && cd ~/Documents/driving-teacher-day1
```

(Windows PowerShell)
```powershell
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\Documents\driving-teacher-day1"; cd "$env:USERPROFILE\Documents\driving-teacher-day1"
```

→ 이 폴더 안에 Block 1의 `output/` 도 자동 생성됨.

---

## Block 1: Claude Code 첫 체험 (~15분)

### 목표
Claude Code가 **내 컴퓨터에서 직접 파일을 읽고 쓸 수 있다**는 것을 체감.

### 진행

1. 먼저 인사하고 현재 프로젝트 구조를 보여준다:

```
안녕하세요! AI Native Camp Week 1 실습을 시작합니다.

먼저, Claude Code가 여러분의 컴퓨터에서 직접 동작한다는 걸 보여드릴게요.
```

2. 프로젝트의 파일/폴더 구조를 간단히 탐색해서 보여준다.

3. AskUserQuestion으로 체험할 업무를 선택하게 한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "Claude Code로 뭘 시켜볼까요? 하나 골라보세요.",
    "header": "첫 체험",
    "options": [
      {"label": "데이터 정리", "description": "표나 리스트를 정리해줘"},
      {"label": "문서 초안", "description": "안내문/보고서 초안 만들어줘"},
      {"label": "아이디어 브레인스토밍", "description": "아이디어 5개 내줘"},
      {"label": "내 업무 직접 말할게", "description": "자유롭게 시켜볼래요"}
    ],
    "multiSelect": false
  }]
})
```

4. 선택한 업무를 실행하되, **파일을 직접 생성**해서 결과를 저장한다.
   (이것이 ChatGPT와의 차이 — 답변을 복사할 필요 없이 파일이 바로 생긴다)
   - 파일은 `output/` 폴더에 저장 (Claude가 폴더 없으면 자동 생성)
   - 실패 시 `mkdir -p output` (Mac/Linux) / `mkdir output` (Windows PowerShell) 수동 생성 후 재시도
   - **반드시 예시 데이터임을 명시**한다 ("이건 실제 데이터가 아니라 예시입니다. 실제 데이터를 쓰려면 다음 단계인 MCP 연결이 필요해요.")

5. 결과를 보여주고 "파일이 바로 생겼죠?"라고 설명.

6. **두 번째 체험** — Claude의 기억 시스템을 체험한다:

```
이번엔 더 실용적인 걸 해볼게요.
Claude Code에는 기억 시스템이 있습니다. 3가지예요.

1. CLAUDE.md — 프로젝트 규칙서. "이 프로젝트에서는 이렇게 해"를 적는 파일
2. Auto Memory — Claude가 대화하면서 알아서 적는 메모. "이 사람은 이런 걸 좋아하는구나"
3. ~/.claude/CLAUDE.md — 나의 전역 설정. 어떤 프로젝트에서든 적용

지금 Auto Memory를 직접 체험해볼게요!
```

- 사용자에게 "나는 [이름]이고 [역할]이야. 기억해둬"라고 입력하라고 안내
- Claude가 Auto Memory에 기록하는 과정을 보여준다
- "이제 새 세션을 열어도 Claude가 여러분을 기억합니다."
- **핵심 메시지**: "ChatGPT는 매번 처음부터 설명해야 하지만, Claude Code는 기억합니다. 이게 'AI가 출근한 것'의 의미예요."

7. 퀴즈로 핵심을 확인한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "Claude Code의 기억 시스템 — CLAUDE.md와 Auto Memory의 차이는?",
    "header": "Block 1 퀴즈",
    "options": [
      {"label": "CLAUDE.md는 내가 쓰고, Auto Memory는 Claude가 쓴다", "description": "작성 주체가 다르다"},
      {"label": "같은 파일이다", "description": "이름만 다른 같은 기능"},
      {"label": "Auto Memory는 한 번만 읽힌다", "description": "매 세션마다? 한 번만?"}
    ],
    "multiSelect": false
  }]
})
```

정답: 1번. CLAUDE.md는 **내가 직접 적는 매뉴얼**, Auto Memory는 **Claude가 대화하면서 알아서 적는 메모**. 둘 다 매 세션 시작 시 자동으로 읽힌다.

8. 다음으로 넘어갈지 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "첫 체험 어떠셨나요? MCP 연결로 넘어갈까요?",
    "header": "다음 단계",
    "options": [
      {"label": "넘어가자", "description": "MCP 연결 실습으로"},
      {"label": "하나 더 해볼래", "description": "다른 업무도 시켜보고 싶어"}
    ],
    "multiSelect": false
  }]
})
```

---

## Block 2: MCP 연결 (~25분)

### 목표
외부 도구(채널톡 or 노션)를 Claude Code에 **연결**해서, AI가 내 도구의 데이터를 읽을 수 있게 한다.

### 진행

1. MCP 개념 간단 설명:

```
MCP는 외부 도구를 Claude Code에 연결하는 방법입니다.

쉽게 말하면:
- 지금 Claude Code는 여러분 컴퓨터의 파일만 볼 수 있어요
- MCP를 연결하면 노션, 슬랙, 채널톡 같은 외부 서비스의 데이터도 읽을 수 있어요
- USB-C처럼 — 꽂으면 바로 쓸 수 있어요

예를 들어 노션 MCP를 연결하면:
"노션에서 지난달 회의록 찾아줘" 가 가능해집니다.

MCP는 수백 개가 있어요. 노션, 슬랙 말고도 구글시트, 지메일, 캘린더,
웹 검색 등 거의 모든 서비스에 MCP가 있습니다.

💡 웹 검색도 MCP로 연결할 수 있어요!
- Tavily MCP: AI 전용 검색 엔진. 검색 결과를 깔끔하게 요약해줍니다
- Claude Code 기본 웹 검색보다 정확하고 빠를 수 있어요
- "최신 뉴스 찾아줘", "경쟁사 분석해줘" 같은 리서치에 유용

"이런 것도 연결할 수 있어?" 싶으면 검색해보세요 — 거의 다 있어요!
```

⚠️ **반드시 개인 계정으로 먼저!** 회사 노션/슬랙은 Admin 권한으로 막힐 수 있어요.
개인 노션, 개인 Gmail 등으로 먼저 연결 → 성공하면 나중에 회사 도구로.

이 경고를 AskUserQuestion **전에** 반드시 말한다. 도구 선택 후가 아니라 선택 전에.

2. 어떤 도구를 연결할지 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "어떤 도구를 Claude Code에 연결해볼까요?",
    "header": "MCP 연결",
    "options": [
      {"label": "채널톡", "description": "고객 문의를 AI가 읽고 답변 초안을 만들 수 있음"},
      {"label": "노션", "description": "노션 문서를 AI가 검색하고 읽을 수 있음"},
      {"label": "슬랙", "description": "슬랙 메시지를 AI가 읽고 요약할 수 있음"},
      {"label": "웹 검색 (Tavily)", "description": "AI가 웹을 검색하고 결과를 요약. 리서치에 유용"},
      {"label": "다른 도구 검색", "description": "원하는 서비스의 MCP를 검색해서 연결 (구글시트, 지메일 등)"}
    ],
    "multiSelect": false
  }]
})
```

3. 선택한 도구의 MCP 서버를 검색하고 연결을 시도한다.
   - 연결 과정을 **단계별로 설명하면서** 진행
   - API 키 등이 필요하면 사용자에게 안내
   - 연결 후 **그 MCP로 할 수 있는 것**을 2~3개 구체적으로 알려준다:
     - 노션: 페이지 읽기, 검색, 데이터베이스 쿼리
     - 슬랙: 채널 메시지 읽기, 요약, 검색
     - 채널톡: 최근 문의 조회, 답변 초안
     - Google Drive: 문서 검색, 내용 읽기

### API 키 보안 안내

API 키를 발급받으면 **한 마디만 안내한다**:

```
참고: API 키는 비밀번호와 같아요.
- claude mcp add 명령어로 연결하면 안전하게 저장됩니다
- 키를 슬랙이나 메모장에 붙여넣지 마세요
- 대화창에 "내 키는 sk-xxx야"라고 직접 입력하지 마세요 — 로그에 남을 수 있어요
```

> 기술적 설명(.env, .gitignore 등)은 하지 않는다. 비개발자에게 혼란만 준다.
> `claude mcp add` 명령어가 키를 안전하게 저장한다는 것만 전달하면 충분.

### claude mcp add 실제 명령어 형식

서비스별 정확한 호출. 새 터미널에서 실행:

```bash
# Notion
claude mcp add notion --env NOTION_API_KEY=<발급받은_키> -- npx -y @modelcontextprotocol/server-notion

# Slack (Slack Bot Token + Team ID 필요)
claude mcp add slack --env SLACK_BOT_TOKEN=<토큰> --env SLACK_TEAM_ID=<팀ID> -- npx -y @modelcontextprotocol/server-slack

# Tavily 웹 검색
claude mcp add tavily --env TAVILY_API_KEY=<키> -- npx -y @modelcontextprotocol/server-tavily

# Google Drive
claude mcp add gdrive -- npx -y @modelcontextprotocol/server-gdrive
# → 첫 호출 시 OAuth 브라우저 자동 열림
```

연결 후 검증:

```bash
claude mcp list
# → 방금 추가한 서비스가 ✅ 표시되어야 함
```

**Windows (PowerShell)** — 동일하지만 줄바꿈 `\` 대신 한 줄로:

```powershell
claude mcp add notion --env NOTION_API_KEY=<키> -- npx -y @modelcontextprotocol/server-notion
```

### 막혔을 때 대안 경로

연결이 안 되면 (권한 없음, API 키 발급 불가 등) **바로 대안을 제시**한다:

- **노션 권한 없음** → "개인 노션 워크스페이스로 먼저 연습해보세요" 또는 Google Drive MCP로 대체
- **채널톡 API 키 없음** → 슬랙 MCP 또는 Google Drive MCP로 대체  
- **모든 도구 막힘** → "MCP는 숙제로 하고, 스킬 만들기로 넘어갑시다" (시간 낭비 방지)

> **원칙: 막히면 5분 이상 붙잡지 않는다. 대안으로 넘어간다.**

4. 연결 성공 후, 실제로 데이터를 가져와서 보여준다:
   - 채널톡: "최근 문의 3개 요약해줘"
   - 노션: "___페이지 내용 읽어줘"
   - 슬랙: "오늘 나한테 온 메시지 요약해줘"
   - Google Drive: "최근 문서 검색해줘"

5. 퀴즈로 핵심을 확인한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "MCP를 한 마디로 말하면?",
    "header": "Block 2 퀴즈",
    "options": [
      {"label": "Claude와 외부 도구를 연결하는 표준 프로토콜", "description": "노션, 슬랙 등을 꽂는 USB-C"},
      {"label": "Claude의 내장 기능", "description": "MCP는 외부 연결 vs 내장?"},
      {"label": "프로그래밍 언어", "description": "도구 연결 프로토콜 vs 언어?"}
    ],
    "multiSelect": false
  }]
})
```

정답: 1번. MCP는 외부 도구를 Claude에 연결하는 **오픈 표준 프로토콜**. USB-C처럼 꽂으면 쓸 수 있다.

6. 다음으로 넘어갈지 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "MCP 연결 완료! 이제 나만의 스킬을 만들어볼까요?",
    "header": "다음 단계",
    "options": [
      {"label": "스킬 만들러 가자", "description": "나만의 첫 스킬 만들기"},
      {"label": "MCP 하나 더 연결할래", "description": "다른 도구도 연결하고 싶어"}
    ],
    "multiSelect": false
  }]
})
```

---

## Block 3: 나만의 첫 스킬 만들기 (~40분)

### 목표
반복하는 업무를 **스킬**로 만들어서 명령어 하나로 실행할 수 있게 한다.

### 진행

1. 스킬 개념 설명:

```
스킬은 반복하는 업무를 자동화하는 명령어입니다.
예: /cs-reply 치면 채널톡 답변 초안이 나오는 식.
한 번 만들면 계속 쓸 수 있고, 팀원과 공유도 됩니다.
```

2. 스킬을 만들기 전에, 뭘 자동화할지 **질문 1개로 빠르게** 정리한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "평소에 반복해서 귀찮은 업무가 뭔가요? 하나만 떠올려보세요.",
    "header": "자동화 대상 찾기",
    "options": [
      {"label": "고객 응대 (CS)", "description": "비슷한 질문에 비슷한 답변을 반복"},
      {"label": "보고/정리", "description": "데일리 스크럼, 주간 보고 등 정형화된 문서"},
      {"label": "자료 조사/요약", "description": "리서치 후 정리하는 작업"},
      {"label": "직접 말할게", "description": "위에 없는 다른 업무"}
    ],
    "multiSelect": false
  }]
})
```

> **참고**: `/think-deeper`를 쓰면 "왜 이게 귀찮은가?"를 깊이 파볼 수 있어요.
> 시간 관계상 여기선 빠르게 넘어가고, **숙제에서 /think-deeper를 직접 써보세요!**

3. 어떤 스킬을 만들지 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "어떤 스킬을 만들어볼까요? 설문에서 쓴 귀찮은 업무를 떠올려보세요.",
    "header": "스킬 만들기",
    "options": [
      {"label": "/cs-reply", "description": "채널톡 답변 초안 자동 생성"},
      {"label": "/daily-scrum", "description": "데일리 스크럼 자동 작성"},
      {"label": "/research-summary", "description": "리서치 자료 요약"},
      {"label": "/contract-review", "description": "계약서 검토 체크리스트"},
      {"label": "직접 말할게", "description": "위에 없는 다른 업무를 자동화하고 싶어"}
    ],
    "multiSelect": false
  }]
})
```

4. 선택한 스킬의 SKILL.md를 **사용자와 대화하면서** 만든다:
   - "이 스킬이 어떤 입력을 받으면 좋을까요?"
   - "출력 형식은 어떻게 하면 좋을까요?"
   - 파일 생성 경로 (절대 경로):
     - **Mac/Linux**: `~/.claude/skills/<스킬이름>/SKILL.md` (전역) 또는 `<현재폴더>/.claude/skills/<스킬이름>/SKILL.md` (프로젝트)
     - **Windows**: `%USERPROFILE%\.claude\skills\<스킬이름>\SKILL.md` (전역)
   - **추천**: 처음엔 전역 (`~/.claude/skills/`) — 어느 폴더에서든 호출 가능
   - 폴더 없으면 자동 생성. 안 되면 `mkdir -p ~/.claude/skills/<스킬이름>` 수동

5. 만든 스킬을 **바로 테스트**한다:
   - 실제로 실행해보고 결과를 확인
   - 수정할 부분이 있으면 즉석에서 개선

6. 퀴즈로 핵심을 확인한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "스킬은 CLAUDE.md와 어떻게 다르게 로드되나요?",
    "header": "Block 3 퀴즈",
    "options": [
      {"label": "필요할 때만 로드된다", "description": "/명령어를 치거나 자동 매칭될 때만"},
      {"label": "CLAUDE.md처럼 매번 전부 로드된다", "description": "그러면 스킬이 많아질수록 느려지겠죠?"},
      {"label": "한 번 로드하면 영구 저장된다", "description": "세션이 끝나면?"}
    ],
    "multiSelect": false
  }]
})
```

정답: 1번. CLAUDE.md는 매 세션마다 전부 로드되지만, 스킬은 **필요할 때만** 로드된다. 그래서 스킬을 아무리 많이 만들어도 무겁지 않다.

7. 완료 후 마무리:

```
축하합니다! 나만의 첫 스킬을 만들었습니다. 🎉

이제 이 스킬은 언제든 사용할 수 있습니다.
다음 주에는 이 스킬을 실전에 써보고, 팀원들과 공유합니다.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
다음 단계 (이 명령어가 안 보이면 슬랙 #ai-native-camp DM):

📝 /homework — Day별 숙제
💡 /claude-code-guide — 7개 기능 가이드
🔧 /tips — 팀 꿀팁 모음
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

명령어 안 보이면 호스트(승아)에게 슬랙으로 화면 캡처 공유.
```

---

## 트러블슈팅

### Block 1 — 파일 저장 실패

- `output/` 폴더 권한 문제 → `chmod u+w .` (Mac/Linux) 후 재시도
- 디스크 풀 → `df -h` (Mac/Linux) / `Get-PSDrive` (Windows)로 용량 확인
- Auto Memory가 안 잡힌 것 같으면 → 새 세션 (`exit` 후 `claude` 재실행) 후 "내 이름 기억해?" 물어보기

### Block 2 — MCP 연결 실패

- **API 키 발급 불가** (회사 Admin 권한 필요) → 개인 워크스페이스로 먼저 (예: 개인 Notion). 캠프 끝나고 회사 권한 받으면 다시
- **`claude mcp add` 명령어 미인식** → Claude Code 버전 2.0 이상인지 (`claude --version`)
- **연결됐는데 데이터 못 읽음** → `claude mcp list` 로 ✅ 확인. 빨간색이면 키 오류
- **5분 이상 막혔다** → 그냥 다음으로. MCP는 숙제로

### Block 3 — 스킬 파일 생성 실패

- 경로 못 찾음 → 위에 박힌 절대 경로 그대로 복붙
- 권한 문제 (Mac/Linux) → `~/.claude/` 폴더 권한 확인 (`ls -la ~/.claude`)
- Windows에서 `%USERPROFILE%` 안 풀림 → `$env:USERPROFILE` 사용

### 어디서든 — 막혔을 때 에스컬레이션

1. **5분 자체 시도** — 위 트러블슈팅 따라하기
2. **옆 페어/같은 OS 사용자 페어** — 같이 보기
3. **슬랙 `#ai-native-camp`** — 화면 캡처 + 에러 메시지 함께 공유
4. **호스트(승아) DM** — 그래도 안 되면 직접

---

## 호스트(승아) 메모

- 박주영 (신규) 또는 캠프 못 받은 분이 첫 호출하는 스킬
- **첫 호출 시 호스트가 옆에 붙어있는 게 안전** — 발표 직후 5.15 핸즈온 동안 박주영 페어로
- Block 0 사전 점검에서 "터미널 켜본 적 없음" 응답 → 즉시 화면 공유 + 함께 진행
- Block 2 MCP 연결은 **회사 도구 권한 문제로 막힐 가능성 가장 큼** — 사전에 박주영 개인 노션/Tavily 키 발급 안내
- 막힌 사람 처리 3순위:
  1. 같은 OS 페어
  2. 슬랙 #ai-native-camp 공유
  3. 호스트 화면 공유
