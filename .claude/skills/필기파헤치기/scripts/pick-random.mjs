#!/usr/bin/env node
// 로컬 problems.json에서 랜덤 1개 문제만 골라 출력한다.
// 1000개 전체를 Claude 컨텍스트에 올리지 않기 위한 선택 로직 (토큰 절약).
//
// 사용: node pick-random.mjs <problems.json 경로>
import fs from 'fs';

const file = process.argv[2];
if (!file) {
  console.error('사용: node pick-random.mjs <problems.json 경로>');
  process.exit(1);
}

let problems;
try {
  problems = JSON.parse(fs.readFileSync(file, 'utf-8'));
} catch (e) {
  console.error(`problems.json 읽기 실패: ${e.message}`);
  process.exit(1);
}

if (!Array.isArray(problems) || problems.length === 0) {
  console.error('problems.json이 비어있거나 배열이 아님');
  process.exit(1);
}

const idx = Math.floor(Math.random() * problems.length);
console.log(JSON.stringify(problems[idx], null, 2));
