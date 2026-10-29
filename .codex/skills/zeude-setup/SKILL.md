---
name: zeude-setup
description: Zeude 모니터링과 회사 표준 스킬 동기화를 설정하고 검증한다. macOS, Windows PowerShell 또는 WSL2 Ubuntu에서 "zeude setup", "Zeude 설치", "/zeude-setup", "회사 스킬 받아줘", "Zeude가 안 잡혀" 요청에 사용한다. Windows는 PowerShell의 공식 install.ps1을 사용한다.
---

# Zeude setup

Zeude shim, 텔레메트리, 회사 표준 스킬 동기화, 대시보드 로그인을 한 번에 설정한다.

## 안전 원칙

- `zd_`로 시작하는 agent key를 비밀번호처럼 취급한다. 응답, 로그, 커밋, 파일 내용에 노출하지 않는다.
- 설치 URL을 바꾸거나 체크섬 검증을 우회하지 않는다.
- 체크섬 불일치가 발생하면 즉시 중단하고 슬랙 `#ai-native` 문의를 안내한다.
- Windows에서는 `docs/zeude-windows-setup.md`를 읽고 공식 PowerShell 설치·검증 절차를 수행한다. WSL은 선택 사항이다.

## 1. 플랫폼 확인

`uname -s`와 필요하면 `uname -r`을 확인한다.

- `Darwin`: 계속 진행한다.
- `Linux`이며 커널 문자열에 `microsoft` 또는 `WSL2`가 있음: WSL2로 간주하고 계속 진행한다.
- 일반 Linux: 설치기는 지원하지만 회사 표준 환경은 macOS·Windows PowerShell·WSL2다. 사용자에게 이 차이를 짧게 알린 뒤 계속 진행한다.
- `MINGW*`, `MSYS*`, `CYGWIN*`, `$env:OS = Windows_NT` 또는 PowerShell/CMD: 저장소의 `docs/zeude-windows-setup.md`를 읽고 Windows 절차를 수행한다. Bash 예제를 그대로 실행하지 않는다. 아래 2~7단계는 macOS·Linux·WSL 전용이다.
- Windows와 WSL의 credentials는 별개다. 자동으로 복사하거나 WSL로 전환하지 않는다.

WSL1이면 중단하고 PowerShell 관리자 창에서 WSL2로 올리도록 안내한다.

## 2. 사전 조건 확인

다음을 확인한다.

```bash
command -v curl
command -v bash
command -v python3
command -v claude
```

현재 Zeude installer는 `claude` shim을 설치하므로 Claude Code가 필요하다. `claude`가 없으면 이 저장소의 `SETUP.md`에서 Claude Code 설치 단계를 먼저 수행하도록 안내하고 중단한다. Codex 자체는 계속 사용할 수 있다.

## 3. 기존 설치와 credentials 확인

macOS·WSL 모두 동일하게 먼저 기존 설치를 확인한다. 초대 링크를 먼저 요청하지 않는다.

```bash
ZEUDE_DIR="$HOME/.zeude"
CREDENTIALS="$ZEUDE_DIR/credentials"
test -f "$CREDENTIALS"
test -x "$ZEUDE_DIR/bin/claude"
test -x "$ZEUDE_DIR/bin/zeude"
```

credentials가 있으면 key를 출력하지 말고 형식만 검증한다.

```bash
AGENT_KEY=$(sed -n 's/^agent_key=//p' "$CREDENTIALS")
python3 -c 'import re,sys; assert re.fullmatch(r"zd_[0-9a-fA-F]{64}", sys.argv[1])' "$AGENT_KEY"
```

형식이 유효하면 OTT API로 key가 아직 살아 있는지 확인한다. 응답 본문은 출력하지 않는다.

```bash
OTT_RESPONSE=$(curl -fsS -X POST "https://zeude.vercel.app/api/auth/ott" \
  -H "Content-Type: application/json" \
  -d "{\"agentKey\": \"$AGENT_KEY\"}")
python3 -c 'import json,sys; assert json.load(sys.stdin).get("token")' <<<"$OTT_RESPONSE"
```

다음 상태로 분기한다.

