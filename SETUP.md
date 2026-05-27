# 사전 준비 가이드

> 캠프 시작 전에 아래 순서대로 해주세요. macOS 10분 / Windows는 WSL 설치 포함 30분.
> 막히면 슬랙 #ai-native-camp에서 물어봐주세요! 봇이 도와드립니다.

---

## Step 0: OS 확인 (Windows는 WSL 필수)

**macOS** → 바로 Step 1로.

**Windows** → 아래 WSL(Ubuntu)을 먼저 설치하고, **이후 모든 단계를 Ubuntu 터미널 안에서** 진행합니다.

> ⚠️ **왜 WSL이 필수인가**: Zeude의 스킬 자동 동기화(`company-setup`·`kb`·`graphify` 등 회사 표준 스킬)는 shim이 담당하는데, 이 shim은 **Mac/Linux 빌드만** 있습니다. 네이티브 Windows에선 텔레메트리(모니터링)는 되지만 **스킬 자동 동기화가 안 됩니다.** WSL(=Linux) 안에서 돌리면 Mac과 동일하게 전부 작동합니다.

### WSL 설치

1. **PowerShell을 관리자 권한으로** 엽니다 (시작 메뉴 → "PowerShell" → 우클릭 → "관리자로 실행")
2. 설치:

```powershell
wsl --install
```

3. **재부팅**
4. 재부팅 후 Ubuntu 창이 자동으로 뜨면 → **사용자 이름 + 비밀번호** 설정 (비밀번호는 입력해도 화면에 안 보이는 게 정상)
   - Ubuntu 창이 안 뜨면: 시작 메뉴에서 **"Ubuntu"** 검색 → 실행
5. 이제부터 **이 Ubuntu 터미널** 안에서 아래 Step들의 **macOS 명령**을 따라가면 됩니다 (git만 apt로 설치 — Step 2 참고).

> 이미 WSL Ubuntu가 깔려 있으면 Ubuntu 터미널만 열고 Step 1로.

### WSL(Ubuntu) 터미널 켜는 법

다음부터 **Claude Code 작업은 항상 Ubuntu 터미널에서** 합니다 (네이티브 PowerShell/CMD ❌ — 거기선 설치한 claude·스킬이 안 보임).

- **제일 쉬움**: Windows 키 → `Ubuntu` 타이핑 → 엔터
- **Windows Terminal**: 상단 탭 `∨` → Ubuntu 선택 (매번 귀찮으면 Settings → Default profile을 Ubuntu로)
- **아무 터미널에서**: `wsl` 입력 → 현재 창이 Ubuntu로 전환
- **VSCode 쓰면**: "WSL" 확장 설치 → 좌하단 `><` → "Connect to WSL" (터미널·Claude Code 확장이 전부 WSL에서 돌아감, 추천)

확인:
```bash
uname -a    # Linux ... 라고 나오면 WSL 정상
```

> `wsl`이 "명령을 찾을 수 없음" → WSL 미설치. 위 'WSL 설치'부터.

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

### Windows (WSL Ubuntu)

**Ubuntu 터미널 안에서** 실행합니다 (PowerShell 아님).

```bash
git --version
```

- 버전이 나오면 → **이미 설치됨, Step 3으로**
- 에러가 나오면 → 아래 실행:

```bash
sudo apt update && sudo apt install -y git
```

> 비밀번호를 물으면 WSL 설치 때 만든 비밀번호 입력 (화면에 안 보이는 게 정상).

---

## Step 3: 세팅 스크립트 실행

### macOS

```bash
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native
bash scripts/setup-mac.sh
```

### Windows (WSL Ubuntu)

**Ubuntu 터미널 안에서** 아래를 순서대로 실행합니다. (`setup-mac.sh`는 macOS 전용이라 WSL에선 아래 명령을 직접 씁니다.)

```bash
# 1) 레포 받기
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native

# 2) Claude Code 설치
curl -fsSL https://claude.ai/install.sh | bash

# 3) Node.js 설치 (fnm)
curl -fsSL https://fnm.vercel.app/install | bash
source ~/.bashrc
fnm install --lts

# 4) Python (보통 Ubuntu에 기본 포함, 없으면)
sudo apt install -y python3
```

설치 후 Ubuntu 터미널을 **껐다가 다시 열어** PATH를 반영합니다.

> 💡 TODO(운영): 위 WSL 단계를 자동화하는 `scripts/setup-wsl.sh`를 추가하면 Windows 입사자도 한 줄로 끝납니다.

### 세팅이 설치하는 것

| 도구 | 용도 |
|------|------|
| **Claude Code** | AI 코딩/업무 도구 |
| **Node.js** | 플러그인, MCP 서버 |
| **Python** | 엑셀/데이터 처리, 일부 MCP |

