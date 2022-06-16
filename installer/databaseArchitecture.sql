--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Debian 13.7-0+deb11u1)
-- Dumped by pg_dump version 13.7 (Debian 13.7-0+deb11u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: estadoencuesta; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.estadoencuesta AS ENUM (
    'pendiente',
    'realizada',
    'cancelada'
);


ALTER TYPE public.estadoencuesta OWNER TO pae;

--
-- Name: idioma; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.idioma AS ENUM (
    'espanol',
    'ingles'
);


ALTER TYPE public.idioma OWNER TO pae;

--
-- Name: modo; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.modo AS ENUM (
    'claro',
    'oscuro'
);


ALTER TYPE public.modo OWNER TO pae;

--
-- Name: origennotificacion; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.origennotificacion AS ENUM (
    'Asesoria reservada',
    'Asesoria confirmada',
    'Asesoria cancelada',
    'PAE'
);


ALTER TYPE public.origennotificacion OWNER TO pae;

--
-- Name: roles; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.roles AS ENUM (
    'asesor',
    'asesorado',
    'directivo'
);


ALTER TYPE public.roles OWNER TO pae;

--
-- Name: statusaccess; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.statusaccess AS ENUM (
    'activo',
    'inactivo'
);


ALTER TYPE public.statusaccess OWNER TO pae;

--
-- Name: statusasesoria; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.statusasesoria AS ENUM (
    'reservada',
    'confirmada',
    'finalizada',
    'cancelada',
    'registrando'
);


ALTER TYPE public.statusasesoria OWNER TO pae;

--
-- Name: statushorario; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.statushorario AS ENUM (
    'disponible',
    'bloqueada',
    'reservada',
    'finalizada'
);


ALTER TYPE public.statushorario OWNER TO pae;

--
-- Name: statusperiodo; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.statusperiodo AS ENUM (
    'actual',
    'pasado'
);


ALTER TYPE public.statusperiodo OWNER TO pae;

--
-- Name: statuspolitica; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.statuspolitica AS ENUM (
    'vigente',
    'deprecado',
    'en revision'
);


ALTER TYPE public.statuspolitica OWNER TO pae;

--
-- Name: tipopregunta; Type: TYPE; Schema: public; Owner: pae
--

CREATE TYPE public.tipopregunta AS ENUM (
    'abierta',
    'cerrada'
);


ALTER TYPE public.tipopregunta OWNER TO pae;

--
-- Name: aceptarasesoria(character varying, character varying, character varying, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.aceptarasesoria(idasesor character varying, nombreuf character varying, idasesorado character varying, hora integer, dia integer, mes integer, anio integer)
    LANGUAGE plpgsql
    AS $$

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


ALTER PROCEDURE public.aceptarasesoria(idasesor character varying, nombreuf character varying, idasesorado character varying, hora integer, dia integer, mes integer, anio integer) OWNER TO pae;

--
-- Name: aceptarasesoria(character varying, character varying, character varying, integer, integer, integer, integer, text); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.aceptarasesoria(idasesor character varying, nombreuf character varying, idasesorado character varying, hora integer, dia integer, mes integer, anio integer, lugarasesoria text)
    LANGUAGE plpgsql
    AS $$

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


ALTER PROCEDURE public.aceptarasesoria(idasesor character varying, nombreuf character varying, idasesorado character varying, hora integer, dia integer, mes integer, anio integer, lugarasesoria text) OWNER TO pae;

--
-- Name: cancelarasesoria(character varying, character varying, integer, integer, integer, integer); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.cancelarasesoria(nombreuf character varying, idasesorado character varying, hora integer, dia integer, mes integer, anio integer)
    LANGUAGE plpgsql
    AS $$

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


ALTER PROCEDURE public.cancelarasesoria(nombreuf character varying, idasesorado character varying, hora integer, dia integer, mes integer, anio integer) OWNER TO pae;

--
-- Name: enviarnotificaciones(text, character varying, text); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.enviarnotificaciones(destinatario text, asunto character varying, mensaje text)
    LANGUAGE plpgsql
    AS $$

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


ALTER PROCEDURE public.enviarnotificaciones(destinatario text, asunto character varying, mensaje text) OWNER TO pae;

--
-- Name: get_allasesorias(integer, integer); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_allasesorias(mes integer, anio integer) RETURNS TABLE(numerodia double precision, status public.statusasesoria, hora double precision)
    LANGUAGE plpgsql
    AS $$

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
$$;


ALTER FUNCTION public.get_allasesorias(mes integer, anio integer) OWNER TO pae;

--
-- Name: get_asesoresdisponibles(integer, integer, integer, integer, character varying); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_asesoresdisponibles(hora integer, dia integer, mes integer, anio integer, nombreuf character varying) RETURNS TABLE(matricula character varying, nombre text)
    LANGUAGE plpgsql
    AS $$

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
$$;


ALTER FUNCTION public.get_asesoresdisponibles(hora integer, dia integer, mes integer, anio integer, nombreuf character varying) OWNER TO pae;

--
-- Name: get_asesorias_usuario(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_asesorias_usuario(idusuario character varying, mes integer, anio integer) RETURNS TABLE(numerodia double precision, status public.statusasesoria, hora double precision)
    LANGUAGE plpgsql
    AS $$

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
$$;


ALTER FUNCTION public.get_asesorias_usuario(idusuario character varying, mes integer, anio integer) OWNER TO pae;

--
-- Name: get_asesoriasasesordia(integer, integer, integer); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_asesoriasasesordia(dia integer, mes integer, anio integer) RETURNS TABLE(nombreasesor text, matricula character varying, claveuf character varying, horaasesoria double precision, contenido public.statusasesoria)
    LANGUAGE plpgsql
    AS $$

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
$$;


ALTER FUNCTION public.get_asesoriasasesordia(dia integer, mes integer, anio integer) OWNER TO pae;

--
-- Name: get_asesoriasasesordia(character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_asesoriasasesordia(idasesor character varying, dia integer, mes integer, anio integer) RETURNS TABLE(nombreasesor text, matricula character varying, claveuf character varying, horaasesoria double precision, contenido public.statusasesoria)
    LANGUAGE plpgsql
    AS $$

BEGIN

  RETURN QUERY
    SELECT
      (
        SELECT CONCAT("Usuario"."nombreUsuario", ' ', "Usuario"."apellidoPaterno", ' ', "Usuario"."apellidoMaterno")
        FROM "Usuario"
        WHERE "Usuario"."idUsuario" = idAsesor
      ) AS nombreAsesor,
      "Asesoria"."idAsesor" AS matricula,
      "Asesoria"."idUF" AS claveUF,
      EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora") AS horaAsesoria,
      "Asesoria"."status" AS contenido
    FROM "Asesoria", "HorarioDisponible"
    WHERE "Asesoria"."idHorarioDisponible" = "HorarioDisponible"."idHorarioDisponible"
    AND "Asesoria"."idAsesor" = idAsesor
    AND EXTRACT(DAY FROM "HorarioDisponible"."fechaHora") = dia
    AND EXTRACT(MONTH FROM "HorarioDisponible"."fechaHora") = mes
    AND EXTRACT(YEAR FROM "HorarioDisponible"."fechaHora") = anio
    GROUP BY
      "Asesoria"."idAsesor", "Asesoria"."idUF", EXTRACT(HOUR FROM "HorarioDisponible"."fechaHora"), "Asesoria"."status", (
        SELECT CONCAT("Usuario"."nombreUsuario", ' ', "Usuario"."apellidoPaterno", ' ', "Usuario"."apellidoMaterno")
        FROM "Usuario"
        WHERE "Usuario"."idUsuario" = idAsesor
      );

END;
$$;


ALTER FUNCTION public.get_asesoriasasesordia(idasesor character varying, dia integer, mes integer, anio integer) OWNER TO pae;

--
-- Name: get_dias_disponibles(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_dias_disponibles(iduf character varying, anio integer, mes integer) RETURNS TABLE(dias_disponibles double precision)
    LANGUAGE plpgsql
    AS $$
  
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
$$;


ALTER FUNCTION public.get_dias_disponibles(iduf character varying, anio integer, mes integer) OWNER TO pae;

--
-- Name: get_horas_disponibles(character varying, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_horas_disponibles(iduf character varying, anio integer, mes integer, dia integer) RETURNS TABLE(horas_disponibles double precision)
    LANGUAGE plpgsql
    AS $$
  
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
$$;


ALTER FUNCTION public.get_horas_disponibles(iduf character varying, anio integer, mes integer, dia integer) OWNER TO pae;

--
-- Name: get_info_encuesta(integer, character varying, public.roles); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_info_encuesta(idasesoria integer, matricula character varying, roluser public.roles) RETURNS TABLE(idencuesta integer, tituloencuesta text, descripcionencuesta text, fotoe text)
    LANGUAGE plpgsql
    AS $$

DECLARE
  encuesta INTEGER;
  foto TEXT;
  
BEGIN

  SELECT "idEncuesta" INTO encuesta FROM "Encuesta" WHERE "rol" = roluser;  

  SELECT "fotoEvidencia" INTO foto FROM "CalificacionEncuesta" WHERE "idEncuesta" = encuesta AND "idAsesoria" = idasesoria;

  RETURN QUERY
    SELECT "idEncuesta", "titulo", "descripcion", foto FROM "Encuesta" WHERE "idEncuesta" = encuesta;

END;
$$;


ALTER FUNCTION public.get_info_encuesta(idasesoria integer, matricula character varying, roluser public.roles) OWNER TO pae;

--
-- Name: get_info_perfil(character varying, public.roles); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_info_perfil(idusuario character varying, rol public.roles) RETURNS TABLE(nombreusuario character varying, telefonousuario character varying, carrerausuario1 character varying, carrerausuario2 character varying, semestreusuario smallint)
    LANGUAGE plpgsql
    AS $$

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
$$;


ALTER FUNCTION public.get_info_perfil(idusuario character varying, rol public.roles) OWNER TO pae;

--
-- Name: get_informacionasesoria(character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_informacionasesoria(idusuario character varying, horac integer, diac integer, mesc integer, anioc integer) RETURNS TABLE(hora double precision, dia double precision, mes double precision, anio double precision, usuario text, lugar text, uf character varying, duda text, image text, status public.statusasesoria)
    LANGUAGE plpgsql
    AS $$

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
$$;


ALTER FUNCTION public.get_informacionasesoria(idusuario character varying, horac integer, diac integer, mesc integer, anioc integer) OWNER TO pae;

--
-- Name: get_meses_inicio_fin_semestre(); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_meses_inicio_fin_semestre() RETURNS TABLE(mes_inicio_semestre double precision, mes_fin_semestre double precision)
    LANGUAGE plpgsql
    AS $$

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
$$;


ALTER FUNCTION public.get_meses_inicio_fin_semestre() OWNER TO pae;

--
-- Name: get_nombreusuario(character varying); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_nombreusuario(idusuario character varying) RETURNS TABLE(nombrecompleto text)
    LANGUAGE plpgsql
    AS $$
  
BEGIN

  RETURN QUERY
    SELECT coalesce("nombreUsuario", '') || ' ' || coalesce("apellidoPaterno", '') || ' ' || coalesce("apellidoMaterno", '') || ' - ' || coalesce("idUsuario", '') FROM "Usuario"
    WHERE "idUsuario" = idUsuario;

END;
$$;


ALTER FUNCTION public.get_nombreusuario(idusuario character varying) OWNER TO pae;

--
-- Name: get_notificaciones_usuario(character varying); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.get_notificaciones_usuario(idusuario character varying) RETURNS TABLE(origen public.origennotificacion, titulo character varying, leyenda timestamp without time zone, contenido text)
    LANGUAGE plpgsql
    AS $$

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
$$;



ALTER FUNCTION public.get_notificaciones_usuario(idusuario character varying) OWNER TO pae;

--
-- Name: new_asesoria(character varying, character varying); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.new_asesoria(idasesorado character varying, iduf character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.new_asesoria(idasesorado character varying, iduf character varying) OWNER TO pae;

--
-- Name: nueva_asesoria(character varying, character varying, integer); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.nueva_asesoria(idasesorado character varying, iduf character varying, idhorariodisponible integer)
    LANGUAGE plpgsql
    AS $$

DECLARE
  randomasesor VARCHAR(10);

BEGIN
  
  SELECT "idUsuario" FROM "Usuario" WHERE "rol" = 'asesor' LIMIT 1 INTO randomasesor;
  INSERT INTO "Asesoria" 
    ("idAsesoria", "idAsesor", "idAsesorado", "idUF", "status", "descripcionDuda", "lugar", "idHorarioDisponible")
  VALUES 
    (DEFAULT, randomasesor, idAsesorado, idUF, 'reservada', NULL, NULL, idHorarioDisponible);
  
END
$$;


ALTER PROCEDURE public.nueva_asesoria(idasesorado character varying, iduf character varying, idhorariodisponible integer) OWNER TO pae;

--
-- Name: nueva_asesoria(character varying, integer, integer, integer, integer, character varying, integer, text); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.nueva_asesoria(iduf character varying, anio integer, mes integer, dia integer, hora integer, idasesorado character varying, idhorariodisponible integer, duda text) RETURNS integer
    LANGUAGE plpgsql
    AS $$

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
$$;


ALTER FUNCTION public.nueva_asesoria(iduf character varying, anio integer, mes integer, dia integer, hora integer, idasesorado character varying, idhorariodisponible integer, duda text) OWNER TO pae;

--
-- Name: registro_asesorado(character varying, text, character varying, character varying, character varying, character varying, text, character varying); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.registro_asesorado(matriculausr character varying, passwordusr text, saltusr character varying, nombreusr character varying, apellidopaternousr character varying, apellidomaternousr character varying, fotoperfilusr text, telefonousr character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "Usuario" 
    ("idUsuario", "rol", "nombreUsuario", "apellidoPaterno", "fotoPerfil", "ultimaConexion", "statusAcceso", "telefono", "apellidoMaterno")
  VALUES 
    (matriculaUsr, 'asesorado', nombreUsr, apellidoPaternoUsr, fotoPerfilUsr, CURRENT_TIMESTAMP, 'activo', telefonoUsr, apellidoMaternoUsr);
  INSERT INTO "Acceso" ("idUsuario", "password", "salt") VALUES 
    (matriculaUsr, passwordUsr, saltUsr);
  INSERT INTO "Preferencia" ("idUsuario", "modoInterfaz", "lenguaje", "subscripcionCorreo") VALUES
    (matriculaUsr, 'claro', 'espanol', TRUE);
END
$$;


ALTER PROCEDURE public.registro_asesorado(matriculausr character varying, passwordusr text, saltusr character varying, nombreusr character varying, apellidopaternousr character varying, apellidomaternousr character varying, fotoperfilusr text, telefonousr character varying) OWNER TO pae;

--
-- Name: registro_asesorado(character varying, text, character varying, character varying, character varying, character varying, text, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.registro_asesorado(matriculausr character varying, passwordusr text, saltusr character varying, nombreusr character varying, apellidopaternousr character varying, apellidomaternousr character varying, fotoperfilusr text, telefonousr character varying, carrerausr character varying)
    LANGUAGE plpgsql
    AS $$
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


ALTER PROCEDURE public.registro_asesorado(matriculausr character varying, passwordusr text, saltusr character varying, nombreusr character varying, apellidopaternousr character varying, apellidomaternousr character varying, fotoperfilusr text, telefonousr character varying, carrerausr character varying) OWNER TO pae;

--
-- Name: registro_datosperfil_asesor(character varying, text, character varying, character varying, character varying, character varying, text, character varying, character varying, character varying, integer); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.registro_datosperfil_asesor(matriculausr character varying, passwordusr text, saltusr character varying, nombreusr character varying, apellidopaternousr character varying, apellidomaternousr character varying, fotoperfilusr text, telefonousr character varying, carrerausr character varying, carrera2usr character varying, semestreusr integer)
    LANGUAGE plpgsql
    AS $$
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


ALTER PROCEDURE public.registro_datosperfil_asesor(matriculausr character varying, passwordusr text, saltusr character varying, nombreusr character varying, apellidopaternousr character varying, apellidomaternousr character varying, fotoperfilusr text, telefonousr character varying, carrerausr character varying, carrera2usr character varying, semestreusr integer) OWNER TO pae;

--
-- Name: registro_directivo(character varying, text, character varying, character varying, character varying, character varying, text, character varying); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.registro_directivo(matriculausr character varying, passwordusr text, saltusr character varying, nombreusr character varying, apellidopaternousr character varying, apellidomaternousr character varying, fotoperfilusr text, telefonousr character varying)
    LANGUAGE plpgsql
    AS $$
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


ALTER PROCEDURE public.registro_directivo(matriculausr character varying, passwordusr text, saltusr character varying, nombreusr character varying, apellidopaternousr character varying, apellidomaternousr character varying, fotoperfilusr text, telefonousr character varying) OWNER TO pae;

--
-- Name: update_info_perfil(character varying, public.roles, text, character varying, character varying, character varying, smallint); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.update_info_perfil(idusr character varying, rolusr public.roles, fotousr text, telefonousr character varying, carrera1 character varying, carrera2 character varying, semestreusr smallint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  
  UPDATE "Usuario" SET "fotoPerfil" = fotoUsr, "ultimaConexion" = CURRENT_TIMESTAMP, "telefono" = telefonoUsr WHERE "idUsuario" = idUsr;

  IF rolUsr = 'asesor' THEN
    UPDATE "Asesor" SET "semestre" = semestreUsr WHERE "idUsuario" = idUsr;
  END IF;

  IF rolUsr <> 'directivo' THEN 
    
    DELETE FROM "EstudianteCarrera" WHERE "idUsuario" = idUsr;
  
    INSERT INTO "EstudianteCarrera" ("idCarrera" ,"idUsuario") VALUES (carrera1, idUsr);
    
    IF carrera2 <> '' THEN 
      INSERT INTO "EstudianteCarrera" ("idCarrera" ,"idUsuario") VALUES (carrera2, idUsr);
    END IF;
    
  END IF;

END
$$;


ALTER PROCEDURE public.update_info_perfil(idusr character varying, rolusr public.roles, fotousr text, telefonousr character varying, carrera1 character varying, carrera2 character varying, semestreusr smallint) OWNER TO pae;

--
-- Name: update_periodos(timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone, timestamp without time zone); Type: PROCEDURE; Schema: public; Owner: pae
--

CREATE PROCEDURE public.update_periodos(inicioperiodo1 timestamp without time zone, finperiodo1 timestamp without time zone, inicioperiodo2 timestamp without time zone, finperiodo2 timestamp without time zone, inicioperiodo3 timestamp without time zone, finperiodo3 timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
  UPDATE "Periodo" SET "status" = 'pasado' WHERE "status" = 'actual';

  INSERT INTO "Periodo" 
    ("idPeriodo", "numero", "fechaInicial", "fechaFinal", "status")
  VALUES 
    (DEFAULT, 1, inicioPeriodo1, finPeriodo1, 'actual'),
    (DEFAULT, 2, inicioPeriodo2, finPeriodo2, 'actual'),
    (DEFAULT, 3, inicioPeriodo3, finPeriodo3, 'actual');
END
$$;


ALTER PROCEDURE public.update_periodos(inicioperiodo1 timestamp without time zone, finperiodo1 timestamp without time zone, inicioperiodo2 timestamp without time zone, finperiodo2 timestamp without time zone, inicioperiodo3 timestamp without time zone, finperiodo3 timestamp without time zone) OWNER TO pae;

--
-- Name: update_ultima_conexion(character varying); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.update_ultima_conexion(idusuario character varying) RETURNS TABLE(nombre_user text, rol_user public.roles, foto_user text, modo_user public.modo, idioma_user public.idioma)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.update_ultima_conexion(idusuario character varying) OWNER TO pae;

--
-- Name: verificar_horarios_disponibles(character varying, integer, integer, integer, integer); Type: FUNCTION; Schema: public; Owner: pae
--

CREATE FUNCTION public.verificar_horarios_disponibles(iduf character varying, anio integer, mes integer, dia integer, hora integer) RETURNS TABLE(idhorariodisponible integer)
    LANGUAGE plpgsql
    AS $$
  
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
$$;


ALTER FUNCTION public.verificar_horarios_disponibles(iduf character varying, anio integer, mes integer, dia integer, hora integer) OWNER TO pae;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Acceso; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Acceso" (
    "idUsuario" character varying(10) NOT NULL,
    password text NOT NULL,
    salt character varying(16) NOT NULL
);


ALTER TABLE public."Acceso" OWNER TO pae;

--
-- Name: Asesor; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Asesor" (
    "idUsuario" character varying(10) NOT NULL,
    semestre smallint NOT NULL,
    "cantidadCambioHorario" smallint NOT NULL
);


ALTER TABLE public."Asesor" OWNER TO pae;

--
-- Name: AsesorUnidadFormacion; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."AsesorUnidadFormacion" (
    "idUsuario" character varying(10) NOT NULL,
    "idUF" character varying(50) NOT NULL
);


ALTER TABLE public."AsesorUnidadFormacion" OWNER TO pae;

--
-- Name: Asesoria; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Asesoria" (
    "idAsesoria" integer NOT NULL,
    "idAsesor" character varying(10) NOT NULL,
    "idAsesorado" character varying(10) NOT NULL,
    "idUF" character varying(50) NOT NULL,
    status public.statusasesoria NOT NULL,
    "descripcionDuda" text,
    lugar text,
    "idHorarioDisponible" integer NOT NULL
);


ALTER TABLE public."Asesoria" OWNER TO pae;

--
-- Name: AsesoriaImagen; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."AsesoriaImagen" (
    "idAsesoria" integer NOT NULL,
    imagen text
);


ALTER TABLE public."AsesoriaImagen" OWNER TO pae;

--
-- Name: Asesoria_idAsesoria_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."Asesoria_idAsesoria_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Asesoria_idAsesoria_seq" OWNER TO pae;

--
-- Name: Asesoria_idAsesoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."Asesoria_idAsesoria_seq" OWNED BY public."Asesoria"."idAsesoria";


--
-- Name: CalificacionEncuesta; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."CalificacionEncuesta" (
    "idCalificacionEncuesta" integer NOT NULL,
    "idEncuesta" integer NOT NULL,
    "idAsesoria" integer NOT NULL,
    estado public.estadoencuesta,
    "fotoEvidencia" text,
    fecha timestamp without time zone NOT NULL
);


ALTER TABLE public."CalificacionEncuesta" OWNER TO pae;

--
-- Name: CalificacionEncuesta_idCalificacionEncuesta_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."CalificacionEncuesta_idCalificacionEncuesta_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CalificacionEncuesta_idCalificacionEncuesta_seq" OWNER TO pae;

--
-- Name: CalificacionEncuesta_idCalificacionEncuesta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."CalificacionEncuesta_idCalificacionEncuesta_seq" OWNED BY public."CalificacionEncuesta"."idCalificacionEncuesta";


--
-- Name: CalificacionPregunta; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."CalificacionPregunta" (
    "idCalificacionPregunta" integer NOT NULL,
    "idCalificacionEncuesta" integer NOT NULL,
    "idPregunta" integer NOT NULL,
    respuesta text
);


ALTER TABLE public."CalificacionPregunta" OWNER TO pae;

--
-- Name: CalificacionPregunta_idCalificacionPregunta_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."CalificacionPregunta_idCalificacionPregunta_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."CalificacionPregunta_idCalificacionPregunta_seq" OWNER TO pae;

--
-- Name: CalificacionPregunta_idCalificacionPregunta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."CalificacionPregunta_idCalificacionPregunta_seq" OWNED BY public."CalificacionPregunta"."idCalificacionPregunta";


--
-- Name: Carrera; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Carrera" (
    "idCarrera" character varying(5) NOT NULL,
    "nombreCarrera" character varying(100) NOT NULL
);


ALTER TABLE public."Carrera" OWNER TO pae;

--
-- Name: Encuesta; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Encuesta" (
    "idEncuesta" integer NOT NULL,
    titulo text,
    descripcion text,
    rol public.roles
);


ALTER TABLE public."Encuesta" OWNER TO pae;

--
-- Name: Encuesta_idEncuesta_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."Encuesta_idEncuesta_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Encuesta_idEncuesta_seq" OWNER TO pae;

--
-- Name: Encuesta_idEncuesta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."Encuesta_idEncuesta_seq" OWNED BY public."Encuesta"."idEncuesta";


--
-- Name: EstudianteCarrera; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."EstudianteCarrera" (
    "idCarrera" character varying(5) NOT NULL,
    "idUsuario" character varying(10) NOT NULL
);


ALTER TABLE public."EstudianteCarrera" OWNER TO pae;

--
-- Name: HorarioDisponible; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."HorarioDisponible" (
    "idHorarioDisponible" integer NOT NULL,
    "idHorarioDisponiblePeriodo" integer NOT NULL,
    "fechaHora" timestamp without time zone NOT NULL,
    status public.statushorario NOT NULL
);


ALTER TABLE public."HorarioDisponible" OWNER TO pae;

--
-- Name: HorarioDisponiblePeriodo; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."HorarioDisponiblePeriodo" (
    "idHorarioDisponiblePeriodo" integer NOT NULL,
    "idAsesor" character varying(10) NOT NULL,
    "idPeriodo" integer NOT NULL
);


ALTER TABLE public."HorarioDisponiblePeriodo" OWNER TO pae;

--
-- Name: HorarioDisponiblePeriodo_idHorarioDisponiblePeriodo_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."HorarioDisponiblePeriodo_idHorarioDisponiblePeriodo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."HorarioDisponiblePeriodo_idHorarioDisponiblePeriodo_seq" OWNER TO pae;

--
-- Name: HorarioDisponiblePeriodo_idHorarioDisponiblePeriodo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."HorarioDisponiblePeriodo_idHorarioDisponiblePeriodo_seq" OWNED BY public."HorarioDisponiblePeriodo"."idHorarioDisponiblePeriodo";


--
-- Name: HorarioDisponible_idHorarioDisponible_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."HorarioDisponible_idHorarioDisponible_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."HorarioDisponible_idHorarioDisponible_seq" OWNER TO pae;

--
-- Name: HorarioDisponible_idHorarioDisponible_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."HorarioDisponible_idHorarioDisponible_seq" OWNED BY public."HorarioDisponible"."idHorarioDisponible";


--
-- Name: Notificacion; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Notificacion" (
    "idNotificacion" integer NOT NULL,
    origen public.origennotificacion NOT NULL,
    titulo character varying(200),
    "fechaHora" timestamp without time zone NOT NULL,
    descripcion text
);


ALTER TABLE public."Notificacion" OWNER TO pae;

--
-- Name: NotificacionUsuario; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."NotificacionUsuario" (
    "idNotificacion" integer NOT NULL,
    "idUsuario" character varying(10) NOT NULL
);


ALTER TABLE public."NotificacionUsuario" OWNER TO pae;

--
-- Name: Notificacion_idNotificacion_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."Notificacion_idNotificacion_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Notificacion_idNotificacion_seq" OWNER TO pae;

--
-- Name: Notificacion_idNotificacion_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."Notificacion_idNotificacion_seq" OWNED BY public."Notificacion"."idNotificacion";


--
-- Name: Periodo; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Periodo" (
    "idPeriodo" integer NOT NULL,
    numero smallint NOT NULL,
    "fechaInicial" timestamp without time zone NOT NULL,
    "fechaFinal" timestamp without time zone NOT NULL,
    status public.statusperiodo NOT NULL
);


ALTER TABLE public."Periodo" OWNER TO pae;

--
-- Name: Periodo_idPeriodo_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."Periodo_idPeriodo_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Periodo_idPeriodo_seq" OWNER TO pae;

--
-- Name: Periodo_idPeriodo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."Periodo_idPeriodo_seq" OWNED BY public."Periodo"."idPeriodo";


--
-- Name: Politica; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Politica" (
    "idPolitica" integer NOT NULL,
    titulo character varying(50) NOT NULL,
    descripcion text,
    "fechaCreacion" timestamp without time zone NOT NULL,
    "fechaUltimoCambio" timestamp without time zone NOT NULL,
    status public.statuspolitica NOT NULL
);


ALTER TABLE public."Politica" OWNER TO pae;

--
-- Name: PoliticaDocumento; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."PoliticaDocumento" (
    "idPolitica" integer NOT NULL,
    titulo character varying(50) NOT NULL,
    documento text NOT NULL
);


ALTER TABLE public."PoliticaDocumento" OWNER TO pae;

--
-- Name: Politica_idPolitica_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."Politica_idPolitica_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Politica_idPolitica_seq" OWNER TO pae;

--
-- Name: Politica_idPolitica_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."Politica_idPolitica_seq" OWNED BY public."Politica"."idPolitica";


--
-- Name: Preferencia; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Preferencia" (
    "idUsuario" character varying(10) NOT NULL,
    "modoInterfaz" public.modo,
    lenguaje public.idioma,
    "subscripcionCorreo" boolean
);


ALTER TABLE public."Preferencia" OWNER TO pae;

--
-- Name: Pregunta; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Pregunta" (
    "idPregunta" integer NOT NULL,
    "idEncuesta" integer NOT NULL,
    tipo public.tipopregunta,
    pregunta text,
    "opcionesRespuesta" text
);


ALTER TABLE public."Pregunta" OWNER TO pae;

--
-- Name: Pregunta_idPregunta_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."Pregunta_idPregunta_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Pregunta_idPregunta_seq" OWNER TO pae;

--
-- Name: Pregunta_idPregunta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."Pregunta_idPregunta_seq" OWNED BY public."Pregunta"."idPregunta";


--
-- Name: Profesor; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Profesor" (
    "idProfesor" integer NOT NULL,
    nombre character varying(50) NOT NULL,
    correo character varying(50) NOT NULL
);


ALTER TABLE public."Profesor" OWNER TO pae;

--
-- Name: ProfesorUnidadFormacion; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."ProfesorUnidadFormacion" (
    "idProfesor" integer NOT NULL,
    "idUF" character varying(50) NOT NULL
);


ALTER TABLE public."ProfesorUnidadFormacion" OWNER TO pae;

--
-- Name: Profesor_idProfesor_seq; Type: SEQUENCE; Schema: public; Owner: pae
--

CREATE SEQUENCE public."Profesor_idProfesor_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Profesor_idProfesor_seq" OWNER TO pae;

--
-- Name: Profesor_idProfesor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pae
--

ALTER SEQUENCE public."Profesor_idProfesor_seq" OWNED BY public."Profesor"."idProfesor";


--
-- Name: UnidadFormacion; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."UnidadFormacion" (
    "idUF" character varying(50) NOT NULL,
    "nombreUF" character varying(100) NOT NULL,
    semestre smallint NOT NULL
);


ALTER TABLE public."UnidadFormacion" OWNER TO pae;

--
-- Name: UnidadFormacionCarrera; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."UnidadFormacionCarrera" (
    "idUF" character varying(50) NOT NULL,
    "idCarrera" character varying(5) NOT NULL
);


ALTER TABLE public."UnidadFormacionCarrera" OWNER TO pae;

--
-- Name: Usuario; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public."Usuario" (
    "idUsuario" character varying(10) NOT NULL,
    rol public.roles,
    "nombreUsuario" character varying(50) NOT NULL,
    "apellidoPaterno" character varying(30) NOT NULL,
    "fotoPerfil" text,
    "ultimaConexion" timestamp without time zone,
    "statusAcceso" public.statusaccess,
    telefono character varying(10),
    "apellidoMaterno" character varying(30)
);


ALTER TABLE public."Usuario" OWNER TO pae;

--
-- Name: rol; Type: TABLE; Schema: public; Owner: pae
--

CREATE TABLE public.rol (
    rol public.roles
);


ALTER TABLE public.rol OWNER TO pae;

--
-- Name: usuarios; Type: VIEW; Schema: public; Owner: pae
--

CREATE VIEW public.usuarios AS
 SELECT "Usuario"."idUsuario",
    "Usuario".rol,
    "Usuario"."nombreUsuario",
    "Usuario"."apellidoPaterno",
    "Usuario"."apellidoMaterno",
    "Usuario".telefono,
    "Usuario"."ultimaConexion",
    "Usuario"."statusAcceso"
   FROM public."Usuario";


ALTER TABLE public.usuarios OWNER TO pae;

--
-- Name: Asesoria idAsesoria; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Asesoria" ALTER COLUMN "idAsesoria" SET DEFAULT nextval('public."Asesoria_idAsesoria_seq"'::regclass);


--
-- Name: CalificacionEncuesta idCalificacionEncuesta; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."CalificacionEncuesta" ALTER COLUMN "idCalificacionEncuesta" SET DEFAULT nextval('public."CalificacionEncuesta_idCalificacionEncuesta_seq"'::regclass);


--
-- Name: CalificacionPregunta idCalificacionPregunta; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."CalificacionPregunta" ALTER COLUMN "idCalificacionPregunta" SET DEFAULT nextval('public."CalificacionPregunta_idCalificacionPregunta_seq"'::regclass);


--
-- Name: Encuesta idEncuesta; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Encuesta" ALTER COLUMN "idEncuesta" SET DEFAULT nextval('public."Encuesta_idEncuesta_seq"'::regclass);


--
-- Name: HorarioDisponible idHorarioDisponible; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."HorarioDisponible" ALTER COLUMN "idHorarioDisponible" SET DEFAULT nextval('public."HorarioDisponible_idHorarioDisponible_seq"'::regclass);


--
-- Name: HorarioDisponiblePeriodo idHorarioDisponiblePeriodo; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."HorarioDisponiblePeriodo" ALTER COLUMN "idHorarioDisponiblePeriodo" SET DEFAULT nextval('public."HorarioDisponiblePeriodo_idHorarioDisponiblePeriodo_seq"'::regclass);


--
-- Name: Notificacion idNotificacion; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Notificacion" ALTER COLUMN "idNotificacion" SET DEFAULT nextval('public."Notificacion_idNotificacion_seq"'::regclass);


--
-- Name: Periodo idPeriodo; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Periodo" ALTER COLUMN "idPeriodo" SET DEFAULT nextval('public."Periodo_idPeriodo_seq"'::regclass);


--
-- Name: Politica idPolitica; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Politica" ALTER COLUMN "idPolitica" SET DEFAULT nextval('public."Politica_idPolitica_seq"'::regclass);


--
-- Name: Pregunta idPregunta; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Pregunta" ALTER COLUMN "idPregunta" SET DEFAULT nextval('public."Pregunta_idPregunta_seq"'::regclass);


--
-- Name: Profesor idProfesor; Type: DEFAULT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Profesor" ALTER COLUMN "idProfesor" SET DEFAULT nextval('public."Profesor_idProfesor_seq"'::regclass);


--
-- Data for Name: Acceso; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Acceso" ("idUsuario", password, salt) VALUES ('L00000001', 'e491ff9f556e10eff26bef77c627cc5783dfcee8e23ab6fd04da5124f73246a579d152e5bf3048db5da923f3942915ceb34af9ec5c740ec2a198ac121481a665', 'eaf1961e64647e5b');
INSERT INTO public."Acceso" ("idUsuario", password, salt) VALUES ('A00000000', '5c8f26561d998ea232ff8514bf90d37b09360deda79a091b1876b3526011226a8f3953564fdf14f92e9f2daf0f45d64982dbb555f18e582e4b584f2ee927a635', '0e6969b8083e7a3f');


--
-- Data for Name: Asesor; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Asesor" ("idUsuario", semestre, "cantidadCambioHorario") VALUES ('A00000000', 1, 0);


--
-- Data for Name: AsesorUnidadFormacion; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: Asesoria; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: AsesoriaImagen; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: CalificacionEncuesta; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: CalificacionPregunta; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: Carrera; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ITC', 'Ingeniería en Tecnologías Computacionales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IBT', 'Ingeniería en Biotecnología');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IMT', 'Ingeniería en Mecatrónica');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('AMC', 'Ambiente Construido/ Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ESC', 'Estudios Creativos / Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ARQ', 'Arquitecto');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LAD', 'Licenciado en Arte Digital');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LDI', 'Licenciado en Diseño');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LUB', 'Licenciado en Urbanismo');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('CIS', 'Derecho, Economía y Relaciones Internacionales / Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LEC', 'Licenciado en Economía');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LED', 'Licenciado en Derecho');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LRI', 'Licenciado en Relaciones Internacionales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LTP', 'Licenciado en Gobierno y Transformación Pública');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LC', 'Licenciado en Comunicación');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LEI', 'Licenciado en Innovación Educativa');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LLE', 'Licenciado en Letras Hispánicas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LPE', 'Licenciado en Periodismo');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LTM', 'Licenciado en Tecnología y Producción Musical');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IBQ', 'Ingeniería - Bioingeniería y Procesos Químicos (avenida) / Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IAG', 'Ingeniero en Biosistemas Agroalimentarios');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IAL', 'Ingeniero en Alimentos');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IDS', 'Ingeniero en Desarrollo Sustentable');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IQ', 'Ingeniero Químico');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ICI', 'Ingeniería - Ciencias Aplicadas (avenida) / Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IDM', 'Ingeniero en Ciencia de Datos y Matemáticas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IFI', 'Ingeniero Físico Industrial');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('INA', 'Ingeniero en Nanotecnología');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ICT', 'Ingeniería - Computación y Tecnologías de Información (avenida) / Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IRS', 'Ingeniero en Robótica y Sistemas Digitales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('ITD', 'Ingeniero en Transformación Digital de Negocios');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IIT', 'Ingeniería - Innovación y Transformación (avenida) / Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('BIE', 'Ingeniero Industrial y de Sistemas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('BME', 'Ingeniero en Mecatrónica');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IC', 'Ingeniero Civil');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IE', 'Ingeniero en Electrónica');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IID', 'Ingeniero en Innovación y Desarrollo');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IIS', 'Ingeniero Industrial y de Sistemas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IM', 'Ingeniero Mecánico');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('IMD', 'Ingeniero Biomédico');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('SLD', 'Salud / Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LBC', 'Licenciado en Biociencias');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LNB', 'Licenciado en Nutrición y Bienestar Integral');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LPS', 'Licenciado en Psicología Clínica y de la Salud');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('MC', 'Médico Cirujano');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('MO', 'Médico Cirujano Odontólogo');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('NEG', 'Negocios / Exploración');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('BGB', 'Licenciado en Negocios Internacionales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LAE', 'Licenciado en Estrategia y Transformación de Negocios');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LAF', 'Licenciado en Finanzas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LCPF', 'Licenciado en Contaduría Pública y Finanzas');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LDE', 'Licenciado en Emprendimiento');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LDO', 'Licenciado en Desarrollo de Talento y Cultura Organizacional');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LEM', 'Licenciado en Mercadotecnia');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LIN', 'Licenciado en Negocios Internacionales');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('LIT', 'Licenciado en Inteligencia de Negocios');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTG', 'Optativa General');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTI', 'Optativa de Ingeniería');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTA', 'Optativa de Arte Digital');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTD', 'Optativa de Diseño');
INSERT INTO public."Carrera" ("idCarrera", "nombreCarrera") VALUES ('OPTP', 'Optativa Profesional');


