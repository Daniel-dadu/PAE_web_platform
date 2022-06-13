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
  "semestre" SMALLINT NOT NULL,
  "cantidadCambioHorario" SMALLINT NOT NULL,
  
  FOREIGN KEY ("idUsuario") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE
);

-- 3 --

CREATE TABLE "Carrera" (
  "idCarrera" VARCHAR(5) PRIMARY KEY,
  "nombreCarrera" VARCHAR(100) NOT NULL
);

-- 4 --

CREATE TABLE "EstudianteCarrera" (
  "idCarrera" VARCHAR(5) NOT NULL,
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
  "nombreUF" VARCHAR(100) NOT NULL,
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
  "idCarrera" VARCHAR(5) NOT NULL,

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
  "titulo" TEXT,
  "descripcion" TEXT,
  "rol" ROLES
);

-- 9 --

CREATE TYPE TIPOPREGUNTA AS ENUM ('abierta', 'cerrada');

CREATE TABLE "Pregunta" (
  "idPregunta" SERIAL PRIMARY KEY,
  "idEncuesta" INTEGER NOT NULL,
  "tipo" TIPOPREGUNTA,
  "pregunta" TEXT,
  "opcionesRespuesta" TEXT,

  FOREIGN KEY ("idEncuesta") 
  REFERENCES "Encuesta" ("idEncuesta")
  ON DELETE RESTRICT
);

-- 10 --

CREATE TYPE ESTADOENCUESTA AS ENUM ('pendiente', 'realizada', 'cancelada');

CREATE TABLE "CalificacionEncuesta" (
  "idCalificacionEncuesta" SERIAL PRIMARY KEY,
  "idEncuesta" INTEGER NOT NULL,
  "idAsesoria" INTEGER NOT NULL,
  "estado" ESTADOENCUESTA,
  "fotoEvidencia" TEXT,
  "fecha" TIMESTAMP NOT NULL,

  FOREIGN KEY ("idEncuesta") 
  REFERENCES "Encuesta" ("idEncuesta")
  ON DELETE RESTRICT,

  FOREIGN KEY ("idAsesoria") 
  REFERENCES "Asesoria" ("idAsesoria")
  ON DELETE CASCADE
);

-- 11 --

