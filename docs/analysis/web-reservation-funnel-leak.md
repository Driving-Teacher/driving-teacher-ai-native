---
name: dt-web-reservation-funnel-leak
description: "직영 웹 예약 퍼널 누수·갭 진단 결과 — 광고전환 채용/수강 혼입, academyAbrId 사각지대, 본서비스 퍼널 이탈, 직영 실결제·예약실패"
metadata: 
  node_type: memory
  type: project
  originSessionId: 31286cf7-c7ab-4aa6-ac58-991743e33a95
---

직영학원 웹 예약 퍼널 이탈 분석 (2026-03~05 실측, 소스 5종 교차). 산출물 `ds-output/web-reservation-funnel-leak.html`. 입력=직영홈피 이벤트 택소노미 시트(100+이벤트, gid 434009402)+`tracking-report-deck.html`(직영 마케팅랜딩 추적: 결제·가입 없음, "온라인예약"클릭=driving_teacher_click=당근Purchase, 상담폼=inquiry_leave=Lead, Hackle/PostHog는 설정만·미전송).

**구조: 퍼널은 2도메인에 걸침.** (A)직영홈피(예 뉴삼성 web kbdrive류) GA4 477+픽셀5종+google_ads → (B)본서비스 drivingteacher.co.kr GA4 335+airbridge+Hackle. 연결키=`academyAbrId`(랜딩클릭시 URL부착, utm_source=direct_academy_homepage). **academyAbrId 전용컬럼이 어느소스에도 없어 직영광고→본서비스 1:1귀속 측정불가 = 최대 사각지대.**

**핵심 갭 3종:**
1. **광고 전환 라벨 혼입·정체(뉴삼성, 계정 5819228711)**: ⚠️구글애즈 직영 전환 1·2위 `instructor_apply_online_click` 978.6·`_phone_click` 814.6은 **강사 채용 지원**(랜딩 final_url=suwonnewsamsung.co.kr/company/instructor, `recruit` 캠페인, 카테고리 SIGNUP) — **수강 예약 아님, 수강 퍼널에서 제외 필수**. (초안이 이걸 수강예약으로 오인해 979↔실결제154 비교한 건 무효). **수강생 모집**(always-on pmax) 광고비 **34,717,289원**(전체 36.3M 중 채용 158만 제외) → 전환=`inquiry_leave` 182.5(폼 실리드)·`phone_call` 165.2·`kakao_inquiry_click` 868(채팅 진입 클릭=부풀림). 수강모집 CAC=34,717,289÷실결제154=**225,437원**(⚠️154는 전채널 실결제라 광고전용 CAC는 더 높을 수 있음). ⚠️비용은 ads_AccountBasicStats/CampaignBasicStats 직접SUM, ads_Campaign(일자스냅샷) JOIN시 fan-out 3배. 캠페인 분해는 ads_CampaignConversionStats×campaign_id→name. **교훈: 구글애즈 전환은 캠페인 목적(recruit채용 vs always-on수강)으로 갈라야 하고, 클릭형(kakao)과 폼리드(inquiry_leave) 구분 필요.**
2. **직영 예약 실패가 성공만큼**(내부DB homepage_inquiry_flat 6곳): status 예약성공 1098 ≈ **예약실패 1036**, 상담전 523, 취소 181. 광고·웹퍼널 어디에도 안 잡히는 클로징 단계 최대 실누수.
3. **본서비스 상세→장바구니 76.6% 이탈**(GA4 335, 3개월): view_item 40,566→add_to_cart 9,487(23.4%)→purchase 1,721(상세대비 4.24%). 단 결제시작→완료는 84%(끝까지 가면 닫힘).

**직영6곳 상담→결제완료(내부DB homepage_inquiry_flat, 20.6%)**: 뉴강남 998→225(22.5%)·뉴삼성 925→153(16.5%)·신일 638→131(20.5%)·한백 139→64(46%)·동송 133→9(6.8%)·왜관 23→5. 합 2856→587. ⚠️상담=레코드1건(예약문의 접수, 홈피/전화/네이버 유입), 결제완료=`paymentcompleted=TRUE`(BOOLEAN, IS NOT NULL로 세면 FALSE 섞임 주의). ⚠️status'예약성공'1098 ≠ 결제완료587 — 별개필드(예약성공처리돼도 실결제 절반이하). **상담 source 본류=아웃바운드콜 1343(47%)>웹예약 750(26%)>네이버부킹 243 → 웹예약 클로징은 영업전화가 함**(순수 웹셀프 아님).

다음 1순위 조치 = academyAbrId를 GA4 335/Airbridge에 적재(크로스도메인 닫기) + 픽셀 클릭이벤트를 '의향'으로 재정의·실결제는 내부DB 기준 분리보고. 데이터지형·우회법 [[bq-data-landscape]], 내부DB [[dt-internal-db-orders-inquiry]], 광고기준선 [[dt-paid-cac-baselines]], 에어브릿지 [[ad-tracking-airbridge-vs-hackle]].