--
-- Data for Name: Encuesta; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Encuesta" ("idEncuesta", titulo, descripcion, rol) VALUES (1, 'Encuesta post-asesoría para ASESORES', '¡Hola! Gracias por tu trabajo en PAE. Recuerda que llenar esta encuesta es importante ya que las respuestas son las que contarán como asesorías impartidas. No olvides que debes subir una foto como evidencia de la asesoría.', 'asesor');
INSERT INTO public."Encuesta" ("idEncuesta", titulo, descripcion, rol) VALUES (2, 'Encuesta post-asesoría para ESTUDIANTES', 'Gracias por utilizar PAE, la retroalimentación que nos das nos sirve mucho para mejorar en las próximas asesorías', 'asesorado');


--
-- Data for Name: EstudianteCarrera; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."EstudianteCarrera" ("idCarrera", "idUsuario") VALUES ('ITC', 'A00000000');

--
-- Data for Name: HorarioDisponible; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: HorarioDisponiblePeriodo; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: Notificacion; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: NotificacionUsuario; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: Periodo; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Periodo" ("idPeriodo", numero, "fechaInicial", "fechaFinal", status) VALUES (1, 1, '2022-02-14 00:00:00', '2022-03-18 23:59:59', 'actual');
INSERT INTO public."Periodo" ("idPeriodo", numero, "fechaInicial", "fechaFinal", status) VALUES (2, 2, '2022-03-28 00:00:00', '2022-05-07 23:59:59', 'actual');
INSERT INTO public."Periodo" ("idPeriodo", numero, "fechaInicial", "fechaFinal", status) VALUES (3, 3, '2022-05-23 00:00:00', '2022-06-24 23:59:59', 'actual');