CREATE TABLE "CalificacionPregunta" (
  "idCalificacionPregunta" SERIAL PRIMARY KEY,
  "idCalificacionEncuesta" INTEGER NOT NULL,
  "idPregunta" INTEGER NOT NULL,
  "respuesta" TEXT,

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

CREATE TYPE STATUSASESORIA AS ENUM ('reservada', 'confirmada', 'finalizada', 'cancelada');
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

-- Función para actualizar la hora de últimaConexión del usuario al hacer el Login
-- regresa el rol del usuario, su imagen de perfil, su modo (claro/oscuro) e idioma (espanol/ingles)
-- Utilizada en el endpoint 'validateCredentials' de login
-- Esta se debe ejecutar de la siguiente: SELECT * FROM update_ultima_conexion('A01657967'); 

CREATE OR REPLACE FUNCTION update_ultima_conexion (idUsuario VARCHAR(10))
RETURNS TABLE (
  nombre_user TEXT,
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
    SELECT 
      CONCAT("nombreUsuario", ' ', "apellidoPaterno", ' ', "apellidoMaterno") AS nombre_user, 
      "rol" AS rol_user, 
      "fotoPerfil" AS foto_user, 
      "modoInterfaz" AS modo_user, 
      "lenguaje" AS idioma_user
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

-- Función que verifica que un día y hora tenga horarios disponibles y regresa sus id
-- EJEMPLO: SELECT * FROM verificar_horarios_disponibles('TC1028', 2022, 6, 8, 11);
CREATE OR REPLACE FUNCTION verificar_horarios_disponibles (
  idUF VARCHAR(50), 
  anio INTEGER, 
  mes INTEGER, 
  dia INTEGER, 
  hora INTEGER
)

RETURNS TABLE (idHorarioDisponible INTEGER)

LANGUAGE plpgsql AS $func$
  
BEGIN
  
  RETURN QUERY
    SELECT "idHorarioDisponible"
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
    AND EXTRACT(YEAR FROM "fechaHora") = anio
    AND EXTRACT(MONTH FROM "fechaHora") = mes
    AND EXTRACT(DAY FROM "fechaHora") = dia
    AND EXTRACT(HOUR FROM "fechaHora") = hora
    AND "status" = 'disponible';

END;
$func$;


-- FUNCION IMPORTANTE -- 
-- FUNCION para la creación de una nueva asesoría
-- Recibimos la UF, año, mes, dia, hora, idAsesorado (quien pide la asesoria), idHorarioDisponible (uno de los horarios disponibles recibidos en la llamada a verificar_horarios_disponibles) y la duda
-- Regresa el id de la asesoria creada para usarlo para insertar las imagenes
-- OJO: Esta funcion no guarda las imágenes en la tabla de asesoría imagen, es necesario que estas se guarden en otra consulta ya que si no, se hace muy largo el JSON del api request
CREATE OR REPLACE FUNCTION nueva_asesoria (
  idUF VARCHAR(50),
  anio INTEGER,
  mes INTEGER,
  dia INTEGER,
  hora INTEGER,
  idAsesorado VARCHAR(10),
  idHorarioDisponible INTEGER,
  duda TEXT
)

RETURNS INTEGER
  
LANGUAGE plpgsql AS
$func$

DECLARE
  idasesoria INTEGER;
  horarioreservado TIMESTAMP;
  nombreasesorado VARCHAR(100);
  idnuevanotificacion INTEGER;

BEGIN

  -- Actualizamos el status de los horarios disponibles para que se bloqueen
  UPDATE "HorarioDisponible" 
  SET "status" = 'bloqueada' 
  WHERE "idHorarioDisponible" IN (
    SELECT "idHorarioDisponible"
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
    AND EXTRACT(YEAR FROM "fechaHora") = anio
    AND EXTRACT(MONTH FROM "fechaHora") = mes
    AND EXTRACT(DAY FROM "fechaHora") = dia
    AND EXTRACT(HOUR FROM "fechaHora") = hora
    AND "status" = 'disponible'
  );

  -- Creamos la asesoría asignándole el asesor por defecto 
  -- IMPORTANTE: 
    -- el asesor correcto lo asignará un directivo de PAE
    -- el idHorarioDisponible asignado tampoco es correcto, ese depende del asesor que escoja PAE
  INSERT INTO "Asesoria" 
    ("idAsesoria", "idAsesor", "idAsesorado", "idUF", "status", "descripcionDuda", "lugar", "idHorarioDisponible")
  VALUES 
    (DEFAULT, 'A00000000', idAsesorado, idUF, 'reservada', duda, NULL, idHorarioDisponible)
  RETURNING "idAsesoria" INTO idasesoria;

  -- Creamos la notificación 
  SELECT "fechaHora" FROM "HorarioDisponible" WHERE "idHorarioDisponible" = idHorarioDisponible INTO horarioreservado;
  SELECT CONCAT("nombreUsuario", ' ', "apellidoPaterno") FROM "Usuario" WHERE "idUsuario" = idAsesorado INTO nombreasesorado;
  INSERT INTO "Notificacion" 
    ("idNotificacion", "origen", "titulo", "fechaHora", "descripcion")
  VALUES
    (DEFAULT, 'Asesoria reservada', 'Nueva solicitud de asesoria', horarioreservado, 
    CONCAT('El alumno ', nombreasesorado, ' con matrícula ', idAsesorado, ' ha solicitado una asesoría.'))
  RETURNING "idNotificacion" INTO idnuevanotificacion;

  -- Relacionamos la notificación con ese asesorado
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesorado);

  -- Relacionamos la notificación con todos los directivos
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  SELECT notificacion.idnuevanotificacion, directivos."idUsuario"
  FROM 
    (SELECT idnuevanotificacion) notificacion, 
    (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'directivo') directivos;

  -- Se regresa el ID de la asesoria para saber en qué asesoría insertar las imágenes
  RETURN idasesoria;
  
END
$func$;

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

-- FUNCION PARA OBTENER LA INFORMACION DE PERFIL DE UN USUARIO DEPENDIENDO DE SU ROL
CREATE OR REPLACE FUNCTION get_info_perfil (idUsuario VARCHAR(10), rol ROLES)
RETURNS TABLE (
  nombreUsuario VARCHAR(100), 
  telefonoUsuario VARCHAR(10),
  carreraUsuario1 VARCHAR(5),
  carreraUsuario2 VARCHAR(5),
  semestreUsuario SMALLINT
)

LANGUAGE plpgsql AS $func$

DECLARE
  nombrecompleto VARCHAR(100); 
  telefonouser VARCHAR(10); 
  cantidadcarreras INTEGER; 
  primeracarrera VARCHAR(5);
  segundacarrera VARCHAR(5);
  semestreuser SMALLINT;

BEGIN

  SELECT CONCAT("nombreUsuario", ' ', "apellidoPaterno") FROM "Usuario" WHERE "idUsuario" = idUsuario INTO nombrecompleto;
  SELECT "telefono" FROM "Usuario" WHERE "idUsuario" = idUsuario INTO telefonouser;
  SELECT '' INTO primeracarrera;
  SELECT '' INTO segundacarrera;
  SELECT 0 INTO semestreuser; 

  IF rol <> 'directivo' THEN
    SELECT COUNT(*) FROM "EstudianteCarrera" WHERE "idUsuario" = idUsuario INTO cantidadcarreras;
    SELECT "idCarrera" FROM "EstudianteCarrera" WHERE "idUsuario" = idUsuario LIMIT 1 INTO primeracarrera;
  
    IF cantidadcarreras = 2 THEN
      SELECT "idCarrera" FROM "EstudianteCarrera" WHERE "idUsuario" = idUsuario AND "idCarrera" <> primeracarrera INTO segundacarrera;
    END IF;
  
    IF rol = 'asesor' THEN 
      SELECT "semestre" FROM "Asesor" WHERE "idUsuario" = idUsuario INTO semestreuser;
    END IF;
  END IF;
  
  RETURN QUERY
    SELECT nombrecompleto, telefonouser, primeracarrera, segundacarrera, semestreuser;

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
    AND "Asesoria"."idAsesor" = "Usuario"."idUsuario"
    AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anio
    AND "Asesoria"."status" != 'reservada'
    AND "Asesoria"."idAsesor" != 'A00000000';

END;
$func$;

SELECT * FROM get_allAsesorias(2, 2022);
DROP FUNCTION get_allAsesorias;

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
  image TEXT,
  status STATUSASESORIA
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
            AND "Asesoria"."idAsesoria" = (
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
        ) AS usuario,
        "Asesoria"."lugar",
        "UnidadFormacion"."nombreUF",
        "Asesoria"."descripcionDuda",
        "AsesoriaImagen"."imagen",
        "Asesoria"."status"
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
            AND "Asesoria"."idAsesoria" = (
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
        ) AS usuario,
        "Asesoria"."lugar",
        "UnidadFormacion"."nombreUF",
        "Asesoria"."descripcionDuda",
        NULL AS image,
        "Asesoria"."status"
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

-- FUNCION PARA OBTENER INFORMACIÓN DE UNA RESPUESTA DE UNA ENCUESTA
CREATE OR REPLACE FUNCTION get_info_encuesta(idasesoria INTEGER, matricula VARCHAR(10), roluser ROLES)
RETURNS TABLE (
  idencuesta INTEGER, 
  tituloencuesta TEXT, 
  descripcionencuesta TEXT,
  fotoe TEXT
)
LANGUAGE plpgsql AS $func$

DECLARE
  encuesta INTEGER;
  foto TEXT;
  
BEGIN

  SELECT "idEncuesta" INTO encuesta FROM "Encuesta" WHERE "rol" = roluser;  

  SELECT "fotoEvidencia" INTO foto FROM "CalificacionEncuesta" WHERE "idEncuesta" = encuesta AND "idAsesoria" = idasesoria;

  RETURN QUERY
    SELECT "idEncuesta", "titulo", "descripcion", foto FROM "Encuesta" WHERE "idEncuesta" = encuesta;

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

-- Obtención de las asesorías de un usuario a partir de su ID, dia, mes y año
CREATE OR REPLACE FUNCTION get_asesoriasAsesorDia(
  dia INTEGER,
  mes INTEGER,
  anio INTEGER
)
RETURNS TABLE (
  nombreAsesor TEXT,
  matricula VARCHAR(10),
  claveUF VARCHAR(50),
  horaAsesoria DOUBLE PRECISION,
  contenido STATUSASESORIA
)
LANGUAGE plpgsql AS $func$

BEGIN

  RETURN QUERY
    SELECT
      CONCAT("Usuario"."nombreUsuario", ' ', "Usuario"."apellidoPaterno", ' ', "Usuario"."apellidoMaterno") AS nombreAsesor,
      "Asesoria"."idAsesor" AS matricula,
      "Asesoria"."idUF" AS claveUF,
      EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") AS horaAsesoria,
      "Asesoria"."status" AS contenido
    FROM "Asesoria", "HorarioDisponible", "Usuario"
    WHERE "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
    AND "Asesoria"."idAsesor" = "Usuario"."idUsuario"
    AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = dia
    AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anio
    AND "Asesoria"."idAsesor" != 'A00000000';

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
  carreraUsr VARCHAR(5)
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

-- Procedimiento para hacer el registro de los datos de perfil del asesor
-- Este no incluye en registro de su horario ni sus UFs en las que dará asesoría
CREATE OR REPLACE PROCEDURE registro_datosperfil_asesor(
  matriculaUsr VARCHAR(10), 
  passwordUsr TEXT, 
  saltUsr VARCHAR(16), 
  nombreUsr VARCHAR(50),
  apellidoPaternoUsr VARCHAR(30),
  apellidoMaternoUsr VARCHAR(30),
  fotoPerfilUsr TEXT,
  telefonoUsr VARCHAR(10),
  carreraUsr VARCHAR(5),
  carrera2Usr VARCHAR(5),
  semestreUsr INT
)
LANGUAGE plpgsql AS
$$
BEGIN
  
  INSERT INTO "Usuario" 
    ("idUsuario", "rol", "nombreUsuario", "apellidoPaterno", "fotoPerfil", "ultimaConexion", "statusAcceso", "telefono", "apellidoMaterno")
  VALUES 
    (matriculaUsr, 'asesor', nombreUsr, apellidoPaternoUsr, fotoPerfilUsr, CURRENT_TIMESTAMP, 'activo', telefonoUsr, apellidoMaternoUsr);
  
  INSERT INTO "Acceso" ("idUsuario", "password", "salt") VALUES 
    (matriculaUsr, passwordUsr, saltUsr);

  INSERT INTO "Asesor" ("idUsuario","semestre","cantidadCambioHorario") VALUES
    (matriculaUsr, semestreUsr, 0);

  INSERT INTO "EstudianteCarrera" ("idCarrera", "idUsuario") VALUES
    (carreraUsr, matriculaUsr);
  
  IF carrera2Usr <> '' THEN 
    INSERT INTO "EstudianteCarrera" ("idCarrera" ,"idUsuario") VALUES 
      (carrera2Usr, matriculaUsr);
  END IF;

  INSERT INTO "Preferencia" ("idUsuario", "modoInterfaz", "lenguaje", "subscripcionCorreo") VALUES
    (matriculaUsr, 'claro', 'espanol', TRUE);

END
$$;


-- Procedimiento para la actualización de la información de perfil de un usuario
CREATE OR REPLACE PROCEDURE update_info_perfil(
  idUsr VARCHAR(10), 
  rolUsr ROLES,
  fotoUsr TEXT,
  telefonoUsr VARCHAR(10),
  carrera1 VARCHAR(5),
  carrera2 VARCHAR(5)
)
LANGUAGE plpgsql AS
$$
BEGIN
  
  UPDATE "Usuario" SET "fotoPerfil" = fotoUsr, "ultimaConexion" = CURRENT_TIMESTAMP, "telefono" = telefonoUsr WHERE "idUsuario" = idUsr;

  IF rolUsr <> 'directivo' THEN 
    DELETE FROM "EstudianteCarrera" WHERE "idUsuario" = idUsr;
  
    INSERT INTO "EstudianteCarrera" ("idCarrera" ,"idUsuario") VALUES (carrera1, idUsr);
    
    IF carrera2 <> '' THEN 
      INSERT INTO "EstudianteCarrera" ("idCarrera" ,"idUsuario") VALUES (carrera2, idUsr);
    END IF;
    
  END IF;

END
$$;

-- PROCEDIMIENTO PARA EL REGISTRO DE UN DIRECTIVO
CREATE OR REPLACE PROCEDURE registro_directivo(
  matriculaUsr VARCHAR(10), 
  passwordUsr TEXT, 
  saltUsr VARCHAR(16), 
  nombreUsr VARCHAR(50),
  apellidoPaternoUsr VARCHAR(30),
  apellidoMaternoUsr VARCHAR(30),
  fotoPerfilUsr TEXT,
  telefonoUsr VARCHAR(10)
)
LANGUAGE plpgsql AS
$$
BEGIN
  INSERT INTO "Usuario" 
    ("idUsuario", "rol", "nombreUsuario", "apellidoPaterno", "fotoPerfil", "ultimaConexion", "statusAcceso", "telefono", "apellidoMaterno")
  VALUES 
    (matriculaUsr, 'directivo', nombreUsr, apellidoPaternoUsr, fotoPerfilUsr, CURRENT_TIMESTAMP, 'activo', telefonoUsr, apellidoMaternoUsr);
  INSERT INTO "Acceso" ("idUsuario", "password", "salt") VALUES 
    (matriculaUsr, passwordUsr, saltUsr);
  INSERT INTO "Preferencia" ("idUsuario", "modoInterfaz", "lenguaje", "subscripcionCorreo") VALUES
    (matriculaUsr, 'claro', 'espanol', TRUE);
END
$$;

-- Aceptación de asesoría
CREATE OR REPLACE PROCEDURE aceptarAsesoria(
  idAsesor VARCHAR(10),
  nombreUF VARCHAR(100),
  idAsesorado VARCHAR(10),
  hora INTEGER,
  dia INTEGER,
  mes INTEGER,
  anio INTEGER,
  lugarAsesoria TEXT
)
LANGUAGE plpgsql AS
$$

DECLARE
  idAsesoriaC INTEGER;
  horarioreservado TIMESTAMP;
  nombreasesorado VARCHAR(100);
  idnuevanotificacion INTEGER;
  idhorariodisponible INTEGER;
  idnotificacionsolicitud INTEGER;

BEGIN

  -- Obtención del ID de la asesoría
  SELECT "Asesoria"."idAsesoria"
  FROM "Asesoria", "HorarioDisponible", "Usuario", "UnidadFormacion"
  WHERE
    "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
    AND "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
    AND "Asesoria"."idUF" = "UnidadFormacion"."idUF"
    AND "Usuario"."idUsuario" = idAsesorado
    AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = hora
    AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = dia
    AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anio
  INTO idAsesoriaC;

  -- Actualización del ID del asesor
  UPDATE "Asesoria" 
  SET "idAsesor" = idAsesor 
  WHERE "idAsesoria" = idAsesoriaC;

  -- Actualización del ID del horario disponible, correspondiente al asesor
  UPDATE "Asesoria" 
  SET "idHorarioDisponible" = (
    SELECT "idHorarioDisponible"
    FROM "HorarioDisponible" 
    WHERE "idHorarioDisponiblePeriodo" IN (
      SELECT "idHorarioDisponiblePeriodo" 
      FROM "HorarioDisponiblePeriodo" 
      WHERE "idAsesor" = idAsesor
    )
    AND EXTRACT(YEAR FROM "fechaHora") = anio
    AND EXTRACT(MONTH FROM "fechaHora") = mes
    AND EXTRACT(DAY FROM "fechaHora") = dia
    AND EXTRACT(HOUR FROM "fechaHora") = hora
    AND "status" = 'bloqueada'
  )
  WHERE "idAsesoria" = idAsesoriaC;

  -- Guardado del ID del horario disponible, correspondiente al asesor

  SELECT "idHorarioDisponible"
  FROM "HorarioDisponible" 
  WHERE "idHorarioDisponiblePeriodo" IN (
    SELECT "idHorarioDisponiblePeriodo" 
    FROM "HorarioDisponiblePeriodo" 
    WHERE "idAsesor" = idAsesor
  )
  AND EXTRACT(YEAR FROM "fechaHora") = anio
  AND EXTRACT(MONTH FROM "fechaHora") = mes
  AND EXTRACT(DAY FROM "fechaHora") = dia
  AND EXTRACT(HOUR FROM "fechaHora") = hora
  AND "status" = 'bloqueada'
  INTO idhorariodisponible;

  -- Actualización del status de la asesoría
  UPDATE "Asesoria" 
  SET "status" = 'confirmada' 
  WHERE "idAsesoria" = idAsesoriaC;

  -- Actualización del lugar de la asesoría
  UPDATE "Asesoria" 
  SET "lugar" = lugarAsesoria
  WHERE "idAsesoria" = idAsesoriaC;

  -- Actualización del status del horario disponible del asesor
  UPDATE "HorarioDisponible" 
  SET "status" = 'reservada' 
  WHERE "idHorarioDisponiblePeriodo" IN (
    SELECT "idHorarioDisponiblePeriodo" 
    FROM "HorarioDisponiblePeriodo" 
    WHERE "idAsesor" = idAsesor
  )
  AND EXTRACT(YEAR FROM "fechaHora") = anio
  AND EXTRACT(MONTH FROM "fechaHora") = mes
  AND EXTRACT(DAY FROM "fechaHora") = dia
  AND EXTRACT(HOUR FROM "fechaHora") = hora
  AND "status" = 'bloqueada';

  -- Actualización del status de los horarios disponibles del resto de asesores (desbloqueo)
  UPDATE "HorarioDisponible" 
  SET "status" = 'disponible' 
  WHERE "idHorarioDisponible" IN (
    SELECT "idHorarioDisponible"
    FROM "HorarioDisponible" 
    WHERE "idHorarioDisponiblePeriodo" IN (
      SELECT "idHorarioDisponiblePeriodo" 
      FROM "HorarioDisponiblePeriodo" 
      WHERE "idAsesor" IN (
        SELECT "idUsuario" 
        FROM "AsesorUnidadFormacion"
        WHERE "AsesorUnidadFormacion"."idUF" = (
          SELECT "idUF"
          FROM "UnidadFormacion"
          WHERE "nombreUF" = nombreUF
        )
        AND "idUsuario" != idAsesor
      )
    ) 
    AND EXTRACT(YEAR FROM "fechaHora") = anio
    AND EXTRACT(MONTH FROM "fechaHora") = mes
    AND EXTRACT(DAY FROM "fechaHora") = dia
    AND EXTRACT(HOUR FROM "fechaHora") = hora
    AND "status" = 'bloqueada'
  );

  -- Creación de la notificación de la confirmación de la asesoría
  SELECT "fechaHora" FROM "HorarioDisponible" WHERE "idHorarioDisponible" = idHorarioDisponible INTO horarioreservado;
  SELECT CONCAT("nombreUsuario", ' ', "apellidoPaterno") FROM "Usuario" WHERE "idUsuario" = idAsesorado INTO nombreasesorado;
  INSERT INTO "Notificacion" 
    ("idNotificacion", "origen", "titulo", "fechaHora", "descripcion")
  VALUES
    (DEFAULT, 'Asesoria confirmada', 'Nueva confirmación de asesoria', horarioreservado, 
    CONCAT('El alumno ', nombreasesorado, ' con matrícula ', idAsesorado, ' tiene confirmada una nueva asesoría.'))
  RETURNING "idNotificacion" INTO idnuevanotificacion;

  -- Relación de la notificación con el asesorado
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesorado);

  -- Relación de la notificación con el asesor
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesor);

  -- Relación de la notificación con todos los directivos
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  SELECT notificacion.idnuevanotificacion, directivos."idUsuario"
  FROM 
    (SELECT idnuevanotificacion) notificacion, 
    (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'directivo') directivos;

  -- Eliminación de la notificación de solicitud de asesoría (creada cuando se agendó la asesoría que se acaba de aceptar)

  SELECT "Notificacion"."idNotificacion"
  FROM "NotificacionUsuario", "Notificacion", "Usuario"
  WHERE
    "NotificacionUsuario"."idNotificacion" = "Notificacion"."idNotificacion"
    AND "NotificacionUsuario"."idUsuario" = "Usuario"."idUsuario"
    AND "Notificacion"."origen" = 'Asesoria reservada'
    AND "NotificacionUsuario"."idUsuario" = idAsesorado
    AND EXTRACT(HOUR FROM "Notificacion"."fechaHora") = hora
    AND EXTRACT(DAY FROM "Notificacion"."fechaHora") = dia
    AND EXTRACT(MONTH FROM "Notificacion"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "Notificacion"."fechaHora") = anio
  INTO idnotificacionsolicitud;

  DELETE FROM "NotificacionUsuario"
  WHERE "NotificacionUsuario"."idNotificacion" = idnotificacionsolicitud;

  DELETE FROM "Notificacion"
  WHERE "idNotificacion" = idnotificacionsolicitud;
  
