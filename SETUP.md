# 0단계 — 입사 첫날 셋업

> **이 문서가 끝나면 `/ai-onboarding` 한 줄을 칠 수 있습니다.** 거기서부터는 AI가 알아서 안내합니다.
>
> 지금은 컴퓨터에 아무것도 없는 상태를 가정합니다. 아래를 **위에서부터 순서대로** 따라와주세요.
> 설치 시간은 기존 도구와 네트워크 상태에 따라 달라집니다.
>
> 막히면 **5분만** 붙잡고 슬랙 `#ai-native`에 물어봐주세요. 프로그래밍 몰라도 됩니다 — 복붙만 하면 됩니다.

```
[지금 여기]  0단계 · 설치           ← 이 문서 (첫날 · Step 0~7)
     ↓
  /ai-onboarding  Step 1           Claude Code가 뭔지 · 방금 친 게 뭐였는지 (20~25분)
     │
     ├─→ /onboarding      Day 1~9    회사 · 우리 팀 · 옆 팀 · 사람 · 문화   하루 30분
     │
     └─→ /ai-onboarding   Step 2~13  CLAUDE.md · 내 첫 스킬 · Hermes · 선언  내 속도
```

> 온보딩은 **회사 온보딩**과 **AI 온보딩** 두 갈래입니다. 이 문서(설치)와 `/ai-onboarding` Step 1까지 하면 둘 다 시작할 수 있고, 그다음부터는 병행합니다.

---

## Step 0: OS 확인

**macOS** → 터미널을 열고 Step 1로.

**Windows** → 시작 메뉴에서 **PowerShell**을 열고 Step 1로. **WSL 설치는 필수가 아닙니다.** Zeude의 Windows용 설치기를 사용합니다.

### 이미 WSL을 쓰고 있다면 (선택)

기존 WSL2 Ubuntu 환경도 계속 사용할 수 있습니다. 이후 Windows PowerShell 명령 대신 WSL 명령을 따라가세요. 새로 WSL을 선택한다면 관리자 PowerShell에서 `wsl --install` 후 재부팅하고 Ubuntu 사용자 계정을 만듭니다.

Windows와 WSL의 프로그램·로그인·스킬·credentials는 별개입니다. 설치부터 실행까지 선택한 환경에서 진행하세요.

---

## Step 1: 회사 접속 준비 (CLIProxy + 슬랙)

회사 Tailscale에 연결하고 슬랙 `#ai-native`에 참여하세요. Claude 개인 계정이나 Claude Teams 초대는 필요하지 않습니다.

### 1-1. 회사 CLIProxy 키

담당자에게 개인 메시지로 `sk_`가 아닌 **`sk-`로 시작하는 CLIProxy 키**를 받으세요. 이 키는 Claude Code가 회사 AI 서비스를 쓰기 위한 접속 키입니다. 노션·공개 채널·스크린샷에 넣지 마세요.

### 1-2. 슬랙 `#ai-native` 채널

1. 슬랙 워크스페이스 초대를 수락 (입사 안내에 포함)
2. 채널 목록에서 **`#ai-native`** 검색 → 참여
3. 여기가 셋업 중 막혔을 때 물어보는 곳입니다

### 1-3. 여기서 미리 요청해둘 것

Step 6 이후에 필요한데 사람이 발급해주는 것들입니다. **지금 슬랙에 한 번에 요청해두면** 기다리지 않습니다.

```
#ai-native 에 이렇게 남기면 됩니다:

  오늘 입사한 {이름}입니다! 셋업 시작하는데 세 개 요청드려요.
  1) 회사 CLIProxy 키 (개인 DM으로 전달 부탁드립니다)
  2) Zeude 초대 링크
  3) GitHub 초대 — 제 아이디는 {github-username} 입니다
```

> 초대 메일이 안 왔거나 채널을 못 찾으면 입사 담당자에게 알려주세요.

---

## Step 2: git 설치

### macOS

터미널을 엽니다. (`Cmd + Space` → "터미널" 검색 → 엔터)

```bash
git --version
```

- 버전이 나오면 → **이미 설치됨, Step 3으로**
- "xcode-select" 팝업이 뜨면 → **"설치" 클릭** 후 완료될 때까지 대기 (5분)

### Windows (PowerShell)

```powershell
git --version
```

버전이 안 나오면 아래 명령으로 설치하고 PowerShell을 껐다 다시 여세요.

