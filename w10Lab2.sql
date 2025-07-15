USE seriesDB;

-- 1.- Utilizar GROUP_CONCAT
SELECT s.nombre AS Serie, t.numero AS Temporada, GROUP_CONCAT(e.titulo SEPARATOR '/') AS Episodios 
FROM Serie s
LEFT JOIN Temporada t ON s.id = t.serie_id
LEFT JOIN Episodio e ON t.id = e.temporada_id
GROUP BY Serie,Temporada; 

/*
Serie	Temporada	Episodios
Breaking Bad	1	Episodio 1/Episodio 2/Episodio 3
Breaking Bad	2	Episodio 3/Episodio 4/Episodio 5/Episodio 1/Episodio 2
Breaking Bad	3	Episodio 4/Episodio 1/Episodio 2/Episodio 3
Dark	1	Episodio 1/Episodio 2/Episodio 3/Episodio 4/Episodio 5
Dark	2	Episodio 1/Episodio 3/Episodio 4/Episodio 5
Dark	3	Episodio 3/Episodio 4/Episodio 5/Episodio 1/Episodio 2
Stranger Things	1	Episodio 2/Episodio 3/Episodio 5
Stranger Things	2	Episodio 2/Episodio 3/Episodio 4/Episodio 5/Episodio 1
Stranger Things	3	Episodio 4/Episodio 5/Episodio 3
The Mandalorian	1	Episodio 1/Episodio 2/Episodio 3/Episodio 5
The Mandalorian	2	Episodio 4/Episodio 1/Episodio 2
The Mandalorian	3	Episodio 2/Episodio 3/Episodio 4/Episodio 5
The Office	1	Episodio 5/Episodio 1/Episodio 2/Episodio 3/Episodio 4
The Office	2	Episodio 1/Episodio 2/Episodio 3/Episodio 5
The Office	3	Episodio 1/Episodio 2/Episodio 3/Episodio 4/Episodio 5

*/

-- Agrupar por serie y la lista de episodios con temporada 
SELECT  s.nombre,  GROUP_CONCAT( CONCAT('T',t.numero), e.titulo SEPARATOR ' /') AS Episodios 
FROM Serie s
LEFT JOIN Temporada t ON s.id = t.serie_id
LEFT JOIN Episodio e ON t.id = e.temporada_id
GROUP BY s.nombre; 


/*
# nombre	Episodios
Breaking Bad	T1Episodio 1 /T1Episodio 2 /T1Episodio 3 /T2Episodio 1 /T2Episodio 2 /T2Episodio 3 /T2Episodio 4 /T2Episodio 5 /T3Episodio 1 /T3Episodio 2 /T3Episodio 3 /T3Episodio 4
Dark	T1Episodio 1 /T1Episodio 2 /T1Episodio 3 /T1Episodio 4 /T1Episodio 5 /T2Episodio 1 /T2Episodio 3 /T2Episodio 4 /T2Episodio 5 /T3Episodio 1 /T3Episodio 2 /T3Episodio 3 /T3Episodio 4 /T3Episodio 5
Stranger Things	T1Episodio 2 /T1Episodio 3 /T1Episodio 5 /T2Episodio 1 /T2Episodio 2 /T2Episodio 3 /T2Episodio 4 /T2Episodio 5 /T3Episodio 3 /T3Episodio 4 /T3Episodio 5
The Mandalorian	T1Episodio 1 /T1Episodio 2 /T1Episodio 3 /T1Episodio 5 /T2Episodio 1 /T2Episodio 2 /T2Episodio 4 /T3Episodio 2 /T3Episodio 3 /T3Episodio 4 /T3Episodio 5
The Office	T1Episodio 1 /T1Episodio 2 /T1Episodio 3 /T1Episodio 4 /T1Episodio 5 /T2Episodio 1 /T2Episodio 2 /T2Episodio 3 /T2Episodio 5 /T3Episodio 1 /T3Episodio 2 /T3Episodio 3 /T3Episodio 4 /T3Episodio 5

*/

-- Nombre de la serie con la lista de episodios no repetidos
SELECT s.nombre, GROUP_CONCAT(DISTINCT e.titulo SEPARATOR '/')
FROM Serie s
LEFT JOIN Temporada t ON t.serie_id = s.id
LEFT JOIN Episodio e ON e.temporada_id = t.id
GROUP BY s.nombre; 


/*
# nombre	GROUP_CONCAT(DISTINCT e.titulo SEPARATOR '/')
Breaking Bad	Episodio 1/Episodio 2/Episodio 3/Episodio 4/Episodio 5
Dark	Episodio 1/Episodio 2/Episodio 3/Episodio 4/Episodio 5
Stranger Things	Episodio 1/Episodio 2/Episodio 3/Episodio 4/Episodio 5
The Mandalorian	Episodio 1/Episodio 2/Episodio 3/Episodio 4/Episodio 5
The Office	Episodio 1/Episodio 2/Episodio 3/Episodio 4/Episodio 5

*/

-- 2.- Combinacion de Joins

/* 
   En esta consulta nos aparecerán el número de temporadas pero tienen el nombre de la serie
   es y la cantidad de episodios es null.
*/

SELECT s.nombre AS serie_nombre, t.numero AS temporada_numero, COUNT(e.id) AS cantidad_episodios
FROM Temporada t
LEFT JOIN Serie s ON t.serie_id = s.id
LEFT JOIN Episodio e ON t.id = e.temporada_id
GROUP BY s.nombre, t.id, t.numero;

