# AI Native Camp — 추천 도구 가이드

> Week 2 수업에서 소개 + 팀원들이 스스로 설치해볼 수 있는 도구 목록

---

## Anthropic 공식 플러그인 (knowledge-work-plugins)

설치:
```bash
claude plugin marketplace add anthropics/knowledge-work-plugins
claude plugin install [이름]@knowledge-work-plugins
```

### customer-support — CS팀 필수

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/triage` | 티켓 분류 + 우선순위 + 라우팅 |
| `/draft-response` | 고객 응답 초안 |
| `/kb-article` | 반복 문의 → KB 문서 자동 생성 |
| `/escalate` | 에스컬레이션 패키지 작성 |
| `/research` | 고객 질문 리서치 |

예시: `/triage 고객이 환불 요청했는데 수업을 3회 이상 수강한 상태입니다`

### operations — 운영팀 필수

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/process-doc` | SOP/프로세스 문서화 |
| `/status-report` | 주간/월간 상태 보고서 |
| `/runbook` | 운영 매뉴얼 생성 |
| `/vendor-review` | 벤더/파트너 평가 |
| `/change-request` | 변경 관리 (영향 분석 + 롤백 플랜) |

예시: `/process-doc 신규 학원 등록 프로세스를 문서화해줘`

### productivity — 전원 추천

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/start` | 태스크 + 워크플로우 초기화 |
| `/update` | 정체 항목 정리, 외부 도구 동기화 |
| `/update --comprehensive` | 이메일/캘린더/채팅 전체 스캔 |

예시: `/start` → Claude가 역할, 팀, 우선순위를 물어보고 태스크 관리 시작

### product-management — 기획팀 필수

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/write-spec` | PRD/기능 스펙 작성 |
| `/roadmap-update` | 로드맵 생성/우선순위 |
| `/stakeholder-update` | 임원 보고용 업데이트 |
| `/competitive-brief` | 경쟁사 분석 |
| `/brainstorm` | 아이디어 브레인스토밍 |

예시: `/write-spec 학원 직영 관리 대시보드 기능 스펙`

### data — 데이터 다루는 사람

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/analyze` | 데이터 질문 → 분석 |
| `/explore-data` | 데이터셋 프로파일링 |
| `/build-dashboard` | 인터랙티브 HTML 대시보드 |
| `/create-viz` | 차트/그래프 생성 |

예시: `/analyze 지난 6개월 월별 매출 트렌드를 지역별로 보여줘` (CSV 첨부)

### legal — 계약 관련

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/review-contract` | 계약서 조항별 검토 (GREEN/YELLOW/RED) |
| `/triage-nda` | NDA 사전 심사 |

예시: `/review-contract` + 계약서 파일 → 리스크 조항 자동 검출

### sales — 영업/제휴

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/call-summary` | 미팅 노트 → 요약 + 팔로업 이메일 |
| `/pipeline-review` | 파이프라인 건강도 분석 |
| 자연어 | "내일 학원 미팅 준비해줘" → 자동 리서치 + 어젠다 |

### human-resources — 인사/채용

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/onboarding` | 신규 입사자 온보딩 체크리스트 |
| `/policy-lookup` | 회사 정책 검색 |
| `/draft-offer` | 오퍼 레터 초안 |

---

## 커뮤니티 스킬/플러그인

### compounding-marketing — 마케팅 올인원 (61개 스킬)

설치: `npx compounding-marketing`

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/cm:daily` | 일일 마케팅 리뷰 (10분) |
| `/cm:research` | 시장 + 고객 심층 리서치 |
| `/cm:social` | 소셜 미디어 캠페인 계획 |
| `/cm:copy` | 카피라이팅 → CRO 리뷰 |
| `/cm:position` | 포지셔닝 워크숍 |

### claude-rank — AI 검색 최적화

설치: `npx @houseofmvps/claude-rank scan https://사이트URL`

AI 검색(ChatGPT, Perplexity)에서 우리 사이트가 인용되는지 진단하고 자동 수정. URL만 넣으면 됨.

### nano-banana — 이미지 생성

설치:
1. https://aistudio.google.com/apikey 에서 Gemini API 키 발급 (무료)
2. `claude mcp add nano-banana-pro --env GEMINI_API_KEY=키 -- npx @easyuseai/nano-banana-pro-mcp`

사용: "SNS 배너 만들어줘 — 운전선생 로고 느낌으로"

### ai-cmo-agent — 마케팅 (간편 버전)

설치: `npx ai-cmo-agent`

`/cmo-research 운전선생` → 회사/제품 심층 리서치

---

### gstack — 가상 팀 (YC 대표 Garry Tan이 만듦)

설치:
```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack && cd ~/.claude/skills/gstack && ./setup
```

30개+ 커맨드 중 **비개발자도 쓸 수 있는 것**:

| 커맨드 | 뭘 하나 |
|--------|--------|
| `/office-hours` | YC 오피스아워 — 6개 질문으로 아이디어를 기획서로 |
| `/plan-ceo-review` | CEO 관점에서 기획서 검토 |
| `/plan-design-review` | 디자인 0-10점 채점 + 개선안 |
| `/design-shotgun` | AI 목업 4-6개 한번에 생성, 골라서 발전 |
| `/qa` | URL 주면 실제 브라우저로 앱 테스트 |
| `/qa-only` | 코드 수정 없이 버그 리포트만 |
| `/retro` | 주간 회고 — 커밋/라인수 통계 자동 |
| `/browse` | 실제 브라우저로 웹 탐색 |

예시:
```
/office-hours
"고객 불만 접수를 카카오톡으로 받는데 응답이 너무 느려요.
AI로 자동 응답하는 걸 만들고 싶어요."
→ 6개 질문으로 진짜 문제를 파고들고 기획서 작성
```

---

## 운전선생 팀 역할별 추천

| 역할 | 먼저 설치할 것 | 다음에 |
|------|--------------|--------|
| **CS** | customer-support | productivity |
| **운영** | operations | productivity |
| **마케팅** | compounding-marketing | claude-rank, nano-banana |
| **기획** | product-management | data |
| **영업/제휴** | sales | compounding-marketing |
| **전원** | productivity | — |
