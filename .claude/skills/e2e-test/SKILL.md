---
name: e2e-test
description: 스킬을 페르소나로 시뮬레이션하고 평가하는 E2E 테스트. "/e2e-test [스킬명]" 또는 "스킬 테스트" 요청에 사용.
---

# E2E 스킬 테스트

이 스킬이 호출되면 아래 순서로 진행한다.

## 1단계: 테스트 대상 확인

인자로 스킬명이 주어지면 해당 스킬을, 없으면 AskUserQuestion으로 물어본다.

```json
AskUserQuestion({
  "questions": [{
    "question": "어떤 스킬을 테스트할까요?",
    "header": "E2E 테스트",
    "options": [
      {"label": "think-deeper", "description": "기획/의사결정 워크플로우"},
      {"label": "day1-onboarding", "description": "Week 1 실습"},
      {"label": "직접 입력", "description": "다른 스킬명 입력"}
    ],
    "multiSelect": false
  }]
})
```

## 2단계: 페르소나 선택

`personas/` 폴더의 파일을 읽고 선택지를 제시한다.

```json
AskUserQuestion({
  "questions": [{
    "question": "어떤 페르소나로 테스트할까요?",
    "header": "페르소나",
    "options": [
      {"label": "비개발자 마케터", "description": "코딩 경험 없음, 노션/슬랙 주 도구"},
      {"label": "시니어 개발자", "description": "CLI 익숙, 빠르게 넘기려 함"},
      {"label": "관심 없는 참가자", "description": "의무 참석, 동기 낮음"}
    ],
    "multiSelect": false
  }]
})
```

## 3단계: 시뮬레이션 실행

1. 선택된 페르소나 파일을 읽는다
2. 대상 스킬의 SKILL.md를 읽는다
3. 해당 평가 기준 파일(`criteria/`)을 읽는다
4. **시뮬레이션을 실행한다**:
   - Claude가 **페르소나 역할**과 **스킬 진행자 역할**을 동시에 수행
   - 스킬의 AskUserQuestion이 나오면, 페르소나의 행동 패턴에 따라 자동 응답
   - 전체 대화 흐름을 기록

## 4단계: 평가

시뮬레이션 결과를 평가 기준으로 채점한다.

출력 형식:
```markdown
# E2E 테스트 결과: [스킬명] × [페르소나]

## 시뮬레이션 요약
- 총 대화 턴: N회
- 완료 여부: 완료 / 중단 (어디서 막힘)
- 소요 시간 추정: N분

## 채점
| 항목 | 점수 | 이유 |
|------|------|------|
| 비개발자 접근성 | /25 | ... |
| 상호작용 품질 | /25 | ... |
| 결과물 실용성 | /25 | ... |
| 시간 효율 | /25 | ... |
| **총점** | **/100** | |

## 발견된 문제점
1. ...
2. ...

## 개선 제안
1. ...
2. ...
```

## 5단계: 개선 적용 여부

```json
AskUserQuestion({
  "questions": [{
    "question": "개선 제안을 적용할까요?",
    "header": "개선",
    "options": [
      {"label": "적용하고 재테스트", "description": "SKILL.md 수정 후 다시 시뮬레이션"},
      {"label": "결과만 저장", "description": "output/e2e-results/에 저장"},
      {"label": "끝", "description": "테스트 완료"}
    ],
    "multiSelect": false
  }]
})
```
