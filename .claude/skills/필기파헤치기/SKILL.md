---
name: 필기파헤치기
description: 운전선생 필기 1000문제 중 랜덤 1개로 30~50초 Shorts 대본(대사만)을 만들고 시각 자산을 다운로드한다. "필기파헤치기", "필기 쇼츠 대본", "필기 문제 영상", "/필기파헤치기" 요청에 사용.
---

# 필기파헤치기

운전선생 : 0km 채널의 [필기파헤치기] Shorts 대본을 한 편 만든다. 문제 1개 = 영상 1개.
설계 진리원본은 레포 루트 `필기파헤치기-시스템-스펙.md`. 이 스킬은 그 스펙의 실행 도구.

## 경로 (giheung 기준 — 팀원은 본인 환경에 맞게 조정)

| 변수 | 경로 |
|------|------|
| 프론트 레포 | `$HOME/Documents/GitHub/driving-teacher-frontend` |
| 서비스 계정 키 | `<프론트>/packages/cloud-functions/drivingteacher-eeb82-firebase-adminsdk-sas55-a951c5fde6.json` |
| export 스크립트 | `<프론트>/apps/admin/scripts/problems/export-problems2026-for-pilgi.ts` |
| 동영상 메타 | `<프론트>/apps/web/videos/Q{id}.mp4.json` |
| 로컬 덤프 | `$HOME/Documents/GitHub/driving-teacher-ai-native/.pilgi-cache/` (problems.json + manifest.json) |
| 스킬 스크립트 | `$HOME/Documents/GitHub/driving-teacher-ai-native/.claude/skills/필기파헤치기/scripts/` |
| Ep 폴더 | `$HOME/Downloads/필기파헤치기/` |

> ⚠️ Firestore는 READ만 한다. write 절대 금지.

## 워크플로우

### Phase 1 — 신선도 체크 + 필요시 자동 export

데이터(`ai.summary`)는 Firestore `Problems2026V2`에만 있고, 스킬은 로컬 덤프를 쓴다. 매 실행 시 덤프가 최신인지 가볍게 확인하고, 오래됐으면 자동 재export 한다.

```bash
FE="$HOME/Documents/GitHub/driving-teacher-frontend"
KEY="$FE/packages/cloud-functions/drivingteacher-eeb82-firebase-adminsdk-sas55-a951c5fde6.json"
SCRIPT="$FE/apps/admin/scripts/problems/export-problems2026-for-pilgi.ts"
TSX="$FE/node_modules/.bin/tsx"   # 검증된 runner. 없으면 (cd "$FE/apps/admin" && pnpm tsx ...)
CACHE="$HOME/Documents/GitHub/driving-teacher-ai-native/.pilgi-cache"

# 1) 로컬 덤프 없으면 무조건 export
if [ ! -f "$CACHE/problems.json" ]; then NEED_EXPORT=1; else
  # 2) Firestore 최신 ai.generatedAt 1건 읽어 manifest와 비교 (~1 read)
  REMOTE=$( ( cd "$FE/apps/admin" && SERVICE_ACCOUNT_KEY="$(cat "$KEY")" "$TSX" "$SCRIPT" --check ) | tail -1 )
  REMOTE_MAX=$(echo "$REMOTE" | sed -n 's/.*"maxGeneratedAt":\([0-9]*\).*/\1/p')
  LOCAL_MAX=$(sed -n 's/.*"maxGeneratedAt": *\([0-9]*\).*/\1/p' "$CACHE/manifest.json")
  if [ "$REMOTE_MAX" != "$LOCAL_MAX" ]; then NEED_EXPORT=1; fi
fi

# 3) 필요하면 전체 export (1000개 → problems.json + manifest.json)
if [ "$NEED_EXPORT" = "1" ]; then
  ( cd "$FE/apps/admin" && SERVICE_ACCOUNT_KEY="$(cat "$KEY")" "$TSX" "$SCRIPT" --export "$CACHE" )
fi
```

