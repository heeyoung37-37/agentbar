/* Presentation-only examples. No accounts, usage APIs, analytics, or storage. */
(() => {
  'use strict';
  const examples = Object.freeze({
    start: { codex: 100, claude: 100, label: '작업 시작' },
    flow: { codex: 62, claude: 97, label: '작업 중' },
    finish: { codex: 9, claude: 32, label: '마무리' },
  });
  const buttons = [...document.querySelectorAll('[data-scenario]')];
  const demo = document.getElementById('quota-demo');
  const description = document.getElementById('scenario-description');
  buttons.forEach(button => { button.disabled = false; });
  buttons.forEach(button => button.addEventListener('click', () => {
    const example = examples[button.dataset.scenario];
    if (!example) return;
    buttons.forEach(item => item.setAttribute('aria-pressed', String(item === button)));
    for (const provider of ['codex', 'claude']) {
      const value = document.getElementById(`${provider}-value`);
      value.replaceChildren(document.createTextNode(String(example[provider])));
      const percent = document.createElement('span');
      percent.textContent = '%';
      value.append(percent);
      document.getElementById(`${provider}-bar`).style.width = `${example[provider]}%`;
    }
    const summary = `Codex ${example.codex}%, Claude ${example.claude}% 남음`;
    demo.setAttribute('aria-label', `예시: ${summary}`);
    description.textContent = `${example.label} 예시 · ${summary}`;
  }));
  // A schematic of calendar slots, deliberately without money or token values.
  const heights = [12, 0, 24, 36, 18, 0, 31, 47, 65, 27, 0, 39, 53, 35, 76,
    48, 0, 22, 62, 45, 84, 57, 30, 0, 43, 71, 55, 88, 67, 40];
  const chart = document.querySelector('.calendar-chart');
  const bars = document.createDocumentFragment();
  heights.forEach((height, index) => {
    const bar = document.createElement('i');
    bar.style.setProperty('--height', `${height}%`);
    if (index < 2) bar.className = 'unknown';
    else if (height === 0) bar.className = 'zero';
    bars.append(bar);
  });
  chart.replaceChildren(bars);
})();
