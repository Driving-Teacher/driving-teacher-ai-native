# 도메인 지식 플로우

## SSOT (Single Source of Truth)

```
driving-teacher-frontend/docs/  (Git = SSOT)
├── 1-guides/       가이드
├── 2-domains/      도메인 지식
├── 3-apps/         앱별 문서
├── prd/            기획서
├── stories/        유저 스토리
└── ...
```

## 읽기 경로

```
                    ┌─ 개발자 (Claude Code) ← 로컬 docs/ 직접 읽기
Git docs/ (SSOT) ──┤
                    └─ 커밋 시 → GDrive 동기화 ← Claude Desktop (GDrive MCP)
```

## 쓰기 경로

```
개발자:     로컬에서 직접 편집 → git commit
비개발자:   Claude Code에서 "이거 수정해줘" → Claude가 docs/ 편집 → git commit
```

## 스킬에서의 활용

```
/think-deeper
  Step 1~3: 순수 사고 (5 Whys, Plan A/B/C, 임기응변 체크)
  Step 4:   "참고할 자료 있나요?" → 있으면 docs/ 또는 GDrive 검색
            → 기획 문서 출력
```

## 팀원 셋업

```
개발자:     git clone driving-teacher-frontend (이미 있음)
비개발자:   bash scripts/setup-gdrive-mcp.sh (GDrive 접근용)
전원:       Claude Code 사용법만 알면 됨
```
