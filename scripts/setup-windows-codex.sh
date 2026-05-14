#!/usr/bin/env bash
# 운전선생 AI Native Camp - Windows Git Bash Codex 세팅 스크립트
# 실행: Git Bash에서 bash scripts/setup-windows-codex.sh

set -euo pipefail

step() {
  echo ""
  echo "[$1] $2"
}

has_command() {
  command -v "$1" >/dev/null 2>&1
}

add_windows_paths() {
  # winget/node installers update Windows PATH, but the current Git Bash session
  # often does not see it until the terminal is reopened.
  local windows_apps="/c/Users/${USERNAME:-$USER}/AppData/Local/Microsoft/WindowsApps"
  if [[ -d "$windows_apps" ]]; then
    export PATH="$windows_apps:$PATH"
  fi

  if [[ -d "/c/Program Files/nodejs" ]]; then
    export PATH="/c/Program Files/nodejs:$PATH"
  fi

  if [[ -n "${APPDATA:-}" ]] && has_command cygpath; then
    local appdata_unix
    appdata_unix="$(cygpath "$APPDATA")"
    if [[ -d "$appdata_unix/npm" ]]; then
      export PATH="$appdata_unix/npm:$PATH"
    fi
  fi
}

require_winget() {
  add_windows_paths

  if ! has_command winget.exe; then
    echo "winget.exe를 찾을 수 없습니다."
    echo "아래 둘 중 하나로 해결해주세요."
    echo "  1. Microsoft Store에서 'App Installer'를 설치/업데이트한 뒤 Git Bash 다시 열기"
    echo "  2. Windows 설정 > 앱 > 고급 앱 설정 > 앱 실행 별칭에서 'Windows Package Manager Client' 켜기"
    exit 1
  fi
}

install_winget_package() {
  local id="$1"
  local name="$2"

  require_winget
  echo "  [installing] $name ..."
  winget.exe install --id "$id" --exact --accept-package-agreements --accept-source-agreements
  add_windows_paths
  echo "  [OK] $name installed"
}

run_npm() {
  add_windows_paths

  if has_command npm; then
    npm "$@"
    return
  fi

  if [[ -f "/c/Program Files/nodejs/npm.cmd" ]]; then
    "/c/Program Files/nodejs/npm.cmd" "$@"
    return
  fi

  echo "npm을 찾을 수 없습니다. Git Bash를 껐다가 다시 열고 이 스크립트를 다시 실행해주세요."
  exit 1
}

echo "=============================="
echo " AI Native Camp Codex Setup"
echo " Git Bash version"
echo "=============================="

add_windows_paths

step "1/4" "git"
if has_command git; then
  echo "  [OK] $(git --version)"
else
  install_winget_package "Git.Git" "git"
fi

step "2/4" "Node.js / npm"
if has_command node; then
  echo "  [OK] Node.js $(node --version)"
else
  install_winget_package "OpenJS.NodeJS.LTS" "Node.js LTS"
fi

add_windows_paths
echo "  [OK] npm $(run_npm --version)"

step "3/4" "Python"
if has_command python && python --version >/dev/null 2>&1; then
  echo "  [OK] Python $(python --version 2>&1)"
else
  install_winget_package "Python.Python.3.12" "Python"
fi

step "4/4" "Codex CLI"
if has_command codex; then
  echo "  [OK] Codex $(codex --version 2>&1)"
else
  echo "  [installing] Codex CLI ..."
  run_npm i -g @openai/codex@latest
  add_windows_paths

  if has_command codex; then
    echo "  [OK] Codex $(codex --version 2>&1)"
  else
    echo "Codex 설치는 끝났지만 codex 명령을 찾지 못했습니다."
    echo "Git Bash를 껐다가 다시 열고 'codex --version'을 실행해주세요."
    exit 1
  fi
fi

echo ""
echo "=============================="
echo " Codex setup complete!"
echo "=============================="
echo ""
echo "Next steps:"
echo "  1. Close and reopen Git Bash"
echo "  2. Type: codex"
echo "  3. Choose 'Sign in with ChatGPT'"
echo "  4. Login in the browser"
echo "  5. Post 'done' in Slack #ai-native-camp thread"
echo ""
