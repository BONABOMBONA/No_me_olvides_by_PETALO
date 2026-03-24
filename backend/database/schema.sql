-- ============================================================
-- No Me Olvides — Fundación Infantil
-- Schema de base de datos basado en el FUD (CEAVEM)
-- ============================================================

-- ── PERSONAL (empleados y voluntarios de la fundación) ──────
CREATE TABLE IF NOT EXISTS personal (
    id                  SERIAL PRIMARY KEY,
    nombre              VARCHAR(100) NOT NULL,
    primer_apellido     VARCHAR(60)  NOT NULL,
    segundo_apellido    VARCHAR(60),
    rfc                 VARCHAR(13)  UNIQUE,
    curp                VARCHAR(18)  UNIQUE,
    sexo                VARCHAR(20),
    edad                INTEGER,
    direccion           TEXT,
    correo              VARCHAR(120) UNIQUE NOT NULL,
    contrasena          VARCHAR(255) NOT NULL,
    tipo                VARCHAR(20)  CHECK (tipo IN ('empleado', 'voluntario')),
    rol                 VARCHAR(40)  CHECK (rol IN (
                            'director', 'coordinador', 'psicologo',
                            'doctor', 'abogado', 'trabajador_social',
                            'analista', 'equipo_multidisciplinario', 'donante'
                        )),
    estado              VARCHAR(20)  DEFAULT 'pendiente'
                                     CHECK (estado IN ('activo', 'inactivo', 'pendiente', 'restringido')),
    activo              BOOLEAN      DEFAULT FALSE,
    fecha_registro      TIMESTAMP    DEFAULT NOW()
);

-- ── INVITACIONES (links de registro con token) ───────────────
CREATE TABLE IF NOT EXISTS invitaciones (
    id              SERIAL PRIMARY KEY,
    token           VARCHAR(100) UNIQUE NOT NULL,
    creado_por      INTEGER REFERENCES personal(id),
    fecha_creacion  TIMESTAMP DEFAULT NOW(),
    fecha_expira    TIMESTAMP NOT NULL,
    usado           BOOLEAN   DEFAULT FALSE
);

