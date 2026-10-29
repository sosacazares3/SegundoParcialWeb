-- ============================================================
-- BASE DE DATOS: ESCUELA
-- SISTEMA DE CONTROL ESCOLAR
-- MySQL 8.0+
-- ============================================================

DROP DATABASE IF EXISTS ESCUELA;

CREATE DATABASE ESCUELA
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE ESCUELA;


-- ============================================================
-- 1. TABLA ALUMNO
-- ============================================================

CREATE TABLE ALUMNO
(
    ID BIGINT NOT NULL AUTO_INCREMENT,
    NOMBRE VARCHAR(100) NOT NULL,
    EDAD INT NOT NULL,
    PROMEDIO DECIMAL(4,2) NOT NULL,

    PRIMARY KEY (ID),

    CONSTRAINT CHK_ALUMNO_EDAD
        CHECK (EDAD > 0),

    CONSTRAINT CHK_ALUMNO_PROMEDIO
        CHECK (PROMEDIO BETWEEN 0 AND 10)

) ENGINE = InnoDB;


-- ============================================================
-- 2. TABLA PROFESOR
-- ============================================================

CREATE TABLE PROFESOR
(
    ID BIGINT NOT NULL AUTO_INCREMENT,
    NOMBRE VARCHAR(100) NOT NULL,
    ESPECIALIDAD VARCHAR(100) NOT NULL,

    PRIMARY KEY (ID)

) ENGINE = InnoDB;


-- ============================================================
-- 3. TABLA MATERIA
-- ============================================================

CREATE TABLE MATERIA
(
    ID BIGINT NOT NULL AUTO_INCREMENT,
    NOMBRE VARCHAR(100) NOT NULL,
    CREDITOS INT NOT NULL,

    PRIMARY KEY (ID),

    CONSTRAINT CHK_MATERIA_CREDITOS
        CHECK (CREDITOS > 0)

) ENGINE = InnoDB;


-- ============================================================
-- 4. TABLA PROFESOR_MATERIA
-- ============================================================

CREATE TABLE PROFESOR_MATERIA
(
    ID BIGINT NOT NULL AUTO_INCREMENT,
    PROFESOR_ID BIGINT NOT NULL,
    MATERIA_ID BIGINT NOT NULL,

    PRIMARY KEY (ID),

    CONSTRAINT UK_PROFESOR_MATERIA
        UNIQUE (PROFESOR_ID, MATERIA_ID),

    CONSTRAINT FK_PROFESOR_MATERIA_PROFESOR
        FOREIGN KEY (PROFESOR_ID)
            REFERENCES PROFESOR(ID),

    CONSTRAINT FK_PROFESOR_MATERIA_MATERIA
        FOREIGN KEY (MATERIA_ID)
            REFERENCES MATERIA(ID)

) ENGINE = InnoDB;


-- ============================================================
-- 5. TABLA ALUMNO_MATERIA
-- ============================================================

CREATE TABLE ALUMNO_MATERIA
(
    ID BIGINT NOT NULL AUTO_INCREMENT,
    ALUMNO_ID BIGINT NOT NULL,
    MATERIA_ID BIGINT NOT NULL,
    CALIFICACION DECIMAL(4,2) NULL,

    PRIMARY KEY (ID),

    CONSTRAINT UK_ALUMNO_MATERIA
        UNIQUE (ALUMNO_ID, MATERIA_ID),

    CONSTRAINT FK_ALUMNO_MATERIA_ALUMNO
        FOREIGN KEY (ALUMNO_ID)
            REFERENCES ALUMNO(ID),

    CONSTRAINT FK_ALUMNO_MATERIA_MATERIA
        FOREIGN KEY (MATERIA_ID)
            REFERENCES MATERIA(ID),

    CONSTRAINT CHK_ALUMNO_MATERIA_CALIFICACION
        CHECK (
            CALIFICACION IS NULL
                OR CALIFICACION BETWEEN 0 AND 10
            )

) ENGINE = InnoDB;


-- ============================================================
-- 6. TABLA ROL
-- ============================================================