/*
# serie_nombre	temporada_numero	cantidad_episodios
	1	0
	2	0
Breaking Bad	1	3
Breaking Bad	2	5
Breaking Bad	3	4
Dark	1	5
Dark	2	4
Dark	3	5
Stranger Things	1	3
Stranger Things	2	5
Stranger Things	3	3
The Mandalorian	1	4
The Mandalorian	2	3
The Mandalorian	3	4
The Office	1	5
The Office	2	4
The Office	3	5

*/



-- Cuando hacemos el simple cambio de un left y luego un right join tenemos la cantidad de 
-- episodios pero no tenemos el nombre de la serie ni tampoco el numero de temporada
SELECT s.nombre AS serie_nombre, t.numero AS temporada_numero, COUNT(e.id) AS cantidad_episodios
FROM Temporada t
LEFT JOIN Serie s ON t.serie_id = s.id
RIGHT JOIN Episodio e ON t.id = e.temporada_id
GROUP BY s.nombre, t.id, t.numero;

/*
# serie_nombre	temporada_numero	cantidad_episodios
		18
Breaking Bad	1	3
Breaking Bad	2	5
Breaking Bad	3	4
Dark	1	5
Dark	2	4
Dark	3	5
Stranger Things	1	3
Stranger Things	2	5
Stranger Things	3	3
The Mandalorian	1	4
The Mandalorian	2	3
The Mandalorian	3	4
The Office	1	5
The Office	2	4
The Office	3	5

*/


-- Si utilizamos primero el right y luego el left join no tenemos nulls
SELECT s.nombre AS serie_nombre, t.numero AS temporada_numero, COUNT(e.id) AS cantidad_episodios
FROM Temporada t
RIGHT JOIN Serie s ON t.serie_id = s.id
LEFT JOIN Episodio e ON t.id = e.temporada_id
GROUP BY s.nombre, t.id, t.numero;

/*
# serie_nombre	temporada_numero	cantidad_episodios
Breaking Bad	1	3
Breaking Bad	2	5
Breaking Bad	3	4
Dark	1	5
Dark	2	4
Dark	3	5
Stranger Things	1	3
Stranger Things	2	5
Stranger Things	3	3
The Mandalorian	1	4
The Mandalorian	2	3
The Mandalorian	3	4
The Office	1	5
The Office	2	4
The Office	3	5

*/


-- 3. Libreria

CREATE DATABASE libreria;
USE libreria;

CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE autores (
    id_autor INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    nacionalidad VARCHAR(50)
);

CREATE TABLE libros (
    id_libro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    id_autor INT,
    id_categoria INT,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

INSERT INTO categorias (nombre) VALUES
('Ficción'),
('Historia'),
('Ciencia');


INSERT INTO autores (nombre, nacionalidad) VALUES
('Gabriel García Márquez', 'Colombiano'),
('Isabel Allende', 'Chilena'),
('Jorge Luis Borges', 'Argentino'),
('Mario Vargas Llosa', 'Peruano'),
('Octavio Paz', 'Mexicano');

INSERT INTO libros (titulo, id_autor, id_categoria) VALUES
('Cien años de soledad', 1, 1),
('El coronel no tiene quien le escriba', 1, 1),
('La casa de los espíritus', 2, 1),
('Eva Luna', 2, 3),
('Ficciones', 3, 1),
('El Aleph', 3, 3),
('La ciudad y los perros', 4, 2),
('Conversación en La Catedral', 4, 2),
('El laberinto de la soledad', 5, 2),
('Libertad bajo palabra', 5, 3);


-- titulo libro con autor

SELECT a.nombre as autor, GROUP_CONCAT(l.titulo SEPARATOR '/') as libros
FROM autores a
LEFT JOIN libros l ON l.id_autor = a.id_autor
GROUP BY a.nombre;

/*
# autor	libros
Gabriel García Márquez	Cien años de soledad/El coronel no tiene quien le escriba
Isabel Allende	La casa de los espíritus/Eva Luna
Jorge Luis Borges	Ficciones/El Aleph
Mario Vargas Llosa	La ciudad y los perros/Conversación en La Catedral
Octavio Paz	El laberinto de la soledad/Libertad bajo palabra

*/

-- autor con libros y sus categorias 
SELECT a.nombre as autor, l.titulo AS libro, c.nombre as categorias
FROM autores a
LEFT JOIN libros l ON l.id_autor = a.id_autor
LEFT JOIN categorias c ON c.id_categoria = l.id_categoria
GROUP BY autor, libro;
/*
# autor	libro	categorias
Gabriel García Márquez	Cien años de soledad	Ficción
Gabriel García Márquez	El coronel no tiene quien le escriba	Ficción
Isabel Allende	Eva Luna	Ciencia
Isabel Allende	La casa de los espíritus	Ficción
Jorge Luis Borges	El Aleph	Ciencia
Jorge Luis Borges	Ficciones	Ficción
Mario Vargas Llosa	Conversación en La Catedral	Historia
Mario Vargas Llosa	La ciudad y los perros	Historia
Octavio Paz	El laberinto de la soledad	Historia
Octavio Paz	Libertad bajo palabra	Ciencia

*/


-- libros de autores que escribieron ficcion

SELECT a.nombre, l.titulo, c.nombre
FROM autores a
INNER JOIN libros l ON l.id_autor = a.id_autor
INNER JOIN categorias c ON c.id_categoria = l.id_categoria
WHERE c.nombre = "Ficcion";  

/*
# nombre	titulo	nombre
Gabriel García Márquez	Cien años de soledad	Ficción
Gabriel García Márquez	El coronel no tiene quien le escriba	Ficción
Isabel Allende	La casa de los espíritus	Ficción
Jorge Luis Borges	Ficciones	Ficción

*/