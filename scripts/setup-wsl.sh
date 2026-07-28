#!/usr/bin/env bash
# 운전선생 — Windows(WSL Ubuntu) 세팅 스크립트
# 실행: WSL Ubuntu 터미널에서  bash scripts/setup-wsl.sh
#
# ⚠️ 네이티브 Windows(PowerShell/CMD/Git Bash)에서는 돌아가지 않습니다.
#    Zeude 스킬 자동 동기화 shim이 Mac/Linux 빌드만 있어서, 네이티브 Windows에
#    깔면 /ai-onboarding 같은 회사 스킬이 아예 안 뜹니다. (SETUP.md Step 0 참고)
#
# 설계 원칙 — 비개발자가 혼자 돌립니다.
#   1. 실패를 절대 성공으로 보고하지 않는다. 설치 후 실제로 명령이 있는지 확인한다.
#   2. 죽을 때는 한국어로 다음 행동을 알려주고 죽는다.
#   3. 몇 번 돌려도 안전하다 (.bashrc 에 같은 줄이 쌓이지 않는다).

set -Eeuo pipefail

FNM_DIR="$HOME/.local/share/fnm"
BASHRC="$HOME/.bashrc"
MARK_BEGIN="# >>> 운전선생 setup-wsl >>>"
MARK_END="# <<< 운전선생 setup-wsl <<<"
SLACK="#ai-native-camp"
NODE_MIN_MAJOR=20

FAILED=()
APT_UPDATED=0
HAS_SUDO=0

# ── 도우미 ──────────────────────────────────────────────────────
die() {
    echo ""
    echo "  ❌ $1"
    echo ""
    echo "  → 슬랙 $SLACK 에 이 화면을 그대로 캡처해서 올려주세요. 도와드립니다."
    exit 1
}

# .bashrc 끝에 개행 없이 저장돼 있어도 안전하게 append
rc_append() {
    printf '\n%s\n' "$1" >> "$BASHRC"
}

# 우리 블록을 마커로 단독 관리 — 재실행 시 통째로 교체하므로 중복이 안 쌓인다
rc_write_block() {
    local body="$1" tmp
    touch "$BASHRC"
    if grep -qF "$MARK_BEGIN" "$BASHRC" 2>/dev/null; then
        tmp="$(mktemp)"
        awk -v b="$MARK_BEGIN" -v e="$MARK_END" '
            index($0,b){skip=1} !skip{print} index($0,e){skip=0}
        ' "$BASHRC" > "$tmp"
        mv "$tmp" "$BASHRC"
    fi
    printf '\n%s\n%s\n%s\n' "$MARK_BEGIN" "$body" "$MARK_END" >> "$BASHRC"
}

apt_install() {
    if [ "$HAS_SUDO" -eq 0 ]; then
        echo "  ⚠️  sudo가 없어서 '$*' 설치를 건너뜁니다."
        echo "     관리자에게 'apt install $*' 를 요청해주세요."
        return 1
    fi
    if [ "$APT_UPDATED" -eq 0 ]; then
        sudo apt-get update -qq \
            || die "패키지 목록을 못 받았습니다. 인터넷·회사 VPN/프록시 문제일 수 있습니다."
        APT_UPDATED=1
    fi
    sudo apt-get install -y -qq "$@" \
        || die "'$*' 설치에 실패했습니다. 인터넷·회사 VPN/프록시 문제일 수 있습니다."
}

node_major() {
    node --version 2>/dev/null | sed 's/^v//' | cut -d. -f1
}

echo "=============================="
echo " 운전선생 세팅 (WSL Ubuntu)"
echo "=============================="

# ── 1. 실행 환경 확인 ───────────────────────────────────────────
echo ""
echo "[ 1/5 ] 실행 환경 확인..."

# root 로 돌리면 전부 /root 에 깔려서 본인 셸에선 아무것도 안 보인다
if [ "$(id -u)" -eq 0 ]; then
    echo "  ❌ sudo(관리자)로 실행하셨습니다."
    echo ""
    echo "     sudo 없이 다시 실행해주세요:"
    echo "       bash scripts/setup-wsl.sh"
    echo ""
    echo "     (중간에 비밀번호를 물으면 그때 입력하시면 됩니다."
    echo "      지금처럼 sudo를 미리 붙이면 관리자 폴더에 깔려서 안 보입니다.)"
    exit 1