CREATE TABLE ROL
(
    ID BIGINT NOT NULL AUTO_INCREMENT,
    NOMBRE VARCHAR(50) NOT NULL,
    DESCRIPCION VARCHAR(150),

    PRIMARY KEY (ID),

    CONSTRAINT UK_ROL_NOMBRE
        UNIQUE (NOMBRE)

) ENGINE = InnoDB;


-- ============================================================
-- 7. TABLA USUARIO
-- ============================================================

CREATE TABLE USUARIO
(
    ID BIGINT NOT NULL AUTO_INCREMENT,
    USERNAME VARCHAR(50) NOT NULL,
    PASSWORD VARCHAR(100) NOT NULL,
    ROL_ID BIGINT NOT NULL,
    ALUMNO_ID BIGINT NULL,
    PROFESOR_ID BIGINT NULL,
    ACTIVO BOOLEAN NOT NULL DEFAULT TRUE,

    PRIMARY KEY (ID),

    CONSTRAINT UK_USUARIO_USERNAME
        UNIQUE (USERNAME),

    CONSTRAINT UK_USUARIO_ALUMNO
        UNIQUE (ALUMNO_ID),

    CONSTRAINT UK_USUARIO_PROFESOR
        UNIQUE (PROFESOR_ID),

    CONSTRAINT FK_USUARIO_ROL
        FOREIGN KEY (ROL_ID)
            REFERENCES ROL(ID),

    CONSTRAINT FK_USUARIO_ALUMNO
        FOREIGN KEY (ALUMNO_ID)
            REFERENCES ALUMNO(ID),

    CONSTRAINT FK_USUARIO_PROFESOR
        FOREIGN KEY (PROFESOR_ID)
            REFERENCES PROFESOR(ID),

    CONSTRAINT CHK_USUARIO_PERSONA
        CHECK (
            (
                ALUMNO_ID IS NOT NULL
                    AND PROFESOR_ID IS NULL
                )
                OR
            (
                ALUMNO_ID IS NULL
                    AND PROFESOR_ID IS NOT NULL
                )
            )

) ENGINE = InnoDB;


-- ============================================================
-- INSERTS
-- ============================================================

INSERT INTO ALUMNO
(ID, NOMBRE, EDAD, PROMEDIO)
VALUES
    (1, 'MAX', 20, 9.50),
    (2, 'EMILIANO', 22, 8.70),
    (3, 'XIMENA', 19, 9.10);


-- ============================================================
-- 9. PROFESORES
-- ============================================================

INSERT INTO PROFESOR
(ID, NOMBRE, ESPECIALIDAD)
VALUES
    (1, 'GERDOC', 'PROGRAMACION'),
    (2, 'PAOLA', 'BASES DE DATOS'),
    (3, 'ADAN', 'MATEMATICAS'),
    (4, 'GLORIA', 'REDES');


-- ============================================================
-- 10. MATERIAS
-- ============================================================

INSERT INTO MATERIA
(ID, NOMBRE, CREDITOS)
VALUES
    (1, 'PROGRAMACION ORIENTADA A OBJETOS', 8),
    (2, 'BASES DE DATOS', 8),
    (3, 'MATEMATICAS', 6),
    (4, 'REDES DE COMPUTADORAS', 7),
    (5, 'DESARROLLO WEB', 8);


-- ============================================================
-- 11. PROFESOR_MATERIA
-- ============================================================

INSERT INTO PROFESOR_MATERIA
(ID, PROFESOR_ID, MATERIA_ID)
VALUES
    (1, 1, 1),
    (2, 1, 5),
    (3, 2, 2),
    (4, 3, 3),
    (5, 4, 4);


-- ============================================================
-- 12. ALUMNO_MATERIA
-- ============================================================

INSERT INTO ALUMNO_MATERIA
(ID, ALUMNO_ID, MATERIA_ID, CALIFICACION)
VALUES
    -- Calificaciones originales
    (1, 1, 1, 9.50),
    (2, 1, 2, 9.00),
    (3, 1, 3, 8.50),
    (4, 2, 1, 8.00),
    (5, 2, 2, 8.70),
    (6, 3, 3, 9.80),
    (7, 3, 4, 9.20),

    -- Inscripciones sin calificación
    (8, 1, 5, NULL),
    (9, 2, 5, NULL),
    (10, 3, 5, NULL),
    (11, 3, 1, NULL);


