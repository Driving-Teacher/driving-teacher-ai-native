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
      {"label": "OpenClaw 셋업 완료했다", "description": "스크린샷 보여주세요!"},
      {"label": "페어 실습 문제 마저 풀었다", "description": "어떤 결과가 나왔는지 공유"},
      {"label": "스킬 만들었다/개선했다", "description": "어떤 스킬인지 소개"},
      {"label": "못 했다", "description": "괜찮아요, 오늘 같이 합니다"}
    ],
    "multiSelect": true
  }]
})
```

2. Zeude 소개 + 셋업 (Week 2에서 예고한 것):
   - Zeude가 뭔지 간단 설명 (팀 AI 사용 측정 + 스킬 자동 배포)
   - 슬랙에 공유한 설치 명령어로 shim 설치
   - 대시보드에서 자기 이름 뜨는지 확인

---

## Block 2: OpenClaw 셋업 확인 + 실전 활용 (~35분)

> Week 2 숙제에서 OpenClaw 셋업을 미리 해왔으므로, 셋업 시간을 줄이고 실전에 집중한다.

### 셋업 확인 + 트러블슈팅 (10분)

1. 셋업 완료 여부를 확인한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "OpenClaw 셋업 상태가 어떤가요?",
    "header": "셋업 확인",
    "options": [
      {"label": "완료! 메시지 주고받기 성공", "description": "바로 실전으로"},
      {"label": "설치는 했는데 응답이 안 와", "description": "같이 트러블슈팅"},
      {"label": "아직 못 했다", "description": "지금 빠르게 셋업"}
    ],
    "multiSelect": false
  }]
})
```

2. 완료한 사람: 확인만 하고 대기.
3. 문제 있는 사람: 빠르게 트러블슈팅 (봇 토큰, 서버 연결 등).
4. 못 한 사람: 지금 같이 셋업 진행 — 10분 안에 끝낸다.

> 원칙: 트러블슈팅에 10분 이상 쓰지 않는다. 안 되면 옆 사람과 페어로.

### 실전 활용 (25분)

1. OpenClaw 소개 (셋업 완료한 사람도 다시 짚기):

```
OpenClaw는 "항상 켜진 AI"입니다.

Claude Code는 터미널에서 써야 하잖아요?
OpenClaw를 쓰면 Telegram이나 Discord에서
메시지로 AI에게 업무를 요청할 수 있습니다.

출퇴근길에 "오늘 할 일 정리해줘"
점심 먹으면서 "채널톡 문의 요약해줘"
이런 게 가능해집니다.
```

2. 실전 시나리오를 바로 시작한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "OpenClaw로 뭘 시켜볼까요?",
    "header": "실전 시나리오",
    "options": [
      {"label": "오늘 할 일 정리", "description": "일정/업무 정리"},
      {"label": "채널톡 문의 요약", "description": "MCP 연동 활용"},
      {"label": "Knowledge Base에 질문", "description": "팀 지식 검색"},
      {"label": "리서치 요약", "description": "자료 분석"},
      {"label": "직접 말할게", "description": "자유롭게 요청"}
    ],
    "multiSelect": false
  }]
})
```

3. 요청을 실행하고 결과를 확인. 여러 시나리오를 돌아가며 시도한다.

---

## Block 3: 심화 시나리오 + 마무리 (~30분)

### 진행

1. Block 2에서 기본 시나리오를 해봤으니, 심화 시나리오를 시도한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "좀 더 복잡한 걸 시켜볼까요?",
    "header": "심화 시나리오",
    "options": [
      {"label": "MCP 복합 요청", "description": "채널톡 + 노션 등 여러 도구 연동"},
      {"label": "팀원과 함께 쓰기", "description": "같은 채널에서 팀 업무 요청"},
      {"label": "자동화 아이디어", "description": "매일 아침 자동 보고 등 스케줄링"},
      {"label": "직접 말할게", "description": "자유롭게 요청"}
    ],
    "multiSelect": false
  }]
})
```

2. 요청을 실행하고 결과를 확인. 여러 시나리오를 돌아가며 시도.

3. 마무리:

```
OpenClaw 셋업 완료! 이제 언제 어디서든 AI에게 요청할 수 있습니다.

이번 주 숙제: 1주일간 OpenClaw로 업무 3개 이상 요청해보기

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 숙제는 /homework 으로 확인하세요!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