> 이미 설치되어 있으면 자동으로 건너뜁니다.

---

## Step 4: Claude 로그인

설치 완료 후, 터미널(Mac) / Ubuntu 터미널(WSL)을 **껐다가 다시 열고**:

```bash
claude
```

1. 브라우저가 자동으로 열립니다
2. Claude.ai 계정으로 로그인합니다
3. 터미널로 돌아오면 자동으로 인증 완료

> 브라우저가 안 열리면 `c` 키를 눌러 URL을 복사하고 직접 열어주세요.
> (WSL은 Windows 기본 브라우저가 열립니다. 안 열리면 URL 복사 방식 사용.)

---

## Step 5: 확인

```bash
claude --version
node --version
git --version
python3 --version   # macOS
python --version    # Windows
```

4개 다 버전이 나오면 인프라 준비 완료. 이제 캠프 셋업으로 갑니다.

---

## Step 6: Zeude 가입 (모니터링 + 회사 스킬 자동 받기)

슬랙 #ai-native-camp 에서 받은 **Zeude 초대 링크**를 클릭하면 자동으로 가입 + `~/.zeude/credentials` 박힘.

링크가 안 왔거나 잃어버렸으면 슬랙에 요청.

링크 클릭 후 Claude Code에서:

```
/zeude-setup
```

이 한 번이 다음을 다 해줍니다:
- 텔레메트리 shim 설치 (Claude Code 사용 데이터가 팀 대시보드에 자동 기록)
- 회사 표준 스킬 자동 동기화 (`camp-onboarding`, `camp-review`, `tips` 등 10개+)
- 대시보드 자동 로그인 (`/zeude`로 언제든 재접속)

> 캠프 끝나도 회사 표준 스킬은 이걸로 받습니다. 가입은 1번만.

---

## Step 7: 회사 폴더 + 레포 받기

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

## Step 8: 캠프 시작

```
/camp-onboarding
```

4주 커리큘럼을 자기주도로 따라가는 안내가 시작됩니다 (Week 1 환경 → Week 4 Ouroboros + 선언).

캠프 끝나고 부분 복습 원하면:
```
/camp-review
```

---

## 빠른 셋업 시퀀스 (전체 요약)

```
Step 0: (Windows만) wsl --install → 재부팅 → 이후 Ubuntu 터미널에서 진행
Step 1: Claude Teams 초대 수락 (메일)
Step 2: git 설치 (Mac: 자동 / WSL: sudo apt install -y git)
Step 3: Mac: bash scripts/setup-mac.sh / WSL: claude.ai·fnm 수동 설치
Step 4: claude 로그인
Step 5: 버전 확인 4개
Step 6: /zeude-setup           ← 모니터링 + 스킬 자동 동기화
Step 7: /company-setup         ← 회사 폴더 + 레포
Step 8: /camp-onboarding       ← 4주 통수강 시작
```

Mac 30~40분 / Windows는 WSL 설치 포함 50분~1시간. 막히면 #ai-native-camp.

---

## 안 될 때

| 증상 | 해결 |
|------|------|
| `wsl --install`이 안 됨 (Windows) | PowerShell을 **관리자 권한**으로 실행했는지 확인. 그래도 안 되면 Windows 업데이트 후 재시도 |
| (Windows) 스킬이 안 뜸 / `/company-setup` 없음 | 네이티브 Windows(PowerShell)에서 돌린 경우. **WSL Ubuntu 안에서** Step 2부터 다시 (shim이 Linux에서만 동기화) |
| `git clone`이 안 됨 | git 미설치. Step 2부터 다시 |
| `claude`를 못 찾음 | 터미널 **껐다 다시 열기**. WSL은 `source ~/.bashrc` |
| `node`를 못 찾음 | 터미널 **껐다 다시 열기**. macOS는 `source ~/.zshrc`, WSL은 `source ~/.bashrc` |
| 로그인이 안 됨 | Teams 초대를 수락했는지 확인 (Step 1) |
| 브라우저가 안 열림 | `c` 키 눌러서 URL 복사 → 브라우저에서 직접 열기 |
| `/zeude-setup` 후에도 스킬이 안 보임 | Claude Code 새 창. 또는 `claude --version` 한번 호출해서 sync trigger. (Windows는 WSL인지 먼저 확인) |
| `/company-setup` clone 403 | driving-teacher-bot org 멤버 아님 → 슬랙에 GitHub username 보고 |
| zeude credentials 잃어버림 | 슬랙에서 새 초대 링크 요청 (호스트가 `/zeude-invite 1`로 발급) |

그래도 안 되면 **슬랙에 에러 스크린샷** 올려주세요. 도와드립니다!
