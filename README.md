# 운전선생 AI Native Camp

> 4주 후, 우리 조직의 업무 방식은 영구적으로 바뀐다.

운전선생 팀 8명(경영진 포함)을 위한 AI Native 전환 캠프.

## AI Native란?

AI Native **!=** ChatGPT를 잘 쓰는 것
AI Native **!=** 기존 업무에 AI를 붙이는 것
AI Native **=** AI가 있다는 전제로 업무/경험을 재설계하는 것

> "학생/학원/기사가 지금 하고 있지만 사실 안 해도 되는 일을 발견하고, 제거하는 것"

## 사전 준비

[SETUP.md](SETUP.md) 참고. 캠프 1주 전까지 완료.

```
1. GitHub 계정 만들기 → 슬랙에 아이디 공유 → 초대 받기
2. git 설치 확인
3. git clone + 세팅 스크립트 실행 (Claude Code, Node.js, Python 한 번에)
4. claude 로그인
5. (선택) Google Drive MCP 연결: bash scripts/setup-gdrive-mcp.sh
```

## 커리큘럼 (주 1회 × 4주)

전원이 모이는 날에 진행. Claude Code와 대화하면서 배움.

| Week | 테마 | 핵심 질문 | 결과물 |
|------|------|----------|--------|
| 1 | **첫 체험 + 도구 이해** | "AI 도구로 뭘 할 수 있는가?" | 개발 환경 세팅 + 7개 기능 체험 |
| 2 | **연결 + 나만의 스킬** | "내 도구들을 AI에 어떻게 연결하나?" | Context Sync 스킬 (Slack/Notion/Linear/Google) |
| 3 | **명확화 + 기획** | "모호한 아이디어를 어떻게 실행 가능하게?" | Clarify 스킬 + PRD + GitHub PR |
| 4 | **분석 + 정착** | "이걸 어떻게 매일의 습관으로?" | Session Wrap 스킬 + AI Native 선언 |

## 팀 구성

| 팀 | 관점 |
|----|------|
| 플랫폼 팀 | B2C, 제품, 학생 경험 |
| 직영 학원 팀 | 운영, 현장, 학원/기사 경험 |

**조 편성**: 플랫폼 + 학원 크로스 페어 (서로 다른 관점이 섞이도록)

## 주차별 상세

---

### Week 1: 첫 체험 + 도구 이해

> "이게 되네" — Claude Code가 뭘 할 수 있는지 직접 체험

| 파트 | 내용 | 결과물 |
|------|------|--------|
| 설정 | Claude Code 첫 실행 + 에디터 연결 | 개발 환경 완성 |
| 체험 | Working Backward 데모 3가지 직접 따라하기 | "이런 게 가능하구나" |
| 이해 | "왜 CLI인가? 왜 터미널인가?" | AI 도구의 구조 이해 |
| 7개 기능 | Memory, Skill, MCP, Subagent, Agent Teams, Hook, Plugin | 각 기능 설명→실행→퀴즈 |
| 기본기 | CLI + git + GitHub 기초 | 협업 도구 기초 |

**숙제**
- CLAUDE.md에 본인 정보 작성 → 새 세션에서 기억하는지 확인
- 업무 1개를 Claude Code로 직접 수행해보기
- (도전) 평소 하던 업무 1개를 일주일간 "안 해보기" 실험

---

### Week 2: 연결 + 나만의 스킬

> 내가 쓰는 도구를 AI에 연결하고, 첫 스킬을 만든다

| 파트 | 내용 | 결과물 |
|------|------|--------|
| MCP 개념 | USB-C 비유로 이해 + `claude mcp add` | MCP가 뭔지 알게 됨 |
| 서버 탐색 | `/mcp` 명령어 + 인기 MCP 서버 설치 | 사용 가능한 도구 파악 |
| 4가지 연결 | Connector(Slack), mcp add(Notion), Plugin(Linear), 커뮤니티(Google) | 4개 도구 연결 완료 |
| 스킬 제작 | 템플릿 기반 Context Sync 스킬 작성 | `my-context-sync/SKILL.md` |
| 통합 실행 | 4개 소스에서 병렬 수집 + 출력 포맷 완성 | 나만의 컨텍스트 수집 스킬 |

**숙제**
- 고객(학생/학원/기사) 입장에서 서비스 처음부터 끝까지 체험 → "안 해도 되는 단계" 3개 기록
- 수업에서 못 연결한 MCP 도구 추가 연결
- (도전) Claude Code에게 "운전면허 취득 과정 고객 여정 분석" 시키기

---

### Week 3: 명확화 + 기획

> 모호한 요구사항을 구조화하고, PRD를 만들어 GitHub에 올린다