-- ── NNA (expedientes de beneficiarios) ──────────────────────
CREATE TABLE IF NOT EXISTS nna (

    id                      SERIAL PRIMARY KEY,

    -- SECCIÓN I: Datos de la víctima (hoja 1 FUD)
    nombre                  VARCHAR(100) NOT NULL,
    primer_apellido         VARCHAR(60)  NOT NULL,
    segundo_apellido        VARCHAR(60),
    fecha_nacimiento        DATE,
    sexo                    VARCHAR(20),
    nacionalidad            VARCHAR(60),
    curp                    VARCHAR(18)  UNIQUE,
    lugar_nac_pais          VARCHAR(60),
    lugar_nac_entidad       VARCHAR(60),
    lugar_nac_municipio     VARCHAR(80),
    lugar_nac_comunidad     VARCHAR(80),
    estado_civil            VARCHAR(30),

    -- DOMICILIO (hoja 1 FUD)
    calle                   VARCHAR(120),
    numero_exterior         VARCHAR(20),
    numero_interior         VARCHAR(20),
    colonia                 VARCHAR(80),
    codigo_postal           VARCHAR(10),
    localidad               VARCHAR(80),
    delegacion_municipio    VARCHAR(80),
    entidad_federativa      VARCHAR(60),
    telefono                VARCHAR(20),

    -- SECCIÓN II: Tipo de víctima (hoja 2 FUD)
    tipo_victima            VARCHAR(20)  CHECK (tipo_victima IN ('directa', 'indirecta', 'ofendido')),
    nombre_victima_directa  VARCHAR(200),
    relacion_victima        VARCHAR(100),

    -- RELATO DE HECHOS (hoja 2 FUD)
    lugar_hechos_calle      VARCHAR(120),
    lugar_hechos_colonia    VARCHAR(80),
    lugar_hechos_municipio  VARCHAR(80),
    lugar_hechos_entidad    VARCHAR(60),
    fecha_hechos            DATE,
    relato_hechos           TEXT,

    -- SECCIÓN VI: Tipo de daño (hoja 3 FUD)
    dano_fisico             BOOLEAN DEFAULT FALSE,
    dano_psicologico        BOOLEAN DEFAULT FALSE,
    dano_patrimonial        BOOLEAN DEFAULT FALSE,
    dano_sexual             BOOLEAN DEFAULT FALSE,

    -- INVESTIGACIÓN MINISTERIAL (hoja 3 FUD)
    denuncio_mp             BOOLEAN DEFAULT FALSE,
    fecha_denuncia_mp       DATE,
    competencia_mp          VARCHAR(10)  CHECK (competencia_mp IN ('federal', 'local')),
    entidad_mp              VARCHAR(60),
    delito_mp               VARCHAR(120),
    agencia_mp              VARCHAR(120),
    numero_averiguacion     VARCHAR(60),
    estado_investigacion    VARCHAR(80),

    -- PROCESO JUDICIAL (hoja 3 FUD)
    tiene_proceso_judicial  BOOLEAN DEFAULT FALSE,
    fecha_inicio_judicial   DATE,
    competencia_judicial    VARCHAR(10),
    entidad_judicial        VARCHAR(60),
    delito_judicial         VARCHAR(120),
    numero_juzgado          VARCHAR(60),
    numero_proceso          VARCHAR(60),
    estado_proceso          VARCHAR(80),

    -- SECCIÓN VIII: Vulnerabilidad (hoja 8 FUD)
    es_menor                BOOLEAN DEFAULT TRUE,
    nombre_tutor            VARCHAR(200),
    contacto_tutor          VARCHAR(120),
    tiene_discapacidad      BOOLEAN DEFAULT FALSE,
    tipo_discapacidad       VARCHAR(60)  CHECK (tipo_discapacidad IN (
                                'fisica', 'mental', 'intelectual', 'visual', 'auditiva'
                            )),
    grado_dependencia       VARCHAR(30)  CHECK (grado_dependencia IN (
                                'moderada', 'severa', 'gran_dependencia'
                            )),
    habla_espanol           BOOLEAN DEFAULT TRUE,
    requiere_traductor      BOOLEAN DEFAULT FALSE,
    idioma_lengua           VARCHAR(80),
    pertenece_indigena      BOOLEAN DEFAULT FALSE,
    comunidad_indigena      VARCHAR(100),
    tipo_violencia          VARCHAR(30)  CHECK (tipo_violencia IN (
                                'psicologica', 'fisica', 'economica',
                                'sexual', 'feminicida', 'otro'
                            )),

    -- SOLICITANTE (quién llenó el FUD — hoja 1)
    tipo_solicitante        VARCHAR(30)  CHECK (tipo_solicitante IN (
                                'victima', 'familiar', 'servidor_publico', 'representante'
                            )),
    nombre_solicitante      VARCHAR(200),
    parentesco_solicitante  VARCHAR(80),

    -- ESTATUS DEL EXPEDIENTE (propio del sistema — propuesta PETALO)
    estatus                 VARCHAR(20)  DEFAULT 'sin_proceso'
                                         CHECK (estatus IN ('sin_proceso', 'en_proceso', 'concluido')),
    fecha_ingreso           TIMESTAMP    DEFAULT NOW(),
    fecha_inicio_proceso    TIMESTAMP,
    fecha_cierre            TIMESTAMP,

    -- AUDITORÍA
    registrado_por          INTEGER REFERENCES personal(id),
    ultima_actualizacion    TIMESTAMP DEFAULT NOW()
);

-- ── ÍNDICES para búsqueda rápida ────────────────────────────
CREATE INDEX IF NOT EXISTS idx_nna_curp       ON nna(curp);
CREATE INDEX IF NOT EXISTS idx_nna_apellido   ON nna(primer_apellido);
CREATE INDEX IF NOT EXISTS idx_nna_estatus    ON nna(estatus);
CREATE INDEX IF NOT EXISTS idx_personal_rol   ON personal(rol);
CREATE INDEX IF NOT EXISTS idx_personal_estado ON personal(estado);
