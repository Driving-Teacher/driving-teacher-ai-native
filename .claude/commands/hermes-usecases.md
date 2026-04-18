---
name: hermes-usecases
description: Hermes Agent로 할 수 있는 것들. 직무별/레벨별 유스케이스 + 복붙 가능한 예시 메시지.
allowed-tools: Bash, Read
---

Hermes Agent 유스케이스 가이드를 보여준다.

## 진행

1. 사용자에게 관심사를 물어본다:

```json
AskUserQuestion({
  "questions": [{
    "question": "Hermes로 뭘 해보고 싶으세요?",
    "header": "유스케이스 선택",
    "options": [
      {"label": "기본 — 바로 해볼 수 있는 것", "description": "할 일 정리, 문서 요약, 이메일 작성"},
      {"label": "직무별 시나리오", "description": "CS/개발/마케팅/기획별 실전 예시"},
      {"label": "자동화 — cron 예약", "description": "매일 아침 브리핑, 주간 리포트, 모니터링"},
      {"label": "심화 — 웹검색/코드실행", "description": "리서치, 파이썬 실행, 파일 분석"},
      {"label": "창의적 유스케이스", "description": "트레이딩봇, SNS 에이전트, 멀티에이전트"},
      {"label": "전부 다 보여줘", "description": "전체 가이드"}
    ],
    "multiSelect": true
  }]
})
```

2. 선택한 카테고리의 유스케이스를 docs/hermes-usecases.md에서 읽어서 보여준다.

```bash
cat docs/hermes-usecases.md
```

3. 각 유스케이스에서 "이거 해보자"를 선택하면, 슬랙에서 봇한테 보낼 메시지를 알려준다.

4. cron 자동화를 선택한 경우, 실제 `/cron add` 명령어를 알려주고 슬랙에서 실행하게 한다.

5. 더 궁금한 게 있으면 추가 질문을 받는다.
