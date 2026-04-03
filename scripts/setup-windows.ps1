# 운전선생 AI Native Camp - Windows 세팅 스크립트
# 실행: PowerShell 관리자 권한으로 열고 .\setup-windows.ps1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=============================="
Write-Host " AI Native Camp Setup"
Write-Host "=============================="
Write-Host ""

# 1. git
Write-Host "[ 1/4 ] git ..."
if (Get-Command git -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] $(git --version)"
} else {
    Write-Host "  [installing] git ..."
    winget install Git.Git --accept-package-agreements --accept-source-agreements
    Write-Host "  [OK] git installed"
}

# 2. Node.js
Write-Host "[ 2/4 ] Node.js ..."
if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] Node.js $(node --version)"
} else {
    Write-Host "  [installing] Node.js ..."
    winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
    Write-Host "  [OK] Node.js installed"
}

# 3. Python
Write-Host "[ 3/4 ] Python ..."
if (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] Python $(python --version 2>&1)"
} else {
    Write-Host "  [installing] Python ..."
    winget install Python.Python.3.12 --accept-package-agreements --accept-source-agreements
    Write-Host "  [OK] Python installed"
}

# 4. Claude Code
Write-Host "[ 4/4 ] Claude Code ..."
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Write-Host "  [OK] Claude Code installed"
} else {
    Write-Host "  [installing] Claude Code ..."
    Invoke-RestMethod https://claude.ai/install.ps1 | Invoke-Expression
    Write-Host "  [OK] Claude Code installed"
}

Write-Host ""
Write-Host "=============================="
Write-Host " Setup complete!"
Write-Host "=============================="
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Close and reopen PowerShell"
Write-Host "  2. Type: claude"
Write-Host "  3. Login in the browser"
Write-Host "  4. Post 'done' in Slack #ai-native-camp thread"
Write-Host ""