```powershell
winget install --id Git.Git --exact --accept-package-agreements --accept-source-agreements
```

### WSL Ubuntu (선택)

Ubuntu 터미널에서 `git --version`을 확인합니다. 없다면 `sudo apt update && sudo apt install -y git`을 실행하세요.

---

## Step 3: 세팅 스크립트 실행

### macOS

```bash
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native
bash scripts/setup-mac.sh
```

### Windows (PowerShell)

```powershell
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native
.\scripts\setup-windows.ps1
```

실행 정책 오류가 나오면 `Set-ExecutionPolicy -Scope Process RemoteSigned`를 실행한 뒤 다시 시도하세요. 회사 정책으로 차단되면 `#ai-native`에 문의해주세요.

### WSL Ubuntu (선택)

```bash
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native
bash scripts/setup-wsl.sh
```

### 어느 폴더에 받아야 하나요? — **아무 데나 괜찮습니다**

터미널을 열면 보통 **홈 폴더**(`~`)에서 시작합니다. 그냥 위 세 줄을 치면 홈 아래에 받아집니다. 그걸로 충분합니다.

따로 정리하고 싶으시면 원하는 폴더를 먼저 만들고 들어간 뒤 위 세 줄을 치세요. 예를 들어:

```bash
mkdir -p ~/dev && cd ~/dev      # macOS / WSL 예시
# PowerShell: New-Item -ItemType Directory -Force ~/dev; Set-Location ~/dev
```

> **어디에 받든 회사 도구는 알아서 찾습니다.** `/kb`·`/company-setup` 같은 것들이 홈 아래를 뒤져서 찾아냅니다.
> 하나만 기억하세요 — **`claude` 를 켤 때는 이 폴더 안에 들어와 있어야 합니다.** 그 이유는 Step 4에 있고, **정확한 경로는 설치가 끝나면 화면에 찍어드립니다.** 외울 필요 없습니다.
>
> (WSL을 선택한 경우에만 예외: `/mnt/c/...` 같은 **Windows 쪽 디스크는 피하세요.** 느리고 AI가 파일을 잘 못 찾습니다. Ubuntu 홈 `~` 아래면 됩니다.)

선택한 스크립트가 필요한 도구를 설치합니다. 설치 후 사용 중인 터미널을 **껐다가 다시 열어** PATH를 반영합니다.

> PowerShell에서는 `setup-windows.ps1`, Ubuntu에서는 `setup-wsl.sh`를 실행하세요.


### 세팅이 설치하는 것

| 도구 | 용도 |
|------|------|
| **git** | 회사 자료 받기 (Mac은 Xcode CLI Tools로) |
| **Claude Code** | AI 코딩/업무 도구 |
| **Node.js** | 플러그인, MCP 서버 |
| **Python** | 엑셀/데이터 처리, 일부 MCP |
| **gh** (GitHub CLI) | 비공개 회사 KB 받기 — 나중에 `/company-setup` 이 이걸 씁니다 |

> 이미 설치되어 있으면 자동으로 건너뜁니다. 여러 번 돌려도 안전합니다.

---

## Step 4: 회사 CLIProxy 연결

Claude Code는 먼저 설치만 합니다. **개인 Claude 계정 로그인은 필요하지 않습니다.** 아래에서 운영체제에 맞는 방법으로 회사 프록시에 연결한 뒤 `claude`에서 실제 답변이 오는지 확인하세요.

### macOS (zsh 또는 bash)

`echo $SHELL`을 실행하세요. `/bin/zsh`면 첫 번째, `/bin/bash`면 두 번째 명령을 사용합니다. 키는 터미널에 직접 입력하며 화면에 표시되지 않습니다.

**zsh:**

```zsh
read -r -s "KEY?CLIProxy 키: "; echo
printf '%s' "$KEY" > ~/.rr-proxy-key; chmod 600 ~/.rr-proxy-key; unset KEY
touch ~/.zshrc
printf '\nexport ANTHROPIC_BASE_URL="https://rr-proxy-vm.tail7f1c29.ts.net"\nexport ANTHROPIC_AUTH_TOKEN="$(cat ~/.rr-proxy-key)"\n' >> ~/.zshrc
```

**bash (Mac 로그인 셸):**

