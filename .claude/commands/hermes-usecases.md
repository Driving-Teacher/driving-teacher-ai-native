---
name: hermes-usecases
description: Hermes Agent로 할 수 있는 것들. 직무별/레벨별 유스케이스 + 복붙 가능한 예시 메시지.
allowed-tools: Bash, Read, Grep, AskUserQuestion
---

운전선생 팀의 Hermes Agent 유스케이스 가이드.

## 정보

- **Source of truth**: `<repo-root>/docs/hermes-usecases.md` (이 파일은 그 가이드를 카테고리별로 보여주는 wrapper)
- **유스케이스 추가하려면**: `docs/hermes-usecases.md` 직접 편집 → PR 또는 슬랙 #ai-native-camp 에 공유

## 진행

### Step 1: knowledge-base 위치 탐색

repo root는 cwd에 따라 달라지므로 절대 경로로 docs 파일 찾기:

```bash
# 가장 가까운 hermes-usecases.md 찾기 (현재 디렉토리 → 상위)
DOC=""
for path in \
  "./docs/hermes-usecases.md" \
  "../docs/hermes-usecases.md" \
  "$HOME/Documents/company-code/driving-teacher-ai-native/docs/hermes-usecases.md"; do
  if [[ -f "$path" ]]; then
    DOC="$path"
    break
  fi
done

if [[ -z "$DOC" ]]; then
  echo "❌ docs/hermes-usecases.md 를 찾지 못했습니다." >&2
  echo "→ 슬랙 #ai-native-camp 에 위치 확인 요청" >&2
  exit 1
fi
echo "📂 가이드 위치: $DOC"
```

### Step 2: 카테고리 선택

```json
AskUserQuestion({
  "questions": [{
    "question": "Hermes로 뭘 해보고 싶으세요?",
    "header": "유스케이스",
    "options": [
      {"label": "🌱 처음이라면 — 기본 3개", "description": "할 일 정리 / 문서 요약 / 답변 초안 — 5분 안에 체감"},
      {"label": "직무별 시나리오", "description": "CS / 마케팅 / 기획 / 디자인 — 운전선생 도메인 예시"},
      {"label": "자동화 — cron 예약", "description": "주간 리포트, 매일 브리핑, 알림"},
      {"label": "심화 — 웹검색 / 코드실행", "description": "리서치 봇, 데이터 분석, 파일 처리"},
      {"label": "전부 다 보여줘", "description": "전체 가이드 (긴 파일)"}
    ],
    "multiSelect": false
  }]
})
```

### Step 3: 카테고리별 섹션만 추출 (전체 691줄 X)

선택한 카테고리에 따라 grep + Read 로 해당 섹션만 추출:

| 카테고리 | 추출 키 |
|---|---|
| 처음이라면 | `## 1. 기본` 헤더부터 다음 `## 2.` 직전까지 |
| 직무별 시나리오 | `## 2. 직무별` 헤더부터 다음 `##` 직전까지 |
| 자동화 — cron | `## 3.` 또는 `cron` 키워드 섹션 |
| 심화 — 웹검색 | `## 4.` 또는 `## 5.` (웹검색/코드실행) |
| 전부 다 보여줘 | 전체 파일 Read |

```bash
# 예: 직무별 섹션만 추출
sed -n '/^## 2\. 직무별/,/^## 3\./p' "$DOC"
```

### Step 4: 사용자가 "이거 해보자" 라고 선택하면

해당 유스케이스의 **복붙 가능한 슬랙 메시지**만 강조해서 다시 보여줌. 형식:

```markdown
## ✨ 선택한 유스케이스: [이름]

### 슬랙에서 봇한테 보낼 메시지
```
@hermes-bot [실제 메시지 — 복붙용]
```

### cron 자동화하려면 (선택)
```
@hermes-bot /cron add [cron-expr] [메시지]
```

### 변형 아이디어
- ...
```

두 번째 AskUserQuestion 으로 "유스케이스 선택" 받기:

```json
AskUserQuestion({
  "questions": [{
    "question": "이 중 어떤 걸 지금 해볼까요?",
    "header": "선택",
    "options": [
      // Step 3에서 추출한 섹션 안의 유스케이스 제목 3-5개로 동적 채움
    ]
  }]
})
```

### Step 5: 추가 질문 받기

"다른 카테고리도 보고 싶은지", "유스케이스 추가 방법 알고 싶은지" 등.

## 유스케이스 추가하는 방법 (사용자 안내용)

새 유스케이스를 팀에 공유하려면:

1. `docs/hermes-usecases.md` 를 직접 편집 (해당 카테고리 섹션 아래에 추가)
2. git commit + PR 또는 슬랙 #ai-native-camp 에 텍스트로 공유
3. 호스트가 PR 머지하면 다음 `/hermes-usecases` 호출부터 모두에게 보임
