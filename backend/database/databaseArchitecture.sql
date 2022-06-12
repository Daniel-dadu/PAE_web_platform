--Se utiliza la variante femenina para los adjetivos
--ejemplo: asesoria cancelada

CREATE TYPE ROLES AS ENUM ('asesor', 'asesorado', 'directivo');
CREATE TYPE STATUSACCESS AS ENUM ('activo', 'inactivo');

-- 1 --

CREATE TABLE "Usuario" (
  "idUsuario" VARCHAR(10) PRIMARY KEY,
  "rol" ROLES,
  "nombreUsuario" VARCHAR(50) NOT NULL,
  "apellidoPaterno" VARCHAR(30) NOT NULL,
  "fotoPerfil" TEXT,
  "ultimaConexion" TIMESTAMP,
  "statusAcceso" STATUSACCESS,
  "telefono" VARCHAR(10),
  "apellidoMaterno" VARCHAR(30)
);

-- 1.1 --

CREATE TABLE "Acceso" (
  "idUsuario" VARCHAR(10) NOT NULL,
  "password" TEXT NOT NULL,
  "salt" VARCHAR(16) NOT NULL, -- String random para mayor seguridad

  FOREIGN KEY ("idUsuario") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE
);

-- 2 --

CREATE TABLE "Asesor" (
  "idUsuario" VARCHAR(10) NOT NULL,
  "carrera" SMALLINT NOT NULL,
  "semestre" SMALLINT NOT NULL,
  "cantidadCambioHorario" SMALLINT NOT NULL,
  
  FOREIGN KEY ("idUsuario") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE
);

-- 3 --

CREATE TABLE "Carrera" (
  "idCarrera" VARCHAR(3) PRIMARY KEY,
  "nombreCarrera" VARCHAR(50) NOT NULL
);

-- 4 --

CREATE TABLE "EstudianteCarrera" (
  "idCarrera" VARCHAR(3) NOT NULL,
  "idUsuario" VARCHAR(10) NOT NULL,

  FOREIGN KEY ("idCarrera") 
  REFERENCES "Carrera" ("idCarrera")
  ON DELETE CASCADE,

  FOREIGN KEY ("idUsuario") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE
);

-- 5 --

CREATE TABLE "UnidadFormacion" (
  "idUF" VARCHAR(50) PRIMARY KEY,
  "nombreUF" VARCHAR(50) NOT NULL,
  "semestre" SMALLINT NOT NULL
);

-- 6 --

CREATE TABLE "AsesorUnidadFormacion" (
  "idUsuario" VARCHAR(10) NOT NULL,
  "idUF" VARCHAR(50) NOT NULL,

  FOREIGN KEY ("idUsuario") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE,

  FOREIGN KEY ("idUF") 
  REFERENCES "UnidadFormacion" ("idUF")
  ON DELETE CASCADE
);

-- 7 --

CREATE TABLE "UnidadFormacionCarrera" (
  "idUF" VARCHAR(50) NOT NULL,
  "idCarrera" VARCHAR(3) NOT NULL,

  FOREIGN KEY ("idUF") 
  REFERENCES "UnidadFormacion" ("idUF")
  ON DELETE CASCADE,

  FOREIGN KEY ("idCarrera") 
  REFERENCES "Carrera" ("idCarrera")
  ON DELETE CASCADE
);

-- 8 --

CREATE TABLE "Encuesta" (
  "idEncuesta" SERIAL PRIMARY KEY,
  "titulo" VARCHAR(200),
  "descripcion" VARCHAR(200),
  "rol" ROLES
);

-- 9 --

CREATE TYPE TIPOPREGUNTA AS ENUM ('abierta', 'cerrada');

CREATE TABLE "Pregunta" (
  "idPregunta" SERIAL PRIMARY KEY,
  "idEncuesta" INTEGER NOT NULL,
  "tipo" TIPOPREGUNTA,
  "pregunta" VARCHAR(100),
  "opcionesRespuesta" json,

  FOREIGN KEY ("idEncuesta") 
  REFERENCES "Encuesta" ("idEncuesta")
  ON DELETE RESTRICT
);

-- 10 --

