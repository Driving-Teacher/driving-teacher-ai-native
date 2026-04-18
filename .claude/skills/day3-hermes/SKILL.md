---
name: day3-openclaw
description: AI Native Camp Week 3 실습. Hermes Agent 셋업 — Slack으로 AI에게 언제든 요청하는 "쓸수록 똑똑해지는 나만의 AI". "3일차", "Day 3", "Hermes", "헤르메스" 요청에 사용.
---

# Week 3: Hermes Agent — 쓸수록 똑똑해지는 나만의 AI

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

먼저 Zeude가 뭔지 설명한다:
```
Zeude는 우리 팀의 AI 사용을 측정하는 대시보드입니다.

- 누가 얼마나 AI를 쓰는지 리더보드
- 어떤 스킬이 인기 있는지 통계
- 비용/토큰 사용량 추적
- 팀 전체 스킬을 중앙에서 배포

지금부터 5분 안에 셋업합니다.
```

셋업 순서 (사전에 `/zeude-invite`로 초대 링크를 만들어서 슬랙에 공유해둔 상태):

```
Step 1: 슬랙에 공유된 초대 링크 클릭
Step 2: 이름 + 이메일 입력 → agent_key가 화면에 표시됨 (복사!)
Step 3: Claude Code에서 /zeude-setup 실행 → key 붙여넣기
Step 4: 대시보드 열리면 본인 이름 확인!
```

> 주의: 초대 링크는 1시간 유효. 수업 시작 직전에 `/zeude-invite`로 생성할 것.
> 셋업 안 되는 사람은 5분 이상 쓰지 않는다. 수업 후 1:1로 해결.

---

## Block 2: Hermes 셋업 + 첫 대화 (~35분)

### 셋업 (15분)

1. Hermes가 뭔지 간단 설명:

```
Hermes Agent는 "쓸수록 똑똑해지는 나만의 AI 비서"입니다.

Claude Code는 터미널에서만 쓸 수 있잖아요?
Hermes를 설치하면 슬랙에서 봇한테 DM으로
업무를 요청할 수 있습니다.

그리고 Hermes는 자가학습합니다.
같은 업무를 반복하면 자동으로 스킬을 만들고,
여러분의 선호도와 패턴을 기억합니다.
쓰면 쓸수록 나한테 맞는 AI가 됩니다.
```

2. `/hermes-setup` 실행을 안내한다.
   - Mac 유저: 바로 진행
   - Windows 유저: WSL 필수 (사전 숙제로 설치했어야 함)
   - WSL 안 된 사람: Mac 유저랑 페어로 진행하고, 수업 후 별도 해결

3. 셋업 완료 확인:

```json
AskUserQuestion({
  "questions": [{
    "question": "Hermes 셋업 상태가 어떤가요?",
    "header": "셋업 확인",
    "options": [
      {"label": "슬랙 봇 응답 성공!", "description": "바로 실전으로"},
      {"label": "설치는 했는데 응답이 안 와", "description": "같이 트러블슈팅"},
      {"label": "WSL/설치 안 됨", "description": "옆 사람이랑 페어로"}
    ],
    "multiSelect": false
  }]
})
```

> 원칙: 셋업 트러블슈팅에 15분 이상 쓰지 않는다. 안 되면 페어로.

### 첫 대화 — 직무별 시나리오 (20분)

1. 슬랙에서 봇한테 DM으로 아래 중 하나를 보내본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "봇한테 뭘 시켜볼까요? 본인 업무에 맞는 걸 골라보세요.",
    "header": "첫 번째 요청",
    "options": [
      {"label": "CS/운영", "description": "고객 문의 답변 초안 작성해줘 / FAQ 정리해줘"},
      {"label": "개발", "description": "이 에러 메시지 뭔지 설명해줘 / 코드 리뷰해줘"},
      {"label": "마케팅", "description": "이 제품 소개 문구 3가지 만들어줘"},
      {"label": "기획", "description": "이 기능의 PRD 초안 잡아줘"},
      {"label": "공통", "description": "오늘 할 일 정리해줘 / 이 문서 요약해줘"},
      {"label": "직접 말할게", "description": "자유롭게 요청"}
    ],
    "multiSelect": false
  }]
})
```

2. 선택한 시나리오를 슬랙에서 실제로 실행한다. 결과를 보고 피드백.
3. 2~3가지 시나리오를 더 돌아가며 시도.

---

## Block 3: 자동화 + 학습 체험 + 마무리 (~30분)

### Hermes만의 기능 체험 (20분)

1. 자동 예약 (Hermes 킬러 기능):

```
슬랙 봇한테 이렇게 보내보세요:

"매일 아침 9시에 오늘 날씨랑 할 일 알려줘"

Hermes가 자연어로 cron 스케줄을 만들어줍니다.
내일 아침 9시에 진짜 메시지가 옵니다.
```

2. 메모리 확인:

```
봇한테 이렇게 보내보세요:

"내가 아까 뭘 물어봤는지 기억해?"

Hermes는 대화를 기억합니다.
세션이 바뀌어도, 며칠 지나도 기억합니다.
```

3. 심화 시나리오:

```json
AskUserQuestion({
  "questions": [{
    "question": "좀 더 복잡한 걸 시켜볼까요?",
    "header": "심화 시나리오",
    "options": [
      {"label": "웹 검색", "description": "최근 OOO 트렌드 리서치해줘"},
      {"label": "긴 문서 분석", "description": "이 링크 내용 요약해줘 (URL 붙여넣기)"},
      {"label": "코드 실행", "description": "파이썬으로 OOO 계산해줘"},
      {"label": "자동화 추가", "description": "매주 금요일에 이번 주 업무 정리해줘"},
      {"label": "직접 말할게", "description": "자유롭게 요청"}
    ],
    "multiSelect": false
  }]
})
```

### 마무리 (10분)

```
Hermes 셋업 완료! 이제 슬랙에서 언제든 AI에게 요청할 수 있습니다.

지금 설치한 Hermes는 여러분 PC에서 돌아갑니다.
쓰면 쓸수록 나를 아는 AI가 됩니다.
1주일 뒤에 "내 AI가 얼마나 똑똑해졌는지" 같이 봅시다.

이번 주 숙제:
- Hermes로 업무 요청 5개 이상
- 자동 예약 1개 이상 만들어보기
- "이런 것도 돼?" 싶은 거 막 시켜보기

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
숙제는 /homework 으로 확인하세요!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
