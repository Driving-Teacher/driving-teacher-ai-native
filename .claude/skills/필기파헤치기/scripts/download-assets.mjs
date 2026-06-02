#!/usr/bin/env node
// 선택된 문제 1개의 시각 자산을 Ep 폴더에 다운로드한다 (락인 #14 이분법).
//   - media.problem URL 있음(공단 이미지 285개) → curl 다운로드
//   - 동영상형(Q{id}.mp4.json 존재, ID 966~1000) → ffmpeg로 Mux m3u8 → mp4 변환 + thumbnail 다운로드
//   - 그 외(문장형 680개) → 다운로드 없음. "AI 일러스트 프롬프트 필요" 신호만 출력 (이미지 생성 도구 미설치)
//
// 사용: node download-assets.mjs <problem.json 경로> <outDir> <frontend videos 디렉토리>
import fs from 'fs';
import path from 'path';
import { execFileSync } from 'child_process';

const [, , problemFile, outDir, videosDir] = process.argv;
if (!problemFile || !outDir || !videosDir) {
  console.error('사용: node download-assets.mjs <problem.json> <outDir> <videosDir>');
  process.exit(1);
}

const p = JSON.parse(fs.readFileSync(problemFile, 'utf-8'));
fs.mkdirSync(outDir, { recursive: true });

function sh(cmd, args) {
  execFileSync(cmd, args, { stdio: 'inherit' });
}

const media = Array.isArray(p.mediaProblem) ? p.mediaProblem : [];

if (media.length > 0) {
  // 공단 원본 이미지/미디어
  media.forEach((url, i) => {
    const ext = (url.split('?')[0].match(/\.(png|jpg|jpeg|webp|gif|mp4)$/i) || [, 'img'])[1];
    const out = path.join(outDir, `problem-media-${i + 1}.${ext}`);
    console.log(`⬇️  공단 원본 다운로드: ${out}`);
    sh('curl', ['-fsSL', url, '-o', out]);
  });
  console.log(`✅ 공단 원본 ${media.length}개 다운로드 완료 (Layer C = 원본)`);
} else {
  const mp4Json = path.join(videosDir, `Q${p.id}.mp4.json`);
  if (fs.existsSync(mp4Json)) {
    // 동영상형 → Mux
    const meta = JSON.parse(fs.readFileSync(mp4Json, 'utf-8'));
    const playbackId = meta?.providerMetadata?.mux?.playbackId;
    if (!playbackId) {
      console.error(`❌ ${mp4Json}에 playbackId 없음`);
      process.exit(1);
    }
    const m3u8 = `https://stream.mux.com/${playbackId}.m3u8`;
    const thumb = `https://image.mux.com/${playbackId}/thumbnail.webp`;
    const mp4Out = path.join(outDir, `problem-video.mp4`);
    const thumbOut = path.join(outDir, `problem-video-thumb.webp`);
    console.log(`⬇️  Mux 영상 변환(ffmpeg): ${mp4Out}`);
    sh('ffmpeg', ['-y', '-i', m3u8, '-c', 'copy', mp4Out]);
    console.log(`⬇️  Mux 썸네일: ${thumbOut}`);
    sh('curl', ['-fsSL', thumb, '-o', thumbOut]);
    console.log(`✅ 동영상형(Mux) mp4 + 썸네일 다운로드 완료 (Layer C = 원본)`);
  } else {
    // 문장형 → AI 일러스트 (자동 생성 도구 없음)
    console.log('ILLUSTRATION_NEEDED');
    console.log('문장형 문제 — 공단 원본 없음. Layer C = AI 일러스트.');
    console.log('이미지 생성 도구가 없으므로 스킬이 일러스트 생성 프롬프트를 대본과 함께 제공한다.');
  }
}