CREATE TYPE ESTADOENCUESTA AS ENUM ('pendiente', 'realizada', 'cancelada');

CREATE TABLE "CalificacionEncuesta" (
  "idCalificacionEncuesta" SERIAL PRIMARY KEY,
  "idEncuesta" INTEGER NOT NULL,
  "estado" ESTADOENCUESTA,
  "idAsesor" VARCHAR(10) NOT NULL,
  "idAsesorado" VARCHAR(10) NOT NULL,
  "evidencia" TEXT,
  "fecha" TIMESTAMP NOT NULL,

  FOREIGN KEY ("idEncuesta") 
  REFERENCES "Encuesta" ("idEncuesta")
  ON DELETE RESTRICT,

  FOREIGN KEY ("idAsesor") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE,
  
  FOREIGN KEY ("idAsesorado") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE
);

-- 11 --

CREATE TABLE "CalificacionPregunta" (
  "idCalificacionPregunta" SERIAL PRIMARY KEY,
  "idCalificacionEncuesta" INTEGER NOT NULL,
  "idPregunta" INTEGER NOT NULL,
  "respuesta" VARCHAR(200),

  FOREIGN KEY ("idCalificacionEncuesta") 
  REFERENCES "CalificacionEncuesta" ("idCalificacionEncuesta")
  ON DELETE CASCADE,
  
  FOREIGN KEY ("idPregunta") 
  REFERENCES "Pregunta" ("idPregunta")
  ON DELETE RESTRICT
);

-- 12 --

CREATE TYPE MODO AS ENUM ('claro', 'oscuro');
CREATE TYPE IDIOMA AS ENUM ('espanol', 'ingles');

CREATE TABLE "Preferencia" (
  "idUsuario" VARCHAR(10) NOT NULL,
  "modoInterfaz" MODO,
  "lenguaje" IDIOMA,
  "subscripcionCorreo" BOOLEAN,
    
  FOREIGN KEY ("idUsuario") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE
);

-- 13 --

CREATE TYPE STATUSPERIODO AS ENUM ('actual', 'pasado');

CREATE TABLE "Periodo" (
  "idPeriodo" SERIAL PRIMARY KEY,
  "numero" SMALLINT NOT NULL,
  "fechaInicial" TIMESTAMP NOT NULL,
  "fechaFinal" TIMESTAMP NOT NULL,
  "status" STATUSPERIODO NOT NULL
);

-- 14 --

CREATE TABLE "HorarioDisponiblePeriodo" (
  "idHorarioDisponiblePeriodo" SERIAL PRIMARY KEY,
  "idAsesor" VARCHAR(10) NOT NULL,
  "idPeriodo" INTEGER NOT NULL,

  FOREIGN KEY ("idAsesor") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE,

  FOREIGN KEY ("idPeriodo") 
  REFERENCES "Periodo" ("idPeriodo")
  ON DELETE CASCADE
);

-- 15 --

CREATE TYPE STATUSHORARIO AS ENUM ('disponible', 'bloqueada', 'reservada', 'finalizada');

CREATE TABLE "HorarioDisponible" (
  "idHorarioDisponible" SERIAL PRIMARY KEY,
  "idHorarioDisponiblePeriodo" INTEGER NOT NULL,
  "fechaHora" TIMESTAMP NOT NULL,
  "status" STATUSHORARIO NOT NULL,

  FOREIGN KEY ("idHorarioDisponiblePeriodo") 
  REFERENCES "HorarioDisponiblePeriodo" ("idHorarioDisponiblePeriodo")
  ON DELETE CASCADE
);

-- 16 --

CREATE TYPE STATUSASESORIA AS ENUM ('registrando', 'reservada', 'confirmada', 'finalizada', 'cancelada');
-- registrando es cuando el usuario está llenando los datos en el front pero no ha confirmado su reserva
-- reservada es antes de la confirmación de PAE
-- confirmada es después de la confirmación de PAE
-- cancelada es cuando el asesor/asesorado cancelo la asesoria o PAE ha rechazado la solicitud