--
-- Data for Name: Politica; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Politica" ("idPolitica", titulo, descripcion, "fechaCreacion", "fechaUltimoCambio", status) VALUES (1, 'Términos y condiciones DE PRUEBA', 'Esta información la debe proporcionar PAE. \n Lorem ipsum, dolor sit amet consectetur adipisicing elit. Ducimus soluta nisi cupiditate error quo ut magnam rerum expedita eius. Accusantium nisi ad, consequatur reprehenderit veniam impedit temporibus esse optio neque. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Nemo id iusto soluta neque explicabo? In quam enim repellendus eaque expedita nisi adipisci nihil optio fugit laborum, cupiditate iusto asperiores quaerat, praesentium totam! Possimus voluptatibus reprehenderit animi beatae itaque quaerat nemo. Atque, consectetur ea incidunt maxime perferendis architecto, dolorum veritatis hic illo iste voluptas cumque eos. Nobis, reiciendis. Ea dignissimos aspernatur numquam dolorum enim veritatis corporis ut? Debitis aliquid, facilis sunt quod atque quae adipisci veritatis perspiciatis vero nihil molestiae iure recusandae perferendis ratione sapiente beatae earum ipsum ullam dignissimos similique repellat libero! Quaerat, debitis ab facilis neque autem atque alias. Lorem ipsum dolor sit amet consectetur adipisicing elit. Modi assumenda ab quis cupiditate vero a dolores architecto illo? Minus vel nihil cumque consectetur doloribus illo obcaecati alias neque, possimus pariatur non magnam nisi, minima voluptate fugit rerum aperiam nostrum vero sapiente omnis laboriosam voluptatum. In ea quos sint aperiam temporibus eligendi qui fugit quibusdam aut! Reiciendis asperiores dolores sed quo animi qui incidunt placeat a repellat ullam quibusdam, ab autem aliquid distinctio! Omnis fugiat eveniet possimus, ut rem consequatur porro? Ipsam cupiditate odio nihil ratione eveniet qui iste sunt sit ullam velit adipisci corporis provident odit facilis totam sint ipsa quod, natus unde aliquam voluptate. Necessitatibus eligendi magni fugiat! A quasi eligendi ea, vero fugiat blanditiis rem nobis eum cupiditate maxime totam facere tenetur harum suscipit eaque voluptatum aliquam? Dolores vel voluptate aliquid veritatis distinctio quibusdam tempore unde autem, aperiam voluptates dicta delectus quis ad illo iusto, voluptatibus eos aspernatur id! Nulla iusto cumque, mollitia accusamus ut voluptas. Illum sed quas veniam iure temporibus sapiente minima aliquid praesentium quaerat harum enim quia ratione, exercitationem molestias illo. Ea tempore corrupti debitis quidem quisquam voluptatum perferendis in dolore, adipisci dignissimos doloribus, totam quod ut nisi soluta reiciendis quam et molestias. Nobis beatae quas tenetur vel eius porro et cumque sunt dicta aut recusandae quidem reprehenderit voluptate exercitationem illo, nulla explicabo iure dignissimos in! Dolor illo accusamus aperiam atque deserunt ad numquam aspernatur minima, consectetur soluta aliquid ratione blanditiis quam eveniet, enim, sit labore? Sequi in quam facilis minus eius tempora nulla explicabo perspiciatis sunt magnam, veniam, molestias quo sit autem. Cumque eligendi quos veniam omnis soluta laudantium? Ad, ex assumenda natus similique voluptatibus odit totam amet quasi maxime! Alias ut voluptatum in ipsam pariatur cumque excepturi itaque rem, ratione commodi vel fuga corporis id temporibus amet facere aliquid molestias maxime ea quidem neque, dignissimos dicta obcaecati quisquam? Culpa impedit officiis unde ut labore ex error excepturi exercitationem voluptate alias, nisi nemo iusto modi ratione commodi? Ratione molestias consectetur fugit, iure, suscipit id sed quibusdam expedita a repudiandae quisquam sint deserunt magnam harum voluptatem! Commodi illo eveniet inventore labore deserunt eius animi quis obcaecati consequuntur quasi mollitia, cupiditate incidunt voluptatibus atque. Voluptatem totam adipisci exercitationem sed error at fuga sint voluptatibus itaque laborum esse, sequi alias temporibus quam nesciunt hic nisi dolores quaerat atque, optio voluptas! Optio, culpa! Dicta esse reiciendis fugiat in similique, tempore laudantium, sit eos ut corrupti soluta officia atque! Qui nemo similique ullam dignissimos assumenda fugit illum ad asperiores nihil, quas labore, adipisci dolore repellat deserunt non exercitationem. Officia accusantium nesciunt cum amet voluptatum quibusdam earum in saepe, soluta laudantium officiis ducimus. Earum impedit sed reprehenderit explicabo nisi, provident eligendi enim culpa, veritatis maxime cupiditate. Necessitatibus ab perspiciatis hic cum doloribus. Debitis, laudantium expedita! Quod quo quibusdam, labore fugit nulla tenetur excepturi nemo? Sapiente maiores itaque incidunt atque repudiandae quod nulla rem exercitationem, libero voluptatem perspiciatis deserunt. Deserunt ipsa, aut nisi dicta voluptate quidem, nostrum ipsam minima, eveniet optio aliquid. Dolore dignissimos optio animi exercitationem velit distinctio dolorem eos?', '2022-05-22 23:45:06.790842', '2022-05-22 23:45:06.790842', 'vigente');


