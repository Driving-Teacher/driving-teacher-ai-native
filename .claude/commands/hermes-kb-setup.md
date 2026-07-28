---
name: hermes-kb-setup
description: Hermes(Slack 봇)에 운전선생 knowledge-base 연결. 슬랙에서 "@hermes-bot 우리 회사 [질문]" 자연어로 KB 검색 가능. Mac/Windows 둘 다 지원. Triggers - "/hermes-kb-setup", "Hermes KB 연결", "hermes에 kb"
allowed-tools: Bash, Read, Write, AskUserQuestion
---

Hermes에 운전선생 knowledge-base를 연결해서 슬랙에서 자연어로 회사 정보를 검색할 수 있게 한다.

> **소요 시간**: ~5분
> **결과**: 슬랙에서 `@hermes-bot 우리 회사 [질문]` 보내면 Hermes가 KB 검색해서 답변
> **막히면**: 슬랙 `#ai-native` 에 OS + Step + 에러 메시지 공유

## 사전 요구사항

- Hermes 설치 완료 (`hermes --version` 동작)
- Claude Code 설치 (이 스킬 호출용)
- **knowledge-base repo 본인 PC에 clone 되어있음** — 안 되어있으면 먼저 `/kb-setup` 호출 후 이 스킬

---

## Block 1: KB 위치 확인 (~1분)

knowledge-base가 본인 PC 어디 있는지 확인.

```bash
# 가장 흔한 위치들 자동 탐색
KB_DIR=""
for path in \
  "$HOME/Documents/company-code/driving-teacher-knowledge-base" \
  "$HOME/Documents/driving-teacher-knowledge-base" \
  "$HOME/work/driving-teacher-knowledge-base"; do
  if [[ -d "$path" ]]; then
    KB_DIR="$path"
    break
  fi
done

if [[ -z "$KB_DIR" ]]; then
  echo "❌ knowledge-base를 찾지 못했습니다."
  echo ""
  echo "먼저 /kb-setup 으로 받아오세요:"
  echo "  /kb-setup"
  echo ""
  echo "받기 끝나면 이 스킬을 다시 호출하세요."
  exit 1
else
  echo "✅ KB 발견: $KB_DIR"
fi
```

> 💡 **KB 못 받았으면**: 이 스킬 종료 후 `/kb-setup` 먼저 (private repo라 gh CLI 인증 필요).

---

## Block 2: 환경변수 설정 (~1분)

`~/.hermes/.env` 에 `DRIVING_TEACHER_KB_PATH` 추가.

### Mac / Linux / WSL Ubuntu

```bash
# 기존 .env 백업
cp ~/.hermes/.env ~/.hermes/.env.bak.$(date +%s) 2>/dev/null

# 중복 방지 — 이미 있는 라인 삭제 후 추가
sed -i.bak '/^DRIVING_TEACHER_KB_PATH=/d' ~/.hermes/.env 2>/dev/null
echo "" >> ~/.hermes/.env
echo "# 운전선생 knowledge-base (hermes-kb-setup 스킬로 자동 추가)" >> ~/.hermes/.env
echo "DRIVING_TEACHER_KB_PATH=$KB_DIR" >> ~/.hermes/.env

# 권한 잠그기
chmod 600 ~/.hermes/.env

echo "✅ 환경변수 추가됨: DRIVING_TEACHER_KB_PATH=$KB_DIR"
```

### Windows native PowerShell (WSL 안 쓰는 경우)

```powershell
$envFile = "$env:USERPROFILE\.hermes\.env"
$kbPath = "$env:USERPROFILE\Documents\company-code\driving-teacher-knowledge-base"

# 백업
Copy-Item $envFile "$envFile.bak.$([int][double]::Parse((Get-Date -UFormat %s)))" -ErrorAction SilentlyContinue

# 중복 라인 제거 후 추가
$content = Get-Content $envFile -ErrorAction SilentlyContinue | Where-Object { $_ -notmatch "^DRIVING_TEACHER_KB_PATH=" }
$content += ""
$content += "# 운전선생 knowledge-base (hermes-kb-setup 스킬로 자동 추가)"
$content += "DRIVING_TEACHER_KB_PATH=$kbPath"
$content | Set-Content $envFile

Write-Host "✅ 환경변수 추가됨: DRIVING_TEACHER_KB_PATH=$kbPath"
```

> **추천**: Windows는 WSL Ubuntu 안에서 위 Mac/Linux 명령 실행이 더 안정적. native PowerShell은 권한/경로 문제 가능성.

---

## Block 3: Hermes에 KB 스킬 생성 (~2분)

`~/.hermes/skills/domain/driving-teacher-kb/SKILL.md` 자동 생성.