| 파트 | 내용 | 결과물 |
|------|------|--------|
| Clarify 개념 | AskUserQuestion으로 모호함 → 명확함 | Clarify 기법 이해 |
| 체험 | clarify:vague 프로토콜 시연 — 모호한 요구사항 던지기 | 구조화된 질문의 힘 체감 |
| 스킬 제작 | Clarify 플러그인 구조 분석 → 나만의 Clarify 스킬 작성 | 나만의 Clarify 스킬 |
| Plugin 심화 | clarify:unknown (Known/Unknown 4분면 프레임워크) | Plugin 구조 이해 |
| PRD + GitHub | PRD 초안 자동 작성 → 검증 → GitHub 첫 PR 제출 | PRD 문서 + PR 경험 |

**숙제**
- 조별 /think-deeper 스킬 마무리 (5 Whys, Plan A/B/C)
- 자주 반복하는 회사 업무를 Skill 1개로 만들기 (예: /daily-report, /student-stats)
- Quick Win 재설계안을 마크다운 문서로 정리

---

### Week 4: 분석 + 정착

> 지금까지 배운 걸 되돌아보고, 앞으로의 습관을 만든다

| 파트 | 내용 | 결과물 |
|------|------|--------|
| Multi-agent | 2-Phase Pipeline 패턴 (병렬 분석 → 순차 검증) | 설계 패턴 이해 |
| 스킬 제작 | session-wrap SKILL.md 직접 작성 | `my-session-wrap/SKILL.md` |
| 실행 + 확인 | 만든 스킬 실행 → 결과 확인 | 작동하는 스킬 |
| 세션 분석 | history-insight + session-analyzer로 과거 작업 분석 | 내 작업 패턴 인사이트 |
| 콘텐츠 소화 | fetch-tweet + content-digest (Quiz-First 학습법) | 콘텐츠 소화 파이프라인 |
| 보너스 | compound, team-assemble 스킬 소개 | 추가 도구 파악 |
| Zeude 도입 | [zep-us/zeude](https://github.com/zep-us/zeude) 설치 — 조직 Claude Code 사용량/스킬 모니터링 | 팀 AI 사용 현황 대시보드 |

**숙제 (영구)**
- 매일 슬랙에 "AI로 한 것 / 안 한 것" 1줄 기록
- "나는 앞으로 ___를 하지 않겠다" 선언 → 이번 주부터 실천
- 캠프에서 만든 스킬을 실제 업무에 1회 이상 사용

---

## 3개 원칙 (캠프 전체를 관통)

```
1. 액션 전에 문제 — "뭘 할까" 전에 "왜 해야 하나"
2. 성공과 실패 동시에 — Plan A와 Plan B를 같이 기획
3. 임기응변 체크 — "이거 시스템인가 땜빵인가" 매번 자문
```

## 도구

| 도구 | 용도 | 시점 |
|------|------|------|
| **슬랙** | 소통 + #ai-native-log + 숙제 공유 | 항상 |
| **Claude Code** | AI 도구 — 수업 진행, 스킬 제작, 업무 자동화 | Week 1~ |
| **MCP** | Slack/Notion/Google/Linear 연결 | Week 2~ |
| **GitHub** | 스킬/PRD 공유 + 협업 | Week 3~ |
| **Google Drive** | 도메인 문서 미러 (Claude Desktop 연동) | 선택 |

## 도메인 지식

도메인 지식 관리에 대한 상세 플로우는 [docs/domain-knowledge-flow.md](docs/domain-knowledge-flow.md) 참고.

- **SSOT**: `driving-teacher-frontend/docs/` (Git 레포)
- **읽기**: Claude Code는 로컬 docs/ 직접 접근, Claude Desktop은 GDrive MCP
- **쓰기**: 개발자는 git commit, 비개발자는 Claude Code에서 편집 요청

## 캠프 후 (Phase 2)

| 시점 | 할 것 |
|------|-------|
| 캠프 후 즉시 | `#ai-native-log` 슬랙 채널 운영 |
| 캠프 후 즉시 | Zeude 대시보드로 팀 AI 사용 현황 추적 |
| 4주 후 | 리뷰 미팅 — 선언 이행 체크 + Zeude 지표 리뷰 |
| 넥스트 스텝 | [OpenClaw](https://github.com/openclaw) 도입 검토 — 오픈소스 AI 코딩 에이전트, 모델 무관, Telegram/Discord 연동으로 "항상 켜져있는" AI 워크플로우 |
| 점진적 | GitHub에 스킬/PRD 축적, 도메인 문서 보강 |

## 성공 지표

캠프 종료 4주 후:
- [ ] "제거된 업무"가 3개 이상
- [ ] 그로 인해 아무 문제가 발생하지 않음
- [ ] 각자 만든 스킬이 1개 이상 실제 사용 중
- [ ] `#ai-native-log`에 주 3회 이상 기록
- [ ] `/think-deeper`가 실제 기획에 1회 이상 사용됨

---

> "AI Native는 도구를 잘 쓰는 게 아니라, 안 해도 되는 일을 발견하고 제거하는 것이다."