- **credentials 유효 + `zeude doctor` 성공**: 이미 설치 완료된 상태다. installer를 다시 돌리지 말고 스킬 동기화와 대시보드만 확인한다.
- **credentials 유효 + shim/CLI 없음 또는 doctor 실패**: 초대 없이 저장된 key로 복구 설치한다.
- **credentials 없음·형식 오류·OTT 인증 거절**: 이때만 새 agent key를 요청한다.

OTT 확인의 네트워크 실패와 401/403 인증 거절을 구분한다. 네트워크 오류만으로 invite를 다시 받게 하지 않는다.

## 4. 필요할 때만 Agent key 받기

유효한 기존 key가 없을 때만 사용자에게 정확히 한 가지를 요청한다.

> 슬랙 `#ai-native`의 Zeude 초대 링크에서 받은 agent key를 붙여넣어주세요. `zd_`로 시작하는 긴 키입니다.

입력값이 `^zd_[0-9a-fA-F]{64}$`와 일치하는지 검증한다. 일치하지 않으면 설치하지 말고 새 초대 링크를 요청하도록 안내한다.

## 5. 설치 또는 복구

신규 key 또는 credentials에서 확인한 기존 key를 셸 히스토리에 남기지 않도록 환경변수에 전달하고 공식 HTTPS installer를 실행한다. 이미 doctor가 성공했다면 이 단계를 건너뛴다.

```bash
ZEUDE_AGENT_KEY="<agent-key>" bash <(curl -fsS https://ulkqtmqspquxppywajsu.supabase.co/storage/v1/object/public/releases/install.sh)
```

`curl`의 `-f -S`를 유지한다. installer는 다음을 수행한다.

- 플랫폼·아키텍처 감지: macOS 또는 Linux, amd64 또는 arm64
- `~/.zeude/bin/claude` shim과 `~/.zeude/bin/zeude` 설치
- OTel 텔레메트리와 shell PATH 설정
- `~/.claude/skills/`와 `~/.codex/skills/`에 회사 표준 스킬 동기화
- credentials 저장

네트워크 접근이 sandbox에서 막히면 동일한 공식 installer 명령만 권한 승인을 받아 다시 실행한다.

## 6. 검증

새 셸 없이 명시적 경로로 진단한다.

```bash
~/.zeude/bin/zeude doctor
test -f ~/.zeude/credentials
test -x ~/.zeude/bin/claude
test -x ~/.zeude/bin/zeude
```

회사 스킬이 양쪽에 동기화됐는지 최소 한 개의 공통 스킬 디렉터리로 확인한다. 비밀값을 출력하지 않는다.

## 7. 대시보드 로그인

credentials에서 key를 읽어 일회용 토큰을 만들되 key나 토큰을 응답에 노출하지 않는다.

```bash
AGENT_KEY=$(sed -n 's/^agent_key=//p' ~/.zeude/credentials)
OTT=$(curl -fsS -X POST "https://zeude.vercel.app/api/auth/ott" \
  -H "Content-Type: application/json" \
  -d "{\"agentKey\": \"$AGENT_KEY\"}" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["token"])')
URL="https://zeude.vercel.app/auth?ott=$OTT"
```

브라우저 열기는 실행 환경에 맞춘다.

```bash
if command -v open >/dev/null 2>&1; then
  open "$URL"
elif command -v wslview >/dev/null 2>&1; then
  wslview "$URL"
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$URL"
else
  echo "$URL"
fi
```

브라우저를 여는 데 권한 승인이 필요하면 요청한다. 열 수 없으면 URL을 사용자에게 제공하되 일회용 로그인 URL이라는 점을 알린다.

## 완료 기준

다음을 모두 만족할 때만 완료라고 보고한다.

- `zeude doctor` 성공
- shim과 CLI 실행 파일 존재
- credentials 존재 및 OTT 인증 성공
- 회사 표준 Codex 스킬 동기화 확인
- 대시보드가 열렸거나 일회용 URL 제공

마지막으로 새 터미널을 열거나 macOS는 `source ~/.zshrc`, WSL은 `source ~/.bashrc`를 실행하면 된다고 안내한다.
