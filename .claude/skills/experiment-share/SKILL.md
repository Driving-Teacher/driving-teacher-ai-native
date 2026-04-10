---
name: experiment-share
description: Hackle 실험 결과를 조회·비교·슬랙 공유. "/experiment-share" 또는 "실험 공유", "실험 결과" 요청에 사용.
---

# Experiment Share Skill

Hackle MCP로 실험 데이터를 조회하고, 이전 스냅샷과 비교 분석한 뒤, 슬랙에 공유하는 워크플로우.

> 이 스킬은 어떤 프로젝트 디렉토리에서든 실행 가능합니다.
> 스냅샷은 현재 디렉토리의 `.claude/experiment-data/`에 저장됩니다.

## 사용법

```
/experiment-share              → 전체 워크플로우 시작 (실험번호 질문부터)
/experiment-share [실험번호]   → 해당 실험번호로 바로 시작
```

## 워크플로우 (6단계)

### Step 0: Hackle MCP 연결 확인

스킬 실행 시 가장 먼저 Hackle MCP 연결 상태를 확인한다.

**확인 방법:**
- `mcp__hackle-mcp__experiment-list` 도구가 사용 가능한지 확인
- 사용 가능하면 → Step 1로 진행

**MCP 미연결 시:**

아래 메시지를 출력하고 AskUserQuestion으로 선택지를 제공한다:

```
⚠️ Hackle MCP가 연결되어 있지 않습니다.

실험 데이터를 자동으로 조회하려면 Hackle MCP 설정이 필요합니다.
```

옵션:
1. **"자동 설정"** — 아래 안내 출력:
   ```
   터미널에서 아래 명령어를 실행해주세요:

   ! bash scripts/setup-hackle-mcp.sh

   Hackle API Key를 물어봅니다. 팀 슬랙에서 공유받은 키를 붙여넣으세요.
   실행 후 Claude Code를 재시작하면 사용할 수 있습니다.
   (Cmd+R 또는 claude 다시 실행)
   ```
   → 여기서 STOP. 재시작 후 다시 `/experiment-share` 실행하도록 안내.

2. **"수동 데이터 입력"** — Hackle MCP 없이 진행. 사용자가 실험 데이터를 직접 붙여넣으면 그 데이터로 Step 3부터 진행.

### Step 1: 실험번호 묻기

AskUserQuestion으로 실험번호를 질문한다.

```
"어떤 실험 결과를 공유할까요? 실험번호를 알려주세요."
```

- 인자로 실험번호가 이미 들어왔으면 이 단계 스킵
- 실험번호 예시: 16, 17, 18 등

### Step 2: Hackle MCP로 실험 데이터 조회

Hackle MCP 도구를 순서대로 호출하여 실험 데이터를 가져온다.

**조회 순서:**

1. **실험 리스트 조회** — `mcp__hackle-mcp__experiment-list`로 실험번호를 검색하여 매칭되는 실험 찾기
   - `searchKeyword`에 실험번호 전달
   - 응답에서 `experimentKey`가 실험번호와 일치하는 항목의 `id` 추출
   - 실험 이름, 상태(RUNNING/COMPLETED), 시작일 확인

2. **실험 상세+분석 조회** — `mcp__hackle-mcp__experiment-detail`에 위에서 추출한 `id`(experimentId) 전달
   - 변이(variation) 정보, 트래픽 배분
   - **objectives 배열**: 각 지표별 A/B 측정값, 개선율, p-value, 신뢰구간
   - objective의 `type`: `PRIMARY`(핵심), `GUARDRAIL`(가드레일), `NONE`(부가)

3. **데이터 파싱** — experiment-detail 응답의 `objectives` 배열에서 지표 추출:
   - `variations[].metric.measurement.value` → A/B 값
   - `variations[].metric.improvement.rate` → 개선율
   - `variations[].metric.analysis.frequentist.pvalue` → p-value
   - `variations[].metric.analysis.frequentist.isSignificant` → 유의성
   - `controlGroup: true`인 variation이 A군

**MCP 조회 실패 시:**
- "Hackle MCP 연결을 확인하세요. 데이터를 직접 붙여넣어도 됩니다." 메시지 출력
- 사용자가 데이터를 직접 입력하면 그 데이터로 진행

### Step 3: 이전 스냅샷과 비교

1. `.claude/experiment-data/exp-{N}.json` 파일 읽기
2. 가장 최근 스냅샷과 오늘 MCP에서 가져온 데이터를 비교
3. 스냅샷 스키마는 `references/snapshot-schema.json` 참조

