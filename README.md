# 🌸 No Me Olvides

### Sistema de Gestión — Fundación Infantil

> *Manteniendo vivo el amor y construyendo su futuro*

Sistema web para el registro, seguimiento y gestión de Niñas, Niños y Adolescentes (NNA) víctimas de orfandad por feminicidio o abandono materno.

Desarrollado por **PETALO Agency** como proyecto escolar para la materia de Bases de Datos — ESCOM, IPN.

---

## 👥 Equipo

| NOMBRE |
| --- |
| García Hernández Edgar Alessandro |
| Soria Lopez Dana Paola |
| Velázquez Rivero Lesly |

**Profesor:** Ulises Vélez Saldaña

---

## 🛠️ Tecnologías

| Capa | Tecnología |
| --- | --- |
| Frontend | HTML · CSS · JavaScript |
| Backend | Python · FastAPI |
| Base de datos | PostgreSQL |
| Autenticación | JWT |

---

## ⚙️ Requisitos

- Python 3.11 o superior
- PostgreSQL instalado y corriendo
- Git

---

## 🚀 Instalación y arranque

### 1. Clonar el repositorio

```bash
git clone https://github.com/BONABOMBONA/No_me_olvides_by_PETALO.git
cd No_me_olvides_by_PETALO
```

### 2. Configurar la base de datos

Abre PostgreSQL y ejecuta:

```sql
CREATE USER petalo WITH PASSWORD '1234';
CREATE DATABASE no_me_olvides OWNER petalo;
```

Luego ejecuta el schema:

```bash
psql -U petalo -d no_me_olvides -f backend/database/schema.sql
```

### 3. Configurar el backend

```bash
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Edita el archivo `.env` con tus credenciales si son diferentes:

```
DB_HOST=localhost
DB_NAME=no_me_olvides
DB_USER=petalo
DB_PASS=1234
JWT_SECRET=nommeolvides2026
LINK_EXPIRA_HORAS=48
```

### 4. Correr el proyecto

Abre **dos terminales**:

**Terminal 1 — Backend:**
```bash
cd ~/Descargas/no-me-olvides/backend
source venv/bin/activate
uvicorn main:app --reload
```

**Terminal 2 — Frontend:**
```bash
cd ~/Descargas/no-me-olvides/frontend
python3 -m http.server 5173
```

Abre el navegador en: **http://localhost:5173**

---

## 🔐 Roles y permisos

| Rol | Acceso |
| --- | --- |
| Director | Todo: usuarios, NNA, estadísticas, generar links, asignar roles |
| Coordinador | Usuarios y NNA: ver, registrar, editar |
| Psicólogo / Doctor / Abogado / Trabajador Social | NNA: ver y editar expedientes |
| Analista | NNA: solo lectura |
| Donante | Estadísticas anónimas únicamente |
| Pendiente | Sin acceso hasta que el Director asigne rol |

---

## 📋 Cuentas de prueba

| Correo | Contraseña | Rol |
| --- | --- | --- |
| director@fundacion.org | 1234 | Director |
| coordinador@fundacion.org | 1234 | Coordinador |
| psicologo@fundacion.org | 1234 | Psicólogo |
| donante@fundacion.org | 1234 | Donante |

---

## 🔗 Flujo de registro de nuevo usuario

1. El Director genera un link desde su dashboard
2. El link tiene un token único con expiración de 48 hrs
3. El link se envía al nuevo usuario
4. El usuario llena el formulario con sus datos
5. La cuenta queda en estado **Pendiente**
6. El Director ve la cuenta pendiente y asigna el rol
7. La cuenta se activa

---

## 📄 Entregables del proyecto

- Propuesta técnico-económica (PETALO Agency)
- Estructura del proyecto y arquitectura
- Prototipo inicial — segunda entrega
- Base de datos implementada en PostgreSQL
- Sistema funcionando con todas las pantallas
- Reporte final en LaTeX

---

*Proyecto académico — Bases de Datos — ESCOM IPN — 2026*
