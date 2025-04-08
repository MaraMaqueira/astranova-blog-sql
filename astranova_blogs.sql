---Creacion de las tablas

-- a) Tabla: Usuarios
CREATE TABLE Usuarios (
  usuario_id INT PRIMARY KEY,                      
  nombre_usuario VARCHAR(50),                      
  correo_electronico VARCHAR(100) UNIQUE,         
  fecha_registro DATETIME                          
);

-- c) Tabla: Categorías
CREATE TABLE Categorias (
  categoria_id INT PRIMARY KEY,                   
  nombre_categoria VARCHAR(50)                     
);  

-- b) Tabla: Publicaciones
CREATE TABLE Publicaciones (
  publicacion_id INT PRIMARY KEY,                 
  titulo VARCHAR(100),                             
  contenido TEXT,                                 
  fecha_publicacion DATETIME,                     
  usuario_id INT,                                  
  categoria_id INT,                              
  CONSTRAINT fk_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id),
  CONSTRAINT fk_categoria FOREIGN KEY (categoria_id) REFERENCES Categorias(categoria_id)
);

-- d) Tabla: Etiquetas
CREATE TABLE Etiquetas (
  etiqueta_id INT PRIMARY KEY,                    
  nombre_etiqueta VARCHAR(50)                     

-- e) Tabla: Publicacion Etiqueta
CREATE TABLE PublicacionEtiqueta (
  publicacion_id INT,                             
  etiqueta_id INT,                                
  PRIMARY KEY (publicacion_id, etiqueta_id),
  CONSTRAINT fk_pe_publicacion FOREIGN KEY (publicacion_id) REFERENCES Publicaciones(publicacion_id),
  CONSTRAINT fk_pe_etiqueta FOREIGN KEY (etiqueta_id) REFERENCES Etiquetas(etiqueta_id)
);

-- f) Tabla: Comentarios
CREATE TABLE Comentarios (
  comentario_id INT PRIMARY KEY,                  
  contenido TEXT,                                 
  fecha_comentario DATETIME,                      
  usuario_id INT,                                 
  publicacion_id INT,                            
  CONSTRAINT fk_comentario_usuario FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id),
  CONSTRAINT fk_comentario_publicacion FOREIGN KEY (publicacion_id) REFERENCES Publicaciones(publicacion_id)
);
