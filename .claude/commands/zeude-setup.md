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
ZEUDE_AGENT_KEY="<입력받은키>" bash <(curl -fsS https://ulkqtmqspquxppywajsu.supabase.co/storage/v1/object/public/releases/install.sh)
```

> `-f -S` 를 반드시 붙인다. `-s` 만 쓰면 서버가 죽었거나 404일 때 **빈 내용이 bash로 넘어가서 아무것도 안 하고 종료 0** 이 된다 — 설치가 실패했는데 성공한 것처럼 보인다.
>
> **주소를 임의로 바꾸지 말 것.** 예전에는 `http://34.64.239.89:8080` 이었는데, 평문 HTTP + 날 IP + 무결성 검증이 없어서 같은 네트워크에 있는 사람이 실행파일을 바꿔치기할 수 있었다. 그 파일은 PATH 맨 앞에서 `claude` 를 감싸므로 영향 범위가 전 직원이다. (2026-07-31 에 HTTPS + SHA256 검증으로 옮김)
>
> 설치 중 `체크섬 불일치` 가 뜨면 **설치가 중단되는 게 정상이다.** 받은 파일이 예상과 다르다는 뜻이니 사용자에게 슬랙 `#ai-native` 안내만 하고 우회하지 않는다.

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
OTT=$(curl -fsS -X POST "https://zeude.vercel.app/api/auth/ott" \
  -H "Content-Type: application/json" \
  -d "{\"agentKey\": \"$AGENT_KEY\"}" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["token"])')
URL="https://zeude.vercel.app/auth?ott=$OTT"

# 브라우저 열기 — OS마다 명령이 다르다
if command -v open >/dev/null 2>&1; then        # macOS
    open "$URL"
elif command -v wslview >/dev/null 2>&1; then   # WSL (wslu 설치된 경우)
    wslview "$URL"
elif command -v xdg-open >/dev/null 2>&1; then  # Linux
    xdg-open "$URL"
else
    echo "아래 주소를 브라우저에 직접 붙여넣어주세요:"
    echo "$URL"
fi
```

> ⚠️ **`jq`·`open` 을 쓰지 않는다.** 둘 다 WSL Ubuntu 기본 설치에 **없다.** `jq -r`은 없으면 빈 문자열을 만들어서 `ott=` 인 깨진 링크가 나오고, `open`은 `command not found` 로 끝난다. `python3` 는 셋업 스크립트가 깔아주므로 항상 있다.
>
> 어느 방법으로도 브라우저가 안 열리면 **주소를 출력해서 사람이 직접 열게** 한다. 여기서 막혀서 셋업 전체를 실패로 만들지 않는다.

5. 완료 메시지:
```
셋업 완료!
- 새 터미널 열거나: source ~/.zshrc
- /zeude : 대시보드 열기
- zeude doctor : 설치 상태 확인
```
