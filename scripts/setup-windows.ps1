# Windows PowerShell 5.1+ / PowerShell 7. Run: .\scripts\setup-windows.ps1
$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT') { throw 'Run this script in Windows PowerShell. For WSL use setup-wsl.sh.' }
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$repoDir = Split-Path -Parent $PSScriptRoot

function Refresh-SetupPath {
    $parts = @(
        (Join-Path $env:USERPROFILE '.zeude\bin'),
        (Join-Path $env:USERPROFILE '.local\bin'),
        [Environment]::GetEnvironmentVariable('Path', 'User'),
        [Environment]::GetEnvironmentVariable('Path', 'Machine'),
        $env:Path
    )
    $env:Path = $parts -join ';'
}
function Test-SetupTool([string]$Name, [string[]]$VersionArgs = @('--version')) {
    $tool = Get-Command $Name -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $tool) { return $false }
    $version = & $tool.Source @VersionArgs 2>&1
    if ($LASTEXITCODE -ne 0) { return $false }
    Write-Host "[OK] $Name $version"
    return $true
}
function Install-SetupPackage([string]$Id) {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'Install or update App Installer in Microsoft Store, then rerun this script.'
    }
    & winget install --id $Id --exact --source winget --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) { throw "winget failed for $Id (exit $LASTEXITCODE). Reopen PowerShell and retry; ask #ai-native if it persists." }
    Refresh-SetupPath
}

Write-Host 'Driving Teacher - Windows setup (WSL optional)'
Refresh-SetupPath
foreach ($package in @(
    @{ Name = 'git'; Id = 'Git.Git' },
    @{ Name = 'node'; Id = 'OpenJS.NodeJS.LTS' },
    @{ Name = 'python'; Id = 'Python.Python.3.12' },
    @{ Name = 'gh'; Id = 'GitHub.cli' }
)) {
    if (-not (Test-SetupTool $package.Name)) { Install-SetupPackage $package.Id }
    if (-not (Test-SetupTool $package.Name)) { throw "$($package.Name) is unavailable. Close and reopen PowerShell, then rerun this script." }
}
# Claude Code on Windows uses Git Bash even when launched from PowerShell.
$gitExe = (Get-Command git -CommandType Application | Select-Object -First 1).Source
$gitRoot = Split-Path -Parent (Split-Path -Parent $gitExe)
$gitBash = Join-Path $gitRoot 'bin\bash.exe'
if (-not (Test-Path $gitBash)) {
    throw 'Git Bash was not found. Install Git for Windows with Bash, reopen PowerShell and retry.'
}
if (-not (Test-SetupTool 'claude')) {
    $installer = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + '.ps1')
    try {
        Invoke-WebRequest -Uri 'https://claude.ai/install.ps1' -OutFile $installer -UseBasicParsing
        & $installer
        if (-not $?) { throw 'Claude Code installer failed.' }
    } finally {
        Remove-Item $installer -ErrorAction SilentlyContinue
    }
    Refresh-SetupPath
}
if (-not (Test-SetupTool 'claude')) { throw 'Claude Code is unavailable. Reopen PowerShell and rerun this script.' }
Write-Host ''
Write-Host 'Setup complete. Configure the company CLIProxy in SETUP.md Step 4 before starting Claude.'
Write-Host 'Close and reopen PowerShell after configuring it, then run:'
Write-Host ('cd "' + $repoDir.Replace('`', '``').Replace('$', '`$').Replace('"', '`"') + '"')
Write-Host 'claude'
Write-Host 'Verify a Claude reply, then run /zeude-setup and /ai-onboarding.'
Write-Host 'Zeude credentials are configured separately by /zeude-setup.'
