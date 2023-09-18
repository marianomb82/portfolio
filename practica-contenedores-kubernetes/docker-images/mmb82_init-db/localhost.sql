-- phpMyAdmin SQL Dump
-- version 3.3.9
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 10-06-2011 a las 01:58:10
-- Versión del servidor: 5.5.8
-- Versión de PHP: 5.3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `cds`
--
-- CREATE DATABASE `cds` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `cds`;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `actividad`
--

CREATE TABLE IF NOT EXISTS `actividad` (
  `ID_AC` smallint(6) NOT NULL AUTO_INCREMENT,
  `NOMBRE_AC` varchar(100) NOT NULL,
  `FECHA_IN_AC` varchar(50) NOT NULL,
  `FECHA_FIN_AC` varchar(50) NOT NULL,
  `DESC_AC` text NOT NULL,
  `FOTO_AC` varchar(100) DEFAULT NULL,
  `PLAZAS` int(4) NOT NULL,
  `N_PLAZAS_DIS` int(4) NOT NULL,
  `PRECIO_AC` float(10,2) NOT NULL,
  `ID_MON` smallint(6) NOT NULL,
  `ID_PISTA` smallint(6) NOT NULL,
  PRIMARY KEY (`ID_AC`),
  KEY `MONITOR_ACTIVIDAD_FK1` (`ID_MON`),
  KEY `PISTA_ACTIVIDAD_FK1` (`ID_PISTA`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=14 ;

--
-- Volcar la base de datos para la tabla `actividad`
--

INSERT INTO `actividad` (`ID_AC`, `NOMBRE_AC`, `FECHA_IN_AC`, `FECHA_FIN_AC`, `DESC_AC`, `FOTO_AC`, `PLAZAS`, `N_PLAZAS_DIS`, `PRECIO_AC`, `ID_MON`, `ID_PISTA`) VALUES
(4, 'padel', '1307318400', '1293840000', 'curso iniciaciÃ³n padel', '', 10, 10, 30.00, 6, 4),
(13, 'Baloncesto', '1307577600', '1330646400', 'gdb', '', 20, 20, 35.00, 6, 3);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `alquila`
--

CREATE TABLE IF NOT EXISTS `alquila` (
  `ID_AL` smallint(3) NOT NULL AUTO_INCREMENT,
  `ID_MAT` smallint(6) NOT NULL,
  `ID_SO` smallint(6) NOT NULL,
  `FECHA_IN` varchar(50) NOT NULL,
  `CANTIDAD` int(4) NOT NULL,
  `FECHA_FIN` varchar(50) NOT NULL,
  `IMPORTE` float(10,2) NOT NULL,
  `DEVUELTO` varchar(3) NOT NULL,
  `MULTA` float(10,2) DEFAULT NULL,
  PRIMARY KEY (`ID_AL`,`ID_MAT`,`ID_SO`,`FECHA_IN`),
  KEY `SOCIO_ALQUILA_FK1` (`ID_SO`),
  KEY `ID_MAT` (`ID_MAT`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

--
-- Volcar la base de datos para la tabla `alquila`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial`
--

CREATE TABLE IF NOT EXISTS `historial` (
  `id_historial` smallint(3) NOT NULL AUTO_INCREMENT,
  `id_mat` smallint(6) NOT NULL,
  `id_so` smallint(6) NOT NULL,
  `fecha_inicio` varchar(50) NOT NULL,
  `cantidad` int(4) NOT NULL,
  `fecha_fin` varchar(50) NOT NULL,
  `importe` float(10,2) NOT NULL,
  `devuelto` varchar(3) NOT NULL,
  `multa` float(10,2) NOT NULL,
  PRIMARY KEY (`id_historial`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `historial`
--

INSERT INTO `historial` (`id_historial`, `id_mat`, `id_so`, `fecha_inicio`, `cantidad`, `fecha_fin`, `importe`, `devuelto`, `multa`) VALUES
(1, 8, 7, '1307577600', 1, '1307577600', 2.00, 'Si', 0.00),
(2, 8, 7, '1307577600', 1, '1307577600', 2.00, 'Si', 0.00),
(3, 8, 7, '1307577600', 1, '1307577600', 2.00, 'Si', 0.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `historial_realiza`
--

CREATE TABLE IF NOT EXISTS `historial_realiza` (
  `ID_CONT` smallint(4) NOT NULL AUTO_INCREMENT,
  `ID_AC` smallint(6) NOT NULL,
  `ID_SO` smallint(6) NOT NULL,
  `FECHA_IN_CONT` varchar(50) NOT NULL,
  `FECHA_FIN_CONT` varchar(50) NOT NULL,
  `IMPORTE_CONT` float(10,2) NOT NULL,
  PRIMARY KEY (`ID_CONT`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

--
-- Volcar la base de datos para la tabla `historial_realiza`
--

INSERT INTO `historial_realiza` (`ID_CONT`, `ID_AC`, `ID_SO`, `FECHA_IN_CONT`, `FECHA_FIN_CONT`, `IMPORTE_CONT`) VALUES
(1, 13, 6, '1307577600', '1307491200', 35.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `material`
--

CREATE TABLE IF NOT EXISTS `material` (
  `ID_MAT` smallint(6) NOT NULL AUTO_INCREMENT,
  `NOMBRE_MAT` varchar(100) NOT NULL,
  `MARCA_MAT` varchar(100) NOT NULL,
  `MODELO_MAT` varchar(100) NOT NULL,
  `STOCK_MAT` int(4) NOT NULL,
  `PRECIO_MAT` float(10,2) NOT NULL,
  `FOTO_MAT` varchar(150) NOT NULL,
  `EN_ALMACEN` int(4) NOT NULL,
  PRIMARY KEY (`ID_MAT`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Volcar la base de datos para la tabla `material`
--

INSERT INTO `material` (`ID_MAT`, `NOMBRE_MAT`, `MARCA_MAT`, `MODELO_MAT`, `STOCK_MAT`, `PRECIO_MAT`, `FOTO_MAT`, `EN_ALMACEN`) VALUES
(8, 'balon', 'spalding', 'nba', 5, 2.00, '', 5);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `monitor`
--

CREATE TABLE IF NOT EXISTS `monitor` (
  `ID_MON` smallint(6) NOT NULL AUTO_INCREMENT,
  `NOMBRE_MON` varchar(100) NOT NULL,
  `APELLIDOS_MON` varchar(100) NOT NULL,
  `DNI_MON` varchar(10) NOT NULL,
  `TELEFONO_MON` varchar(9) NOT NULL,
  `FOTO_MON` varchar(150) DEFAULT NULL,
  `SEXO_MON` varchar(10) NOT NULL,
  `EMAIL_MON` varchar(100) NOT NULL,
  `EDAD_MON` int(3) NOT NULL,
  PRIMARY KEY (`ID_MON`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Volcar la base de datos para la tabla `monitor`
--

INSERT INTO `monitor` (`ID_MON`, `NOMBRE_MON`, `APELLIDOS_MON`, `DNI_MON`, `TELEFONO_MON`, `FOTO_MON`, `SEXO_MON`, `EMAIL_MON`, `EDAD_MON`) VALUES
(5, 'samuel', 'espino', '77777777o', '666666666', '', 'hombre', 'samuel@hotmail.com', 35),
(6, 'isaac', 'garrido', '74747474o', '666666666', '', 'hombre', 'templo32@hotmail.com', 35);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pista`
--

CREATE TABLE IF NOT EXISTS `pista` (
  `ID_PISTA` smallint(6) NOT NULL AUTO_INCREMENT,
  `NOMBRE_PISTA` varchar(100) NOT NULL,
  `ANCHO` float(10,2) NOT NULL,
  `LARGO` float(10,2) NOT NULL,
  PRIMARY KEY (`ID_PISTA`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

--
-- Volcar la base de datos para la tabla `pista`
--

INSERT INTO `pista` (`ID_PISTA`, `NOMBRE_PISTA`, `ANCHO`, `LARGO`) VALUES
(3, 'futbol1', 20.00, 20.00),
(4, 'padel1', 10.00, 20.00),
(5, 'tenis1', 11.00, 24.00),
(7, 'Pista Baloncesto', 28.00, 15.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `realiza`
--

CREATE TABLE IF NOT EXISTS `realiza` (
  `ID_RE` smallint(6) NOT NULL AUTO_INCREMENT,
  `ID_AC` smallint(6) NOT NULL,
  `ID_SO` smallint(6) NOT NULL,
  `FECHA_INICIO_RE` varchar(50) NOT NULL,
  `FECHA_FIN_RE` varchar(50) NOT NULL,
  `IMPORTE_RE` float(10,2) NOT NULL,
  PRIMARY KEY (`ID_RE`,`ID_AC`,`ID_SO`),
  KEY `SOCIO_REALIZA_FK1` (`ID_SO`),
  KEY `ACTIVIDAD_REALIZA_FK1` (`ID_AC`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Volcar la base de datos para la tabla `realiza`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `socio`
--

CREATE TABLE IF NOT EXISTS `socio` (
  `ID_SO` smallint(6) NOT NULL AUTO_INCREMENT,
  `NOMBRE_SO` varchar(100) NOT NULL,
  `APELLIDOS_SO` varchar(100) NOT NULL,
  `DNI_SO` varchar(10) NOT NULL,
  `TELEFONO_SO` varchar(9) NOT NULL,
  `EDAD_SO` varchar(3) NOT NULL,
  `SEXO_SO` varchar(10) NOT NULL,
  `EMAIL_SO` varchar(100) DEFAULT NULL,
  `DIRECCION_SO` varchar(100) NOT NULL,
  `FOTO_SO` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`ID_SO`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Volcar la base de datos para la tabla `socio`
--

INSERT INTO `socio` (`ID_SO`, `NOMBRE_SO`, `APELLIDOS_SO`, `DNI_SO`, `TELEFONO_SO`, `EDAD_SO`, `SEXO_SO`, `EMAIL_SO`, `DIRECCION_SO`, `FOTO_SO`) VALUES
(6, 'were', 'Bugar', '01431556w', '111111111', '20', 'hombre', 'anuso_@hotmail.com', 'arahal', ''),
(7, 'lorena', 'cano dominguez', '14758969L', '333333333', '32', 'mujer', 'lorena2210m@hotmail.com', 'alacala', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE IF NOT EXISTS `usuario` (
  `ID_US` smallint(6) NOT NULL AUTO_INCREMENT,
  `NOMBRE_US` varchar(100) NOT NULL,
  `APELLIDOS_US` varchar(100) NOT NULL,
  `DNI_US` varchar(10) NOT NULL,
  `TELEFONO_US` varchar(9) NOT NULL,
  `EDAD_US` varchar(3) NOT NULL,
  `SEXO_US` varchar(10) NOT NULL,
  `EMAIL_US` varchar(100) NOT NULL,
  `DIRECCION_US` varchar(100) NOT NULL,
  `FOTO_US` varchar(100) DEFAULT NULL,
  `TIPO_US` varchar(10) NOT NULL,
  `USER` varchar(50) NOT NULL,
  `PASSWORD` varchar(200) NOT NULL,
  PRIMARY KEY (`ID_US`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Volcar la base de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`ID_US`, `NOMBRE_US`, `APELLIDOS_US`, `DNI_US`, `TELEFONO_US`, `EDAD_US`, `SEXO_US`, `EMAIL_US`, `DIRECCION_US`, `FOTO_US`, `TIPO_US`, `USER`, `PASSWORD`) VALUES
(1, 'mariano', 'martin', '88888888e', '645834196', '32', 'hombre', 'jufrabu@hotmail.com', 'w', '', 'admin', 'mariano', 'e55fa8d84e9270abbe73e99b66a33169'),
(13, 'juane', 'maireles', '00000000q', '222222222', '30', 'hombre', 'anuso_@hotmail.com', 'arahal', '', 'gestor', 'juane', '49ccdb563dd7197cd5baae6eb154ce69'),
(14, 'pipi', 'MartÃ­n BugarÃ­n', '01431594p', '111111111', '20', 'mujer', 'jufrabu@hotmail.com', 'Salvador 5', 'img/Mariano-Copia de rosa tribal.jpg', 'admin', 'rrrr', '82bd80131e1d00375ae73cea7b691728'),
(16, 'sda', 'asdasd', '11111111p', '666666333', '23', 'hombre', 'samuel@hotmail.com', 'ff', '', 'gestor', '33', 'e55fa8d84e9270abbe73e99b66a33169'),
(22, 'marian1', 'dd', '88888888e', '444444444', '44', 'hombre', 'aortizh3@gmail.com', '4444', '', 'admin', 'mariano', '565f9f0971854bd6a3b579cbd57bef08');

--
-- Filtros para las tablas descargadas (dump)
--

--
-- Filtros para la tabla `actividad`
--
ALTER TABLE `actividad`
  ADD CONSTRAINT `MONITOR_ACTIVIDAD_FK1` FOREIGN KEY (`ID_MON`) REFERENCES `monitor` (`ID_MON`),
  ADD CONSTRAINT `PISTA_ACTIVIDAD_FK1` FOREIGN KEY (`ID_PISTA`) REFERENCES `pista` (`ID_PISTA`);

--
-- Filtros para la tabla `alquila`
--
ALTER TABLE `alquila`
  ADD CONSTRAINT `alquila_ibfk_1` FOREIGN KEY (`ID_SO`) REFERENCES `socio` (`ID_SO`),
  ADD CONSTRAINT `alquila_ibfk_2` FOREIGN KEY (`ID_MAT`) REFERENCES `material` (`ID_MAT`);

--
-- Filtros para la tabla `realiza`
--
ALTER TABLE `realiza`
  ADD CONSTRAINT `ACTIVIDAD_REALIZA_FK1` FOREIGN KEY (`ID_AC`) REFERENCES `actividad` (`ID_AC`),
  ADD CONSTRAINT `SOCIO_REALIZA_FK1` FOREIGN KEY (`ID_SO`) REFERENCES `socio` (`ID_SO`);
