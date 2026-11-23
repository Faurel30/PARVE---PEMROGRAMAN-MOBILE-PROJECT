const Auth = (() => {
  const SESSION_KEY = "parve_admin_session";
  const DEMO_ADMIN = {
    email: "admin@parve.id",
    password: "admin123",
    name: "Admin PARVE",
  };

  function safeSetSession(session) {
    const serialized = JSON.stringify(session);
    try {
      localStorage.setItem(SESSION_KEY, serialized);
    } catch (_) {}
    try {
      sessionStorage.setItem(SESSION_KEY, serialized);
    } catch (_) {}
  }

  function safeClearSession() {
    try {
      localStorage.removeItem(SESSION_KEY);
    } catch (_) {}
    try {
      sessionStorage.removeItem(SESSION_KEY);
    } catch (_) {}
  }

  function getSession() {
    try {
      const raw =
        localStorage.getItem(SESSION_KEY) ||
        sessionStorage.getItem(SESSION_KEY);
      if (raw) return JSON.parse(raw);
    } catch (_) {}
    return null;
  }

  function login(email, password) {
    if (
      email.trim().toLowerCase() === DEMO_ADMIN.email &&
      password === DEMO_ADMIN.password
    ) {
      const session = {
        email: DEMO_ADMIN.email,
        name: DEMO_ADMIN.name,
        loggedInAt: Date.now(),
      };
      safeSetSession(session);
      return { ok: true, session };
    }
    return { ok: false, message: "Email atau kata sandi administrator salah." };
  }

  function logout() {
    safeClearSession();
    window.location.href = "index.html";
  }

  function requireAuth() {
    let session = getSession();

    // Dukungan handoff sesi jika dibuka langsung via file:// (localStorage terpisah per file)
    if (!session && window.location.hash === "#logged_in") {
      session = {
        email: DEMO_ADMIN.email,
        name: DEMO_ADMIN.name,
        loggedInAt: Date.now(),
      };
      safeSetSession(session);
      try {
        history.replaceState(null, "", window.location.pathname + window.location.search);
      } catch (_) {}
    }

    if (!session) {
      window.location.href = "index.html";
      return null;
    }
    return session;
  }

  function initLoginPage() {
    const loginForm = document.getElementById("loginForm");
    if (!loginForm) return;

    const currentTheme = ParveStore.applySavedTheme();
    const themeBtn = document.getElementById("themeToggleBtn");

    if (themeBtn) {
      themeBtn.textContent =
        currentTheme === "dark" ? "☀️ Mode Terang" : "🌙 Mode Gelap";
      themeBtn.addEventListener("click", () => {
        const next = ParveStore.toggleTheme();
        themeBtn.textContent =
          next === "dark" ? "☀️ Mode Terang" : "🌙 Mode Gelap";
      });
    }

    const togglePwd = document.getElementById("togglePassword");
    const pwdInput = document.getElementById("password");
    togglePwd?.addEventListener("click", () => {
      const isPwd = pwdInput.type === "password";
      pwdInput.type = isPwd ? "text" : "password";
      togglePwd.textContent = isPwd ? "Sembunyi" : "Lihat";
    });

    const errorBox = document.getElementById("loginError");
    loginForm.addEventListener("submit", (e) => {
      e.preventDefault();
      const email = document.getElementById("email").value;
      const password = pwdInput.value;
      const result = login(email, password);

      if (!result.ok) {
        errorBox.textContent = result.message;
        errorBox.classList.remove("hidden");
        return;
      }
      errorBox.classList.add("hidden");
      window.location.href = "dashboard.html#logged_in";
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initLoginPage);
  } else {
    initLoginPage();
  }

  return { getSession, login, logout, requireAuth };
})();
