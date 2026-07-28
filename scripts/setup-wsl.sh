#!/bin/bash
# 운전선생 — Windows(WSL Ubuntu) 세팅 스크립트
# 실행: WSL Ubuntu 터미널에서  bash scripts/setup-wsl.sh
#
# ⚠️ 네이티브 Windows(PowerShell/CMD)에서는 돌리지 마세요.
#    Zeude 스킬 자동 동기화가 Mac/Linux 빌드만 있어서, 네이티브 Windows에
#    깔면 /ai-onboarding 같은 회사 스킬이 아예 안 뜹니다.
#    자세한 이유는 SETUP.md 의 Step 0 참고.

set -e

echo "=============================="
echo " 운전선생 세팅 (WSL Ubuntu)"
echo "=============================="
echo ""

# ── 0. WSL 인지 확인 ────────────────────────────────────────────
echo "[ 0/4 ] 실행 환경 확인..."
if ! grep -qiE "microsoft|wsl" /proc/version 2>/dev/null; then
    if [ "$(uname -s)" = "Darwin" ]; then
        echo "  ❌ macOS입니다. 이 스크립트가 아니라 아래를 실행해주세요:"
        echo "       bash scripts/setup-mac.sh"
        exit 1
    fi
    echo "  ⚠️  WSL로 보이지 않습니다. (일반 Linux면 그대로 진행해도 됩니다)"
    echo "     Git Bash·PowerShell이라면 여기서 멈추고 SETUP.md Step 0의"
    echo "     WSL 설치부터 해주세요."
    printf "     계속할까요? [y/N] "
    read -r answer
    case "$answer" in
        [yY]*) echo "  → 계속합니다." ;;
        *) echo "  중단했습니다."; exit 1 ;;
    esac
else
    echo "  ✅ WSL Ubuntu ($(uname -r))"
fi

# sudo 사용 가능 여부 (apt 설치에 필요)
if ! command -v sudo &> /dev/null; then
    echo "  ⚠️  sudo가 없습니다. git·python 설치 단계를 건너뛸 수 있습니다."
fi

# ── 1. git ──────────────────────────────────────────────────────
echo ""
echo "[ 1/4 ] git 확인..."
if command -v git &> /dev/null; then
    echo "  ✅ git $(git --version | cut -d' ' -f3)"
else
    echo "  ⏳ git 설치 중... (비밀번호를 물으면 WSL 설치 때 만든 것 입력)"
    sudo apt-get update -qq
    sudo apt-get install -y -qq git
    echo "  ✅ git $(git --version | cut -d' ' -f3)"
fi

# ── 2. Claude Code ──────────────────────────────────────────────
echo ""
echo "[ 2/4 ] Claude Code 확인..."
if command -v claude &> /dev/null; then
    echo "  ✅ Claude Code $(claude --version 2>/dev/null || echo 'installed')"
else
    echo "  ⏳ Claude Code 설치 중..."
    curl -fsSL https://claude.ai/install.sh | bash
    # 현재 셸 + 영구 PATH
    export PATH="$HOME/.local/bin:$HOME/.claude/bin:$PATH"
    if ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi
    echo "  ✅ Claude Code 설치 완료"
fi

# ── 3. Node.js (fnm) ────────────────────────────────────────────
echo ""
echo "[ 3/4 ] Node.js 확인..."
if command -v node &> /dev/null; then
    echo "  ✅ Node.js $(node --version)"
else
    echo "  ⏳ Node.js 설치 중 (fnm)..."
    # unzip이 없으면 fnm 설치 스크립트가 실패한다
    if ! command -v unzip &> /dev/null; then
        sudo apt-get update -qq
        sudo apt-get install -y -qq unzip
    fi
    curl -fsSL https://fnm.vercel.app/install | bash

    FNM_BIN="$HOME/.local/share/fnm/fnm"
    if [ ! -x "$FNM_BIN" ]; then
        FNM_BIN="$(command -v fnm || true)"
    fi

    if [ -z "$FNM_BIN" ]; then
        echo "  ⚠️  fnm을 못 찾았습니다. 터미널을 껐다 열고 다시 실행해주세요."
        echo "     (그래도 안 되면 슬랙 #ai-native 에 물어봐주세요)"
    else
        export PATH="$(dirname "$FNM_BIN"):$PATH"
        eval "$("$FNM_BIN" env --shell bash)"
        "$FNM_BIN" install --lts
        # 셸에 영구 등록 (fnm 설치 스크립트가 이미 넣었으면 중복 방지)
        if ! grep -q 'fnm env' "$HOME/.bashrc" 2>/dev/null; then
            echo 'export PATH="$HOME/.local/share/fnm:$PATH"' >> "$HOME/.bashrc"
            echo 'eval "$(fnm env --shell bash)"' >> "$HOME/.bashrc"
        fi
        echo "  ✅ Node.js $(node --version 2>/dev/null || echo '설치 완료') "
    fi
fi

# ── 4. Python ───────────────────────────────────────────────────
echo ""
echo "[ 4/4 ] Python 확인..."
if command -v python3 &> /dev/null; then
    echo "  ✅ Python $(python3 --version | cut -d' ' -f2)"
else
    echo "  ⏳ Python 설치 중..."
    sudo apt-get update -qq
    sudo apt-get install -y -qq python3
    echo "  ✅ Python $(python3 --version | cut -d' ' -f2)"
fi

echo ""
echo "=============================="
echo " 세팅 완료!"
echo "=============================="
echo ""
echo "다음 단계:"
echo "  1. 이 Ubuntu 터미널을 껐다가 다시 열기 (또는  source ~/.bashrc )"
echo "  2. claude  입력 → 브라우저에서 로그인"
echo "  3. 버전 4개 확인:  claude --version / node --version / git --version / python3 --version"
echo "  4. SETUP.md 의 Step 6부터 계속 (/zeude-setup → /company-setup → /mcp → /ai-onboarding)"
echo ""
echo "막히면 5분만 붙잡고 슬랙 #ai-native 에 에러 화면을 올려주세요."
echo ""
