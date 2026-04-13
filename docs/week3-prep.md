# Week 3 사전 준비 — OpenClaw 셋업

Week 3 수업에서 "터미널 없이 Slack으로 AI에게 일 시키기"를 실습합니다.
당일 막힘 없이 진행하려면 아래 준비물을 **수업 3일 전까지** 완료해주세요.

총 소요 시간: **20~30분** (짬날 때 쪼개서 OK)

---

## 각자 해야 할 것

### ✅ 1. Claude Teams 라이선스 확인 (2분)
- [ ] `claude` CLI에서 로그인되어 있는지 확인
- [ ] 로그인 안 되어 있으면: 터미널에서 `claude login` 실행
- [ ] Teams 구독에 자기 계정이 배정됐는지 Slack에서 승아에게 확인

### ✅ 2. Fly.io 계정 가입 (10분)
개인 VM 한 대 무료로 돌릴 인프라.

- [ ] https://fly.io/app/sign-up 접속
- [ ] "Sign up with GitHub" 클릭 (GitHub 계정으로 로그인)
- [ ] 카드 등록 (무료 티어만 쓸 거지만 검증용)
- [ ] `flyctl` CLI 설치 — OS별:
  - **Mac**: `brew install flyctl`
  - **Windows**: PowerShell에서 `iwr https://fly.io/install.ps1 -useb | iex`
- [ ] `flyctl auth login` 으로 로그인

### ✅ 3. Slack 모바일 앱 로그인 확인 (2분)
- [ ] 폰에 Slack 앱 설치되어 있는지
- [ ] 회사 워크스페이스에 로그인되어 있는지
- [ ] 알림 허용 (봇 응답을 바로 보려면)

### ✅ 4. git / gh CLI 확인 (3분)
Week 2에서 했던 것 재확인.

- [ ] 터미널에서 `git --version` → 버전 나오면 OK
- [ ] `gh --version` → 버전 나오면 OK
- [ ] 안 되면 Slack #ai-native-camp 에 질문

### ✅ 5. 자동화 아이디어 3개 준비 (5분)
수업 당일 실습에 쓸 내 유스케이스.

- [ ] 매일/매주 반복하는 일 중 "Slack으로 시키고 싶은 것" 3개 메모
- [ ] 예: "매일 아침 9시 할 일 정리", "채널톡 문의 답변 초안", "주간 보고서 초안"
- [ ] 구체적일수록 수업에서 바로 써볼 수 있음

---

## 승아가 준비하는 것 (학생은 신경 X)

- Fly.io에 배포할 OpenClaw Docker 이미지 + `fly.toml` 템플릿
- Slack 앱 생성 + Bot Token + 팀원 DM 분기 설정
- 수업 당일 `fly launch` 1줄로 세팅 끝내는 셋업 스크립트
- OAuth 흐름(`claude login` URL 클릭) 안내

---

## 막히면

- Slack `#ai-native-camp` 채널에 질문
- 혹은 Claude한테 물어보세요. 설치 에러는 Claude가 다 압니다.

---

## 체크리스트 요약 (Slack 공지용)

```
📋 Week 3 사전 준비 (수업 3일 전까지)

[ ] 1. Claude CLI 로그인 확인
[ ] 2. Fly.io 가입 + flyctl 설치
[ ] 3. Slack 모바일 앱 로그인
[ ] 4. git/gh CLI 확인
[ ] 5. 자동화 아이디어 3개 메모

총 20~30분. 막히면 Slack에 질문.
```
