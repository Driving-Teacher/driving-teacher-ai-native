---
name: cliproxy-setup
description: cliproxy 풀에 내 Claude Code/Hermes 연결. "/cliproxy-setup" 또는 "cliproxy 연결", "팀 풀에 붙이기" 요청에 사용.
---

# cliproxy 셋업 — 팀 풀에 내 Claude Code/Hermes 붙이기

> 회사 Teams 좌석 8개를 cliproxy 풀로 묶어서 라운드로빈으로 같이 쓰는 시스템.
>
> **연결은 두 단계:**
> - ① 풀에 OAuth 등록 — 호스트(승아)가 회사 메일로 1인당 1회 등록 (발표 라이브 시 진행됨)
> - ② **클라이언트 환경변수 셋업** — 이 스킬이 처리하는 부분
>
> 인증 방식은 풀에서 발급받은 `sk-...` 토큰을 슬랙 DM으로 받아 자기 PC에 박는 형태.

---

## 정보

- **풀 URL**: `https://rr-proxy-vm.tail7f1c29.ts.net` (HTTPS, 영구)
- **API 키**: 슬랙 DM으로 받은 `sk-...` (외부 공유 절대 금지)
- 인프라: GCP VM `rr-proxy-vm` + Tailscale Funnel + cli-proxy-api (router-for-me)

---

## STOP PROTOCOL

> 한 단계가 완료될 때까지 다음 단계를 시작하지 않는다.

---

## Block 1: API 키 확인 (~1분)

승아에게 슬랙 DM으로 받은 `sk-...` 키가 있는지 확인.

```json
AskUserQuestion({
  "questions": [{
    "question": "cliproxy API 키(sk-...로 시작)를 받았나요?",
    "header": "API 키",
    "options": [
      {"label": "네 받았어요", "description": "다음 단계로"},
      {"label": "아직 못 받았어요", "description": "승아에게 슬랙 DM으로 요청"},
      {"label": "받았는데 어디 뒀는지 모름", "description": "다시 받기"}
    ]
  }]
})
```

받은 키는 절대 깃허브/슬랙 공개채널/외부에 박지 말 것.

---

## Block 2: OS 감지 + 환경변수 설정 (~3분)

OS별로 환경변수 설정 위치가 다름.

### Mac / Linux (zsh)

`~/.zshrc` 마지막에 추가:

```bash
# cliproxy — 회사 Teams 풀 (HTTPS)
export ANTHROPIC_BASE_URL="https://rr-proxy-vm.tail7f1c29.ts.net"
export ANTHROPIC_AUTH_TOKEN="sk-...받은_키..."
```

적용:

```bash
source ~/.zshrc
```

### Mac (bash)

`~/.bash_profile` 또는 `~/.bashrc`에 동일하게 추가.

### Windows (PowerShell)

```powershell
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", "https://rr-proxy-vm.tail7f1c29.ts.net", "User")
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", "sk-...받은_키...", "User")
```

PowerShell 재시작.

### Hermes도 같이 쓸 거면

`~/.hermes/.env` 또는 Hermes 설정 파일에 동일한 환경변수 박기 (cliproxy는 OpenAI/Claude/Gemini 호환이라 base_url만 바꾸면 됨).

---

## Block 3: 검증 (~1분)

**새 터미널 / 새 PowerShell** 에서 환경변수 박혔는지 확인:

### Mac / Linux

```bash
echo $ANTHROPIC_BASE_URL
# → https://rr-proxy-vm.tail7f1c29.ts.net 가 출력되어야 함
```

### Windows (PowerShell)

```powershell
echo $env:ANTHROPIC_BASE_URL
# → https://rr-proxy-vm.tail7f1c29.ts.net 가 출력되어야 함
```

→ 출력이 비어있으면 새 셸 안 띄운 것. 터미널/PowerShell 완전히 종료 후 다시 열기.

### Claude Code 한 줄 호출

```bash
claude
# → 켜지면 아무거나 시켜보기 (예: "안녕")
```

응답이 오면 끝. 응답 안 오면 Block 4로.

---

## Block 4: 트러블슈팅

### 401 Unauthorized

- API 키 오타 — 다시 확인
- 키 앞뒤 공백 들어갔는지 체크 (특히 복붙할 때)

### Connection refused / timeout

- 인터넷 연결 확인
- `curl https://rr-proxy-vm.tail7f1c29.ts.net/v1/models -H "Authorization: Bearer $ANTHROPIC_AUTH_TOKEN"` 으로 직접 테스트
- 그래도 안 되면 → 슬랙 #ai-native-camp 에 질문 (승아 또는 인프라 담당자)

### 환경변수가 안 박힘

- **Mac/Linux**: 새 터미널에서만 적용. 이미 켜둔 터미널은 `source ~/.zshrc` 또는 재시작
- **Mac shell이 zsh가 아닐 수 있음**: `echo $SHELL`로 확인 후 맞는 파일(`~/.bashrc` 등)에 추가
- **Windows**: PowerShell **완전히 종료 후 다시 열기** (탭만 닫으면 안 됨). VSCode 사용 시 VSCode 자체 재시작 필요. `setx` 또는 `[System.Environment]::SetEnvironmentVariable` 둘 중 하나만 써도 OK

### 모델 이름 에러 (`unknown provider`)

- 모델 ID는 풀 버전으로. 예: `claude-sonnet-4-5-20250929` (Claude Code는 자동으로 풀 버전 보냄)

---

## Block 5: 마무리 안내

```
완료. 이제 모든 Claude Code 호출이 회사 Teams 풀로 갑니다.

기억할 것 3개:
  1. API 키는 회사 내부 전용 — 외부 공유 X
  2. 사용량은 모두에게 공유됨 — /usage로 점검
  3. MCP보다 CLI 우선 (/tips 참고)

캠프가 끝나도 풀은 계속 살아있습니다.
```

---

## 운영자(승아) 전용 — 풀에 OAuth 등록 (참고)

```bash
# VM 접속
gcloud compute ssh rr-proxy-vm --zone=asia-northeast3-a

# OAuth 등록 (한 명당 ~2분)
cli-proxy-api -claude-login --no-browser
# → URL 출력 → 그 사람한테 슬랙으로 전달
# → 본인이 자기 회사 메일로 OAuth 로그인
# → ~/.cli-proxy-api/claude-<이메일>.json 자동 저장

# 모두 끝나면 reload
sudo systemctl restart cliproxyapi
```

cliproxy는 `~/.cli-proxy-api/` 안의 모든 `claude-*.json`을 자동으로 풀에 등록 → 라운드로빈.

검증: `~/.cli-proxy-api/` 안에 `.json` 파일 8개 있으면 풀 완성.
