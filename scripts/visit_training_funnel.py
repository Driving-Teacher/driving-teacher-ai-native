#!/usr/bin/env python3
"""visit_training_funnel.py

visit-training 퍼널로 유입된 유저를 전수조사하여 유입 attribution을 정리하는 스크립트.
정리 항목: 유입 페이지(도메인)·소스/매체/캠페인·광고/비광고·신규/기존·웹/앱·검색(유입) 키워드.

원천 2채널
----------
1) Firestore ``Order``  ── 퍼널 멤버십의 정본.
     기본 태그 ``arrivalMethod == 'visit-training'`` (필드/값은 CLI로 변경 가능).
     추출: 주문ID·userId·userType(member/non-member)·academyId·상품·결제금액·요청시각.
2) GA4 BigQuery export  ── 유입 attribution 원천.
     - ``purchase`` 이벤트: ``transaction_id`` == 주문ID (Firestore와 조인 키)
     - ``traffic_source``           : 유저 최초 유입(소스·매체·캠페인)
     - ``collected_traffic_source`` : 이벤트 시점 유입(소스·매체·캠페인·term·gclid)
     - ``device`` / ``platform`` / ``page_location`` : 웹·앱·도메인
     - ``click_academyAd_*`` : 앱 내부 광고영역 클릭. 외부 유료광고와 **분리해서** 집계.

분류 규칙 (조정은 상단 상수 참고)
---------------------------------
- paid_ad : gclid/fbclid 존재 or 매체 ∈ PAID_MEDIUMS or 소스 ∈ PAID_SOURCE_HINTS
- organic : 매체 == 'organic'
- owned   : 소스 ∈ OWNED_SOURCES (kakaotalk 등 owned/custom 채널)
- direct  : 소스/매체가 direct/none
- unknown : 위 어디에도 안 걸림
  (내부 academyAd 클릭 여부는 acquisition_type와 별개 컬럼으로 표기)

산출물 (--out-dir)
------------------
- visit_training_funnel_raw.csv / .json : 유저(주문)별 로데이터
- visit_training_funnel_summary.json    : 집계(유입유형·플랫폼·신규/기존·상위소스·키워드)

인증/설정 (환경변수 또는 CLI)
-----------------------------
- GOOGLE_APPLICATION_CREDENTIALS : 서비스계정 키 경로 (Firestore/BQ 공통)
- --bq-project    / GA4_BQ_PROJECT
- --ga4-dataset   / GA4_BQ_DATASET   (예: analytics_123456789)
- --firestore-db  / FIRESTORE_DB     (기본 '(default)')

BQ project/dataset·Firestore DB id는 환경별 값이라 하드코딩하지 않는다.
실행 전 ``--print-sql`` 로 쿼리만 먼저 검토할 수 있다(클라우드 라이브러리/인증 불필요).

의존성
------
    pip install google-cloud-bigquery google-cloud-firestore

사용 예
-------
    python visit_training_funnel.py --print-sql
    python visit_training_funnel.py --start 2026-07-01 --end 2026-07-29 \
        --bq-project my-proj --ga4-dataset analytics_123456789 --out-dir ./out
"""

from __future__ import annotations

import argparse
import csv
import json
import os
import sys
from collections import Counter
from datetime import datetime, timedelta, timezone
from typing import Any, Optional
from urllib.parse import parse_qs, urlsplit

# ── 도메인 상수 (레포에서 확인한 값) ─────────────────────────────────────────
FUNNEL_FIELD_DEFAULT = "arrivalMethod"          # Order 문서의 퍼널 태그 필드
FUNNEL_VALUE_DEFAULT = "visit-training"         # 결제알림의 "퍼널 정보: visit-training"
PURCHASE_EVENT = "purchase"                     # GA4 구매 이벤트 (transaction_id=주문ID)
FUNNEL_GA4_EVENT = "visit_training_funnel"      # GA4 방문교육 퍼널 진입 이벤트
ACADEMY_AD_CLICK_EVENTS = ("click_academyAd_home", "click_academyAd_listView")

KST = timezone(timedelta(hours=9))

# 광고/비광고 판별 (소문자 비교). 필요 시 팀 기준에 맞게 조정.
PAID_MEDIUMS = {
    "cpc", "ppc", "paid", "paidsearch", "paid_search", "paid-search",
    "display", "cpm", "banner", "retargeting", "paid_social", "paid-social",
}
PAID_SOURCE_HINTS = {
    "google_ads", "googleads", "adwords", "facebook", "meta", "instagram",
    "naver_ad", "naver_gfa", "kakao_moment", "kakaomoment", "criteo", "moloco",
    "tiktok", "carrot", "danggeun",
}
OWNED_SOURCES = {
    "kakaotalk", "kakao", "kakao_channel", "sms", "email", "push",
    "owned", "crm", "bizmessage",
}
DIRECT_TOKENS = {"", "(direct)", "direct", "(none)", "none", "(not set)"}


