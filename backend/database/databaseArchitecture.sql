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
  "ultimaConexion" DATE,
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
  "idUF" SERIAL PRIMARY KEY,
  "nombreUF" VARCHAR(50) NOT NULL,
  "semestre" SMALLINT NOT NULL
);

-- 6 --

CREATE TABLE "AsesorUnidadFormacion" (
  "idUsuario" VARCHAR(10) NOT NULL,
  "idUF" INTEGER NOT NULL,

  FOREIGN KEY ("idUsuario") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE,

  FOREIGN KEY ("idUF") 
  REFERENCES "UnidadFormacion" ("idUF")
  ON DELETE CASCADE
);

-- 7 --

CREATE TABLE "UnidadFormacionCarrera" (
  "idUF" INTEGER NOT NULL,
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
  "titulo" VARCHAR(50),
  "descripcion" VARCHAR(100),
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
  ON DELETE CASCADE
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
  ON DELETE CASCADE,

  FOREIGN KEY ("idAsesor") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE,
  
  FOREIGN KEY ("idAsesorado") 
  REFERENCES "Usuario" ("idUsuario")
  ON DELETE CASCADE
);