-- ============================================================
-- 13. ROLES
-- ============================================================

INSERT INTO ROL
(ID, NOMBRE, DESCRIPCION)
VALUES
    (1, 'ALUMNO', 'Consulta sus materias y calificaciones'),
    (2, 'PROFESOR', 'Consulta alumnos y administra calificaciones');


-- ============================================================
-- 14. USUARIOS DE ALUMNOS
-- ============================================================

INSERT INTO USUARIO
(USERNAME, PASSWORD, ROL_ID, ALUMNO_ID, PROFESOR_ID, ACTIVO)
VALUES
    ('MAX', '1234', 1, 1, NULL, TRUE),
    ('EMILIANO', '12345', 1, 2, NULL, TRUE),
    ('XIMENA', '123456', 1, 3, NULL, TRUE);


-- ============================================================
-- 15. USUARIOS DE PROFESORES
-- ============================================================

INSERT INTO USUARIO
(USERNAME, PASSWORD, ROL_ID, ALUMNO_ID, PROFESOR_ID, ACTIVO)
VALUES
    ('GERDOC', '1234', 2, NULL, 1, TRUE),
    ('PAOLA', '12345', 2, NULL, 2, TRUE),
    ('ADAN', '123456', 2, NULL, 3, TRUE),
    ('GLORIA', '1234567', 2, NULL, 4, TRUE);


-- ============================================================
-- CONSULTAS DE VERIFICACIÓN
-- ============================================================

-- 16. Verificar usuarios y roles

SELECT
    U.ID,
    U.USERNAME,
    R.NOMBRE AS ROL,
    COALESCE(A.NOMBRE, P.NOMBRE) AS NOMBRE_COMPLETO,
    U.ACTIVO
FROM USUARIO U
         INNER JOIN ROL R
                    ON R.ID = U.ROL_ID
         LEFT JOIN ALUMNO A
                   ON A.ID = U.ALUMNO_ID
         LEFT JOIN PROFESOR P
                   ON P.ID = U.PROFESOR_ID
ORDER BY R.NOMBRE, U.USERNAME;


-- 17. Consultar calificaciones de alumnos

SELECT
    A.NOMBRE AS ALUMNO,
    M.NOMBRE AS MATERIA,
    AM.CALIFICACION
FROM ALUMNO_MATERIA AM
         INNER JOIN ALUMNO A
                    ON A.ID = AM.ALUMNO_ID
         INNER JOIN MATERIA M
                    ON M.ID = AM.MATERIA_ID
ORDER BY A.NOMBRE, M.NOMBRE;


-- 18. Consultar alumnos asignados a profesores

SELECT
    P.NOMBRE AS PROFESOR,
    M.NOMBRE AS MATERIA,
    A.NOMBRE AS ALUMNO,
    AM.CALIFICACION
FROM PROFESOR_MATERIA PM
         INNER JOIN PROFESOR P
                    ON P.ID = PM.PROFESOR_ID
         INNER JOIN MATERIA M
                    ON M.ID = PM.MATERIA_ID
         INNER JOIN ALUMNO_MATERIA AM
                    ON AM.MATERIA_ID = M.ID
         INNER JOIN ALUMNO A
                    ON A.ID = AM.ALUMNO_ID
ORDER BY P.NOMBRE, M.NOMBRE, A.NOMBRE;


-- 19. Verificar cantidad de registros

SELECT 'ALUMNO' AS TABLA, COUNT(*) AS REGISTROS FROM ALUMNO
UNION ALL
SELECT 'PROFESOR', COUNT(*) FROM PROFESOR
UNION ALL
SELECT 'MATERIA', COUNT(*) FROM MATERIA
UNION ALL
SELECT 'PROFESOR_MATERIA', COUNT(*) FROM PROFESOR_MATERIA
UNION ALL
SELECT 'ALUMNO_MATERIA', COUNT(*) FROM ALUMNO_MATERIA
UNION ALL
SELECT 'ROL', COUNT(*) FROM ROL
UNION ALL
SELECT 'USUARIO', COUNT(*) FROM USUARIO;