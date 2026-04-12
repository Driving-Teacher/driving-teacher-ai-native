# AI Native Camp 꿀팁 모음

> 팀원들이 발견한 유용한 팁을 모아두는 곳입니다.
> Claude Code에서 `/tips` 치면 볼 수 있어요.
> 새 팁이 있으면 여기에 추가하세요!

---

## CLAUDE.md 작성법

- **Claude가 모를 것만** 넣으세요 — 코드에서 알 수 있는 건 안 넣어도 됨
- 200줄 넘기지 마세요 — 길면 Claude가 뒷부분을 무시할 수 있음
- "한국어로 대화해"는 기본으로 넣어두세요
- "표로 정리해줘"를 넣으면 결과가 훨씬 깔끔해짐
- 폴더별 CLAUDE.md 가능 — `src/api/CLAUDE.md`에 API 규칙, `src/frontend/CLAUDE.md`에 프론트 규칙
- 중요한 규칙은 `<important>` 태그로 감싸면 무시 안 함
- `@docs/파일명.md`로 다른 파일 참조 가능 — 본문에 다 넣지 말고 참조로
- **넣어야 할 것**: 프로젝트 설명, 기술 스택, 빌드/테스트 명령어, 코드 스타일
- **넣지 말아야 할 것**: 임시 할일, 일정, 긴 절차 (→ 스킬이나 별도 파일로)
- 테스트: 새 세션 열어서 "테스트 실행해줘"라고 시켜보세요 — 한 번에 되면 CLAUDE.md가 잘 된 것

## MCP 연결

- MCP 연결할 때 **개인 계정으로 먼저** 해보세요 — 회사 계정은 Admin 권한에 막힐 수 있음
- API 키는 대화창에 직접 입력하지 마세요 — `claude mcp add` 명령어로 안전하게
- MCP가 안 되면 → 파일을 직접 넣어서 시키면 됨 (엑셀, PDF 등 드래그앤드롭)
- 어떤 MCP가 있는지 궁금하면 → Claude에게 "___를 연결할 수 있는 MCP 찾아줘"
- 노션 MCP 연결하면 → "노션에서 ___페이지 읽어줘"가 가능

## 스킬 작성법

- **description이 제일 중요** — Claude는 이름+설명만 보고 스킬을 쓸지 결정. 설명이 부실하면 절대 실행 안 됨
- "왜"를 설명하면 "무엇"만 말하는 것보다 결과가 좋음 — Claude는 이유를 알면 더 잘 일반화함
- 예시를 넣으면 품질이 확 올라감 — 입력 예시 + 출력 예시
- 하나의 스킬 = 하나의 업무 — 여러 업무를 합치지 마세요
- SKILL.md는 짧게 (50줄 이내) — 자세한 건 `references/` 폴더에
- 만든 후 Claude에게 "이 스킬 읽고 모호한 부분 알려줘" → 개선점이 나옴 (역 프롬프팅)
- **3번 같은 걸 설명했으면 → 그건 스킬로 만들어야 할 것**
- 스킬은 `.claude/skills/스킬이름/SKILL.md` 구조
- "이거 자동화해줘"라고 시키면 Claude가 알아서 스킬 파일을 만들어줌
- `/superpowers:writing-skills` → 스킬을 만들어주는 스킬 (Superpowers 플러그인)

## 에러/디버깅

- 에러 메시지 붙여넣고 **"fix" 한 마디면 80%는 해결** — 과도한 설명은 오히려 방해
- 막히면 2번만 시도 → 안 되면 `/clear`하고 새로 시작
- "왜 안 돼?"보다 "이 에러 고쳐줘"가 더 잘 됨
- Claude가 같은 실수를 반복하면 → CLAUDE.md에 "___하지 마"를 추가

## 컨텍스트 관리

- 대화가 길어지면 `/compact` — 지금까지 내용을 압축
- 완전히 새로 시작하려면 `/clear`
- 컨텍스트 60% 넘기면 성능 떨어짐 — 일찍 압축하는 게 나음
- 한 세션 = 한 작업 — 여러 작업을 한 세션에서 하지 마세요
- 파일 참조: "이 파일 읽고 따라해" > 내용을 복붙해서 설명 (컨텍스트 절약)

## 프롬프트 팁

- **Plan Mode** — 복잡한 작업 전에 `Shift+Tab` 두 번 → 계획만 세우고 코드는 안 씀
- "이거 해줘"보다 "이 파일을 읽고 이 형식으로 정리해줘"가 더 정확함
- 결과가 마음에 안 들면 → "이 부분만 바꿔줘" (전체를 다시 시키지 말고)
- Claude한테 역할을 주면 결과가 좋아짐 → "CS 전문가처럼 답변해줘"
- 긴 작업은 단계별로 → "먼저 1단계만 해줘. 확인하고 다음 단계 할게"
- AskUserQuestion을 쓰면 Claude가 선택지를 만들어줘서 구조화된 대화 가능

## Git 최소 생존 키트

- `git clone [URL]` — 다운로드 (처음 한 번)
- `git pull` — 최신으로 업데이트 (자주)
- `git add .` → `git commit -m "메시지"` → `git push` — 올리기 3줄 세트
- 충돌나면? `git pull` 하고 다시 push
- Permission denied → `gh auth login`
- 안 되면 → Claude한테 "git push 해줘"라고 시키면 됨

## 터미널 팁

- 줄바꿈: macOS `Option+Enter` / Windows `Alt+Enter`
- Windows는 CMD 말고 **Windows Terminal** 쓰세요
- 폰트는 **Cascadia Code** 추천
- `claude --version` 으로 버전 확인
- `/config` → Output style → Explanatory로 설정하면 설명이 상세해짐

## 플러그인/도구

- **공식 플러그인 설치**: `claude plugin marketplace add anthropics/knowledge-work-plugins`
- **역할별 추천**: CS → customer-support / 운영 → operations / 전원 → productivity
- **gstack**: YC 대표가 만든 30개+ 도구 — `/office-hours`로 아이디어 기획
- **compounding-marketing**: `npx compounding-marketing` — 마케팅 61개 스킬
- **claude-rank**: `npx @houseofmvps/claude-rank scan [URL]` — AI 검색 최적화
- **nano-banana**: 이미지 생성 (Gemini API 키 필요)

## 제일 중요한 팁

**스스로 계속 찾으세요.** 이 팁을 읽는 이 순간에도 더 좋은 도구가 나오고 있어요.
웹 검색으로 끊임없이 내가 필요한 툴을 찾아오세요. Claude한테 "최신 Claude Code 팁 찾아줘"라고 시켜도 됩니다.
