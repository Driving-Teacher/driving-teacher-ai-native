/* ============================================================
   AI Native 세션 공용 덱 조작 (←/→ · 클릭 · 스와이프)
   ------------------------------------------------------------
   deck.css 와 짝이다. 덱마다 복붙돼 있던 것을 한 군데로 뺐다.
   ============================================================ */
(function () {
  const deck = document.getElementById('deck');
  if (!deck) return;

  const slides = deck.querySelectorAll('.slide');
  if (!slides.length) return;

  const progress = document.getElementById('progress');
  const counter = document.getElementById('counter');
  let current = 0;

  function goTo(n) {
    if (n < 0 || n >= slides.length) return;

    slides[current].classList.remove('active');
    // reveal 애니메이션을 되감는다. offsetHeight 를 읽는 건 브라우저에게
    // "지금 다시 계산해" 라고 시키는 것 — 이게 없으면 재생이 안 된다.
    slides[current].querySelectorAll('.reveal').forEach((el) => {
      el.style.animation = 'none';
      void el.offsetHeight;
      el.style.animation = '';
      el.style.opacity = '0';
    });

    current = n;
    slides[current].classList.add('active');
    slides[current].scrollTop = 0;

    if (progress) {
      progress.style.width = slides.length > 1
        ? ((current / (slides.length - 1)) * 100) + '%'
        : '100%';
    }
    if (counter) counter.textContent = (current + 1) + ' / ' + slides.length;

    // 새로고침해도 보던 장으로 돌아오게. 발표 중 사고 대비.
    if (window.history && window.history.replaceState) {
      window.history.replaceState(null, '', '#' + (current + 1));
    }
  }

  document.addEventListener('keydown', (e) => {
    if (e.key === 'ArrowRight' || e.key === 'ArrowDown' || e.key === ' ') { e.preventDefault(); goTo(current + 1); }
    if (e.key === 'ArrowLeft' || e.key === 'ArrowUp') { e.preventDefault(); goTo(current - 1); }
    if (e.key === 'Home') goTo(0);
    if (e.key === 'End') goTo(slides.length - 1);
  });

  let touchStartX = 0;
  document.addEventListener('touchstart', (e) => { touchStartX = e.touches[0].clientX; }, { passive: true });
  document.addEventListener('touchend', (e) => {
    const diff = touchStartX - e.changedTouches[0].clientX;
    if (Math.abs(diff) > 50) { diff > 0 ? goTo(current + 1) : goTo(current - 1); }
  });

  deck.addEventListener('click', (e) => {
    // 링크와 스크롤 영역 안에서는 장 넘김을 막는다.
    if (e.target.closest('a')) return;
    if (e.clientX > window.innerWidth / 2) goTo(current + 1);
    else goTo(current - 1);
  });

  const start = parseInt((window.location.hash || '').replace('#', ''), 10);
  goTo(Number.isInteger(start) && start >= 1 && start <= slides.length ? start - 1 : 0);
})();
