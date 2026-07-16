#!/usr/bin/env bash
set -euo pipefail

# holytpk.github.io one-command site builder
#
# Run this script from the root of your repository:
#   chmod +x build_holytpk_site.sh
#   ./build_holytpk_site.sh
#
# Expected optional source files in the repository root:
#   B6D5BE39-6344-48BD-9333-72A4103EE7B7.jpg
#   grok-video-8fe56bdf-b6b8-4f80-8b2d-b909c83d3f80.mp4
#
# Replace the placeholder files later with:
#   assets/crypto/btc.png
#   assets/crypto/eth.png
#   assets/crypto/solana.png
#   assets/crypto/monad.png
#   assets/crypto/bnb.png
#   assets/crypto/tron.png
#   assets/characters/unipeg.png
#
# The script intentionally creates SVG placeholders with those PNG-oriented
# paths referenced through <picture> fallbacks, so the page works immediately.

ROOT="$(pwd)"
STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$ROOT/backups/$STAMP"

echo "[1/8] Checking repository..."
if [[ ! -d "$ROOT/.git" ]]; then
  echo "WARNING: no .git directory found in $ROOT"
  echo "Continue only if this is the intended website directory."
fi

mkdir -p "$BACKUP_DIR"

for item in index.html site.css site.js particle-lab; do
  if [[ -e "$ROOT/$item" ]]; then
    cp -a "$ROOT/$item" "$BACKUP_DIR/"
  fi
done

echo "[2/8] Creating directories..."
mkdir -p \
  "$ROOT/assets/media" \
  "$ROOT/assets/crypto" \
  "$ROOT/assets/characters" \
  "$ROOT/assets/icons" \
  "$ROOT/particle-lab"

LOGO_SOURCE="B6D5BE39-6344-48BD-9333-72A4103EE7B7.jpg"
VIDEO_SOURCE="grok-video-8fe56bdf-b6b8-4f80-8b2d-b909c83d3f80.mp4"

if [[ -f "$ROOT/$LOGO_SOURCE" ]]; then
  cp -f "$ROOT/$LOGO_SOURCE" "$ROOT/assets/media/btfu-logo.jpg"
  echo "  copied $LOGO_SOURCE -> assets/media/btfu-logo.jpg"
else
  echo "  $LOGO_SOURCE not found; the generated fallback logo will be used."
fi

if [[ -f "$ROOT/$VIDEO_SOURCE" ]]; then
  cp -f "$ROOT/$VIDEO_SOURCE" "$ROOT/assets/media/intro.mp4"
  echo "  copied $VIDEO_SOURCE -> assets/media/intro.mp4"
else
  echo "  $VIDEO_SOURCE not found; the hero will use its static fallback."
fi

echo "[3/8] Writing placeholder artwork..."

make_coin_svg() {
  local file="$1"
  local ticker="$2"
  local subtitle="$3"
  cat > "$file" <<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="640" height="640" viewBox="0 0 640 640">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#171717"/>
      <stop offset="1" stop-color="#050505"/>
    </linearGradient>
    <filter id="glow">
      <feGaussianBlur stdDeviation="8" result="b"/>
      <feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge>
    </filter>
  </defs>
  <rect width="640" height="640" rx="72" fill="url(#bg)"/>
  <rect x="24" y="24" width="592" height="592" rx="56" fill="none" stroke="#f4cf54" stroke-width="8" stroke-dasharray="20 14"/>
  <circle cx="320" cy="278" r="164" fill="#f4cf54" opacity=".14"/>
  <circle cx="320" cy="278" r="144" fill="none" stroke="#f4cf54" stroke-width="18" filter="url(#glow)"/>
  <text x="320" y="326" text-anchor="middle" fill="#fff5c2" font-family="monospace" font-size="112" font-weight="900">${ticker}</text>
  <text x="320" y="500" text-anchor="middle" fill="#f4cf54" font-family="monospace" font-size="28">${subtitle}</text>
  <text x="320" y="550" text-anchor="middle" fill="#999" font-family="monospace" font-size="19">REPLACE WITH PNG LATER</text>
</svg>
SVG
}

make_coin_svg "$ROOT/assets/crypto/btc-placeholder.svg" "BTC" "BITCOIN"
make_coin_svg "$ROOT/assets/crypto/eth-placeholder.svg" "ETH" "ETHEREUM"
make_coin_svg "$ROOT/assets/crypto/solana-placeholder.svg" "SOL" "SOLANA"
make_coin_svg "$ROOT/assets/crypto/monad-placeholder.svg" "MON" "MONAD"
make_coin_svg "$ROOT/assets/crypto/bnb-placeholder.svg" "BNB" "BNB CHAIN"
make_coin_svg "$ROOT/assets/crypto/tron-placeholder.svg" "TRX" "TRON"

