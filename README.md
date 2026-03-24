# 🌸 No Me Olvides
### Sistema de Gestión — Fundación Infantil
> *Manteniendo vivo el amor y construyendo su futuro*

Sistema web para el registro, seguimiento y gestión de Niñas, Niños y Adolescentes (NNA) víctimas de orfandad por feminicidio o abandono materno.

Desarrollado por **PETALO Agency** como proyecto escolar para la materia de Bases de Datos — ESCOM, IPN.

---

## 👥 Equipo

| García Hernández Edgar Alessandro |
| Soria Lopez Dana Paola | 
| Velázquez Rivero Lesly |

**Profesor:** Ulises Vélez Saldaña

---

## 🛠️ Tecnologías

| Capa | Tecnología |
|---|---|
| Frontend | HTML · CSS · JavaScript |
| Backend | Python · FastAPI |
| Base de datos | PostgreSQL |
| Autenticación | JWT |

---

## ⚙️ Requisitos para correr el proyecto

- Python 3.11 o superior
- PostgreSQL instalado y corriendo
- Git

---

## 🔐 Roles y permisos

| Rol | Acceso |
|---|---|
| Director | Todo: usuarios, NNA, estadísticas, generar links, asignar roles |
| Coordinador | Usuarios y NNA: ver, registrar, editar |
| Psicólogo / Doctor / Abogado / Trabajador Social | NNA: ver y editar expedientes |
| Analista | NNA: solo lectura |
| Donante | Estadísticas anónimas únicamente |
| Pendiente | Sin acceso hasta que el Director asigne rol |

---

## 🔗 Flujo de registro de nuevo usuario

1. El Director genera un link desde su dashboard
2. El link tiene un token único con expiración de 48 hrs
3. El link se envía al nuevo usuario por email o WhatsApp
4. El usuario llena el formulario: nombre, RFC, CURP, correo, contraseña
5. La cuenta queda en estado **Pendiente**
6. El sistema muestra: *"Cuenta creada exitosamente. Acuda a las oficinas para verificar su rol."*
7. El Director ve la cuenta pendiente y asigna el rol
8. La cuenta se activa

---

## 📋 Cuentas de prueba

| Correo | Contraseña | Rol |
|---|---|---|
| director@fundacion.org | 1234 | Director |
| coordinador@fundacion.org | 1234 | Coordinador |
| psicologo@fundacion.org | 1234 | Psicólogo |
| donante@fundacion.org | 1234 | Donante |

---

## 📄 Entregables del proyecto

- [x] Propuesta técnico-económica (PETALO Agency)
- [x] Estructura del proyecto y arquitectura
- [ ] Prototipo inicial — segunda entrega
- [ ] Base de datos implementada en PostgreSQL
- [ ] Sistema funcionando con todas las pantallas
- [ ] Reporte final en LaTeX

---

*Proyecto académico — Bases de Datos — ESCOM IPN — 2026*
