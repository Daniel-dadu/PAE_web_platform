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

-- 5.1 --

CREATE TYPE STATUSASESORIA AS ENUM ('reservada', 'confirmada', 'finalizada', 'cancelada');
-- reservada es antes de la confirmaci??n de PAE
-- confirmada es despu??s de la confirmaci??n de PAE
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

-- 16 --

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
-- Asesoria reservada es para confirmar la peticion de una asesoria antes de la confirmaci??n de PAE
-- Asesoria confirmada es para informar de la confirmaci??n de PAE para la asesoria
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

------------ FUNCI??N -----------------

-- Funci??n para actualizar la hora de ??ltimaConexi??n del usuario al hacer el Login
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

-- A partir de una UF, un mes y un a??o, se deben buscar los horarios disponibles de esas caracter??sticas
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

-- Funci??n que regresa el mes de inicio y mes de cierre de semestre
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

-- A partir de una UF, un mes, un a??o y d??a, se deben buscar las horas disponibles de esas caracter??sticas
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

-- Funci??n que verifica que un d??a y hora tenga horarios disponibles y regresa sus id
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
-- FUNCION para la creaci??n de una nueva asesor??a
-- Recibimos la UF, a??o, mes, dia, hora, idAsesorado (quien pide la asesoria), idHorarioDisponible (uno de los horarios disponibles recibidos en la llamada a verificar_horarios_disponibles) y la duda
-- Regresa el id de la asesoria creada para usarlo para insertar las imagenes
-- OJO: Esta funcion no guarda las im??genes en la tabla de asesor??a imagen, es necesario que estas se guarden en otra consulta ya que si no, se hace muy largo el JSON del api request
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

  -- Creamos la asesor??a asign??ndole el asesor por defecto 
  -- IMPORTANTE: 
    -- el asesor correcto lo asignar?? un directivo de PAE
    -- el idHorarioDisponible asignado tampoco es correcto, ese depende del asesor que escoja PAE
  INSERT INTO "Asesoria" 
    ("idAsesoria", "idAsesor", "idAsesorado", "idUF", "status", "descripcionDuda", "lugar", "idHorarioDisponible")
  VALUES 
    (DEFAULT, 'A00000000', idAsesorado, idUF, 'reservada', duda, NULL, idHorarioDisponible)
  RETURNING "idAsesoria" INTO idasesoria;

  -- Creamos la notificaci??n 
  SELECT "fechaHora" FROM "HorarioDisponible" WHERE "idHorarioDisponible" = idHorarioDisponible INTO horarioreservado;
  SELECT CONCAT("nombreUsuario", ' ', "apellidoPaterno") FROM "Usuario" WHERE "idUsuario" = idAsesorado INTO nombreasesorado;
  INSERT INTO "Notificacion" 
    ("idNotificacion", "origen", "titulo", "fechaHora", "descripcion")
  VALUES
    (DEFAULT, 'Asesoria reservada', 'Nueva solicitud de asesoria', horarioreservado, 
    CONCAT('El alumno ', nombreasesorado, ' con matr??cula ', idAsesorado, ' ha solicitado una asesor??a.'))
  RETURNING "idNotificacion" INTO idnuevanotificacion;

  -- Relacionamos la notificaci??n con ese asesorado
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesorado);

  -- Relacionamos la notificaci??n con todos los directivos
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  SELECT notificacion.idnuevanotificacion, directivos."idUsuario"
  FROM 
    (SELECT idnuevanotificacion) notificacion, 
    (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'directivo') directivos;

  -- Se regresa el ID de la asesoria para saber en qu?? asesor??a insertar las im??genes
  RETURN idasesoria;
  
END
$func$;

-- Obtenci??n de las notificaciones de un usuario a partir de su ID
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

-- Obtenci??n de las asesor??as de un usuario a partir de su ID, mes y a??o
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

-- Obtenci??n de las asesor??as de todos los usuarios
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

-- Obtenci??n de la informaci??n de una asesor??a, a partir del idUsuario, d??a, mes, anio
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

-- FUNCION PARA OBTENER INFORMACI??N DE UNA RESPUESTA DE UNA ENCUESTA
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

-- Obtenci??n de los asesores que est??n disponibles para dar una asesor??a, a partir de una hora, d??a, mes y a??o
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

-- Obtenci??n de las asesor??as de un usuario a partir de su ID, dia, mes y a??o
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
-- Este no incluye en registro de su horario ni sus UFs en las que dar?? asesor??a
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


-- Procedimiento para la actualizaci??n de la informaci??n de perfil de un usuario
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

-- Aceptaci??n de asesor??a
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

  -- Obtenci??n del ID de la asesor??a
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

  -- Actualizaci??n del ID del asesor
  UPDATE "Asesoria" 
  SET "idAsesor" = idAsesor 
  WHERE "idAsesoria" = idAsesoriaC;

  -- Actualizaci??n del ID del horario disponible, correspondiente al asesor
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

  -- Actualizaci??n del status de la asesor??a
  UPDATE "Asesoria" 
  SET "status" = 'confirmada' 
  WHERE "idAsesoria" = idAsesoriaC;

  -- Actualizaci??n del lugar de la asesor??a
  UPDATE "Asesoria" 
  SET "lugar" = lugarAsesoria
  WHERE "idAsesoria" = idAsesoriaC;

  -- Actualizaci??n del status del horario disponible del asesor
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

  -- Actualizaci??n del status de los horarios disponibles del resto de asesores (desbloqueo)
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

  -- Creaci??n de la notificaci??n de la confirmaci??n de la asesor??a
  SELECT "fechaHora" FROM "HorarioDisponible" WHERE "idHorarioDisponible" = idHorarioDisponible INTO horarioreservado;
  SELECT CONCAT("nombreUsuario", ' ', "apellidoPaterno") FROM "Usuario" WHERE "idUsuario" = idAsesorado INTO nombreasesorado;
  INSERT INTO "Notificacion" 
    ("idNotificacion", "origen", "titulo", "fechaHora", "descripcion")
  VALUES
    (DEFAULT, 'Asesoria confirmada', 'Nueva confirmaci??n de asesoria', horarioreservado, 
    CONCAT('El alumno ', nombreasesorado, ' con matr??cula ', idAsesorado, ' tiene confirmada una nueva asesor??a.'))
  RETURNING "idNotificacion" INTO idnuevanotificacion;

  -- Relaci??n de la notificaci??n con el asesorado
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesorado);

  -- Relaci??n de la notificaci??n con el asesor
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesor);

  -- Relaci??n de la notificaci??n con todos los directivos
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  SELECT notificacion.idnuevanotificacion, directivos."idUsuario"
  FROM 
    (SELECT idnuevanotificacion) notificacion, 
    (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'directivo') directivos;

  -- Eliminaci??n de la notificaci??n de solicitud de asesor??a (creada cuando se agend?? la asesor??a que se acaba de aceptar)

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

-- Cancelaci??n de asesor??a
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

  -- Obtenci??n del ID de la asesor??a
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

  -- Obtenci??n del ID del asesor
  SELECT "idAsesor"
  FROM "Asesoria"
  WHERE "idAsesoria" = idAsesoriaC
  INTO idAsesor;
  
  -- Actualizaci??n del status de la asesor??a
  UPDATE "Asesoria" 
  SET "status" = 'cancelada' 
  WHERE "idAsesoria" = idAsesoriaC;

  -- Actualizaci??n del status de los horarios disponibles de los de asesores (desbloqueo)
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
  
  -- Creaci??n de la notificaci??n de la cancelaci??n de la asesor??a
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
    (DEFAULT, 'Asesoria cancelada', 'Nueva cancelaci??n de asesoria', horarioreservado, 
    CONCAT('El alumno ', nombreasesorado, ' con matr??cula ', idAsesorado, ' tiene cancelada una asesor??a.'))
  RETURNING "idNotificacion" INTO idnuevanotificacion;

  -- Relaci??n de la notificaci??n con el asesorado
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesorado);

  -- Relaci??n de la notificaci??n con el asesor
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  VALUES
    (idnuevanotificacion, idAsesor);

  -- Relaci??n de la notificaci??n con todos los directivos
  INSERT INTO "NotificacionUsuario" 
    ("idNotificacion", "idUsuario")
  SELECT notificacion.idnuevanotificacion, directivos."idUsuario"
  FROM 
    (SELECT idnuevanotificacion) notificacion, 
    (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'directivo') directivos;

  -- Eliminaci??n de la notificaci??n de solicitud de asesor??a (creada cuando se agend?? la asesor??a que se acaba de cancelar)

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

