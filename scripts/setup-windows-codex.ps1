# 운전선생 AI Native Camp - Windows Codex 세팅 스크립트
# 실행: PowerShell 관리자 권한 권장, .\scripts\setup-windows-codex.ps1

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$ErrorActionPreference = "Stop"

function Write-Step {
    param(
        [string]$Label,
        [string]$Message
    )
    Write-Host ""
    Write-Host "[$Label] $Message"
}

function Refresh-Path {
    $machinePath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

function Test-Command {
    param([string]$Name)
    return $null -ne (Get-Command $Name -ErrorAction SilentlyContinue)
}

function Install-WingetPackage {
    param(
        [string]$Id,
        [string]$Name
    )

    if (-not (Test-Command "winget")) {
        throw "winget을 찾을 수 없습니다. Microsoft Store에서 'App Installer'를 업데이트한 뒤 다시 실행해주세요."
    }

    Write-Host "  [installing] $Name ..."
    winget install --id $Id --exact --accept-package-agreements --accept-source-agreements
    Refresh-Path
    Write-Host "  [OK] $Name installed"
}

Write-Host "=============================="
Write-Host " AI Native Camp Codex Setup"
Write-Host "=============================="

# 1. git
Write-Step "1/4" "git"
if (Test-Command "git") {
    Write-Host "  [OK] $(git --version)"
} else {
    Install-WingetPackage -Id "Git.Git" -Name "git"
}

# 2. Node.js + npm
Write-Step "2/4" "Node.js / npm"
if (Test-Command "node") {
    Write-Host "  [OK] Node.js $(node --version)"
} else {
    Install-WingetPackage -Id "OpenJS.NodeJS.LTS" -Name "Node.js LTS"
}

Refresh-Path
if (Test-Command "npm") {
    Write-Host "  [OK] npm $(npm --version)"
} else {
    throw "npm을 찾을 수 없습니다. PowerShell을 껐다가 다시 열고 이 스크립트를 다시 실행해주세요."
}

# npm global path is sometimes not visible until a new shell opens.
try {
    $npmPrefix = (npm prefix -g).Trim()
    if ($npmPrefix -and ($env:Path -notlike "*$npmPrefix*")) {
        $env:Path = "$npmPrefix;$env:Path"
    }
} catch {
    Write-Host "  [WARN] npm global path 확인을 건너뜁니다."
}

# 3. Python
Write-Step "3/4" "Python"
if (Test-Command "python") {
    Write-Host "  [OK] Python $(python --version 2>&1)"
} else {
    Install-WingetPackage -Id "Python.Python.3.12" -Name "Python"
}

# 4. Codex CLI
Write-Step "4/4" "Codex CLI"
if (Test-Command "codex") {
    Write-Host "  [OK] Codex $(codex --version 2>&1)"
} else {
    Write-Host "  [installing] Codex CLI ..."
    npm i -g @openai/codex@latest
    Refresh-Path

    try {
        $npmPrefix = (npm prefix -g).Trim()
        if ($npmPrefix -and ($env:Path -notlike "*$npmPrefix*")) {
            $env:Path = "$npmPrefix;$env:Path"
        }
    } catch {
        Write-Host "  [WARN] npm global path 확인을 건너뜁니다."
    }

    if (Test-Command "codex") {
        Write-Host "  [OK] Codex $(codex --version 2>&1)"
    } else {
        throw "Codex 설치는 끝났지만 codex 명령을 찾지 못했습니다. PowerShell을 껐다가 다시 열고 'codex --version'을 실행해주세요."
    }
}

Write-Host ""
Write-Host "=============================="
Write-Host " Codex setup complete!"
Write-Host "=============================="
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Close and reopen PowerShell"
Write-Host "  2. Type: codex"
Write-Host "  3. Choose 'Sign in with ChatGPT'"
Write-Host "  4. Login in the browser"
Write-Host "  5. Post 'done' in Slack #ai-native thread"
Write-Host ""