cat > "$ROOT/assets/characters/unipeg-placeholder.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="720" height="720" viewBox="0 0 720 720">
  <rect width="720" height="720" rx="80" fill="#0a0a0a"/>
  <g shape-rendering="crispEdges">
    <rect x="300" y="80" width="40" height="120" fill="#ffd95b"/>
    <rect x="340" y="40" width="40" height="160" fill="#fff3bc"/>
    <rect x="380" y="80" width="40" height="120" fill="#ffd95b"/>
    <rect x="240" y="200" width="240" height="40" fill="#fff"/>
    <rect x="200" y="240" width="320" height="40" fill="#fff"/>
    <rect x="160" y="280" width="400" height="120" fill="#fff"/>
    <rect x="200" y="400" width="320" height="80" fill="#fff"/>
    <rect x="240" y="480" width="240" height="80" fill="#fff"/>
    <rect x="280" y="560" width="64" height="80" fill="#fff"/>
    <rect x="376" y="560" width="64" height="80" fill="#fff"/>
    <rect x="200" y="280" width="80" height="80" fill="#ff8fc4"/>
    <rect x="440" y="280" width="80" height="80" fill="#ff8fc4"/>
    <rect x="280" y="300" width="40" height="40" fill="#111"/>
    <rect x="400" y="300" width="40" height="40" fill="#111"/>
    <rect x="320" y="380" width="80" height="40" fill="#f0b9cf"/>
    <rect x="120" y="240" width="80" height="40" fill="#ffe564"/>
    <rect x="80" y="200" width="80" height="40" fill="#8be9ff"/>
    <rect x="40" y="160" width="80" height="40" fill="#c69cff"/>
  </g>
  <text x="360" y="690" text-anchor="middle" fill="#f4cf54" font-family="monospace" font-size="24">UNIPEG PLACEHOLDER</text>
</svg>
SVG

cat > "$ROOT/assets/media/btfu-placeholder.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="1400" height="700" viewBox="0 0 1400 700">
  <rect width="1400" height="700" fill="#000"/>
  <text x="120" y="430" fill="#f5c844" font-family="Impact, sans-serif" font-size="300">₿</text>
  <text x="430" y="430" fill="#eee" font-family="Impact, sans-serif" font-size="270">TFU</text>
  <text x="700" y="570" text-anchor="middle" fill="#777" font-family="monospace" font-size="26">LOGO PLACEHOLDER</text>
</svg>
SVG

echo "[4/8] Writing index.html..."
cat > "$ROOT/index.html" <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="theme-color" content="#080808">
  <meta name="description" content="Particle physicist, scientific programmer, and crypto-native builder.">
  <title>HOLYTPK — Physics, Code & Crypto</title>
  <link rel="stylesheet" href="site.css">
