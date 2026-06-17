# 수원신화성 직영 대시보드 — 팀원용 디벨롭 가이드

이 대시보드를 **클로드(Claude Code)에서 직접 개선**하려는 팀원을 위한 안내입니다.
KB 참고 문서들을 같이 열어두고 리뷰하면서 디벨롭하세요.

---

## 1. 무엇이 있나 (소스 파일)

| 파일 | 무엇 |
|---|---|
| `ds-output/jikyoung-dashboard-prototype.html` | **예시(인터랙티브) 대시보드** — 실데이터가 HTML에 내장(self-contained). 자동 진단 헤더·일/주/월 토글·가로 퍼널(클릭 분해)·채널 기간연동·도착 온오프·광고 CAC. |
| `ds-output/jikyoung-dashboard-spec.html` | **개요·정의 설명서** — 데이터 소스맵·2층 퍼널 구조도·지표 의미정의·도착 온오프 도출·광고 CAC·한계. **지표 뜻이 헷갈리면 먼저 이걸 본다.** |

> KB 배포본(아래 링크)은 **staticrypt 암호화본 = 보기·댓글 전용**입니다. 편집·개선은 **이 레포의 소스 HTML**로 하세요.

---

## 2. 클로드에서 디벨롭하는 법

1. 이 레포(`driving-teacher-ai-native`)를 clone/pull → 해당 폴더에서 `claude` 실행.
2. 클로드에게 이렇게 요청:
   > "`ds-output/jikyoung-dashboard-prototype.html` 와 `jikyoung-dashboard-spec.html` 를 읽고, 아래 KB 참고 링크들도 함께 보면서 [원하는 개선]을 해줘."
3. 정의·맥락이 필요하면 spec HTML + 아래 KB 문서를 근거로 삼게 한다.

### ✅ 소스만으로 가능한 개선 (BQ 접근 불필요)
프로토타입은 데이터가 내장돼 있어 **레이아웃·차트·카피·진단 규칙·인터랙션**을 자유롭게 고칠 수 있습니다.

### ⚠️ 데이터 접근이 필요한 작업 (별도 권한)
**최신 숫자 갱신·새 지표·새 기간·실시간화**는 BigQuery·구글시트·GA4 접근(서비스계정 키)이 필요합니다 — 현재 데이터 담당 환경에만 있습니다. 구조·로직은 누구나 바꿀 수 있지만, 데이터 새로고침은 운영 빌드(Streamlit) 단계의 몫입니다.

---

## 3. 함께 볼 KB 참고 링크 (🔒 팀 공용 비번 — 슬랙 참고)

### 이 대시보드 자체
- 개요·정의 설명서 — https://dt-kb.vercel.app/2026-06-17-jikyoung-dashboard-spec.html
- 예시 대시보드 — https://dt-kb.vercel.app/2026-06-17-jikyoung-dashboard-prototype.html

### 개념·데이터를 뒷받침하는 문서
| 대시보드 개념 | KB 문서 |
|---|---|
| 직영 퍼널·예약 전환 | https://dt-kb.vercel.app/2026-06-10-suwon-funnel-live.html |
| 채널·CAC·광고 신호 | https://dt-kb.vercel.app/2026-06-16-newgangnam-shinhwaseong-ad-funnel.html |
| 상담/상담전 단계(채널톡) | https://dt-kb.vercel.app/2026-06-16-channeltalk-v2-bot-guide.html |
| 이탈 사유·비전환 페르소나 | https://dt-kb.vercel.app/2026-06-05-voc-journey-persona-map.html |
| 결제후 이탈·필기 트래픽 | https://dt-kb.vercel.app/2026-06-08-product-data-trilogy.html |
| 유저 세그먼트 정의 | https://dt-kb.vercel.app/2026-06-15-user-segment-design.html |
| 진입구별 흐름 | https://dt-kb.vercel.app/2026-06-08-user-journey-flow-map.html |
| 직영 광고 셋업 | https://dt-kb.vercel.app/2026-06-11-suwon-google-search-campaign.html |

---

## 4. 데이터 정의 요지 (자세한 건 spec HTML)

- **대상**: 수원신화성(뉴삼성) 직영 1곳. (academyid는 데이터 담당이 관리)
- **상담신청(리드)·예약(성공/이탈)·상담** = 직영 ERP(`homepage_inquiry_flat`).
- **도착(입학)·목표** = 대표 공유 **'[직영팀] 2026 입학생 목표 및 예측' 시트** — 월별 '실측'=실제 도착(입학), '예측 합계'=목표선. (BQ 입학생 테이블과 ±5% 정합)
- **방문/CTA/폼** = GA4 직영웹(28일).
- **온/오프 입학** = 입학생↔리드 전화매칭(하한 추정).
- **광고 CAC** = 광고비 ÷ 실제 도착(입학). 광고 플랫폼 전환수(허수)로 계산 금지.

### ⚠️ 해석 주의 (단정 금지)
- 진단은 **사실 비교만**(어느 지표가 기준 대비 저조한지). 원인·대응은 단정하지 않습니다.
- 예약 실패 사유는 **15%만 기록** → "콜커버리지가 원인" 식 단정은 데이터로 뒷받침되지 않음. 사유 수집 보강이 선행.
