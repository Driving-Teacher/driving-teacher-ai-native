---
name: think-deeper
description: 기획/의사결정 전에 깊이 생각하는 구조화된 워크플로우. "/think-deeper" 또는 "깊이 생각", "기획", "의사결정" 요청에 사용.
---

# Think Deeper

> 액션 전에 문제. 성공과 실패 동시에. 임기응변 체크.

이 스킬이 호출되면 아래 4단계를 **AskUserQuestion**으로 순서대로 진행한다.
각 단계의 답변을 모아서 마지막에 구조화된 기획 문서를 생성한다.

---

## 시작

먼저 주제를 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "깊이 생각할 주제가 뭔가요?",
    "header": "주제",
    "options": [
      {"label": "새로운 기능/서비스 기획", "description": "아직 없는 걸 만들려고 할 때"},
      {"label": "기존 업무/프로세스 개선", "description": "이미 하고 있는 걸 바꾸려고 할 때"},
      {"label": "문제 해결", "description": "뭔가 안 되거나 불만이 있을 때"},
      {"label": "의사결정", "description": "A안 vs B안 고민 중일 때"}
    ],
    "multiSelect": false
  }]
})
```

사용자가 선택하면 (또는 직접 입력하면) 해당 주제로 4단계를 진행한다.

---

## Step 1: 문제 정의 — "왜 해야 하나?"

> 원칙 1: 액션 전에 문제

```json
AskUserQuestion({
  "questions": [{
    "question": "이걸 왜 하려고 하나요? (가장 가까운 이유를 고르세요)",
    "header": "Why",
    "options": [
      {"label": "고객이 불편해해서", "description": "학생/학원/기사가 겪는 문제"},
      {"label": "내부 비효율이 있어서", "description": "시간/비용이 너무 드는 업무"},
      {"label": "경쟁사/시장이 변해서", "description": "외부 환경 변화에 대응"},
      {"label": "대표/경영진이 원해서", "description": "위에서 내려온 과제"}
    ],
    "multiSelect": false
  }]
})
```

답변 후 **5 Whys**를 진행한다. AskUserQuestion으로 "왜?"를 최대 5번 반복하되, 근본 원인에 도달하면 멈춘다.

각 Why에서는:

```json
AskUserQuestion({
  "questions": [{
    "question": "왜 그런 건가요? (근본 원인에 가까운 걸 고르세요)",
    "header": "Why [N]",
    "options": [
      // 이전 답변에 따라 동적으로 3-4개 선택지를 생성한다
      // 마지막 선택지는 항상: {"label": "이게 근본 원인이다", "description": "더 파고들 필요 없음"}
    ],
    "multiSelect": false
  }]
})
```

"이게 근본 원인이다"를 선택하면 Step 2로 넘어간다.

---

## Step 2: 가설 + Plan A/B/C — "성공과 실패를 동시에"

> 원칙 2: 성공과 실패 동시에

Step 1에서 나온 근본 원인을 기반으로 **3가지 접근법**을 제안한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "어떤 방향이 가장 현실적인가요?",
    "header": "Plan 선택",
    "options": [
      {"label": "Plan A: [가장 이상적인 방안]", "description": "[설명]"},
      {"label": "Plan B: [현실적 타협안]", "description": "[설명]"},
      {"label": "Plan C: [최소 실행안]", "description": "[설명]"}
    ],
    "multiSelect": false
  }]
})
```

Plan A/B/C의 내용은 Step 1의 답변을 기반으로 Claude가 동적으로 생성한다.
각 Plan에는 반드시 **실패 시나리오**도 포함한다:
- "이게 안 되면?" → 대안 또는 롤백 방법

---

## Step 3: 임기응변 체크 — "시스템인가 땜빵인가?"

> 원칙 3: 임기응변 체크

선택한 Plan에 대해 체크한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "이 방안은 시스템인가요, 땜빵인가요?",
    "header": "임기응변 체크",
    "options": [
      {"label": "시스템이다", "description": "반복 가능하고, 담당자가 바뀌어도 돌아감"},
      {"label": "땜빵이다", "description": "지금은 되지만 나중에 또 손봐야 함"},
      {"label": "땜빵이지만 지금은 OK", "description": "시간/리소스 고려하면 지금은 이게 맞음"},
      {"label": "모르겠다", "description": "판단이 어려움"}
    ],
    "multiSelect": false
  }]
})
```

"땜빵이다"를 선택하면 → "시스템으로 만들려면 뭐가 필요한지"도 문서에 포함한다.
"땜빵이지만 지금은 OK"를 선택하면 → "언제 시스템으로 전환할지 기한"을 묻는다.

---

## Step 4: 출력 — 기획 문서 생성

### 4-1. 도메인 자료 참고 여부 확인

기획 문서를 작성하기 전에, 참고할 자료가 있는지 사용자에게 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "기획서 작성 전에 Google Drive에서 참고할 자료가 있나요?",
    "header": "참고 자료",
    "options": [
      {"label": "있다 — 검색해줘", "description": "키워드를 입력하면 Google Drive에서 검색합니다"},
      {"label": "없다 — 바로 작성해줘", "description": "지금까지의 사고 결과만으로 기획서를 작성합니다"}
    ],
    "multiSelect": false
  }]
})
```

- "있다"를 선택하면 → 사용자가 입력한 키워드로 gdrive MCP 검색, 결과를 기획서에 반영
- "없다"를 선택하면 → 바로 기획 문서 작성으로 넘어간다

### 4-2. 기획 문서 작성

4단계의 답변을 모아서 아래 형식의 마크다운 문서를 생성한다:

```markdown
# 🧠 Think Deeper: [주제]

## 1. 문제 정의
- **표면 문제**: [처음 답변]
- **근본 원인**: [5 Whys 결과]
- **Why 체인**: Why 1 → Why 2 → ... → 근본 원인

## 2. 접근 방안
| | Plan A | Plan B | Plan C |
|---|--------|--------|--------|
| 방안 | ... | ... | ... |
| 장점 | ... | ... | ... |
| 리스크 | ... | ... | ... |
| 실패 시 | ... | ... | ... |

**선택**: Plan [X] — [이유]

## 3. 임기응변 체크
- **판정**: 시스템 / 땜빵 / 땜빵(허용)
- **시스템화 조건**: [필요한 것]
- **전환 기한**: [해당 시]

## 4. 참고한 도메인 자료
- [Google Drive에서 검색한 문서 목록과 핵심 요약] (없으면 생략)

## 5. 다음 액션
- [ ] [구체적 다음 단계 1]
- [ ] [구체적 다음 단계 2]
- [ ] [구체적 다음 단계 3]

---
> 생성일: [날짜] | /think-deeper로 생성
```

문서를 화면에 출력한 후, "이 문서를 파일로 저장할까요?"라고 물어본다.
