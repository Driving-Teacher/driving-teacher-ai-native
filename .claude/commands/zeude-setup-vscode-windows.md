---
name: zeude-setup-vscode-windows
description: Windows에서 VSCode extension 으로 Claude Code 써도 Zeude 에 잡히게. PowerShell setx 로 OTEL env 영구 등록.
allowed-tools: Bash, Read, Write
---

Windows의 Zeude CLI는 공식 `install.ps1`로 설치할 수 있다. 먼저 `/zeude-setup` 또는 `docs/zeude-windows-setup.md`로 CLI 설치와 진단을 마친다. WSL 설치를 요구하지 않는다.

## VSCode 확장 검증

CLI shim 설치 성공이 VSCode 확장의 텔레메트리 수집 성공을 뜻하지는 않는다.

1. PowerShell에서 `Get-Command claude`와 `zeude doctor`를 확인한다.
2. VSCode를 완전히 종료하고 다시 열어 확장에서 새 세션을 시작한다.
3. Zeude 대시보드에서 해당 확장 세션이 수집되는지 확인한다.
4. 수집되지 않으면 현재 Windows CLI의 지원 명령과 공식 확장 연동 절차를 확인한다. 지원 여부를 확인하지 않은 env dump 명령을 추측해서 실행하지 않는다.

기존 문서의 수동 OTEL 환경변수 등록 예시는 구버전 shim 미지원 전제와 과거 endpoint를 사용하므로 제거했다. agent key·사용자 ID·이메일을 채팅으로 요청하거나 과거 endpoint를 재사용하지 않는다. 최신 확장 연동 절차를 확인할 수 없으면 `#ai-native`에 문의하고 확장 검증이 미완료임을 보고한다.

Windows와 WSL의 설정은 별개다. VSCode Remote-WSL은 WSL 쪽 설치를 검증한다.
