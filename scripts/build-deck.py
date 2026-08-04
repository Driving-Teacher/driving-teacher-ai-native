#!/usr/bin/env python3
"""docs/deck/*.md 를 발표용 HTML 덱으로 굽는다.

왜 이게 있나
------------
예전엔 덱이 HTML 로만 존재했다. 그래서 내용이 CSS·애니메이션 태그
사이에 파묻혀 있었고, 한 줄 고치는 게 부담스러워서 아무도 안 고쳤다.
대신 덱 앞에 "이건 이제 안 씁니다" 슬라이드를 덧붙이는 식으로 넘어갔고,
그렇게 시즌1 내용과 실제로 하는 말이 갈라졌다.

이제 내용은 마크다운에만 있고 HTML 은 구운 결과물이다.
**HTML 을 직접 고치지 말 것** — 다음 빌드에 덮어써진다.

쓰는 법
-------
    python3 scripts/build-deck.py            # 전체 다시 굽기
    python3 scripts/build-deck.py 01-why     # 이름에 01-why 가 든 것만
    python3 scripts/build-deck.py --check    # 굽지 않고 최신인지만 확인 (CI용)

문법
----
문서 맨 위에 제목 블록, 그 아래로 `---` 한 줄이 장 구분이다.

    ---
    title: 왜 AI Native 인가
    subtitle: 오프닝 · 15분
    ---

    [00 · 오늘 흐름]
    ## 오늘은 딱 한 사례, {제대로 봅니다.}
    > 리드 문장은 인용부호로.

    - 목록은 하이픈으로
    - **굵게** 와 {강조색} 과 {{보조색}} 과 `코드` 를 쓸 수 있다

    ---

    [사례 · 실전 공유]
    ## 다음 장

    @ 09:30 | 여는 이야기 | 왜 모였는지          ← 타임라인 한 줄
    @ 10:00 | 실습        | 각자 노트북으로

    :::card 카드 제목
    카드 본문. 카드를 여러 개 연달아 쓰면 가로로 붙는다.
    :::

    !! 노란 강조 박스. 꼭 짚고 갈 것에만.
"""

from __future__ import annotations

import html
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCES = ROOT / "docs" / "deck"

# 한 슬라이드에서 reveal 애니메이션 지연은 6단계까지만 준비돼 있다(deck.css).
MAX_DELAY = 6
# 이보다 블록이 많으면 세로로 넘칠 가능성이 높아 스크롤을 허용한다.
SCROLL_THRESHOLD = 7


# --------------------------------------------------------------------------
# 인라인 표기
# --------------------------------------------------------------------------
def inline(text: str) -> str:
    """한 줄 안의 표기를 HTML 로. 이스케이프를 **먼저** 하고 표기를 푼다.

    순서가 반대면 사용자가 쓴 `<` 가 태그로 살아나 덱이 깨진다.
    """
    out = html.escape(text, quote=False)

    # `코드` — 코드 안에는 다른 표기를 적용하지 않도록 먼저 빼둔다.
    stash: list[str] = []

    def _stash(m: re.Match) -> str:
        stash.append(f"<code>{m.group(1)}</code>")
        return f"\x00{len(stash) - 1}\x00"

    out = re.sub(r"`([^`]+)`", _stash, out)

    out = re.sub(r"\*\*(.+?)\*\*", r'<span class="bold">\1</span>', out)
    # {{보조색}} 을 {강조색} 보다 먼저 — 안 그러면 바깥 중괄호만 먹는다.
    out = re.sub(r"\{\{(.+?)\}\}", r'<span class="accent2">\1</span>', out)
    out = re.sub(r"\{([^{}]+?)\}", r'<span class="accent">\1</span>', out)
    out = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", r'<a href="\2" target="_blank" rel="noopener">\1</a>', out)

    for i, frag in enumerate(stash):
        out = out.replace(f"\x00{i}\x00", frag)
    return out


def tag_html(raw: str) -> str:
    """`[00 · 오늘 흐름]` → 좌상단 라벨."""
    parts = re.split(r"\s*[·—]\s*", raw.strip(), maxsplit=1)
    num = html.escape(parts[0])
    label = html.escape(parts[1]) if len(parts) > 1 else ""
    sep = '<span class="sep">—</span>' if label else ""
    lbl = f'<span class="label">{label}</span>' if label else ""
    return f'<div class="tag reveal"><span class="num">{num}</span>{sep}{lbl}</div>'