# ── 유틸 ─────────────────────────────────────────────────────────────────────
def parse_date(s: str) -> datetime:
    return datetime.strptime(s, "%Y-%m-%d")


def kst_bounds(start: str, end: str) -> tuple[datetime, datetime]:
    """--start/--end(YYYY-MM-DD) → KST [00:00:00, 23:59:59.999999] 경계."""
    s = parse_date(start).replace(tzinfo=KST)
    e = parse_date(end).replace(hour=23, minute=59, second=59, microsecond=999999, tzinfo=KST)
    return s, e


def suffix(date_str: str) -> str:
    return date_str.replace("-", "")


def mask_phone(phone: Optional[str]) -> str:
    if not phone:
        return ""
    digits = "".join(ch for ch in phone if ch.isdigit())
    if len(digits) < 7:
        return "***"
    return f"{digits[:3]}****{digits[-4:]}"


def norm(v: Any) -> str:
    return (str(v).strip().lower()) if v is not None else ""


def extract_fbclid(page_location: Optional[str]) -> str:
    """page_location 쿼리스트링에서 fbclid 추출. (fbc/fbp 쿠키는 GA4 스코프 밖)"""
    if not page_location:
        return ""
    try:
        qs = parse_qs(urlsplit(page_location).query)
    except ValueError:
        return ""
    return (qs.get("fbclid", [""])[0]) or ""


def extract_domain(page_location: Optional[str]) -> str:
    if not page_location:
        return ""
    try:
        return urlsplit(page_location).netloc
    except ValueError:
        return ""


# ── 분류 로직 ────────────────────────────────────────────────────────────────
def classify_acquisition(source: str, medium: str, gclid: str, fbclid: str) -> str:
    s, m = norm(source), norm(medium)
    if gclid or fbclid or m in PAID_MEDIUMS or s in PAID_SOURCE_HINTS:
        return "paid_ad"
    if m == "organic":
        return "organic"
    if s in OWNED_SOURCES:
        return "owned"
    if s in DIRECT_TOKENS and m in DIRECT_TOKENS:
        return "direct"
    return "unknown"


def platform_of(ga4_platform: str, device_os: str) -> str:
    p = norm(ga4_platform) or norm(device_os)
    return "app" if p in {"android", "ios"} else ("web" if p else "unknown")


# ── BigQuery SQL 빌더 ────────────────────────────────────────────────────────
def build_purchase_sql(project: str, dataset: str, start: str, end: str) -> str:
    """purchase 이벤트 attribution. @order_ids(ARRAY<STRING>) 파라미터로 필터."""
    tid = (
        "(SELECT ep.value.string_value FROM UNNEST(event_params) ep "
        "WHERE ep.key = 'transaction_id')"
    )
    return f"""
SELECT
  {tid} AS transaction_id,
  ANY_VALUE(user_id)            AS user_id,
  ANY_VALUE(user_pseudo_id)     AS user_pseudo_id,
  ANY_VALUE(platform)           AS platform,
  ANY_VALUE(device.category)    AS device_category,
  ANY_VALUE(device.operating_system) AS device_os,
  ANY_VALUE(device.web_info.hostname) AS hostname,
  ANY_VALUE(traffic_source.source) AS first_source,
  ANY_VALUE(traffic_source.medium) AS first_medium,
  ANY_VALUE(traffic_source.name)   AS first_campaign,
  ANY_VALUE(collected_traffic_source.manual_source) AS event_source,
  ANY_VALUE(collected_traffic_source.manual_medium) AS event_medium,
  ANY_VALUE(collected_traffic_source.manual_campaign_name) AS event_campaign,
  ANY_VALUE(collected_traffic_source.manual_term)   AS event_term,
  ANY_VALUE(collected_traffic_source.gclid)         AS gclid,
  ANY_VALUE((SELECT ep.value.string_value FROM UNNEST(event_params) ep
             WHERE ep.key = 'page_location')) AS page_location,
  MIN(user_first_touch_timestamp) AS user_first_touch_ts,
  MIN(event_timestamp)            AS purchase_ts
FROM `{project}.{dataset}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{suffix(start)}' AND '{suffix(end)}'
  AND event_name = '{PURCHASE_EVENT}'
  AND {tid} IN UNNEST(@order_ids)
GROUP BY transaction_id
""".strip()


