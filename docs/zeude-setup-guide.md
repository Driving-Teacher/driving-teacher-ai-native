# Zeude 서버 셋업 가이드

> Zeude는 Claude Code (및 Codex) 팀 모니터링/관리 플랫폼이다.
> GitHub: https://github.com/zep-us/zeude

---

## 전체 아키텍처

```
개발자 머신                              서버 인프라
┌──────────────────────┐                 ┌─────────────────────────────┐
│                      │                 │                             │
│  claude (shim)       │── startup ────> │  Zeude Dashboard (Next.js)  │
│  ~/.zeude/bin/       │  config sync    │  ├─ Supabase (유저, 설정)    │
│         │            │                 │  └─ ClickHouse (텔레메트리)  │
│         v            │                 │                             │
│  real claude         │── telemetry ──> │  OTel Collector             │
│  (원본 바이너리)      │                 │  (OTLP → ClickHouse)       │
│                      │                 │                             │
└──────────────────────┘                 └─────────────────────────────┘
```

**3계층 구조:**
1. **Sensing** — OpenTelemetry로 사용량 측정 → ClickHouse 저장 → 대시보드 시각화
2. **Delivery** — 대시보드에서 Skill/Hook/MCP 설정 → Shim이 자동 동기화
3. **Guidance** — 프롬프트 키워드 기반 스킬 추천 (UserPromptSubmit Hook)

---

## 필요한 서비스 목록

| 서비스 | 용도 | 무료 여부 |
|--------|------|-----------|
| **Supabase** | 유저/팀/설정 데이터 (PostgreSQL) | Free tier 있음 (500MB, 2개 프로젝트) |
| **ClickHouse** | 텔레메트리/분석 데이터 | ClickHouse Cloud Free tier (10GB) 또는 Docker로 자체 호스팅 |
| **서버/VM** | Dashboard + OTel Collector 호스팅 | Vercel(대시보드) + 별도 VM(OTel) 조합 가능 |
| **Docker** | 로컬 개발/ClickHouse/OTel Collector | 무료 |

---

## Step 1: Supabase 프로젝트 생성

### 1.1 프로젝트 만들기

1. https://supabase.com 접속 → 계정 생성
2. "New Project" 클릭
3. 프로젝트 이름: `zeude` (또는 원하는 이름)
4. Database Password 설정 (기억해둘 것)
5. Region: Northeast Asia (ap-northeast-1) 추천

### 1.2 API 키 확보

프로젝트 생성 후 **Settings → API** 에서 3개 값을 복사:

- `Project URL` → `.env`의 `SUPABASE_URL`
- `anon/public` key → `.env`의 `SUPABASE_ANON_KEY`
- `service_role` key → `.env`의 `SUPABASE_SERVICE_ROLE_KEY` (절대 클라이언트에 노출 금지)

### 1.3 마이그레이션 실행

Supabase 대시보드의 **SQL Editor**에서 마이그레이션 파일을 순서대로 실행한다.
마이그레이션 파일 위치: `zeude/dashboard/supabase/migrations/`

실행 순서 (파일명의 타임스탬프 순):
```
20251219000001_initial_schema.sql          -- 유저, 세션, OTT 테이블
20251222000001_phase2_team_mcp.sql         -- 팀, MCP 서버 테이블
20251222000002_skills.sql                  -- 스킬 테이블
20251222000003_mcp_install_status.sql      -- MCP 설치 상태
20251225000001_hooks.sql                   -- 훅 테이블
20251225000002_hook_install_status.sql     -- 훅 설치 상태
20251225000003_seed_prompt_logger_hook.sql -- 프롬프트 로거 시드
20251226000001_seed_update_checker_hook.sql -- 업데이트 체커 시드
20250106000001_fix_update_checker_hook.sql
20250114000001_update_prompt_logger_with_uuid.sql
20250120000001_skill_rules.sql
20250120000002_skill_hint_hook.sql
20250121000001_skill_keywords_tier.sql
20250121000002_skill_hint_2tier.sql
20260304000001_cohort_members.sql
20260304000002_skill_hint_v4_softmatch.sql
20260305000001_skills_files_column.sql
20260305000001b_skills_files_constraints.sql
20260305000002_agents_table.sql
20260313000001_user_disabled_skills.sql
```

> 팁: SQL Editor에 각 파일 내용을 붙여넣고 "Run" 클릭. 순서를 지켜야 외래키 참조 오류가 안 난다.

---

## Step 2: ClickHouse 셋업

### 옵션 A: ClickHouse Cloud (추천 — 운영 편함)

1. https://clickhouse.cloud 접속 → 계정 생성
2. "Create Service" → Region 선택
3. Free tier: 10GB 스토리지, 충분히 시작 가능
4. 접속 정보 확보:
   - `CLICKHOUSE_URL` (예: `https://xxx.clickhouse.cloud:8443`)
   - `CLICKHOUSE_USER` (기본: `default`)
   - `CLICKHOUSE_PASSWORD`
   - `CLICKHOUSE_DATABASE`: `zeude` (직접 생성 필요)

### 옵션 B: Docker로 자체 호스팅 (로컬 개발용)