> 검증됨(2026-06-02): `--check` 1 read 정상, `--export` 1000개 정상, ai.summary 1000/1000. answer는 `number[]`(복수정답).

### Phase 2 — 랜덤 문제 1개 선택 (완전 랜덤, 락인 #20)

```bash
node "$HOME/Documents/GitHub/driving-teacher-ai-native/.claude/skills/필기파헤치기/scripts/pick-random.mjs" "$CACHE/problems.json"
```

출력된 1개 문제만 읽는다(토큰 절약). 필드: `id, index, type, answer(number[]), problem, choices[], aiSummary, mediaProblem[]`.

### Phase 3 — 회차(Ep) 번호 계산 (락인 #19)

```bash
EPDIR="$HOME/Downloads/필기파헤치기"
mkdir -p "$EPDIR"
N=$(( $(find "$EPDIR" -maxdepth 1 -type d -name 'Ep*' 2>/dev/null | wc -l | tr -d ' ') + 1 ))
DATE=$(date +%Y-%m-%d)
```
폴더: `$EPDIR/{DATE}-Ep{N}-{problemId}/`

### Phase 4 — 대본 드래프트 작성 (대사만, 자유 산문)

`aiSummary`를 핵심 누락 없이 압축해 **30~50초 대사만** 자유 산문으로 쓴다. 자막·시각 큐·사운드 큐·초수 표기 안 함.

**캐릭터 = 운전선생** (브랜드 자체). 성격: 안심시키는·차분·잘난체 X. 말투: 존댓말, "~인데요/거든요/해볼게요", 원리 먼저.

**오프닝**: "운전선생입니다" 류 브랜드 인사로 시작 **금지**. 강력한 후크 1문장으로 연다 (충격 사실/공감/도발 질문).

**클로징** (정형, 잠정): "제대로 알면, 운전은 즐겁죠. 다음 편은 [다음 문제 후크]—헷갈린 거 있으면 댓글로 남겨주세요." (본편/앱 깔때기 X)

> `base.choices[].explanation`(레거시 해설)·`base.explanation` 인용 금지. `aiSummary`가 단일 진리원본. 법규·사실은 정확히.

### Phase 5 — 핑퐁: 자유 코멘트형 (락인 #21)

드래프트를 통째로 보여주고 giheung의 자유 코멘트를 받아 반영, 만족할 때까지 반복. 스킬이 구조 잡아 되묻거나 단계 쪼개지 않는다. 확정되면 `{폴더}/script.md`로 저장.

### Phase 6 — 시각 자산 다운로드 (락인 #14, #22)

```bash
SK="$HOME/Documents/GitHub/driving-teacher-ai-native/.claude/skills/필기파헤치기/scripts"
# 선택된 문제를 파일로 저장한 뒤:
node "$SK/download-assets.mjs" "{문제json경로}" "{Ep폴더}" "$FE/apps/web/videos"
```
- 공단 이미지(`mediaProblem` 있음) → curl
- 동영상형(`Q{id}.mp4.json` 존재) → ffmpeg로 Mux mp4 변환 + 썸네일
- 문장형(`ILLUSTRATION_NEEDED` 출력) → 다운로드 없음. 대본과 함께 **AI 일러스트 생성 프롬프트**를 적어준다 (이미지 생성 도구 미설치라 자동 생성 불가).

## 완료 산출물

`$HOME/Downloads/필기파헤치기/{날짜}-Ep{N}-{problemId}/`
- `script.md` (확정 대사)
- 공단 원본 이미지/영상 또는 (문장형이면) 일러스트 프롬프트가 적힌 대본

## 주의

- Firestore write 금지. export 스크립트는 read-only.
- 1000개 전체를 컨텍스트에 올리지 말 것 — 선택은 `pick-random.mjs`가 코드로 처리, 컨텍스트엔 1개만.
- 시리즈명·캐릭터 컨셉 등 설계 변경은 `필기파헤치기-시스템-스펙.md`에 먼저 반영.
