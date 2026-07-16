#!/usr/bin/env bash
set -euo pipefail

# Official Ling website builder
# Run from the root of holytpk.github.io:
#   chmod +x build_ling_site.sh
#   ./build_ling_site.sh

ROOT="$(pwd)"
STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$ROOT/backups/$STAMP"

echo "[1/9] Backing up current site..."
mkdir -p "$BACKUP_DIR"
for item in index.html site.css site.js particle-lab assets/characters assets/crypto; do
  [[ -e "$ROOT/$item" ]] && cp -a "$ROOT/$item" "$BACKUP_DIR/"
done

echo "[2/9] Preparing directories..."
mkdir -p \
  "$ROOT/assets/media" \
  "$ROOT/assets/crypto" \
  "$ROOT/assets/characters" \
  "$ROOT/particle-lab"

# Preserve and normalize the user's uploaded media.
[[ -f "$ROOT/B6D5BE39-6344-48BD-9333-72A4103EE7B7.jpg" ]] && \
  cp -f "$ROOT/B6D5BE39-6344-48BD-9333-72A4103EE7B7.jpg" "$ROOT/assets/media/btfu-logo.jpg"

[[ -f "$ROOT/grok-video-8fe56bdf-b6b8-4f80-8b2d-b909c83d3f80.mp4" ]] && \
  cp -f "$ROOT/grok-video-8fe56bdf-b6b8-4f80-8b2d-b909c83d3f80.mp4" "$ROOT/assets/media/intro.mp4"

# Remove old temporary artwork and labels.
rm -f \
  "$ROOT/assets/crypto/"*-placeholder.svg \
  "$ROOT/assets/characters/unipeg-placeholder.svg" \
  "$ROOT/assets/media/btfu-placeholder.svg"

# Create a clean fallback mascot only when the final unipeg PNG has not been supplied.
if [[ ! -f "$ROOT/assets/characters/unipeg.png" ]]; then
cat > "$ROOT/assets/characters/unipeg-fallback.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="720" height="720" viewBox="0 0 720 720">
  <defs>
    <linearGradient id="wing" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#8eeaff"/>
      <stop offset=".5" stop-color="#c69cff"/>
      <stop offset="1" stop-color="#ff93c7"/>
    </linearGradient>
  </defs>
  <rect width="720" height="720" rx="88" fill="#0b0b0b"/>
  <g shape-rendering="crispEdges">
    <rect x="300" y="70" width="40" height="130" fill="#f1ca4a"/>
    <rect x="340" y="30" width="40" height="170" fill="#fff4bf"/>
    <rect x="380" y="70" width="40" height="130" fill="#f1ca4a"/>
    <rect x="240" y="200" width="240" height="40" fill="#fff"/>
    <rect x="200" y="240" width="320" height="40" fill="#fff"/>
    <rect x="160" y="280" width="400" height="120" fill="#fff"/>
    <rect x="200" y="400" width="320" height="80" fill="#fff"/>
    <rect x="240" y="480" width="240" height="80" fill="#fff"/>
    <rect x="280" y="560" width="64" height="80" fill="#fff"/>
    <rect x="376" y="560" width="64" height="80" fill="#fff"/>
    <rect x="200" y="280" width="80" height="80" fill="#ff93c7"/>
    <rect x="440" y="280" width="80" height="80" fill="#ff93c7"/>
    <rect x="280" y="300" width="40" height="40" fill="#111"/>
    <rect x="400" y="300" width="40" height="40" fill="#111"/>
    <rect x="320" y="380" width="80" height="40" fill="#efb3ca"/>
    <path d="M160 250 L40 160 L120 360 Z" fill="url(#wing)"/>
    <path d="M560 250 L680 160 L600 360 Z" fill="url(#wing)"/>
  </g>
</svg>
SVG
fi