```bash
read -r -s -p "CLIProxy 키: " KEY; echo
printf '%s' "$KEY" > ~/.rr-proxy-key; chmod 600 ~/.rr-proxy-key; unset KEY
touch ~/.bash_profile
printf '\nexport ANTHROPIC_BASE_URL="https://rr-proxy-vm.tail7f1c29.ts.net"\nexport ANTHROPIC_AUTH_TOKEN="$(cat ~/.rr-proxy-key)"\n' >> ~/.bash_profile
```

설정 파일에 같은 두 줄이 이미 있다면 다시 추가하지 말고 기존 줄을 확인하세요.

**WSL Ubuntu를 선택했다면:** Ubuntu 터미널에서 아래를 실행하세요. Windows PowerShell에 설정한 환경변수는 WSL에 자동 적용되지 않습니다.

```bash
read -r -s -p "CLIProxy 키: " KEY; echo
printf '%s' "$KEY" > ~/.rr-proxy-key; chmod 600 ~/.rr-proxy-key; unset KEY
touch ~/.bashrc
printf '\nexport ANTHROPIC_BASE_URL="https://rr-proxy-vm.tail7f1c29.ts.net"\nexport ANTHROPIC_AUTH_TOKEN="$(cat ~/.rr-proxy-key)"\n' >> ~/.bashrc
```

### Windows (PowerShell)

CLIProxy 키는 개인 메시지로 받은 뒤 PowerShell에서 직접 입력하세요. 사용자 환경변수는 해당 Windows 계정에 평문으로 저장됩니다.

```powershell
[Environment]::SetEnvironmentVariable('ANTHROPIC_BASE_URL', 'https://rr-proxy-vm.tail7f1c29.ts.net', 'User')
$key = Read-Host 'CLIProxy 키' -AsSecureString
$plain = [Net.NetworkCredential]::new('', $key).Password
[Environment]::SetEnvironmentVariable('ANTHROPIC_AUTH_TOKEN', $plain, 'User')
Remove-Variable key, plain
```

### 연결 확인

터미널·PowerShell을 완전히 닫고 새로 여세요. Paseo를 쓰면 Paseo도 완전히 종료한 뒤 다시 엽니다. Tailscale 연결을 확인하고, 아래처럼 Claude Code를 실행해 짧은 질문에 **실제 답변이 오는지** 확인하세요. 버전 출력만으로는 프록시 연결을 확인할 수 없습니다.

CLIProxy 환경변수를 설정한 후, Step 3 마지막에 표시된 경로로 들어가 Claude Code를 실행합니다.

```bash
cd <설치가 알려준 경로>
claude
```

터미널(Mac) / PowerShell(Windows) / Ubuntu 터미널(WSL)을 **껐다가 다시 열고**, 그 두 줄을 **복사해서** 칩니다.

> **경로를 외우지 마세요.** 사람마다 다릅니다 — Step 3에서 본인이 받은 곳이 찍힙니다.
> 화면을 이미 닫아버렸으면, 레포 폴더로 들어가서 `pwd` 를 치면 지금 경로가 나옵니다.

### ⚠️ 첫 줄(`cd`)을 빠뜨리면 다음 Step에서 막힙니다

`cd`는 **"그 폴더로 들어가라"** 는 뜻입니다 (change directory). 터미널에서는 폴더를 더블클릭으로 여는 게 아니라 이 명령으로 엽니다.

**왜 그 폴더여야 하나** — Claude Code는 **지금 들어와 있는 폴더**에 있는 회사 도구만 알아봅니다. `/zeude-setup` 이 그 폴더 안에 들어 있어서, 다른 곳에서 켜면 **없는 것처럼 보입니다.**

> 옆방에 둔 책과 같습니다. 집에 있긴 한데, 지금 앉은 방에 없으면 못 읽습니다.

**터미널을 껐다 열면 `cd`가 풀립니다.** 새 창은 항상 홈 폴더에서 시작하니까요. Step 3에서 이미 들어갔었지만 **다시 들어가야 합니다.**

앞으로도 **회사 일을 할 때는 이 폴더에서** `claude` 를 켜세요.

개인 계정 로그인 화면이 나오거나 응답이 실패하면 Step 6으로 넘어가지 말고 CLIProxy 키·환경변수·Tailscale 연결을 확인하세요. WSL을 선택했다면 WSL 안에서 Linux용 셸 설정을 따로 해야 합니다.

---

## Step 5: 확인

```bash
claude --version
node --version
git --version
python3 --version   # macOS / WSL
# Windows PowerShell에서는 대신 python --version
```

