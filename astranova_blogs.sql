-- ==========================================
-- SECCIÓN 1: CREACIÓN DE LA BASE Y TABLAS
-- ==========================================

DROP DATABASE IF EXISTS astranova_blog;
CREATE DATABASE astranova_blog;
USE astranova_blog;

-- Tabla: Usuarios
CREATE TABLE Usuarios (
  usuario_id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_usuario VARCHAR(50),
  correo_electronico VARCHAR(100) UNIQUE,
  fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: Categorías
CREATE TABLE Categorias (
  categoria_id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_categoria VARCHAR(50)
);

-- Tabla: Publicaciones
CREATE TABLE Publicaciones (
  publicacion_id INT PRIMARY KEY AUTO_INCREMENT,
  titulo VARCHAR(100),
  contenido TEXT,
  fecha_publicacion DATETIME DEFAULT CURRENT_TIMESTAMP,
  usuario_id INT,
  categoria_id INT,
  FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id),
  FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id)
);

-- Tabla: Etiquetas
CREATE TABLE Etiquetas (
  etiqueta_id INT PRIMARY KEY AUTO_INCREMENT,
  nombre_etiqueta VARCHAR(50)
);

-- Tabla: PublicacionEtiqueta
CREATE TABLE PublicacionEtiqueta (
  publicacion_id INT,
  etiqueta_id INT,
  PRIMARY KEY (publicacion_id, etiqueta_id),
  FOREIGN KEY (publicacion_id) REFERENCES Publicaciones(publicacion_id),
  FOREIGN KEY (etiqueta_id) REFERENCES Etiquetas(etiqueta_id)
);

-- Tabla: Comentarios
CREATE TABLE Comentarios (
  comentario_id INT PRIMARY KEY AUTO_INCREMENT,
  contenido TEXT,
  fecha_comentario DATETIME DEFAULT CURRENT_TIMESTAMP,
  usuario_id INT,
  publicacion_id INT,
  FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id),
  FOREIGN KEY (publicacion_id) REFERENCES Publicaciones(publicacion_id)
);

-- ==========================================
-- SECCIÓN 2: INSERCIÓN DE DATOS
-- ==========================================

-- Usuarios
INSERT INTO Usuarios (nombre_usuario, correo_electronico) VALUES
('Ana', 'ana@mail.com'),
('Luis', 'luis@mail.com');

-- Categorías
INSERT INTO Categorias (nombre_categoria) VALUES
('Tecnología'),
('Aeroespacial');

-- Publicaciones
INSERT INTO Publicaciones (titulo, contenido, usuario_id, categoria_id) VALUES
('Proyecto Apolo', 'Un artículo sobre el Apolo 11', 1, 2),
('Python para ciencia', 'Usos de Python en tecnología', 2, 1);

-- Etiquetas
INSERT INTO Etiquetas (nombre_etiqueta) VALUES
('NASA'),
('Programación');

-- PublicacionEtiqueta
INSERT INTO PublicacionEtiqueta VALUES
(1, 1),
(2, 2);

-- Comentarios
INSERT INTO Comentarios (contenido, usuario_id, publicacion_id) VALUES
('Excelente artículo', 2, 1),
('Muy informativo', 1, 2);

-- ==========================================
-- SECCIÓN 3: VISTAS
-- ==========================================

-- Vista: VistaPublicaciones
-- Muestra publicaciones con nombre de usuario y categoría
CREATE VIEW VistaPublicaciones AS
SELECT p.publicacion_id, p.titulo, p.fecha_publicacion, u.nombre_usuario, c.nombre_categoria
FROM Publicaciones p
JOIN Usuarios u ON p.usuario_id = u.usuario_id
JOIN Categorias c ON p.categoria_id = c.categoria_id;

-- Vista: VistaComentariosPorPublicacion
-- Lista de comentarios con título de publicación
CREATE VIEW VistaComentariosPorPublicacion AS
SELECT co.comentario_id, co.contenido, co.fecha_comentario, p.titulo AS publicacion
FROM Comentarios co
JOIN Publicaciones p ON co.publicacion_id = p.publicacion_id;

-- ==========================================
-- SECCIÓN 4: FUNCIONES
-- ==========================================

-- Función: cantidadComentariosPorUsuario
-- Devuelve la cantidad de comentarios que hizo un usuario
DELIMITER $$
CREATE FUNCTION cantidadComentariosPorUsuario(id INT) RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE cantidad INT;
  SELECT COUNT(*) INTO cantidad FROM Comentarios WHERE usuario_id = id;
  RETURN cantidad;
END $$
DELIMITER ;

-- ==========================================
-- SECCIÓN 5: STORED PROCEDURES
-- ==========================================

-- Procedure: agregarComentario
-- Agrega un comentario a una publicación
DELIMITER $$
CREATE PROCEDURE agregarComentario(
  IN contenido_comentario TEXT,
  IN id_usuario INT,
  IN id_publicacion INT
)
BEGIN
  INSERT INTO Comentarios (contenido, usuario_id, publicacion_id)
  VALUES (contenido_comentario, id_usuario, id_publicacion);
END $$
DELIMITER ;

-- ==========================================
-- SECCIÓN 6: TRIGGERS
-- ==========================================

-- Trigger: validarCorreoUnico
-- Antes de insertar un usuario, verifica que el correo no esté repetido
DELIMITER $$
CREATE TRIGGER validarCorreoUnico
BEFORE INSERT ON Usuarios
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM Usuarios WHERE correo_electronico = NEW.correo_electronico) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Correo electrónico ya registrado';
  END IF;
END $$
DELIMITER ;
