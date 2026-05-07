/**
 * AI Native Camp Week 4 자기효능감 설문 자동 생성
 *
 * 사용법:
 * 1. https://script.google.com → 새 프로젝트
 * 2. 이 코드 전체 복붙
 * 3. ▶ "createSurvey" 함수 실행
 * 4. 권한 승인 (Forms, Sheets, Triggers)
 * 5. 실행 로그(보기 → 로그)에서 응답 URL 확인
 * 6. 슬랙에 공유
 *
 * 자동 동작:
 * - 응답 시트 자동 생성 + 연결
 * - 2026-05-07 18:00 KST에 자동 마감 (trigger)
 */

const DEADLINE = new Date('2026-05-07T18:00:00+09:00');

function createSurvey() {
  const form = FormApp.create('AI Native Camp 4주차 자기효능감 설문 (익명)');

  form.setDescription(
    '4주간 캠프 수고하셨습니다 🙌\n' +
    '솔직한 답변 부탁드려요. 완전 익명으로 진행됩니다.\n\n' +
    '응답 마감: 2026-05-07 (목) 18:00 KST'
  );

  // 익명 설정
  form.setCollectEmail(false);
  form.setRequireLogin(false);
  form.setLimitOneResponsePerUser(false);
  form.setAllowResponseEdits(false);
  form.setShowLinkToRespondAgain(false);

  // Q1: 자신감
  form.addScaleItem()
    .setTitle('1. AI 도구로 내 업무를 처리할 수 있다는 자신감')
    .setBounds(1, 5)
    .setLabels('전혀 그렇지 않다', '매우 그렇다')
    .setRequired(true);

  // Q2: 해결 능력
  form.addScaleItem()
    .setTitle('2. 막혔을 때 스스로 해결 방법을 찾을 수 있다')
    .setBounds(1, 5)
    .setLabels('전혀 그렇지 않다', '매우 그렇다')
    .setRequired(true);

  // Q3: 학습 자신감
  form.addScaleItem()
    .setTitle('3. 새 도구가 나와도 배워서 쓸 자신이 있다')
    .setBounds(1, 5)
    .setLabels('전혀 그렇지 않다', '매우 그렇다')
    .setRequired(true);

  // Q4: 변화 (-2 ~ +2)
  const q4 = form.addMultipleChoiceItem();
  q4.setTitle('4. 4주 전과 비교해 자신감 변화')
    .setChoices([
      q4.createChoice('-2 (크게 줄었다)'),
      q4.createChoice('-1 (조금 줄었다)'),
      q4.createChoice('0 (변화 없다)'),
      q4.createChoice('+1 (조금 늘었다)'),
      q4.createChoice('+2 (크게 늘었다)'),
    ])
    .setRequired(true);

  // Q5: 최근 사용 빈도
  const q5 = form.addMultipleChoiceItem();
  q5.setTitle('5. 최근 1주일에 AI 도구로 일한 횟수')
    .setChoices([
      q5.createChoice('없음'),
      q5.createChoice('1–2회'),
      q5.createChoice('3–5회'),
      q5.createChoice('6회 이상'),
    ])
    .setRequired(true);

  // Q6: 지속 의향
  form.addScaleItem()
    .setTitle('6. 캠프가 끝나도 계속 쓸 것 같다')
    .setBounds(1, 5)
    .setLabels('전혀 그렇지 않다', '매우 그렇다')
    .setRequired(true);

  // Q7: 자유 텍스트
  form.addParagraphTextItem()
    .setTitle('7. (자유) 효능감이 가장 올라간 순간 / 막혔던 순간')
    .setHelpText('편하게 적어주세요. 완전 익명입니다.')
    .setRequired(false);

  // 응답 시트 생성 + 연결
  const ss = SpreadsheetApp.create('AI Native Camp 4주차 설문 응답');
  form.setDestination(FormApp.DestinationType.SPREADSHEET, ss.getId());

  // 자동 마감 trigger 등록
  PropertiesService.getScriptProperties().setProperty('FORM_ID', form.getId());

  // 기존 close trigger 정리
  ScriptApp.getProjectTriggers()
    .filter(t => t.getHandlerFunction() === 'closeFormAtDeadline')
    .forEach(t => ScriptApp.deleteTrigger(t));

  ScriptApp.newTrigger('closeFormAtDeadline')
    .timeBased()
    .at(DEADLINE)
    .create();

  // 결과 출력
  const editUrl = form.getEditUrl();
  const publishedUrl = form.getPublishedUrl();
  const shortUrl = form.shortenFormUrl(publishedUrl);
  const sheetUrl = ss.getUrl();

  Logger.log('===== ✅ 폼 생성 완료 =====');
  Logger.log('📝 편집 URL: ' + editUrl);
  Logger.log('🔗 응답 URL (이걸 공유): ' + publishedUrl);
  Logger.log('🔗 단축 URL: ' + shortUrl);
  Logger.log('📊 응답 시트: ' + sheetUrl);
  Logger.log('⏰ 자동 마감: 2026-05-07 18:00 KST');
  Logger.log('');
  Logger.log('슬랙 공유 메시지 예시:');
  Logger.log('---');
  Logger.log('📋 캠프 마무리 설문 (익명, 5분 이내)');
  Logger.log(shortUrl);
  Logger.log('마감: 내일(목) 18:00');
  Logger.log('---');
}

function closeFormAtDeadline() {
  const formId = PropertiesService.getScriptProperties().getProperty('FORM_ID');
  if (!formId) {
    Logger.log('FORM_ID 없음 — 마감 처리 스킵');
    return;
  }
  const form = FormApp.openById(formId);
  form.setAcceptingResponses(false);
  Logger.log('✅ 폼 마감 처리 완료: ' + form.getTitle());
}