def build_academy_ad_sql(project: str, dataset: str, start: str, end: str) -> str:
    """내부 광고영역(academyAd) 클릭 유저. @user_ids(ARRAY<STRING>)로 필터."""
    events = ", ".join(f"'{e}'" for e in ACADEMY_AD_CLICK_EVENTS)
    return f"""
SELECT DISTINCT user_id
FROM `{project}.{dataset}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{suffix(start)}' AND '{suffix(end)}'
  AND event_name IN ({events})
  AND user_id IN UNNEST(@user_ids)
""".strip()


# ── Firestore ────────────────────────────────────────────────────────────────
def _where(query, field: str, op: str, value: Any):
    """google-cloud-firestore 버전 차이 흡수 (FieldFilter 우선, 실패 시 positional)."""
    try:
        from google.cloud.firestore_v1.base_query import FieldFilter

        return query.where(filter=FieldFilter(field, op, value))
    except Exception:  # noqa: BLE001 - 구버전 호환
        return query.where(field, op, value)


def fetch_funnel_orders(
    db, funnel_field: str, funnel_value: str,
    start_dt: datetime, end_dt: datetime,
    academy_id: Optional[str], limit: Optional[int],
) -> list[dict]:
    q = db.collection("Order")
    q = _where(q, funnel_field, "==", funnel_value)
    q = _where(q, "requestedAt", ">=", start_dt)
    q = _where(q, "requestedAt", "<=", end_dt)
    if limit:
        q = q.limit(limit)

    rows: list[dict] = []
    for doc in q.stream():
        d = doc.to_dict() or {}
        receipt = d.get("receipt") or {}
        if academy_id and receipt.get("academyId") != academy_id:
            continue
        requested = d.get("requestedAt")
        rows.append({
            "order_id": doc.id,
            "requested_at": requested.isoformat() if hasattr(requested, "isoformat") else str(requested),
            "academy_id": receipt.get("academyId", ""),
            "academy_name": receipt.get("academyName", ""),
            "user_id": receipt.get("userId", "") or "",
            "user_phone": receipt.get("userPhoneNum", "") or receipt.get("visitorPhoneNum", "") or "",
            "user_type": receipt.get("userType", ""),
            "lesson_name": receipt.get("lessonName", ""),
            "amount": receipt.get("lessonPrice", ""),
            "order_device": receipt.get("device", ""),
            "state": d.get("state", ""),
        })
    return rows


def count_prior_orders(db, user_id: str, before_dt: datetime, cache: dict) -> int:
    """해당 userId의 이전 주문 수(퍼널 무관 전체). 신규/기존 판별 신호."""
    if not user_id:
        return 0
    key = user_id
    if key in cache:
        return cache[key]
    q = db.collection("Order")
    q = _where(q, "receipt.userId", "==", user_id)
    q = _where(q, "requestedAt", "<", before_dt)
    try:
        cnt = sum(1 for _ in q.stream())
    except Exception:  # noqa: BLE001 - 인덱스 부재 등은 0으로 처리하고 계속
        cnt = 0
    cache[key] = cnt
    return cnt


# ── BigQuery 실행 ────────────────────────────────────────────────────────────
def run_bq(client, sql: str, array_param_name: str, values: list[str]) -> list[dict]:
    from google.cloud import bigquery

    job_config = bigquery.QueryJobConfig(
        query_parameters=[bigquery.ArrayQueryParameter(array_param_name, "STRING", values)]
    )
    return [dict(row) for row in client.query(sql, job_config=job_config).result()]