```bash
cd zeude/dashboard
docker compose -f docker-compose.dev.yaml up -d
```

이 명령으로 다음이 실행된다:
- **ClickHouse** (포트 8123/HTTP, 9000/Native)
- **OTel Collector** (포트 4317/gRPC, 4318/HTTP)

초기 스키마는 `init-clickhouse.sql`이 자동 적용된다.

### 2.1 ClickHouse 스키마 적용

ClickHouse Cloud를 사용하는 경우, 수동으로 스키마를 적용해야 한다:

1. **기본 스키마 적용**: `zeude/dashboard/clickhouse/init.sql` 전체 실행
2. **마이그레이션 적용**: `zeude/dashboard/clickhouse/migrations/` 폴더의 파일을 순서대로 실행

```
001_token_usage_hourly.sql
002_efficiency_metrics.sql
003_retry_density.sql
004_context_growth.sql
005_ai_prompts_user_id.sql
006_fix_token_usage_hourly_email.sql
007_prompt_type_tracking.sql
008_fix_analysis_views.sql
009_frustration_analysis.sql
010_openai_pricing_models.sql
011_add_source_column.sql
012_frustration_codex_support.sql
013_retry_context_source_column.sql
014_codex_skill_detection.sql
015_fix_retry_context_user_id.sql
```

> ClickHouse Cloud의 SQL Console이나 `clickhouse-client` CLI로 실행 가능.

---

## Step 3: Dashboard (Next.js) 배포

### 3.1 환경변수 설정

```bash
cd zeude/dashboard
cp ../../.env.example .env.local
```

`.env.local` 내용:

```env
# Supabase (Step 1에서 확보)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

# ClickHouse (Step 2에서 확보)
CLICKHOUSE_URL=http://localhost:8123          # 또는 ClickHouse Cloud URL
CLICKHOUSE_USER=default
CLICKHOUSE_PASSWORD=your-password
CLICKHOUSE_DATABASE=zeude

# 앱 URL
NEXT_PUBLIC_APP_URL=http://localhost:3000      # 배포 시 실제 URL로 변경

# OpenRouter (선택사항 — AI 기능용)
OPENROUTER_API_KEY=
OPENROUTER_MODEL=anthropic/claude-sonnet-4
```

### 3.2 로컬 실행

```bash
cd zeude/dashboard
pnpm install      # 또는 npm install
pnpm dev           # http://localhost:3000
```

개발 모드 (DB 없이 테스트):
```bash
SKIP_AUTH=true MOCK_API=true pnpm dev
```

### 3.3 프로덕션 배포 옵션

#### 옵션 A: Vercel에 배포 (추천)

1. Zeude 레포를 GitHub에 fork
2. Vercel에서 Import → Root Directory를 `zeude/dashboard`로 설정
3. Environment Variables에 위 환경변수 모두 입력
4. Deploy

> `next.config.ts`에 `output: 'standalone'`가 설정되어 있어 Docker 배포도 가능.

#### 옵션 B: Docker로 배포

```bash
cd zeude/dashboard
docker compose up -d
```

`docker-compose.yaml`이 대시보드를 포트 3000에 띄운다.

#### 옵션 C: Docker 풀빌드 (Go shim 바이너리 포함)

```bash
cd zeude
docker build -t zeude-server .
```

이 Dockerfile은:
1. Go로 모든 플랫폼의 shim 바이너리를 빌드 (darwin/linux, amd64/arm64)
2. Next.js 대시보드를 빌드
3. 바이너리를 `/public/releases/`에 포함 → 클라이언트가 다운로드 가능

---

## Step 4: OTel Collector 배포

OTel Collector는 개발자 머신의 Claude Code에서 보내는 텔레메트리를 받아 ClickHouse에 저장한다.

### 4.1 프로덕션 배포

```bash
cd zeude/deployments
docker compose -f docker-compose.collector.yaml up -d
```

설정 파일: `zeude/deployments/otel-collector-config.yaml`

환경변수 필요:
```env
CLICKHOUSE_ENDPOINT=https://your-clickhouse-host:8443
CLICKHOUSE_PASSWORD=your-password
```

### 4.2 설정 파일 수정

`otel-collector-config.yaml`에서 ClickHouse 연결 정보를 확인/수정:

```yaml
exporters:
  clickhouse:
    endpoint: ${CLICKHOUSE_ENDPOINT:-https://localhost:8443}
    database: zeude
    username: zep           # 본인의 ClickHouse 유저로 변경
    password: ${CLICKHOUSE_PASSWORD}
    logs_table_name: claude_code_logs
```

### 4.3 포트

| 포트 | 프로토콜 | 용도 |
|------|----------|------|
| 4317 | gRPC | OTLP (Claude Code 기본) |
| 4318 | HTTP | OTLP (대안) |

> 방화벽에서 4317/4318을 열어야 개발자 머신에서 텔레메트리를 보낼 수 있다.

---

## Step 5: 개발자 머신에 CLI Shim 설치

대시보드가 떠 있으면, 각 개발자 머신에 Zeude shim을 설치한다.

### 5.1 설치 스크립트

