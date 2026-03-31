# 운전선생 AI Native Camp - Windows 세팅 스크립트
# 실행: PowerShell 관리자 권한으로 열고 .\setup-windows.ps1

Write-Host "=============================="
Write-Host " 운전선생 AI Native Camp 세팅"
Write-Host "=============================="
Write-Host ""

# 1. git
Write-Host "[ 1/4 ] git 확인..."
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "  ✅ $(git --version)"
} else {
    Write-Host "  ⏳ git 설치 중..."
    winget install Git.Git --accept-package-agreements --accept-source-agreements
    Write-Host "  ✅ git 설치 완료"
}

# 2. Node.js
Write-Host "[ 2/4 ] Node.js 확인..."
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "  ✅ Node.js $(node --version)"
} else {
    Write-Host "  ⏳ Node.js 설치 중..."
    winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
    Write-Host "  ✅ Node.js 설치 완료"
}

# 3. Python
Write-Host "[ 3/4 ] Python 확인..."
if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "  ✅ Python $(python --version 2>&1)"
} else {
    Write-Host "  ⏳ Python 설치 중..."
    winget install Python.Python.3.12 --accept-package-agreements --accept-source-agreements
    Write-Host "  ✅ Python 설치 완료"
}

# 4. Claude Code
Write-Host "[ 4/4 ] Claude Code 확인..."
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "  ✅ Claude Code 설치됨"
} else {
    Write-Host "  ⏳ Claude Code 설치 중..."
    Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
    Write-Host "  ✅ Claude Code 설치 완료"
}

Write-Host ""
Write-Host "=============================="
Write-Host " 세팅 완료!"
Write-Host "=============================="
Write-Host ""
Write-Host "다음 단계:"
Write-Host "  1. PowerShell 껐다가 다시 열기"
Write-Host "  2. claude 입력 → 브라우저에서 로그인"
Write-Host "  3. 스크린샷을 슬랙 #ai-native 에 올리기"
Write-Host ""
