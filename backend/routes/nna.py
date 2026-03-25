from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from typing import Optional
from database import get_connection
from routes.auth import verificar_token, solo_director

router = APIRouter()

# ── Modelo ───────────────────────────────────────────────────
class NNA(BaseModel):
    # Datos básicos (hoja 1 FUD)
    nombre: str
    primer_apellido: str
    segundo_apellido: Optional[str] = None
    fecha_nacimiento: Optional[str] = None
    sexo: Optional[str] = None
    nacionalidad: Optional[str] = None
    curp: Optional[str] = None
    lugar_nac_pais: Optional[str] = None
    lugar_nac_entidad: Optional[str] = None
    lugar_nac_municipio: Optional[str] = None
    lugar_nac_comunidad: Optional[str] = None
    estado_civil: Optional[str] = None
    # Domicilio
    calle: Optional[str] = None
    numero_exterior: Optional[str] = None
    numero_interior: Optional[str] = None
    colonia: Optional[str] = None
    codigo_postal: Optional[str] = None
    localidad: Optional[str] = None
    delegacion_municipio: Optional[str] = None
    entidad_federativa: Optional[str] = None
    telefono: Optional[str] = None
    # Tipo de víctima (hoja 2 FUD)
    tipo_victima: Optional[str] = None
    nombre_victima_directa: Optional[str] = None
    relacion_victima: Optional[str] = None
    # Relato de hechos
    lugar_hechos_calle: Optional[str] = None
    lugar_hechos_colonia: Optional[str] = None
    lugar_hechos_municipio: Optional[str] = None
    lugar_hechos_entidad: Optional[str] = None
    fecha_hechos: Optional[str] = None
    relato_hechos: Optional[str] = None
    # Daño (hoja 3 FUD)
    dano_fisico: Optional[bool] = False
    dano_psicologico: Optional[bool] = False
    dano_patrimonial: Optional[bool] = False
    dano_sexual: Optional[bool] = False
    # Investigación ministerial
    denuncio_mp: Optional[bool] = False
    fecha_denuncia_mp: Optional[str] = None
    competencia_mp: Optional[str] = None
    entidad_mp: Optional[str] = None
    delito_mp: Optional[str] = None
    agencia_mp: Optional[str] = None
    numero_averiguacion: Optional[str] = None
    estado_investigacion: Optional[str] = None
    # Proceso judicial
    tiene_proceso_judicial: Optional[bool] = False
    fecha_inicio_judicial: Optional[str] = None
    competencia_judicial: Optional[str] = None
    entidad_judicial: Optional[str] = None
    delito_judicial: Optional[str] = None
    numero_juzgado: Optional[str] = None
    numero_proceso: Optional[str] = None
    estado_proceso: Optional[str] = None
    # Vulnerabilidad (hoja 8 FUD)
    es_menor: Optional[bool] = True
    nombre_tutor: Optional[str] = None
    contacto_tutor: Optional[str] = None
    tiene_discapacidad: Optional[bool] = False
    tipo_discapacidad: Optional[str] = None
    grado_dependencia: Optional[str] = None
    habla_espanol: Optional[bool] = True
    requiere_traductor: Optional[bool] = False
    idioma_lengua: Optional[str] = None
    pertenece_indigena: Optional[bool] = False
    comunidad_indigena: Optional[str] = None
    tipo_violencia: Optional[str] = None
    # Solicitante
    tipo_solicitante: Optional[str] = None
    nombre_solicitante: Optional[str] = None
    parentesco_solicitante: Optional[str] = None

class CambiarEstatus(BaseModel):
    estatus: str

# ── Rutas ────────────────────────────────────────────────────

@router.get("/api/nna")
def listar_nna(usuario=Depends(verificar_token)):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("""
        SELECT id, nombre, primer_apellido, segundo_apellido,
               curp, tipo_victima, tipo_violencia,
               estatus, fecha_ingreso
        FROM nna
        ORDER BY fecha_ingreso DESC
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()
    cols = ["id","nombre","primer_apellido","segundo_apellido",
            "curp","tipo_victima","tipo_violencia","estatus","fecha_ingreso"]
    return [dict(zip(cols, r)) for r in rows]


@router.get("/api/nna/{id}")
def ver_nna(id: int, usuario=Depends(verificar_token)):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("SELECT * FROM nna WHERE id = %s", (id,))
    row = cur.fetchone()
    if not row:
        raise HTTPException(status_code=404, detail="Expediente no encontrado")
    cols = [desc[0] for desc in cur.description]
    cur.close()
    conn.close()
    return dict(zip(cols, row))


@router.post("/api/nna")
def crear_nna(data: NNA, usuario=Depends(verificar_token)):
    conn = get_connection()
    cur = conn.cursor()
    try:
        campos = data.dict()
        campos["registrado_por"] = usuario.get("id")
        keys = ", ".join(campos.keys())
        placeholders = ", ".join(["%s"] * len(campos))
        values = list(campos.values())
        cur.execute(f"INSERT INTO nna ({keys}) VALUES ({placeholders}) RETURNING id", values)
        nuevo_id = cur.fetchone()[0]
        conn.commit()
        return {"mensaje": "Expediente creado", "id": nuevo_id}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        cur.close()
        conn.close()


@router.put("/api/nna/{id}")
def editar_nna(id: int, data: NNA, usuario=Depends(verificar_token)):
    conn = get_connection()
    cur = conn.cursor()
    campos = {k: v for k, v in data.dict().items() if v is not None}
    if not campos:
        raise HTTPException(status_code=400, detail="No hay campos para actualizar")
    campos["ultima_actualizacion"] = "NOW()"
    sets = ", ".join([f"{k} = %s" for k in campos if k != "ultima_actualizacion"])
    sets += ", ultima_actualizacion = NOW()"
    valores = [v for k, v in campos.items() if k != "ultima_actualizacion"] + [id]
    cur.execute(f"UPDATE nna SET {sets} WHERE id = %s", valores)
    conn.commit()
    cur.close()
    conn.close()
    return {"mensaje": "Expediente actualizado"}


@router.put("/api/nna/{id}/estatus")
def cambiar_estatus(id: int, data: CambiarEstatus, usuario=Depends(verificar_token)):
    conn = get_connection()
    cur = conn.cursor()
    if data.estatus == "en_proceso":
        cur.execute("""
            UPDATE nna SET estatus = %s, fecha_inicio_proceso = NOW()
            WHERE id = %s
        """, (data.estatus, id))
    elif data.estatus == "concluido":
        cur.execute("""
            UPDATE nna SET estatus = %s, fecha_cierre = NOW()
            WHERE id = %s
        """, (data.estatus, id))
    else:
        cur.execute("UPDATE nna SET estatus = %s WHERE id = %s", (data.estatus, id))
    conn.commit()
    cur.close()
    conn.close()
    return {"mensaje": f"Estatus actualizado a {data.estatus}"}


@router.delete("/api/nna/{id}")
def eliminar_nna(id: int, usuario=Depends(solo_director)):
    conn = get_connection()
    cur = conn.cursor()
    cur.execute("DELETE FROM nna WHERE id = %s", (id,))
    conn.commit()
    cur.close()
    conn.close()
    return {"mensaje": "Expediente eliminado"}