-- EnviarNotificacionDirectivos
-- Env??o de notificaciones
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

  -- Creaci??n de la notificaci??n
  INSERT INTO "Notificacion" 
    ("idNotificacion", "origen", "titulo", "fechaHora", "descripcion")
  VALUES
    (DEFAULT, 'PAE', asunto, NOW()::TIMESTAMP, mensaje)
  RETURNING "idNotificacion" INTO idnuevanotificacion;

  IF destinatario = 'TODOS' THEN

    -- Relaci??n de la notificaci??n con todos los asesorados
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, asesorados."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesorado') asesorados;
  
    -- Relaci??n de la notificaci??n con todos los asesores
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, asesores."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesor') asesores;
  
    -- Relaci??n de la notificaci??n con todos los directivos
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, directivos."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'directivo') directivos;

  ELSEIF destinatario = 'ESTUDIANTES' THEN

    -- Relaci??n de la notificaci??n con todos los asesorados
    INSERT INTO "NotificacionUsuario" 
      ("idNotificacion", "idUsuario")
    SELECT notificacion.idnuevanotificacion, asesorados."idUsuario"
    FROM 
      (SELECT idnuevanotificacion) notificacion, 
      (SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesorado') asesorados;

  ELSE

    -- Relaci??n de la notificaci??n con todos los asesores
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
  (DEFAULT, 'Encuesta post-asesor??a para ASESORES', '??Hola! Gracias por tu trabajo en PAE. Recuerda que llenar esta encuesta es importante ya que las respuestas son las que contar??n como asesor??as impartidas. No olvides que debes subir una foto como evidencia de la asesor??a.', 'asesor');
-- Insertando preguntas para asesores
INSERT INTO "Pregunta" ("idPregunta","idEncuesta","tipo","pregunta","opcionesRespuesta") VALUES
  (DEFAULT, 1, 'cerrada', '??La asesor??a se llev?? a cabo en la materia indicada?', 'S??,No'),
  (DEFAULT, 1, 'cerrada', '??El asesorado fue puntual?', 'S??,No'),
  (DEFAULT, 1, 'cerrada', '??Cu??nto tiempo (en minutos) dur?? la asesor??a?', '20,30,40,45,m??s de 50'),
  (DEFAULT, 1, 'abierta', '??Tienes alg??n comentario extra sobre la asesor??a?', NULL);

-- INSERTANDO ENCUESTA DE ASESORADO
INSERT INTO "Encuesta" ("idEncuesta", "titulo", "descripcion", "rol") VALUES 
  (DEFAULT, 'Encuesta post-asesor??a para ESTUDIANTES', 'Gracias por utilizar PAE, la retroalimentaci??n que nos das nos sirve mucho para mejorar en las pr??ximas asesor??as', 'asesorado');
-- Insertando preguntas para asesorados
INSERT INTO "Pregunta" ("idPregunta","idEncuesta","tipo","pregunta","opcionesRespuesta") VALUES
  (DEFAULT, 2, 'cerrada', '??El asesor fue puntual?', 'S??,No'),
  (DEFAULT, 2, 'cerrada', '??Qu?? tal claro fue tu asesor?', '1,2,3,4,5'),
  (DEFAULT, 2, 'cerrada', '??El asesor brind?? los ejemplos necesarios para aclarar tus dudas?', '1,2,3,4,5'),
  (DEFAULT, 2, 'cerrada', '??El asesor brind?? la atenci??n necesaria durante la asesor??a?', '1,2,3,4,5'),
  (DEFAULT, 2, 'cerrada', '??Qu?? tanto dominio del tema tiene asesor?', '1,2,3,4,5'),
  (DEFAULT, 2, 'abierta', '??Tienes alg??n comentario extra sobre la asesor??a?', NULL);

-- INSERTANDO LAS CARRERAS

INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ITC', 'Ingenier??a en Tecnolog??as Computacionales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IBT', 'Ingenier??a en Biotecnolog??a');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IMT', 'Ingenier??a en Mecatr??nica');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('AMC', 'Ambiente Construido/ Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ESC', 'Estudios Creativos / Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ARQ', 'Arquitecto');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LAD', 'Licenciado en Arte Digital');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LDI', 'Licenciado en Dise??o');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LUB', 'Licenciado en Urbanismo');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('CIS', 'Derecho, Econom??a y Relaciones Internacionales / Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LEC', 'Licenciado en Econom??a');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LED', 'Licenciado en Derecho');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LRI', 'Licenciado en Relaciones Internacionales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LTP', 'Licenciado en Gobierno y Transformaci??n P??blica');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LC', 'Licenciado en Comunicaci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LEI', 'Licenciado en Innovaci??n Educativa');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LLE', 'Licenciado en Letras Hisp??nicas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LPE', 'Licenciado en Periodismo');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LTM', 'Licenciado en Tecnolog??a y Producci??n Musical');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IBQ', 'Ingenier??a - Bioingenier??a y Procesos Qu??micos (avenida) / Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IAG', 'Ingeniero en Biosistemas Agroalimentarios');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IAL', 'Ingeniero en Alimentos');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IDS', 'Ingeniero en Desarrollo Sustentable');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IQ', 'Ingeniero Qu??mico');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ICI', 'Ingenier??a - Ciencias Aplicadas (avenida) / Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IDM', 'Ingeniero en Ciencia de Datos y Matem??ticas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IFI', 'Ingeniero F??sico Industrial');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('INA', 'Ingeniero en Nanotecnolog??a');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ICT', 'Ingenier??a - Computaci??n y Tecnolog??as de Informaci??n (avenida) / Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IRS', 'Ingeniero en Rob??tica y Sistemas Digitales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ITD', 'Ingeniero en Transformaci??n Digital de Negocios');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IIT', 'Ingenier??a - Innovaci??n y Transformaci??n (avenida) / Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('BIE', 'Ingeniero Industrial y de Sistemas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('BME', 'Ingeniero en Mecatr??nica');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IC', 'Ingeniero Civil');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IE', 'Ingeniero en Electr??nica');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IID', 'Ingeniero en Innovaci??n y Desarrollo');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IIS', 'Ingeniero Industrial y de Sistemas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IM', 'Ingeniero Mec??nico');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IMD', 'Ingeniero Biom??dico');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('SLD', 'Salud / Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LBC', 'Licenciado en Biociencias');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LNB', 'Licenciado en Nutrici??n y Bienestar Integral');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LPS', 'Licenciado en Psicolog??a Cl??nica y de la Salud');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('MC', 'M??dico Cirujano');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('MO', 'M??dico Cirujano Odont??logo');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('NEG', 'Negocios / Exploraci??n');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('BGB', 'Licenciado en Negocios Internacionales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LAE', 'Licenciado en Estrategia y Transformaci??n de Negocios');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LAF', 'Licenciado en Finanzas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LCPF', 'Licenciado en Contadur??a P??blica y Finanzas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LDE', 'Licenciado en Emprendimiento');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LDO', 'Licenciado en Desarrollo de Talento y Cultura Organizacional');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LEM', 'Licenciado en Mercadotecnia');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LIN', 'Licenciado en Negocios Internacionales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LIT', 'Licenciado en Inteligencia de Negocios');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTG', 'Optativa General');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTI', 'Optativa de Ingenier??a');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTA', 'Optativa de Arte Digital');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTD', 'Optativa de Dise??o');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTP', 'Optativa Profesional');

-- INSERTANDO UNIDADES DE FORMACION:

INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1028', 'Pensamiento computacional para ingenier??a', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1030', 'Programaci??n orientada a objetos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT1013', 'An??lisis de biolog??a computacional', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2026', 'An??lisis de fen??menos de transporte', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2024', 'Dise??o mecatr??nico', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1001', 'L??gica computacional', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1001B', 'Modelaci??n de la f??sica: Est??tica', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1002', 'Razonamiento matem??tico', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1002B', 'Modelaci??n de la f??sica: Din??mica', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1002B', 'Exploraci??n en el h??bitat: de la escala del elemento al territorio', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1009', 'An??lisis qu??mico del ambiente y de los materiales de construcci??n', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1001', 'Optativa de matem??ticas y ciencias', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1025', 'Creatividad y dise??o', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1026', 'Metodolog??as de investigaci??n para proyectos de dise??o', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD1000B', 'El rol de los negocios en la sociedad', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD1014', 'Direcci??n de los negocios', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF1015', 'An??lisis financiero', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1017', 'Econom??a empresarial', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ1011', 'Decisiones financieras', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1027', 'Razonamiento matem??tico', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI1001B', 'Globalizaci??n de los negocios', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH1001B', 'Estrategia y talento', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1027', 'Programaci??n para negocios', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1001B', 'Modelaci??n de la ingenier??a y ciencias', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1006B', 'Modelaci??n del movimiento en ingenier??a', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1007B', 'Aplicaci??n de las leyes de conservaci??n en sistemas ingenieriles', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1028', 'Modelaci??n matem??tica fundamental', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1019', 'An??lisis de la estructura, propiedades y transformaci??n de la materia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1001B', 'Transformaci??n del M??xico contempor??neo', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1022', 'Pensamiento matem??tico I', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1010', 'Filosof??a pol??tica para los dilemas contempor??neos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1011', 'Introducci??n a las ciencias sociales', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI1001B', 'Desaf??os globales', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1001B', 'Principios de programaci??n para las ciencias sociales', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A1004', 'Cultura visual y sonora', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV1002B', 'T??cnicas y discursos fotogr??ficos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO1001B', 'Metodolog??as de investigaci??n de factores humanos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL1022', 'Metodolog??as del pensamiento creativo', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1001B', 'Inmersi??n y experimentaci??n creativa', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1002B', 'Modelaci??n del movimiento en bioingenier??a y procesos qu??micos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1003B', 'Aplicaci??n de las leyes de conservaci??n en ingenier??a de procesos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1028', 'Fundamentaci??n de la estructura y transformaci??n de la materia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1029', 'An??lisis de la estructura y transformaci??n de la materia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1008B', 'Modelaci??n del movimiento en ciencias', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1009B', 'Aplicaci??n de las leyes de conservaci??n en ciencias', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1004B', 'Modelaci??n computacional del movimiento', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1005B', 'Modelaci??n computacional aplicando leyes de conservaci??n', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1033', 'Pensamiento computacional orientado a objetos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1020', 'An??lisis de la estructura y propiedades de la materia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1029', 'Pensamiento computacional y programaci??n', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1003B', 'Modelaci??n de la f??sica en el ambiente construido', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1007', 'Razonamiento basado en matem??ticas', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1008', 'Resoluci??n de problemas con l??gica computacional', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1003', 'An??lisis con Probabilidad y Estad??stica', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1003B', 'Sistemas constructivos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1004B', 'Informaci??n espacial', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1005B', 'Sistemas de informaci??n geogr??fica', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1010', 'Fundamentos de geolog??a aplicada al ambiente construido', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1011', 'Evaluaci??n del impacto ambiental de proyectos territoriales', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1012', 'Aplicaci??n de m??todos num??ricos al ambiente construido', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1002', 'Optativa de humanidades y bellas artes', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1027', 'M??todos de dise??o', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1028', 'T??cnicas de representaci??n espacial y de imagen', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD1016', 'Comunicaci??n que inspira', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD1004', 'An??lisis para la toma de decisiones', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD1005', 'Pensamiento estad??stico', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF1001B', 'Direcci??n financiera', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D1029', 'Legalidad y negocios responsables', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM1001B', 'Ideaci??n y prototipado', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM1009', 'Innovaci??n de modelos de negocios', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT1001B', 'Descubrimientos del mercado para el desarrollo de estrategias', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH1004', 'Procesos de gesti??n de talento', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1008', 'Experimentaci??n f??sica y pensamiento estad??stico', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1015B', 'Aplicaci??n de la termodin??mica en sistemas ingenieriles', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1016B', 'An??lisis de sistemas el??ctricos en sistemas ingenieriles', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1017B', 'An??lisis de sistemas electromagn??ticos en sistemas ingenieriles', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1029', 'Modelaci??n matem??tica intermedia', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1030', 'Modelaci??n matricial', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1031', 'An??lisis estad??stico', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1021', 'Experimentaci??n qu??mica y pensamiento estad??stico fundamental', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D1001B', 'Introducci??n al derecho', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1002B', 'Emprendimiento y tecnolog??a para la transformaci??n de M??xico', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1013', 'Macroeconom??a', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1014', 'Microeconom??a', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1023', 'M??todos cuantitativos I', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1024', 'Pensamiento matem??tico II', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1002B', 'Herramientas tecnol??gicas para las ciencias sociales', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1001B', 'Representaci??n formal del espacio', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV1001B', 'Narrativa audiovisual', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1008', 'Imaginarios culturales de M??xico', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1009', 'Semi??tica y narratolog??as contempor??neas', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1001B', 'Estructuras simb??licas en la imagen, la literatura y la m??sica', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1010B', 'Aplicaci??n de la termodin??mica en ingenier??a de procesos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1011B', 'An??lisis de sistemas el??ctricos en ingenier??a de procesos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1012B', 'An??lisis de sistemas electromagn??ticos en ingenier??a de procesos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1022', 'An??lisis de la transformaci??n de la materia en procesos qu??micos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1023', 'Experimentaci??n qu??mica y pensamiento estad??stico intermedio', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1018B', 'Aplicaci??n de la termodin??mica en ciencias', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1019B', 'An??lisis de sistemas el??ctricos en ciencias', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1020B', 'An??lisis de sistemas electromagn??ticos en ciencias', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1013B', 'Modelaci??n computacional de sistemas el??ctricos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1014B', 'Modelaci??n computacional de sistemas electromagn??ticos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1003B', 'Modelaci??n de la ingenier??a con matem??tica computacional', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP1007', 'Optativa de fundamentos en ingenier??a', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1004B', 'Modelaci??n y representaci??n gr??fica de un edificio', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1005B', 'Modelaci??n y representaci??n gr??fica de tu campus con topograf??a', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1006B', 'Modelaci??n y representaci??n gr??fica de tu entorno con geom??tica', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1013', 'An??lisis de fen??menos naturales y sociales con probabilidad y estad??stica', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2002B', 'Dise??o y construcci??n de un h??bitat ef??mero', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2035', 'La conceptualizaci??n del espacio, su teor??a y su historia', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2036', 'Representaci??n de la arquitectura y su construcci??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1003', 'Optativa de ciencias sociales y del comportamiento', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA1001B', 'T??pico de exploraci??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD1001B', 'Creaci??n de valor compartido', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF1016', 'Estrategias de planeaci??n financiera', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM1010', 'Proyecto de innovaci??n empresarial', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ1012', 'Evaluaci??n de proyectos de inversi??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT1002B', 'Construcci??n de soluciones para el mercado', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT1011', 'Estrategias de mercado y diferenciaci??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI1004', 'Competitividad internacional  y oportunidades de crecimiento', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH1005', 'Dimensi??n estrat??gica del capital humano', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN1001B', 'Dise??o y an??lisis de experimentos para la innovaci??n ingenieril', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN1002B', 'Desarrollo de proyectos de an??lisis de datos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M1011', 'An??lisis de equilibrio est??tico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1034', 'Modelaci??n de procesos mediante algebra lineal', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1035', 'Modelaci??n en ingenier??a mediante sistemas din??micos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE1020', 'An??lisis de circuitos el??ctricos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1003B', 'Macroeconom??a y desarrollo econ??mico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1015', 'Econom??a conductual', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1016', 'Econom??a para la toma de decisiones', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1025', 'M??todos cuantitativos II', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1026', 'Pensamiento matem??tico III', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1001B', 'Participaci??n pol??tica y sociolog??a de la identidad', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT1014', 'Fundamentaci??n de la biolog??a molecular', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ1001B', 'Aplicaci??n de la conservaci??n de la materia en ingenier??a de procesos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ1002B', 'Aplicaci??n de la conservaci??n de la energ??a en ingenier??a de procesos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1024', 'Aplicaci??n del an??lisis qu??mico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1025', 'Experimentaci??n en qu??mica anal??tica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1026', 'An??lisis estructural de mol??culas org??nicas y sus propiedades', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1027', 'Fundamentaci??n de la estructura y propiedades de biomol??culas', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1009', 'An??lisis de m??todos matem??ticos para la f??sica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1010', 'Modelaci??n con ecuaciones diferenciales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1001B', 'Modelaci??n estad??stica para la toma de decisiones', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1002B', 'Modelaci??n de sistemas con ecuaciones diferenciales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1036', 'Fundamentaci??n del ??lgebra lineal', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1033', 'An??lisis de ecuaciones diferenciales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1004B', 'Implementaci??n de internet de las cosas', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1031', 'Programaci??n de estructuras de datos y algoritmos fundamentales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1032', 'Modelaci??n de sistemas m??nimos y arquitecturas computacionales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI1015', 'An??lisis de requerimientos de software', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS1008', 'Evaluaci??n del capital natural y principios de sustentabilidad', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1001', 'Sistema musculoesquel??tico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1002B', 'Metabolismo y energ??a', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1003', 'Aporte y consumo de ox??geno', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1001B', 'Fundamentaci??n de las propiedades de nanomateriales y materiales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1002B', 'Obtenci??n de nanomateriales, materiales org??nicos y bioinorg??nicos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE1019', 'Fundamentaci??n de ingenier??a el??ctrica y electr??nica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2001B', 'Pre-producci??n de cortometraje animado', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2002B', 'Producci??n de cortometraje animado', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2012', 'Dibujo', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2013', 'Historia de la animaci??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2014', 'Fundamentos de la animaci??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2001B', 'Producci??n de audio, video y dise??o digital', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO2001B', 'Metodolog??as de investigaci??n para la comunicaci??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO2011', 'Teor??as de la comunicaci??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH2006', 'Del humanismo al post-humanismo', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2001B', 'Comunicaci??n digital del producto', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2002B', 'Configuraci??n del objeto', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2042', 'Representaci??n visual', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2043', 'Materia y expresi??n', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2001B', 'Bienes y derechos reales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2002B', 'Derecho constitucional', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2031', 'Argumentaci??n jur??dica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2032', 'Personas y acto jur??dico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2033', 'Seminario de argumentaci??n jur??dica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2034', 'Seminario de personas y acto jur??dico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2035', 'Seminario de teor??a del derecho', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2036', 'Teor??a del derecho', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2001', 'Fundamentos de la pedagog??a', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2001B', 'An??lisis de problem??ticas educativas', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2002', 'Metodolog??as de la investigaci??n educativa', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2002B', 'Fundamentaci??n pedag??gica aplicada a las soluciones de aprendizaje', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2001B', 'An??lisis del discurso', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2002B', 'Textos cl??sicos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2050', 'An??lisis cr??tico de textos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2051', 'Estructuras y an??lisis del espa??ol', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2001B', 'Metodolog??as de la investigaci??n period??stica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SO2001', 'Estudios sociales y pol??ticos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2010B', 'Fundamentos de la ac??stica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2001', 'Teor??a y estilos musicales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2001B', 'Entrenamiento auditivo e instrumental', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2002', 'Negocios en la industria de la m??sica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2001B', 'Diagn??stico territorial', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2003B', 'Ecobarrio', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2037', 'Derecho Urbano', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2027', 'Ecolog??a urbana', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2041', 'Infraestructura urbana', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2004B', 'Arquitectura y contextos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2007B', 'Equipamiento comunitario', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2039', 'Investigaci??n y proyecto arquitect??nico', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1004', 'Optativa de liderazgo, emprendimiento e innovaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2001B', 'Panorama internacional de los negocios', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2002B', 'Plan de exportaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2026', 'Negocios globales: tendencias y detecci??n de riesgos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2027', 'Operaci??n log??stica internacional', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2001B', 'Desarrollo de proyectos con visi??n sist??mica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2002B', 'Mejora de un proceso organizacional con m??todos estad??sticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2003B', 'Conceptualizaci??n de procesos con enfoque innovador', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2032', 'An??lisis estad??stico de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2037', 'Dise??o de sistemas ciberf??sicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2038', 'Evaluaci??n econ??mica de proyectos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2001B', 'An??lisis de materiales y manufactura', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2005', 'An??lisis  de mecanismos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2003B', 'Integraci??n mecatr??nica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2004B', 'Implementaci??n de sistemas mecatr??nicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2022', 'An??lisis de elementos de la mecatr??nica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2023', 'Modelaci??n y automatizaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2001B', 'An??lisis de biosistemas productivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2002B', 'Evaluaci??n de nutrici??n y sanidad en los biosistemas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2029', 'Fundamentaci??n de biosistemas productivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2030', 'Integraci??n de procesos bioproductivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS2001B', 'Conservaci??n de recursos naturales en biosistemas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2033', 'Gesti??n de biosistemas productivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2001B', 'Dise??o de alimentos saludables', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2002B', 'Planeaci??n de sistemas de distribuci??n de alimentos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2003B', 'Evaluaci??n de factibilidad de nuevos productos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2017', 'Dise??o sustentable en procesamiento de alimentos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2018', 'Optimizaci??n de procesos y sistemas de inocuidad', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2019', 'An??lisis fisicoqu??mico en el dise??o de alimentos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2002B', 'Elaboraci??n de productos biotecnol??gicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2003B', 'S??ntesis de biof??bricas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2019', 'An??lisis y estudio de biosistemas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2020', 'Aplicaci??n de bases moleculares', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2001B', 'An??lisis de la interacci??n del ambiente construido y el entorno', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2002B', 'Evaluaci??n del comportamiento de materiales en estructuras', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2003B', 'An??lisis del comportamiento de sistemas hidr??ulicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2035', 'Modelaci??n de la informaci??n en la construcci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2036', 'Gesti??n de costos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2037', 'Planeaci??n y control de obra', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2001B', 'Optimizaci??n determinista', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2002B', 'An??lisis de criptograf??a y seguridad', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2004B', 'An??lisis de ciencia de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2032', 'Dise??o de agentes inteligentes', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2033', 'An??lisis de sistemas basados en conocimiento', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2034', 'Modelaci??n del aprendizaje con inteligencia artificial', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS2002B', 'Implementaci??n de programas de manejo de recursos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2001B', 'Integraci??n de procesos energ??ticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2002B', 'Dimensionamiento de procesos energ??ticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2009', 'An??lisis termodin??mico de procesos energ??ticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2010', 'Dise??o de procesos para el transporte de fluidos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2011', 'Dise??o de procesos de transferencia de calor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2005B', 'Aplicaci??n de la teor??a electromagn??tica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2006B', 'Evaluaci??n de circuitos el??ctricos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2007B', 'Aplicaci??n de dispositivos electr??nicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2047', 'An??lisis de circuitos el??ctricos de corriente alterna', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2048', 'An??lisis de sistemas l??gicos y circuitos digitales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2049', 'Fundamentaci??n de la f??sica de estado s??lido y optoelectr??nica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2002B', 'Soluci??n de problemas de mec??nica cl??sica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2003B', 'Modelaci??n num??rica de sistemas f??sicos determin??sticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2004B', 'Aplicaci??n de las fuentes alternas de energ??a', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2017', 'Fundamentaci??n de la electrodin??mica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN2001B', 'Dise??o y creaci??n de soluciones innovadoras', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN2007', 'Estudio de metodolog??as para la innovaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP2019', 'Optativa de acentuaci??n en ingenier??a I', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP2026', 'Optativa de acentuaci??n en ingenier??a II', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2001B', 'Dise??o de sistemas de bioinstrumentaci??n anal??gica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2002B', 'Dise??o de sistemas de bioinstrumentaci??n digital', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2003B', 'An??lisis qu??mico, biol??gico y molecular', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2010', 'An??lisis de se??ales y sistemas biom??dicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2011', 'Aplicaci??n de tecnolog??as de la informaci??n en salud', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2002B', 'Dise??o de productos sometidos a cargas est??ticas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2003B', 'Dise??o din??mico', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2033', 'An??lisis de esfuerzos y deformaciones', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2034', 'An??lisis del movimiento de cuerpos r??gidos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2035', 'Fundamentaci??n de ingenier??a de materiales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2001B', 'Fabricaci??n de nanoestructuras por m??todos qu??micos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2002B', 'Fabricaci??n de nano y microestructuras por m??todos f??sicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2001B', 'Fundamentaci??n fisicoqu??mica de las propiedades de las nanoestructuras', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2024', 'Caracterizaci??n de materiales y nanomateriales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2025', 'Fundamentaci??n de qu??mica m??dica y nanomedicina', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2007B', 'Dise??o de sistemas de flujo de fluidos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2008B', 'Dise??o de sistemas de transferencia de calor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2009B', 'An??lisis de procesos de transferencia de calor y flujo de fluidos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2015', 'Modelaci??n de fen??menos de transporte', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2016', 'Modelaci??n matem??tica avanzada', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2002B', 'Dise??o con l??gica programable', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2003B', 'Dise??o de sistemas en chip', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2044', 'Fundamentaci??n electr??nica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2045', 'Dise??o de circuitos electr??nicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2005B', 'Construcci??n de software y toma de decisiones', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2006B', 'Interconexi??n de dispositivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2037', 'Implementaci??n de m??todos computacionales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2029', 'Modelaci??n, estructura y operaci??n de los negocios', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2002B', 'Evaluaci??n de arquitecturas empresariales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2003B', 'Evaluaci??n de tecnolog??a para los negocios', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2004B', 'Exploraci??n e interpretaci??n de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2018', 'Dise??o de arquitecturas, uso y administraci??n de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2019', 'Evaluaci??n y administraci??n de proyectos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2003B', 'Arte conceptual', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2004B', 'Fundamentos de interacci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2005B', 'Arte instalaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2015', 'Exploraci??n de la forma', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2016', 'Introducci??n al 3D', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2001B', 'Detecci??n de oportunidades estrat??gicas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2002B', 'Dise??o de organizaciones flexibles', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2004B', 'Liderazgo para la transformaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2025', 'Pensamiento estrat??gico', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2001B', 'An??lisis de inversiones', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2002B', 'Cultura financiera', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2004B', 'Gesti??n de tesorer??a', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2019', 'Modelos econom??tricos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2020', 'Series de tiempo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2021', 'Teor??a de inversiones', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2001B', 'Diagn??stico financiero', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2002B', 'Integraci??n financiera de procesos de negocio', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2022', 'Cumplimiento fiscal', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2023', 'Optimizaci??n de costos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2003B', 'Decisiones de negocio estrat??gicas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2016', 'Estructuras de informaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2002B', 'Guionismo y producci??n de narrativas audiovisuales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2016', 'Fotograf??a publicitaria y comercial', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CR2001B', 'Comunicaci??n estrat??gica aplicada', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2001B', 'Adaptaci??n de oportunidad y soluci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2002B', 'Evaluaci??n y comunicaci??n de oportunidades', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2003B', 'Exploraci??n de alto impacto', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2013', 'Innovaci??n en la cadena de valor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2014', 'Liderazgo emprendedor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2015', 'Oportunidades de emprendimiento corporativo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2003B', 'Pensamiento y proceso creativo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2004B', 'Especificaci??n de productos y servicios', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2005B', 'Dise??o e innovaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2044', 'Administraci??n de proyectos de dise??o', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2001B', 'Estrategias para potenciar el talento humano', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2002B', 'Planeaci??n del capital humano', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2003B', 'Valoraci??n estrat??gica del trabajo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2012', 'Atracci??n y desarrollo del talento en entornos digitales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2013', 'Desempe??o y retribuci??n en contextos globales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2015', 'Anal??tica del talento', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2001B', 'Dinero y capitales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2003B', 'Incentivos del consumidor y productor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2004B', 'Origen y futuro del panorama macroecon??mico', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2029', 'Fundamentos de econometr??a', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2012', 'Fundamentos de estad??stica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2013', 'Pensamiento matem??tico IV', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2003B', 'Derecho penal y delitos en especial', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2004B', 'Derechos humanos y su interpretaci??n judicial', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2005B', 'Soluci??n de conflictos y teor??a general del proceso', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2037', 'Derecho de las obligaciones I', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2038', 'Derecho de las obligaciones II', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2039', 'Seminario de derecho de las obligaciones I', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2003', 'Introducci??n a la administraci??n educativa', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2003B', 'Desarrollo de proyectos educativos basados en tecnolog??a', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2004B', 'Exploraci??n de tendencias tecnol??gicas en educaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2005B', 'Uso de tecnolog??a en la investigaci??n educativa', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2001B', 'Inteligencia de mercado para la generaci??n de conocimiento del consumidor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2002B', 'Inteligencia exploratoria de mercados', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2003B', 'Segmentaci??n y posicionamiento de estrategias de valor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2027', 'Definici??n competitiva de mercado', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2028', 'Dise??o de m??tricas de mercadotecnia', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2029', 'Visi??n hol??stica del consumidor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2003B', 'Indicadores y riesgos con visi??n estrat??gica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2001B', 'Diagn??stico para l??neas de acci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2008', 'An??lisis descriptivo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2009', 'Manipulaci??n de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2017', 'Integraci??n de base de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2003B', 'Literatura de los Siglos de Oro', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2004B', 'Literatura espa??ola medieval', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2005B', 'Literatura novohispana', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2052', 'Teor??a literaria', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2002B', 'Producci??n de contenidos noticiosos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2007', 'Ejercicio period??stico, derecho a la informaci??n y opini??n p??blica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2001B', 'An??lisis hist??rico del sistema internacional', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2002B', 'Escenarios regionales en el mundo contempor??neo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2003B', 'Prospectiva sobre escenarios pol??tico-econ??micos internacionales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2039', 'Teor??as cl??sicas de relaciones internacionales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2040', 'Teor??as contempor??neas de relaciones internacionales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2002B', 'Aplicaci??n de tecnolog??a en la producci??n sonora', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2003', 'Producci??n sonora y mezcla digital', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2003B', 'T??cnicas de grabaci??n sonora', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2004B', 'Proyecto de producci??n musical', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2001B', 'Opini??n p??blica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2002B', 'Instituciones, regulaci??n y pol??tica p??blica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2001B', 'Ciencia de datos para la toma de decisiones I', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3066', 'M??todos econom??tricos y pol??tica p??blica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2005B', 'Ciudades competitivas: Innovaci??n', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2006B', 'Ciudades competitivas: Movilidad', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2010B', 'Ciudades competitivas: Calidad de vida', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2038', 'Ciudades del futuro', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2008B', 'Vivienda colectiva', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2009B', 'Vivienda unifamiliar', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2040', 'Constructibilidad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1005', 'Optativa de ??tica y ciudadan??a', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2003B', 'Administraci??n de importaciones y sus regulaciones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2004B', 'Desarrollo internacional de servicios', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2025', 'Negociaci??n Intercultural', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2028', 'Ventas y contratos internacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2004B', 'Generaci??n de valor con anal??tica de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2005B', 'Evaluaci??n de la competitividad organizacional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2006B', 'An??lisis de la viabilidad de proyectos con perspectiva sist??mica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2039', 'Visualizaci??n de datos para la toma de decisiones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2040', 'Optimizaci??n de procesos organizacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2041', 'Mejora de procesos con m??todos heur??sticos y metaheur??sticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2005B', 'Soluci??n de problemas de procesos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2006B', 'Automatizaci??n industrial', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2025', 'Dise??o de sistemas de control', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2003B', 'Integraci??n de tecnolog??as sustentables en biosistemas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2001B', 'Mejora de biosistemas con gen??tica y biotecnolog??a', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2034', 'Evaluaci??n de la productividad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2035', 'Gesti??n avanzada de la producci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2036', 'Aplicaci??n de metrolog??a en biosistemas productivos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2001B', 'Aplicaci??n de automatizaci??n y control en biosistemas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2004B', 'Dise??o de procesos sustentables', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2005B', 'An??lisis del consumidor y mercado de alimentos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2006B', 'Dise??o de sistemas de administraci??n de procesos e inocuidad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2020', 'Administraci??n de procesos y sistemas de inocuidad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2021', 'Aplicaci??n del an??lisis sensorial en alimentos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2022', 'Simulaci??n de procesos de transformaci??n de alimentos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2004B', 'Experimentaci??n in vitro', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2005B', 'Integraci??n de operaciones de transferencia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2004B', 'Evaluaci??n del comportamiento de sistemas estructurales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2005B', 'Dise??o de sistemas hidr??ulicos para el uso sustentable del agua', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2006B', 'Dise??o de vialidades para el desarrollo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2038', 'Gesti??n de proyectos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2039', 'Gesti??n de operaciones de construcci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2040', 'Gesti??n empresarial en la industria de la construcci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2003B', 'Aplicaci??n de m??todos multivariados en ciencia de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2004B', 'Optimizaci??n estoc??stica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2005B', 'Aplicaci??n de criptograf??a y seguridad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2014', 'An??lisis de m??todos de razonamiento e incertidumbre', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2015', 'Dise??o de algoritmos matem??ticos bioinspirados', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2035', 'Dise??o de redes neuronales y aprendizaje profundo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2003B', 'Evaluaci??n de procesos energ??ticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2004B', 'Evaluaci??n del desempe??o energ??tico de procesos industriales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2012', 'Aplicaci??n de los principios de eficiencia energ??tica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2013', 'An??lisis de procesos y econom??a circular', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2009B', 'Dise??o usando microcontroladores y arquitectura computacional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2039', 'Desarrollo de sistemas digitales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2008B', 'Evaluaci??n de Dispositivos Electr??nicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2009B', 'An??lisis de sistemas y dispositivos electr??nicos de control', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2046', 'An??lisis de se??ales y sistemas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2050', 'Dise??o de circuitos electr??nicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2005B', 'An??lisis de fen??menos ??pticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2006B', 'Modelaci??n num??rica de sistemas estoc??sticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2007B', 'An??lisis de los sistemas termodin??micos y estad??sticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2018', 'An??lisis de sistemas cu??nticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN2002B', 'Dise??o y evaluaci??n de emprendimientos tecnol??gicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN2008', 'An??lisis de factibilidad y viabilidad de proyectos de innovaci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP2027', 'Optativa de acentuaci??n en ingenier??a III', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP2028', 'Optativa de acentuaci??n en ingenier??a IV', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2004B', 'An??lisis y dise??o en biomec??nica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2005B', 'Aplicaci??n de bioinstrumentaci??n y tecnolog??as biom??dicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2006B', 'Gesti??n y validaci??n de tecnolog??as biom??dicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2012', 'Caracterizaci??n de biomateriales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2013', 'Modelaci??n y control de sistemas biom??dicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1012', 'Sistema nervioso', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2004B', 'Dise??o de mecanismos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2005B', 'Dise??o de sistemas termoflu??dicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2036', 'Fundamentaci??n de mec??nica de fluidos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2037', 'An??lisis de los procesos de transformaci??n energ??tica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2038', 'Modelaci??n de transferencia de calor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2001B', 'Desarrollo de nanosistemas fot??nicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2015', 'Fundamentaci??n del estado s??lido de la materia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2016', 'Fundamentaci??n de electromagnetismo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2003B', 'Desarrollo de nanosistemas flu??dicos y mec??nicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2002B', 'Modelaci??n de sistemas moleculares', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2026', 'Formulaci??n de productos nanotecnol??gicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2010B', 'Dise??o de procesos de separaci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2011B', 'Dise??o de reactores qu??micos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2012B', 'An??lisis de procesos de separaci??n y reacci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2016', 'Predicci??n del equilibrio qu??mico y de fases', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2002B', 'An??lisis de sistemas de control', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2036', 'Implementaci??n de redes seguras', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2004B', 'Dise??o de sistemas embebidos avanzados', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2007B', 'Integraci??n de seguridad inform??tica en redes y sistemas de software', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2008B', 'Modelaci??n de sistemas multiagentes con gr??ficas computacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2038', 'An??lisis y dise??o de algoritmos avanzados', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2008B', 'Administraci??n del cambio', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2030', 'An??lisis del comportamiento y desempe??o organizacional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2025', 'An??lisis de las actividades econ??micas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2005B', 'Dise??o de procesos y arquitecturas empresariales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2006B', 'Soporte anal??tico para la toma de decisiones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2020', 'Implementaci??n de tecnolog??a en los procesos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3070', 'Optativa de arte digital I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3071', 'Optativa de arte digital II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3072', 'Optativa de arte digital III', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3073', 'Optativa de arte digital IV', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3074', 'Optativa de arte digital V', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3075', 'Optativa de arte digital VI', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2005B', 'Aseguramiento de la co-creaci??n de valor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2006B', 'Dise??o estrat??gico para crear valor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2026', 'Construcci??n de habilidades interpersonales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2027', 'Innovaci??n y co-creaci??n de valor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2005B', 'An??lisis de financiamiento', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2008B', 'Valuaci??n de empresas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2009B', 'Veh??culos de inversi??n y cobertura', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2022', 'Algoritmos y an??lisis de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2023', 'Instrumentos derivados', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2024', 'Modelaci??n y programaci??n financiera', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2003B', 'Desarrollo de arquitectura contable', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2024', 'Dise??o de estrategia financiera', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2025', 'Valuaci??n y presentaci??n de financiamientos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2026', 'Valuaci??n y presentaci??n de inversiones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2006B', 'An??lisis fundamental de empresas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2007B', 'Creaci??n de valor corporativo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2003B', 'Narrativa documental', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO2002B', 'Comunicaci??n, mercadotecnia digital y miner??a de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO2012', 'Estudios culturales y medios', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2003B', 'Producci??n period??stica convergente', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2004B', 'Dise??o de prototipos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2005B', 'Dise??o de soluciones de alto impacto', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2006B', 'Generaci??n y validaci??n de prototipos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2016', 'Metodolog??as de innovaci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2017', 'Metodolog??as de innovaci??n tecnol??gica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2018', 'T??cnicas de prototipaje', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3076', 'Optativa de dise??o I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3077', 'Optativa de dise??o II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3078', 'Optativa de dise??o III', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3079', 'Optativa de dise??o IV', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3080', 'Optativa de dise??o V', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3081', 'Optativa de dise??o VI', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2028', 'Responsabilidad social y talento humano', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2004B', 'Comprensi??n del ambiente laboral', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2005B', 'Creaci??n de valor desde el talento', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2006B', 'Dise??o de experiencias laborales plenas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2014', 'Organizaciones positivas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2015', 'Versatilidad organizacional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2005B', 'Competencia econ??mica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2006B', 'Decisiones estrat??gicas en mercados e instituciones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2007B', 'Din??mica del crecimiento nacional y regional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2030', 'Econometr??a I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2031', 'Econometr??a II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2032', 'Multivariante', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2006B', 'Contratos civiles y mercantiles', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2007B', 'Derecho administrativo I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2008B', 'Familia y sucesiones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2040', 'Derecho laboral I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2041', 'Derecho laboral ll', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2042', 'Seminario de derecho de las obligaciones II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2004', 'Educaci??n global y comparada', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2006B', 'Dise??o de soluciones para retos educativos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2007B', 'Desarrollo de proyectos en el marco de las pol??ticas educativas vigentes', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2004B', 'Desarrollo de marcas que transforman', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2005B', 'Dise??o de experiencias omnicanal', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2006B', 'Gesti??n sustentable de proyectos de mercadotecnia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2030', 'Dise??o de estrategias de mercadotecnia interna', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2031', 'Optimizaci??n de precios y cadenas de valor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2007B', 'L??neas de acci??n estrat??gicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2010', 'Introducci??n a la econometr??a', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2011', 'Miner??a de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2003B', 'Gesti??n de proyectos de plataformas tecnol??gicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2001B', 'Plataformas de anal??tica de negocios para organizaciones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2006B', 'Narrativa Iberoamericana de los siglos XIX y XX', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2007B', 'Poes??a Iberoamericana de los siglos XIX y XX', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2008B', 'Teatro y ensayo iberoamericanos de los siglos XIX y XX', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2053', 'Desarrollo de modelos y prototipos editoriales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2004B', 'Producci??n de narrativas convergentes multimodales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2008', 'Fundamentos del periodismo hipermedia y transmedia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2004B', 'Conflicto y negociaci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2005B', 'Cooperaci??n y gobernanza global', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2006B', 'Gesti??n de bienes p??blicos globales en la sociedad de riesgo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2041', 'Aspectos jur??dicos de las relaciones internacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2042', 'Organismos internacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2043', 'Riesgos y amenazas en la agenda global contempor??nea', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2004', 'Postproducci??n de audio para cine y video', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2005B', 'Dise??o de aplicaciones interactivas de tecnolog??a musical', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2006B', 'Musicalizaci??n de productos audiovisuales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2007B', 'Producci??n y mercadotecnia audiovisual', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2002B', 'Econom??a conductual y neurociencia pol??tica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2003B', 'Pol??ticas tecnol??gicas para el desarrollo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2013', 'Elecci??n p??blica e instituciones pol??ticas comparadas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2002B', 'Ciencia de datos para la toma de decisiones II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3001B', 'Metr??polis sostenible: Mitigaci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3002B', 'Metr??polis sostenible: Resiliencia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3004B', 'Metr??polis sostenible: Adaptaci??n', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2033', 'Econom??a urbana', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3111', 'T??picos I', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3112', 'T??picos II', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3113', 'T??picos III', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3114', 'T??picos IV', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3115', 'T??picos V', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3116', 'T??picos VI', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2007B', 'Dise??o disruptivo de procesos organizacionales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2008B', 'Aseguramiento de la excelencia operacional', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2009B', 'Mejora de una cadena de valor adaptativa', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2042', 'Modelaci??n de la cadena de valor', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2043', 'Simulaci??n discreta, continua y por agentes', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2044', 'Dise??o de un proceso de consultor??a y gesti??n del cambio', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2007B', 'Automatizaci??n de sistemas de manufactura', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR3001B', 'Dise??o y desarrollo de robots', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG3001B', 'Bioproducci??n en ambientes controlados', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA3001B', 'Desarrollo sustentable de alimentos saludables y personalizados', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2006B', 'Dise??o de biorreactores', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2007B', 'Dise??o de estrategias de bioseparaci??n', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2008B', 'Planeaci??n de procesos biotecnol??gicos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2024', 'Aplicaci??n y an??lisis de las tecnolog??as ??micas', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2025', 'Prospecci??n de bioprocesos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2007B', 'Modelaci??n de t??cnicas de saneamiento del agua', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2008B', 'Dise??o de movilidad eficiente de personas y mercanc??as', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2009B', 'Dise??o estructural con concreto reforzado y acero', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2006B', 'Uso de ??lgebras modernas para seguridad y criptograf??a', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2007B', 'Uso de geometr??a y topolog??a para ciencia de datos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2008B', 'An??lisis num??rico para la optimizaci??n no-lineal', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS2002', 'Innovaci??n de modelos de sustentabilidad corporativa', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2005B', 'Dimensionamiento avanzado y monitoreo de procesos energ??ticos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2006B', 'Innovaci??n de los procesos en su cadena de valor', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2014', 'Mejora de procesos productivos aplicando principios de econom??a circular', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2010B', 'Desarrollo de sistemas de procesamiento digital de se??ales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2011B', 'Dise??o de sistemas de comunicaciones', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2012B', 'An??lisis de sistemas energ??ticos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2008B', 'Caracterizaci??n experimental de sistemas ??pticos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2009B', 'Caracterizaci??n experimental de materiales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2001B', 'Caracterizaci??n experimental mediante instrumentaci??n electr??nica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN3001B', 'Gesti??n estrat??gica de la innovaci??n tecnol??gica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2007B', 'An??lisis de sistemas de imagenolog??a', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2008B', 'Aplicaci??n de la Ingenier??a tisular y bioimpresi??n', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2009B', 'Procesamiento de im??genes m??dicas para el diagn??stico', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2010B', 'Dise??o y desarrollo en neuroingenier??a', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2011B', 'Implementaci??n de ingenier??a cl??nica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2012B', 'An??lisis de la mec??nica de biofluidos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2006B', 'Dise??o de m??quinas t??rmicas', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2007B', 'An??lisis y prevenci??n de fallas', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2008B', 'Dise??o de elementos de m??quinas', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2001', 'Dise??o de dispositivos nanotecnol??gicos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2002', 'Generaci??n de prototipos y escalamiento de procesos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2004B', 'Aplicaci??n de nanodispositivos en soluciones integrales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2005B', 'Aplicaci??n de prototipado y escalamiento en soluciones integrales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2003B', 'Aplicaci??n de investigaci??n en soluciones integrales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2027', 'Investigaci??n y dise??o experimental', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2013B', 'Dise??o integral de procesos qu??micos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2017', 'Dise??o de procesos qu??micos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2021', 'Automatizaci??n y control de procesos qu??micos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE3001B', 'Fundamentaci??n de rob??tica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE3002B', 'Implementaci??n de rob??tica inteligente', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3001B', 'Desarrollo de software', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI3001B', 'Administraci??n estrat??gica y gobierno de tecnolog??as de informaci??n', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI3002B', 'Innovaci??n y dise??o de iniciativas de transformaci??n digital', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI3003B', 'Aplicaci??n de anal??tica y gobierno de datos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AT3001B', 'Proyecto de arte digital', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL3001B', 'Proyecto de dise??o', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3001B', 'Controles constitucionales I', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3002B', 'Derecho administrativo II', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3003B', 'Derecho procesal civil y mercantil', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3039', 'Derecho fiscal', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3040', 'Derecho procesal laboral', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3041', 'Empresa y cumplimiento regulatorio', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3042', 'Juicios orales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3043', 'Sistema penal acusatorio', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3044', 'Sociedades mercantiles', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC3001B', 'An??lisis de decisiones bajo condiciones de incertidumbre', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2020', 'Econom??a pol??tica del cambio tecnol??gico y el desarrollo', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P3001B', 'Gobierno, sector privado, tecnolog??a y nuevos mercados', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3065', 'Experimentos e inferencia causal para pol??tica p??blica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3091', 'Optativa Profesional I', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3092', 'Optativa Profesional II', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3093', 'Optativa profesional III', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3094', 'Optativa profesional IV', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3095', 'Optativa profesional V', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3096', 'Optativa profesional VI', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3001B', 'Formaci??n de juicio cr??tico profesional', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3024', 'Aseguramiento e inter??s p??blico', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3026', 'Ciclo tributario y empresas', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3027', 'Consolidaci??n de informaci??n financiera', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3004B', 'Controles constitucionales II', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3005B', 'Derecho internacional privado y arbitraje comercial internacional', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3006B', 'Derecho procesal fiscal y administrativo', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3045', 'Derecho de la propiedad intelectual', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3046', 'Derecho internacional p??blico', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3047', '??tica para abogados', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3048', 'Ingl??s legal', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3049', 'Seminario de derecho internacional p??blico', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3050', 'T??tulos y operaciones de cr??dito', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3003B', 'Gesti??n y administraci??n de proyectos territoriales de inversi??n', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3007B', 'Emprendimiento en el ??mbito de la arquitectura', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3008B', 'Gesti??n arquitect??nica', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI3001B', 'Desarrollo de estrategias de internacionalizaci??n para el siglo XXI', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN3001B', 'Dise??o de un sistema organizacional inteligente', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR3002B', 'Dise??o e implementaci??n de sistemas mecatr??nicos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG3002B', 'Transformaci??n digital de biosistemas productivos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG3003B', 'Gesti??n integral y ecoeficiente', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA3002B', 'Administraci??n de procesos de producci??n y distribuci??n de alimentos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT3002B', 'Dise??o de procesos biotecnol??gicos y de bioproductos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV3001B', 'Integraci??n de proyectos de ingenier??a civil', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA3001B', 'Desarrollo de proyectos de ingenier??a matem??tica', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS3001B', 'Dise??o de estrategias de sustentabilidad corporativa', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ3001B', 'Desarrollo de modelos de sustentabilidad energ??tica', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE3004B', 'Desarrollo de telecomunicaciones y sistemas energ??ticos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F3001B', 'Integraci??n de ingenier??a f??sica', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN3002B', 'Desarrollo de proyecto integrador de innovaci??n', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI3001B', 'Desarrollo de dispositivos m??dicos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M3001B', 'Dise??o de m??quinas', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q3001B', 'Desarrollo de proyectos de nanotecnolog??a', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ3002B', 'Aplicaci??n de la ingenier??a de procesos en proyectos industriales', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE3003B', 'Integraci??n de rob??tica y sistemas inteligentes', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3002B', 'Desarrollo de aplicaciones avanzadas de ciencias computacionales', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3003B', 'Implementaci??n de redes de ??rea amplia y servicios distribuidos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI3004B', 'Transformaci??n digital de la organizaci??n', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AT3002B', 'Proyecto integral de arte digital', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD3001B', 'Gesti??n estrat??gica de PYMES', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD3002B', 'Institucionalizaci??n de la empresa familiar', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ3001B', 'Administraci??n financiera internacional', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ3002B', 'Gesti??n de fondos de inversi??n', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3002B', 'Direcci??n financiera y contralor??a estrat??gica', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO3001B', 'Proyecto integrador de comunicaci??n', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM3001B', 'Escalabilidad', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM3002B', 'Persuasi??n y ventas', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL3002B', 'Proyecto integral de dise??o', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH3001B', 'Liderazgo estrat??gico del talento', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH3002B', 'Potenciaci??n de la cultura organizacional', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC3002B', 'Soluci??n y evaluaci??n de problemas econ??micos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED3001B', 'Proyecto integrador de innovaci??n educativa', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT3001B', 'Liderazgo de mercadotecnia I', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT3002B', 'Liderazgo de mercadotecnia II', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD3003B', 'Planeaci??n estrat??gica basada en anal??tica prescriptiva', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H3001B', 'Proyecto integrador de letras', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI3001B', 'Proyecto integrador de periodismo', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI3002B', 'An??lisis y estrategias de pol??tica exterior', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM3001B', 'Proyecto integrador de tecnolog??a y producci??n musical', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P3002B', 'Dise??o e implementaci??n de innovaciones p??blicas', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3005B', 'Ciudades emergentes', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3006B', 'Complejidad y debate', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3007B', 'Investigaci??n jur??dica aplicada', 9);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3001B', 'Optativa profesional multidisciplinaria', 9);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1020', 'Micro incentivos econ??micos y macro resultados', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1010', 'Claves de la felicidad para el florecimiento humano', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1058', 'Antropolog??a del cuerpo', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1012', 'Cambio tecnol??gico y desarrollo social', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1013', 'Pol??tica mexicana: evoluci??n y desaf??os', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI1016', 'G??nero, sociedad y derechos humanos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI1018', 'Geopol??tica y cambios tecnol??gicos: el futuro hoy', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1019', 'Salud y bienestar personal', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1018', 'Infodemia y posverdad: ideolog??a, algoritmos y redes sociales', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A1005', 'Apreciaci??n del arte', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AT1005', 'Cultura de la imagen', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1013', 'Patrimonio cultural de M??xico', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1057', 'Los mitos que nos habitan: de Prometeo a Marvel', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IM1003', 'Apreciaci??n multidisciplinaria de la m??sica', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI1017', 'Hitos hist??ricos de los siglos XX y XXI', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1017', 'Futuros posibles: utop??as y distop??as en el cine y la literatura', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV1010', 'An??lisis cinematogr??fico: de Lumiere a Netflix', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2054', 'Viajeros del mundo: narrativas, mapas y fronteras', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IB1005', 'Fundamentaci??n de sistemas biol??gicos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IB1006', 'Biomim??tica y sustentabilidad', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS1009', 'Procesos ecol??gicos para el desarrollo humano', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1042', 'Matem??ticas y ciencia de datos para la toma de decisiones ', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1019', 'Ciudadan??a y ciudades inteligentes', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1011', 'Posthumanismo, ??tica y tecnolog??a', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1012', '??tica, sostenibilidad y responsabilidad social', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1014', 'Violencia, dignidad y justicia social', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1059', '??tica y psicolog??a: del autoconocimiento a la realizaci??n', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MB1002', 'Bienestar humano, desarrollo sustentable y entorno construido', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1006', 'Ciudadan??a global: diversidad y tolerancia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1014', 'Ciudadan??a y tecnolog??a', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL1023', 'Innovaci??n y procesos creativos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1018', 'Anticorrupci??n en  gobierno, empresas y sociedad', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM1011', 'Emprendimiento e innovaci??n', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1063', 'Argumentaci??n, debate y el arte de hablar en p??blico', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MB1001', 'Salud global para l??deres', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2035', 'Introducci??n a los negocios conscientes', 1);



INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1030', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1013', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2026', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2024', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AC1001', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AC1001B', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AC1002', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AC1002B', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1002B', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1009', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AC1003', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AC1003B', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AC1004B', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AC1005B', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1010', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1011', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1012', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'AMC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1004', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1002B', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO1001B', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1022', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1001B', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1001B', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1001B', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1008', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1009', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1001B', 'ESC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1025', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1026', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1027', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1028', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2002B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2035', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2036', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2004B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2007B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2039', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2008B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2009B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2040', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR3007B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR3008B', 'ARQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1004', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1002B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO1001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1022', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1008', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1009', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2002B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2012', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2013', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2014', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2003B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2004B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2005B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2015', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A2016', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3070', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3071', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3072', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3073', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3074', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3075', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AT3001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AT3002B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LAD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1004', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1002B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO1001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1022', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1008', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1009', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL2001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL2002B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL2042', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL2043', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL2003B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL2004B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL2005B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL2044', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3076', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3077', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3078', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3079', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3080', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3081', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL3001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL3002B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LDI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1002B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1003B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1007', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1008', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1009', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1004B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1005B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1006B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1010', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1011', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1012', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV1013', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2001B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2003B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2037', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2027', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2041', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2005B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2006B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2010B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR2038', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR3001B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR3002B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR3004B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2033', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR3003B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR3005B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR3006B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LUB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1001B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1022', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1010', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1011', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI1001B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1001B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1001B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1002B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1013', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1014', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1023', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1024', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1002B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1003B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1015', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1016', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1025', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1026', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1001B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'CIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1001B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1022', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1010', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1011', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI1001B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1001B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1001B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1002B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1013', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1014', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1023', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1024', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1002B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1003B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1015', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1016', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1025', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1026', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1001B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2001B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2003B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2004B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2029', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2012', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2013', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2005B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2006B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2007B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2030', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2031', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2032', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC3002B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LEC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1001B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1022', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1010', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1011', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI1001B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1001B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1001B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1002B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1013', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1014', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1023', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1024', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1002B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2001B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2002B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2031', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2032', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2033', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2034', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2035', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2036', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2003B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2004B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2005B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2037', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2038', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2039', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2006B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2007B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2008B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2040', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2041', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D2042', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3001B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3002B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3003B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3039', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3040', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3041', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3042', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3043', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3044', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3004B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3005B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3006B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3045', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3046', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3047', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3048', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3049', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3050', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D3007B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LED');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1001B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1022', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1010', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1011', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI1001B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1001B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1001B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1002B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1013', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1014', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1023', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1024', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1002B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1003B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1015', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1016', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1025', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1026', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1001B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2001B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2002B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2003B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2039', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2040', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2004B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2005B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2006B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2041', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2042', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2043', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI3002B', 'LRI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1022', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1010', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1011', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI1001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1002B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1013', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1014', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1023', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1024', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1002B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1003B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1015', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1016', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1025', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1026', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P2001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P2002B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC3066', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC2002B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P2003B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P2013', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2002B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC3001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P2020', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P3001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC3065', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P3002B', 'LTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1004', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1002B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO1001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1022', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1008', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1009', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV2001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO2001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO2011', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH2006', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV2002B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV2016', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CR2001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV2003B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO2002B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO2012', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MI2003B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO3001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1004', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1002B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO1001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1022', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1008', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1009', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2001', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2002', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2002B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2003', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2003B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2004B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2005B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2004', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2006B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED2007B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('ED3001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LEI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1004', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1002B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO1001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1022', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1008', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1009', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2002B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2050', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2051', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2003B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2004B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2005B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2052', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2006B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2007B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2008B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2053', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H3001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LLE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1004', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1002B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO1001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1022', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1008', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1009', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO2011', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MI2001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('SO2001', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MI2002B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MI2007', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI2001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV2004B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MI2003B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MI2008', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MI3001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LPE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1004', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1002B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CO1001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1022', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AR1001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1008', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1009', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2010B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2001', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2002', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2002B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2003', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2003B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2004B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2004', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2005B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2006B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM2007B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TM3001B', 'LTM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1002B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1003B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1028', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1029', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1011B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1012B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1022', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1023', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1014', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1001B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1002B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1024', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1025', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1026', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1027', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IBQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1002B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1003B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1011B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1012B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1022', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1023', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1014', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1002B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1024', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1025', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1026', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1027', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AG2001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AG2002B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AG2029', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AG2030', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DS2001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2033', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AG2003B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2034', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2035', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2036', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AG3001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AG3002B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AG3003B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IAG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1002B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1003B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1011B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1012B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1022', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1023', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1014', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1001B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1002B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1024', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1025', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1026', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1027', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2001B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2002B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2003B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2017', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2018', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2019', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2004B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2005B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2006B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2020', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2021', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA2022', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA3001B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TA3002B', 'IAL');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1002B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1003B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1011B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1012B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1022', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1023', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1014', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1001B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1002B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1024', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1025', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1026', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1027', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2002B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2003B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2019', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2020', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2004B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2005B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2026', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2006B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2007B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2008B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2024', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT2025', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT3002B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IBT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1002B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1003B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1011B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1012B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1022', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1023', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DS1008', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1001B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1002B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1026', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DS2002B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2001B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2002B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2009', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2010', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2011', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2003B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2004B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2012', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2013', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DS2002', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2005B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2006B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2014', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DS3001B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ3001B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IDS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1002B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1003B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1011B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1012B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1022', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1023', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1014', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1001B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ1002B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1024', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1025', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1026', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1027', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2007B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2008B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2009B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2015', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2010B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2011B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2012B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2016', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2013B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ2017', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2021', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IQ3002B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IQ');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1009B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1028', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1029', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1018B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1019B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1020B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1009', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1001B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1002B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1036', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'ICI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1009B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1020', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1029', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1013', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1019B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1020B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1003B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1030', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1009', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1001B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1002B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1036', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2001B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2002B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2004B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2032', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2033', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2034', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2003B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2004B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2005B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2014', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2015', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2035', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2006B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2007B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2008B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA3001B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IDM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1009B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1018B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1019B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1020B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1009', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1010', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1001B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1002B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1036', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2002B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2003B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2004B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2017', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2005B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2006B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2007B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2018', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2008B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2009B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2001B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F3001B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IFI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1009B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1018B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1019B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1020B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1022', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1023', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1014', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1001B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1002B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1024', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1025', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1026', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1027', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NT2001B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NT2002B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q2001B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q2024', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q2025', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2001B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2015', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F2016', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NT2003B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q2002B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q2026', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NT2001', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NT2002', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NT2004B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NT2005B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q2003B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q2027', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q3001B', 'INA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1004B', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1005B', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1028', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1033', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1013', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1013B', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1014B', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1003B', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1030', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1033', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1004B', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1031', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1032', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI1015', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'ICT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1004B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1005B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1020', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1029', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1013', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1013B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1014B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1003B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1030', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1033', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1004B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1031', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1032', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1019', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA2016', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2002B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2003B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2044', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2045', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2002B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2036', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2004B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2046', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE3001B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE3002B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE3003B', 'IRS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1004B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1005B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1020', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1029', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1013', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1013B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1014B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1003B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1030', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1033', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1004B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1031', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1032', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI1015', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2005B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2006B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2037', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2007B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2008B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2038', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC3001B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC3002B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC3003B', 'ITC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1004B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1005B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1020', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1029', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BT1013', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1013B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1014B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1003B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1030', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1033', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1004B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1031', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1032', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI1015', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2029', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2002B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2003B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2004B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2018', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2019', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2008B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2030', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2025', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2005B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2006B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2020', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI3001B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI3002B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI3003B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI3004B', 'ITD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1028', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1029', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2001B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2002B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2003B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2032', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2037', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2038', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2004B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2005B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2006B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2039', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2040', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2041', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2007B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2008B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2009B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2042', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2043', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2044', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN3001B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'BIE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2001B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2005', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2003B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2004B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2022', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2023', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2005B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2006B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2024', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2025', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2007B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR3001B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR3002B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'BME');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2001B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2002B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2003B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2035', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2036', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2037', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2004B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2005B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2006B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2038', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2039', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2040', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2007B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2008B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV2009B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CV3001B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IC');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2005B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2006B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2007B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2047', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2048', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2049', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2009B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2039', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2008B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2009B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2046', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2050', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2010B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2011B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE2012B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE3004B', 'IE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP1007', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NN2001B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NN2007', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP2019', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP2026', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NN2002B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NN2008', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP2027', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP2028', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NN3001B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NN3002B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IID');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2001B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2002B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2003B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2032', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2037', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2038', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2004B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2005B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2006B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2039', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2040', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2041', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2007B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2008B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2009B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2042', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2043', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN2044', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN3001B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IIS');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2002B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2003B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2033', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2034', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2035', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2004B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2005B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2036', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2037', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2038', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2006B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2007B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2008B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M3001B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('SD1001', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('SD1002B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('SD1003', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2001B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2002B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2003B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2010', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2011', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2004B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2005B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2006B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2012', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2013', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('SD1012', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2007B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2008B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2009B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2010B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2011B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI2012B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('BI3001B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IMD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1001B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1006B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1007B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1028', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1019', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1028', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1008', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1015B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1016B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('F1017B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1029', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1030', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1031', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('Q1021', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1001B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IN1002B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M1011', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1034', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1035', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TE1020', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2001B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('M2005', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2003B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2004B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2022', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2023', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2005B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2006B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2024', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2025', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR2007B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR3001B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MR3002B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'IMT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'NEG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2002B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2026', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2027', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2003B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2004B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2025', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2028', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI3001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'BGB');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2002B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2004B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2025', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2005B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2006B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2026', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2027', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD3001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD3002B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LAE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2002B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2004B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2019', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2020', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2021', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2005B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2008B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2009B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2022', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2023', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2024', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ3001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ3002B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LAF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF2001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF2002B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF2022', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF2023', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2003B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2016', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF2003B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF2024', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF2025', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF2026', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2006B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ2007B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF3001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF3024', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF3026', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF3027', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF3002B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LCPF');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2002B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2003B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2013', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2014', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2015', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2004B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2005B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2006B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2016', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2017', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM2018', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM3001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM3002B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LDE');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2002B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2003B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2012', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2013', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2015', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2028', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2004B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2005B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2006B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2014', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH2015', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH3001B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH3002B', 'LDO');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2002B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2003B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2027', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2028', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2029', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2004B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2005B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2006B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2030', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT2031', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT3001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT3002B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LEM');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2002B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2026', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2027', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2003B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2004B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2025', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI2028', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI3001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LIN');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1000B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1014', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1015', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1017', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1001', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1011', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1027', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC1027', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1016', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1004', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD1005', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('D1029', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1002', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1009', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1004', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD1001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CF1016', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1003', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1010', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('FZ1012', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1002B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MT1011', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('NI1004', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RH1005', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA1001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2003B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD2001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD2008', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD2009', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1004', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2017', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2007B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD2010', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('CD2011', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EG1005', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TC2003B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('TI2001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3111', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3112', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3113', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3114', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3115', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('VA3116', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD3003B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'LIT');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1020', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1010', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1058', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1012', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1013', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI1016', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI1018', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('SD1019', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1018', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('A1005', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AT1005', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1013', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1057', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IM1003', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('RI1017', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1017', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AV1010', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H2054', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IB1005', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('IB1006', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DS1009', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MA1042', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1019', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1011', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1012', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EH1014', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1059', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MB1002', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1006', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('P1014', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('DL1023', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EC1018', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('EM1011', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('H1063', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('MB1001', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('AD2035', 'OPTG');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP1007', 'OPTI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP2019', 'OPTI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP2026', 'OPTI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP2027', 'OPTI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP2028', 'OPTI');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3070', 'OPTA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3071', 'OPTA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3072', 'OPTA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3073', 'OPTA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3074', 'OPTA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3075', 'OPTA');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3076', 'OPTD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3077', 'OPTD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3078', 'OPTD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3079', 'OPTD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3080', 'OPTD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3081', 'OPTD');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3091', 'OPTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3092', 'OPTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3093', 'OPTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3094', 'OPTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3095', 'OPTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3096', 'OPTP');
INSERT INTO public."UnidadFormacionCarrera" ("idUF", "idCarrera") VALUES ('OP3001B', 'OPTP');

-- INSERTANDO LA POL??TICA POR DEFECTO

INSERT INTO public."Politica" ("idPolitica", titulo, descripcion, "fechaCreacion", "fechaUltimoCambio", status) VALUES (1, 'T??rminos y condiciones DE PRUEBA', 'Esta informaci??n la debe proporcionar PAE. \n Lorem ipsum, dolor sit amet consectetur adipisicing elit. Ducimus soluta nisi cupiditate error quo ut magnam rerum expedita eius. Accusantium nisi ad, consequatur reprehenderit veniam impedit temporibus esse optio neque. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nemo id iusto soluta neque explicabo? In quam enim repellendus eaque expedita nisi adipisci nihil optio fugit laborum, cupiditate iusto asperiores quaerat, praesentium totam! Possimus voluptatibus reprehenderit animi beatae itaque quaerat nemo. Atque, consectetur ea incidunt maxime perferendis architecto, dolorum veritatis hic illo iste voluptas cumque eos. Nobis, reiciendis. Ea dignissimos aspernatur numquam dolorum enim veritatis corporis ut? Debitis aliquid, facilis sunt quod atque quae adipisci veritatis perspiciatis vero nihil molestiae iure recusandae perferendis ratione sapiente beatae earum ipsum ullam dignissimos similique repellat libero! Quaerat, debitis ab facilis neque autem atque alias. Lorem ipsum dolor sit amet consectetur adipisicing elit. Modi assumenda ab quis cupiditate vero a dolores architecto illo? Minus vel nihil cumque consectetur doloribus illo obcaecati alias neque, possimus pariatur non magnam nisi, minima voluptate fugit rerum aperiam nostrum vero sapiente omnis laboriosam voluptatum. In ea quos sint aperiam temporibus eligendi qui fugit quibusdam aut! Reiciendis asperiores dolores sed quo animi qui incidunt placeat a repellat ullam quibusdam, ab autem aliquid distinctio! Omnis fugiat eveniet possimus, ut rem consequatur porro? Ipsam cupiditate odio nihil ratione eveniet qui iste sunt sit ullam velit adipisci corporis provident odit facilis totam sint ipsa quod, natus unde aliquam voluptate. Necessitatibus eligendi magni fugiat! A quasi eligendi ea, vero fugiat blanditiis rem nobis eum cupiditate maxime totam facere tenetur harum suscipit eaque voluptatum aliquam? Dolores vel voluptate aliquid veritatis distinctio quibusdam tempore unde autem, aperiam voluptates dicta delectus quis ad illo iusto, voluptatibus eos aspernatur id! Nulla iusto cumque, mollitia accusamus ut voluptas. Illum sed quas veniam iure temporibus sapiente minima aliquid praesentium quaerat harum enim quia ratione, exercitationem molestias illo. Ea tempore corrupti debitis quidem quisquam voluptatum perferendis in dolore, adipisci dignissimos doloribus, totam quod ut nisi soluta reiciendis quam et molestias. Nobis beatae quas tenetur vel eius porro et cumque sunt dicta aut recusandae quidem reprehenderit voluptate exercitationem illo, nulla explicabo iure dignissimos in! Dolor illo accusamus aperiam atque deserunt ad numquam aspernatur minima, consectetur soluta aliquid ratione blanditiis quam eveniet, enim, sit labore? Sequi in quam facilis minus eius tempora nulla explicabo perspiciatis sunt magnam, veniam, molestias quo sit autem. Cumque eligendi quos veniam omnis soluta laudantium? Ad, ex assumenda natus similique voluptatibus odit totam amet quasi maxime! Alias ut voluptatum in ipsam pariatur cumque excepturi itaque rem, ratione commodi vel fuga corporis id temporibus amet facere aliquid molestias maxime ea quidem neque, dignissimos dicta obcaecati quisquam? Culpa impedit officiis unde ut labore ex error excepturi exercitationem voluptate alias, nisi nemo iusto modi ratione commodi? Ratione molestias consectetur fugit, iure, suscipit id sed quibusdam expedita a repudiandae quisquam sint deserunt magnam harum voluptatem! Commodi illo eveniet inventore labore deserunt eius animi quis obcaecati consequuntur quasi mollitia, cupiditate incidunt voluptatibus atque. Voluptatem totam adipisci exercitationem sed error at fuga sint voluptatibus itaque laborum esse, sequi alias temporibus quam nesciunt hic nisi dolores quaerat atque, optio voluptas! Optio, culpa! Dicta esse reiciendis fugiat in similique, tempore laudantium, sit eos ut corrupti soluta officia atque! Qui nemo similique ullam dignissimos assumenda fugit illum ad asperiores nihil, quas labore, adipisci dolore repellat deserunt non exercitationem. Officia accusantium nesciunt cum amet voluptatum quibusdam earum in saepe, soluta laudantium officiis ducimus. Earum impedit sed reprehenderit explicabo nisi, provident eligendi enim culpa, veritatis maxime cupiditate. Necessitatibus ab perspiciatis hic cum doloribus. Debitis, laudantium expedita! Quod quo quibusdam, labore fugit nulla tenetur excepturi nemo? Sapiente maiores itaque incidunt atque repudiandae quod nulla rem exercitationem, libero voluptatem perspiciatis deserunt. Deserunt ipsa, aut nisi dicta voluptate quidem, nostrum ipsam minima, eveniet optio aliquid. Dolore dignissimos optio animi exercitationem velit distinctio dolorem eos?', '2022-05-22 23:45:06.790842', '2022-05-22 23:45:06.790842', 'vigente');


-- INSERTAMOS AL SUPER USUARIO DIRECTIVO
CALL registro_directivo(
  'L00000001', 
'e491ff9f556e10eff26bef77c627cc5783dfcee8e23ab6fd04da5124f73246a579d152e5bf3048db5da923f3942915ceb34af9ec5c740ec2a198ac121481a665', 
  'eaf1961e64647e5b', 
  'Directivo',
  'SuperUsuario',
  null,
  null,
  null
);

-- INSERTANDO EL ASESOR POR DEFECTO
CALL registro_datosperfil_asesor(
  'A00000000', 
  '5c8f26561d998ea232ff8514bf90d37b09360deda79a091b1876b3526011226a8f3953564fdf14f92e9f2daf0f45d64982dbb555f18e582e4b584f2ee927a635', 
  '0e6969b8083e7a3f', 
  'Asesor', 
  'Sin confirmar', 
  null, 
  null,
  null,
  'ITC',
  '', 
  1
);

---------------- IMPORTANTE ------------------

-- Es necesario implementar los triggers para:
--  > el cambio de status del horario de disponiblidad de los asesores cuando apartan
--  > el cambio de status de los periodos
--  > el cambio de status de los usuarios
