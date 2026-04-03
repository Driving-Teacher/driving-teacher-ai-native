# 사전 준비 가이드

> 캠프 시작 전에 아래 순서대로 해주세요. 10분이면 됩니다.
> 막히면 슬랙 #ai-native-camp에서 물어봐주세요! 봇이 도와드립니다.

---

## Step 1: Claude Teams 초대 수락

1. 메일함에서 **Claude Teams 초대** 메일 확인
2. **Accept invitation** 클릭 → 끝!
3. 별도 결제 없음 (회사에서 일괄 결제)

> 초대 메일이 안 왔으면 슬랙에서 알려주세요.

---

## Step 2: git 설치

### macOS

터미널을 엽니다. (`Cmd + Space` → "터미널" 검색 → 엔터)

```bash
git --version
```

- 버전이 나오면 → **이미 설치됨, Step 3으로**
- "xcode-select" 팝업이 뜨면 → **"설치" 클릭** 후 완료될 때까지 대기 (5분)

### Windows

PowerShell을 엽니다. (시작 메뉴에서 "PowerShell" 검색)

```powershell
git --version
```

- 버전이 나오면 → **이미 설치됨, Step 3으로**
- 에러가 나오면 → 아래 실행:

```powershell
winget install Git.Git
```

설치 후 PowerShell을 **껐다가 다시 열고** `git --version`으로 확인.

> `winget`도 안 되면? → https://git-scm.com/download/win 에서 다운로드 → 설치 (다음 다음 다음)

---

## Step 3: 세팅 스크립트 실행

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
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native
.\scripts\setup-windows.ps1
```

> 실행 권한 에러가 나면: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` 입력 후 재시도

### 세팅이 설치하는 것

| 도구 | 용도 |
|------|------|
| **Claude Code** | AI 코딩/업무 도구 |
| **Node.js** | 플러그인, MCP 서버 |
| **Python** | 엑셀/데이터 처리, 일부 MCP |

> 이미 설치되어 있으면 자동으로 건너뜁니다.

---

## Step 4: Claude 로그인

스크립트 완료 후, 터미널/PowerShell을 **껐다가 다시 열고**:

```bash
claude
```

1. 브라우저가 자동으로 열립니다
2. Claude.ai 계정으로 로그인합니다
3. 터미널로 돌아오면 자동으로 인증 완료

> 브라우저가 안 열리면 `c` 키를 눌러 URL을 복사하고 직접 열어주세요.

---

## Step 5: 확인

```bash
claude --version
node --version
git --version
python3 --version   # macOS
python --version    # Windows
```

4개 다 버전이 나오면 완료! **슬랙 #ai-native-camp 세팅 스레드에 "완료" 남겨주세요.**

---

## 안 될 때

| 증상 | 해결 |
|------|------|
| `git clone`이 안 됨 | git 미설치. Step 2부터 다시 |
| `claude`를 못 찾음 | 터미널/PowerShell **껐다 다시 열기** |
| `node`를 못 찾음 | 터미널 **껐다 다시 열기**. macOS에서 안 되면 `source ~/.zshrc` |
| 로그인이 안 됨 | Teams 초대를 수락했는지 확인 (Step 1) |
| 브라우저가 안 열림 | `c` 키 눌러서 URL 복사 → 브라우저에서 직접 열기 |
| 스크립트 실행 권한 에러 (Windows) | `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned` 후 재시도 |

그래도 안 되면 **슬랙에 에러 스크린샷** 올려주세요. 도와드립니다!