END
$$;

-- Cancelación de asesoría
CREATE OR REPLACE PROCEDURE cancelarAsesoria(
  nombreUF VARCHAR(100),
  idAsesorado VARCHAR(10),
  hora INTEGER,
  dia INTEGER,
  mes INTEGER,
  anio INTEGER
)
LANGUAGE plpgsql AS
$$

DECLARE
  idAsesoriaC INTEGER;
  horarioreservado TIMESTAMP;
  nombreasesorado VARCHAR(100);
  idnuevanotificacion INTEGER;
  idnotificacionsolicitud INTEGER;
  idAsesor VARCHAR(10);

BEGIN

  -- Obtención del ID de la asesoría
  SELECT "Asesoria"."idAsesoria"
  FROM "Asesoria", "HorarioDisponible", "Usuario", "UnidadFormacion"
  WHERE
    "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
    AND "Asesoria"."idAsesorado" = "Usuario"."idUsuario"
    AND "Asesoria"."idUF" = "UnidadFormacion"."idUF"
    AND "Usuario"."idUsuario" = idAsesorado
    AND EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") = hora
    AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = dia
    AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anio
  INTO idAsesoriaC;

  -- Obtención del ID del asesor
  SELECT "idAsesor"
  FROM "Asesoria"
  WHERE "idAsesoria" = idAsesoriaC
  INTO idAsesor;
  
  -- Actualización del status de la asesoría
  UPDATE "Asesoria" 
  SET "status" = 'cancelada' 
  WHERE "idAsesoria" = idAsesoriaC;

  -- Actualización del status de los horarios disponibles de los de asesores (desbloqueo)
  UPDATE "HorarioDisponible" 
  SET "status" = 'disponible' 
  WHERE "idHorarioDisponible" IN (
    SELECT "idHorarioDisponible"
    FROM "HorarioDisponible" 
    WHERE "idHorarioDisponiblePeriodo" IN (
      SELECT "idHorarioDisponiblePeriodo" 
      FROM "HorarioDisponiblePeriodo" 
      WHERE "idAsesor" IN (
        SELECT "idUsuario" 
        FROM "AsesorUnidadFormacion"
        WHERE "AsesorUnidadFormacion"."idUF" = (
          SELECT "idUF"
          FROM "UnidadFormacion"
          WHERE "nombreUF" = nombreUF
        )
      )
    ) 
    AND EXTRACT(YEAR FROM "fechaHora") = anio
    AND EXTRACT(MONTH FROM "fechaHora") = mes
    AND EXTRACT(DAY FROM "fechaHora") = dia
    AND EXTRACT(HOUR FROM "fechaHora") = hora
    AND "status" = 'bloqueada'
  );
  
  -- Creación de la notificación de la cancelación de la asesoría
  SELECT "fechaHora"
  FROM "HorarioDisponible"
  WHERE
    EXTRACT(YEAR FROM "fechaHora") = anio
    AND EXTRACT(MONTH FROM "fechaHora") = mes
    AND EXTRACT(DAY FROM "fechaHora") = dia
    AND EXTRACT(HOUR FROM "fechaHora") = hora
  INTO horarioreservado;

  SELECT CONCAT("nombreUsuario", ' ', "apellidoPaterno") FROM "Usuario" WHERE "idUsuario" = idAsesorado INTO nombreasesorado;
  INSERT INTO "Notificacion" 
    ("idNotificacion", "origen", "titulo", "fechaHora", "descripcion")
  VALUES
    (DEFAULT, 'Asesoria cancelada', 'Nueva cancelación de asesoria', horarioreservado, 
    CONCAT('El alumno ', nombreasesorado, ' con matrícula ', idAsesorado, ' tiene cancelada una asesoría.'))
  RETURNING "idNotificacion" INTO idnuevanotificacion;

  -- Relación de la notificación con el asesorado
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesorado);

  -- Relación de la notificación con el asesor
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesor);

  -- Relación de la notificación con todos los directivos
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  SELECT notificacion.idnuevanotificacion, directivos."idUsuario"
  FROM 
    (SELECT idnuevanotificacion) notificacion, 
    (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'directivo') directivos;

  -- Eliminación de la notificación de solicitud de asesoría (creada cuando se agendó la asesoría que se acaba de cancelar)

  SELECT "Notificacion"."idNotificacion"
  FROM "NotificacionUsuario", "Notificacion", "Usuario"
  WHERE
    "NotificacionUsuario"."idNotificacion" = "Notificacion"."idNotificacion"
    AND "NotificacionUsuario"."idUsuario" = "Usuario"."idUsuario"
    AND "Notificacion"."origen" = 'Asesoria reservada'
    AND "NotificacionUsuario"."idUsuario" = idAsesorado
    AND EXTRACT(HOUR FROM "Notificacion"."fechaHora") = hora
    AND EXTRACT(DAY FROM "Notificacion"."fechaHora") = dia
    AND EXTRACT(MONTH FROM "Notificacion"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "Notificacion"."fechaHora") = anio
  INTO idnotificacionsolicitud;

  DELETE FROM "NotificacionUsuario"
  WHERE "NotificacionUsuario"."idNotificacion" = idnotificacionsolicitud;

  DELETE FROM "Notificacion"
  WHERE "idNotificacion" = idnotificacionsolicitud;
  
