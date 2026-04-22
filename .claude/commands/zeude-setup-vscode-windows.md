---
name: zeude-setup-vscode-windows
description: Windows에서 VSCode extension 으로 Claude Code 써도 Zeude 에 잡히게. PowerShell setx 로 OTEL env 영구 등록.
allowed-tools: Bash, Read, Write
---

Windows 에서 VSCode Claude Code extension 사용 시 Zeude 에 세션이 잡히도록
PowerShell `[Environment]::SetEnvironmentVariable` 로 사용자 레벨 영구 환경변수 등록.
Windows 는 macOS `launchctl` 같은 게 없어서 시스템 env 에 직접 박는 방식.

## 플랫폼 체크

```bash
uname -s
```

- `MINGW*` / `MSYS*` / `CYGWIN*` / `Windows_NT` — Windows, 계속 진행
- `Darwin` — "macOS 는 `/zeude-setup-vscode` 를 쓰세요" 안내 후 중단
- `Linux` — "Linux 는 추후 지원" 안내 후 중단

## 사전 준비

Windows 에는 현재 Zeude CLI shim 이 없어서 env 자동 dump 불가. 사용자가 **본인 값을 입력**해야 함:

1. **agent_key** — Zeude admin 에서 발급받은 `zd_...` 로 시작하는 키
2. **zeude.user.email** — 본인 업무 이메일
3. **zeude.user.id** — Zeude 대시보드 프로필에서 확인 (또는 agent_key 로 API 조회)

사용자에게 물어본다:

> "Zeude 초대 메일에서 받은 정보가 필요합니다:
>  1. agent_key (zd_로 시작)
>  2. 본인 이메일
>  3. user.id (Zeude 대시보드 > 프로필 > User ID, UUID 형식)
>
>  셋 다 알려주세요."

입력 검증:
- agent_key: `zd_` 시작 + 67자
- email: `@` 포함
- user.id: UUID 형식 (`xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)

## 진행

### 1. PowerShell 로 env 영구 등록

Git Bash / WSL 에서 powershell.exe 호출해서 사용자 환경변수 설정:

```bash
# 각 env 변수를 사용자 레벨 영구 등록 (setx 보다 PowerShell 이 긴 값 OK)
pwsh_cmd() {
  powershell.exe -NoProfile -Command "[Environment]::SetEnvironmentVariable('$1', '$2', 'User')"
}

pwsh_cmd "CLAUDE_CODE_ENABLE_TELEMETRY" "1"
pwsh_cmd "OTEL_EXPORTER_OTLP_ENDPOINT" "http://34.64.239.89:4318"
pwsh_cmd "OTEL_EXPORTER_OTLP_PROTOCOL" "http/protobuf"
pwsh_cmd "OTEL_EXPORTER_OTLP_METRICS_TEMPORALITY_PREFERENCE" "delta"
pwsh_cmd "OTEL_LOG_TOOL_DETAILS" "1"
pwsh_cmd "OTEL_LOG_USER_PROMPTS" "1"
pwsh_cmd "OTEL_LOGS_EXPORTER" "otlp"
pwsh_cmd "OTEL_METRICS_EXPORTER" "otlp"
pwsh_cmd "OTEL_TRACES_EXPORTER" "otlp"

# RESOURCE_ATTRIBUTES 에 zeude.source=vscode 포함 — VSCode 유입 식별자
USER_ID="<사용자 입력 user.id>"
USER_EMAIL="<사용자 입력 email>"
pwsh_cmd "OTEL_RESOURCE_ATTRIBUTES" "zeude.user.id=${USER_ID},zeude.user.email=${USER_EMAIL},zeude.team=default,zeude.source=vscode"
```

`powershell.exe` 대신 `pwsh` (PowerShell 7) 가 설치돼있으면 그거 써도 됨.

### 2. 등록 확인

```bash
powershell.exe -NoProfile -Command "[Environment]::GetEnvironmentVariable('OTEL_EXPORTER_OTLP_ENDPOINT', 'User')"
```

출력이 `http://34.64.239.89:4318` 나와야 성공.

### 3. 사용자에게 재시작 안내

```
✅ Zeude × VSCode 연동 완료 (Windows)

다음 단계:
1. VSCode 완전 종료 (File > Exit 또는 Alt+F4) — 트레이 아이콘도 확인
2. VSCode 다시 열기
3. Claude Code extension 에서 새 세션 시작
4. 1-2분 후 https://zeude.vercel.app/admin/analytics 에서 확인

⚠️ 등록한 env 는 재부팅해도 유지됩니다.
   해제하려면 제어판 > 시스템 > 고급 시스템 설정 > 환경 변수 > 사용자 변수 에서
   OTEL_* / CLAUDE_CODE_* 삭제
```

## 검증 (선택)

VSCode 재시작 후 새 터미널(Git Bash 또는 PowerShell) 열고:

```bash
# Claude Code extension 프로세스 env 확인 (Git Bash)
# 프로세스 ID 찾기:
powershell.exe -NoProfile -Command "Get-Process | Where-Object { \$_.Path -like '*anthropic.claude-code*native-binary*' } | Select-Object Id, Path"

# 찾은 PID 의 env (PowerShell):
# Get-Process -Id <PID> -Module 은 env 직접 제공 X — 대안은 Process Explorer
# 실무적으론 ClickHouse 에서 zeude.source=vscode 이벤트 뜨는지 확인이 빠름
```

가장 확실한 검증은 Zeude 대시보드에서 **`zeude.source=vscode` 이벤트** 가 뜨는지 확인.

## 문제 해결

- **`powershell.exe: command not found`**: Git Bash PATH 에 Windows PowerShell 없음. 절대 경로 사용:
  `/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe`
- **env 가 등록 됐는데 VSCode 에 안 잡힘**: VSCode 가 tray 에 남아있을 수 있음. 작업 관리자에서 `Code.exe` 프로세스 전부 종료 후 재실행.
- **값에 공백이나 특수문자**: PowerShell 쿼트 이스케이프 필요. `"` 를 `\"` 로.
- **WSL 환경**: WSL 은 Windows env 상속 안 함. WSL 내부에선 `~/.profile` 에 `export OTEL_*` 추가하고 `source ~/.profile` 필요. VSCode Remote-WSL 쓰면 WSL env 사용.

## 주의

- **Windows 전용**. macOS 는 `/zeude-setup-vscode` (LaunchAgent).
- Zeude CLI shim 이 Windows 에 없으므로 env 자동 dump 불가 — 사용자 입력 의존.
- `OTEL_RESOURCE_ATTRIBUTES` 의 user.id/email 은 **사람마다 다름**. 공유 금지.
- 과거 세션 backfill 불가.
- 이 스킬은 **Git Bash 또는 WSL 에서 Claude Code CLI 가 돌 때** 실행된다고 가정. 순수 PowerShell 만 있으면 Bash 명령 안 먹히니 명령 변환 필요.
