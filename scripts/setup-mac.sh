#!/bin/bash
# 운전선생 AI Native Camp - macOS 세팅 스크립트
# 실행: curl -fsSL [URL] | bash 또는 bash setup-mac.sh

set -e

echo "=============================="
echo " 운전선생 AI Native Camp 세팅"
echo "=============================="
echo ""

# 1. Xcode CLI Tools (git 포함)
echo "[ 1/4 ] git 확인..."
if command -v git &> /dev/null; then
    echo "  ✅ git $(git --version | cut -d' ' -f3)"
else
    echo "  ⏳ Xcode CLI Tools 설치 중... (팝업이 뜨면 '설치' 클릭)"
    xcode-select --install 2>/dev/null || true
    echo "  ⚠️  설치 완료 후 이 스크립트를 다시 실행해주세요."
    exit 1
fi

# 2. Claude Code
echo "[ 2/4 ] Claude Code 확인..."
if command -v claude &> /dev/null; then
    echo "  ✅ Claude Code $(claude --version 2>/dev/null || echo 'installed')"
else
    echo "  ⏳ Claude Code 설치 중..."
    curl -fsSL https://claude.ai/install.sh | bash
    export PATH="$HOME/.claude/bin:$PATH"
    echo "  ✅ Claude Code 설치 완료"
fi

# 3. Node.js (fnm)
echo "[ 3/4 ] Node.js 확인..."
if command -v node &> /dev/null; then
    echo "  ✅ Node.js $(node --version)"
else
    echo "  ⏳ Node.js 설치 중 (fnm)..."
    # Homebrew 없이도 설치되도록 바이너리 직접 다운로드
    FNM_DIR="$HOME/.local/share/fnm"
    ARCH=$(uname -m)
    if [[ "$ARCH" == "arm64" ]]; then
        FNM_PLATFORM="aarch64-apple-darwin"
    else
        FNM_PLATFORM="x86_64-apple-darwin"
    fi
    FNM_URL="https://github.com/Schniz/fnm/releases/latest/download/fnm-${FNM_PLATFORM}.zip"
    mkdir -p "$FNM_DIR"
    curl -fsSL "$FNM_URL" -o /tmp/fnm.zip
    unzip -o /tmp/fnm.zip -d "$FNM_DIR"
    chmod +x "$FNM_DIR/fnm"
    rm -f /tmp/fnm.zip
    export PATH="$HOME/.local/share/fnm:$PATH"
    eval "$(fnm env)"
    fnm install --lts
    echo "  ✅ Node.js $(node --version) 설치 완료"
fi

# 4. Python
echo "[ 4/4 ] Python 확인..."
if command -v python3 &> /dev/null; then
    echo "  ✅ Python $(python3 --version | cut -d' ' -f2)"
else
    echo "  ⚠️  Python이 없습니다. 나중에 필요하면 설치합니다."
fi

echo ""
echo "=============================="
echo " 세팅 완료!"
echo "=============================="
echo ""
echo "다음 단계:"
echo "  1. 터미널을 껐다가 다시 열기"
echo "  2. claude 입력 → 브라우저에서 로그인"
echo "  3. 스크린샷을 슬랙 #ai-native-camp 에 올리기"
echo ""
