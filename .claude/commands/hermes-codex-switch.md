---
name: hermes-codex-switch
description: Hermes 모델을 ChatGPT Codex(gpt-5.5)로 전환. 별도 API 키/크레딧 불필요 — ChatGPT 구독으로 사용. Mac/Windows 모두 지원. Triggers - "/hermes-codex-switch", "Hermes 모델 codex", "hermes 모델 변경"
allowed-tools: Bash, Read, AskUserQuestion
---

Hermes의 default 모델을 **ChatGPT Codex (gpt-5.5)** 로 전환한다.

> **왜 codex로?**
> - 별도 OpenAI/Anthropic/OpenRouter API 키 발급 불필요
> - ChatGPT 구독(Plus/Team) 있으면 그걸로 사용 — 크레딧 관리 X
> - 회사 표준 모델로 통일 (호스트 환경과 동일)
>
> **소요 시간**: ~3분
> **막히면**: 슬랙 `#ai-native-camp`

## 사전 요구사항

- Hermes 설치 완료 (`hermes --version` 동작)
- **ChatGPT 계정 + 로그인된 codex CLI** — 아래 Block 1에서 안내
- Mac / Linux / WSL / Windows native 모두 지원

---

## Block 1: codex CLI 설치 + 로그인 확인 (~1분)

### codex CLI 설치 확인

```bash
codex --version 2>/dev/null || echo "❌ codex 미설치"
```

미설치면:

```bash
# Mac / Linux / WSL Ubuntu
npm install -g @openai/codex

# Windows native PowerShell (npm 있으면)
npm install -g @openai/codex
```

> npm이 없으면 Node.js 먼저 (https://nodejs.org LTS 설치 후 PowerShell/터미널 재시작).

### codex 로그인 확인

```bash
codex login --status 2>&1 | head -5
```

로그인 안 되어있으면:

```bash
codex login
# → 브라우저 자동 열림 → ChatGPT 계정으로 로그인
# → "Successfully logged in" 뜰 때까지 대기
```

> 회사 ChatGPT Team 플랜이 있으면 회사 메일 계정으로. 개인 ChatGPT Plus여도 OK.

---

## Block 2: 현재 Hermes 모델 백업 (~30초)

config.yaml 백업 후 현재 설정 확인:

```bash
# 백업 (타임스탬프 붙여서)
cp ~/.hermes/config.yaml ~/.hermes/config.yaml.bak.$(date +%s)

# 현재 모델 출력
echo "=== 현재 Hermes 모델 ==="
grep -A 3 "^model:" ~/.hermes/config.yaml
```

---

## Block 3: Codex 모델로 전환 (~1분)

### Mac / Linux / WSL

```bash
# model 블록을 codex 설정으로 교체
python3 << 'PY'
import re
path = "/Users/seungahjung/.hermes/config.yaml" if False else f"{__import__('os').path.expanduser('~')}/.hermes/config.yaml"
with open(path) as f:
    content = f.read()

# 기존 model: 블록 (다음 같은 들여쓰기 시작 라인까지) 교체
new_model = """model:
  default: gpt-5.5
  provider: openai-codex
  base_url: https://chatgpt.com/backend-api/codex
"""

# 첫 model: 블록만 매치 (model_aliases 같은 비슷한 키 제외)
pattern = re.compile(r"^model:\s*\n(?:[ \t]+.*\n)+", re.MULTILINE)
if pattern.search(content):
    content = pattern.sub(new_model, content, count=1)
else:
    # 없으면 맨 앞에 추가
    content = new_model + "\n" + content

with open(path, "w") as f:
    f.write(content)
print("✅ model 블록을 codex로 교체 완료")
PY

# 검증
echo "=== 변경 후 ==="
grep -A 3 "^model:" ~/.hermes/config.yaml
```

### Windows native PowerShell

```powershell
# Python 사용 가능하면 위 Mac/Linux 명령 그대로 (PowerShell에서 python3 또는 python 실행)
# 없으면 수동 편집:
notepad "$env:USERPROFILE\.hermes\config.yaml"
```

수동 편집 시 — 파일 맨 앞 또는 기존 `model:` 블록을 아래로 교체:

```yaml
model:
  default: gpt-5.5
  provider: openai-codex
  base_url: https://chatgpt.com/backend-api/codex
```

저장 후 메모장 닫기.

---

## Block 4: Hermes 재시작 (~30초)

### Mac / Linux / WSL

```bash
hermes gateway stop 2>/dev/null
sleep 2
hermes gateway start
hermes gateway status
# → "running" 확인
```

### Windows PowerShell

```powershell
hermes gateway stop
Start-Sleep -Seconds 2
hermes gateway start
hermes gateway status
```

---

## Block 5: 검증 (~30초)

슬랙에서 Hermes 봇한테 DM:

```
@hermes-bot 안녕, 지금 어떤 모델로 답하고 있어?
```

### 성공 신호

- 응답 옴 (어떤 모델인지 정확히 답하지 않을 수 있지만 응답 자체가 옴)
- `~/.hermes/logs/gateway.log` 에 `provider: openai-codex` 또는 `gpt-5.5` 흔적

### 실패 → 트러블슈팅

| 증상 | 원인 / 해결 |
|---|---|
| 봇 응답 없음 | `hermes gateway status` 재확인 → restart 안 됐을 가능성 |
| 401 / 인증 에러 | `codex login` 다시 (만료됐을 수 있음) |
| "model not found" | base_url 오타. Block 3 확인 |
| 갑자기 다 깨짐 | 백업 복원: `cp ~/.hermes/config.yaml.bak.<타임스탬프> ~/.hermes/config.yaml` |

---

## Block 6: 마무리 + 보고

```
✅ Hermes 모델 codex(gpt-5.5)로 전환 완료!

이제부터:
- ChatGPT 구독으로 동작 — OpenAI/Anthropic 별도 키/크레딧 X
- 모델 호출이 ChatGPT Codex 백엔드 경유
- 호스트(승아) 환경과 동일 표준

기존 OPENAI_API_KEY / ANTHROPIC_API_KEY는 .env에 그대로 둬도 OK
(model 블록이 우선이라 codex로 라우팅됨)

슬랙 #ai-native-camp 에 보고:
✅ Hermes 모델 codex 전환 완료 — [내 이름] / [Mac or Windows]
```

---

## 호스트(승아) 메모

- **회사 ChatGPT Team 플랜** 가입자 = codex 사용 가능. 개인 Plus도 OK
- 회사 ChatGPT 못 들어가는 팀원 → OpenRouter 또는 OpenAI 키 fallback (Block 3 안 함)
- codex CLI 로그인은 브라우저 OAuth — 회사 메일로 로그인 권장
- 백업 파일(`config.yaml.bak.*`)은 며칠 보관 후 삭제. 너무 많이 쌓이면 `~/.hermes/` 정리
- 막힌 사람 처리:
  1. `hermes gateway logs --tail 50` 출력 슬랙 공유
  2. `cat ~/.hermes/config.yaml | head -10` 출력 (model 블록 정확한지)
  3. 같은 OS 페어 호출
- **모델 변경 후 첫 호출은 응답 좀 느릴 수 있음** (캐시 워밍업)