def add_reveal(block: str, delay: int) -> str:
    """블록의 여는 태그에 reveal 클래스를 얹는다 (기존 class 는 보존)."""
    m = re.match(r"^<(\w+)([^>]*)>", block)
    if not m:
        return block
    tag, attrs = m.group(1), m.group(2)
    rev = f"reveal reveal-delay-{delay}"
    if 'class="' in attrs:
        attrs = re.sub(r'class="([^"]*)"', lambda mm: f'class="{mm.group(1)} {rev}"', attrs, count=1)
    else:
        attrs = f'{attrs} class="{rev}"'
    return f"<{tag}{attrs}>" + block[m.end():]


# --------------------------------------------------------------------------
# 슬라이드 본문
# --------------------------------------------------------------------------
def render_slide(body: str) -> str:
    lines = body.split("\n")
    blocks: list[str] = []
    i = 0

    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        if not stripped:
            i += 1
            continue

        # [태그]
        if stripped.startswith("[") and stripped.endswith("]") and "](" not in stripped:
            blocks.append(tag_html(stripped[1:-1]))
            i += 1
            continue

        # 제목
        m = re.match(r"^(#{1,3})\s+(.*)$", stripped)
        if m:
            level = len(m.group(1))
            blocks.append(f"<h{level}>{inline(m.group(2))}</h{level}>")
            i += 1
            continue

        # > 리드
        if stripped.startswith(">"):
            buf = []
            while i < len(lines) and lines[i].strip().startswith(">"):
                buf.append(lines[i].strip().lstrip(">").strip())
                i += 1
            blocks.append(f'<p class="lead">{inline(" ".join(buf))}</p>')
            continue

        # !! 강조 박스
        if stripped.startswith("!!"):
            buf = []
            while i < len(lines) and lines[i].strip().startswith("!!"):
                buf.append(lines[i].strip().lstrip("!").strip())
                i += 1
            blocks.append(f'<div class="note"><p>{inline(" ".join(buf))}</p></div>')
            continue

        # @ 시각 | 제목 | 설명  → 타임라인
        if stripped.startswith("@"):
            rows = []
            while i < len(lines) and lines[i].strip().startswith("@"):
                cells = [c.strip() for c in lines[i].strip().lstrip("@").split("|")]
                time = inline(cells[0]) if cells else ""
                title = inline(cells[1]) if len(cells) > 1 else ""
                desc = inline(cells[2]) if len(cells) > 2 else ""
                rows.append(
                    '<div class="tl-row">'
                    f'<div class="tl-time">{time}</div><div class="tl-bar"></div>'
                    f'<div class="tl-body"><div class="t">{title}</div>'
                    f'<div class="d">{desc}</div></div></div>'
                )
                i += 1
            blocks.append('<div class="timeline">' + "".join(rows) + "</div>")
            continue

        # :::card 제목 ... :::  (연달아 쓰면 한 그리드로 묶인다)
        # :::quad 는 2열로 못 박은 사분면. 넓은 화면에서도 2×2 를 유지한다.
        # 제목 끝에 * 를 붙이면 그 칸이 강조된다 (:::quad 모른다는 것도 모른다*)
        if stripped.startswith(":::card") or stripped.startswith(":::quad"):
            kind = "quad" if stripped.startswith(":::quad") else "card"
            marker = ":::" + kind
            cards = []
            while i < len(lines) and lines[i].strip().startswith(marker):
                title = lines[i].strip()[len(marker):].strip()
                hot = title.endswith("*")
                if hot:
                    title = title[:-1].strip()
                i += 1
                buf = []
                while i < len(lines) and lines[i].strip() != ":::":
                    buf.append(lines[i])
                    i += 1
                i += 1  # 닫는 :::
                head = f"<h3>{inline(title)}</h3>" if title else ""
                text = " ".join(x.strip() for x in buf if x.strip())
                cls = "card hot" if hot else "card"
                cards.append(f'<div class="{cls}">{head}<p>{inline(text)}</p></div>')
                while i < len(lines) and not lines[i].strip():
                    i += 1
            wrap = "cards quad" if kind == "quad" else "cards"
            blocks.append(f'<div class="{wrap}">' + "".join(cards) + "</div>")
            continue

        # ```코드```
        if stripped.startswith("```"):
            i += 1
            buf = []
            while i < len(lines) and not lines[i].strip().startswith("```"):
                buf.append(lines[i])
                i += 1
            i += 1
            code = html.escape("\n".join(buf), quote=False)
            blocks.append(f"<pre><code>{code}</code></pre>")
            continue

        # - 목록
        if stripped.startswith("- "):
            items = []
            while i < len(lines) and lines[i].strip().startswith("- "):
                items.append(f"<li>{inline(lines[i].strip()[2:])}</li>")
                i += 1
            blocks.append('<ul class="bullets">' + "".join(items) + "</ul>")
            continue

        # 그 밖엔 문단
        buf = []
        while i < len(lines) and lines[i].strip() and not re.match(
            r"^\s*([#>\-@!`\[]|:::)", lines[i]
        ):
            buf.append(lines[i].strip())
            i += 1
        if buf:
            blocks.append(f"<p>{inline(' '.join(buf))}</p>")
        else:
            # 어떤 규칙에도 안 걸렸다 — 조용히 삼키면 내용이 사라지므로 문단으로.
            blocks.append(f"<p>{inline(stripped)}</p>")
            i += 1

    # reveal 지연을 위에서부터 순서대로. 태그는 이미 reveal 이 붙어 있다.
    out: list[str] = []
    delay = 0
    for b in blocks:
        if 'class="tag reveal"' in b:
            out.append(b)
            continue
        delay = min(delay + 1, MAX_DELAY)
        out.append(add_reveal(b, delay))

    scrollable = " scrollable" if len(blocks) > SCROLL_THRESHOLD else ""
    return f'<div class="slide{scrollable}">\n  ' + "\n  ".join(out) + "\n</div>"


