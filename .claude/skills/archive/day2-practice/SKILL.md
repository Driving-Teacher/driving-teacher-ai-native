---
name: day2-practice
description: AI Native Camp Week 2 실습. Git 교육 + 숙제 발표자료 만들기 + Knowledge Base 체험 + Zeude 셋업. "2일차", "Day 2", "실전", "공유" 요청에 사용.
---

# Week 2: 실전 적용 + 팀 Knowledge Base

이 스킬이 호출되면 아래 4개 Block을 순서대로 진행한다.

---

## STOP PROTOCOL

> 하나의 Block이 완료될 때까지 다음 Block을 시작하지 않는다.
> 사용자의 응답을 기다린 후에만 진행한다.

---

## 사전 준비 (승아가 수업 전에 완료)

- [ ] Knowledge Base 레포 생성 + 팀원 전원 collaborator 초대
- [ ] 노션 전체 Export (Markdown) → raw/에 넣고 push
- [ ] Graphify 실행 (`/graphify ./raw --wiki`) → 결과 push
- [ ] Zeude 서버 셋업 (Supabase + ClickHouse + 대시보드)
- [ ] Zeude Agent Key 발급 + 설치 명령어 슬랙에 공유
- [ ] 팀원들에게 GitHub 초대 수락 리마인드

---

## Block 1: Git 교육 + 숙제 발표자료 만들기 + 발표 (~60분)

### 1-1. Git 최소 생존 키트 (5분)

```
오늘은 Git을 배우는 것부터 시작합니다.
Git을 처음 쓰는 분을 위해 딱 이것만 알면 됩니다:

┌──────────────────────────────────────────────┐
│  Git 최소 생존 키트                            │
│                                              │
│  1. 받기:   git clone <URL>   ← "다운로드"     │
│  2. 당기기:  git pull          ← "최신으로 업데이트" │
│  3. 올리기 (3줄 세트):                         │
│     git add .                ← "이거 올릴 거야" │
│     git commit -m "메시지"    ← "확정"          │
│     git push                 ← "업로드"        │
│                                              │
│  충돌나면?                                     │
│     git pull → 다시 git push                   │
│                                              │
│  이것만 알면 됩니다. 나머지는 Claude한테 물어보세요. │
└──────────────────────────────────────────────┘
```

### 1-2. 레포 clone (5분)

```
이미 레포가 준비되어 있습니다.
초대 메일이 왔을 텐데, 수락하셨나요?

터미널에서:
git clone https://github.com/driving-teacher-bot/driving-teacher-knowledge-base.git
cd driving-teacher-knowledge-base
```

> ⚠️ clone이 안 되는 사람은 GitHub 초대를 수락했는지 확인.
> 그래도 안 되면 승아가 도와준다.

### 1-3. 숙제 확인 + 발표자료 만들기 (25분)

1. 먼저 숙제 현황을 파악한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "지난주 숙제 어떻게 됐나요?",
    "header": "숙제 검사",
    "options": [
      {"label": "CLAUDE.md 만들었다", "description": "어떤 규칙을 넣었는지 공유"},
      {"label": "/think-deeper 써봤다", "description": "어떤 문제를 넣었는지, 결과는?"},
      {"label": "MCP로 업무 해봤다", "description": "뭘 시켰는지, 잘 됐는지"},
      {"label": "스킬 만들었다", "description": "어떤 스킬인지 소개"},
      {"label": "못 했다", "description": "괜찮아요, 오늘 같이 합시다"}
    ],
    "multiSelect": true
  }]
})
```

2. 각자 Claude Code에게 발표자료를 만들게 시킨다:

```
이제 Claude Code를 실전으로 써봅니다.

각자 자기 숙제 결과를 Claude에게 보여주고,
이렇게 시켜보세요:

"내가 한 숙제 결과를 소개하는 2장짜리 HTML 발표자료 만들어줘.
 presentations/week2/내이름.html 에 저장해줘."

숙제를 못 했으면:
"Week 1에서 Claude Code를 써본 경험을 2장짜리 HTML 발표자료로 만들어줘."

20분 드립니다. 발표자료가 마음에 안 들면 Claude에게 수정 시키세요.
```

> Claude Code가 HTML 발표자료를 생성하는 것 자체가 "AI 실전 활용"의 체험.

### 1-4. Push (5분)

```
발표자료가 완성되면 Git으로 올립니다.
아까 배운 3줄 세트:

git add .
git commit -m "내 발표자료 추가"
git push
```

> 충돌나면 `git pull` 먼저 하고 다시 push.
> git이 안 되면 Claude Code에 "이 파일을 git으로 올려줘"라고 시켜도 된다.

### 1-5. 발표 (20분)

```
각자 push한 HTML을 열어서 발표합니다.
3분씩, 간단하게:

1. 어떤 숙제를 했는지
2. 결과는 어땠는지
3. (스킬 만든 사람은) 실행 데모