</head>
<body>
  <div class="noise" aria-hidden="true"></div>
  <div class="ticker" aria-hidden="true">
    <div class="ticker-track">
      <span>PARTICLE PHYSICS</span><i>✦</i><span>SCIENTIFIC CODE</span><i>✦</i>
      <span>OPEN FINANCE</span><i>✦</i><span>ONCHAIN CULTURE</span><i>✦</i>
      <span>PARTICLE PHYSICS</span><i>✦</i><span>SCIENTIFIC CODE</span><i>✦</i>
      <span>OPEN FINANCE</span><i>✦</i><span>ONCHAIN CULTURE</span><i>✦</i>
    </div>
  </div>

  <header class="site-header">
    <a class="brand" href="#home" data-tab-link="home" aria-label="HOLYTPK home">
      <span class="brand-mark">H</span>
      <span>HOLYTPK</span>
    </a>

    <button class="menu-button" type="button" aria-expanded="false" aria-controls="site-nav">
      MENU
    </button>

    <nav id="site-nav" class="site-nav" aria-label="Main navigation">
      <button class="nav-link is-active" type="button" data-tab="home">HOME</button>
      <button class="nav-link" type="button" data-tab="physics">PHYSICS</button>
      <button class="nav-link" type="button" data-tab="code">CODE</button>
      <button class="nav-link" type="button" data-tab="crypto">CRYPTO</button>
      <a class="nav-link nav-link-external" href="particle-lab/">PARTICLE LAB ↗</a>
    </nav>
  </header>

  <main>
    <section class="tab-panel is-active" data-panel="home">
      <div class="hero">
        <div class="hero-copy">
          <div class="eyebrow">PHYSICIST × BUILDER × CRYPTO NATIVE</div>
          <h1>
            I STUDY THE
            <span class="outline">SMALLEST</span>
            THINGS—
            <span class="gold">AND BUILD</span>
            FOR BIGGER SYSTEMS.
          </h1>
          <p class="hero-lede">
            I am Lingqiang He, a particle-physics student working on top-quark
            measurements, spin correlations, and effective field theory while
            building reproducible scientific software and exploring open,
            programmable financial infrastructure.
          </p>
          <div class="hero-actions">
            <button class="pill primary" type="button" data-tab="physics">ENTER THE LAB</button>
            <button class="pill" type="button" data-tab="code">VIEW THE CODE</button>
          </div>
        </div>

        <div class="hero-media">
          <div class="media-frame">
            <video autoplay muted loop playsinline poster="assets/media/btfu-logo.jpg">
              <source src="assets/media/intro.mp4" type="video/mp4">
            </video>
            <img class="video-fallback" src="assets/media/btfu-logo.jpg"
                 onerror="this.src='assets/media/btfu-placeholder.svg'"
                 alt="BTFU logo">
            <div class="video-label">10 SEC / FIELD NOTE 001</div>
          </div>
          <img class="floating-unipeg" src="assets/characters/unipeg.png"
               onerror="this.onerror=null;this.src='assets/characters/unipeg-placeholder.svg'"
               alt="Pixel unipeg mascot">
        </div>
      </div>

      <section class="manifesto">
        <p class="section-kicker">THE PROFILE</p>
        <div class="manifesto-grid">
          <h2>FROM COLLIDER DATA<br>TO ONCHAIN DATA.</h2>
          <div>
            <p>
              My research asks how fundamental particles behave and whether
              subtle deviations reveal physics beyond the Standard Model.
            </p>
            <p>
              My coding work turns large datasets into defensible results:
              event selection, histogram pipelines, uncertainty propagation,
              χ² fits, visualization, and production automation.
            </p>
          </div>
        </div>
      </section>

      <section class="coin-cloud" aria-label="Crypto ecosystem artwork">
        <article class="coin-card tilt-left">
          <img src="assets/crypto/btc.png" onerror="this.onerror=null;this.src='assets/crypto/btc-placeholder.svg'" alt="Bitcoin">
          <span>HARD MONEY</span>
        </article>
        <article class="coin-card rise">
          <img src="assets/crypto/eth.png" onerror="this.onerror=null;this.src='assets/crypto/eth-placeholder.svg'" alt="Ethereum">
          <span>PROGRAMMABLE VALUE</span>
        </article>
        <article class="coin-card tilt-right">
          <img src="assets/crypto/solana.png" onerror="this.onerror=null;this.src='assets/crypto/solana-placeholder.svg'" alt="Solana">
          <span>FAST EXECUTION</span>
        </article>
        <article class="coin-card low">
          <img src="assets/crypto/monad.png" onerror="this.onerror=null;this.src='assets/crypto/monad-placeholder.svg'" alt="Monad">
          <span>PARALLEL EVM</span>
        </article>
        <article class="coin-card">
          <img src="assets/crypto/bnb.png" onerror="this.onerror=null;this.src='assets/crypto/bnb-placeholder.svg'" alt="BNB">
          <span>GLOBAL ACCESS</span>
        </article>
        <article class="coin-card tilt-left">
          <img src="assets/crypto/tron.png" onerror="this.onerror=null;this.src='assets/crypto/tron-placeholder.svg'" alt="Tron">
          <span>PAYMENT RAILS</span>
        </article>
      </section>
    </section>

    <section class="tab-panel" data-panel="physics" hidden>
      <div class="page-hero">
        <p class="section-kicker">01 / PARTICLE PHYSICS</p>
        <h2>READING THE UNIVERSE<br>ONE COLLISION AT A TIME.</h2>
        <p>
          My work centers on top-quark pair production, angular observables,
          spin-density information, and effective-field-theory interpretations.
        </p>
      </div>

      <div class="feature-grid">
        <article class="feature-card featured">
          <div class="feature-number">01</div>
          <h3>TOP-QUARK SPIN</h3>
          <p>
            Constructing and validating spin-correlation observables in multiple
            reference bases, from generator truth through analysis-level
            distributions.
          </p>
          <div class="pixel-orbit" aria-hidden="true"><i></i><i></i><i></i></div>
        </article>
        <article class="feature-card">
          <div class="feature-number">02</div>
          <h3>SMEFT</h3>
          <p>
            Comparing Wilson-coefficient points, conventions, interference
            patterns, LO/NLO predictions, and fit behavior.
          </p>
        </article>
        <article class="feature-card">
          <div class="feature-number">03</div>
          <h3>COLLIDER PIPELINES</h3>
          <p>
            NanoGEN production, ROOT and coffea workflows, covariance-aware
            comparisons, batch systems, and reproducibility checks.
          </p>
        </article>
      </div>

      <div class="statement-strip">
        <span>MEASURE</span><b>→</b><span>VALIDATE</span><b>→</b>
        <span>INTERPRET</span><b>→</b><span>REPEAT</span>
      </div>
    </section>

    <section class="tab-panel" data-panel="code" hidden>
      <div class="page-hero">
        <p class="section-kicker">02 / CODING PROFILE</p>
        <h2>CODE THAT SURVIVES<br>THE FULL ANALYSIS CHAIN.</h2>
        <p>
          I focus on transparent, inspectable tools for scientific computing,
          production, validation, visualization, and statistical inference.
        </p>
      </div>

      <div class="terminal-window">
        <div class="terminal-bar">
          <span></span><span></span><span></span>
          <b>lingqiang@analysis:~/profile</b>
        </div>
        <pre><code><span class="prompt">$</span> whoami
