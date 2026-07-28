# 사전 준비 가이드 - Codex 버전

> 캠프 시작 전에 아래 순서대로 해주세요. 20~30분이면 됩니다.
> 막히면 슬랙 #ai-native-camp에서 물어봐주세요! 봇이 도와드립니다.

---

## Step 1: ChatGPT/Codex 계정 확인

1. ChatGPT 계정으로 로그인할 수 있는지 확인
2. 회사 ChatGPT Team/Business 초대가 있으면 먼저 수락
3. 개인 ChatGPT Plus/Pro 계정으로도 Codex 사용 가능

> Codex는 ChatGPT Plus, Pro, Business, Edu, Enterprise 플랜에 포함됩니다.
> 회사 계정 초대가 안 왔으면 슬랙에서 알려주세요.

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

## Step 3: Codex CLI 설치

### macOS

Homebrew가 있으면 아래 방식 추천:

```bash
brew install --cask codex
```

Homebrew는 있는데 위 명령이 막히면, Node.js 설치 후 npm으로 설치:

```bash
brew install node
npm i -g @openai/codex
```

> `brew`도 없고 `npm`도 없으면 슬랙에 알려주세요. 같이 설치하면 됩니다.

### Windows

이미 이 레포를 받은 상태면 **Git Bash**에서 아래 한 줄로 설치:

```bash
bash scripts/setup-windows-codex.sh
```

PowerShell을 쓰는 분은 이걸로도 됩니다:

```powershell
.\scripts\setup-windows-codex.ps1
```

레포를 아직 받기 전이면 Git Bash에서 수동 설치:

```bash
winget.exe install OpenJS.NodeJS.LTS
```

설치 후 Git Bash를 **껐다가 다시 열고**:

```bash
npm i -g @openai/codex
```

### 설치 확인

```bash
codex --version
```

버전이 나오면 설치 완료.

---

## Step 4: 캠프 레포 받기

```bash
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native
```

> `permission denied` 또는 `403`이 나오면 GitHub 초대를 수락했는지 확인해주세요. 안 되면 슬랙에 GitHub username을 남겨주세요.

---

## Step 5: Codex 로그인

터미널/PowerShell에서:

```bash
codex
```

1. 처음 실행하면 로그인 안내가 나옵니다
2. **Sign in with ChatGPT** 선택
3. 브라우저에서 ChatGPT 계정으로 로그인
4. 터미널로 돌아오면 Codex 시작

> 브라우저가 안 열리면 터미널에 표시된 URL을 복사해서 직접 열어주세요.

---

## Step 6: 확인

```bash
codex --version
node --version
git --version
python3 --version   # macOS
python --version    # Windows
```

`codex`, `node`, `git` 3개는 꼭 버전이 나와야 합니다.
Python은 없으면 나중에 필요할 때 설치해도 됩니다.

---

## Step 7: Zeude 가입 (모니터링 + 회사 스킬 자동 받기)

슬랙 #ai-native-camp 에서 받은 **Zeude 초대 링크**를 클릭하면 자동으로 가입 + `~/.zeude/credentials`가 생성됩니다.

링크가 안 왔거나 잃어버렸으면 슬랙에 요청.

링크 클릭 후 Codex에서:

```
/zeude-setup
```

이 한 번이 다음을 다 해줍니다:

- 텔레메트리 shim 설치 (Codex 사용 데이터가 팀 대시보드에 자동 기록)
- 회사 표준 스킬 자동 동기화 (`camp-onboarding`, `camp-review`, `tips` 등)
- 대시보드 자동 로그인 (`/zeude`로 언제든 재접속)

> `/zeude-setup`이 안 보이면 Codex를 새로 열고 다시 시도해주세요. 그래도 안 되면 슬랙에 알려주세요.

---

## Step 8: 회사 폴더 + 레포 받기

Codex에서:

```
/company-setup
```

이 스킬 한 번이:

- `~/Documents/company-code/` 표준 부모 폴더 생성
- `driving-teacher-ai-native` (캠프 자료) clone
- `driving-teacher-knowledge-base` (회사 KB) clone

> private 레포라 GitHub 권한 필요. 안 받아지면 슬랙에 GitHub username 보고 → admin 초대.
> 이미 다른 곳에 받아둔 게 있으면 자동 감지 후 표준 위치로 이동할지 물어봅니다.

---

## Step 9: 캠프 시작

Codex에서:

```
/camp-onboarding
```

4주 커리큘럼을 자기주도로 따라가는 안내가 시작됩니다.

캠프 끝나고 부분 복습 원하면:

```
/camp-review
```

---

## 빠른 셋업 시퀀스 (전체 요약)

```
Step 1: ChatGPT/Codex 계정 확인
Step 2: git 설치
Step 3: Codex CLI 설치
Step 4: 캠프 레포 받기
Step 5: codex 로그인
Step 6: 버전 확인
Step 7: /zeude-setup           ← 모니터링 + 스킬 자동 동기화
Step 8: /company-setup         ← 회사 폴더 + 레포
Step 9: /camp-onboarding       ← 4주 통수강 시작
```

총 20~30분. 막히면 #ai-native-camp.

---

## 안 될 때

| 증상 | 해결 |
|------|------|
| `git clone`이 안 됨 | git 미설치. Step 2부터 다시 |
| `codex`를 못 찾음 | 터미널/PowerShell **껐다 다시 열기** |
| `npm`을 못 찾음 | Node.js 설치 후 터미널/PowerShell **껐다 다시 열기** |
| `node`를 못 찾음 | 터미널/PowerShell **껐다 다시 열기** |
| Codex 로그인이 안 됨 | ChatGPT 계정/플랜 확인. 회사 초대가 있으면 먼저 수락 |
| 브라우저가 안 열림 | 터미널에 표시된 URL 복사 → 브라우저에서 직접 열기 |
| `/zeude-setup` 후에도 스킬이 안 보임 | Codex 새 창. 또는 `codex --version` 한번 호출 후 재시도 |
| `/company-setup` clone 403 | Driving Teacher GitHub 권한 없음 → 슬랙에 GitHub username 보고 |
| zeude credentials 잃어버림 | 슬랙에서 새 초대 링크 요청 |

그래도 안 되면 **슬랙에 에러 스크린샷** 올려주세요. 도와드립니다!

---

## Claude Code를 쓰는 경우

Claude Code로 참여하는 분은 기존 스크립트를 쓰면 됩니다.

### macOS

```bash
bash scripts/setup-mac.sh
```

### Windows

**WSL Ubuntu 터미널에서** 실행합니다 (PowerShell 아님):

```bash
bash scripts/setup-wsl.sh
```

이 스크립트는 git, Claude Code, Node.js, Python을 설치합니다.

> ⚠️ **네이티브 Windows(PowerShell)에 Claude Code를 깔면 안 됩니다.** Zeude 스킬 자동 동기화가 Mac/Linux 빌드만 있어서 `/ai-onboarding` 같은 회사 스킬이 아예 안 뜹니다. WSL 설치부터는 [`SETUP.md`](./SETUP.md) Step 0 참고.

Codex로 참여하는 분은 대신 Git Bash에서:

```bash
bash scripts/setup-windows-codex.sh
```

PowerShell을 쓰면:

```powershell
.\scripts\setup-windows-codex.ps1
```