**비교 항목:**
- 각 지표별 개선율 변화 (이전 → 오늘)
- p-value 변화 (유의성 근접 여부)
- 방향성 역전 감지
- 가드레일 지표 변화

**비교 결과 표기:**
```
🟢 개선 지속   — 이전과 같은 방향, 수치 개선
➡️ 유사 유지   — 방향 동일, 변화 미미
🔴 방향 역전   — 이전과 반대 방향
🆕 신규 지표   — 이전 스냅샷에 없던 지표
```

**이전 스냅샷 없을 때:**
- 비교 없이 오늘 데이터만으로 진행
- "첫 스냅샷이므로 비교 데이터 없음" 표기

### Step 4: 내용 정리 (공유용 포맷 생성)

MCP 조회 데이터 + 비교 결과를 아래 포맷으로 정리한다.

**슬랙 메시지 포맷:**

```
📊 *실험 {N} — {실험명}*
D+{진행일수} ({시작일}~오늘) · A {A명}명 / B {B명}명

> ✅ [결론 한 줄]

———————————————

*핵심 지표*

{추이아이콘} {지표명}
A {A값} → B {B값} *({개선량})* · p={pValue}

{추이아이콘} {지표명}
A {A값} → B {B값} *({개선량})* · p={pValue}

———————————————

*이전(D+{N}) 대비 변화*

{추이아이콘} {지표명} {변화 설명}
{추이아이콘} {지표명} {변화 설명}

———————————————

*B군 전용 UI* ✅ 유의   (해당 시에만)

• {지표명} {B값} ({B명}명) · p<0.0001

———————————————

*가드레일*
{상태}

*한줄 해석*
{비전문가도 이해할 수 있는 한국어 1~2문장}

*권고: {계속 실험 / B 배포 / A 유지}* {이모지}
```

**결론 판단 기준:**

| 조건 | 결론 | 권고 |
|------|------|------|
| p < 0.05 + B군 개선 | ✅ B군 방향성 긍정 | B 배포 권장 |
| p < 0.05 + B군 악화 | ⚠️ B군 지표 악화 | A 유지 |
| p ≥ 0.05 + 방향 긍정 | ⚠️ 방향성 긍정, 유의성 미달 | 계속 실험 |
| p ≥ 0.05 + 방향 부정 | ⚠️ 유의미한 차이 없음 | A 유지 또는 실험 연장 |
| 가드레일 위반 | ⚠️ 가드레일 주의 | 반드시 표기 |

**출력 규칙:**
- 지표 변화량: 퍼센트포인트 `%p`, 배율 `×`, 시간 `분`/`초`
- p-value: 소수점 2~4자리 (예: p=0.03, p=0.2886)
- 해석: 비전문가도 이해할 수 있는 한국어
- 추이 아이콘: 이전 대비 변화 방향 표시
- 슬랙 굵은 글씨: `*텍스트*`, 인용: `>`
- 섹션 구분: `———————————————` (가독성)

### Step 5: 슬랙 보내기 (반드시 확인)

**MANDATORY: 슬랙 전송 전 반드시 사용자에게 확인**

정리된 내용을 보여준 후 AskUserQuestion으로 질문:

```
"위 내용을 슬랙에 보낼까요?"
옵션:
- "보내기" — 슬랙 채널에 전송
- "수정 후 보내기" — 수정할 부분 입력받은 후 전송
- "보내지 않기" — 전송하지 않고 종료
```

**슬랙 전송:**
- Slack MCP 도구 (`mcp__claude_ai_Slack__slack_send_message`)를 사용하여 메시지 전송
- 채널을 물어보거나, 기존에 사용하던 채널이 있으면 기본값으로 제안
- 채널 검색: `mcp__claude_ai_Slack__slack_search_channels`

**전송 후:**
```
✅ 슬랙 전송 완료 — [메시지 링크]
```

## 부가 동작: 스냅샷 자동 저장

Step 2에서 조회한 데이터를 자동으로 `.claude/experiment-data/exp-{N}.json`에 스냅샷으로 저장한다.

- 스키마: `references/snapshot-schema.json` 참조
- 오늘 날짜로 저장
- 같은 날짜 스냅샷이 이미 있으면 덮어쓰기
- 파일이 없으면 새로 생성 (`snapshots` 배열에 추가)
- `source`: `"hackle-mcp"` (MCP 조회) 또는 `"manual"` (수동 입력)

## 관련 스킬

- `/experiment-log` — 스냅샷 누적 관리, 추이 표 출력 (driving-teacher-frontend 레포)
