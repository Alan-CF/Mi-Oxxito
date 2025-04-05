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
  PRIMARY KEY (`juego_id`),
  KEY `juego_jugador_en_turno_FK` (`jugador_en_turno`),
  KEY `juego_ganador_FK` (`ganador`),
  CONSTRAINT `juego_ganador_FK` FOREIGN KEY (`ganador`) REFERENCES `jugadores` (`jugador_id`),
  CONSTRAINT `juego_jugador_en_turno_FK` FOREIGN KEY (`jugador_en_turno`) REFERENCES `jugadores` (`jugador_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `juegos_preguntas`
--

DROP TABLE IF EXISTS `juegos_preguntas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `juegos_preguntas` (
  `juego_id` int unsigned NOT NULL,
  `pregunta_id` int unsigned NOT NULL,
  PRIMARY KEY (`juego_id`,`pregunta_id`),
  KEY `preguntas_juegos_preguntas_FK` (`pregunta_id`),
  CONSTRAINT `juegos_juegos_preguntas_FK` FOREIGN KEY (`juego_id`) REFERENCES `juegos` (`juego_id`),
  CONSTRAINT `preguntas_juegos_preguntas_FK` FOREIGN KEY (`pregunta_id`) REFERENCES `preguntas` (`pregunta_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  PRIMARY KEY (`jugador_id`),
  KEY `jugador_lider_FK` (`lider_id`),
  KEY `jugador_juego_FK` (`juego_id`),
  CONSTRAINT `jugador_juego_FK` FOREIGN KEY (`juego_id`) REFERENCES `juegos` (`juego_id`),
  CONSTRAINT `jugador_lider_FK` FOREIGN KEY (`lider_id`) REFERENCES `lideres` (`lider_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  PRIMARY KEY (`lider_id`),
  UNIQUE KEY `Lider_unique` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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

-- Dump completed on 2025-04-04 16:03:35