--
-- Data for Name: PoliticaDocumento; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: Preferencia; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Preferencia" ("idUsuario", "modoInterfaz", lenguaje, "subscripcionCorreo") VALUES ('L00000001', 'claro', 'espanol', true);


--
-- Data for Name: Pregunta; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (21, 1, 'cerrada', '¿La asesoría se llevó a cabo en la materia indicada?', 'Sí,No');
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (22, 1, 'cerrada', '¿El asesorado fue puntual?', 'Sí,No');
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (23, 1, 'cerrada', '¿Cuánto tiempo (en minutos) duró la asesoría?', '20,30,40,45,más de 50');
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (24, 1, 'abierta', '¿Tienes algún comentario extra sobre la asesoría?', NULL);
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (25, 2, 'cerrada', '¿El asesor fue puntual?', 'Sí,No');
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (26, 2, 'cerrada', '¿Qué tal claro fue tu asesor?', '1,2,3,4,5');
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (27, 2, 'cerrada', '¿El asesor brindó los ejemplos necesarios para aclarar tus dudas?', '1,2,3,4,5');
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (28, 2, 'cerrada', '¿El asesor brindó la atención necesaria durante la asesoría?', '1,2,3,4,5');
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (29, 2, 'cerrada', '¿Qué tanto dominio del tema tiene asesor?', '1,2,3,4,5');
INSERT INTO public."Pregunta" ("idPregunta", "idEncuesta", tipo, pregunta, "opcionesRespuesta") VALUES (30, 2, 'abierta', '¿Tienes algún comentario extra sobre la asesoría?', NULL);


--
-- Data for Name: Profesor; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: ProfesorUnidadFormacion; Type: TABLE DATA; Schema: public; Owner: pae
--