echo "[3/9] Writing official homepage..."
cat > "$ROOT/index.html" <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="theme-color" content="#080808">
  <meta name="description" content="Ling — particle physicist, scientific programmer, and crypto-native builder.">
  <title>Ling — Physics, Code & Crypto</title>
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
    <a class="brand" href="#home" data-tab-link="home" aria-label="Ling home">
      <span class="brand-mark">L</span>
      <span>LING</span>
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
            I am Ling, a particle-physics student working on top-quark
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
            <img class="video-fallback" src="assets/media/btfu-logo.jpg" alt="BTFU artwork">
            <div class="video-label">FIELD NOTE 001</div>
          </div>
          <img class="floating-unipeg"
               src="assets/characters/unipeg.png"
               onerror="this.onerror=null;this.src='assets/characters/unipeg-fallback.svg'"
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

      <section class="coin-cloud" aria-label="Crypto ecosystem">
        <article class="coin-card tilt-left">
          <img src="assets/crypto/btc.png" alt="Bitcoin">
          <span>HARD MONEY</span>
        </article>
        <article class="coin-card rise">
          <img src="assets/crypto/eth.png" alt="Ethereum">
          <span>PROGRAMMABLE VALUE</span>
        </article>
        <article class="coin-card tilt-right">
          <img src="assets/crypto/solana.png" alt="Solana">
          <span>FAST EXECUTION</span>
        </article>
        <article class="coin-card low">
          <img src="assets/crypto/monad.png" alt="Monad">
          <span>PARALLEL EVM</span>
        </article>
        <article class="coin-card">
          <img src="assets/crypto/bnb.png" alt="BNB">
          <span>GLOBAL ACCESS</span>
        </article>
        <article class="coin-card tilt-left">
          <img src="assets/crypto/tron.png" alt="Tron">
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
          <b>ling@analysis:~/profile</b>
        </div>
        <pre><code><span class="prompt">$</span> whoami
Ling — particle physics student & scientific programmer

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
        <article><span>01</span><h3>OPEN ACCESS</h3><p>Internet-native wallets can lower account and geographic barriers, although interfaces, regulation, and connectivity still matter.</p></article>
        <article><span>02</span><h3>24/7 SETTLEMENT</h3><p>Public networks can move and settle assets outside conventional banking hours without waiting for multiple reconciliations.</p></article>
        <article><span>03</span><h3>PROGRAMMABILITY</h3><p>Smart contracts let money, ownership, and agreements interact directly with software instead of relying entirely on manual layers.</p></article>
        <article><span>04</span><h3>VERIFIABILITY</h3><p>Shared ledgers make many balances and transactions independently inspectable, while privacy and offchain claims still require care.</p></article>
        <article><span>05</span><h3>PORTABILITY</h3><p>Users can carry assets and identity between compatible applications rather than remaining locked inside one institution.</p></article>
        <article><span>06</span><h3>COMPETITION</h3><p>Open protocols let new products build on existing liquidity and infrastructure, reducing some barriers to experimentation.</p></article>
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
      <strong>LING</strong>
      <span>PARTICLE PHYSICS / CODE / CRYPTO</span>
    </div>
    <div class="footer-links">
      <a href="https://github.com/holytpk" rel="noreferrer">GITHUB ↗</a>
      <a href="particle-lab/">PARTICLE LAB ↗</a>
      <a href="#home" data-tab-link="home">BACK TO TOP ↑</a>
    </div>
    <small>© <span id="year"></span> Ling. Not financial advice.</small>
  </footer>

  <script src="site.js"></script>
</body>
</html>
HTML