```bash
curl -fsSL https://YOUR_DASHBOARD_URL/releases/install.sh | \
  ZEUDE_AGENT_KEY=zd_xxx \
  ZEUDE_DOWNLOAD_BASE=https://YOUR_DASHBOARD_URL \
  ZEUDE_ENDPOINT=https://YOUR_OTEL_COLLECTOR_URL/ \
  ZEUDE_DASHBOARD_URL=https://YOUR_DASHBOARD_URL \
  bash
```

### 5.2 설치 과정 (자동)

설치 스크립트가 하는 일:
1. `jq` 설치 여부 확인
2. 플랫폼 감지 (darwin/linux, amd64/arm64)
3. 원본 `claude` 바이너리 위치 찾기
4. `~/.zeude/bin/claude` (shim) 다운로드
5. `~/.zeude/config`에 endpoint/dashboard URL 저장
6. `~/.zeude/credentials`에 agent key 저장 (0600 퍼미션)
7. `PATH`에 `~/.zeude/bin` 추가 (zshrc/bashrc)
8. `/zeude` 스킬 설치 (`~/.claude/commands/zeude.md`)

### 5.3 설치 확인

```bash
source ~/.zshrc        # 셸 재시작 대신
zeude doctor           # 설치 상태 진단
claude                 # shim을 통해 실행되는지 확인
```

### 5.4 Shim 동작 원리

`claude` 명령 실행 시 shim이:
1. 대시보드 API에서 팀 설정을 fetch
2. MCP 서버 설정 → `~/.claude.json`에 동기화
3. Hook 스크립트 → `~/.claude/hooks/`에 설치
4. Skill 파일 → `~/.claude/skills/`에 동기화
5. Agent 프로필 → `~/.claude/agents/`에 설치
6. OTel 환경변수 주입
7. 원본 `claude` 바이너리를 `exec` (shim 프로세스 교체)

---

## Step 6: 제거 (필요 시)

```bash
curl -fsSL https://YOUR_DASHBOARD_URL/releases/uninstall.sh | bash
```

제거 대상:
- `~/.zeude/` 디렉토리
- Zeude가 설치한 Hook들
- `~/.claude.json`에서 Zeude 관리 MCP 서버
- `/zeude` 스킬
- PATH 설정

---

## 환경변수 전체 요약

### 서버 (.env.local)

| 변수 | 설명 | 예시 |
|------|------|------|
| `SUPABASE_URL` | Supabase 프로젝트 URL | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Supabase public key | `eyJ...` |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase service role key | `eyJ...` |
| `CLICKHOUSE_URL` | ClickHouse HTTP URL | `http://localhost:8123` |
| `CLICKHOUSE_USER` | ClickHouse 유저명 | `default` |
| `CLICKHOUSE_PASSWORD` | ClickHouse 비밀번호 | - |
| `CLICKHOUSE_DATABASE` | ClickHouse DB 이름 | `zeude` |
| `NEXT_PUBLIC_APP_URL` | 대시보드 공개 URL | `https://zeude.example.com` |
| `OPENROUTER_API_KEY` | (선택) AI 기능용 | - |

### 클라이언트 (~/.zeude/)

| 파일 | 내용 |
|------|------|
| `~/.zeude/credentials` | `agent_key=zd_xxx` (0600 퍼미션) |
| `~/.zeude/config` | `endpoint=https://otel-url/` + `dashboard_url=https://dashboard-url` |
| `~/.zeude/real_binary_path` | 원본 claude 바이너리 경로 |

---

## 트러블슈팅

### "claude not found" 에러
- 원본 Claude Code가 먼저 설치되어 있어야 한다: `npm install -g @anthropic-ai/claude-code`

### 텔레메트리가 안 들어올 때
1. `zeude doctor` 실행하여 진단
2. OTel Collector가 실행 중인지 확인 (`docker ps`)
3. 방화벽에서 4317/4318 포트가 열려있는지 확인
4. `ZEUDE_DEBUG=1 claude` 로 디버그 로그 확인

### Supabase 마이그레이션 오류
- 순서대로 실행했는지 확인 (타임스탬프 기준 정렬)
- RLS(Row Level Security) 정책 충돌 시 기존 정책 먼저 삭제

### 로컬 개발 (DB 없이)
```bash
SKIP_AUTH=true MOCK_API=true pnpm dev
```

---

## 비용 예상 (최소 구성)

| 서비스 | 플랜 | 월 비용 |
|--------|------|---------|
| Supabase | Free | $0 |
| ClickHouse Cloud | Free (10GB) | $0 |
| Vercel | Hobby | $0 |
| OTel Collector VM | 별도 필요 | ~$5/월 (작은 VM) |
| **합계** | | **$0 ~ $5/월** |

> 팀 규모가 커지면 Supabase Pro ($25/월), ClickHouse 유료 플랜으로 업그레이드 필요.

---

## 다음 단계

1. 대시보드에서 첫 유저 생성 및 Agent Key 발급
2. 팀원들에게 설치 스크립트 배포
3. Skill/Hook/MCP 서버 설정을 대시보드에서 관리
4. 대시보드에서 사용량 데이터 모니터링 시작
