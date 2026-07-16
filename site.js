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
