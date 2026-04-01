/**
 * AI Native Camp 사전 설문 — Google Forms 자동 생성
 *
 * 사용법:
 * 1. https://script.google.com 접속
 * 2. 새 프로젝트 생성
 * 3. 이 코드를 붙여넣기
 * 4. createSurveyForm 함수 실행
 * 5. 로그에서 폼 URL 확인
 */
function createSurveyForm() {
  var form = FormApp.create('AI Native Camp 사전 설문');
  form.setDescription('캠프 시작 1주 전에 작성해주세요. 5분이면 됩니다.\n결과에 따라 캠프 내용을 조정합니다.');
  form.setIsQuiz(false);
  form.setAllowResponseEdits(true);

  // ── 섹션 1: AI 사용 현황 ──
  form.addSectionHeaderItem()
    .setTitle('1. AI 사용 현황');

  form.addMultipleChoiceItem()
    .setTitle('Q1. 현재 AI 도구를 업무에 사용하고 있나요?')
    .setChoiceValues([
      '전혀 안 씀',
      '가끔 씀 (주 1회 미만)',
      '자주 씀 (주 1회 이상)',
      '매일 씀'
    ])
    .setRequired(true);

  form.addCheckboxItem()
    .setTitle('Q2. 어떤 AI 도구를 쓰고 있나요? (복수 선택)')
    .setChoiceValues([
      'ChatGPT',
      'Claude (웹/앱)',
      'Claude Code (터미널)',
      'Cursor / Copilot',
      '안 씀'
    ])
    .setRequired(true);

  form.addCheckboxItem()
    .setTitle('Q3. AI로 주로 뭘 하나요? (복수 선택)')
    .setChoiceValues([
      '질문/검색',
      '문서/글 작성',
      '데이터 정리/분석',
      '코딩/개발',
      '기획/아이디어',
      '안 씀'
    ])
    .setRequired(true);

  // ── 섹션 2: 업무 인식 ──
  form.addSectionHeaderItem()
    .setTitle('2. 업무 인식');

  form.addCheckboxItem()
    .setTitle('Q4. 아래 중 해당되는 것이 있나요? (복수 선택)')
    .setChoiceValues([
      '수동으로 복붙해서 만드는 문서/보고서가 있다',
      '같은 내용을 여러 곳에 반복해서 입력한다',
      '형식만 바꿔서 반복하는 안내/메시지가 있다',
      '매번 비슷한 패턴의 질문에 답하고 있다',
      '정해진 양식을 채우는 데 시간이 오래 걸린다',
      '해당 없음'
    ])
    .setRequired(true);

  form.addParagraphTextItem()
    .setTitle('Q5. 반복적으로 하는 업무 중 가장 귀찮은 것 1개는?')
    .setRequired(true);

  form.addMultipleChoiceItem()
    .setTitle('Q6. AI로 직접 해본 것 중 가장 고도화된 것은?')
    .setChoiceValues([
      '아직 안 써봄',
      '간단한 질문/검색',
      '문서 초안이나 요약을 시켜봄',
      '데이터 정리/분석을 시켜봄',
      '반복 업무를 자동화해봄',
      'AI로 기획이나 의사결정을 해봄',
      'MCP, 스킬, 플러그인 등을 직접 만들어봄',
      'OpenClaw / Claude Code 에이전트를 운영해봄'
    ])
    .setRequired(true);

  // ── 섹션 3: 기대와 우려 ──
  form.addSectionHeaderItem()
    .setTitle('3. 기대와 우려');

  form.addMultipleChoiceItem()
    .setTitle('Q7. 이 캠프에서 가장 기대하는 것은?')
    .setChoiceValues([
      'AI 도구 사용법 배우기',
      '내 업무를 더 효율적으로 하기',
      '팀 전체의 일하는 방식 개선',
      '새로운 것 배우는 것 자체'
    ])
    .showOtherOption(true)
    .setRequired(true);

  form.addMultipleChoiceItem()
    .setTitle('Q8. 가장 걱정되는 것은?')
    .setChoiceValues([
      '어려울 것 같아서',
      '시간이 부족해서',
      '내 업무에 적용이 안 될 것 같아서',
      '걱정 없음'
    ])
    .showOtherOption(true)
    .setRequired(true);

  // ── 섹션 4: 터미널 경험 ──
  form.addSectionHeaderItem()
    .setTitle('4. 터미널 경험');

  form.addMultipleChoiceItem()
    .setTitle('Q9. 터미널(검은 화면에 글자 치는 것)을 써본 적 있나요?')
    .setChoiceValues([
      '뭔지 모름',
      '본 적은 있지만 써본 적 없음',
      '간단한 명령어는 써봄',
      '자주 씀'
    ])
    .setRequired(true);

  // ── 완료 ──
  form.setConfirmationMessage('감사합니다! 캠프에서 뵙겠습니다 🚗');

  Logger.log('폼 생성 완료!');
  Logger.log('편집 URL: ' + form.getEditUrl());
  Logger.log('응답 URL: ' + form.getPublishedUrl());
}
