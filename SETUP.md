# 사전 준비 가이드

> 캠프 시작 전에 아래 순서대로 해주세요. 10분이면 됩니다.
> 막히면 슬랙에서 물어봐주세요!

---

## Step 0: Claude 계정 (필수)

Claude Code를 사용하려면 **유료 계정**이 필요합니다.

1. [claude.ai](https://claude.ai) 접속 → 계정이 없으면 가입
2. **Teams 초대**를 이메일로 보내드립니다 → 수락하면 끝
3. 별도 결제 필요 없음 (회사에서 Teams 플랜으로 일괄 결제)

---

## Step 0.5: GitHub 계정

1. [github.com](https://github.com) 접속
2. 계정이 없으면 **Sign up** → 가입 (무료)
3. 이미 있으면 넘어가세요
4. **가입 후 슬랙에 GitHub 아이디를 알려주세요** → 팀 레포에 초대해드립니다

> 초대를 받아야 캠프 레포를 받을 수 있습니다. 이메일로 초대장이 옵니다 — **Accept invitation** 클릭!

---

## Step 1: git 설치

### macOS

터미널을 엽니다. (Spotlight에서 "터미널" 검색하거나, `Cmd + Space` → "터미널")

```bash
git --version
```

- 버전이 나오면 → **이미 설치됨, Step 1로**
- "xcode-select" 팝업이 뜨면 → **"설치" 클릭** 후 완료될 때까지 대기 (5분)

### Windows

PowerShell을 엽니다. (시작 메뉴에서 "PowerShell" 검색)

```powershell
git --version
```

- 버전이 나오면 → **이미 설치됨, Step 1로**
- 에러가 나오면 → 아래 실행:

```powershell
winget install Git.Git
```

설치 후 PowerShell을 **껐다가 다시 열고** `git --version`으로 확인.

> `winget`도 안 되면? → 브라우저에서 https://git-scm.com/download/win 접속 → 다운로드 → 설치 (다음 다음 다음)

---

## Step 1: 세팅 스크립트 실행

### macOS

```bash
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native
bash scripts/setup-mac.sh
```

### Windows

PowerShell을 **관리자 권한**으로 엽니다.
(시작 메뉴에서 "PowerShell" 검색 → 우클릭 → "관리자로 실행")

```powershell

# PowerShell 껐다가 다시 관리자로 열기, 그 다음:
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native

# 세팅 스크립트 실행 (git, Claude Code, Node.js, Python 한 번에)
.\scripts\setup-windows.ps1
```

---

## 세팅이 설치하는 것

| 도구 | 용도 | 언제 쓰나 |
|------|------|----------|
| **git** | 레포 관리, 스킬 공유 | 매일 |
| **Claude Code** | AI 코딩/업무 도구 | 매일 |
| **Node.js** | 플러그인, MCP 서버 | Day 2~ |
| **Python** | 엑셀/데이터 처리, 일부 MCP | Day 2~ |

> 이미 설치되어 있으면 자동으로 건너뜁니다.

---

## 로그인

스크립트 완료 후, 터미널/PowerShell을 **껐다가 다시 열고**:

```bash
claude
```

1. 브라우저가 자동으로 열립니다
2. Claude.ai 계정으로 로그인합니다
3. 터미널로 돌아오면 자동으로 인증 완료

> 브라우저가 안 열리면 `c` 키를 눌러 URL을 복사하고 직접 열어주세요.

---

## Step 2: Google Drive MCP 연결 (선택)

Claude Code에서 Google Drive 파일을 읽을 수 있게 해줍니다.

```bash
bash scripts/setup-gdrive-mcp.sh
```

1. 브라우저가 열립니다
2. Google 계정으로 로그인 → **승인** 클릭
3. "Credentials saved" 메시지가 나오면 완료
4. Claude Code를 **재시작**하면 Google Drive MCP 사용 가능

> 안 되면 슬랙에 에러 메시지를 올려주세요.

---

## 확인

```bash
claude --version
node --version
python3 --version   # macOS
python --version    # Windows
git --version
```

4개 다 버전이 나오면 완료! **스크린샷을 슬랙 #ai-native 채널에 올려주세요.**

---

## 안 될 때

| 증상 | 해결 |
|------|------|
| `git clone`이 안 됨 | git 미설치. macOS: `xcode-select --install` / Windows: `winget install Git.Git` |
| `winget`을 못 찾음 | Windows 10 1809 이상 필요. Microsoft Store에서 "앱 설치 관리자" 업데이트 |
| `claude`를 못 찾음 | 터미널/PowerShell **껐다 다시 열기** |
| `node`를 못 찾음 | 터미널 **껐다 다시 열기**. macOS에서 안 되면 `source ~/.zshrc` |
| 로그인이 안 됨 | Claude Pro/Max/Teams 계정이 필요합니다 |
| 브라우저가 안 열림 | `c` 키 눌러서 URL 복사 → 브라우저에서 직접 열기 |
| 스크립트 실행 권한 에러 (Windows) | `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` 후 재시도 |

그래도 안 되면 **슬랙에 에러 스크린샷** 올려주세요. 도와드립니다!

---

## Claude 계정

Claude Code를 사용하려면 아래 중 하나의 계정이 필요합니다:

- Claude Pro ($20/월)
- Claude Max ($100/월 또는 $200/월)
- Claude Teams ($30/인/월)
- Claude Enterprise

계정이 없으면 [claude.ai](https://claude.ai)에서 가입하세요.
