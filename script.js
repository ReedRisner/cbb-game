const annualTimeline = [
  'Policy phase',
  'Coach carousel',
  'Roster churn I (graduation, draft, portal)',
  'NIL market opening',
  'Recruiting cycle',
  'Roster churn II (late portal movement)',
  'Development camp',
  'Schedule generation',
  'Season simulation',
  'Postseason tournaments',
  'Persistence and history snapshots',
];

const layers = [
  ['World', 'Conferences, policy rules, realignment, media economics.'],
  ['Program', 'Finances, prestige, facilities, staffing, fan climate.'],
  ['Roster', 'Players, recruits, transfers, NIL and eligibility.'],
  ['Game', 'Possession engine, tactics, clutch logic, variance.'],
  ['Narrative', 'Polls, bracketology, awards, records, legacy.'],
];

const milestones = [
  'M1: Data model + season loop + basic game simulation.',
  'M2: Recruiting, portal, NIL market, and coach carousel.',
  'M3: Rankings, bracketology, postseason, and records.',
  'M4: Long-term macro events and narrative engine.',
  'M5: Balancing tooling, telemetry dashboards, mod support.',
];

function renderTimeline() {
  const list = document.querySelector('.timeline');
  annualTimeline.forEach((label, index) => {
    const item = document.createElement('li');
    item.className = 'step';
    item.innerHTML = `<span class="num">${index + 1}</span><span>${label}</span>`;
    list.append(item);
  });
}

function renderLayers() {
  const root = document.getElementById('layers');
  layers.forEach(([name, detail]) => {
    const el = document.createElement('article');
    el.className = 'layer';
    el.innerHTML = `<h3>${name}</h3><p>${detail}</p>`;
    root.append(el);
  });
}

function renderMilestones() {
  const root = document.getElementById('milestones');
  milestones.forEach((text) => {
    const row = document.createElement('div');
    row.className = 'milestone';
    row.textContent = text;
    root.append(row);
  });
}

function calculateBudget(inputs) {
  return (
    Number(inputs.base.value) +
    Number(inputs.tickets.value) +
    Number(inputs.media.value) +
    Number(inputs.boosters.value) +
    Number(inputs.units.value) -
    Number(inputs.debt.value) -
    Number(inputs.staffing.value)
  );
}

function calculateTransferPressure(inputs) {
  return (
    0.3 * Number(inputs.minutes.value) +
    0.2 * Number(inputs.nil.value) +
    0.15 * Number(inputs.trust.value) +
    0.1 * Number(inputs.style.value) +
    0.1 * Number(inputs.losing.value) +
    0.1 * Number(inputs.academic.value) +
    0.05 * Number(inputs.peer.value)
  );
}

function setupModels() {
  const budgetRoot = document.querySelector('[data-model="budget"]');
  const budgetInputs = Object.fromEntries(new FormDataKeys(budgetRoot).entries());
  const budgetOutput = document.querySelector('[data-result="budget"]');

  const updateBudget = () => {
    budgetOutput.textContent = `Estimated Budget: $${calculateBudget(budgetInputs).toFixed(1)}M`;
  };

  Object.values(budgetInputs).forEach((input) => input.addEventListener('input', updateBudget));
  updateBudget();

  const transferRoot = document.querySelector('[data-model="transfer"]');
  const transferInputs = Object.fromEntries(new FormDataKeys(transferRoot).entries());
  const transferOutput = document.querySelector('[data-result="transfer"]');

  const updateTransfer = () => {
    const score = calculateTransferPressure(transferInputs);
    const risk = score >= 60 ? 'Very High' : score >= 45 ? 'High' : score >= 30 ? 'Moderate' : 'Low';
    transferOutput.textContent = `Pressure Score: ${score.toFixed(1)} / 100 (${risk} Risk)`;
  };

  Object.values(transferInputs).forEach((input) => input.addEventListener('input', updateTransfer));
  updateTransfer();
}

class FormDataKeys {
  constructor(root) {
    this.root = root;
  }

  entries() {
    const controls = this.root.querySelectorAll('input');
    return Array.from(controls).map((control) => [control.name, control]);
  }
}

renderTimeline();
renderLayers();
renderMilestones();
setupModels();
