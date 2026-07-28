# 후발 입사자 1-Day AX 온보딩 — 진행 아젠다

> 캠프(4주)가 끝난 뒤 합류한 멤버를 위한 **압축 1-Day 세션**.
> 4주 커리큘럼의 핵심을 90~120분에 전달 + 4주 솔로 과제로 핸드오버.
>
> 본 문서는 **진행자용 아젠다**입니다. 참여자 핸드아웃은 [`onboarding-latecomer-4week-solo.md`](./onboarding-latecomer-4week-solo.md).

---

## 사전 준비 — 세션 전날까지 완료

**참여자 (입사자)**
- [`SETUP.md`](../SETUP.md) Step 0~8까지 완료 (macOS 30~40분 / Windows WSL 포함 60분)
- `claude --version` 확인 + `/zeude-setup` 끝
- 핸드아웃 [4주 솔로 과제 문서](./onboarding-latecomer-4week-solo.md)는 세션 전엔 안 읽음 (세션 후 같이 훑음)

**진행자**
- Claude Teams + GitHub(`Driving-Teacher` org + `driving-teacher-bot` org) + Slack `#ai-native` + Zeude 초대 발송 완료
- 참여자가 어느 팀(예: 성장팀)이고 핵심 업무 영역(예: CRM 템플릿, 마케팅 리포트)이 뭔지 사전 인지 → **실습 소재로 그의 진짜 업무 1개 미리 픽**
- 본 아젠다 + 4주 과제 문서 미리 훑고 옴

---

## 아젠다 — 90분 (필요시 120분으로 확장)

