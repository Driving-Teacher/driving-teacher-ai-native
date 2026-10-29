# Zeude Windows 설치·복구 (PowerShell)

Windows는 WSL 없이 설치할 수 있습니다. macOS·WSL은 기존 `install.sh`를 사용합니다.
공식 Windows 설치기: https://ulkqtmqspquxppywajsu.supabase.co/storage/v1/object/public/releases/install.ps1

## 사전 확인

- `SETUP.md`의 Windows 설치를 마치고 `claude --version`이 성공해야 합니다.
- PowerShell에서 실행합니다. Git Bash/CMD에서는 PowerShell을 열도록 안내합니다.
- Windows의 `$env:USERPROFILE\.zeude`와 WSL의 `~/.zeude`는 별도 설치입니다. 기존 WSL 설정을 옮기거나 지우지 않습니다.
- 실행 중인 Zeude 기반 Claude/Codex/Paseo 세션은 저장하고 닫은 뒤 설치합니다. 에이전트 자신이 shim으로 실행 중이면 사용자가 별도 PowerShell에서 설치하도록 안내합니다.

## 기존 설치부터 확인

```powershell
$zeudeRoot = Join-Path $env:USERPROFILE '.zeude'
$credentials = Join-Path $zeudeRoot 'credentials'
$zeudeExe = Join-Path $zeudeRoot 'bin\zeude.exe'
$agentKey = $null
if (Test-Path $credentials) {
    $keyLine = Get-Content $credentials | Where-Object { $_ -match '^agent_key=' } | Select-Object -First 1
    if ($keyLine) { $agentKey = $keyLine.Substring('agent_key='.Length).Trim() }
}
```

키와 credentials 내용은 출력하지 않습니다. 키가 있으면 아래 OTT 요청으로 유효성을 확인합니다. 네트워크 오류는 재시도하며 401/403일 때만 키 재발급을 안내합니다.

```powershell
$ott = Invoke-RestMethod -Method Post -Uri 'https://zeude.vercel.app/api/auth/ott' -ContentType 'application/json' -Body (@{agentKey=$agentKey} | ConvertTo-Json -Compress)
if (-not $ott.token) { throw 'Zeude authentication response has no token.' }
```

인증이 401/403으로 거절되면 `$agentKey = $null`로 비우고 새 키 입력 단계로 갑니다. 네트워크 오류일 때는 기존 키를 유지합니다.

키가 유효하고 실행 파일이 있으면 `& $zeudeExe doctor`를 실행하고 `$LASTEXITCODE`를 확인합니다. 진단이 성공하면 재설치 없이 아래 검증으로 갑니다.

## 필요한 경우에만 설치·복구

기존 키가 없거나 인증이 거절됐을 때만 초대 링크에서 새 키를 받도록 안내합니다. 키는 채팅 대신 사용자의 로컬 PowerShell에 입력합니다.

```powershell
if (-not $agentKey) {
    $secureKey = Read-Host 'Zeude agent key' -AsSecureString
    $agentKey = [Net.NetworkCredential]::new('', $secureKey).Password
}
if ($agentKey -notmatch '^zd_[A-Za-z0-9_-]+$') { throw 'Invalid Zeude agent key.' }
$installer = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + '.ps1')
try {
    Invoke-WebRequest -Uri 'https://ulkqtmqspquxppywajsu.supabase.co/storage/v1/object/public/releases/install.ps1' -OutFile $installer -UseBasicParsing -ErrorAction Stop
    & $installer -AgentKey $agentKey
    if (-not $?) { throw 'Zeude installer failed.' }
} finally {
    Remove-Item $installer -ErrorAction SilentlyContinue
    $agentKey = $null
    $secureKey = $null
}
```

실행 정책 오류가 나면 `Set-ExecutionPolicy -Scope Process RemoteSigned` 후 재시도합니다. 회사 관리 정책으로 차단되면 `#ai-native`에 문의합니다.

설치기는 Windows amd64/arm64를 감지하고 SHA256 검증 후 `claude.exe`·`zeude.exe`, 기존 Codex가 있으면 `codex.exe`도 설치합니다. 체크섬 불일치는 우회하지 않습니다. 다운로드 주소나 endpoint를 임의로 덮어쓰지 않습니다.

## 검증과 로그인

새 PowerShell을 열어 확인합니다.

```powershell
Get-Command claude | Select-Object Source
Get-Command zeude | Select-Object Source
zeude doctor
if ($LASTEXITCODE -ne 0) { throw 'Zeude doctor failed.' }
claude --version
```

- `claude`가 `$env:USERPROFILE\.zeude\bin\claude.exe`로 해석되어야 합니다. 다른 경로면 PATH 우선순위를 확인합니다.
- credentials와 shim/CLI 파일이 실제로 존재하는지 확인합니다.
- Claude를 새로 실행한 후 `$env:USERPROFILE\.claude\skills`와 `$env:USERPROFILE\.codex\skills`에 회사 공통 스킬이 내려왔는지 확인합니다. 설치기 자체는 스킬 파일을 복사하지 않으므로 바이너리 설치만으로 동기화 완료라고 보고하지 않습니다.
- 스킬이 내려오지 않으면 doctor 결과와 실행 경로를 확인하고 `#ai-native`에 문의합니다. WSL 재설치를 기본 해결책으로 안내하지 않습니다.
- 위 OTT 요청을 다시 수행하고 `Start-Process ('https://zeude.vercel.app/auth?ott=' + [Uri]::EscapeDataString($ott.token))`으로 대시보드를 엽니다. 키·OTT를 로그나 응답에 출력하지 않습니다.

**완료 기준:** doctor 성공, shim 경로·credentials·OTT 인증 확인, 양쪽 회사 스킬 동기화 확인, 대시보드 열기. Windows 실기 검증 없이 설치 완료라고 하지 않습니다.

VSCode 확장은 shim을 거치지 않을 수 있습니다. CLI 설치 성공만으로 확장 모니터링까지 완료라고 판단하지 말고 새 확장 세션의 대시보드 수신을 별도로 확인합니다.