CREATE TABLE "Asesoria" (
  "idAsesoria" SERIAL PRIMARY KEY,
  "idAsesor" VARCHAR(10) NOT NULL,
  "idAsesorado" VARCHAR(10) NOT NULL,
  "idUF" VARCHAR(50) NOT NULL,
  "status" STATUSASESORIA NOT NULL,
  "descripcionDuda" TEXT,
  "lugar" TEXT,
  "idHorarioDisponible" INTEGER NOT NULL,

  FOREIGN KEY ("idAsesor") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE,
  
  FOREIGN KEY ("idAsesorado") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE,

  FOREIGN KEY ("idUF") 
  REFERENCES "UnidadFormacion" ("idUF")
  ON DELETE CASCADE,
  
  FOREIGN KEY ("idHorarioDisponible") 
  REFERENCES "HorarioDisponible" ("idHorarioDisponible")
  ON DELETE CASCADE
);

-- 17 --

CREATE TABLE "AsesoriaImagen" (
  "idAsesoria" INTEGER NOT NULL,
  "imagen" TEXT,

  FOREIGN KEY ("idAsesoria")
  REFERENCES "Asesoria" ("idAsesoria")
  ON DELETE CASCADE
);

-- 18 --

CREATE TYPE STATUSPOLITICA AS ENUM ('vigente', 'deprecado', 'en revision');

CREATE TABLE "Politica" (
  "idPolitica" SERIAL PRIMARY KEY,
  "titulo" VARCHAR(50) NOT NULL,
  "descripcion" TEXT,
  "fechaCreacion" TIMESTAMP NOT NULL,
  "fechaUltimoCambio" TIMESTAMP NOT NULL,
  "status" STATUSPOLITICA NOT NULL
);

-- 19 --

CREATE TABLE "PoliticaDocumento" (
  "idPolitica" INTEGER NOT NULL,
  "titulo" VARCHAR(50) NOT NULL,
  "documento" TEXT NOT NULL,

  FOREIGN KEY ("idPolitica") 
  REFERENCES "Politica" ("idPolitica")
  ON DELETE CASCADE
);

-- 20 --

CREATE TYPE ORIGENNOTIFICACION AS ENUM ('Asesoria reservada', 'Asesoria confirmada', 'Asesoria cancelada', 'PAE');
-- Asesoria reservada es para confirmar la peticion de una asesoria antes de la confirmación de PAE
-- Asesoria confirmada es para informar de la confirmación de PAE para la asesoria
-- Asesoria cancelada es cuando el asesor/asesorado cancelo la asesoria o PAE ha rechazado la solicitud

CREATE TABLE "Notificacion" (
  "idNotificacion" SERIAL PRIMARY KEY,
  "origen" ORIGENNOTIFICACION NOT NULL,
  "titulo" VARCHAR(200),
  "fechaHora" TIMESTAMP NOT NULL,
  "descripcion" TEXT
);

-- 21 --

CREATE TABLE "NotificacionUsuario" (
  "idNotificacion" INTEGER NOT NULL,
  "idUsuario" VARCHAR(10) NOT NULL,

  FOREIGN KEY ("idNotificacion") 
  REFERENCES "Notificacion" ("idNotificacion")
  ON DELETE CASCADE,
  
  FOREIGN KEY ("idUsuario") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE
);

-- 22 --

CREATE TABLE "Profesor" (
  "idProfesor" SERIAL PRIMARY KEY,
  "nombre" VARCHAR(50) NOT NULL,
  "correo" VARCHAR(50) NOT NULL
);

-- 23 --

CREATE TABLE "ProfesorUnidadFormacion" (
  "idProfesor" INTEGER NOT NULL,
  "idUF" VARCHAR(50) NOT NULL,

  FOREIGN KEY ("idProfesor") 
  REFERENCES "Profesor" ("idProfesor")
  ON DELETE CASCADE,
  
  FOREIGN KEY ("idUF") 
  REFERENCES "UnidadFormacion" ("idUF")
  ON DELETE CASCADE
);

------------ FUNCIÓN -----------------

-- Función para crear una asesoría a partir de un asesorado y uf
-- Se debe ejecutar en la primera pantalla de AgendarAsesoría, cuando el asesorado escoge la UF
-- Esta regresa el Id de la nueva asesoría creada

