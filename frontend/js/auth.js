const API = "http://127.0.0.1:8000";

function login(email, password) {
  const cuentas = {
    "director@fundacion.org":     { password:"1234", rol:"director",     nombre:"Director",     dashboard:"pages/dashboard-director.html" },
    "coordinador@fundacion.org":  { password:"1234", rol:"coordinador",  nombre:"Coordinador",  dashboard:"pages/dashboard-director.html" },
    "psicologo@fundacion.org":    { password:"1234", rol:"psicologo",    nombre:"Psicólogo",    dashboard:"pages/dashboard-equipo.html" },
    "doctor@fundacion.org":       { password:"1234", rol:"doctor",       nombre:"Doctor",       dashboard:"pages/dashboard-equipo.html" },
    "donante@fundacion.org":      { password:"1234", rol:"donante",      nombre:"Donante",      dashboard:"pages/dashboard-donante.html" },
  };
  const cuenta = cuentas[email];
  if (cuenta && cuenta.password === password) {
    localStorage.setItem("token", "demo-token");
    localStorage.setItem("rol", cuenta.rol);
    localStorage.setItem("nombre", cuenta.nombre);
    return cuenta;
  }
  return null;
}

async function loginReal(email, password) {
  try {
    const res = await fetch(`${API}/api/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ correo: email, contrasena: password })
    });
    if (!res.ok) {
      const err = await res.json();
      return { error: err.detail };
    }
    const data = await res.json();
    localStorage.setItem("token", data.token);
    localStorage.setItem("rol", data.rol);
    localStorage.setItem("nombre", data.nombre);
    const dashboards = {
      director: "pages/dashboard-director.html",
      coordinador: "pages/dashboard-director.html",
      psicologo: "pages/dashboard-equipo.html",
      doctor: "pages/dashboard-equipo.html",
      abogado: "pages/dashboard-equipo.html",
      trabajador_social: "pages/dashboard-equipo.html",
      analista: "pages/dashboard-equipo.html",
      donante: "pages/dashboard-donante.html",
    };
    return { dashboard: dashboards[data.rol] || "pages/dashboard-equipo.html" };
  } catch(e) {
    return { error: "No se pudo conectar con el servidor" };
  }
}

function getToken()  { return localStorage.getItem("token"); }
function getRol()    { return localStorage.getItem("rol"); }
function getNombre() { return localStorage.getItem("nombre"); }

function logout() {
  localStorage.clear();
  window.location.href = "../index.html";
}

function requireAuth() {
  if (!getToken()) window.location.href = "../index.html";
}

function requireDirector() {
  const rol = getRol();
  if (!rol || !["director","coordinador"].includes(rol)) {
    window.location.href = "../index.html";
  }
}

function authHeaders() {
  return {
    "Content-Type": "application/json",
    "Authorization": `Bearer ${getToken()}`
  };
}

function renderSidebar(activo) {
  const rol = getRol();
  const nombre = getNombre();
  const esDirector = ["director","coordinador"].includes(rol);
  const esDonante = rol === "donante";

  const navDirector = esDirector ? `
    <div class="nav-label">Gestión</div>
    <div class="nav-item ${activo==='usuarios'?'active':''}" onclick="location.href='${esDirector?'usuarios/lista-usuarios.html':'#'}'">
      <span class="nav-icon">👥</span> Personal
    </div>
    <div class="nav-item ${activo==='invitaciones'?'active':''}" onclick="generarLink && generarLink()">
      <span class="nav-icon">🔗</span> Generar Link
    </div>` : "";

  const navNNA = !esDonante ? `
    <div class="nav-label">Beneficiarios</div>
    <div class="nav-item ${activo==='nna'?'active':''}" onclick="location.href='nna/lista-nna.html'">
      <span class="nav-icon">📋</span> Expedientes NNA
    </div>` : "";

  const navStats = esDirector || esDonante ? `
    <div class="nav-label">Reportes</div>
    <div class="nav-item ${activo==='stats'?'active':''}" onclick="location.href='estadisticas.html'">
      <span class="nav-icon">📊</span> Estadísticas
    </div>` : "";

  return `
    <div class="sb-logo">
      <div class="sb-logo-icon">🌸</div>
      <div>
        <div class="sb-logo-name">No Me Olvides</div>
        <div class="sb-logo-sub">Fundación Infantil</div>
      </div>
    </div>
    <div class="sb-user">
      <div class="sb-avatar">${nombre?nombre[0]:'U'}</div>
      <div>
        <div class="sb-uname">${nombre||'Usuario'}</div>
        <div class="sb-urole">${rol||''}</div>
      </div>
    </div>
    <nav class="sb-nav">
      <div class="nav-item ${activo==='dashboard'?'active':''}" onclick="location.href='${esDonante?'dashboard-donante.html':esDirector?'dashboard-director.html':'dashboard-equipo.html'}'">
        <span class="nav-icon">🏠</span> Inicio
      </div>
      ${navDirector}${navNNA}${navStats}
    </nav>
    <div class="sb-footer">
      <button class="btn-logout" onclick="logout()">🚪 Cerrar sesión</button>
    </div>`;
}
