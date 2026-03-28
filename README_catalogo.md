# 📋 Catálogo de Discapacidades — PETALO Agency

## Descripción

Catálogo de discapacidades para el sistema **No Me Olvides**, basado en:

- **LGDNNA** (Ley General de los Derechos de Niñas, Niños y Adolescentes)
- **FUD CEAVEM** — Hoja 8: Información complementaria de la víctima
- **CIF** (Clasificación Internacional del Funcionamiento — OMS)

El catálogo clasifica las discapacidades en 5 tipos y 3 grados de dependencia, permitiendo registrar con precisión las condiciones de los NNA atendidos por la fundación.

## Estructura del catálogo

| Campo | Tipo | Descripción |
|---|---|---|
| id_discapacidad | SERIAL | Identificador único |
| tipo | VARCHAR | Física, Mental, Intelectual, Visual, Auditiva, Múltiple |
| descripcion | VARCHAR | Descripción específica de la discapacidad |
| grado_dependencia | VARCHAR | Moderada, Severa, Gran dependencia |
| es_permanente | BOOLEAN | Si la condición es permanente o temporal |

### Tipos de discapacidad

| Tipo | Descripción |
|---|---|
| Física | Limitaciones motoras o de movilidad |
| Mental | Trastornos psiquiátricos o psicológicos |
| Intelectual | Limitaciones en el desarrollo cognitivo |
| Visual | Pérdida parcial o total de la vista |
| Auditiva | Pérdida parcial o total de la audición |
| Múltiple | Combinación de dos o más tipos |

### Grados de dependencia (CIF/OMS)

| Grado | Descripción |
|---|---|
| Moderada | Requiere apoyo ocasional para actividades diarias |
| Severa | Requiere apoyo frecuente para la mayoría de actividades |
| Gran dependencia | Requiere apoyo continuo para todas las actividades |

---

## 🚀 Cómo importar el catálogo a PostgreSQL

### Opción 1 — Usando el schema completo (recomendado)

```bash
# Crear la base de datos si no existe
psql -U petalo -c "CREATE DATABASE no_me_olvides;"

# Ejecutar el schema completo (incluye el catálogo)
psql -U petalo -d no_me_olvides -f backend/database/schema.sql
```

### Opción 2 — Solo el catálogo (si ya tienes la BD)

```bash
# Crear la tabla e importar los datos
psql -U petalo -d no_me_olvides -f catalogo_discapacidades.sql
```

### Opción 3 — Importar desde el CSV

```bash
# Primero crear la tabla
psql -U petalo -d no_me_olvides -c "
CREATE TABLE IF NOT EXISTS catalogo_discapacidades (
    id_discapacidad   SERIAL PRIMARY KEY,
    tipo              VARCHAR(20),
    descripcion       VARCHAR(200),
    grado_dependencia VARCHAR(20),
    es_permanente     BOOLEAN
);"

# Luego importar el CSV
psql -U petalo -d no_me_olvides -c "\COPY catalogo_discapacidades(tipo,descripcion,grado_dependencia,es_permanente) FROM 'discapacidades.csv' CSV HEADER;"
```

### Verificar que se importó correctamente

```bash
psql -U petalo -d no_me_olvides -c "SELECT * FROM catalogo_discapacidades;"
```

---

## Relación con el módulo NNA

La tabla `nna_discapacidades` relaciona cada NNA con una o más discapacidades del catálogo:

```sql
SELECT n.nombre, n.primer_apellido, c.tipo, c.descripcion, c.grado_dependencia
FROM nna n
JOIN nna_discapacidades nd ON n.id = nd.id_nna
JOIN catalogo_discapacidades c ON nd.id_discapacidad = c.id_discapacidad;
```

---

*PETALO Agency — Bases de Datos — ESCOM IPN — 2026*