CREATE OR REPLACE FUNCTION new_asesoria (idAsesorado VARCHAR(10), idUF VARCHAR(50))
RETURNS INTEGER AS $id$
DECLARE
	id INTEGER;
  randomasesor VARCHAR(10);
BEGIN
  
  SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesor' LIMIT 1 INTO randomasesor;
  INSERT INTO "Asesoria" VALUES 
    (DEFAULT, randomasesor, idAsesorado, idUF, 'registrando', null, null, 1);
  SELECT "idAsesoria" into id FROM "Asesoria" ORDER BY "idAsesoria" DESC LIMIT 1;
  RETURN id;

END;
$id$ LANGUAGE plpgsql;

-- Función para actualizar la hora de últimaConexión del usuario al hacer el Login
-- regresa el rol del usuario, su imagen de perfil, su modo (claro/oscuro) e idioma (espanol/ingles)
-- Utilizada en el endpoint 'validateCredentials' de login
-- Esta se debe ejecutar de la siguiente: SELECT * FROM update_ultima_conexion('A01657967'); 

CREATE OR REPLACE FUNCTION update_ultima_conexion (idUsuario VARCHAR(10))
RETURNS TABLE (
  rol_user ROLES,
  foto_user TEXT,
  modo_user MODO,
  idioma_user IDIOMA
)
LANGUAGE plpgsql AS 
$func$
BEGIN
  
  UPDATE "Usuario" SET "ultimaConexion" = CURRENT_TIMESTAMP WHERE "idUsuario" = idUsuario;
  RETURN QUERY
    SELECT "rol" AS rol_user, "fotoPerfil" AS foto_user, "modoInterfaz" AS modo_user, "lenguaje" AS idioma_user
    FROM "Usuario", "Preferencia"
    WHERE "Usuario"."idUsuario" = "Preferencia"."idUsuario" AND "Usuario"."idUsuario" = idUsuario;

END
$func$;

-- A partir de una UF, un mes y un año, se deben buscar los horarios disponibles de esas características
CREATE OR REPLACE FUNCTION get_dias_disponibles (idUF VARCHAR(50), anio INTEGER, mes INTEGER)
RETURNS TABLE (dias_disponibles DOUBLE PRECISION)

LANGUAGE plpgsql AS $func$
  
BEGIN
  
  RETURN QUERY
    SELECT DISTINCT EXTRACT(DAY FROM "fechaHora") AS dias
    FROM "HorarioDisponible" 
    WHERE "idHorarioDisponiblePeriodo" IN (
      SELECT "idHorarioDisponiblePeriodo" 
      FROM "HorarioDisponiblePeriodo" 
      WHERE "idAsesor" IN (
        SELECT "idUsuario" 
        FROM "AsesorUnidadFormacion"   
        WHERE "AsesorUnidadFormacion"."idUF" = idUF
      )
    ) 
    AND "status" = 'disponible'
    AND EXTRACT(YEAR FROM "fechaHora") = anio
    AND EXTRACT(MONTH FROM "fechaHora") = mes;

END;
$func$;

-- Función que regresa el mes de inicio y mes de cierre de semestre
-- Este solo toma en cuenta los periodos con status actual, por lo que usa el semestre actual
CREATE OR REPLACE FUNCTION get_meses_inicio_fin_semestre ()
RETURNS TABLE (
  mes_inicio_semestre DOUBLE PRECISION, 
  mes_fin_semestre DOUBLE PRECISION
)

LANGUAGE plpgsql AS $func$

DECLARE
  mes_inicio_semestre DOUBLE PRECISION;
  mes_fin_semestre DOUBLE PRECISION;

BEGIN

  SELECT EXTRACT(MONTH FROM "fechaInicial") 
  FROM "Periodo" 
  WHERE "status" = 'actual' AND "numero" = 1 
  INTO mes_inicio_semestre;

  SELECT EXTRACT(MONTH FROM "fechaFinal") 
  FROM "Periodo" 
  WHERE "status" = 'actual' AND "numero" = 3
  INTO mes_fin_semestre;
  
  RETURN QUERY
    SELECT mes_inicio_semestre, mes_fin_semestre;

END;
$func$;

