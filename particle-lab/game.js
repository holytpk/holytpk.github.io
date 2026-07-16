(() => {
  const canvas = document.getElementById("detector");
  const ctx = canvas.getContext("2d");
  const energy = document.getElementById("energy");
  const lumi = document.getElementById("lumi");
  const energyOutput = document.getElementById("energyOutput");
  const lumiOutput = document.getElementById("lumiOutput");
  const collideButton = document.getElementById("collideButton");
  const autoButton = document.getElementById("autoButton");
  const resetButton = document.getElementById("resetButton");
  const eventNumber = document.getElementById("eventNumber");
  const triggerState = document.getElementById("triggerState");
  const runLabel = document.getElementById("runLabel");
  const objectiveText = document.getElementById("objectiveText");
  const eventLog = document.getElementById("eventLog");

  const metric = {
    events: document.getElementById("events"),
    tracks: document.getElementById("tracks"),
    photons: document.getElementById("photons"),
    jets: document.getElementById("jets"),
    met: document.getElementById("met"),
    score: document.getElementById("score")
  };

  const state = {
    events: 0,
    tracks: 0,
    photons: 0,
    jets: 0,
    met: 0,
    score: 0,
    run: 1,
    auto: null,
    discoveries: new Set(),
    particles: []
  };

  const colors = ["#8eeaff", "#ff8fc4", "#f1ca4a", "#ffffff", "#8fff9a"];

  function resizeCanvas() {
    const rect = canvas.getBoundingClientRect();
    const ratio = Math.max(1, window.devicePixelRatio || 1);
    canvas.width = rect.width * ratio;
    canvas.height = rect.height * ratio;
    ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
  }

  function drawDetector() {
    const w = canvas.clientWidth;
    const h = canvas.clientHeight;
    const cx = w / 2;
    const cy = h / 2;

    ctx.clearRect(0, 0, w, h);
    ctx.fillStyle = "#07090d";
    ctx.fillRect(0, 0, w, h);

    const maxR = Math.min(w, h) * .42;
    [1, .78, .57, .34].forEach((scale, index) => {
      ctx.beginPath();
      ctx.arc(cx, cy, maxR * scale, 0, Math.PI * 2);
      ctx.strokeStyle = index === 0 ? "rgba(241,202,74,.4)" : "rgba(142,234,255,.2)";
      ctx.lineWidth = index === 0 ? 3 : 2;
      ctx.stroke();
    });

    for (let i = 0; i < 24; i++) {
      const angle = i * Math.PI * 2 / 24;
      ctx.beginPath();
      ctx.moveTo(cx + Math.cos(angle) * maxR * .82, cy + Math.sin(angle) * maxR * .82);
      ctx.lineTo(cx + Math.cos(angle) * maxR, cy + Math.sin(angle) * maxR);
      ctx.strokeStyle = "rgba(255,255,255,.13)";
      ctx.lineWidth = 1;
      ctx.stroke();
    }

    state.particles.forEach(p => {
      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.lineTo(cx + Math.cos(p.angle) * p.length, cy + Math.sin(p.angle) * p.length);
      ctx.strokeStyle = p.color;
      ctx.globalAlpha = p.alpha;
      ctx.lineWidth = p.width;
      ctx.stroke();

      ctx.beginPath();
      ctx.arc(cx + Math.cos(p.angle) * p.length, cy + Math.sin(p.angle) * p.length, p.width + 1.5, 0, Math.PI * 2);
      ctx.fillStyle = p.color;
      ctx.fill();
    });

    ctx.globalAlpha = 1;
    ctx.beginPath();
    ctx.arc(cx, cy, 10, 0, Math.PI * 2);
    ctx.fillStyle = "#fff";
    ctx.shadowBlur = 18;
    ctx.shadowColor = "#fff";
    ctx.fill();
    ctx.shadowBlur = 0;
  }

  function addLog(label, message) {
    const article = document.createElement("article");
    article.innerHTML = `<time>${label}</time><p>${message}</p>`;
    eventLog.prepend(article);
    while (eventLog.children.length > 7) eventLog.lastElementChild.remove();
  }

  function discover(key, message) {
    if (state.discoveries.has(key)) return;
    state.discoveries.add(key);
    document.querySelector(`[data-key="${key}"]`)?.classList.add("found");
    objectiveText.textContent = `${state.discoveries.size} / 3 discovered`;
    addLog("DISCOVERY", message);

    if (state.discoveries.size === 3) {
      state.score += 5000;
      addLog("COMPLETE", "All target signatures identified. Analysis objective completed.");
    }
  }

  function generateEvent() {
    const e = Number(energy.value);
    const l = Number(lumi.value);
    const tracks = Math.floor(18 + Math.random() * e * 5);
    const photons = Math.random() < .36 ? Math.floor(1 + Math.random() * 3) : 0;
    const jets = Math.floor(1 + Math.random() * 7);
    const met = Math.floor(Math.random() * e * 14);
    const rareBoost = (e / 14) * (l / 300);

    state.events++;
    state.tracks += tracks;
    state.photons += photons;
    state.jets += jets;
    state.met = met;
    state.score += Math.floor(tracks * 2 + jets * 18 + photons * 45 + met);

    state.particles = Array.from({ length: Math.min(tracks, 70) }, () => ({
      angle: Math.random() * Math.PI * 2,
      length: 40 + Math.random() * Math.min(canvas.clientWidth, canvas.clientHeight) * .38,
      color: colors[Math.floor(Math.random() * colors.length)],
      width: .7 + Math.random() * 2.7,
      alpha: .45 + Math.random() * .55
    }));

    eventNumber.textContent = String(state.events).padStart(6, "0");
    triggerState.textContent = "ACCEPT";
    metric.events.textContent = state.events.toLocaleString();
    metric.tracks.textContent = state.tracks.toLocaleString();
    metric.photons.textContent = state.photons.toLocaleString();
    metric.jets.textContent = state.jets.toLocaleString();
    metric.met.textContent = `${met} GeV`;
    metric.score.textContent = state.score.toLocaleString();

    let summary = `${tracks} tracks, ${photons} photons, ${jets} jets, missing Eₜ ${met} GeV.`;

    if (photons >= 2 && Math.random() < .12 + rareBoost * .18) {
      discover("higgs", "A high-quality diphoton candidate entered the Higgs-like signal region.");
      summary += " Diphoton trigger fired.";
    }

    if (jets >= 5 && tracks > 45 && Math.random() < .11 + rareBoost * .16) {
      discover("top", "A boosted multijet event is compatible with a top-quark candidate.");
      summary += " Boosted-top tag passed.";
    }

    if (met > 120 && Math.random() < .2 + rareBoost * .18) {
      discover("dark", "Large missing transverse momentum suggests an invisible-particle signature.");
      summary += " Missing-energy trigger fired.";
    }

    addLog(`EVT ${String(state.events).padStart(6, "0")}`, summary);
    drawDetector();

    setTimeout(() => {
      triggerState.textContent = "STANDBY";
    }, 500);
  }

  function reset() {
    if (state.auto) {
      clearInterval(state.auto);
      state.auto = null;
      autoButton.textContent = "AUTO RUN";
    }

    state.events = 0;
    state.tracks = 0;
    state.photons = 0;
    state.jets = 0;
    state.met = 0;
    state.score = 0;
    state.run++;
    state.particles = [];
    state.discoveries.clear();

    runLabel.textContent = `RUN ${String(state.run).padStart(3, "0")}`;
    eventNumber.textContent = "000000";
    triggerState.textContent = "STANDBY";
    Object.values(metric).forEach((node, index) => {
      node.textContent = index === 4 ? "0 GeV" : "0";
    });
    document.querySelectorAll(".discoveries li").forEach(li => li.classList.remove("found"));
    objectiveText.textContent = "0 / 3 discovered";
    eventLog.innerHTML = "<article><time>READY</time><p>Detector systems reset. Begin a new run.</p></article>";
    drawDetector();
  }

  energy.addEventListener("input", () => {
    energyOutput.value = `${Number(energy.value).toFixed(1)} TeV`;
  });

  lumi.addEventListener("input", () => {
    lumiOutput.value = `${lumi.value} fb⁻¹`;
  });

  collideButton.addEventListener("click", generateEvent);

  autoButton.addEventListener("click", () => {
    if (state.auto) {
      clearInterval(state.auto);
      state.auto = null;
      autoButton.textContent = "AUTO RUN";
    } else {
      generateEvent();
      state.auto = setInterval(generateEvent, 850);
      autoButton.textContent = "STOP AUTO";
    }
  });

  resetButton.addEventListener("click", reset);
  window.addEventListener("resize", () => {
    resizeCanvas();
    drawDetector();
  });

  resizeCanvas();
  drawDetector();
})();