# ── 병합/집계 ────────────────────────────────────────────────────────────────
def build_rows(orders: list[dict], ga4_by_tid: dict, academy_ad_users: set, db,
               mask: bool) -> list[dict]:
    prior_cache: dict = {}
    out: list[dict] = []
    for o in orders:
        tid = o["order_id"]
        g = ga4_by_tid.get(tid, {})
        source = g.get("event_source") or g.get("first_source") or ""
        medium = g.get("event_medium") or g.get("first_medium") or ""
        gclid = g.get("gclid") or ""
        page_location = g.get("page_location") or ""
        fbclid = extract_fbclid(page_location)

        prior = 0
        if db is not None and o["user_id"]:
            before = _dt(o["requested_at"])
            if before:
                prior = count_prior_orders(db, o["user_id"], before, prior_cache)
        is_existing = prior > 0 or norm(o.get("user_type")) == "member"

        row = {
            "order_id": tid,
            "requested_at": o["requested_at"],
            "academy_id": o["academy_id"],
            "academy_name": o["academy_name"],
            "user_id": o["user_id"],
            "user_phone": mask_phone(o["user_phone"]) if mask else o["user_phone"],
            "user_type": o["user_type"],
            "lesson_name": o["lesson_name"],
            "amount": o["amount"],
            "state": o["state"],
            "ga4_matched": bool(g),
            "platform": platform_of(g.get("platform", ""), g.get("device_os", "")),
            "device_os": g.get("device_os", ""),
            "domain": extract_domain(page_location) or g.get("hostname", "") or "",
            "first_source": g.get("first_source", ""),
            "first_medium": g.get("first_medium", ""),
            "first_campaign": g.get("first_campaign", ""),
            "event_source": g.get("event_source", ""),
            "event_medium": g.get("event_medium", ""),
            "event_campaign": g.get("event_campaign", ""),
            "keyword": g.get("event_term", "") or "",
            "gclid": gclid,
            "fbclid": fbclid,
            "acquisition_type": classify_acquisition(source, medium, gclid, fbclid),
            "internal_academy_ad_clicked": (o["user_id"] in academy_ad_users) if o["user_id"] else False,
            "prior_order_count": prior,
            "is_existing_user": is_existing,
        }
        out.append(row)
    return out


def _dt(iso: str) -> Optional[datetime]:
    try:
        return datetime.fromisoformat(iso)
    except (ValueError, TypeError):
        return None


def summarize(rows: list[dict], params: dict) -> dict:
    def counter(key: str) -> dict:
        return dict(Counter(r[key] for r in rows))

    top_sources = Counter(
        f"{(r['event_source'] or r['first_source'] or '(none)')} / "
        f"{(r['event_medium'] or r['first_medium'] or '(none)')}"
        for r in rows
    )
    keywords = Counter(r["keyword"] for r in rows if r["keyword"])
    return {
        "params": params,
        "total_orders": len(rows),
        "ga4_matched": sum(1 for r in rows if r["ga4_matched"]),
        "by_acquisition_type": counter("acquisition_type"),
        "by_platform": counter("platform"),
        "by_user_status": {
            "existing": sum(1 for r in rows if r["is_existing_user"]),
            "new": sum(1 for r in rows if not r["is_existing_user"]),
        },
        "internal_academy_ad_clicked": sum(1 for r in rows if r["internal_academy_ad_clicked"]),
        "top_sources": dict(top_sources.most_common(20)),
        "keywords": dict(keywords.most_common(50)),
    }


def write_outputs(rows: list[dict], summary: dict, out_dir: str) -> None:
    os.makedirs(out_dir, exist_ok=True)
    raw_json = os.path.join(out_dir, "visit_training_funnel_raw.json")
    raw_csv = os.path.join(out_dir, "visit_training_funnel_raw.csv")
    summ = os.path.join(out_dir, "visit_training_funnel_summary.json")

    with open(raw_json, "w", encoding="utf-8") as f:
        json.dump(rows, f, ensure_ascii=False, indent=2)
    if rows:
        with open(raw_csv, "w", encoding="utf-8-sig", newline="") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
    with open(summ, "w", encoding="utf-8") as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)

    print(f"[OK] raw  → {raw_json}")
    print(f"[OK] raw  → {raw_csv}")
    print(f"[OK] summ → {summ}")


# ── main ─────────────────────────────────────────────────────────────────────
def build_arg_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="visit-training 퍼널 유입 정보 정리")
    p.add_argument("--start", help="시작일 YYYY-MM-DD (KST)")
    p.add_argument("--end", help="종료일 YYYY-MM-DD (KST)")
    p.add_argument("--funnel-field", default=FUNNEL_FIELD_DEFAULT, help="Order 퍼널 태그 필드")
    p.add_argument("--funnel-value", default=FUNNEL_VALUE_DEFAULT, help="Order 퍼널 태그 값")
    p.add_argument("--academy-id", default=None, help="특정 학원만 필터(선택)")
    p.add_argument("--bq-project", default=os.getenv("GA4_BQ_PROJECT"), help="BigQuery 프로젝트")
    p.add_argument("--ga4-dataset", default=os.getenv("GA4_BQ_DATASET"), help="GA4 export dataset (analytics_XXXX)")
    p.add_argument("--firestore-db", default=os.getenv("FIRESTORE_DB", "(default)"), help="Firestore DB id")
    p.add_argument("--out-dir", default="./visit_training_funnel_out", help="산출물 디렉토리")
    p.add_argument("--limit", type=int, default=None, help="주문 수 상한(테스트용)")
    p.add_argument("--no-firestore", action="store_true", help="Firestore 건너뛰고 GA4만(주문ID는 --order-ids 필요)")
    p.add_argument("--order-ids", default=None, help="쉼표구분 주문ID (--no-firestore 시 사용)")
    p.add_argument("--include-pii", action="store_true", help="전화번호 마스킹 해제")
    p.add_argument("--skip-academy-ad", action="store_true", help="내부 academyAd 클릭 조회 생략")
    p.add_argument("--print-sql", action="store_true", help="SQL만 출력하고 종료(인증 불필요)")
    return p


