# 0단계 — 입사 첫날 셋업

> **이 문서가 끝나면 `/ai-onboarding` 한 줄을 칠 수 있습니다.** 거기서부터는 AI가 알아서 안내합니다.
>
> 지금은 컴퓨터에 아무것도 없는 상태를 가정합니다. 아래를 **위에서부터 순서대로** 따라와주세요.
> macOS 30~40분 / Windows는 WSL 설치 포함 50분~1시간.
>
> 막히면 **5분만** 붙잡고 슬랙 `#ai-native-camp`에 물어봐주세요. 프로그래밍 몰라도 됩니다 — 복붙만 하면 됩니다.

```
[지금 여기]  0단계 · 설치           ← 이 문서 (첫날 · Step 0~9)
     ↓
  /ai-onboarding  Step 1           Claude Code가 뭔지 · 방금 친 게 뭐였는지 (20~25분)
     │
     ├─→ /onboarding      Day 1~9    회사 · 우리 팀 · 옆 팀 · 사람 · 문화   하루 30분
     │
     └─→ /ai-onboarding   Step 2~13  CLAUDE.md · 내 첫 스킬 · Hermes · 선언  내 속도
```

> 온보딩은 **회사 온보딩**과 **AI 온보딩** 두 갈래입니다. 이 문서(설치)와 `/ai-onboarding` Step 1까지 하면 둘 다 시작할 수 있고, 그다음부터는 병행합니다.

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

**Ubuntu 터미널 안에서** 실행합니다 (PowerShell 아님 — Step 0 참고).

```bash
git clone https://github.com/Driving-Teacher/driving-teacher-ai-native.git
cd driving-teacher-ai-native
bash scripts/setup-wsl.sh
```

Mac과 똑같이 git·Claude Code·Node.js·Python이 한 번에 깔립니다. 설치 후 Ubuntu 터미널을 **껐다가 다시 열어** PATH를 반영합니다.

> 실수로 PowerShell에서 돌리면 스크립트가 **스스로 멈추고** WSL로 안내합니다.


### 세팅이 설치하는 것

| 도구 | 용도 |
|------|------|
| **git** | 회사 자료 받기 (WSL만 — Mac은 Xcode CLI Tools로) |
| **Claude Code** | AI 코딩/업무 도구 |
| **Node.js** | 플러그인, MCP 서버 |
| **Python** | 엑셀/데이터 처리, 일부 MCP |

> 이미 설치되어 있으면 자동으로 건너뜁니다. 여러 번 돌려도 안전합니다.

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

4개 다 버전이 나오면 설치 완료. 여기까지가 터미널 작업이고, 남은 Step 6~9는 **Claude Code 안에서** 합니다.

---

## 잠깐 — `/`로 시작하는 게 뭔가요?

Step 6부터는 `/zeude-setup` 처럼 **슬래시(`/`)로 시작하는 것**을 칩니다. 치기 전에 3줄만 알고 가세요.

1. `/`로 시작하는 건 **미리 만들어둔 작업 묶음**입니다. 회사가 만들어 나눠준 것이고, 나중엔 여러분도 만들 수 있습니다.
2. **나머지는 그냥 한국어로 말하면 됩니다.** 외울 명령어는 없습니다 — "이거 정리해줘" 처럼 말하면 됩니다.
3. **틀려도 안 부서집니다.** 편하게 하세요. 5분 넘게 막히면 슬랙에.

> 각각이 정확히 뭘 하는 건지는 **Step 9(`/ai-onboarding`)에서 제대로 설명**해드립니다. 지금은 아래 세 개를 순서대로 치면 됩니다.

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
- 회사 표준 스킬 자동 동기화 (`ai-onboarding`, `onboarding`, `kb`, `tips` 등 10개+)
- 대시보드 자동 로그인 (`/zeude`로 언제든 재접속)

> ⚠️ **이걸 먼저 해야 Step 9의 `/ai-onboarding`이 생깁니다.** 회사 스킬은 전부 여기서 받아옵니다. 가입은 1번만.

> 💡 **회사에 새 스킬을 풀고 싶을 때**: `Zeude 대시보드 > Skills 탭 > 스킬등록`. 모든 멤버 admin이라 셀프 서비스 — 등록하면 팀 전원의 다음 sync에 자동 반영됩니다. (자세한 분류는 [README의 "스킬 살림터"](./README.md#스킬-살림터--어디에-뭘-두나) 참고)

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

## Step 8: 노션 연결

온보딩이 **노션**에서 회사·팀 자료를 읽어오고, 여러분의 진척(`온보딩 진행 · {이름}`)을 노션에 저장합니다. 연결 안 하면 매번 "어디까지 하셨어요?"를 되묻게 됩니다.

Claude Code에서:

```
/mcp
```

목록에서 **`claude.ai Notion`** 을 고르고 인증(Authenticate)합니다. 브라우저가 열리면 회사 노션 계정으로 승인 → 터미널로 돌아오면 끝.

확인 — 다시 `/mcp`를 쳤을 때 이렇게 보이면 성공:

```
claude.ai Notion: https://mcp.notion.com/mcp - ✔ Connected
```

> 회사 노션 계정 초대를 아직 못 받았으면 슬랙에 요청. 노션 없이도 Step 9는 진행되지만, 진척 저장이 안 됩니다.

---

## Step 9: 시작 🎉

여기까지 왔으면 설치 끝. 이제 한 줄만 치면 됩니다.

```
/ai-onboarding
```

방금 친 세 개(`/zeude-setup`·`/company-setup`·`/mcp`)가 각각 뭐였는지, Claude Code가 ChatGPT 웹창과 뭐가 다른지부터 알려줍니다. **20~25분이면 끝나고, 거기까지 하면 회사 온보딩을 시작할 수 있습니다.**

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

## 캠프 자료 복습 (기존 팀원용)

AI Native Camp 4주 세션을 들었던 분이 부분 복습을 원하면:

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
        ┈┈ 여기까지 터미널. 아래는 Claude Code 안에서 ┈┈
Step 6: /zeude-setup           ← 회사 스킬 동기화 + 모니터링 (먼저 해야 나머지가 생김)
Step 7: /company-setup         ← 회사 폴더 + 레포
Step 8: /mcp → Notion 연결     ← 온보딩 트래커 저장소
Step 9: /ai-onboarding         ← ★ 종착지. Step 1만 하면 /onboarding 도 시작 가능

그다음: /onboarding            ← 회사 온보딩 (Day 1~9 · 하루 30분)
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
| `/mcp`에 Notion이 "Needs authentication" | 그 항목 선택 → Authenticate → 브라우저에서 **회사 노션 계정**으로 승인 (개인 계정 아님) |
| 노션 연결했는데 온보딩이 진척을 못 찾음 | Claude Code 새 창으로 다시 호출. 그래도면 노션에서 온보딩 페이지 접근 권한 요청 |
| `/ai-onboarding`·`/onboarding`이 없다고 나옴 | Step 6 `/zeude-setup`이 안 끝난 것 (스킬은 Zeude가 동기화). 새 창 후 재시도 |
| `/kb`가 회사 자료를 못 찾음 | Step 7 `/company-setup`이 안 끝난 것. 다시 실행 |
| 스킬은 뜨는데 "무슨 뜻인지 모르겠음" | 정상입니다. Step 9 `/ai-onboarding`이 하나씩 설명해줍니다 |

그래도 안 되면 **슬랙에 에러 스크린샷** 올려주세요. 도와드립니다!