발표 후 한 줄 리액션: "이 발표에서 가장 ___한 점"
```

---

## Block 2: Q&A (~15분)

### 진행

1. 사전에 수집한 질문 + 현장 질문을 받는다:

```
Claude Code를 쓰면서 궁금했던 것, 막혔던 것,
"이런 것도 돼?" 싶었던 것 — 다 물어보세요.
```

2. 질문이 없으면 자주 나오는 주제로 안내한다:

```json
AskUserQuestion({
  "questions": [{
    "question": "이런 것들이 궁금하지 않으세요?",
    "header": "Q&A 주제",
    "options": [
      {"label": "MCP 연결이 안 됐는데", "description": "같이 해결합시다"},
      {"label": "스킬을 더 잘 만드는 법", "description": "고급 패턴 소개"},
      {"label": "AI한테 뭘 시키면 좋을지 모르겠다", "description": "업무별 활용 사례"},
      {"label": "다른 질문 있어요", "description": "자유 질문"}
    ],
    "multiSelect": true
  }]
})
```

3. 질문에 답하면서, 실습 중 발견한 꿀팁이 나오면 기록해둔다.

---

## Block 3: Knowledge Base 체험 (~30분)

### 목표
노션의 모든 자료가 이미 Knowledge Base에 들어가 있다.
팀원들이 직접 질문해보면서 "노션 뒤지지 않아도 된다"를 체험한다.

> ⚠️ 사전 준비 완료 전제: 승아가 노션 전체를 Export → raw/ → Graphify로 Knowledge Graph + Wiki 생성 완료.

### 진행

1. Knowledge Base 소개 + 데모 (10분):

```
지금까지는 각자 AI를 썼죠.
이번엔 팀 전체의 지식을 AI가 정리한 걸 보여드립니다.

노션에 있던 자료 전부를 이미 Knowledge Base에 넣어뒀어요.
Graphify라는 도구가 자동으로 정리해서
지식 그래프 + 위키를 만들어줬습니다.
```

graph.html을 열어서 보여준다:
```
이게 우리 팀의 지식 그래프입니다.
- 노드를 클릭하면 관련 개념이 보입니다
- 검색도 됩니다
- 어떤 개념이 가장 많이 연결되어 있는지도 보여줍니다
```

> graph.html의 인터랙티브 시각화가 임팩트 포인트.
> "와 이게 자동으로 됐어요?" 반응을 유도.

2. 질문 실습 (10분):

```
이제 각자 자기 업무와 관련된 질문을 해보세요.
이 레포 폴더에서 Claude Code를 열고 질문하면 됩니다.

예시:
- "환불 정책이 뭐야?"
- "채널톡 응대 매뉴얼 알려줘"
- "신규 입사자가 첫 주에 알아야 할 것 정리해줘"
- "운전면허 시험 절차 요약해줘"

AI가 Knowledge Base에서 찾아서 답변합니다.
노션 뒤질 필요 없어요.
```

3. 빠진 자료 찾기 + 논의 (10분):

```
질문했는데 답이 안 나오거나 부족한 게 있었나요?
그게 바로 우리 팀에 정리가 안 된 지식입니다.

각자 담당 영역에서 "이건 들어가야 하는데 없네" 하는 것을 찾아보세요.
```

```json
AskUserQuestion({
  "questions": [{
    "question": "Knowledge Base 어떠셨나요?",
    "header": "Block 3 확인",
    "options": [
      {"label": "노션 안 뒤져도 되겠다", "description": "질문하면 바로 답이 나오니까"},
      {"label": "빠진 자료가 있다", "description": "내 담당 영역에서 추가할 게 보인다"},
      {"label": "아직 잘 모르겠다", "description": "괜찮아요, 써보면서 알게 됩니다"}
    ],
    "multiSelect": false
  }]
})
```

---

## Block 4: Zeude 셋업 + 마무리 (~15분)

### Zeude 셋업

> ⚠️ 사전 준비: 승아가 미리 Zeude 서버(Supabase + ClickHouse + 대시보드)를 셋업해둔다.
> 수업에서는 클라이언트(shim) 설치만 진행한다.

1. Zeude 소개 (5분):

```
마지막으로 Zeude를 셋업합니다.

Zeude는 팀의 Claude Code를 관리하는 도구예요:
1. 측정 — 누가 얼마나 쓰는지 대시보드
2. 배포 — 스킬을 만들면 팀 전체에 자동 설치
3. 추천 — 상황에 맞는 스킬 자동 제안

2주 후 회고할 때 이 데이터로 이야기합니다.
```

대시보드 화면을 보여주면서 "여기서 여러분의 사용량이 보입니다" 데모.

2. 클라이언트 설치 (5분):

```
터미널에 이 한 줄만 복붙하세요:

curl -fsSL https://<대시보드URL>/releases/install.sh | ZEUDE_AGENT_KEY=zd_xxx bash

설치 끝나면 claude를 실행해보세요.
평소와 똑같이 동작하지만, 사용 데이터가 대시보드에 기록됩니다.
```

> 설치 명령어는 승아가 슬랙에 미리 공유한다.

3. 확인 (5분):

```
대시보드에서 자기 이름이 보이나요?
보이면 성공입니다. 이제부터 여러분의 AI 사용이 측정됩니다.
```

### 마무리

4. 꿀팁 수집:

```
오늘 실습하면서 발견한 꿀팁 있나요?
슬랙에서 봇한테 말하면 등록해줍니다.
/tips 치면 팀 꿀팁 목록을 볼 수 있어요.
```

5. 오늘 정리:

```
오늘 한 것:
- Git 배우고, 발표자료를 AI로 만들어서 push
- 팀 Knowledge Base 체험 — 노션 자료가 전부 들어가 있다
- Zeude로 AI 사용 측정 시작

Knowledge Base에 빠진 자료가 있으면 raw/에 추가하세요.
추가하고 Graphify 돌리면 자동으로 업데이트됩니다.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
숙제는 /homework 으로 확인하세요!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