def main(argv: Optional[list[str]] = None) -> int:
    args = build_arg_parser().parse_args(argv)

    if args.print_sql:
        proj = args.bq_project or "<PROJECT>"
        ds = args.ga4_dataset or "<analytics_XXXXXXXXX>"
        start = args.start or "2026-01-01"
        end = args.end or "2026-12-31"
        print("=" * 70 + "\n[purchase attribution SQL]\n" + "=" * 70)
        print(build_purchase_sql(proj, ds, start, end))
        print("\n" + "=" * 70 + "\n[academyAd click SQL]\n" + "=" * 70)
        print(build_academy_ad_sql(proj, ds, start, end))
        return 0

    if not args.start or not args.end:
        print("[ERROR] --start / --end 는 필수입니다 (또는 --print-sql).", file=sys.stderr)
        return 2
    if not args.bq_project or not args.ga4_dataset:
        print("[ERROR] --bq-project / --ga4-dataset (또는 GA4_BQ_PROJECT/GA4_BQ_DATASET) 필요.", file=sys.stderr)
        return 2

    start_dt, end_dt = kst_bounds(args.start, args.end)

    # 1) 퍼널 멤버십 (Firestore Order) ------------------------------------------
    db = None
    if args.no_firestore:
        ids = [x.strip() for x in (args.order_ids or "").split(",") if x.strip()]
        if not ids:
            print("[ERROR] --no-firestore 사용 시 --order-ids 필요.", file=sys.stderr)
            return 2
        orders = [{"order_id": i, "requested_at": "", "academy_id": "", "academy_name": "",
                   "user_id": "", "user_phone": "", "user_type": "", "lesson_name": "",
                   "amount": "", "order_device": "", "state": ""} for i in ids]
    else:
        from google.cloud import firestore

        db = firestore.Client(project=args.bq_project, database=args.firestore_db)
        orders = fetch_funnel_orders(
            db, args.funnel_field, args.funnel_value, start_dt, end_dt, args.academy_id, args.limit
        )
    print(f"[INFO] 퍼널 주문 {len(orders)}건")
    if not orders:
        print("[WARN] 대상 주문이 없습니다. 조건을 확인하세요.")
        write_outputs([], summarize([], vars(args) | {"note": "no orders"}), args.out_dir)
        return 0

    # 2) GA4 attribution --------------------------------------------------------
    from google.cloud import bigquery

    bq = bigquery.Client(project=args.bq_project)
    order_ids = [o["order_id"] for o in orders]

    purchase_sql = build_purchase_sql(args.bq_project, args.ga4_dataset, args.start, args.end)
    ga4_rows = run_bq(bq, purchase_sql, "order_ids", order_ids)
    ga4_by_tid = {r["transaction_id"]: r for r in ga4_rows if r.get("transaction_id")}
    print(f"[INFO] GA4 purchase 매칭 {len(ga4_by_tid)}건 / {len(order_ids)}")

    academy_ad_users: set = set()
    if not args.skip_academy_ad:
        user_ids = [o["user_id"] for o in orders if o["user_id"]]
        if user_ids:
            ad_sql = build_academy_ad_sql(args.bq_project, args.ga4_dataset, args.start, args.end)
            ad_rows = run_bq(bq, ad_sql, "user_ids", user_ids)
            academy_ad_users = {r["user_id"] for r in ad_rows if r.get("user_id")}
            print(f"[INFO] 내부 academyAd 클릭 유저 {len(academy_ad_users)}명")

    # 3) 병합 + 집계 + 출력 -----------------------------------------------------
    rows = build_rows(orders, ga4_by_tid, academy_ad_users, db, mask=not args.include_pii)
    params = {
        "start": args.start, "end": args.end,
        "funnel_field": args.funnel_field, "funnel_value": args.funnel_value,
        "academy_id": args.academy_id, "bq_project": args.bq_project,
        "ga4_dataset": args.ga4_dataset, "firestore_db": args.firestore_db,
        "generated_at_kst": datetime.now(KST).isoformat(),
    }
    summary = summarize(rows, params)
    write_outputs(rows, summary, args.out_dir)
    print("\n[SUMMARY] " + json.dumps(summary["by_acquisition_type"], ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