> Step 4에서 `claude` 로 들어가 있으면 이 명령들이 안 먹습니다. **`/exit` 를 쳐서 Claude Code를 나온 다음** 위 4개를 확인하세요. 확인이 끝나면 Step 4의 두 줄(`cd` → `claude`)로 다시 들어갑니다.

4개 다 버전이 나오면 설치 완료. 여기까지가 터미널 작업이고, 남은 Step 6~7은 **Claude Code 안에서** 합니다. **두 줄이면 끝납니다.**

### Paseo 설치 (Mac·Windows)

Paseo에서 Claude Code를 사용할 분은 [Paseo 공식 다운로드](https://paseo.sh/download)에서 운영체제에 맞는 **데스크톱 앱**을 설치하세요. Paseo 앱에는 자체 실행 서비스가 포함되어 있어 별도의 Paseo CLI 설치는 필요하지 않습니다. Claude Code와 회사 CLIProxy 연결은 위 단계에서 먼저 끝내야 합니다.

Paseo가 이미 열려 있다면 완전히 종료하세요. 아래 Step 6에서 Zeude를 설치한 **뒤에 Paseo를 다시 열어야** 새 환경변수와 Zeude 실행 경로가 적용됩니다.

---

## 잠깐 — `/`로 시작하는 게 뭔가요?

Step 6부터는 `/zeude-setup` 처럼 **슬래시(`/`)로 시작하는 것**을 칩니다. 치기 전에 3줄만 알고 가세요.

1. `/`로 시작하는 건 **미리 만들어둔 작업 묶음**입니다. 회사가 만들어 나눠준 것이고, 나중엔 여러분도 만들 수 있습니다.
2. **나머지는 그냥 한국어로 말하면 됩니다.** 외울 명령어는 없습니다 — "이거 정리해줘" 처럼 말하면 됩니다.
3. **틀려도 안 부서집니다.** 편하게 하세요. 5분 넘게 막히면 슬랙에.

> 각각이 정확히 뭘 하는 건지는 **Step 7(`/ai-onboarding`)에서 제대로 설명**해드립니다. 지금은 아래 두 개를 순서대로 치면 됩니다.

---

## Step 6: Zeude 가입 (모니터링 + 회사 스킬 자동 받기)

슬랙 #ai-native에서 받은 **Zeude 초대 링크**로 가입하고 설치 안내를 확인합니다. 기존 credentials가 있으면 재사용하며, 없을 때만 발급받은 agent key를 설치기에 입력합니다. 키는 슬랙이나 커밋에 올리지 마세요.

링크가 안 왔거나 잃어버렸으면 슬랙에 요청.

링크를 열면 **`zd_` 로 시작하는 긴 글자**가 나옵니다. **그 화면을 닫지 말고** 아래를 진행하세요 — 곧 붙여넣으라고 물어봅니다.

Claude Code에서:

```
/zeude-setup
```

`zd_...` 를 붙여넣으라고 하면 초대 링크 화면에서 복사해 붙여넣으면 됩니다.

> **`/zeude-setup` 이 목록에 안 뜨나요?** Step 4의 `cd` 를 빠뜨린 겁니다. Claude Code를 나가서(`/exit`) **레포 폴더로 들어간 뒤** `claude` 를 다시 켜세요. 경로가 기억 안 나면 Step 3 화면에 찍힌 두 줄을 쓰시면 됩니다.

이 한 번이 다음을 다 해줍니다:
- 텔레메트리 shim 설치 (Claude Code 사용 데이터가 팀 대시보드에 자동 기록)
- 회사 표준 스킬 자동 동기화 (`ai-onboarding`, `onboarding`, `kb`, `tips` 등 10개+)
- 대시보드 자동 로그인 (`/zeude`로 언제든 재접속)

Paseo를 설치했다면 이제 앱을 다시 열고 Claude 세션에서 짧은 질문을 보내세요. Windows에서는 새 PowerShell의 `Get-Command claude -All` 첫 결과가 `.zeude\bin\claude.exe`인지 확인합니다. Paseo가 `claude`를 실행 파일의 절대경로로 직접 호출하면 Zeude를 거치지 않을 수 있습니다. 대시보드에 **본인 기록이 실제로 들어오는지** 확인하세요. Windows의 Paseo→Zeude 기록 수집은 아직 실기기 검증 전입니다.

> ⚠️ **이걸 먼저 해야 다음 Step의 `/ai-onboarding`이 생깁니다.** 회사 스킬은 전부 여기서 받아옵니다. 가입은 1번만.

> 💡 **회사에 새 스킬을 풀고 싶을 때**: `Zeude 대시보드 > Skills 탭 > 스킬등록`. 모든 멤버 admin이라 셀프 서비스 — 등록하면 팀 전원의 다음 sync에 자동 반영됩니다. (자세한 분류는 [README의 "스킬 살림터"](./README.md#스킬-살림터--어디에-뭘-두나) 참고)

---

## Step 7: 시작 🎉

여기까지 왔으면 설치 끝. 이제 한 줄만 치면 됩니다.

```
/ai-onboarding
```

**여러분이 외울 건 여기까지입니다.** 남은 준비(회사 자료 받기·노션 연결)는 `/ai-onboarding`이 안내하거나 대신 해줍니다.

방금 친 `/zeude-setup`이 뭐였는지, Claude Code가 ChatGPT 웹창과 뭐가 다른지부터 알려줍니다. **20~25분이면 끝나고, 거기까지 하면 회사 온보딩을 시작할 수 있습니다.**

중간에 *"요즘 하는 일 중에 이거 AI가 해주면 좋겠다 싶은 것"* 을 하나 물어봅니다. 한 줄로 답해두시면 나중에 그걸 **명령어 하나로 만들어 드립니다.**

### 온보딩은 두 갈래입니다

| | 무엇 | 리듬 |
|---|---|---|
| **회사 온보딩** `/onboarding` | 회사·우리 팀·옆 팀·함께 일하는 사람들·문화·첫 과제 | Day 1~9 · 하루 30분 |
| **AI 온보딩** `/ai-onboarding` | Claude Code로 일하는 법 · 내 첫 스킬 · Hermes · 선언 | Step 1~13 · 내 속도 |

**`/ai-onboarding` Step 1을 마치면 두 트랙을 병행합니다.** 어느 쪽을 먼저 부르든 서로의 진척을 알고 이어줍니다.

```
설치 (여기까지)
   ↓
/ai-onboarding  Step 1 ─┬─→ Step 2 → ... → 13    내 속도
                        │
/onboarding             └─→ Day 1 → ... → Day 9   하루 30분
```

> 급하지 않습니다. 하루에 얼마나 할지는 `/ai-onboarding`이 매번 물어보고 그만큼만 진행합니다.

---

## 부록 — 막혔을 때 직접 하는 법

**정상 흐름에서는 필요 없습니다.** `/ai-onboarding`이 알아서 안내합니다. 아래는 스킬이 안 뜨거나 중간에 막혔을 때의 탈출구입니다.

### 회사 자료 받기

```
/company-setup
```

`driving-teacher-ai-native`(캠프·온보딩 자료)와 `driving-teacher-knowledge-base`(회사 KB)를 받아옵니다. 이미 받아둔 게 있으면 **자동으로 찾아내서** 그 자리를 그대로 씁니다.

> 둘 중 `driving-teacher-knowledge-base`(회사 KB)는 **비공개 레포**라서 GitHub 권한이 필요합니다. 안 받아지면 슬랙에 GitHub username 보고 → admin이 권한을 줍니다.
> 이미 다른 곳에 받아둔 게 있으면 자동 감지 후 표준 위치로 이동할지 물어봅니다.

### 노션 연결

```
/mcp
```

목록에서 **`claude.ai Notion`** 을 고르고 Authenticate → 브라우저에서 **회사 노션 계정**으로 승인. 다시 `/mcp` 를 쳤을 때 이렇게 보이면 성공:

```
claude.ai Notion: https://mcp.notion.com/mcp - ✔ Connected
```

> 노션 없이도 온보딩은 진행됩니다. 다만 진척이 저장 안 돼서 매번 "어디까지 하셨어요?"를 되묻습니다.

---

## 캠프 자료 복습 (기존 팀원용)

AI Native Camp 4주 세션을 들었던 분이 부분 복습을 원하면:

```
/camp-review
```

---

## 빠른 셋업 시퀀스 (전체 요약)

```
Step 0: Mac은 터미널 / Windows는 PowerShell (기존 WSL도 선택 가능)
Step 1: Tailscale 연결 + CLIProxy 키·Zeude 초대 요청
Step 2: git 설치 (Mac: Xcode / Windows: winget / WSL: apt)
Step 3: Mac: bash scripts/setup-mac.sh
        Windows: .\scripts\setup-windows.ps1
        WSL 선택 시: bash scripts/setup-wsl.sh
Step 4: CLIProxy 환경변수 설정 + 실제 Claude 응답 확인
Step 5: 버전 확인 4개
        Paseo를 쓴다면 공식 데스크톱 앱 설치 (Zeude 설치 뒤 재시작)
        ┈┈ 여기까지 터미널. 아래는 Claude Code 안에서 ┈┈
Step 6: /zeude-setup           ← 회사 스킬 동기화 + 모니터링 (먼저 해야 나머지가 생김)
Step 7: /ai-onboarding         ← ★ 종착지. 남은 준비는 이 스킬이 안내합니다

그다음: /onboarding            ← 회사 온보딩 (Day 1~9 · 하루 30분)
```

설치 시간은 기존 도구와 네트워크 상태에 따라 달라집니다. 막히면 #ai-native.

---

## 안 될 때

| 증상 | 해결 |
|------|------|
| `wsl --install`이 안 됨 (Windows) | PowerShell을 **관리자 권한**으로 실행했는지 확인. 그래도 안 되면 Windows 업데이트 후 재시도 |
| (Windows) 스킬이 안 뜸 / `/company-setup` 없음 | `Get-Command claude`로 Zeude shim 경로인지 확인하고 `zeude doctor` 실행. `/zeude-setup`에서 스킬 동기화 확인 |
| `git clone`이 안 됨 | git 미설치. Step 2부터 다시 |
| `claude`를 못 찾음 | 터미널 **껐다 다시 열기**. WSL은 `source ~/.bashrc` |
| `node`를 못 찾음 | 터미널 **껐다 다시 열기**. macOS는 `source ~/.zshrc`, WSL은 `source ~/.bashrc` |
| Claude가 답변하지 않음 | Tailscale 연결, CLIProxy 키와 Step 4 환경변수 확인. 새 터미널에서 다시 실행 |
| 개인 Claude 로그인 화면이 나옴 | Step 4의 환경변수가 현재 프로세스에 적용됐는지 확인. 터미널·Paseo를 완전히 재시작 |
| Paseo에서만 Zeude 기록이 안 보임 | Paseo 완전 종료 후 재시작. Windows는 `Get-Command claude -All`로 shim 우선순위 확인 |
| `/zeude-setup` 후에도 스킬이 안 보임 | Claude Code 새 창. 또는 `claude --version` 한번 호출해서 sync trigger. (Windows는 `Get-Command claude`로 shim 경로 확인) |
| `/company-setup` clone 403 | 비공개 레포(회사 KB) 권한 없음 → 슬랙에 GitHub username 보고 |
| zeude credentials 잃어버림 | 슬랙에서 새 초대 링크 요청 (호스트가 `/zeude-invite 1`로 발급) |
| `/mcp`에 Notion이 "Needs authentication" | 그 항목 선택 → Authenticate → 브라우저에서 **회사 노션 계정**으로 승인 (개인 계정 아님) |
| 노션 연결했는데 온보딩이 진척을 못 찾음 | Claude Code 새 창으로 다시 호출. 그래도 안 되면 노션에서 온보딩 페이지 접근 권한 요청 |
| **`/zeude-setup`이 없다고 나옴** | **Step 4의 `cd` 를 빠뜨린 것.** `/exit` → 레포 폴더로 `cd` → `claude` 로 다시 켜기 (경로는 Step 3 화면 마지막에 찍혀 있습니다) |
| `/ai-onboarding`·`/onboarding`이 없다고 나옴 | Step 6 `/zeude-setup`이 안 끝난 것 (스킬은 Zeude가 동기화). 새 창 후 재시도 |
| Claude Code 안에서 `claude --version` 등이 안 먹음 | 대화창 안이라서 그렇습니다. `/exit` 로 나와서 터미널에서 치세요 |
| 초대 링크 화면을 닫아버려서 `zd_` 키를 잃음 | 슬랙 `#ai-native` 에 재발급 요청 (링크는 1시간 후 만료됩니다) |
| `/kb`가 회사 자료를 못 찾음 | `/company-setup`이 안 끝난 것 (`/ai-onboarding` 중간에 실행됩니다). 직접 `/company-setup` 재실행 |
| 스킬은 뜨는데 "무슨 뜻인지 모르겠음" | 정상입니다. Step 7 `/ai-onboarding`이 하나씩 설명해줍니다 |

그래도 안 되면 **슬랙에 에러 스크린샷** 올려주세요. 도와드립니다!
