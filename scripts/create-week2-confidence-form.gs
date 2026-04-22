/**
 * AI Native Camp — Week 2 자신감 체크 폼 자동 생성
 *
 * 사용법:
 * 1. https://script.google.com 접속
 * 2. 새 프로젝트 생성
 * 3. 이 코드를 붙여넣기
 * 4. createWeek2ConfidenceForm 함수 실행
 * 5. 권한 허용
 * 6. 로그(Ctrl+Enter)에서 응답 URL 확인 → Slack에 공유
 */
function createWeek2ConfidenceForm() {
  var form = FormApp.create('AI Native Camp — Week 2 자신감 체크');
  form.setDescription('이번 주 수업을 통해 Claude Code와 얼마나 친해졌는지 가볍게 알려주세요.\n2분이면 됩니다. Week 3 첫 5분에 결과 함께 봅니다.');
  form.setIsQuiz(false);
  form.setAllowResponseEdits(true);
  form.setCollectEmail(false);

  // Q1. 친밀도
  form.addMultipleChoiceItem()
    .setTitle('Q1. Claude Code와 얼마나 친해졌나요?')
    .setHelpText('1주차 대비 얼마나 편해졌는지 솔직하게!')
    .setChoiceValues([
      '1 - 아직 낯설어요',
      '2 - 가끔 쓰는데 막혀요',
      '3 - 기본은 편해졌어요',
      '4 - 스킬도 만들어봤어요',
      '5 - 이미 일상이에요'
    ])
    .setRequired(true);

  // Q2. 제일 잘 쓰는 기능
  form.addCheckboxItem()
    .setTitle('Q2. 이번 주 제일 잘 쓰게 된 기능은? (복수 선택)')
    .setChoiceValues([
      'MCP (Notion·Slack 등 외부 연결)',
      'Skill (내 명령어 만들기)',
      'CLAUDE.md (매뉴얼)',
      'Plan mode',
      'Subagent / Task',
      '플러그인 설치 (awesome-skills 등)',
      '그냥 대화 (질문/요청하기)',
      '아직 뭐가 뭔지 모르겠어요'
    ])
    .setRequired(true);

  // Q3. 인상 깊었던 순간
  form.addParagraphTextItem()
    .setTitle('Q3. 이번 주 가장 인상 깊었던 순간 한 줄')
    .setHelpText('선택 (아무 에피소드나 좋아요)')
    .setRequired(false);

  // Q4. 아직 어려운 것
  form.addParagraphTextItem()
    .setTitle('Q4. 아직 어려운 것 한 줄')
    .setHelpText('선택 (Week 3에서 해결해볼게요)')
    .setRequired(false);

  // 완료 메시지
  form.setConfirmationMessage('감사합니다! Week 3에서 뵈어요 🚗');

  Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  Logger.log('폼 생성 완료!');
  Logger.log('편집 URL: ' + form.getEditUrl());
  Logger.log('응답 URL: ' + form.getPublishedUrl());
  Logger.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  Logger.log('→ 응답 URL을 복사해서 Slack에 공유하세요.');
}
