-- ============================================================
-- Migración v2 — Campos faltantes del FUD en tabla NNA
-- Ejecutar DESPUÉS del schema.sql original
-- ============================================================

-- Datos del Tutor (hoja 8 del FUD)
ALTER TABLE nna ADD COLUMN IF NOT EXISTS tutor_nombre          VARCHAR(200);
ALTER TABLE nna ADD COLUMN IF NOT EXISTS tutor_primer_apellido VARCHAR(60);
ALTER TABLE nna ADD COLUMN IF NOT EXISTS tutor_segundo_apellido VARCHAR(60);
ALTER TABLE nna ADD COLUMN IF NOT EXISTS tutor_parentesco      VARCHAR(80);
ALTER TABLE nna ADD COLUMN IF NOT EXISTS tutor_telefono        VARCHAR(20);
ALTER TABLE nna ADD COLUMN IF NOT EXISTS tutor_correo          VARCHAR(120);

-- Vulnerabilidad (hoja 8 del FUD)
ALTER TABLE nna ADD COLUMN IF NOT EXISTS tiene_discapacidad    BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS tipo_discapacidad     VARCHAR(20) CHECK (tipo_discapacidad IN ('Física','Mental','Intelectual','Visual','Auditiva','Múltiple'));
ALTER TABLE nna ADD COLUMN IF NOT EXISTS grado_dependencia     VARCHAR(20) CHECK (grado_dependencia IN ('Moderada','Severa','Gran dependencia'));
ALTER TABLE nna ADD COLUMN IF NOT EXISTS habla_espanol         BOOLEAN DEFAULT TRUE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS requiere_traductor    BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS idioma_lengua         VARCHAR(80);
ALTER TABLE nna ADD COLUMN IF NOT EXISTS comunidad_indigena    BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS cual_comunidad        VARCHAR(100);
ALTER TABLE nna ADD COLUMN IF NOT EXISTS es_migrante           BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS pais_origen           VARCHAR(60);

-- Tipo de violencia (hoja 8 del FUD)
ALTER TABLE nna ADD COLUMN IF NOT EXISTS violencia_psicologica BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS violencia_fisica      BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS violencia_economica   BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS violencia_patrimonial BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS violencia_sexual      BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS violencia_obstetrica  BOOLEAN DEFAULT FALSE;
ALTER TABLE nna ADD COLUMN IF NOT EXISTS violencia_feminicida  BOOLEAN DEFAULT FALSE;

