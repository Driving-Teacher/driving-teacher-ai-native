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
Step 1: Claude Teams 초대 수락 (메일)
Step 2: git 설치
Step 3: bash scripts/setup-mac.sh (또는 setup-windows.ps1)
Step 4: claude 로그인
Step 5: 버전 확인 4개
Step 6: /zeude-setup           ← 모니터링 + 스킬 자동 동기화
Step 7: /company-setup         ← 회사 폴더 + 레포
Step 8: /camp-onboarding       ← 4주 통수강 시작
```

총 30~40분. 막히면 #ai-native-camp.

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
| `/zeude-setup` 후에도 스킬이 안 보임 | Claude Code 새 창. 또는 `claude --version` 한번 호출해서 sync trigger |
| `/company-setup` clone 403 | driving-teacher-bot org 멤버 아님 → 슬랙에 GitHub username 보고 |
| zeude credentials 잃어버림 | 슬랙에서 새 초대 링크 요청 (호스트가 `/zeude-invite 1`로 발급) |

그래도 안 되면 **슬랙에 에러 스크린샷** 올려주세요. 도와드립니다!
