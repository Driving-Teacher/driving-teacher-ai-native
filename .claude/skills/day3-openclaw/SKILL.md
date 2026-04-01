---
name: day3-openclaw
description: AI Native Camp Week 3 실습. OpenClaw 셋업 — Telegram/Discord로 AI에게 언제든 요청하는 "항상 켜진 AI". "3일차", "Day 3", "OpenClaw", "오픈클로" 요청에 사용.
---

# Week 3: OpenClaw — 항상 켜진 AI

이 스킬이 호출되면 아래 3개 Block을 순서대로 진행한다.

---

## STOP PROTOCOL

> 하나의 Block이 완료될 때까지 다음 Block을 시작하지 않는다.
> 사용자의 응답을 기다린 후에만 진행한다.

---

## Block 1: 숙제 공유 + Zeude 확인 (~15분)

### 진행

1. Week 2 숙제 공유:

```json
AskUserQuestion({
  "questions": [{
    "question": "지난주에 뭘 해봤나요?",
    "header": "숙제 공유",
    "options": [
      {"label": "다른 사람 스킬 써봤다", "description": "어떤 스킬을 써봤는지 공유"},
      {"label": "새 스킬 만들었다", "description": "어떤 스킬인지 소개"},
      {"label": "MCP 추가 연결했다", "description": "어떤 도구를 연결했는지"},
      {"label": "못 했다", "description": "괜찮아요, 오늘 새로운 걸 합니다"}
    ],
    "multiSelect": true
  }]
})
```

2. Zeude 대시보드를 확인해서 1주간의 사용 데이터를 간단히 리뷰.

---

## Block 2: OpenClaw 소개 + 셋업 (~35분)

### 진행

1. OpenClaw 소개:

```
OpenClaw는 "항상 켜진 AI"입니다.

Claude Code는 터미널에서 써야 하잖아요?
OpenClaw를 쓰면 Telegram이나 Discord에서
메시지로 AI에게 업무를 요청할 수 있습니다.

출퇴근길에 "오늘 할 일 정리해줘"
점심 먹으면서 "채널톡 문의 요약해줘"
이런 게 가능해집니다.
```

2. 어떤 플랫폼으로 할지 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "OpenClaw를 어떤 메신저에 연결할까요?",
    "header": "플랫폼 선택",
    "options": [
      {"label": "Telegram", "description": "개인 메신저로 AI와 대화"},
      {"label": "Discord", "description": "팀 서버에서 AI 채널 운영"}
    ],
    "multiSelect": false
  }]
})
```

3. 선택한 플랫폼에 맞춰 OpenClaw 셋업을 진행한다.
   - 설치, 봇 생성, 연결, 테스트까지 단계별 안내

---

## Block 3: 실전 시나리오 + 마무리 (~30분)

### 진행

1. OpenClaw로 실제 업무를 요청해본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "OpenClaw로 뭘 시켜볼까요?",
    "header": "실전 시나리오",
    "options": [
      {"label": "오늘 할 일 정리", "description": "일정/업무 정리"},
      {"label": "채널톡 문의 요약", "description": "MCP 연동 활용"},
      {"label": "리서치 요약", "description": "자료 분석"},
      {"label": "직접 말할게", "description": "자유롭게 요청"}
    ],
    "multiSelect": false
  }]
})
```

2. 요청을 실행하고 결과를 확인.

3. 마무리:

```
OpenClaw 셋업 완료! 이제 언제 어디서든 AI에게 요청할 수 있습니다.

이번 주 숙제: 1주일간 OpenClaw로 업무 3개 이상 요청해보기

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 숙제는 /homework 으로 확인하세요!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