| 블록 | 시간 | 내용 | 결과물 |
|------|:----:|------|--------|
| 0. 사전 점검 | 5m | `claude --version`, `/zeude` 대시보드 본인 잡히는지, KB 레포 접근 OK 확인 | 환경 OK |
| 1. AI Native 철학 압축 | 15m | "AI Native = 안 해도 되는 일을 발견·제거" + 4주 한 줄 요약 + 본인 도메인(성장팀)에 빗대어 | 큰 그림 |
| 2. 첫 체험 — `/kb` & Memory | 20m | `/kb`로 본인 도메인 실제 데이터 질문 (예: "성장팀 KPI/CRM 템플릿 어디?") + `CLAUDE.md`에 본인 정보 박기 | "이게 되네" 1번 |
| 3. 첫 스킬 만들기 | 25m | 본인 반복 업무 1개를 스킬로 (예: `/crm-copy-review`) — `/superpowers:writing-skills` 활용 | `.claude/skills/<이름>/SKILL.md` 1개 |
| 4. 팀 인프라 — Zeude & 살림터 | 10m | Zeude 대시보드 본인 사용량 + [README "스킬 살림터" 3-tier](../README.md#스킬-살림터--어디에-뭘-두나) 설명 | 어디다 둘지 안다 |
| 5. 4주 솔로 과제 핸드오버 | 10m | [`onboarding-latecomer-4week-solo.md`](./onboarding-latecomer-4week-solo.md) 같이 훑고 Week 1만 약속 | 다음 1주 계획 |
| 6. AI Native 선언 + 마무리 | 5m | "1주 동안 ____는 AI에 맡기고 사람은 검토만" 한 줄 작성 → `#ai-native`에 공유 | 선언 1줄 |

---

## 블록별 진행 노트 (진행자용)

### 1. AI Native 철학 압축 (15m)

핵심 메시지 (참여자에 따라 본인 도메인 사례로 치환):

- **AI Native ≠ ChatGPT 잘 쓰기**. **= 업무를 재설계하는 것**.
  - "지금 손으로 하는데 사실 안 해도 되는 일을 발견하고 AI에게 시킨다"
- 캠프 4주 압축 ([week-summary.md](./week-summary.md) 한 줄씩):
  - W1: AI를 도구가 아닌 **재설계의 전제**로 받아들인다
  - W2: 팀의 **공동 경험과 공유 인프라**(Zeude managed)로 함께 배운다
  - W3: 슬랙·자동화·자가학습으로 **항상 떠있는 AI**(Hermes/OpenClaw)
  - W4: 4주 **회고·선언**, 회사 색(KB·Ouroboros)
- 1-Day는 **W1+W2 핵심**까지. W3/W4는 4주 솔로 과제로 누적.

### 2. 첫 체험 — `/kb` & Memory (20m)

라이브로 같이 한다:

```
1) /kb 호출 — 본인 팀 데이터 질문
   예: "성장팀 KPI는 뭐고 누가 책임져?"
       "CRM 템플릿은 어디서 관리해?" (성장팀 케이스 정답: 노션 MKT > CRM MasterSheet)

2) CLAUDE.md (Memory) 작성
   ~/.claude/CLAUDE.md 에 본인 역할·팀·관심 영역 기록
   새 세션에서 "내가 누구야?" 물어 기억 검증

3) Skill discovery
   /superpowers:writing-skills 같은 메타 스킬 소개
   "스킬은 사람마다 가질 수 있고, Zeude로 회사 전체에 풀 수 있다"
```

**주의** — `/kb`가 답을 못 찾으면 그게 오히려 좋은 학습 기회. "AI도 모를 수 있다 → KB에 컨텍스트가 필요하다"는 W4 메시지 미리보기.

### 3. 첫 스킬 만들기 (25m)

핵심: **본인 진짜 업무**를 스킬화. 데모 만들기 아님.

추천 진행:
1. 본인 반복 업무 1개 고름 (사전 준비로 알고 옴)
2. Claude에게 `/superpowers:writing-skills` 또는 직접 "이 일을 스킬로 만들어줘"
3. 한 번 실사용 → 모호한 부분 발견 → "이 스킬 읽고 모호한 부분 알려줘" 반복
4. 결과: `~/.claude/skills/<이름>/SKILL.md` 1개

성장팀 예시 후보:
- `/crm-copy-review` — CRM 카피 톤/길이/CTA 일관성 검토
- `/crm-campaign-draft` — 새 캠페인 기획 초안 (compounding-marketing 활용)
- `/growth-weekly-digest` — 주간 마케팅 데이터 요약

### 4. 팀 인프라 — Zeude & 살림터 (10m)

- `/zeude` 대시보드 → 본인 사용량 + 팀 리더보드 보여주기
- [README "스킬 살림터" 3-tier 표](../README.md#스킬-살림터--어디에-뭘-두나) 정리:
  - **회사 전체** → Zeude 대시보드 Skills 탭 (셀프 등록, 모든 멤버 admin)
  - **KB 데이터 스킬** → KB 레포 `.claude/skills/`
  - **캠프/인프라** → ai-native 레포 `.claude/`
- "방금 만든 스킬이 회사 전체에 풀 만한 가치면 Zeude에 등록" — 다만 강요 X, 본인 판단

### 5. 4주 솔로 과제 핸드오버 (10m)

[`onboarding-latecomer-4week-solo.md`](./onboarding-latecomer-4week-solo.md) 본인 노트북에서 같이 열고:
- Week 1 (시켜본다) 항목만 같이 훑음
- Week 2~4는 시점 되면 본인이 진행
- 추적 도구: Zeude 대시보드 + Slack `#ai-native` 주 3회 이상 기록

### 6. AI Native 선언 + 마무리 (5m)

"____는 제거하고, 그 시간에 ____ 하겠다" 빈칸 채워서 슬랙에 공유.
첫 선언은 **1주 단위**로 가볍게. 1주 후 본인이 회고.

---

## 120분 확장 시 추가 블록 (선택)

- **MCP 연결 라이브 (20m)**: 노션 MCP를 Claude Code에 붙여서 `MKT > CRM MasterSheet` 직접 읽기 → "외부 도구가 AI에 연결된다" 체감
- **Hermes 미리보기 (10m)**: Week 3 도전 과제로 가져가는 Hermes 개념만 소개. 실제 셋업은 솔로 과제로.

---

## 진행자 체크리스트 (세션 직전)

- [ ] 참여자 사전 셋업 상태 슬랙으로 한 번 확인
- [ ] `/zeude` 대시보드 미리 열어두기 (시연용)
- [ ] 본인 도메인 데이터 1~2건 미리 머리에 (예: 성장팀 KPI 정확한 값, CRM 템플릿 노션 페이지 위치)
- [ ] 4주 솔로 과제 문서 링크 준비
- [ ] 본인 카피한 "첫 스킬 후보 아이디어" 3개 (참여자가 막힐 때 시드로)

## 세션 후 24h 안에 (진행자)

- 슬랙에 본인 첫 스킬 + 1주 선언 공유 확인
- Zeude 대시보드에서 사용량 잡히는지 검증
- 1주 뒤 30분 체크인 미팅 캘린더 설정 (Week 1 회고용)
