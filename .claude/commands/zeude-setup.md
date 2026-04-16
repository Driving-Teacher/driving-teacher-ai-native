---
name: zeude-setup
description: Zeude 모니터링 셋업. shim 설치 + 텔레메트리 + /zeude 대시보드 접속까지 한번에.
allowed-tools: Bash, Read
---

Zeude 모니터링 시스템을 셋업한다. shim 바이너리 설치 + OTel 텔레메트리 + /zeude 대시보드 스킬까지 전부 포함.

## 진행

1. 사용자에게 agent_key를 물어본다:
   - "초대 링크에서 받은 agent_key를 붙여넣어주세요 (zd_로 시작하는 키)"
   - 입력값이 `zd_`로 시작하고 67자(zd_ + 64 hex)인지 검증

2. install.sh 실행 (agent_key를 환경변수로 전달):

```bash
ZEUDE_AGENT_KEY="<입력받은키>" bash <(curl -s http://34.22.107.196:8080/releases/install.sh)
```

이 스크립트가 자동으로 하는 것:
- 플랫폼 감지 (darwin/linux, amd64/arm64)
- 실제 claude 바이너리 경로 탐지
- shim 바이너리 다운로드 (~/.zeude/bin/claude)
- zeude CLI 다운로드 (~/.zeude/bin/zeude)
- OTel 텔레메트리 설정
- PATH 설정 (~/.zshrc 또는 ~/.bashrc)
- /zeude 스킬 설치
- agent_key 저장

3. 설치 확인:

```bash
~/.zeude/bin/zeude doctor
```

4. 성공하면 대시보드 열기:

```bash
AGENT_KEY=$(grep "^agent_key=" ~/.zeude/credentials | cut -d'=' -f2)
OTT=$(curl -s -X POST "https://zeude.vercel.app/api/auth/ott" \
  -H "Content-Type: application/json" \
  -d "{\"agentKey\": \"$AGENT_KEY\"}" | jq -r '.token')
open "https://zeude.vercel.app/auth?ott=$OTT"
```

5. 완료 메시지:
```
셋업 완료!
- 새 터미널 열거나: source ~/.zshrc
- /zeude : 대시보드 열기
- zeude doctor : 설치 상태 확인
```