END
$$;

-- Envío de notificaciones
CREATE OR REPLACE PROCEDURE enviarNotificaciones(
  destinatario TEXT,
  asunto VARCHAR(200),
  mensaje TEXT
)
LANGUAGE plpgsql AS
$$

DECLARE
  idnuevanotificacion INTEGER;
  
BEGIN

-- Creación de la notificación
  INSERT INTO "Notificacion" 
    ("idNotificacion", "origen", "titulo", "fechaHora", "descripcion")
  VALUES
    (DEFAULT, 'PAE', asunto, NOW()::TIMESTAMP, mensaje)
  RETURNING "idNotificacion" INTO idnuevanotificacion;

  IF destinatario = 'TODOS' THEN

    -- Relación de la notificación con todos los asesorados
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, asesorados."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesorado') asesorados;
  
    -- Relación de la notificación con todos los asesores
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, asesores."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesor') asesores;
  
    -- Relación de la notificación con todos los directivos
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, directivos."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'directivo') directivos;

  ELSEIF destinatario = 'ESTUDIANTES' THEN

    -- Relación de la notificación con todos los asesorados
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, asesorados."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesorado') asesorados;

  ELSE

    -- Relación de la notificación con todos los asesores
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, asesores."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesor') asesores;

  END IF;
  
