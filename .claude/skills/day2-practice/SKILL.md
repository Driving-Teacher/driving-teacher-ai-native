---
name: day2-practice
description: AI Native Camp Week 2 실습. 스킬 고도화 + MCP 추가 연결 + 서로 스킬 소개 + Zeude 셋업. "2일차", "Day 2", "실전", "공유" 요청에 사용.
---

# Week 2: 실전 적용 + 도구 확장 + Zeude

이 스킬이 호출되면 아래 4개 Block을 순서대로 진행한다.

---

## STOP PROTOCOL

> 하나의 Block이 완료될 때까지 다음 Block을 시작하지 않는다.
> 사용자의 응답을 기다린 후에만 진행한다.

---

## Block 1: 숙제 공유 + 피드백 (~20분)

### 진행

1. Week 1에서 만든 스킬을 실전에 써본 경험을 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "지난주에 만든 스킬을 실제 업무에 써봤나요?",
    "header": "숙제 공유",
    "options": [
      {"label": "써봤다 — 잘 됐다", "description": "어떤 스킬을 어디에 썼는지 공유"},
      {"label": "써봤다 — 안 됐다", "description": "뭐가 안 됐는지 같이 고쳐봅시다"},
      {"label": "못 만들었다", "description": "지금 만들어봅시다"},
      {"label": "/think-deeper 해봤다", "description": "결과 공유"}
    ],
    "multiSelect": false
  }]
})
```

2. 답변에 따라:
   - "잘 됐다" → 축하 + 어떻게 개선할 수 있을지 제안
   - "안 됐다" → 함께 디버깅
   - "못 만들었다" → Block 2에서 바로 만들기
   - "think-deeper 해봤다" → 결과 리뷰

---

## Block 2: 스킬 고도화 + MCP 추가 연결 (~30분)

### 진행

1. 무엇을 할지 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "이번 시간에 뭘 하고 싶으세요?",
    "header": "실습 선택",
    "options": [
      {"label": "기존 스킬 개선", "description": "지난주 만든 스킬을 더 좋게"},
      {"label": "새 스킬 만들기", "description": "다른 업무도 자동화하고 싶어"},
      {"label": "MCP 추가 연결", "description": "노션/슬랙/캘린더 등 더 연결"},
      {"label": "다른 사람 스킬 써보기", "description": "팀원이 만든 스킬을 체험"}
    ],
    "multiSelect": false
  }]
})
```

2. 선택에 따라 진행. 시간이 남으면 다른 옵션도 시도.

---

## Block 3: 서로 스킬 소개 (~30분)

### 진행

1. 안내:

```
이제 서로 만든 스킬을 소개하는 시간입니다.

각자 3-4분씩:
1. 어떤 스킬을 만들었는지
2. 어떤 업무에 쓰는지
3. 실제로 실행해서 보여주기

다른 사람 스킬이 마음에 들면 직접 써보세요!
```

2. 참가자가 소개할 준비가 되면 진행을 도와준다.

---

## Block 4: Zeude 셋업 (~30분)

### 진행

1. Zeude 소개:

```
Zeude는 팀의 Claude Code 사용량을 모니터링하는 도구입니다.
누가 뭘 얼마나 쓰는지 대시보드로 볼 수 있어요.
2주 후 회고할 때 이 데이터를 기반으로 이야기합니다.
```

2. Zeude 셋업을 진행한다:
   - GitHub: https://github.com/zep-us/zeude
   - 설치 가이드를 따라 진행
   - 대시보드 확인

3. 마무리:

```
Zeude 셋업 완료! 이제부터 사용 데이터가 쌓입니다.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 숙제는 /homework 으로 확인하세요!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
