-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: mi_oxxito
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actividadlideres`
--

DROP TABLE IF EXISTS `actividadlideres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `actividadlideres` (
  `actividad_id` int unsigned NOT NULL,
  `lider_id` int unsigned NOT NULL,
  `acceso` datetime NOT NULL,
  PRIMARY KEY (`actividad_id`),
  KEY `lider_FK` (`lider_id`),
  CONSTRAINT `lider_FK` FOREIGN KEY (`lider_id`) REFERENCES `lideres` (`lider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `asesores`
--

DROP TABLE IF EXISTS `asesores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asesores` (
  `asesor_id` int unsigned NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) NOT NULL,
  `contrasenia` varchar(50) NOT NULL,
  PRIMARY KEY (`asesor_id`),
  UNIQUE KEY `asesores_unique` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `categoriaspreguntas`
--

DROP TABLE IF EXISTS `categoriaspreguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categoriaspreguntas` (
  `categoria_id` int unsigned NOT NULL AUTO_INCREMENT,
  `categoria` varchar(20) NOT NULL,
  PRIMARY KEY (`categoria_id`),
  UNIQUE KEY `categoria_pregunta_unique` (`categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estados`
--

DROP TABLE IF EXISTS `estados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estados` (
  `estado_id` int unsigned NOT NULL AUTO_INCREMENT,
  `estado` varchar(50) NOT NULL,
  PRIMARY KEY (`estado_id`),
  UNIQUE KEY `estado_unique` (`estado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `generos`
--

DROP TABLE IF EXISTS `generos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generos` (
  `genero_id` int unsigned NOT NULL,
  `genero` varchar(15) NOT NULL,
  PRIMARY KEY (`genero_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `juegos`
--

DROP TABLE IF EXISTS `juegos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `juegos` (
  `juego_id` int unsigned NOT NULL AUTO_INCREMENT,
  `puntos_meta` int NOT NULL,
  `jugador_en_turno` int unsigned DEFAULT NULL,
  `ganador` int unsigned DEFAULT NULL,
  `creador` int unsigned DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tiempo_desde_turno` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`juego_id`),
  KEY `juego_jugador_en_turno_FK` (`jugador_en_turno`),
  KEY `juego_ganador_FK` (`ganador`),
  KEY `juego_creador_FK` (`creador`),
  CONSTRAINT `juego_creador_FK` FOREIGN KEY (`creador`) REFERENCES `jugadores` (`jugador_id`),
  CONSTRAINT `juego_ganador_FK` FOREIGN KEY (`ganador`) REFERENCES `jugadores` (`jugador_id`),
  CONSTRAINT `juego_jugador_en_turno_FK` FOREIGN KEY (`jugador_en_turno`) REFERENCES `jugadores` (`jugador_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jugadores`
--

DROP TABLE IF EXISTS `jugadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jugadores` (
  `jugador_id` int unsigned NOT NULL AUTO_INCREMENT,
  `puntos_actuales` int unsigned NOT NULL DEFAULT '0',
  `multiplicador` float NOT NULL DEFAULT '1',
  `lider_id` int unsigned NOT NULL,
  `juego_id` int unsigned NOT NULL,
  `turno` tinyint unsigned DEFAULT NULL,
  PRIMARY KEY (`jugador_id`),
  UNIQUE KEY `jugadores_unique` (`juego_id`,`lider_id`),
  UNIQUE KEY `turnos_unique` (`jugador_id`,`juego_id`,`turno`),
  KEY `jugador_lider_FK` (`lider_id`),
  CONSTRAINT `jugador_juego_FK` FOREIGN KEY (`juego_id`) REFERENCES `juegos` (`juego_id`),
  CONSTRAINT `jugador_lider_FK` FOREIGN KEY (`lider_id`) REFERENCES `lideres` (`lider_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `lideres`
--

DROP TABLE IF EXISTS `lideres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lideres` (
  `lider_id` int unsigned NOT NULL AUTO_INCREMENT,
  `usuario` varchar(20) NOT NULL,
  `contrasena` varchar(20) NOT NULL,
  `sede_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`lider_id`),
  UNIQUE KEY `Lider_unique` (`usuario`),
  KEY `lideres_sedes_FK` (`sede_id`),
  CONSTRAINT `lideres_sedes_FK` FOREIGN KEY (`sede_id`) REFERENCES `sedes` (`sede_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mobiliario`
--

DROP TABLE IF EXISTS `mobiliario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mobiliario` (
  `mueble_id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`mueble_id`),
  UNIQUE KEY `mobiliario_unique` (`nombre`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `municipios`
--

DROP TABLE IF EXISTS `municipios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `municipios` (
  `municipio_id` int unsigned NOT NULL AUTO_INCREMENT,
  `municipio` varchar(50) NOT NULL,
  `estado_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`municipio_id`),
  UNIQUE KEY `municipio_unique` (`municipio`),
  KEY `municipio_estado_FK` (`estado_id`),
  CONSTRAINT `municipio_estado_FK` FOREIGN KEY (`estado_id`) REFERENCES `estados` (`estado_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `nivelespreguntas`
--

DROP TABLE IF EXISTS `nivelespreguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nivelespreguntas` (
  `nivel_id` int unsigned NOT NULL AUTO_INCREMENT,
  `puntos` int NOT NULL,
  `tiempo` int NOT NULL,
  `nombre` varchar(20) NOT NULL,
  PRIMARY KEY (`nivel_id`),
  UNIQUE KEY `nivelespreguntas_unique` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oxxitos`
--

DROP TABLE IF EXISTS `oxxitos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oxxitos` (
  `oxxito_id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `lider_id` int unsigned NOT NULL,
  PRIMARY KEY (`oxxito_id`),
  KEY `oxxitos_lideres_FK` (`lider_id`),
  CONSTRAINT `oxxitos_lideres_FK` FOREIGN KEY (`lider_id`) REFERENCES `lideres` (`lider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oxxitos_mobiliario`
--

DROP TABLE IF EXISTS `oxxitos_mobiliario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oxxitos_mobiliario` (
  `mueble_id` int unsigned NOT NULL,
  `oxxito_id` int unsigned NOT NULL,
  `nivel` int unsigned DEFAULT '0',
  PRIMARY KEY (`mueble_id`,`oxxito_id`),
  KEY `oxxito_id` (`oxxito_id`),
  CONSTRAINT `oxxitos_mobiliario_ibfk_1` FOREIGN KEY (`mueble_id`) REFERENCES `mobiliario` (`mueble_id`),
  CONSTRAINT `oxxitos_mobiliario_ibfk_2` FOREIGN KEY (`oxxito_id`) REFERENCES `oxxitos` (`oxxito_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `personajes`
--

DROP TABLE IF EXISTS `personajes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personajes` (
  `lider_id` int unsigned NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `genero_id` int unsigned NOT NULL,
  `color_piel` varchar(50) NOT NULL,
  `color_pelo` varchar(50) NOT NULL,
  `color_ojos` varchar(50) NOT NULL,
  PRIMARY KEY (`lider_id`),
  KEY `genero_id` (`genero_id`),
  CONSTRAINT `personajes_ibfk_1` FOREIGN KEY (`lider_id`) REFERENCES `lideres` (`lider_id`),
  CONSTRAINT `personajes_ibfk_2` FOREIGN KEY (`genero_id`) REFERENCES `generos` (`genero_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pregunta_jugador`
--

DROP TABLE IF EXISTS `pregunta_jugador`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pregunta_jugador` (
  `jugador_id` int unsigned NOT NULL,
  `pregunta_id` int unsigned NOT NULL,
  `correcta` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`jugador_id`,`pregunta_id`),
  KEY `pregunta_FK` (`pregunta_id`),
  CONSTRAINT `jugador_FK` FOREIGN KEY (`jugador_id`) REFERENCES `jugadores` (`jugador_id`),
  CONSTRAINT `pregunta_FK` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `preguntas`
--

DROP TABLE IF EXISTS `preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preguntas` (
  `pregunta_id` int unsigned NOT NULL AUTO_INCREMENT,
  `pregunta` text NOT NULL,
  `opcion_correcta` varchar(100) NOT NULL,
  `opcion_2` varchar(100) NOT NULL,
  `opcion_3` varchar(100) DEFAULT NULL,
  `opcion_4` varchar(100) DEFAULT NULL,
  `justificacion` text NOT NULL,
  `categoria_id` int unsigned NOT NULL,
  `nivel_id` int unsigned NOT NULL,
  PRIMARY KEY (`pregunta_id`),
  KEY `preguntas_categoria_pregunta_FK` (`categoria_id`),
  KEY `preguntas_nivel_pregunta_FK` (`nivel_id`),
  CONSTRAINT `preguntas_categoria_pregunta_FK` FOREIGN KEY (`categoria_id`) REFERENCES `categoriaspreguntas` (`categoria_id`),
  CONSTRAINT `preguntas_nivel_pregunta_FK` FOREIGN KEY (`nivel_id`) REFERENCES `nivelespreguntas` (`nivel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sedes`
--

DROP TABLE IF EXISTS `sedes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sedes` (
  `sede_id` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) DEFAULT NULL,
  `municipio_id` int unsigned DEFAULT NULL,
  `asesor_id` int unsigned DEFAULT NULL,
  PRIMARY KEY (`sede_id`),
  KEY `sede_municipio_FK` (`municipio_id`),
  KEY `sedes_asesores_FK` (`asesor_id`),
  CONSTRAINT `sede_municipio_FK` FOREIGN KEY (`municipio_id`) REFERENCES `municipios` (`municipio_id`),
  CONSTRAINT `sedes_asesores_FK` FOREIGN KEY (`asesor_id`) REFERENCES `asesores` (`asesor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'mi_oxxito'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-10 21:32:46