END
$$;

------------ VIEWS -----------------

-- Para consultar los usuarios sin mostrar su texto largo de fotoPerfil 
-- Se puede consultar ejecutando la query: SELECT * FROM usuarios; 

CREATE VIEW usuarios AS SELECT "idUsuario", "rol", "nombreUsuario", "apellidoPaterno", "apellidoMaterno", "telefono", "ultimaConexion", "statusAcceso" FROM "Usuario";



------------ INSERTS QUE DEBEN INGRESARSE POR DEFECT -----------------

-- INSERTANDO ENCUESTA DE ASESOR
INSERT INTO "Encuesta" ("idEncuesta", "titulo", "descripcion", "rol") VALUES 
  (DEFAULT, 'Encuesta post-asesoría para ASESORES', '¡Hola! Gracias por tu trabajo en PAE. Recuerda que llenar esta encuesta es importante ya que las respuestas son las que contarán como asesorías impartidas. No olvides que debes subir una foto como evidencia de la asesoría.', 'asesor');
-- Insertando preguntas para asesores
INSERT INTO "Pregunta" ("idPregunta","idEncuesta","tipo","pregunta","opcionesRespuesta") VALUES
  (DEFAULT, 1, 'cerrada', '¿La asesoría se llevó a cabo en la materia indicada?', 'Sí,No'),
  (DEFAULT, 1, 'cerrada', '¿El asesorado fue puntual?', 'Sí,No'),
  (DEFAULT, 1, 'cerrada', '¿Cuánto tiempo (en minutos) duró la asesoría?', '20,30,40,45,más de 50'),
  (DEFAULT, 1, 'abierta', '¿Tienes algún comentario extra sobre la asesoría?', NULL);

