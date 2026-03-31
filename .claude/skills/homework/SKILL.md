---
name: homework
description: 숙제 안내. "/homework" 입력 시 실행. Day를 선택하면 해당 Day의 숙제를 안내한다.
---

# Homework

이 스킬이 호출되면 AskUserQuestion으로 Day를 선택하게 한다.

```json
AskUserQuestion({
  "questions": [{
    "question": "어떤 Day의 숙제를 확인할까요?",
    "header": "숙제 확인",
    "options": [
      {"label": "Day 1", "description": "CLAUDE.md 작성 + 업무 1개 Claude로 해보기"},
      {"label": "Day 2", "description": "고객 여정 탐험 + MCP 연결"},
      {"label": "Day 3", "description": "/think-deeper 마무리 + 스킬 만들기"},
      {"label": "Day 4", "description": "AI Native 루틴 정착"}
    ],
    "multiSelect": false
  }]
})
```

선택된 Day에 해당하는 `references/day{N}-homework.md` 파일을 Read 툴로 읽고, 그 안의 `## 출력할 내용` 아래 코드블록을 **그대로** 출력한다.

출력 후 아래를 추가한다:

> **지금 바로 시작하고 싶다면** Claude Code에 숙제 내용을 말로 시키면 됩니다!