# --------------------------------------------------------------------------
# 문서 전체
# --------------------------------------------------------------------------
def parse(md: str) -> tuple[dict[str, str], list[str]]:
    meta: dict[str, str] = {}
    body = md.strip()

    if body.startswith("---"):
        end = body.find("\n---", 3)
        if end != -1:
            for line in body[3:end].strip().split("\n"):
                if ":" in line:
                    k, v = line.split(":", 1)
                    meta[k.strip()] = v.strip()
            body = body[end + 4:]

    # <!-- 진행자 메모 --> 는 소스에만 남기고 덱에는 내보내지 않는다.
    # 이걸 안 지우면 "<!--" 가 이스케이프돼서 슬라이드에 그대로 찍힌다.
    body = re.sub(r"<!--.*?-->", "", body, flags=re.S)

    slides = [s for s in re.split(r"\n---+\s*\n", body) if s.strip()]
    return meta, slides


def build(md_path: Path) -> str:
    meta, slides = parse(md_path.read_text(encoding="utf-8"))
    title = meta.get("title", md_path.stem)
    rendered = "\n\n".join(render_slide(s) for s in slides)

    return f"""<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{html.escape(title)}</title>
<!-- ⚠️ 이 파일은 scripts/build-deck.py 가 만든 결과물이다.
     고칠 곳은 docs/deck/{md_path.name} 이고, 고친 뒤 다시 굽는다:
         python3 scripts/build-deck.py
     여기를 직접 고치면 다음 빌드에 사라진다. -->
<link rel="stylesheet" href="../deck.css">
</head>
<body>

<div class="topbar"><div id="progress"></div></div>
<div class="hint">← → 또는 클릭으로 이동</div>
<div id="counter">1 / {len(slides)}</div>

<div class="deck" id="deck">

{rendered}

</div>

<script src="../deck.js"></script>
</body>
</html>
"""


def main() -> int:
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    check = "--check" in sys.argv

    if not SOURCES.is_dir():
        print(f"덱 소스 폴더가 없습니다: {SOURCES}", file=sys.stderr)
        return 1

    sources = sorted(SOURCES.glob("*.md"))
    sources = [p for p in sources if p.name.lower() != "readme.md"]
    if args:
        sources = [p for p in sources if any(a in p.name for a in args)]

    if not sources:
        print("구울 게 없습니다.", file=sys.stderr)
        return 1

    stale = 0
    for src in sources:
        out = src.with_suffix(".html")
        new = build(src)
        old = out.read_text(encoding="utf-8") if out.exists() else None

        if check:
            if old != new:
                print(f"  ✗ 최신 아님  {out.relative_to(ROOT)}")
                stale += 1
            continue

        if old == new:
            print(f"  =  그대로   {out.relative_to(ROOT)}")
        else:
            out.write_text(new, encoding="utf-8")
            n = len(parse(src.read_text(encoding='utf-8'))[1])
            print(f"  ✓  구움     {out.relative_to(ROOT)}  ({n}장)")

    if check:
        if stale:
            print(f"\n{stale}개가 소스와 어긋납니다. `python3 scripts/build-deck.py` 를 돌리세요.", file=sys.stderr)
            return 1
        print("  모두 최신입니다.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