echo "[4/9] Writing homepage styles..."
cat > "$ROOT/site.css" <<'CSS'
:root{--bg:#080808;--panel:#111;--ink:#f7f2df;--muted:#a8a397;--gold:#f1ca4a;--line:rgba(255,255,255,.14);--radius:28px;--shadow:0 26px 80px rgba(0,0,0,.45)}
*{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;color:var(--ink);background:radial-gradient(circle at 15% 15%,rgba(241,202,74,.09),transparent 28rem),radial-gradient(circle at 85% 30%,rgba(255,147,199,.06),transparent 26rem),var(--bg);font-family:Arial,Helvetica,sans-serif;overflow-x:hidden}
button,a{font:inherit}button{color:inherit}a{color:inherit;text-decoration:none}img,video{display:block;max-width:100%}
.noise{position:fixed;inset:0;pointer-events:none;z-index:100;opacity:.035;background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 180 180' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='.55'/%3E%3C/svg%3E")}
.ticker{overflow:hidden;border-bottom:1px solid var(--line);background:var(--gold);color:#090909;font-weight:900;letter-spacing:.11em;font-size:.72rem}.ticker-track{width:max-content;display:flex;align-items:center;gap:22px;padding:9px 0;animation:ticker 30s linear infinite}.ticker i{font-style:normal}@keyframes ticker{to{transform:translateX(-50%)}}
.site-header{width:min(1480px,calc(100% - 40px));margin:0 auto;min-height:88px;display:flex;align-items:center;justify-content:space-between;gap:24px}.brand{display:inline-flex;align-items:center;gap:10px;font-weight:1000;letter-spacing:-.04em}.brand-mark{width:38px;height:38px;display:grid;place-items:center;background:var(--gold);color:#050505;border-radius:11px;transform:rotate(-8deg)}
.site-nav{display:flex;align-items:center;gap:8px}.nav-link,.menu-button{border:1px solid transparent;background:transparent;border-radius:999px;padding:11px 15px;cursor:pointer;font-size:.78rem;font-weight:900;letter-spacing:.08em}.nav-link:hover,.nav-link.is-active{border-color:var(--line);background:rgba(255,255,255,.06)}.nav-link-external{background:var(--ink);color:#080808}.menu-button{display:none;border-color:var(--line)}
main{min-height:70vh}.tab-panel{width:min(1480px,calc(100% - 40px));margin:0 auto;opacity:0;transform:translateY(16px)}.tab-panel.is-active{animation:panelIn .55s cubic-bezier(.2,.75,.2,1) forwards}@keyframes panelIn{to{opacity:1;transform:none}}
.hero{min-height:calc(100vh - 132px);display:grid;grid-template-columns:1.15fr .85fr;gap:clamp(30px,6vw,100px);align-items:center;padding:55px 0 95px}.eyebrow,.section-kicker{color:var(--gold);font-size:.74rem;font-weight:950;letter-spacing:.18em}.hero h1,.page-hero h2,.manifesto h2{margin:20px 0 24px;font-size:clamp(3.6rem,7.7vw,9.4rem);line-height:.82;letter-spacing:-.075em;font-weight:1000}.hero h1 span{display:inline-block}.outline{color:transparent;-webkit-text-stroke:2px var(--ink)}.gold{color:var(--gold)}.hero-lede{width:min(720px,100%);color:var(--muted);font-size:clamp(1.05rem,1.4vw,1.35rem);line-height:1.58}.hero-actions{display:flex;gap:12px;flex-wrap:wrap;margin-top:34px}.pill{border:1px solid var(--line);background:#141414;border-radius:999px;padding:16px 22px;cursor:pointer;font-weight:950;letter-spacing:.06em;font-size:.8rem;box-shadow:0 8px 0 rgba(0,0,0,.22);transition:transform .2s,background .2s}.pill:hover{transform:translateY(-3px) rotate(-1deg)}.pill.primary{background:var(--gold);color:#080808;border-color:var(--gold)}
.hero-media{position:relative}.media-frame{position:relative;overflow:hidden;aspect-ratio:.82;border-radius:46% 46% 28px 28px;border:1px solid var(--line);background:#000;box-shadow:var(--shadow);transform:rotate(2deg)}.media-frame video,.media-frame .video-fallback{width:100%;height:100%;object-fit:cover}.media-frame video+.video-fallback{display:none}.video-label{position:absolute;left:20px;bottom:20px;padding:10px 14px;background:var(--gold);color:#080808;border-radius:999px;font-size:.68rem;font-weight:950;letter-spacing:.1em}.floating-unipeg{position:absolute;width:36%;right:-11%;bottom:-6%;image-rendering:pixelated;filter:drop-shadow(0 22px 25px rgba(0,0,0,.55));animation:bob 3.5s ease-in-out infinite}@keyframes bob{50%{transform:translateY(-16px) rotate(2deg)}}
.manifesto{padding:110px 0;border-top:1px solid var(--line)}.manifesto-grid{display:grid;grid-template-columns:1.1fr .9fr;gap:70px;align-items:end}.manifesto h2{font-size:clamp(3.2rem,6.3vw,7rem)}.manifesto-grid p{color:var(--muted);font-size:1.18rem;line-height:1.65}
.coin-cloud{display:grid;grid-template-columns:repeat(6,1fr);gap:18px;padding:15px 0 130px}.coin-card{padding:12px;border-radius:24px;background:var(--panel);border:1px solid var(--line);box-shadow:var(--shadow);transition:transform .25s}.coin-card:hover{transform:translateY(-12px) rotate(0)}.coin-card img{width:100%;border-radius:17px;aspect-ratio:1;object-fit:cover}.coin-card span{display:block;padding:14px 7px 8px;color:var(--gold);font-size:.65rem;font-weight:950;letter-spacing:.08em}.tilt-left{transform:rotate(-3deg)}.tilt-right{transform:rotate(3deg)}.rise{transform:translateY(-34px) rotate(2deg)}.low{transform:translateY(30px) rotate(-2deg)}
.page-hero{max-width:1100px;padding:100px 0 75px}.page-hero h2{font-size:clamp(4rem,7vw,8.5rem)}.page-hero>p:last-child{max-width:790px;color:var(--muted);font-size:1.24rem;line-height:1.6}.feature-grid{display:grid;grid-template-columns:1.3fr 1fr 1fr;gap:18px;padding-bottom:85px}.feature-card,.reason-grid article{min-height:340px;padding:30px;border:1px solid var(--line);border-radius:var(--radius);background:var(--panel);position:relative;overflow:hidden}.feature-card.featured{background:var(--gold);color:#080808}.feature-number{font-weight:950;opacity:.65}.feature-card h3,.reason-grid h3,.risk-box h3{font-size:clamp(1.7rem,2.6vw,3.2rem);line-height:.95;letter-spacing:-.055em}.feature-card p,.reason-grid p{color:inherit;opacity:.72;line-height:1.55}.pixel-orbit i{position:absolute;width:30px;height:30px;background:#080808;image-rendering:pixelated}.pixel-orbit i:nth-child(1){right:60px;bottom:80px}.pixel-orbit i:nth-child(2){right:110px;bottom:40px;width:18px;height:18px}.pixel-orbit i:nth-child(3){right:30px;bottom:25px;width:12px;height:12px}.statement-strip{margin-bottom:120px;border-block:1px solid var(--line);padding:28px 0;display:flex;justify-content:space-between;gap:16px;font-weight:1000;font-size:clamp(1rem,2vw,2rem)}.statement-strip b{color:var(--gold)}
.terminal-window{border:1px solid var(--line);background:#030303;border-radius:var(--radius);overflow:hidden;box-shadow:var(--shadow);margin-bottom:70px}.terminal-bar{height:54px;background:#171717;display:flex;align-items:center;gap:8px;padding:0 18px}.terminal-bar span{width:12px;height:12px;border-radius:50%;background:#777}.terminal-bar span:first-child{background:#ff6868}.terminal-bar span:nth-child(2){background:#ffd35e}.terminal-bar span:nth-child(3){background:#6edd83}.terminal-bar b{margin-left:10px;color:#aaa;font:600 .75rem monospace}pre{margin:0;padding:clamp(24px,5vw,70px);overflow-x:auto}code{font:500 clamp(.83rem,1.35vw,1.1rem)/1.75 monospace;color:#d8d8d8}.prompt{color:var(--gold);font-weight:900}.skill-marquee{overflow:hidden;margin-bottom:120px;border-block:1px solid var(--line)}.skill-marquee div{width:max-content;display:flex;gap:40px;padding:24px 0;animation:ticker 25s linear infinite}.skill-marquee span{color:var(--gold);font-size:1.2rem;font-weight:1000;letter-spacing:.1em}
.reason-grid{display:grid;grid-template-columns:repeat(3,1fr);gap:18px;padding-bottom:35px}.reason-grid article{min-height:285px}.reason-grid article>span{color:var(--gold);font-weight:950}.reason-grid h3{font-size:2.1rem}.risk-box{margin:0 0 120px;padding:clamp(28px,5vw,68px);display:grid;grid-template-columns:1fr 1fr;gap:50px;align-items:center;background:var(--gold);color:#080808;border-radius:var(--radius);transform:rotate(-.5deg)}.risk-box p:last-child{font-size:1.08rem;line-height:1.6}
footer{width:min(1480px,calc(100% - 40px));margin:0 auto;padding:45px 0 50px;border-top:1px solid var(--line);display:grid;grid-template-columns:1fr auto;gap:24px}footer strong{display:block;font-size:1.8rem}footer span,footer small{color:var(--muted)}.footer-links{display:flex;gap:18px;font-weight:900;font-size:.78rem}footer small{grid-column:1/-1}
@media(max-width:1050px){.hero{grid-template-columns:1fr}.hero-media{width:min(620px,92%);margin:0 auto}.media-frame{aspect-ratio:1.08;border-radius:40px}.coin-cloud{grid-template-columns:repeat(3,1fr)}.feature-grid,.reason-grid{grid-template-columns:1fr 1fr}.feature-card.featured{grid-column:1/-1}}
@media(max-width:760px){.site-header{min-height:72px}.menu-button{display:block}.site-nav{display:none;position:absolute;left:20px;right:20px;top:105px;z-index:20;padding:14px;flex-direction:column;align-items:stretch;background:#111;border:1px solid var(--line);border-radius:22px;box-shadow:var(--shadow)}.site-nav.is-open{display:flex}.nav-link{text-align:left}.hero{padding-top:38px}.hero h1{font-size:clamp(3.2rem,17vw,5.6rem)}.manifesto-grid,.risk-box{grid-template-columns:1fr;gap:20px}.coin-cloud{grid-template-columns:1fr 1fr}.rise,.low{transform:none}.feature-grid,.reason-grid{grid-template-columns:1fr}.feature-card.featured{grid-column:auto}.statement-strip{flex-wrap:wrap}footer{grid-template-columns:1fr}.footer-links{flex-wrap:wrap}}
@media(prefers-reduced-motion:reduce){*,*::before,*::after{animation-duration:.001ms!important;animation-iteration-count:1!important;scroll-behavior:auto!important}}
CSS

echo "[5/9] Writing homepage interactions..."
cat > "$ROOT/site.js" <<'JS'
(() => {
  const buttons = [...document.querySelectorAll("[data-tab]")];
  const links = [...document.querySelectorAll("[data-tab-link]")];
  const menu = document.querySelector(".site-nav");
  const menuButton = document.querySelector(".menu-button");
  let active = "home";
  let switching = false;

  const panel = name => document.querySelector(`.tab-panel[data-panel="${name}"]`);

  function activate(name, updateHash = true) {
    if (switching || !panel(name)) return;
    if (name === active) {
      window.scrollTo({ top: 0, behavior: "smooth" });
      return;
    }

    switching = true;
    const oldPanel = panel(active);
    const newPanel = panel(name);

    oldPanel.style.transition = "opacity .22s ease, transform .22s ease";
    oldPanel.style.opacity = "0";
    oldPanel.style.transform = "translateY(-10px)";

    setTimeout(() => {
      oldPanel.hidden = true;
      oldPanel.classList.remove("is-active");
      oldPanel.removeAttribute("style");

      newPanel.hidden = false;
      requestAnimationFrame(() => newPanel.classList.add("is-active"));

      active = name;
      buttons.forEach(button =>
        button.classList.toggle("is-active", button.dataset.tab === name)
      );

      if (updateHash) history.replaceState(null, "", `#${name}`);
      window.scrollTo({ top: 0, behavior: "smooth" });
      menu?.classList.remove("is-open");
      menuButton?.setAttribute("aria-expanded", "false");

      setTimeout(() => { switching = false; }, 560);
    }, 220);
  }

  buttons.forEach(button =>
    button.addEventListener("click", () => activate(button.dataset.tab))
  );

  links.forEach(link =>
    link.addEventListener("click", event => {
      event.preventDefault();
      activate(link.dataset.tabLink);
    })
  );

  menuButton?.addEventListener("click", () => {
    const open = menu.classList.toggle("is-open");
    menuButton.setAttribute("aria-expanded", String(open));
  });

  const initial = location.hash.slice(1);
  if (initial && panel(initial)) {
    panel("home").hidden = true;
    panel("home").classList.remove("is-active");
    panel(initial).hidden = false;
    panel(initial).classList.add("is-active");
    active = initial;
    buttons.forEach(button =>
      button.classList.toggle("is-active", button.dataset.tab === initial)
    );
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

echo "[6/9] Rebuilding Particle Lab game..."
cat > "$ROOT/particle-lab/index.html" <<'HTML'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta name="theme-color" content="#070707">
  <title>Particle Lab — Ling</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="grain"></div>

  <header>
    <a class="lab-brand" href="../">
      <span>L</span>
      LING LAB
    </a>
    <div class="status">
      <i></i>
      CMS SIMULATION ONLINE
    </div>
    <a class="back-link" href="../">PORTFOLIO ↗</a>
  </header>

  <main>
    <section class="intro">
      <p class="kicker">INTERACTIVE COLLIDER SIMULATION</p>
      <h1>PARTICLE<br><em>LAB</em></h1>
      <p class="lede">
        Tune the collision energy, generate proton-proton events, collect
        detector data, and identify rare signatures before the run ends.
      </p>
    </section>

    <section class="game-shell">
      <div class="control-panel">
        <div class="panel-heading">
          <span>RUN CONTROL</span>
          <b id="runLabel">RUN 001</b>
        </div>

        <label>
          Collision energy
          <output id="energyOutput">13.6 TeV</output>
        </label>
        <input id="energy" type="range" min="5" max="14" step=".1" value="13.6">

        <label>
          Luminosity
          <output id="lumiOutput">120 fb⁻¹</output>
        </label>
        <input id="lumi" type="range" min="10" max="300" step="10" value="120">

        <div class="button-grid">
          <button id="collideButton" class="primary">COLLIDE</button>
          <button id="autoButton">AUTO RUN</button>
          <button id="resetButton">RESET</button>
        </div>

        <div class="objectives">
          <p>OBJECTIVE</p>
          <strong>Discover 3 rare signatures</strong>
          <span id="objectiveText">0 / 3 discovered</span>
        </div>
      </div>

      <div class="detector-panel">
        <canvas id="detector" width="900" height="620" aria-label="Particle detector simulation"></canvas>
        <div class="detector-hud">
          <span>EVENT <b id="eventNumber">000000</b></span>
          <span>TRIGGER <b id="triggerState">STANDBY</b></span>
          <span>FIELD <b>3.8 T</b></span>
        </div>
      </div>

      <aside class="data-panel">
        <div class="panel-heading">
          <span>LIVE DATA</span>
          <b id="quality">GOOD</b>
        </div>

        <div class="metric"><span>Events</span><strong id="events">0</strong></div>
        <div class="metric"><span>Tracks</span><strong id="tracks">0</strong></div>
        <div class="metric"><span>Photons</span><strong id="photons">0</strong></div>
        <div class="metric"><span>Jets</span><strong id="jets">0</strong></div>
        <div class="metric"><span>Missing Eₜ</span><strong id="met">0 GeV</strong></div>
        <div class="metric accent"><span>Data score</span><strong id="score">0</strong></div>

        <div class="discoveries">
          <p>DISCOVERIES</p>
          <ul id="discoveryList">
            <li data-key="higgs">Higgs-like diphoton event</li>
            <li data-key="top">Boosted top-quark candidate</li>
            <li data-key="dark">Large missing-energy event</li>
          </ul>
        </div>
      </aside>
    </section>

    <section class="log-section">
      <div>
        <p class="kicker">EVENT LOG</p>
        <h2>WHAT THE DETECTOR SAW</h2>
      </div>
      <div id="eventLog" class="event-log">
        <article><time>READY</time><p>Detector systems initialized. Begin the first collision.</p></article>
      </div>
    </section>
  </main>

  <footer>
    <span>LING PARTICLE LAB</span>
    <small>Educational simulation — not real collision data.</small>
  </footer>

  <script src="game.js"></script>
</body>
</html>
HTML

cat > "$ROOT/particle-lab/style.css" <<'CSS'
:root{--bg:#070707;--panel:#111;--panel2:#171717;--ink:#f7f2df;--muted:#9e9a90;--yellow:#f1ca4a;--cyan:#8eeaff;--pink:#ff8fc4;--line:rgba(255,255,255,.14)}
*{box-sizing:border-box}body{margin:0;background:radial-gradient(circle at 50% 20%,rgba(142,234,255,.07),transparent 32rem),var(--bg);color:var(--ink);font-family:Arial,Helvetica,sans-serif}.grain{position:fixed;inset:0;pointer-events:none;opacity:.035;background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 180 180' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='.6'/%3E%3C/svg%3E")}
a{color:inherit;text-decoration:none}header,main,footer{width:min(1500px,calc(100% - 36px));margin:auto}header{height:88px;display:flex;align-items:center;justify-content:space-between;border-bottom:1px solid var(--line)}.lab-brand{display:flex;align-items:center;gap:10px;font-weight:1000}.lab-brand span{width:38px;height:38px;display:grid;place-items:center;background:var(--yellow);color:#070707;border-radius:10px;transform:rotate(-8deg)}.status{font-size:.72rem;font-weight:900;letter-spacing:.13em;color:var(--muted)}.status i{display:inline-block;width:8px;height:8px;margin-right:8px;border-radius:50%;background:#67e881;box-shadow:0 0 14px #67e881}.back-link{font-size:.78rem;font-weight:900}
.intro{padding:80px 0 55px}.kicker{color:var(--yellow);font-size:.72rem;font-weight:900;letter-spacing:.18em}.intro h1,.log-section h2{font-size:clamp(4.5rem,10vw,10rem);line-height:.78;letter-spacing:-.08em;margin:.2em 0}.intro h1 em{font-style:normal;color:transparent;-webkit-text-stroke:2px var(--ink)}.lede{max-width:720px;color:var(--muted);font-size:1.2rem;line-height:1.6}
.game-shell{display:grid;grid-template-columns:300px minmax(0,1fr) 280px;gap:16px;align-items:stretch}.control-panel,.detector-panel,.data-panel{background:var(--panel);border:1px solid var(--line);border-radius:26px;overflow:hidden}.control-panel,.data-panel{padding:22px}.panel-heading{display:flex;justify-content:space-between;align-items:center;padding-bottom:20px;border-bottom:1px solid var(--line);font-size:.7rem;font-weight:900;letter-spacing:.12em}.panel-heading b{color:var(--yellow)}label{display:flex;justify-content:space-between;margin-top:25px;color:var(--muted);font-size:.82rem;font-weight:800}output{color:var(--ink)}input[type=range]{width:100%;accent-color:var(--yellow);margin:14px 0 4px}.button-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:24px}.button-grid button{border:1px solid var(--line);border-radius:12px;background:#191919;color:var(--ink);padding:13px 10px;font-weight:900;cursor:pointer}.button-grid .primary{grid-column:1/-1;background:var(--yellow);color:#070707}.button-grid button:hover{transform:translateY(-2px)}.objectives{margin-top:26px;padding:18px;background:#0a0a0a;border-radius:16px}.objectives p,.discoveries p{margin:0 0 10px;color:var(--yellow);font-size:.68rem;font-weight:900;letter-spacing:.13em}.objectives strong,.objectives span{display:block}.objectives strong{font-size:1rem}.objectives span{margin-top:8px;color:var(--muted);font-size:.78rem}
.detector-panel{position:relative;min-height:620px;background:radial-gradient(circle,#121924 0,#080a0e 65%)}canvas{width:100%;height:100%;min-height:620px;display:block}.detector-hud{position:absolute;left:16px;right:16px;bottom:16px;display:flex;justify-content:space-between;gap:12px;padding:11px 14px;background:rgba(0,0,0,.55);backdrop-filter:blur(8px);border:1px solid var(--line);border-radius:12px;font:700 .68rem monospace;color:var(--muted)}.detector-hud b{color:var(--ink)}
.metric{display:flex;justify-content:space-between;align-items:end;padding:17px 0;border-bottom:1px solid var(--line)}.metric span{color:var(--muted);font-size:.8rem}.metric strong{font-size:1.25rem}.metric.accent strong{color:var(--yellow);font-size:2rem}.discoveries{margin-top:26px}.discoveries ul{list-style:none;padding:0;margin:0}.discoveries li{padding:11px 0 11px 24px;color:#666;font-size:.78rem;position:relative}.discoveries li:before{content:"";position:absolute;left:0;top:13px;width:10px;height:10px;border:1px solid #555;border-radius:3px}.discoveries li.found{color:var(--ink)}.discoveries li.found:before{background:var(--yellow);border-color:var(--yellow);box-shadow:0 0 10px rgba(241,202,74,.45)}
.log-section{padding:110px 0}.log-section{display:grid;grid-template-columns:.9fr 1.1fr;gap:60px}.log-section h2{font-size:clamp(3.5rem,7vw,7rem)}.event-log{display:flex;flex-direction:column;gap:10px}.event-log article{display:grid;grid-template-columns:90px 1fr;gap:20px;padding:18px 20px;background:var(--panel);border:1px solid var(--line);border-radius:14px}.event-log time{color:var(--yellow);font:800 .72rem monospace}.event-log p{margin:0;color:var(--muted);line-height:1.45}
footer{padding:35px 0 55px;border-top:1px solid var(--line);display:flex;justify-content:space-between;color:var(--muted);font-size:.75rem}footer span{color:var(--ink);font-weight:900}
@media(max-width:1100px){.game-shell{grid-template-columns:1fr 1fr}.detector-panel{grid-column:1/-1;grid-row:1}.control-panel,.data-panel{grid-row:2}.log-section{grid-template-columns:1fr}}
@media(max-width:700px){header .status{display:none}.game-shell{grid-template-columns:1fr}.detector-panel,.control-panel,.data-panel{grid-column:auto;grid-row:auto}.detector-panel,canvas{min-height:430px}.intro{padding-top:50px}.intro h1{font-size:clamp(4rem,22vw,7rem)}.detector-hud{font-size:.55rem}.log-section{padding:75px 0}.event-log article{grid-template-columns:1fr;gap:6px}footer{flex-direction:column;gap:10px}}
CSS

cat > "$ROOT/particle-lab/game.js" <<'JS'
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
JS

echo "[7/9] Writing asset guide..."
cat > "$ROOT/ASSET_REPLACEMENT_GUIDE.txt" <<'TXT'
Official site assets

Crypto icons:
assets/crypto/btc.png
assets/crypto/eth.png
assets/crypto/solana.png
assets/crypto/monad.png
assets/crypto/bnb.png
assets/crypto/tron.png

Character:
assets/characters/unipeg.png

Media:
assets/media/btfu-logo.jpg
assets/media/intro.mp4

The site no longer shows placeholder wording. If unipeg.png is absent, a clean
built-in pixel mascot is used automatically.
TXT

echo "[8/9] Checking required crypto files..."
missing=0
for name in btc eth solana monad bnb tron; do
  if [[ ! -f "$ROOT/assets/crypto/$name.png" ]]; then
    echo "  WARNING: assets/crypto/$name.png is missing"
    missing=1
  fi
done

echo "[9/9] Finished."
echo
echo "Backup created at: $BACKUP_DIR"
echo
echo "Preview:"
echo "  python3 -m http.server 8000"
echo "  open http://localhost:8000"
echo
echo "Particle Lab:"
echo "  open http://localhost:8000/particle-lab/"
echo
echo "Commit:"
echo "  git add -A"
echo "  git commit -m 'Launch official Ling portfolio and particle lab'"
echo "  git push"
echo
if [[ "$missing" -eq 1 ]]; then
  echo "One or more crypto PNG files are missing. Copy them into assets/crypto/."
fi