Lingqiang He — particle physics student & scientific programmer

<span class="prompt">$</span> stack --list
Python / C++ / ROOT / uproot / awkward / coffea
Bash / Git / Slurm / HTCondor / CRAB / CMSSW
NumPy / SciPy / matplotlib / LaTeX

<span class="prompt">$</span> interests
spin correlations
effective field theory
statistical fits
distributed production
reproducible research
crypto protocols

<span class="prompt">$</span> philosophy
"Make every transformation visible.
 Make every convention testable.
 Make every result reproducible."</code></pre>
      </div>

      <div class="skill-marquee">
        <div>
          <span>PYTHON</span><span>ROOT</span><span>COFFEA</span><span>CMSSW</span>
          <span>C++</span><span>BASH</span><span>GIT</span><span>LATEX</span>
          <span>PYTHON</span><span>ROOT</span><span>COFFEA</span><span>CMSSW</span>
        </div>
      </div>
    </section>

    <section class="tab-panel" data-panel="crypto" hidden>
      <div class="page-hero">
        <p class="section-kicker">03 / WHY CRYPTO</p>
        <h2>FINANCE SHOULD BE<br>OPEN, COMPOSABLE & VERIFIABLE.</h2>
        <p>
          Crypto is not a universal replacement for every financial service.
          It is a new settlement and coordination layer whose strongest
          properties can improve systems that are closed, slow, fragmented,
          or difficult to audit.
        </p>
      </div>

      <div class="reason-grid">
        <article>
          <span>01</span>
          <h3>OPEN ACCESS</h3>
          <p>
            Internet-native wallets can lower account and geographic barriers,
            although interfaces, regulation, and connectivity still matter.
          </p>
        </article>
        <article>
          <span>02</span>
          <h3>24/7 SETTLEMENT</h3>
          <p>
            Public networks can move and settle assets outside conventional
            banking hours without waiting for multiple reconciliations.
          </p>
        </article>
        <article>
          <span>03</span>
          <h3>PROGRAMMABILITY</h3>
          <p>
            Smart contracts let money, ownership, and agreements interact
            directly with software instead of relying entirely on manual layers.
          </p>
        </article>
        <article>
          <span>04</span>
          <h3>VERIFIABILITY</h3>
          <p>
            Shared ledgers make many balances and transactions independently
            inspectable, while privacy and offchain claims still require care.
          </p>
        </article>
        <article>
          <span>05</span>
          <h3>PORTABILITY</h3>
          <p>
            Users can carry assets and identity between compatible applications
            rather than remaining locked inside one institution.
          </p>
        </article>
        <article>
          <span>06</span>
          <h3>COMPETITION</h3>
          <p>
            Open protocols let new products build on existing liquidity and
            infrastructure, reducing some barriers to experimentation.
          </p>
        </article>
      </div>

      <div class="risk-box">
        <div>
          <p class="section-kicker">REALITY CHECK</p>
          <h3>MIGRATE PROPERTIES,<br>NOT BLINDLY.</h3>
        </div>
        <p>
          Crypto also introduces volatility, smart-contract exploits, custody
          risk, scams, governance tradeoffs, regulatory uncertainty, and
          irreversible mistakes. Adoption should be deliberate and matched to
          the use case—not driven by slogans.
        </p>
      </div>
    </section>
  </main>

  <footer>
    <div>
      <strong>HOLYTPK</strong>
      <span>PARTICLE PHYSICS / CODE / CRYPTO</span>
    </div>
    <div class="footer-links">
      <a href="https://github.com/holytpk" rel="noreferrer">GITHUB ↗</a>
      <a href="particle-lab/">PARTICLE LAB ↗</a>
      <a href="#home" data-tab-link="home">BACK TO TOP ↑</a>
    </div>
    <small>© <span id="year"></span> Lingqiang He. Not financial advice.</small>
  </footer>

  <script src="site.js"></script>