```bash
# 폴더 생성
mkdir -p ~/.hermes/skills/domain/driving-teacher-kb

# domain 카테고리 DESCRIPTION (없으면 생성)
if [[ ! -f ~/.hermes/skills/domain/DESCRIPTION.md ]]; then
  cat > ~/.hermes/skills/domain/DESCRIPTION.md << 'EOF'
---
description: 운전선생 회사 도메인 지식. KB 검색, 정책, 톤 매뉴얼 등.
---
EOF
fi

# KB 스킬 본문 생성
cat > ~/.hermes/skills/domain/driving-teacher-kb/SKILL.md << 'SKILL_EOF'
---
name: driving-teacher-kb
description: 운전선생 회사 knowledge-base 자동 검색. CS/마케팅/기획 등 회사 도메인 질문에 답할 때 호출. 트리거 - "우리 회사", "운전선생", "사내 정책", "도메인 질문".
---

# 운전선생 Knowledge Base 검색

회사 KB는 `$DRIVING_TEACHER_KB_PATH` 환경변수에 박힌 폴더.
구조: `raw/` 원본 · `docs/` 정리본 · `graph-v2/` 그래프

## 사용법

사용자가 회사 관련 질문을 하면:

0. **자동 git pull — 최신화 (~1초)**:

```bash
KB="${DRIVING_TEACHER_KB_PATH:-$HOME/Documents/company-code/driving-teacher-knowledge-base}"

PULL=$(cd "$KB" && timeout 5 git pull --no-edit 2>&1)
if echo "$PULL" | grep -qE "files? changed"; then
  echo "📥 KB 업데이트 받음"
fi
# 실패해도 조용히 진행 (오프라인 fallback)
```

1. **docs/ 우선 검색** (가장 신뢰):

```bash
grep -ril "[질문 키워드]" "$KB/docs/" 2>/dev/null | head -5
```

찾은 파일 1-3개를 `cat` 으로 읽고 관련 섹션 추출.

2. **raw/ 보조 검색** (최신 내용):

```bash
grep -ril "[질문 키워드]" "$KB/raw/" 2>/dev/null | head -3
```

3. **답변 형식**:

```
## 🔍 [질문]

### 핵심 답
[1-3 문장]

### 출처
- docs/[파일명] — [한 줄 요약]
- raw/[파일명] — [한 줄 요약]

### 더 깊이 가려면
- 슬랙 #ai-native 에 추가 질문
```

4. **답이 없으면** 솔직히:
```
❌ KB에 답 없음. 슬랙 #ai-native 에 질문해주세요.
```

## 보안

- KB 폴더는 회사 내부용. 슬랙 외부 채널에 답변 복붙 금지
- 답변에 출처 명시 필수 (어느 파일에서 가져왔는지)
SKILL_EOF

echo "✅ Hermes KB 스킬 생성됨"
ls -la ~/.hermes/skills/domain/driving-teacher-kb/
```

---

## Block 4: Hermes 재시작 (~1분)

환경변수 + 새 스킬 적용을 위해 gateway 재시작.

### Mac / Linux / WSL

```bash
hermes gateway stop 2>/dev/null
sleep 2
hermes gateway start
hermes gateway status
# → "running" 확인
```

### Windows native PowerShell

```powershell
hermes gateway stop
Start-Sleep -Seconds 2
hermes gateway start
hermes gateway status
```

---

## Block 5: 검증 (~1분)

슬랙에서 봇한테 DM:

```
@hermes-bot 우리 회사 환불 정책 알려줘
```

또는

```
@hermes-bot driving-teacher-kb 스킬로 [질문] 검색해줘
```

### 성공 신호

- Hermes가 "docs/[파일명] 에 따르면..." 식으로 출처 명시 답변
- "❌ KB에 답 없음" 같은 정직한 응답 (없는 정보면)

### 실패 신호 → 트러블슈팅

| 증상 | 원인 / 해결 |
|---|---|
| Hermes가 일반 LLM 답만 (KB 무시) | `hermes gateway status` → restart 안 됐을 가능성. Block 4 재실행 |
| "환경변수 없음" 에러 | `~/.hermes/.env` 에 `DRIVING_TEACHER_KB_PATH` 라인 확인 |
| 폴더 없다고 함 | `$DRIVING_TEACHER_KB_PATH` 경로 실제 존재 확인 (`ls`) |
| Windows: 경로 \ 문제 | `.env` 파일 경로 구분자를 `/` 로 변경 (Hermes는 POSIX 처리) |

---

## Block 6: 마무리 안내

```
✅ Hermes KB 연결 완료!

이제 슬랙에서:
- "@hermes-bot 우리 회사 환불 정책" → KB 자동 검색
- "@hermes-bot driving-teacher-kb로 [질문]" → 명시 호출

Claude Code의 /kb 와 동등한 효과 — 슬랙에서도 회사 정보 검색 가능.

KB가 업데이트되면? → git pull 만 하면 끝 (Hermes 재시작 불필요).

막히면 슬랙 #ai-native.
```

---

## 호스트(승아) 메모

- 이 스킬은 **8명 + 신규 입사자 모두 본인 PC에서 실행** → KB 연결을 각자 하게 만드는 게 목적
- KB repo가 본인 PC에 없으면 Block 1.5에서 clone부터
- Hermes gateway 재시작이 안 되면 → `hermes gateway logs` 로 디버그
- **`~/.hermes/skills/domain/driving-teacher-kb/SKILL.md` 는 자동 생성** — 사용자가 손대면 안 됨. KB 검색 로직 변경 시 이 스킬 파일을 직접 수정 후 PR
- Windows native에서 막히는 사람 → WSL Ubuntu로 갈아타게 안내
- 검증 단계 5: 슬랙 #ai-native 에 "✅ Hermes KB 연결 완료 — [내 이름]" 보고 받아서 트래킹
