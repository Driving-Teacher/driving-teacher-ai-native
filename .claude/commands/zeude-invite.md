---
name: zeude-invite
description: Zeude 팀원 초대 링크 생성 (Admin 전용). 인원 수를 지정하면 한번에 생성.
allowed-tools: Bash, Read
---

Zeude 초대 링크를 생성한다. 링크는 1시간 유효.

## 진행

1. 인원 수를 물어본다 (기본 7명).
2. 팀 이름을 물어본다 (기본 "driving-teacher").

3. admin 세션 쿠키를 얻는다:

```bash
AGENT_KEY=$(grep "^agent_key=" ~/.zeude/credentials | cut -d'=' -f2)
OTT=$(curl -s -X POST "https://zeude.vercel.app/api/auth/ott" \
  -H "Content-Type: application/json" \
  -d "{\"agentKey\": \"$AGENT_KEY\"}" | jq -r '.token')

SESSION=$(curl -s -D - -o /dev/null "https://zeude.vercel.app/api/auth/callback?ott=$OTT" \
  | grep -i 'set-cookie.*session=' | head -1 \
  | sed 's/.*session=\([^;]*\).*/\1/')
```

4. 지정된 인원 수만큼 초대 링크를 생성한다:

```bash
for i in $(seq 1 <인원수>); do
  RESULT=$(curl -s -X POST "https://zeude.vercel.app/api/admin/invites" \
    -H "Content-Type: application/json" \
    -H "Cookie: session=$SESSION" \
    -d '{"team": "<팀이름>", "role": "member"}')
  URL=$(echo "$RESULT" | jq -r '.url')
  echo "[$i] $URL"
done
```

5. 결과를 슬랙 공유용 형태로 정리:

```
Zeude 셋업 링크 (1시간 유효!)

1. 아래 본인 링크 클릭 → 이름/이메일 입력 → agent_key 복사
2. Claude Code에서 /zeude-setup 실행 → key 붙여넣기
3. 끝!

[1] https://zeude.vercel.app/invite/xxx
[2] https://zeude.vercel.app/invite/xxx
...
```

링크 옆에 팀원 이름은 붙이지 않는다 (먼저 클릭하는 사람이 쓰는 구조).