-- INSERTANDO ENCUESTA DE ASESORADO
INSERT INTO "Encuesta" ("idEncuesta", "titulo", "descripcion", "rol") VALUES 
  (DEFAULT, 'Encuesta post-asesoría para ESTUDIANTES', 'Gracias por utilizar PAE, la retroalimentación que nos das nos sirve mucho para mejorar en las próximas asesorías', 'asesorado');
-- Insertando preguntas para asesorados
INSERT INTO "Pregunta" ("idPregunta","idEncuesta","tipo","pregunta","opcionesRespuesta") VALUES
  (DEFAULT, 2, 'cerrada', '¿El asesor fue puntual?', 'Sí,No'),
  (DEFAULT, 2, 'cerrada', '¿Qué tal claro fue tu asesor?', '1,2,3,4,5'),
  (DEFAULT, 2, 'cerrada', '¿El asesor brindó los ejemplos necesarios para aclarar tus dudas?', '1,2,3,4,5'),
  (DEFAULT, 2, 'cerrada', '¿El asesor brindó la atención necesaria durante la asesoría?', '1,2,3,4,5'),
  (DEFAULT, 2, 'cerrada', '¿Qué tanto dominio del tema tiene asesor?', '1,2,3,4,5'),
  (DEFAULT, 2, 'abierta', '¿Tienes algún comentario extra sobre la asesoría?', NULL);



---------------- IMPORTANTE ------------------

-- Es necesario implementar los triggers para:
--  > el cambio de status del horario de disponiblidad de los asesores cuando apartan
--  > el cambio de status de los periodos
--  > el cambio de status de los usuarios
