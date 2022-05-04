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
  "apellidoMaterno" VARCHAR(30) NOT NULL,
  "fotoPerfil" TEXT,
  "ultimaConexion" TIMESTAMP,
  "statusAcceso" STATUSACCESS
);

-- 2 --

CREATE TABLE "Asesor" (
  "idUsuario" VARCHAR(10) NOT NULL,
  "telefono" VARCHAR(10),
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

CREATE TABLE "Periodo" (
  "idPeriodo" SERIAL PRIMARY KEY,
  "número" SMALLINT NOT NULL,
  "fechaInicial" TIMESTAMP NOT NULL,
  "fechaFinal" TIMESTAMP NOT NULL
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
  "status" STATUSHORARIO NOT NULL
);

-- 16 --

CREATE TYPE STATUSASESORIA AS ENUM ('reservada', 'agendada', 'finalizada', 'cancelada');
-- reservada es antes de la confirmación de PAE
-- agendada es después de la confirmación de PAE
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
  "imagen" TEXT
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

CREATE TYPE ORIGENNOTIFICACION AS ENUM ('Asesoria reservada', 'Asesoria agendada', 'Asesoria cancelada', 'PAE');
-- Asesoria reservada es para confirmar la peticion de una asesoria antes de la confirmación de PAE
-- Asesoria agendada es para informar de la confirmación de PAE para la asesoria
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