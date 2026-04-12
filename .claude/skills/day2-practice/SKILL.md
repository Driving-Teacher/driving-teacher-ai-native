---
name: day2-practice
description: AI Native Camp Week 2 복습. 추천 도구 설치 + 페어 실습 이어하기. "2일차", "Day 2", "복습", "추천 도구" 요청에 사용.
---

# Week 2: 서로 배우기 — 복습 가이드

이 스킬은 Week 2 수업 후 복습/셀프스터디용이다.

---

## Step 1: Week 2 요약

먼저 Week 2에서 한 것을 보여준다:

```
Week 2에서 한 것:
1. 숙제 발표 — 서로 뭘 해봤는지 공유
2. Git 배우기 — clone / pull / add + commit + push
3. 페어 실습 — 짝지어서 회사 문제를 AI로 풀기
4. 추천 도구 소개
```

---

## Step 2: 추천 도구 설치

`docs/recommended-tools.md`를 읽어서 역할별 추천 도구를 보여준다.

```json
AskUserQuestion({
  "questions": [{
    "question": "어떤 역할이세요? 역할에 맞는 도구를 추천해드릴게요.",
    "header": "역할",
    "options": [
      {"label": "CS", "description": "customer-support + productivity"},
      {"label": "운영", "description": "operations + productivity"},
      {"label": "마케팅", "description": "compounding-marketing + claude-rank"},
      {"label": "기획", "description": "product-management + data"}
    ],
    "multiSelect": false
  }]
})
```

선택한 역할에 맞는 도구의 **설치 방법**과 **예시 커맨드**를 `docs/recommended-tools.md`에서 가져와서 보여준다.

설치를 원하면 같이 진행한다.

---

## Step 3: 페어 실습 이어하기

```json
AskUserQuestion({
  "questions": [{
    "question": "Week 2 페어 실습에서 못 끝낸 거 있나요?",
    "header": "이어하기",
    "options": [
      {"label": "있다 — 이어서 하자", "description": "어떤 문제를 풀고 있었는지 알려주세요"},
      {"label": "끝냈다 — 새 문제 풀자", "description": "다른 업무를 AI로 해보고 싶다"},
      {"label": "스킬 만들기", "description": "만든 결과물을 스킬로 만들어서 레포에 push"},
      {"label": "됐다", "description": "복습 끝"}
    ],
    "multiSelect": false
  }]
})
```

- "이어서 하자" → 어떤 문제였는지 물어보고 같이 진행
- "새 문제 풀자" → 어떤 업무를 하고 싶은지 물어보고 시작
- "스킬 만들기" → 결과물을 SKILL.md로 정리하고 git push 가이드

---

## Step 4: 숙제 확인

```json
AskUserQuestion({
  "questions": [{
    "question": "Week 2 숙제 상태는?",
    "header": "숙제",
    "options": [
      {"label": "OpenClaw 셋업 완료", "description": "다음 주 준비 끝"},
      {"label": "OpenClaw 아직", "description": "같이 셋업하자"},
      {"label": "숙제가 뭐였지?", "description": "/homework 으로 확인"}
    ],
    "multiSelect": false
  }]
})
```

- "같이 셋업하자" → OpenClaw 셋업 안내
- "숙제가 뭐였지?" → `/homework` 안내

---

## 마무리

```
복습 완료!

기억할 것:
- 추천 도구는 docs/recommended-tools.md 에서 언제든 확인
- Git: add → commit → push (3줄 세트)
- 만든 스킬은 레포에 push하면 팀 전원이 쓸 수 있어요
- 다음 주는 OpenClaw — "항상 켜진 AI"
```