</body>
</html>
HTML

echo "[5/8] Writing site.css..."
cat > "$ROOT/site.css" <<'CSS'
:root {
  --bg: #080808;
  --panel: #111;
  --panel-2: #171717;
  --ink: #f7f2df;
  --muted: #a8a397;
  --gold: #f1ca4a;
  --gold-2: #ffe98c;
  --pink: #ff93c7;
  --blue: #8eeaff;
  --line: rgba(255,255,255,.14);
  --radius: 28px;
  --shadow: 0 26px 80px rgba(0,0,0,.45);
}

* { box-sizing: border-box; }
html { scroll-behavior: smooth; }
body {
  margin: 0;
  color: var(--ink);
  background:
    radial-gradient(circle at 15% 15%, rgba(241,202,74,.09), transparent 28rem),
    radial-gradient(circle at 85% 30%, rgba(255,147,199,.06), transparent 26rem),
    var(--bg);
  font-family: Arial, Helvetica, sans-serif;
  overflow-x: hidden;
}
button, a { font: inherit; }
button { color: inherit; }
a { color: inherit; text-decoration: none; }
img, video { display: block; max-width: 100%; }
.noise {
  position: fixed; inset: 0; pointer-events: none; z-index: 100;
  opacity: .035;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 180 180' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='.55'/%3E%3C/svg%3E");
}
.ticker {
  overflow: hidden;
  border-bottom: 1px solid var(--line);
  background: var(--gold);
  color: #090909;
  font-weight: 900;
  letter-spacing: .11em;
  font-size: .72rem;
}
.ticker-track {
  width: max-content;
  display: flex;
  align-items: center;
  gap: 22px;
  padding: 9px 0;
  animation: ticker 30s linear infinite;
}
.ticker i { font-style: normal; }
@keyframes ticker { to { transform: translateX(-50%); } }