--
-- Data for Name: UnidadFormacion; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1028', 'Pensamiento computacional para ingeniería', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1030', 'Programación orientada a objetos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT1013', 'Análisis de biología computacional', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2026', 'Análisis de fenómenos de transporte', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2024', 'Diseño mecatrónico', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1001', 'Lógica computacional', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1001B', 'Modelación de la física: Estática', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1002', 'Razonamiento matemático', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1002B', 'Modelación de la física: Dinámica', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1002B', 'Exploración en el hábitat: de la escala del elemento al territorio', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1009', 'Análisis químico del ambiente y de los materiales de construcción', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1001', 'Optativa de matemáticas y ciencias', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1025', 'Creatividad y diseño', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1026', 'Metodologías de investigación para proyectos de diseño', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD1000B', 'El rol de los negocios en la sociedad', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD1014', 'Dirección de los negocios', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF1015', 'Análisis financiero', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1017', 'Economía empresarial', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ1011', 'Decisiones financieras', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1027', 'Razonamiento matemático', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI1001B', 'Globalización de los negocios', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH1001B', 'Estrategia y talento', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1027', 'Programación para negocios', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1001B', 'Modelación de la ingeniería y ciencias', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1006B', 'Modelación del movimiento en ingeniería', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1007B', 'Aplicación de las leyes de conservación en sistemas ingenieriles', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1028', 'Modelación matemática fundamental', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1019', 'Análisis de la estructura, propiedades y transformación de la materia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1001B', 'Transformación del México contemporáneo', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1022', 'Pensamiento matemático I', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1010', 'Filosofía política para los dilemas contemporáneos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1011', 'Introducción a las ciencias sociales', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI1001B', 'Desafíos globales', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1001B', 'Principios de programación para las ciencias sociales', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A1004', 'Cultura visual y sonora', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV1002B', 'Técnicas y discursos fotográficos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO1001B', 'Metodologías de investigación de factores humanos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL1022', 'Metodologías del pensamiento creativo', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1001B', 'Inmersión y experimentación creativa', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1002B', 'Modelación del movimiento en bioingeniería y procesos químicos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1003B', 'Aplicación de las leyes de conservación en ingeniería de procesos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1028', 'Fundamentación de la estructura y transformación de la materia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1029', 'Análisis de la estructura y transformación de la materia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1008B', 'Modelación del movimiento en ciencias', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1009B', 'Aplicación de las leyes de conservación en ciencias', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1004B', 'Modelación computacional del movimiento', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1005B', 'Modelación computacional aplicando leyes de conservación', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1033', 'Pensamiento computacional orientado a objetos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1020', 'Análisis de la estructura y propiedades de la materia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1029', 'Pensamiento computacional y programación', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1003B', 'Modelación de la física en el ambiente construido', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1007', 'Razonamiento basado en matemáticas', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1008', 'Resolución de problemas con lógica computacional', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1003', 'Análisis con Probabilidad y Estadística', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1003B', 'Sistemas constructivos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1004B', 'Información espacial', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AC1005B', 'Sistemas de información geográfica', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1010', 'Fundamentos de geología aplicada al ambiente construido', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1011', 'Evaluación del impacto ambiental de proyectos territoriales', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1012', 'Aplicación de métodos numéricos al ambiente construido', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1002', 'Optativa de humanidades y bellas artes', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1027', 'Métodos de diseño', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1028', 'Técnicas de representación espacial y de imagen', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD1016', 'Comunicación que inspira', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD1004', 'Análisis para la toma de decisiones', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD1005', 'Pensamiento estadístico', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF1001B', 'Dirección financiera', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D1029', 'Legalidad y negocios responsables', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM1001B', 'Ideación y prototipado', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM1009', 'Innovación de modelos de negocios', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT1001B', 'Descubrimientos del mercado para el desarrollo de estrategias', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH1004', 'Procesos de gestión de talento', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1008', 'Experimentación física y pensamiento estadístico', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1015B', 'Aplicación de la termodinámica en sistemas ingenieriles', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1016B', 'Análisis de sistemas eléctricos en sistemas ingenieriles', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1017B', 'Análisis de sistemas electromagnéticos en sistemas ingenieriles', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1029', 'Modelación matemática intermedia', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1030', 'Modelación matricial', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1031', 'Análisis estadístico', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1021', 'Experimentación química y pensamiento estadístico fundamental', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D1001B', 'Introducción al derecho', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1002B', 'Emprendimiento y tecnología para la transformación de México', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1013', 'Macroeconomía', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1014', 'Microeconomía', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1023', 'Métodos cuantitativos I', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1024', 'Pensamiento matemático II', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1002B', 'Herramientas tecnológicas para las ciencias sociales', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1001B', 'Representación formal del espacio', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV1001B', 'Narrativa audiovisual', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1008', 'Imaginarios culturales de México', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1009', 'Semiótica y narratologías contemporáneas', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1001B', 'Estructuras simbólicas en la imagen, la literatura y la música', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1010B', 'Aplicación de la termodinámica en ingeniería de procesos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1011B', 'Análisis de sistemas eléctricos en ingeniería de procesos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1012B', 'Análisis de sistemas electromagnéticos en ingeniería de procesos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1022', 'Análisis de la transformación de la materia en procesos químicos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1023', 'Experimentación química y pensamiento estadístico intermedio', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1018B', 'Aplicación de la termodinámica en ciencias', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1019B', 'Análisis de sistemas eléctricos en ciencias', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1020B', 'Análisis de sistemas electromagnéticos en ciencias', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1013B', 'Modelación computacional de sistemas eléctricos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1014B', 'Modelación computacional de sistemas electromagnéticos', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1003B', 'Modelación de la ingeniería con matemática computacional', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP1007', 'Optativa de fundamentos en ingeniería', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1004B', 'Modelación y representación gráfica de un edificio', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1005B', 'Modelación y representación gráfica de tu campus con topografía', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR1006B', 'Modelación y representación gráfica de tu entorno con geomática', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV1013', 'Análisis de fenómenos naturales y sociales con probabilidad y estadística', 2);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2002B', 'Diseño y construcción de un hábitat efímero', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2035', 'La conceptualización del espacio, su teoría y su historia', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2036', 'Representación de la arquitectura y su construcción', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1003', 'Optativa de ciencias sociales y del comportamiento', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA1001B', 'Tópico de exploración', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD1001B', 'Creación de valor compartido', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF1016', 'Estrategias de planeación financiera', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM1010', 'Proyecto de innovación empresarial', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ1012', 'Evaluación de proyectos de inversión', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT1002B', 'Construcción de soluciones para el mercado', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT1011', 'Estrategias de mercado y diferenciación', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI1004', 'Competitividad internacional  y oportunidades de crecimiento', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH1005', 'Dimensión estratégica del capital humano', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN1001B', 'Diseño y análisis de experimentos para la innovación ingenieril', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN1002B', 'Desarrollo de proyectos de análisis de datos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M1011', 'Análisis de equilibrio estático', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1034', 'Modelación de procesos mediante algebra lineal', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1035', 'Modelación en ingeniería mediante sistemas dinámicos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE1020', 'Análisis de circuitos eléctricos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1003B', 'Macroeconomía y desarrollo económico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1015', 'Economía conductual', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1016', 'Economía para la toma de decisiones', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1025', 'Métodos cuantitativos II', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1026', 'Pensamiento matemático III', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1001B', 'Participación política y sociología de la identidad', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT1014', 'Fundamentación de la biología molecular', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ1001B', 'Aplicación de la conservación de la materia en ingeniería de procesos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ1002B', 'Aplicación de la conservación de la energía en ingeniería de procesos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1024', 'Aplicación del análisis químico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1025', 'Experimentación en química analítica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1026', 'Análisis estructural de moléculas orgánicas y sus propiedades', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1027', 'Fundamentación de la estructura y propiedades de biomoléculas', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1009', 'Análisis de métodos matemáticos para la física', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F1010', 'Modelación con ecuaciones diferenciales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1001B', 'Modelación estadística para la toma de decisiones', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1002B', 'Modelación de sistemas con ecuaciones diferenciales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1036', 'Fundamentación del álgebra lineal', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1033', 'Análisis de ecuaciones diferenciales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1004B', 'Implementación de internet de las cosas', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1031', 'Programación de estructuras de datos y algoritmos fundamentales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC1032', 'Modelación de sistemas mínimos y arquitecturas computacionales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI1015', 'Análisis de requerimientos de software', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS1008', 'Evaluación del capital natural y principios de sustentabilidad', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1001', 'Sistema musculoesquelético', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1002B', 'Metabolismo y energía', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1003', 'Aporte y consumo de oxígeno', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1001B', 'Fundamentación de las propiedades de nanomateriales y materiales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q1002B', 'Obtención de nanomateriales, materiales orgánicos y bioinorgánicos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE1019', 'Fundamentación de ingeniería eléctrica y electrónica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2001B', 'Pre-producción de cortometraje animado', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2002B', 'Producción de cortometraje animado', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2012', 'Dibujo', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2013', 'Historia de la animación', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2014', 'Fundamentos de la animación', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2001B', 'Producción de audio, video y diseño digital', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO2001B', 'Metodologías de investigación para la comunicación', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO2011', 'Teorías de la comunicación', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH2006', 'Del humanismo al post-humanismo', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2001B', 'Comunicación digital del producto', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2002B', 'Configuración del objeto', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2042', 'Representación visual', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2043', 'Materia y expresión', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2001B', 'Bienes y derechos reales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2002B', 'Derecho constitucional', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2031', 'Argumentación jurídica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2032', 'Personas y acto jurídico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2033', 'Seminario de argumentación jurídica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2034', 'Seminario de personas y acto jurídico', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2035', 'Seminario de teoría del derecho', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2036', 'Teoría del derecho', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2001', 'Fundamentos de la pedagogía', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2001B', 'Análisis de problemáticas educativas', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2002', 'Metodologías de la investigación educativa', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2002B', 'Fundamentación pedagógica aplicada a las soluciones de aprendizaje', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2001B', 'Análisis del discurso', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2002B', 'Textos clásicos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2050', 'Análisis crítico de textos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2051', 'Estructuras y análisis del español', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2001B', 'Metodologías de la investigación periodística', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SO2001', 'Estudios sociales y políticos', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2010B', 'Fundamentos de la acústica', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2001', 'Teoría y estilos musicales', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2001B', 'Entrenamiento auditivo e instrumental', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2002', 'Negocios en la industria de la música', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2001B', 'Diagnóstico territorial', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2003B', 'Ecobarrio', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2037', 'Derecho Urbano', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2027', 'Ecología urbana', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2041', 'Infraestructura urbana', 3);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2004B', 'Arquitectura y contextos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2007B', 'Equipamiento comunitario', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2039', 'Investigación y proyecto arquitectónico', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1004', 'Optativa de liderazgo, emprendimiento e innovación', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2001B', 'Panorama internacional de los negocios', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2002B', 'Plan de exportación', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2026', 'Negocios globales: tendencias y detección de riesgos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2027', 'Operación logística internacional', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2001B', 'Desarrollo de proyectos con visión sistémica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2002B', 'Mejora de un proceso organizacional con métodos estadísticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2003B', 'Conceptualización de procesos con enfoque innovador', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2032', 'Análisis estadístico de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2037', 'Diseño de sistemas ciberfísicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2038', 'Evaluación económica de proyectos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2001B', 'Análisis de materiales y manufactura', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2005', 'Análisis  de mecanismos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2003B', 'Integración mecatrónica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2004B', 'Implementación de sistemas mecatrónicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2022', 'Análisis de elementos de la mecatrónica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2023', 'Modelación y automatización', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2001B', 'Análisis de biosistemas productivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2002B', 'Evaluación de nutrición y sanidad en los biosistemas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2029', 'Fundamentación de biosistemas productivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2030', 'Integración de procesos bioproductivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS2001B', 'Conservación de recursos naturales en biosistemas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2033', 'Gestión de biosistemas productivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2001B', 'Diseño de alimentos saludables', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2002B', 'Planeación de sistemas de distribución de alimentos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2003B', 'Evaluación de factibilidad de nuevos productos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2017', 'Diseño sustentable en procesamiento de alimentos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2018', 'Optimización de procesos y sistemas de inocuidad', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2019', 'Análisis fisicoquímico en el diseño de alimentos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2002B', 'Elaboración de productos biotecnológicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2003B', 'Síntesis de biofábricas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2019', 'Análisis y estudio de biosistemas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2020', 'Aplicación de bases moleculares', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2001B', 'Análisis de la interacción del ambiente construido y el entorno', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2002B', 'Evaluación del comportamiento de materiales en estructuras', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2003B', 'Análisis del comportamiento de sistemas hidráulicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2035', 'Modelación de la información en la construcción', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2036', 'Gestión de costos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2037', 'Planeación y control de obra', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2001B', 'Optimización determinista', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2002B', 'Análisis de criptografía y seguridad', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2004B', 'Análisis de ciencia de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2032', 'Diseño de agentes inteligentes', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2033', 'Análisis de sistemas basados en conocimiento', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2034', 'Modelación del aprendizaje con inteligencia artificial', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS2002B', 'Implementación de programas de manejo de recursos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2001B', 'Integración de procesos energéticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2002B', 'Dimensionamiento de procesos energéticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2009', 'Análisis termodinámico de procesos energéticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2010', 'Diseño de procesos para el transporte de fluidos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2011', 'Diseño de procesos de transferencia de calor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2005B', 'Aplicación de la teoría electromagnética', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2006B', 'Evaluación de circuitos eléctricos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2007B', 'Aplicación de dispositivos electrónicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2047', 'Análisis de circuitos eléctricos de corriente alterna', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2048', 'Análisis de sistemas lógicos y circuitos digitales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2049', 'Fundamentación de la física de estado sólido y optoelectrónica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2002B', 'Solución de problemas de mecánica clásica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2003B', 'Modelación numérica de sistemas físicos determinísticos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2004B', 'Aplicación de las fuentes alternas de energía', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2017', 'Fundamentación de la electrodinámica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN2001B', 'Diseño y creación de soluciones innovadoras', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN2007', 'Estudio de metodologías para la innovación', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP2019', 'Optativa de acentuación en ingeniería I', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP2026', 'Optativa de acentuación en ingeniería II', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2001B', 'Diseño de sistemas de bioinstrumentación analógica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2002B', 'Diseño de sistemas de bioinstrumentación digital', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2003B', 'Análisis químico, biológico y molecular', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2010', 'Análisis de señales y sistemas biomédicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2011', 'Aplicación de tecnologías de la información en salud', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2002B', 'Diseño de productos sometidos a cargas estáticas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2003B', 'Diseño dinámico', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2033', 'Análisis de esfuerzos y deformaciones', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2034', 'Análisis del movimiento de cuerpos rígidos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2035', 'Fundamentación de ingeniería de materiales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2001B', 'Fabricación de nanoestructuras por métodos químicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2002B', 'Fabricación de nano y microestructuras por métodos físicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2001B', 'Fundamentación fisicoquímica de las propiedades de las nanoestructuras', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2024', 'Caracterización de materiales y nanomateriales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2025', 'Fundamentación de química médica y nanomedicina', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2007B', 'Diseño de sistemas de flujo de fluidos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2008B', 'Diseño de sistemas de transferencia de calor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2009B', 'Análisis de procesos de transferencia de calor y flujo de fluidos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2015', 'Modelación de fenómenos de transporte', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2016', 'Modelación matemática avanzada', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2002B', 'Diseño con lógica programable', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2003B', 'Diseño de sistemas en chip', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2044', 'Fundamentación electrónica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2045', 'Diseño de circuitos electrónicos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2005B', 'Construcción de software y toma de decisiones', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2006B', 'Interconexión de dispositivos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2037', 'Implementación de métodos computacionales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2029', 'Modelación, estructura y operación de los negocios', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2002B', 'Evaluación de arquitecturas empresariales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2003B', 'Evaluación de tecnología para los negocios', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2004B', 'Exploración e interpretación de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2018', 'Diseño de arquitecturas, uso y administración de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2019', 'Evaluación y administración de proyectos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2003B', 'Arte conceptual', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2004B', 'Fundamentos de interacción', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2005B', 'Arte instalación', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2015', 'Exploración de la forma', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A2016', 'Introducción al 3D', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2001B', 'Detección de oportunidades estratégicas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2002B', 'Diseño de organizaciones flexibles', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2004B', 'Liderazgo para la transformación', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2025', 'Pensamiento estratégico', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2001B', 'Análisis de inversiones', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2002B', 'Cultura financiera', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2004B', 'Gestión de tesorería', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2019', 'Modelos econométricos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2020', 'Series de tiempo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2021', 'Teoría de inversiones', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2001B', 'Diagnóstico financiero', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2002B', 'Integración financiera de procesos de negocio', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2022', 'Cumplimiento fiscal', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2023', 'Optimización de costos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2003B', 'Decisiones de negocio estratégicas', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2016', 'Estructuras de información', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2002B', 'Guionismo y producción de narrativas audiovisuales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2016', 'Fotografía publicitaria y comercial', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CR2001B', 'Comunicación estratégica aplicada', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2001B', 'Adaptación de oportunidad y solución', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2002B', 'Evaluación y comunicación de oportunidades', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2003B', 'Exploración de alto impacto', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2013', 'Innovación en la cadena de valor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2014', 'Liderazgo emprendedor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2015', 'Oportunidades de emprendimiento corporativo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2003B', 'Pensamiento y proceso creativo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2004B', 'Especificación de productos y servicios', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2005B', 'Diseño e innovación', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL2044', 'Administración de proyectos de diseño', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2001B', 'Estrategias para potenciar el talento humano', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2002B', 'Planeación del capital humano', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2003B', 'Valoración estratégica del trabajo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2012', 'Atracción y desarrollo del talento en entornos digitales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2013', 'Desempeño y retribución en contextos globales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2015', 'Analítica del talento', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2001B', 'Dinero y capitales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2003B', 'Incentivos del consumidor y productor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2004B', 'Origen y futuro del panorama macroeconómico', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2029', 'Fundamentos de econometría', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2012', 'Fundamentos de estadística', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2013', 'Pensamiento matemático IV', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2003B', 'Derecho penal y delitos en especial', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2004B', 'Derechos humanos y su interpretación judicial', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2005B', 'Solución de conflictos y teoría general del proceso', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2037', 'Derecho de las obligaciones I', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2038', 'Derecho de las obligaciones II', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2039', 'Seminario de derecho de las obligaciones I', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2003', 'Introducción a la administración educativa', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2003B', 'Desarrollo de proyectos educativos basados en tecnología', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2004B', 'Exploración de tendencias tecnológicas en educación', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2005B', 'Uso de tecnología en la investigación educativa', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2001B', 'Inteligencia de mercado para la generación de conocimiento del consumidor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2002B', 'Inteligencia exploratoria de mercados', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2003B', 'Segmentación y posicionamiento de estrategias de valor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2027', 'Definición competitiva de mercado', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2028', 'Diseño de métricas de mercadotecnia', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2029', 'Visión holística del consumidor', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2003B', 'Indicadores y riesgos con visión estratégica', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2001B', 'Diagnóstico para líneas de acción', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2008', 'Análisis descriptivo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2009', 'Manipulación de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2017', 'Integración de base de datos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2003B', 'Literatura de los Siglos de Oro', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2004B', 'Literatura española medieval', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2005B', 'Literatura novohispana', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2052', 'Teoría literaria', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2002B', 'Producción de contenidos noticiosos', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2007', 'Ejercicio periodístico, derecho a la información y opinión pública', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2001B', 'Análisis histórico del sistema internacional', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2002B', 'Escenarios regionales en el mundo contemporáneo', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2003B', 'Prospectiva sobre escenarios político-económicos internacionales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2039', 'Teorías clásicas de relaciones internacionales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2040', 'Teorías contemporáneas de relaciones internacionales', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2002B', 'Aplicación de tecnología en la producción sonora', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2003', 'Producción sonora y mezcla digital', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2003B', 'Técnicas de grabación sonora', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2004B', 'Proyecto de producción musical', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2001B', 'Opinión pública', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2002B', 'Instituciones, regulación y política pública', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2001B', 'Ciencia de datos para la toma de decisiones I', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3066', 'Métodos econométricos y política pública', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2005B', 'Ciudades competitivas: Innovación', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2006B', 'Ciudades competitivas: Movilidad', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2010B', 'Ciudades competitivas: Calidad de vida', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2038', 'Ciudades del futuro', 4);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2008B', 'Vivienda colectiva', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2009B', 'Vivienda unifamiliar', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR2040', 'Constructibilidad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EG1005', 'Optativa de ética y ciudadanía', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2003B', 'Administración de importaciones y sus regulaciones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2004B', 'Desarrollo internacional de servicios', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2025', 'Negociación Intercultural', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI2028', 'Ventas y contratos internacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2004B', 'Generación de valor con analítica de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2005B', 'Evaluación de la competitividad organizacional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2006B', 'Análisis de la viabilidad de proyectos con perspectiva sistémica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2039', 'Visualización de datos para la toma de decisiones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2040', 'Optimización de procesos organizacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2041', 'Mejora de procesos con métodos heurísticos y metaheurísticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2005B', 'Solución de problemas de procesos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2006B', 'Automatización industrial', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2025', 'Diseño de sistemas de control', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG2003B', 'Integración de tecnologías sustentables en biosistemas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2001B', 'Mejora de biosistemas con genética y biotecnología', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2034', 'Evaluación de la productividad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2035', 'Gestión avanzada de la producción', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2036', 'Aplicación de metrología en biosistemas productivos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2001B', 'Aplicación de automatización y control en biosistemas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2004B', 'Diseño de procesos sustentables', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2005B', 'Análisis del consumidor y mercado de alimentos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2006B', 'Diseño de sistemas de administración de procesos e inocuidad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2020', 'Administración de procesos y sistemas de inocuidad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2021', 'Aplicación del análisis sensorial en alimentos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA2022', 'Simulación de procesos de transformación de alimentos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2004B', 'Experimentación in vitro', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2005B', 'Integración de operaciones de transferencia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2004B', 'Evaluación del comportamiento de sistemas estructurales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2005B', 'Diseño de sistemas hidráulicos para el uso sustentable del agua', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2006B', 'Diseño de vialidades para el desarrollo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2038', 'Gestión de proyectos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2039', 'Gestión de operaciones de construcción', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2040', 'Gestión empresarial en la industria de la construcción', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2003B', 'Aplicación de métodos multivariados en ciencia de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2004B', 'Optimización estocástica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2005B', 'Aplicación de criptografía y seguridad', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2014', 'Análisis de métodos de razonamiento e incertidumbre', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2015', 'Diseño de algoritmos matemáticos bioinspirados', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2035', 'Diseño de redes neuronales y aprendizaje profundo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2003B', 'Evaluación de procesos energéticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2004B', 'Evaluación del desempeño energético de procesos industriales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2012', 'Aplicación de los principios de eficiencia energética', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2013', 'Análisis de procesos y economía circular', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2009B', 'Diseño usando microcontroladores y arquitectura computacional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2039', 'Desarrollo de sistemas digitales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2008B', 'Evaluación de Dispositivos Electrónicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2009B', 'Análisis de sistemas y dispositivos electrónicos de control', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2046', 'Análisis de señales y sistemas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2050', 'Diseño de circuitos electrónicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2005B', 'Análisis de fenómenos ópticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2006B', 'Modelación numérica de sistemas estocásticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2007B', 'Análisis de los sistemas termodinámicos y estadísticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2018', 'Análisis de sistemas cuánticos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN2002B', 'Diseño y evaluación de emprendimientos tecnológicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN2008', 'Análisis de factibilidad y viabilidad de proyectos de innovación', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP2027', 'Optativa de acentuación en ingeniería III', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP2028', 'Optativa de acentuación en ingeniería IV', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2004B', 'Análisis y diseño en biomecánica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2005B', 'Aplicación de bioinstrumentación y tecnologías biomédicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2006B', 'Gestión y validación de tecnologías biomédicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2012', 'Caracterización de biomateriales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2013', 'Modelación y control de sistemas biomédicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1012', 'Sistema nervioso', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2004B', 'Diseño de mecanismos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2005B', 'Diseño de sistemas termofluídicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2036', 'Fundamentación de mecánica de fluidos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2037', 'Análisis de los procesos de transformación energética', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2038', 'Modelación de transferencia de calor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2001B', 'Desarrollo de nanosistemas fotónicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2015', 'Fundamentación del estado sólido de la materia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2016', 'Fundamentación de electromagnetismo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2003B', 'Desarrollo de nanosistemas fluídicos y mecánicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2002B', 'Modelación de sistemas moleculares', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2026', 'Formulación de productos nanotecnológicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2010B', 'Diseño de procesos de separación', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2011B', 'Diseño de reactores químicos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2012B', 'Análisis de procesos de separación y reacción', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2016', 'Predicción del equilibrio químico y de fases', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2002B', 'Análisis de sistemas de control', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2036', 'Implementación de redes seguras', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2004B', 'Diseño de sistemas embebidos avanzados', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2007B', 'Integración de seguridad informática en redes y sistemas de software', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2008B', 'Modelación de sistemas multiagentes con gráficas computacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2038', 'Análisis y diseño de algoritmos avanzados', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2008B', 'Administración del cambio', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2030', 'Análisis del comportamiento y desempeño organizacional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2025', 'Análisis de las actividades económicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2005B', 'Diseño de procesos y arquitecturas empresariales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2006B', 'Soporte analítico para la toma de decisiones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2020', 'Implementación de tecnología en los procesos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3070', 'Optativa de arte digital I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3071', 'Optativa de arte digital II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3072', 'Optativa de arte digital III', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3073', 'Optativa de arte digital IV', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3074', 'Optativa de arte digital V', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3075', 'Optativa de arte digital VI', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2005B', 'Aseguramiento de la co-creación de valor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2006B', 'Diseño estratégico para crear valor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2026', 'Construcción de habilidades interpersonales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2027', 'Innovación y co-creación de valor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2005B', 'Análisis de financiamiento', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2008B', 'Valuación de empresas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2009B', 'Vehículos de inversión y cobertura', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2022', 'Algoritmos y análisis de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2023', 'Instrumentos derivados', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2024', 'Modelación y programación financiera', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2003B', 'Desarrollo de arquitectura contable', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2024', 'Diseño de estrategia financiera', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2025', 'Valuación y presentación de financiamientos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF2026', 'Valuación y presentación de inversiones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2006B', 'Análisis fundamental de empresas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ2007B', 'Creación de valor corporativo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2003B', 'Narrativa documental', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO2002B', 'Comunicación, mercadotecnia digital y minería de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO2012', 'Estudios culturales y medios', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2003B', 'Producción periodística convergente', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2004B', 'Diseño de prototipos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2005B', 'Diseño de soluciones de alto impacto', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2006B', 'Generación y validación de prototipos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2016', 'Metodologías de innovación', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2017', 'Metodologías de innovación tecnológica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM2018', 'Técnicas de prototipaje', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3076', 'Optativa de diseño I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3077', 'Optativa de diseño II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3078', 'Optativa de diseño III', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3079', 'Optativa de diseño IV', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3080', 'Optativa de diseño V', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3081', 'Optativa de diseño VI', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2028', 'Responsabilidad social y talento humano', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2004B', 'Comprensión del ambiente laboral', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2005B', 'Creación de valor desde el talento', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2006B', 'Diseño de experiencias laborales plenas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2014', 'Organizaciones positivas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH2015', 'Versatilidad organizacional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2005B', 'Competencia económica', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2006B', 'Decisiones estratégicas en mercados e instituciones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2007B', 'Dinámica del crecimiento nacional y regional', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2030', 'Econometría I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2031', 'Econometría II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2032', 'Multivariante', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2006B', 'Contratos civiles y mercantiles', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2007B', 'Derecho administrativo I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2008B', 'Familia y sucesiones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2040', 'Derecho laboral I', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2041', 'Derecho laboral ll', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D2042', 'Seminario de derecho de las obligaciones II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2004', 'Educación global y comparada', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2006B', 'Diseño de soluciones para retos educativos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED2007B', 'Desarrollo de proyectos en el marco de las políticas educativas vigentes', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2004B', 'Desarrollo de marcas que transforman', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2005B', 'Diseño de experiencias omnicanal', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2006B', 'Gestión sustentable de proyectos de mercadotecnia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2030', 'Diseño de estrategias de mercadotecnia interna', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT2031', 'Optimización de precios y cadenas de valor', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2007B', 'Líneas de acción estratégicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2010', 'Introducción a la econometría', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CD2011', 'Minería de datos', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2003B', 'Gestión de proyectos de plataformas tecnológicas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI2001B', 'Plataformas de analítica de negocios para organizaciones', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2006B', 'Narrativa Iberoamericana de los siglos XIX y XX', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2007B', 'Poesía Iberoamericana de los siglos XIX y XX', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2008B', 'Teatro y ensayo iberoamericanos de los siglos XIX y XX', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2053', 'Desarrollo de modelos y prototipos editoriales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV2004B', 'Producción de narrativas convergentes multimodales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI2008', 'Fundamentos del periodismo hipermedia y transmedia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2004B', 'Conflicto y negociación', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2005B', 'Cooperación y gobernanza global', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2006B', 'Gestión de bienes públicos globales en la sociedad de riesgo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2041', 'Aspectos jurídicos de las relaciones internacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2042', 'Organismos internacionales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI2043', 'Riesgos y amenazas en la agenda global contemporánea', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2004', 'Postproducción de audio para cine y video', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2005B', 'Diseño de aplicaciones interactivas de tecnología musical', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2006B', 'Musicalización de productos audiovisuales', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM2007B', 'Producción y mercadotecnia audiovisual', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2002B', 'Economía conductual y neurociencia política', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2003B', 'Políticas tecnológicas para el desarrollo', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2013', 'Elección pública e instituciones políticas comparadas', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC2002B', 'Ciencia de datos para la toma de decisiones II', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3001B', 'Metrópolis sostenible: Mitigación', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3002B', 'Metrópolis sostenible: Resiliencia', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3004B', 'Metrópolis sostenible: Adaptación', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC2033', 'Economía urbana', 5);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3111', 'Tópicos I', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3112', 'Tópicos II', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3113', 'Tópicos III', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3114', 'Tópicos IV', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3115', 'Tópicos V', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('VA3116', 'Tópicos VI', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2007B', 'Diseño disruptivo de procesos organizacionales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2008B', 'Aseguramiento de la excelencia operacional', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2009B', 'Mejora de una cadena de valor adaptativa', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2042', 'Modelación de la cadena de valor', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2043', 'Simulación discreta, continua y por agentes', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN2044', 'Diseño de un proceso de consultoría y gestión del cambio', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2007B', 'Automatización de sistemas de manufactura', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR3001B', 'Diseño y desarrollo de robots', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG3001B', 'Bioproducción en ambientes controlados', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA3001B', 'Desarrollo sustentable de alimentos saludables y personalizados', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2006B', 'Diseño de biorreactores', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2007B', 'Diseño de estrategias de bioseparación', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2008B', 'Planeación de procesos biotecnológicos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2024', 'Aplicación y análisis de las tecnologías ómicas', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT2025', 'Prospección de bioprocesos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2007B', 'Modelación de técnicas de saneamiento del agua', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2008B', 'Diseño de movilidad eficiente de personas y mercancías', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV2009B', 'Diseño estructural con concreto reforzado y acero', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2006B', 'Uso de álgebras modernas para seguridad y criptografía', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2007B', 'Uso de geometría y topología para ciencia de datos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA2008B', 'Análisis numérico para la optimización no-lineal', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS2002', 'Innovación de modelos de sustentabilidad corporativa', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2005B', 'Dimensionamiento avanzado y monitoreo de procesos energéticos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2006B', 'Innovación de los procesos en su cadena de valor', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2014', 'Mejora de procesos productivos aplicando principios de economía circular', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2010B', 'Desarrollo de sistemas de procesamiento digital de señales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2011B', 'Diseño de sistemas de comunicaciones', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2012B', 'Análisis de sistemas energéticos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2008B', 'Caracterización experimental de sistemas ópticos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F2009B', 'Caracterización experimental de materiales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE2001B', 'Caracterización experimental mediante instrumentación electrónica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN3001B', 'Gestión estratégica de la innovación tecnológica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2007B', 'Análisis de sistemas de imagenología', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2008B', 'Aplicación de la Ingeniería tisular y bioimpresión', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2009B', 'Procesamiento de imágenes médicas para el diagnóstico', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2010B', 'Diseño y desarrollo en neuroingeniería', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2011B', 'Implementación de ingeniería clínica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI2012B', 'Análisis de la mecánica de biofluidos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2006B', 'Diseño de máquinas térmicas', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2007B', 'Análisis y prevención de fallas', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M2008B', 'Diseño de elementos de máquinas', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2001', 'Diseño de dispositivos nanotecnológicos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2002', 'Generación de prototipos y escalamiento de procesos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2004B', 'Aplicación de nanodispositivos en soluciones integrales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NT2005B', 'Aplicación de prototipado y escalamiento en soluciones integrales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2003B', 'Aplicación de investigación en soluciones integrales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q2027', 'Investigación y diseño experimental', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2013B', 'Diseño integral de procesos químicos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ2017', 'Diseño de procesos químicos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR2021', 'Automatización y control de procesos químicos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE3001B', 'Fundamentación de robótica', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE3002B', 'Implementación de robótica inteligente', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3001B', 'Desarrollo de software', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI3001B', 'Administración estratégica y gobierno de tecnologías de información', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI3002B', 'Innovación y diseño de iniciativas de transformación digital', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI3003B', 'Aplicación de analítica y gobierno de datos', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AT3001B', 'Proyecto de arte digital', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL3001B', 'Proyecto de diseño', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3001B', 'Controles constitucionales I', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3002B', 'Derecho administrativo II', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3003B', 'Derecho procesal civil y mercantil', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3039', 'Derecho fiscal', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3040', 'Derecho procesal laboral', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3041', 'Empresa y cumplimiento regulatorio', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3042', 'Juicios orales', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3043', 'Sistema penal acusatorio', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3044', 'Sociedades mercantiles', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC3001B', 'Análisis de decisiones bajo condiciones de incertidumbre', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P2020', 'Economía política del cambio tecnológico y el desarrollo', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P3001B', 'Gobierno, sector privado, tecnología y nuevos mercados', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3065', 'Experimentos e inferencia causal para política pública', 6);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3091', 'Optativa Profesional I', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3092', 'Optativa Profesional II', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3093', 'Optativa profesional III', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3094', 'Optativa profesional IV', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3095', 'Optativa profesional V', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3096', 'Optativa profesional VI', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3001B', 'Formación de juicio crítico profesional', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3024', 'Aseguramiento e interés público', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3026', 'Ciclo tributario y empresas', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3027', 'Consolidación de información financiera', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3004B', 'Controles constitucionales II', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3005B', 'Derecho internacional privado y arbitraje comercial internacional', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3006B', 'Derecho procesal fiscal y administrativo', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3045', 'Derecho de la propiedad intelectual', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3046', 'Derecho internacional público', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3047', 'Ética para abogados', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3048', 'Inglés legal', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3049', 'Seminario de derecho internacional público', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3050', 'Títulos y operaciones de crédito', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3003B', 'Gestión y administración de proyectos territoriales de inversión', 7);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3007B', 'Emprendimiento en el ámbito de la arquitectura', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3008B', 'Gestión arquitectónica', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NI3001B', 'Desarrollo de estrategias de internacionalización para el siglo XXI', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IN3001B', 'Diseño de un sistema organizacional inteligente', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MR3002B', 'Diseño e implementación de sistemas mecatrónicos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG3002B', 'Transformación digital de biosistemas productivos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AG3003B', 'Gestión integral y ecoeficiente', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TA3002B', 'Administración de procesos de producción y distribución de alimentos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BT3002B', 'Diseño de procesos biotecnológicos y de bioproductos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CV3001B', 'Integración de proyectos de ingeniería civil', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA3001B', 'Desarrollo de proyectos de ingeniería matemática', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS3001B', 'Diseño de estrategias de sustentabilidad corporativa', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ3001B', 'Desarrollo de modelos de sustentabilidad energética', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE3004B', 'Desarrollo de telecomunicaciones y sistemas energéticos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('F3001B', 'Integración de ingeniería física', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('NN3002B', 'Desarrollo de proyecto integrador de innovación', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('BI3001B', 'Desarrollo de dispositivos médicos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('M3001B', 'Diseño de máquinas', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('Q3001B', 'Desarrollo de proyectos de nanotecnología', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IQ3002B', 'Aplicación de la ingeniería de procesos en proyectos industriales', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TE3003B', 'Integración de robótica y sistemas inteligentes', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3002B', 'Desarrollo de aplicaciones avanzadas de ciencias computacionales', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TC3003B', 'Implementación de redes de área amplia y servicios distribuidos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TI3004B', 'Transformación digital de la organización', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AT3002B', 'Proyecto integral de arte digital', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD3001B', 'Gestión estratégica de PYMES', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD3002B', 'Institucionalización de la empresa familiar', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ3001B', 'Administración financiera internacional', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('FZ3002B', 'Gestión de fondos de inversión', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CF3002B', 'Dirección financiera y contraloría estratégica', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('CO3001B', 'Proyecto integrador de comunicación', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM3001B', 'Escalabilidad', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM3002B', 'Persuasión y ventas', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL3002B', 'Proyecto integral de diseño', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH3001B', 'Liderazgo estratégico del talento', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RH3002B', 'Potenciación de la cultura organizacional', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC3002B', 'Solución y evaluación de problemas económicos', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('ED3001B', 'Proyecto integrador de innovación educativa', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT3001B', 'Liderazgo de mercadotecnia I', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MT3002B', 'Liderazgo de mercadotecnia II', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD3003B', 'Planeación estratégica basada en analítica prescriptiva', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H3001B', 'Proyecto integrador de letras', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MI3001B', 'Proyecto integrador de periodismo', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI3002B', 'Análisis y estrategias de política exterior', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('TM3001B', 'Proyecto integrador de tecnología y producción musical', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P3002B', 'Diseño e implementación de innovaciones públicas', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3005B', 'Ciudades emergentes', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AR3006B', 'Complejidad y debate', 8);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('D3007B', 'Investigación jurídica aplicada', 9);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('OP3001B', 'Optativa profesional multidisciplinaria', 9);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1020', 'Micro incentivos económicos y macro resultados', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1010', 'Claves de la felicidad para el florecimiento humano', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1058', 'Antropología del cuerpo', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1012', 'Cambio tecnológico y desarrollo social', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1013', 'Política mexicana: evolución y desafíos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI1016', 'Género, sociedad y derechos humanos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI1018', 'Geopolítica y cambios tecnológicos: el futuro hoy', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('SD1019', 'Salud y bienestar personal', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1018', 'Infodemia y posverdad: ideología, algoritmos y redes sociales', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('A1005', 'Apreciación del arte', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AT1005', 'Cultura de la imagen', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1013', 'Patrimonio cultural de México', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1057', 'Los mitos que nos habitan: de Prometeo a Marvel', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IM1003', 'Apreciación multidisciplinaria de la música', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('RI1017', 'Hitos históricos de los siglos XX y XXI', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1017', 'Futuros posibles: utopías y distopías en el cine y la literatura', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AV1010', 'Análisis cinematográfico: de Lumiere a Netflix', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H2054', 'Viajeros del mundo: narrativas, mapas y fronteras', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IB1005', 'Fundamentación de sistemas biológicos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('IB1006', 'Biomimética y sustentabilidad', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DS1009', 'Procesos ecológicos para el desarrollo humano', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MA1042', 'Matemáticas y ciencia de datos para la toma de decisiones ', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1019', 'Ciudadanía y ciudades inteligentes', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1011', 'Posthumanismo, ética y tecnología', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1012', 'Ética, sostenibilidad y responsabilidad social', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EH1014', 'Violencia, dignidad y justicia social', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1059', 'Ética y psicología: del autoconocimiento a la realización', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MB1002', 'Bienestar humano, desarrollo sustentable y entorno construido', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1006', 'Ciudadanía global: diversidad y tolerancia', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('P1014', 'Ciudadanía y tecnología', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('DL1023', 'Innovación y procesos creativos', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EC1018', 'Anticorrupción en  gobierno, empresas y sociedad', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('EM1011', 'Emprendimiento e innovación', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('H1063', 'Argumentación, debate y el arte de hablar en público', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('MB1001', 'Salud global para líderes', 1);
INSERT INTO public."UnidadFormacion" ("idUF", "nombreUF", semestre) VALUES ('AD2035', 'Introducción a los negocios conscientes', 1);


--
-- Data for Name: UnidadFormacionCarrera; Type: TABLE DATA; Schema: public; Owner: pae
--

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


--
-- Data for Name: Usuario; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public."Usuario" ("idUsuario", rol, "nombreUsuario", "apellidoPaterno", "fotoPerfil", "ultimaConexion", "statusAcceso", telefono, "apellidoMaterno") VALUES ('L00000001', 'directivo', 'Super Usuario', 'Pae', NULL, '2022-06-15 22:14:59.877839', 'activo', '', '');
INSERT INTO public."Usuario" ("idUsuario", rol, "nombreUsuario", "apellidoPaterno", "fotoPerfil", "ultimaConexion", "statusAcceso", telefono, "apellidoMaterno") VALUES ('A00000000', 'asesor', 'Asesor', 'Sin Confirmar', NULL, '2022-06-15 22:14:59.877839', 'activo', '', '');


--
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: pae
--

INSERT INTO public.rol (rol) VALUES ('asesorado');


--
-- Name: Asesoria_idAsesoria_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."Asesoria_idAsesoria_seq"', 112, true);


--
-- Name: CalificacionEncuesta_idCalificacionEncuesta_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."CalificacionEncuesta_idCalificacionEncuesta_seq"', 12, true);


--
-- Name: CalificacionPregunta_idCalificacionPregunta_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."CalificacionPregunta_idCalificacionPregunta_seq"', 140, true);


--
-- Name: Encuesta_idEncuesta_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."Encuesta_idEncuesta_seq"', 2, true);


--
-- Name: HorarioDisponiblePeriodo_idHorarioDisponiblePeriodo_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."HorarioDisponiblePeriodo_idHorarioDisponiblePeriodo_seq"', 192, true);


--
-- Name: HorarioDisponible_idHorarioDisponible_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."HorarioDisponible_idHorarioDisponible_seq"', 2989, true);


--
-- Name: Notificacion_idNotificacion_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."Notificacion_idNotificacion_seq"', 106, true);


--
-- Name: Periodo_idPeriodo_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."Periodo_idPeriodo_seq"', 9, true);


--
-- Name: Politica_idPolitica_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."Politica_idPolitica_seq"', 1, true);


--
-- Name: Pregunta_idPregunta_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."Pregunta_idPregunta_seq"', 30, true);


--
-- Name: Profesor_idProfesor_seq; Type: SEQUENCE SET; Schema: public; Owner: pae
--

SELECT pg_catalog.setval('public."Profesor_idProfesor_seq"', 1, false);


--
-- Name: Asesoria Asesoria_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Asesoria"
    ADD CONSTRAINT "Asesoria_pkey" PRIMARY KEY ("idAsesoria");


--
-- Name: CalificacionEncuesta CalificacionEncuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."CalificacionEncuesta"
    ADD CONSTRAINT "CalificacionEncuesta_pkey" PRIMARY KEY ("idCalificacionEncuesta");


--
-- Name: CalificacionPregunta CalificacionPregunta_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."CalificacionPregunta"
    ADD CONSTRAINT "CalificacionPregunta_pkey" PRIMARY KEY ("idCalificacionPregunta");


--
-- Name: Carrera Carrera_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Carrera"
    ADD CONSTRAINT "Carrera_pkey" PRIMARY KEY ("idCarrera");


--
-- Name: Encuesta Encuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Encuesta"
    ADD CONSTRAINT "Encuesta_pkey" PRIMARY KEY ("idEncuesta");


--
-- Name: HorarioDisponiblePeriodo HorarioDisponiblePeriodo_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."HorarioDisponiblePeriodo"
    ADD CONSTRAINT "HorarioDisponiblePeriodo_pkey" PRIMARY KEY ("idHorarioDisponiblePeriodo");


--
-- Name: HorarioDisponible HorarioDisponible_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."HorarioDisponible"
    ADD CONSTRAINT "HorarioDisponible_pkey" PRIMARY KEY ("idHorarioDisponible");


--
-- Name: Notificacion Notificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Notificacion"
    ADD CONSTRAINT "Notificacion_pkey" PRIMARY KEY ("idNotificacion");


--
-- Name: Periodo Periodo_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Periodo"
    ADD CONSTRAINT "Periodo_pkey" PRIMARY KEY ("idPeriodo");


--
-- Name: Politica Politica_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Politica"
    ADD CONSTRAINT "Politica_pkey" PRIMARY KEY ("idPolitica");


--
-- Name: Pregunta Pregunta_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Pregunta"
    ADD CONSTRAINT "Pregunta_pkey" PRIMARY KEY ("idPregunta");


--
-- Name: Profesor Profesor_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Profesor"
    ADD CONSTRAINT "Profesor_pkey" PRIMARY KEY ("idProfesor");


--
-- Name: UnidadFormacion UnidadFormacion_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."UnidadFormacion"
    ADD CONSTRAINT "UnidadFormacion_pkey" PRIMARY KEY ("idUF");


--
-- Name: Usuario Usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_pkey" PRIMARY KEY ("idUsuario");


--
-- Name: Acceso Acceso_idUsuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Acceso"
    ADD CONSTRAINT "Acceso_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: AsesorUnidadFormacion AsesorUnidadFormacion_idUF_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."AsesorUnidadFormacion"
    ADD CONSTRAINT "AsesorUnidadFormacion_idUF_fkey" FOREIGN KEY ("idUF") REFERENCES public."UnidadFormacion"("idUF") ON DELETE CASCADE;


--
-- Name: AsesorUnidadFormacion AsesorUnidadFormacion_idUsuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."AsesorUnidadFormacion"
    ADD CONSTRAINT "AsesorUnidadFormacion_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: Asesor Asesor_idUsuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Asesor"
    ADD CONSTRAINT "Asesor_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: AsesoriaImagen AsesoriaImagen_idAsesoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."AsesoriaImagen"
    ADD CONSTRAINT "AsesoriaImagen_idAsesoria_fkey" FOREIGN KEY ("idAsesoria") REFERENCES public."Asesoria"("idAsesoria") ON DELETE CASCADE;


--
-- Name: Asesoria Asesoria_idAsesor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Asesoria"
    ADD CONSTRAINT "Asesoria_idAsesor_fkey" FOREIGN KEY ("idAsesor") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: Asesoria Asesoria_idAsesorado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Asesoria"
    ADD CONSTRAINT "Asesoria_idAsesorado_fkey" FOREIGN KEY ("idAsesorado") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: Asesoria Asesoria_idHorarioDisponible_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Asesoria"
    ADD CONSTRAINT "Asesoria_idHorarioDisponible_fkey" FOREIGN KEY ("idHorarioDisponible") REFERENCES public."HorarioDisponible"("idHorarioDisponible") ON DELETE CASCADE;


--
-- Name: Asesoria Asesoria_idUF_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Asesoria"
    ADD CONSTRAINT "Asesoria_idUF_fkey" FOREIGN KEY ("idUF") REFERENCES public."UnidadFormacion"("idUF") ON DELETE CASCADE;


--
-- Name: CalificacionEncuesta CalificacionEncuesta_idAsesoria_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."CalificacionEncuesta"
    ADD CONSTRAINT "CalificacionEncuesta_idAsesoria_fkey" FOREIGN KEY ("idAsesoria") REFERENCES public."Asesoria"("idAsesoria") ON DELETE CASCADE;


--
-- Name: CalificacionEncuesta CalificacionEncuesta_idEncuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."CalificacionEncuesta"
    ADD CONSTRAINT "CalificacionEncuesta_idEncuesta_fkey" FOREIGN KEY ("idEncuesta") REFERENCES public."Encuesta"("idEncuesta") ON DELETE RESTRICT;


--
-- Name: CalificacionPregunta CalificacionPregunta_idCalificacionEncuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."CalificacionPregunta"
    ADD CONSTRAINT "CalificacionPregunta_idCalificacionEncuesta_fkey" FOREIGN KEY ("idCalificacionEncuesta") REFERENCES public."CalificacionEncuesta"("idCalificacionEncuesta") ON DELETE CASCADE;


--
-- Name: CalificacionPregunta CalificacionPregunta_idPregunta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."CalificacionPregunta"
    ADD CONSTRAINT "CalificacionPregunta_idPregunta_fkey" FOREIGN KEY ("idPregunta") REFERENCES public."Pregunta"("idPregunta") ON DELETE RESTRICT;


--
-- Name: EstudianteCarrera EstudianteCarrera_idCarrera_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."EstudianteCarrera"
    ADD CONSTRAINT "EstudianteCarrera_idCarrera_fkey" FOREIGN KEY ("idCarrera") REFERENCES public."Carrera"("idCarrera") ON DELETE CASCADE;


--
-- Name: EstudianteCarrera EstudianteCarrera_idUsuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."EstudianteCarrera"
    ADD CONSTRAINT "EstudianteCarrera_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: HorarioDisponiblePeriodo HorarioDisponiblePeriodo_idAsesor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."HorarioDisponiblePeriodo"
    ADD CONSTRAINT "HorarioDisponiblePeriodo_idAsesor_fkey" FOREIGN KEY ("idAsesor") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: HorarioDisponiblePeriodo HorarioDisponiblePeriodo_idPeriodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."HorarioDisponiblePeriodo"
    ADD CONSTRAINT "HorarioDisponiblePeriodo_idPeriodo_fkey" FOREIGN KEY ("idPeriodo") REFERENCES public."Periodo"("idPeriodo") ON DELETE CASCADE;


--
-- Name: HorarioDisponible HorarioDisponible_idHorarioDisponiblePeriodo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."HorarioDisponible"
    ADD CONSTRAINT "HorarioDisponible_idHorarioDisponiblePeriodo_fkey" FOREIGN KEY ("idHorarioDisponiblePeriodo") REFERENCES public."HorarioDisponiblePeriodo"("idHorarioDisponiblePeriodo") ON DELETE CASCADE;


--
-- Name: NotificacionUsuario NotificacionUsuario_idNotificacion_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."NotificacionUsuario"
    ADD CONSTRAINT "NotificacionUsuario_idNotificacion_fkey" FOREIGN KEY ("idNotificacion") REFERENCES public."Notificacion"("idNotificacion") ON DELETE CASCADE;


--
-- Name: NotificacionUsuario NotificacionUsuario_idUsuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."NotificacionUsuario"
    ADD CONSTRAINT "NotificacionUsuario_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: PoliticaDocumento PoliticaDocumento_idPolitica_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."PoliticaDocumento"
    ADD CONSTRAINT "PoliticaDocumento_idPolitica_fkey" FOREIGN KEY ("idPolitica") REFERENCES public."Politica"("idPolitica") ON DELETE CASCADE;


--
-- Name: Preferencia Preferencia_idUsuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Preferencia"
    ADD CONSTRAINT "Preferencia_idUsuario_fkey" FOREIGN KEY ("idUsuario") REFERENCES public."Usuario"("idUsuario") ON DELETE CASCADE;


--
-- Name: Pregunta Pregunta_idEncuesta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."Pregunta"
    ADD CONSTRAINT "Pregunta_idEncuesta_fkey" FOREIGN KEY ("idEncuesta") REFERENCES public."Encuesta"("idEncuesta") ON DELETE RESTRICT;


--
-- Name: ProfesorUnidadFormacion ProfesorUnidadFormacion_idProfesor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."ProfesorUnidadFormacion"
    ADD CONSTRAINT "ProfesorUnidadFormacion_idProfesor_fkey" FOREIGN KEY ("idProfesor") REFERENCES public."Profesor"("idProfesor") ON DELETE CASCADE;


--
-- Name: ProfesorUnidadFormacion ProfesorUnidadFormacion_idUF_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."ProfesorUnidadFormacion"
    ADD CONSTRAINT "ProfesorUnidadFormacion_idUF_fkey" FOREIGN KEY ("idUF") REFERENCES public."UnidadFormacion"("idUF") ON DELETE CASCADE;


--
-- Name: UnidadFormacionCarrera UnidadFormacionCarrera_idCarrera_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."UnidadFormacionCarrera"
    ADD CONSTRAINT "UnidadFormacionCarrera_idCarrera_fkey" FOREIGN KEY ("idCarrera") REFERENCES public."Carrera"("idCarrera") ON DELETE CASCADE;


--
-- Name: UnidadFormacionCarrera UnidadFormacionCarrera_idUF_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pae
--

ALTER TABLE ONLY public."UnidadFormacionCarrera"
    ADD CONSTRAINT "UnidadFormacionCarrera_idUF_fkey" FOREIGN KEY ("idUF") REFERENCES public."UnidadFormacion"("idUF") ON DELETE CASCADE;

--
-- PostgreSQL database dump complete
--

