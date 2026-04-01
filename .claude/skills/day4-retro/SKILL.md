---
name: day4-retro
description: AI Native Camp Week 4 회고. Zeude 데이터 리뷰 + 4주간 회고 + AI Native 선언. "4일차", "Day 4", "회고", "선언" 요청에 사용.
---

# Week 4: 회고 + 선언

이 스킬이 호출되면 아래 3개 Block을 순서대로 진행한다.

---

## STOP PROTOCOL

> 하나의 Block이 완료될 때까지 다음 Block을 시작하지 않는다.

---

## Block 1: 숙제 공유 + Zeude 리뷰 (~30분)

### 진행

1. OpenClaw 사용 경험 공유:

```json
AskUserQuestion({
  "questions": [{
    "question": "지난주 OpenClaw 어떻게 쓰셨나요?",
    "header": "숙제 공유",
    "options": [
      {"label": "자주 썼다", "description": "어디서 어떻게 썼는지 공유"},
      {"label": "몇 번 써봤다", "description": "언제 썼는지, 뭘 시켰는지"},
      {"label": "잘 안 썼다", "description": "왜 안 썼는지 — 이것도 중요한 데이터"},
      {"label": "AI한테 먼저 물어본 경험 있다", "description": "사람 대신 AI에게 먼저 물어본 경험"}
    ],
    "multiSelect": true
  }]
})
```

2. Zeude 대시보드 리뷰:

```
Zeude를 열어서 지난 2주간의 데이터를 봅시다.
- 누가 가장 많이 썼나?
- 어떤 스킬이 가장 많이 사용됐나?
- 사용량 트렌드는?
```

---

## Block 2: 4주간 회고 (~30분)

### 진행

1. 회고 질문:

```json
AskUserQuestion({
  "questions": [{
    "question": "4주간 가장 크게 바뀐 것은?",
    "header": "회고",
    "options": [
      {"label": "AI에게 시키는 게 자연스러워짐", "description": "습관이 됐다"},
      {"label": "반복 업무가 줄었다", "description": "스킬로 자동화한 것들"},
      {"label": "팀원이 뭘 하는지 보이게 됐다", "description": "스킬 공유, Zeude"},
      {"label": "아직 잘 모르겠다", "description": "솔직한 답변도 OK"}
    ],
    "multiSelect": true
  }]
})
```

2. 추가 질문:

```json
AskUserQuestion({
  "questions": [{
    "question": "아쉬운 점이나 더 하고 싶은 것은?",
    "header": "피드백",
    "options": [
      {"label": "더 많은 도구 연결하고 싶다", "description": "MCP 추가"},
      {"label": "스킬을 더 정교하게 만들고 싶다", "description": "고도화"},
      {"label": "다른 팀원과 더 공유하고 싶다", "description": "협업"},
      {"label": "지금 이대로 충분하다", "description": "현 상태 유지"}
    ],
    "multiSelect": true
  }]
})
```

---

## Block 3: AI Native 선언 (~20분)

### 진행

1. 선언 안내:

```
마지막입니다.

4주간 배우고 체험한 것을 바탕으로,
각자 하나씩 선언합니다:

"나는 앞으로 ___를 하지 않겠다."

이건 단순한 다짐이 아닙니다.
"안 해도 되는 일을 발견하고 제거한다" — 
AI Native의 핵심을 실천하는 첫 번째 행동입니다.
```

2. 선언을 입력받는다:

```json
AskUserQuestion({
  "questions": [{
    "question": "나는 앞으로 ___를 하지 않겠다.",
    "header": "AI Native 선언",
    "options": [
      {"label": "수동으로 리포트 만들기", "description": "AI가 생성"},
      {"label": "채널톡 답변을 처음부터 쓰기", "description": "스킬이 초안 생성"},
      {"label": "파일 위치를 사람에게 물어보기", "description": "AI에게 먼저"},
      {"label": "직접 쓸게", "description": "나만의 선언"}
    ],
    "multiSelect": false
  }]
})
```

3. 마무리:

```
축하합니다! AI Native Camp 4주가 끝났습니다. 🎉

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

앞으로:
- 매일 슬랙에 "AI로 한 것 / 안 한 것" 1줄 기록
- 선언을 실천하고 1주 후 결과 공유
- Zeude 대시보드 주기적 확인

AI Native는 도구를 잘 쓰는 게 아니라,
안 해도 되는 일을 발견하고 제거하는 것입니다.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