.site-header {
  width: min(1480px, calc(100% - 40px));
  margin: 0 auto;
  min-height: 88px;
  display: flex; align-items: center; justify-content: space-between;
  gap: 24px;
}
.brand { display: inline-flex; align-items: center; gap: 10px; font-weight: 1000; letter-spacing: -.04em; }
.brand-mark {
  width: 38px; height: 38px; display: grid; place-items: center;
  background: var(--gold); color: #050505; border-radius: 11px;
  transform: rotate(-8deg);
}
.site-nav { display: flex; align-items: center; gap: 8px; }
.nav-link, .menu-button {
  border: 1px solid transparent; background: transparent;
  border-radius: 999px; padding: 11px 15px; cursor: pointer;
  font-size: .78rem; font-weight: 900; letter-spacing: .08em;
}
.nav-link:hover, .nav-link.is-active {
  border-color: var(--line); background: rgba(255,255,255,.06);
}
.nav-link-external { background: var(--ink); color: #080808; }
.menu-button { display: none; border-color: var(--line); }

main { min-height: 70vh; }
.tab-panel {
  width: min(1480px, calc(100% - 40px));
  margin: 0 auto;
  opacity: 0;
  transform: translateY(16px);
}
.tab-panel.is-active {
  animation: panelIn .55s cubic-bezier(.2,.75,.2,1) forwards;
}
@keyframes panelIn { to { opacity: 1; transform: none; } }

.hero {
  min-height: calc(100vh - 132px);
  display: grid;
  grid-template-columns: 1.15fr .85fr;
  gap: clamp(30px, 6vw, 100px);
  align-items: center;
  padding: 55px 0 95px;
}
.eyebrow, .section-kicker {
  color: var(--gold);
  font-size: .74rem; font-weight: 950; letter-spacing: .18em;
}
.hero h1, .page-hero h2, .manifesto h2 {
  margin: 20px 0 24px;
  font-size: clamp(3.6rem, 7.7vw, 9.4rem);
  line-height: .82;
  letter-spacing: -.075em;
  font-weight: 1000;
}
.hero h1 span { display: inline-block; }
.outline { color: transparent; -webkit-text-stroke: 2px var(--ink); }
.gold { color: var(--gold); }
.hero-lede {
  width: min(720px, 100%); color: var(--muted);
  font-size: clamp(1.05rem, 1.4vw, 1.35rem); line-height: 1.58;
}
.hero-actions { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 34px; }
.pill {
  border: 1px solid var(--line); background: #141414;
  border-radius: 999px; padding: 16px 22px; cursor: pointer;
  font-weight: 950; letter-spacing: .06em; font-size: .8rem;
  box-shadow: 0 8px 0 rgba(0,0,0,.22);
  transition: transform .2s, background .2s;
}
.pill:hover { transform: translateY(-3px) rotate(-1deg); }
.pill.primary { background: var(--gold); color: #080808; border-color: var(--gold); }
.hero-media { position: relative; }
.media-frame {
  position: relative; overflow: hidden;
  aspect-ratio: .82;
  border-radius: 46% 46% 28px 28px;
  border: 1px solid var(--line);
  background: #000;
  box-shadow: var(--shadow);
  transform: rotate(2deg);
}
.media-frame video, .media-frame .video-fallback {
  width: 100%; height: 100%; object-fit: cover;
}
.media-frame video + .video-fallback { display: none; }
.video-label {
  position: absolute; left: 20px; bottom: 20px;
  padding: 10px 14px; background: var(--gold); color: #080808;
  border-radius: 999px; font-size: .68rem; font-weight: 950; letter-spacing: .1em;
}
.floating-unipeg {
  position: absolute; width: 36%; right: -11%; bottom: -6%;
  image-rendering: pixelated;
  filter: drop-shadow(0 22px 25px rgba(0,0,0,.55));
  animation: bob 3.5s ease-in-out infinite;
}
@keyframes bob { 50% { transform: translateY(-16px) rotate(2deg); } }

.manifesto {
  padding: 110px 0;
  border-top: 1px solid var(--line);
}
.manifesto-grid { display: grid; grid-template-columns: 1.1fr .9fr; gap: 70px; align-items: end; }
.manifesto h2 { font-size: clamp(3.2rem, 6.3vw, 7rem); }
.manifesto-grid p { color: var(--muted); font-size: 1.18rem; line-height: 1.65; }

.coin-cloud {
  display: grid; grid-template-columns: repeat(6, 1fr);
  gap: 18px; padding: 15px 0 130px;
}
.coin-card {
  padding: 12px; border-radius: 24px;
  background: var(--panel); border: 1px solid var(--line);
  box-shadow: var(--shadow); transition: transform .25s;
}
.coin-card:hover { transform: translateY(-12px) rotate(0); }
.coin-card img { width: 100%; border-radius: 17px; aspect-ratio: 1; object-fit: cover; }
.coin-card span {
  display: block; padding: 14px 7px 8px; color: var(--gold);
  font-size: .65rem; font-weight: 950; letter-spacing: .08em;
}
.tilt-left { transform: rotate(-3deg); }
.tilt-right { transform: rotate(3deg); }
.rise { transform: translateY(-34px) rotate(2deg); }
.low { transform: translateY(30px) rotate(-2deg); }

.page-hero { max-width: 1100px; padding: 100px 0 75px; }
.page-hero h2 { font-size: clamp(4rem, 7vw, 8.5rem); }
.page-hero > p:last-child { max-width: 790px; color: var(--muted); font-size: 1.24rem; line-height: 1.6; }

.feature-grid { display: grid; grid-template-columns: 1.3fr 1fr 1fr; gap: 18px; padding-bottom: 85px; }
.feature-card, .reason-grid article {
  min-height: 340px; padding: 30px; border: 1px solid var(--line);
  border-radius: var(--radius); background: var(--panel); position: relative; overflow: hidden;
}
.feature-card.featured { background: var(--gold); color: #080808; }
.feature-number { font-weight: 950; opacity: .65; }
.feature-card h3, .reason-grid h3, .risk-box h3 {
  font-size: clamp(1.7rem, 2.6vw, 3.2rem); line-height: .95; letter-spacing: -.055em;
}
.feature-card p, .reason-grid p { color: inherit; opacity: .72; line-height: 1.55; }
.pixel-orbit i {
  position: absolute; width: 30px; height: 30px; background: #080808;
  image-rendering: pixelated;
}
.pixel-orbit i:nth-child(1) { right: 60px; bottom: 80px; }
.pixel-orbit i:nth-child(2) { right: 110px; bottom: 40px; width: 18px; height: 18px; }
.pixel-orbit i:nth-child(3) { right: 30px; bottom: 25px; width: 12px; height: 12px; }
.statement-strip {
  margin-bottom: 120px; border-block: 1px solid var(--line);
  padding: 28px 0; display: flex; justify-content: space-between; gap: 16px;
  font-weight: 1000; font-size: clamp(1rem, 2vw, 2rem);
}
.statement-strip b { color: var(--gold); }

.terminal-window {
  border: 1px solid var(--line); background: #030303; border-radius: var(--radius);
  overflow: hidden; box-shadow: var(--shadow); margin-bottom: 70px;
}
.terminal-bar { height: 54px; background: #171717; display: flex; align-items: center; gap: 8px; padding: 0 18px; }
.terminal-bar span { width: 12px; height: 12px; border-radius: 50%; background: #777; }
.terminal-bar span:first-child { background: #ff6868; }
.terminal-bar span:nth-child(2) { background: #ffd35e; }
.terminal-bar span:nth-child(3) { background: #6edd83; }
.terminal-bar b { margin-left: 10px; color: #aaa; font: 600 .75rem monospace; }
pre { margin: 0; padding: clamp(24px, 5vw, 70px); overflow-x: auto; }
code { font: 500 clamp(.83rem, 1.35vw, 1.1rem)/1.75 monospace; color: #d8d8d8; }
.prompt { color: var(--gold); font-weight: 900; }

.skill-marquee { overflow: hidden; margin-bottom: 120px; border-block: 1px solid var(--line); }
.skill-marquee div {
  width: max-content; display: flex; gap: 40px; padding: 24px 0;
  animation: ticker 25s linear infinite;
}
.skill-marquee span { color: var(--gold); font-size: 1.2rem; font-weight: 1000; letter-spacing: .1em; }

.reason-grid {
  display: grid; grid-template-columns: repeat(3, 1fr); gap: 18px;
  padding-bottom: 35px;
}
.reason-grid article { min-height: 285px; }
.reason-grid article > span { color: var(--gold); font-weight: 950; }
.reason-grid h3 { font-size: 2.1rem; }
.risk-box {
  margin: 0 0 120px; padding: clamp(28px, 5vw, 68px);
  display: grid; grid-template-columns: 1fr 1fr; gap: 50px;
  align-items: center; background: var(--gold); color: #080808; border-radius: var(--radius);
  transform: rotate(-.5deg);
}
.risk-box p:last-child { font-size: 1.08rem; line-height: 1.6; }

footer {
  width: min(1480px, calc(100% - 40px));
  margin: 0 auto; padding: 45px 0 50px; border-top: 1px solid var(--line);
  display: grid; grid-template-columns: 1fr auto; gap: 24px;
}
footer strong { display: block; font-size: 1.8rem; }
footer span, footer small { color: var(--muted); }
.footer-links { display: flex; gap: 18px; font-weight: 900; font-size: .78rem; }
footer small { grid-column: 1 / -1; }

@media (max-width: 1050px) {
  .hero { grid-template-columns: 1fr; }
  .hero-media { width: min(620px, 92%); margin: 0 auto; }
  .media-frame { aspect-ratio: 1.08; border-radius: 40px; }
  .coin-cloud { grid-template-columns: repeat(3, 1fr); }
  .feature-grid, .reason-grid { grid-template-columns: 1fr 1fr; }
  .feature-card.featured { grid-column: 1 / -1; }
}
@media (max-width: 760px) {
  .site-header { min-height: 72px; }
  .menu-button { display: block; }
  .site-nav {
    display: none; position: absolute; left: 20px; right: 20px; top: 105px;
    z-index: 20; padding: 14px; flex-direction: column; align-items: stretch;
    background: #111; border: 1px solid var(--line); border-radius: 22px;
    box-shadow: var(--shadow);
  }
  .site-nav.is-open { display: flex; }
  .nav-link { text-align: left; }
  .hero { padding-top: 38px; }
  .hero h1 { font-size: clamp(3.2rem, 17vw, 5.6rem); }
  .manifesto-grid, .risk-box { grid-template-columns: 1fr; gap: 20px; }
  .coin-cloud { grid-template-columns: 1fr 1fr; }
  .rise, .low { transform: none; }
  .feature-grid, .reason-grid { grid-template-columns: 1fr; }
  .feature-card.featured { grid-column: auto; }
  .statement-strip { flex-wrap: wrap; }
  footer { grid-template-columns: 1fr; }
  .footer-links { flex-wrap: wrap; }
}
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after { animation-duration: .001ms !important; animation-iteration-count: 1 !important; scroll-behavior: auto !important; }
}
CSS

echo "[6/8] Writing site.js..."
cat > "$ROOT/site.js" <<'JS'
(() => {
  const panelSelector = ".tab-panel";
  const buttons = [...document.querySelectorAll("[data-tab]")];
  const links = [...document.querySelectorAll("[data-tab-link]")];
  const menu = document.querySelector(".site-nav");
  const menuButton = document.querySelector(".menu-button");
  let active = "home";
  let switching = false;

  function getPanel(name) {
    return document.querySelector(`${panelSelector}[data-panel="${name}"]`);
  }

  function activate(name, updateHash = true) {
    if (switching || name === active || !getPanel(name)) {
      if (name === active) window.scrollTo({ top: 0, behavior: "smooth" });
      return;
    }

    switching = true;
    const oldPanel = getPanel(active);
    const newPanel = getPanel(name);

    oldPanel.style.transition = "opacity .22s ease, transform .22s ease";
    oldPanel.style.opacity = "0";
    oldPanel.style.transform = "translateY(-10px)";

    window.setTimeout(() => {
      oldPanel.hidden = true;
      oldPanel.classList.remove("is-active");
      oldPanel.removeAttribute("style");

      newPanel.hidden = false;
      requestAnimationFrame(() => newPanel.classList.add("is-active"));

      active = name;
      buttons.forEach(btn => btn.classList.toggle("is-active", btn.dataset.tab === name));

      if (updateHash) history.replaceState(null, "", `#${name}`);
      window.scrollTo({ top: 0, behavior: "smooth" });
      menu?.classList.remove("is-open");
      menuButton?.setAttribute("aria-expanded", "false");

      window.setTimeout(() => { switching = false; }, 560);
    }, 220);
  }

  buttons.forEach(button => {
    button.addEventListener("click", () => activate(button.dataset.tab));
  });

  links.forEach(link => {
    link.addEventListener("click", event => {
      event.preventDefault();
      activate(link.dataset.tabLink);
    });
  });

  menuButton?.addEventListener("click", () => {
    const isOpen = menu.classList.toggle("is-open");
    menuButton.setAttribute("aria-expanded", String(isOpen));
  });

  const initial = location.hash.slice(1);
  if (initial && getPanel(initial)) {
    const home = getPanel("home");
    home.hidden = true;
    home.classList.remove("is-active");
    const target = getPanel(initial);
    target.hidden = false;
    target.classList.add("is-active");
    active = initial;
    buttons.forEach(btn => btn.classList.toggle("is-active", btn.dataset.tab === initial));
  }

  document.getElementById("year").textContent = new Date().getFullYear();

  const video = document.querySelector(".media-frame video");
  const fallback = document.querySelector(".video-fallback");
  if (video && fallback) {
    video.addEventListener("error", () => {
      video.style.display = "none";
      fallback.style.display = "block";
    });
  }
})();
JS

echo "[7/8] Writing particle-lab placeholder..."
cat > "$ROOT/particle-lab/index.html" <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Particle Lab — HOLYTPK</title>
  <style>
    *{box-sizing:border-box}body{margin:0;min-height:100vh;display:grid;place-items:center;background:#080808;color:#f7f2df;font-family:Arial,sans-serif}
    main{width:min(850px,calc(100% - 36px));padding:50px;border:1px solid #333;border-radius:28px;background:#121212}
    small{color:#f1ca4a;font-weight:900;letter-spacing:.15em}h1{font-size:clamp(3rem,10vw,7rem);line-height:.85;letter-spacing:-.07em;margin:.3em 0}
    p{color:#aaa;font-size:1.15rem;line-height:1.6}a{display:inline-block;margin-top:20px;padding:14px 20px;border-radius:999px;background:#f1ca4a;color:#080808;text-decoration:none;font-weight:900}
  </style>
</head>
<body>
  <main>
    <small>SEPARATE EXPERIMENT</small>
    <h1>PARTICLE<br>LAB</h1>
    <p>
      Place the files for your existing particle-lab game in this directory.
      Keeping it here prevents the game from dominating the portfolio homepage.
    </p>
    <a href="../">← BACK TO PORTFOLIO</a>
  </main>
</body>
</html>
HTML

cat > "$ROOT/ASSET_REPLACEMENT_GUIDE.txt" <<'TXT'
Replace these files whenever your final artwork is ready:

assets/crypto/btc.png
assets/crypto/eth.png
assets/crypto/solana.png
assets/crypto/monad.png
assets/crypto/bnb.png
assets/crypto/tron.png
assets/characters/unipeg.png

Optional already-integrated media:
assets/media/btfu-logo.jpg
assets/media/intro.mp4

Recommended image format:
- PNG or WebP
- square crypto images, ideally 800x800 or larger
- transparent PNG for unipeg
- keep the exact filenames above

The page automatically falls back to the generated SVG placeholders when a
PNG is absent.
TXT

echo "[8/8] Finished."
echo
echo "Backup: $BACKUP_DIR"
echo "Preview:"
echo "  python3 -m http.server 8000"
echo "  then open http://localhost:8000"
echo
echo "Commit:"
echo "  git add index.html site.css site.js assets particle-lab ASSET_REPLACEMENT_GUIDE.txt"
echo "  git commit -m 'Redesign personal website'"
echo "  git push"