-- A partir de una UF, un mes, un año y día, se deben buscar las horas disponibles de esas características
CREATE OR REPLACE FUNCTION get_horas_disponibles (idUF VARCHAR(50), anio INTEGER, mes INTEGER, dia INTEGER)
RETURNS TABLE (horas_disponibles DOUBLE PRECISION)

LANGUAGE plpgsql AS $func$
  
BEGIN
  
  RETURN QUERY
    SELECT DISTINCT EXTRACT(HOUR FROM "fechaHora") AS horas
    FROM "HorarioDisponible" 
    WHERE "idHorarioDisponiblePeriodo" IN (
      SELECT "idHorarioDisponiblePeriodo" 
      FROM "HorarioDisponiblePeriodo" 
      WHERE "idAsesor" IN (
        SELECT "idUsuario" 
        FROM "AsesorUnidadFormacion"   
        WHERE "AsesorUnidadFormacion"."idUF" = idUF
      )
    ) 
    AND "status" = 'disponible'
    AND EXTRACT(YEAR FROM "fechaHora") = anio
    AND EXTRACT(MONTH FROM "fechaHora") = mes
    AND EXTRACT(DAY FROM "fechaHora") = dia;

END;
$func$;

------------ FUNCIÓN -----------------

-- Obtención de las notificaciones de un usuario a partir de su ID
CREATE OR REPLACE FUNCTION get_notificaciones_usuario(
  idUsuario VARCHAR(10)
)
RETURNS TABLE (
  origen ORIGENNOTIFICACION,
  titulo VARCHAR(200),
  leyenda TIMESTAMP,
  contenido TEXT
)
LANGUAGE plpgsql AS $func$

BEGIN

  RETURN QUERY
    SELECT
      "Notificacion"."origen",
      "Notificacion"."titulo",
      "Notificacion"."fechaHora" AS leyenda,
      "Notificacion"."descripcion" AS contenido
    FROM "NotificacionUsuario", "Notificacion", "Usuario"
    WHERE "NotificacionUsuario"."idNotificacion" = "Notificacion"."idNotificacion"
    AND "NotificacionUsuario"."idUsuario" = "Usuario"."idUsuario"
    AND "Usuario"."idUsuario" = idUsuario;

END;
$func$;

-- Obtención de las asesorías de un usuario a partir de su ID, mes y año
CREATE OR REPLACE FUNCTION get_asesorias_usuario(
  idUsuario VARCHAR(10),
  mes INTEGER,
  anio INTEGER
)
RETURNS TABLE (
  numeroDia DOUBLE PRECISION,
  status STATUSASESORIA,
  hora DOUBLE PRECISION
)
LANGUAGE plpgsql AS $func$

BEGIN

  RETURN QUERY
    SELECT
      EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") AS numeroDia,
      "Asesoria"."status",
      EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") AS hora
    FROM "Asesoria", "HorarioDisponible", "Usuario"
    WHERE "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
    AND (
      "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
      "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
    )
    AND "Usuario"."idUsuario" = idUsuario
    AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anio;

END;
$func$;

-- Obtención de las asesorías de todos los usuarios
CREATE OR REPLACE FUNCTION get_allAsesorias(
  mes INTEGER,
  anio INTEGER
)
RETURNS TABLE (
  numeroDia DOUBLE PRECISION,
  status STATUSASESORIA,
  hora DOUBLE PRECISION
)
LANGUAGE plpgsql AS $func$

BEGIN

  RETURN QUERY
    SELECT
      EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") AS numeroDia,
      "Asesoria"."status",
      EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") AS hora
    FROM "Asesoria", "HorarioDisponible", "Usuario"
    WHERE "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
    AND (
      "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
      "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
    )
    AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anio;

END;
$func$;

-- Obtención de la información de una asesoría, a partir del idUsuario, día, mes, anio
CREATE OR REPLACE FUNCTION get_informacionAsesoria(
  idUsuario VARCHAR(10),
  horaC INTEGER,
  diaC INTEGER,
  mesC INTEGER,
  anioC INTEGER
)
RETURNS TABLE (
  hora DOUBLE PRECISION,
  dia DOUBLE PRECISION,
  mes DOUBLE PRECISION,
  anio DOUBLE PRECISION,
  usuario TEXT,
  lugar TEXT,
  uF VARCHAR(100),
  duda TEXT,
  image TEXT
)
LANGUAGE plpgsql AS $func$