fi

case "$(uname -s)" in
    Darwin)
        echo "  ❌ macOS입니다. 이 스크립트가 아니라 아래를 실행해주세요:"
        echo "       bash scripts/setup-mac.sh"
        exit 1
        ;;
    MINGW* | MSYS* | CYGWIN*)
        echo "  ❌ Git Bash / MSYS 입니다. 여기서는 Claude Code가 안 깔립니다."
        echo ""
        echo "     WSL Ubuntu 터미널을 열고 다시 실행해주세요:"
        echo "       Windows 키 → 'Ubuntu' 입력 → 엔터"
        echo ""
        echo "     WSL이 없으면 SETUP.md 의 Step 0(wsl --install)부터 해주세요."
        exit 1
        ;;
esac

if grep -qiE "microsoft|wsl" /proc/version 2>/dev/null; then
    echo "  ✅ WSL ($(uname -r))"
    # WSL1 에서는 Claude Code 네이티브 바이너리가 'Exec format error' 로 죽는다
    # (알려진 회귀 — anthropics/claude-code#38788)
    case "$(uname -r)" in
        *WSL2* | *wsl2*) ;;
        *)
            echo ""
            echo "  ❌ WSL1로 보입니다. WSL1에서는 Claude Code가 실행되지 않습니다."
            echo ""
            echo "     PowerShell(관리자)에서 WSL2로 올려주세요:"
            echo "       wsl -l -v                        (배포판 이름 확인)"
            echo "       wsl --set-version Ubuntu 2       (이름이 Ubuntu인 경우)"
            echo ""
            echo "     변환에 몇 분 걸립니다. 끝나면 이 스크립트를 다시 실행해주세요."
            exit 1
            ;;
    esac
    # Windows 디스크(/mnt/c)에서 돌리면 느리고 파일 검색 품질이 떨어진다
    case "$PWD" in
        /mnt/*)
            echo "  ⚠️  지금 Windows 디스크($PWD)에서 실행 중입니다."
            echo "     느리고 AI가 파일을 잘 못 찾습니다. 레포는 Linux 쪽 홈(~/)에 두세요."
            echo "     Step 7의 /company-setup 이 ~/Documents/company-code/ 로 알아서 받아옵니다."
            ;;
    esac
else
    echo "  ⚠️  WSL로 보이지 않습니다. (일반 Linux면 그대로 진행해도 됩니다)"
    printf "     계속할까요? [y/N] "
    read -r answer || answer="n"   # 파이프 실행 등 stdin이 없으면 중단이 안전
    case "${answer:-n}" in
        [yY]*) echo "     → 계속합니다." ;;
        *) echo "     중단했습니다. WSL Ubuntu 터미널에서 다시 실행해주세요."; exit 1 ;;
    esac
fi

if sudo -n true 2>/dev/null || sudo -v 2>/dev/null; then
    HAS_SUDO=1
else
    HAS_SUDO=0
    echo "  ⚠️  sudo를 쓸 수 없습니다. apt로 깔아야 하는 단계는 건너뜁니다."
fi

# 두 인스톨러의 전제 — 없으면 조용히 실패하므로 미리 챙긴다
for cmd in curl unzip; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "  ⏳ $cmd 설치 중..."
        apt_install "$cmd" ca-certificates || die "$cmd 이 없어서 더 진행할 수 없습니다."
    fi
done
echo "  ✅ curl · unzip 확인"

# ── 2. git ──────────────────────────────────────────────────────
echo ""
echo "[ 2/5 ] git 확인..."
if command -v git >/dev/null 2>&1; then
    echo "  ✅ git $(git --version | cut -d' ' -f3)"
else
    echo "  ⏳ git 설치 중... (비밀번호를 물으면 WSL 설치 때 만든 것 입력)"
    if apt_install git && command -v git >/dev/null 2>&1; then
        echo "  ✅ git $(git --version | cut -d' ' -f3)"
    else
        FAILED+=("git")
        echo "  ❌ git 설치 실패"
    fi
fi

# ── 3. Claude Code ──────────────────────────────────────────────
echo ""
echo "[ 3/5 ] Claude Code 확인..."
export PATH="$HOME/.local/bin:$HOME/.claude/bin:$PATH"

# ⚠️ Windows 쪽 claude 를 잡는 함정
#   Windows에서 npm i -g @anthropic-ai/claude-code 를 했던 사람은
#   %AppData%\npm\claude (확장자 없는 sh 스크립트)가 남는다. WSL은 Windows PATH를
#   상속하므로 bash가 그걸 claude 로 인식하는데, 실제로는 CRLF·node 경로 문제로 죽는다.
#   → /mnt/ 아래면 없는 것으로 취급하고 Linux용으로 새로 깐다.
claude_ok=0
claude_bin="$(command -v claude 2>/dev/null || true)"
case "$claude_bin" in
    /mnt/*)
        echo "  ⚠️  Windows 쪽 claude가 잡혔습니다:"
        echo "       $claude_bin"
        echo "     WSL에서는 정상 동작하지 않아서 Linux용으로 새로 깔겠습니다."
        ;;
    "")
        ;;
    *)
        if claude --version >/dev/null 2>&1; then
            claude_ok=1
            echo "  ✅ Claude Code $(claude --version 2>/dev/null)"
        else
            echo "  ⚠️  claude 명령은 있는데 실행이 안 됩니다 ($claude_bin). 다시 깔겠습니다."
        fi
        ;;
esac

if [ "$claude_ok" -eq 1 ]; then
    :
else
    echo "  ⏳ Claude Code 설치 중..."
    installer="$(mktemp)"
    if ! curl -fsSL https://claude.ai/install.sh -o "$installer"; then
        rm -f "$installer"
        die "Claude Code 설치 파일을 못 받았습니다. 인터넷·회사 VPN/프록시 문제일 수 있습니다."
    fi
    # 인스톨러가 죽어도 여기서 잡아 FAILED 로 기록한다 (성공으로 넘기지 않는다)
    bash "$installer" || true
    rm -f "$installer"
    export PATH="$HOME/.local/bin:$HOME/.claude/bin:$PATH"
    claude_bin="$(command -v claude 2>/dev/null || true)"
    case "$claude_bin" in
        "" | /mnt/*)
            FAILED+=("Claude Code")
            echo "  ❌ Claude Code 설치 실패 (설치 후에도 Linux용 claude를 못 찾음)"
            ;;
        *)
            if claude --version >/dev/null 2>&1; then
                grep -qF '.local/bin' "$BASHRC" 2>/dev/null \
                    || rc_append 'export PATH="$HOME/.local/bin:$HOME/.claude/bin:$PATH"'
                echo "  ✅ Claude Code $(claude --version 2>/dev/null) 설치 완료"
            else
                FAILED+=("Claude Code")
                echo "  ❌ Claude Code 설치 실패 (설치는 됐는데 실행이 안 됨)"
            fi
            ;;
    esac
fi

# ── 4. Node.js (fnm) ────────────────────────────────────────────
echo ""
echo "[ 4/5 ] Node.js 확인..."
need_node=1
if command -v node >/dev/null 2>&1; then
    major="$(node_major || echo 0)"
    if [ "${major:-0}" -ge "$NODE_MIN_MAJOR" ] 2>/dev/null; then
        echo "  ✅ Node.js $(node --version)"
        need_node=0
    else
        echo "  ⚠️  Node.js $(node --version) — 너무 낮습니다 (v${NODE_MIN_MAJOR} 이상 필요)"
        echo "     MCP·플러그인이 안 돌아가므로 최신 LTS를 따로 깔겠습니다."
    fi
fi

if [ "$need_node" -eq 1 ]; then
    echo "  ⏳ Node.js 설치 중 (fnm)..."
    installer="$(mktemp)"
    if ! curl -fsSL https://fnm.vercel.app/install -o "$installer"; then
        rm -f "$installer"
        die "fnm 설치 파일을 못 받았습니다. 인터넷·회사 VPN/프록시 문제일 수 있습니다."
    fi
    # --skip-shell: rc 파일은 우리가 마커로 관리한다 (인스톨러는 조건 없이 append해서 중복이 쌓임)
    # --install-dir: 경로를 고정해 .bashrc 에 쓸 경로와 어긋나지 않게 한다
    bash "$installer" --skip-shell --install-dir "$FNM_DIR" || true
    rm -f "$installer"

    if [ -x "$FNM_DIR/fnm" ]; then
        export PATH="$FNM_DIR:$PATH"
        eval "$("$FNM_DIR/fnm" env --shell bash)" || true
        "$FNM_DIR/fnm" install --lts || true
        eval "$("$FNM_DIR/fnm" env --shell bash)" || true
    fi

    if command -v node >/dev/null 2>&1 && [ "$(node_major)" -ge "$NODE_MIN_MAJOR" ]; then
        rc_write_block "export PATH=\"$FNM_DIR:\$PATH\"
eval \"\$(fnm env --shell bash)\""
        echo "  ✅ Node.js $(node --version) 설치 완료"
    else
        FAILED+=("Node.js")
        echo "  ❌ Node.js 설치 실패 (설치 후에도 node 명령을 못 찾음)"
    fi
fi

# ── 5. Python ───────────────────────────────────────────────────
echo ""
echo "[ 5/5 ] Python 확인..."
if command -v python3 >/dev/null 2>&1; then
    echo "  ✅ Python $(python3 --version | cut -d' ' -f2)"
else
    echo "  ⏳ Python 설치 중..."
    if apt_install python3 && command -v python3 >/dev/null 2>&1; then
        echo "  ✅ Python $(python3 --version | cut -d' ' -f2)"
    else
        FAILED+=("Python")
        echo "  ❌ Python 설치 실패"
    fi
fi

# ── 마무리 ──────────────────────────────────────────────────────
echo ""
if [ "${#FAILED[@]}" -gt 0 ]; then
    echo "=============================="
    echo " ⚠️  일부 실패했습니다"
    echo "=============================="
    echo ""
    echo "  안 깔린 것: ${FAILED[*]}"
    echo ""
    echo "  1) 인터넷·회사 VPN/프록시를 확인하고 이 스크립트를 한 번 더 돌려보세요."
    echo "     (여러 번 돌려도 안전합니다)"
    echo "  2) 그래도 같으면 슬랙 $SLACK 에 이 화면을 캡처해 올려주세요."
    echo ""
    exit 1
fi

echo "=============================="
echo " 세팅 완료!"
echo "=============================="
echo ""
# npm 은 Windows 쪽이 잡힐 수 있다 (확장자 없는 sh 스크립트라 bash가 인식함).
# 런타임엔 fnm PATH가 앞서서 정상이지만, 나중에 문제가 생기면 이 줄이 단서가 된다.
npm_bin="$(command -v npm 2>/dev/null || true)"
case "$npm_bin" in
    /mnt/*)
        echo "  ⚠️  참고: npm 이 Windows 쪽으로 잡혀 있습니다 ($npm_bin)."
        echo "     터미널을 다시 열면 Linux 쪽이 우선됩니다. 나중에 npm 관련 에러가"
        echo "     나면 이 줄을 슬랙에 같이 알려주세요."
        echo ""
        ;;
esac

echo "다음 단계:"
echo "  1. 이 Ubuntu 터미널을 껐다가 다시 열기 (또는  source ~/.bashrc )"
echo "  2. claude  입력 → 로그인"
echo "     WSL은 브라우저 로그인이 종종 막힙니다. 순서대로 시도해주세요:"
echo "       · 브라우저에 뜬 코드를 복사해서 터미널에 붙여넣기"
echo "       · 브라우저가 안 열리면 c 키 → URL 복사 → 직접 열기"
echo "       · 그래도 안 되면:"
echo "         export BROWSER=\"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe\""
echo "  3. 버전 확인 4개:"
echo "       claude --version / node --version / git --version / python3 --version"
echo "  4. SETUP.md 의 Step 6부터 계속:"
echo "       /zeude-setup → /company-setup → /mcp → /ai-onboarding"
echo ""
echo "막히면 5분만 붙잡고 슬랙 $SLACK 에 에러 화면을 올려주세요."
echo ""