BEGIN
  
  IF (
      SELECT COUNT("AsesoriaImagen"."imagen")
      FROM "Asesoria", "AsesoriaImagen", "HorarioDisponible", "Usuario", "UnidadFormacion"
      WHERE
        "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
        AND (
          "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
          "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
        )
        AND "Asesoria"."idUF" = "UnidadFormacion"."idUF"
        AND "AsesoriaImagen"."idAsesoria" = (
          SELECT "Asesoria"."idAsesoria"
            FROM "Asesoria", "HorarioDisponible", "Usuario", "UnidadFormacion"
            WHERE "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
            AND (
              "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
              "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
            )
            AND "Asesoria"."idUF" = "UnidadFormacion"."idUF"
            AND "Usuario"."idUsuario" = idUsuario
            AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = horaC
            AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = diaC
            AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mesC
            AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anioC
        )
        AND "Usuario"."idUsuario" = idUsuario
        AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = horaC
        AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = diaC
        AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mesC
        AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anioC
    ) > 0 then
    RETURN QUERY
      SELECT
        EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") AS hora,
        EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") AS dia,
        EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") AS mes,
        EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") AS anio,
        (
          SELECT CONCAT("Usuario"."nombreUsuario", ' ', "Usuario"."apellidoPaterno", ' ', "Usuario"."apellidoMaterno", ' - ', "Usuario"."idUsuario")
          FROM "Asesoria", "HorarioDisponible", "Usuario"
          WHERE
            (
              "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
              "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
            )
            AND "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
            AND "Usuario"."idUsuario" != idUsuario
            AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = horaC
            AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = diaC
            AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mesC
            AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anioC
        ) AS usuario,
        "Asesoria"."lugar",
        "UnidadFormacion"."nombreUF",
        "Asesoria"."descripcionDuda",
        "AsesoriaImagen"."imagen"
      FROM "Asesoria", "AsesoriaImagen", "HorarioDisponible", "Usuario", "UnidadFormacion"
      WHERE
        "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
        AND (
          "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
          "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
        )
        AND "Asesoria"."idUF" = "UnidadFormacion"."idUF"
        AND "AsesoriaImagen"."idAsesoria" = (
          SELECT "Asesoria"."idAsesoria"
            FROM "Asesoria", "HorarioDisponible", "Usuario", "UnidadFormacion"
            WHERE "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
            AND (
              "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
              "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
            )
            AND "Asesoria"."idUF" = "UnidadFormacion"."idUF"
            AND "Usuario"."idUsuario" = idUsuario
            AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = horaC
            AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = diaC
            AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mesC
            AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anioC
        )
        AND "Usuario"."idUsuario" = idUsuario
        AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = horaC
        AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = diaC
        AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mesC
        AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anioC;
  ELSE
    RETURN QUERY
      SELECT
        EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") AS hora,
        EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") AS dia,
        EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") AS mes,
        EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") AS anio,
        (
          SELECT CONCAT("Usuario"."nombreUsuario", ' ', "Usuario"."apellidoPaterno", ' ', "Usuario"."apellidoMaterno", ' - ', "Usuario"."idUsuario")
          FROM "Asesoria", "HorarioDisponible", "Usuario"
          WHERE
            (
              "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
              "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
            )
            AND "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
            AND "Usuario"."idUsuario" != idUsuario
            AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = horaC
            AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = diaC
            AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mesC
            AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anioC
        ) AS usuario,
        "Asesoria"."lugar",
        "UnidadFormacion"."nombreUF",
        "Asesoria"."descripcionDuda",
        NULL AS image
      FROM "Asesoria", "HorarioDisponible", "Usuario", "UnidadFormacion"
      WHERE
        "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
        AND (
          "Asesoria"."idAsesor" = "Usuario"."idUsuario" OR
          "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
        )
        AND "Asesoria"."idUF" = "UnidadFormacion"."idUF"
        AND "Usuario"."idUsuario" = idUsuario
        AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = horaC
        AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = diaC
        AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mesC
        AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anioC;
  END IF;

END;
$func$;

-- Obtención de los asesores que están disponibles para dar una asesoría, a partir de una hora, día, mes y año
CREATE OR REPLACE FUNCTION get_asesoresDisponibles(
  hora INTEGER,
  dia INTEGER,
  mes INTEGER,
  anio INTEGER,
  nombreUF VARCHAR(100)
)
RETURNS TABLE (
  matricula VARCHAR(10),
  nombre TEXT
)
LANGUAGE plpgsql AS $func$

BEGIN

  RETURN QUERY
    SELECT
      "Asesor"."idUsuario" AS matricula,
      CONCAT("Usuario"."nombreUsuario", ' ', "Usuario"."apellidoPaterno", ' ', "Usuario"."apellidoMaterno") AS nombre
    FROM "HorarioDisponible", "HorarioDisponiblePeriodo", "Asesor", "Usuario", "AsesorUnidadFormacion", "UnidadFormacion"
    WHERE "HorarioDisponible"."idHorarioDisponiblePeriodo" = "HorarioDisponiblePeriodo"."idHorarioDisponiblePeriodo"
    AND "HorarioDisponiblePeriodo"."idAsesor" = "Asesor"."idUsuario"
    AND "Asesor"."idUsuario" = "Usuario"."idUsuario"
    AND "AsesorUnidadFormacion"."idUsuario" = "Usuario"."idUsuario"
    AND "AsesorUnidadFormacion"."idUF" = "UnidadFormacion"."idUF"
    AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anio
    AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mes
    AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = dia
    AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = hora
    AND "UnidadFormacion"."idUF" = (
      SELECT "idUF"
      FROM "UnidadFormacion"
      WHERE "nombreUF" = nombreUF
    )
    AND "HorarioDisponible"."status" = 'bloqueada';
    

END;
$func$;

------------ PROCEDURES ---------------

-- Procedimiento para hacer el registro de un asesorado
-- Se usa en las pantallas de Registro de Asesorados

CREATE OR REPLACE PROCEDURE registro_asesorado(
  matriculaUsr VARCHAR(10), 
  passwordUsr TEXT, 
  saltUsr VARCHAR(16), 
  nombreUsr VARCHAR(50),
  apellidoPaternoUsr VARCHAR(30),
  apellidoMaternoUsr VARCHAR(30),
  fotoPerfilUsr TEXT,
  telefonoUsr VARCHAR(10),
  carreraUsr VARCHAR(3)
)
LANGUAGE plpgsql AS
$$
BEGIN
  INSERT INTO "Usuario" 
    ("idUsuario", "rol", "nombreUsuario", "apellidoPaterno", "fotoPerfil", "ultimaConexion", "statusAcceso", "telefono", "apellidoMaterno")
  VALUES 
    (matriculaUsr, 'asesorado', nombreUsr, apellidoPaternoUsr, fotoPerfilUsr, CURRENT_TIMESTAMP, 'activo', telefonoUsr, apellidoMaternoUsr);
  INSERT INTO "Acceso" ("idUsuario", "password", "salt") VALUES 
    (matriculaUsr, passwordUsr, saltUsr);
  INSERT INTO "EstudianteCarrera" ("idCarrera", "idUsuario") VALUES
    (carreraUsr, matriculaUsr);
  INSERT INTO "Preferencia" ("idUsuario", "modoInterfaz", "lenguaje", "subscripcionCorreo") VALUES
    (matriculaUsr, 'claro', 'espanol', TRUE);
END
$$;

------------ VIEWS -----------------

-- Para consultar los usuarios sin mostrar su texto largo de fotoPerfil 
-- Se puede consultar ejecutando la query: SELECT * FROM usuarios; 

CREATE VIEW usuarios AS SELECT "idUsuario", "rol", "nombreUsuario", "apellidoPaterno", "apellidoMaterno", "telefono", "ultimaConexion", "statusAcceso" FROM "Usuario";


---------------- IMPORTANTE ------------------

-- Es necesario implementar los triggers para:
--  > el cambio de status del horario de disponiblidad de los asesores cuando apartan
--  > el cambio de status de los periodos
--  > el cambio de status de los usuarios