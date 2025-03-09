-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 09-03-2025 a las 00:32:11
-- Versión del servidor: 8.0.30-0ubuntu0.20.04.2
-- Versión de PHP: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `expedientes-graduacion-vs`
--
CREATE DATABASE IF NOT EXISTS `expedientes-graduacion-vs` DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci;
USE `expedientes-graduacion-vs`;

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_AGREGAROTRODOC` (IN `nombre` VARCHAR(200), IN `carrera` INT, IN `estado_doc` TINYINT)  BEGIN

	INSERT INTO `expedientes-graduacion-vs`.`otros_documentos`
	(`nombre_documento`,
	`id_carrera`,
	`estado`)
	VALUES
	(nombre,
	carrera,
	estado_doc);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_APROBARINFOESTUDIANTE` (IN `id_student` INT)  BEGIN

	UPDATE estudiante
	SET estado_informacion = 1
	WHERE id_estudiante = id_student;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BUSCARCITAS` (IN `rol_coor` INT, IN `buscador` VARCHAR(45) CHARSET utf8)  BEGIN

	SELECT est.id_estudiante, u_est.nombres_usuario, u_est.apellidos_usuario, est.numero_cuenta_estudiante, cita.fecha_cita   
	FROM (((cita INNER JOIN estudiante AS est ON cita.id_estudiante = est.id_estudiante) INNER JOIN usuario AS u_est ON est.id_usuario = u_est.id_usuario) INNER JOIN usuario AS coord ON coord.id_usuario = cita.id_usuario)
	WHERE coord.id_rol = rol_coor AND (u_est.nombres_usuario LIKE buscador OR u_est.apellidos_usuario LIKE buscador OR est.numero_cuenta_estudiante LIKE buscador OR cita.fecha_cita LIKE buscador)
    ORDER BY cita.id_cita DESC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BUSCARESTUDIANTESINDOC` (IN `id_rol` INT, IN `buscador` VARCHAR(45) CHARSET utf8, IN `estado` TINYINT)  BEGIN
	SELECT estudiante.id_estudiante, usuario.nombres_usuario, usuario.apellidos_usuario, estudiante.numero_cuenta_estudiante FROM (estudiante INNER JOIN usuario ON estudiante.id_usuario = usuario.id_usuario)
	WHERE estudiante.estado_informacion=1 AND estudiante.id_carrera=id_rol AND estudiante.estado_documento_descarga=estado AND (usuario.nombres_usuario LIKE buscador OR usuario.apellidos_usuario LIKE buscador OR estudiante.numero_cuenta_estudiante LIKE buscador)
	ORDER BY estudiante.id_estudiante ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BUSCARESTUDIANTESINVALIDAR` (IN `id_rol` INT, IN `buscador` VARCHAR(45) CHARSET utf8, IN `estado_info` TINYINT)  BEGIN
	SELECT estudiante.id_estudiante, usuario.nombres_usuario, usuario.apellidos_usuario, estudiante.numero_cuenta_estudiante FROM (estudiante INNER JOIN usuario ON estudiante.id_usuario = usuario.id_usuario)
	WHERE estudiante.estado_informacion=estado_info AND estudiante.id_carrera=id_rol AND (usuario.nombres_usuario LIKE buscador OR usuario.apellidos_usuario LIKE buscador OR estudiante.numero_cuenta_estudiante LIKE buscador)
	ORDER BY estudiante.id_estudiante ASC;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BUSCAREXPEDIENTESINREVISAR` (IN `rol_coor` INT, IN `buscador` VARCHAR(45) CHARSET utf8, IN `estado_solicitud` TINYINT)  BEGIN
	SELECT estudiante.id_estudiante, usuario.nombres_usuario, usuario.apellidos_usuario, estudiante.numero_cuenta_estudiante 
    FROM ((usuario INNER JOIN estudiante ON usuario.id_usuario = estudiante.id_usuario) INNER JOIN solicitud ON estudiante.id_estudiante = solicitud.id_estudiante)
	WHERE solicitud.estado = estado_solicitud AND estudiante.id_carrera = rol_coor AND (usuario.nombres_usuario LIKE buscador OR usuario.apellidos_usuario LIKE buscador OR estudiante.numero_cuenta_estudiante LIKE buscador);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_BUSCAROBSERVACIONES` (IN `buscador` VARCHAR(45))  BEGIN
    SELECT 
        e.id_estudiante,
        u.nombres_usuario,
        u.apellidos_usuario,
        e.numero_cuenta_estudiante,
        ci.id_comentario_informacion,
        ci.comentario
    FROM comentario_informacion ci
    INNER JOIN estudiante e ON ci.id_estudiante = e.id_estudiante
    INNER JOIN usuario u ON e.id_usuario = u.id_usuario
    WHERE 
        u.nombres_usuario LIKE buscador
        OR u.apellidos_usuario LIKE buscador
        OR e.numero_cuenta_estudiante LIKE buscador
        OR ci.comentario LIKE buscador
    ORDER BY ci.id_comentario_informacion DESC;
END$$

CREATE DEFINER=`admin`@`%` PROCEDURE `SP_BUSCAROBSERVACIONESDOC` (IN `buscador` VARCHAR(45))  NO SQL
BEGIN  
  SELECT 
        e.id_estudiante,
        u.nombres_usuario,
        u.apellidos_usuario,
        e.numero_cuenta_estudiante,
        rd.id_respuesta_documento,
        rd.descripcion
    FROM respuesta_documento rd
    INNER JOIN documento d ON rd.id_documento = d.id_documento
    INNER JOIN solicitud s ON d.id_solicitud = s.id_solicitud
    INNER JOIN estudiante e ON s.id_estudiante = e.id_estudiante
    INNER JOIN usuario u ON e.id_usuario = u.id_usuario
    WHERE 
        u.nombres_usuario LIKE buscador
        OR u.apellidos_usuario LIKE buscador
        OR e.numero_cuenta_estudiante LIKE buscador
        OR rd.descripcion LIKE buscador
    ORDER BY rd.id_respuesta_documento DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CAMBAIRESTADODOCINVALIDO` (IN `id_soli` INT, IN `codigo_doc` INT)  BEGIN
	
    UPDATE `expedientes-graduacion-vs`.`documento`
	SET
	`estado` = 2
	WHERE `id_solicitud` = id_soli AND `codigo_documento`= codigo_doc ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CAMBIARPASSWORD` (IN `new_password` VARCHAR(300), IN `id_user` INT, IN `token_user` VARCHAR(45))  BEGIN
	UPDATE `expedientes-graduacion-vs`.`usuario`
	SET
	`password_usuario` = new_password
	WHERE `id_usuario` = id_user;
    
    UPDATE `expedientes-graduacion-vs`.`token`
	SET
	`estado_token` = 2
	WHERE `token` = token_user AND `Usuario_id_usuario`=id_user;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CAMBIARPASSWORD2` (IN `new_password` VARCHAR(300), IN `id_user` INT)  BEGIN

	UPDATE `expedientes-graduacion-vs`.`usuario`
	SET
	`password_usuario` = new_password
	WHERE `id_usuario` = id_user;
    

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CREARSOLICITUDESTUDIANTE` (IN `link` VARCHAR(500), IN `id_student` INT)  BEGIN

	INSERT INTO `expedientes-graduacion-vs`.`solicitud`
	(`estado`,
	`fecha_solicitud`,
	`id_estudiante`,
	`ruta_solicitud`)
	VALUES
	(5,
	now(),
	id_student,
	link);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_CREARTOKEN` (IN `token` VARCHAR(45), IN `id_user` INT)  BEGIN
	INSERT INTO `expedientes-graduacion-vs`.`token`
	(`token`,
	`estado_token`,
	`Usuario_id_usuario`)
	VALUES
	(token,
	1,
	id_user);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EDITARCITA` (IN `new_fecha` DATETIME, IN `id_student` INT)  BEGIN

	UPDATE `expedientes-graduacion-vs`.`cita`
	SET
	`fecha_cita` = new_fecha
	WHERE `id_estudiante` = id_student;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EDITAROTRODOC` (IN `id` INT, IN `nombre` VARCHAR(200), IN `carrera` INT, IN `estado_doc` TINYINT)  BEGIN
	UPDATE `expedientes-graduacion-vs`.`otros_documentos`
	SET
	`nombre_documento` = nombre,
	`id_carrera` = carrera,
	`estado` = estado_doc
	WHERE `id_otros_documentos` = id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EDITARUSUARIO` (IN `id_edit` INT, IN `nombres_edit` VARCHAR(45), IN `apellidos_edit` VARCHAR(45), IN `correo_edit` VARCHAR(45), IN `estado_edit` TINYINT, IN `id_rol_edit` INT)  BEGIN
	UPDATE `expedientes-graduacion-vs`.`usuario` 
    SET 
    `nombres_usuario`= nombres_edit,
    `apellidos_usuario`= apellidos_edit ,
    `correo_usuario`= correo_edit,
    `estado_usuario`= estado_edit,
    `id_rol`= id_rol_edit
    WHERE `id_usuario`=id_edit;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_EDITPERIODOENTREGA` (IN `inicio` DATETIME, IN `fin` DATETIME, IN `estado_periodo` TINYINT, IN `id` INT)  BEGIN

	UPDATE `expedientes-graduacion-vs`.`periodo_entregas`
	SET
	`fecha_inicio` = inicio,
	`fecha_fin` = fin,
	`estado` = estado_periodo
	WHERE `id_periodo_entregas` = id;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ENVIAREXPEDIENTE` (IN `id_student` INT, IN `estado_exp` TINYINT)  BEGIN
	UPDATE `expedientes-graduacion-vs`.`solicitud`
	SET
	`estado` = estado_exp, 
    `hora_envio` = CONVERT_TZ(NOW(), '+00:00', '-06:00')
	WHERE `id_estudiante` = id_student;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ESTADOSOLICITUDESTUDIANTE` (IN `id_user_student` INT)  BEGIN
	SELECT solicitud.estado FROM (solicitud INNER JOIN estudiante ON solicitud.id_estudiante = estudiante.id_estudiante) INNER JOIN usuario ON usuario.id_usuario = estudiante.id_usuario
	WHERE usuario.id_usuario = id_user_student;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETCOMENTARIOINFO` (IN `id_student` INT)  BEGIN
	
    SELECT * FROM comentario_informacion
	WHERE id_estudiante = id_student 
	ORDER BY id_comentario_informacion DESC
	LIMIT 1;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETDATOSESTUDIANTE` (IN `id_student` INT)  BEGIN

	SELECT usuario.id_usuario ,estudiante.id_estudiante, usuario.nombres_usuario, usuario.apellidos_usuario, estudiante.identidad_estudiante, usuario.correo_usuario, estudiante.numero_cuenta_estudiante, estudiante.id_carrera, estudiante.estado_excelencia, estudiante.estado_informacion, estudiante.hash_correo
	FROM (estudiante INNER JOIN usuario ON estudiante.id_usuario = usuario.id_usuario)
    WHERE usuario.id_usuario = id_student;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETDOCUMENTOSINVALIDOS` (IN `id_student` INT)  BEGIN

	SELECT documento.codigo_documento, documento.estado, respuesta_documento.descripcion
	FROM ((solicitud INNER JOIN documento ON documento.id_solicitud = solicitud.id_solicitud) INNER JOIN respuesta_documento ON documento.id_documento = respuesta_documento.id_documento)
	WHERE solicitud.id_estudiante = id_student
    ORDER BY respuesta_documento.id_respuesta_documento ASC;
		
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETDOCUMENTOSSUBIDOS` (IN `id_student` INT)  BEGIN
	
    SELECT documento.id_documento, documento.link_documento, documento.codigo_documento FROM (documento INNER JOIN solicitud ON solicitud.id_solicitud = documento.id_solicitud)
	WHERE solicitud.id_estudiante = id_student;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETESTADODOCESTUDIANTE` (IN `id_student` INT)  BEGIN
	SELECT estudiante.id_estudiante, estudiante.estado_documento_descarga
	FROM (estudiante INNER JOIN usuario ON estudiante.id_usuario = usuario.id_usuario)
    WHERE usuario.id_usuario = id_student;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETESTADOSOLICITUD` (IN `id_student` INT)  BEGIN
	SELECT estado, ruta_solicitud FROM solicitud
	WHERE id_estudiante = id_student;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETESTUDIANTESSINVALIDARPAG` (IN `numero_registros` INT, IN `offset_registros` INT, IN `id_rol` INT, IN `estado_info` TINYINT)  BEGIN
	SELECT estudiante.id_estudiante, usuario.nombres_usuario, usuario.apellidos_usuario, estudiante.numero_cuenta_estudiante FROM (estudiante INNER JOIN usuario ON estudiante.id_usuario = usuario.id_usuario)
	WHERE estudiante.estado_informacion=estado_info AND estudiante.id_carrera=id_rol 
	ORDER BY estudiante.id_estudiante ASC
	LIMIT numero_registros OFFSET offset_registros;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETEXPEDIENTESINVALIDARPAG` (IN `numero_registros` INT, IN `offset_registros` INT, IN `rol_coor` INT, IN `estado_solicitud` TINYINT)  BEGIN

	SELECT estudiante.id_estudiante, usuario.nombres_usuario, usuario.apellidos_usuario, estudiante.numero_cuenta_estudiante, estudiante.estado_excelencia, solicitud.id_solicitud, solicitud.estado,solicitud.hora_envio, usuario.correo_usuario
    FROM ((usuario INNER JOIN estudiante ON usuario.id_usuario = estudiante.id_usuario) INNER JOIN solicitud ON estudiante.id_estudiante = solicitud.id_estudiante)
	WHERE solicitud.estado = estado_solicitud AND estudiante.id_carrera = rol_coor
    ORDER BY estudiante.id_estudiante ASC
	LIMIT numero_registros OFFSET offset_registros;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLINKDESCARGAESTUDIANTE` (IN `id_student` INT)  BEGIN

	SELECT link_documento FROM descargas_estudiante
	WHERE id_estudiante=id_student;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLINKDOC` (IN `doc_id` INT)  BEGIN

	SELECT link_documento FROM documento
	WHERE id_documento=doc_id;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLINKDOCESTUDIANTE` (IN `id_student` INT)  BEGIN

	SELECT * FROM documento_estudiante
    WHERE id_estudiante=id_student;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLINKSDOCUMENTOSESTUDIANTE` (IN `id_estudiante` INT)  BEGIN
	SELECT documento.id_documento ,documento.link_documento, documento.codigo_documento, documento.estado, solicitud.estado AS estado_solicitud
	FROM ((documento INNER JOIN solicitud ON documento.id_solicitud = solicitud.id_solicitud) INNER JOIN estudiante ON solicitud.id_estudiante = estudiante.id_estudiante)
	WHERE solicitud.id_estudiante = id_estudiante
	ORDER BY documento.codigo_documento ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTAUSUARIO` ()  BEGIN
	SELECT usuario.id_usuario, usuario.nombres_usuario, usuario.apellidos_usuario, usuario.correo_usuario, rol.nombre_rol, usuario.estado_usuario FROM 
		(usuario INNER JOIN rol ON usuario.id_rol = rol.id_rol AND usuario.id_rol != 7);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTCARRERAS` ()  BEGIN
	SELECT * FROM  carrera;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTCITAS` (IN `numero_registros` INT, IN `offset_registros` INT, IN `rol_coor` INT)  BEGIN

	SELECT est.id_estudiante, u_est.nombres_usuario, u_est.apellidos_usuario, est.numero_cuenta_estudiante, u_est.correo_usuario, cita.fecha_cita    
	FROM (((cita INNER JOIN estudiante AS est ON cita.id_estudiante = est.id_estudiante) INNER JOIN usuario AS u_est ON est.id_usuario = u_est.id_usuario) INNER JOIN usuario AS coord ON coord.id_usuario = cita.id_usuario)
	WHERE coord.id_rol = rol_coor
    ORDER BY cita.id_cita DESC
	LIMIT numero_registros OFFSET offset_registros;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTCITASEXCEL` (IN `rol_coor` INT, IN `fecha_buscar` VARCHAR(45))  BEGIN

	SELECT u_est.nombres_usuario, u_est.apellidos_usuario, est.numero_cuenta_estudiante, u_est.correo_usuario, cita.fecha_cita  
	FROM (((cita INNER JOIN estudiante AS est ON cita.id_estudiante = est.id_estudiante) INNER JOIN usuario AS u_est ON est.id_usuario = u_est.id_usuario) INNER JOIN usuario AS coord ON coord.id_usuario = cita.id_usuario)
	WHERE (coord.id_rol = rol_coor) AND (cita.fecha_cita LIKE fecha_buscar)
    ORDER BY cita.fecha_cita ASC;
    

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTCOMENTINFO` (IN `numero_registros` INT, IN `offset_registros` INT)  BEGIN
    SELECT 
        e.id_estudiante,
        u.nombres_usuario,
        u.apellidos_usuario,
        e.numero_cuenta_estudiante,
        ci.id_comentario_informacion,
        ci.comentario
    FROM comentario_informacion ci
    INNER JOIN estudiante e ON ci.id_estudiante = e.id_estudiante
    INNER JOIN usuario u ON e.id_usuario = u.id_usuario
    ORDER BY ci.id_comentario_informacion DESC
    LIMIT numero_registros OFFSET offset_registros;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTESTUDIANTESINDOCUMENTO` (IN `numero_registros` INT, IN `offset_registros` INT, IN `id_rol` INT, IN `estado` TINYINT)  BEGIN

	SELECT estudiante.id_estudiante, usuario.nombres_usuario, usuario.apellidos_usuario, estudiante.numero_cuenta_estudiante FROM (estudiante INNER JOIN usuario ON estudiante.id_usuario = usuario.id_usuario)
	WHERE estudiante.estado_informacion=1 AND estudiante.id_carrera=id_rol AND estudiante.estado_documento_descarga=estado
	ORDER BY estudiante.id_estudiante ASC
	LIMIT numero_registros OFFSET offset_registros;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTFECHAENTREGAS` ()  BEGIN

	SELECT * FROM periodo_entregas
	ORDER BY id_periodo_entregas DESC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTOTROSDOCUMENTOS` (IN `carrera` INT)  BEGIN

	SELECT * FROM otros_documentos
	WHERE id_Carrera = carrera;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTRESPDOC` (IN `numero_registros` INT, IN `offset_registros` INT, IN `rol_coor` INT)  BEGIN
    SELECT 
        e.id_estudiante,
        u.nombres_usuario,
        u.apellidos_usuario,
        e.numero_cuenta_estudiante,
        rd.id_respuesta_documento,
        rd.descripcion
    FROM respuesta_documento rd
    INNER JOIN documento d ON rd.id_documento = d.id_documento
    INNER JOIN solicitud s ON d.id_solicitud = s.id_solicitud
    INNER JOIN estudiante e ON s.id_estudiante = e.id_estudiante
    INNER JOIN usuario u ON e.id_usuario = u.id_usuario
    ORDER BY rd.id_respuesta_documento DESC
    LIMIT numero_registros OFFSET offset_registros;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETLISTROL` ()  BEGIN
	SELECT * FROM  rol WHERE rol.id_rol != 7;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GETMISDATOS` (IN `id_user` INT)  BEGIN

	SELECT * FROM (usuario INNER JOIN rol ON usuario.id_rol=rol.id_rol) 
	WHERE id_usuario =id_user;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GUARDARDOCUMENTO` (IN `link` VARCHAR(500), IN `solicitud` INT, IN `codigo` INT)  BEGIN

	SELECT * FROM `expedientes-graduacion-vs`.documento;INSERT INTO `expedientes-graduacion-vs`.`documento`
	(`link_documento`,
	`id_solicitud`,
	`estado`,
	`codigo_documento`)
	VALUES
	(link,
	solicitud,
	2,
	codigo);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GUARDARESTUDIANTE` (IN `nombres_new` VARCHAR(45), IN `apellidos_new` VARCHAR(45), IN `correo_new` VARCHAR(45), IN `contraseña` VARCHAR(300), IN `cuenta_new` VARCHAR(45), IN `identidad_new` VARCHAR(45), IN `excelencia_new` TINYINT, IN `carrera_new` INT, IN `hash_new` VARCHAR(45))  BEGIN

	INSERT INTO `expedientes-graduacion-vs`.`usuario`
		(`nombres_usuario`,
		`apellidos_usuario`,
		`correo_usuario`,
		`password_usuario`,
		`fecha_creacion`,
		`estado_usuario`,
		`id_rol`)
		VALUES
		(nombres_new,
		apellidos_new,
		correo_new,
		contraseña,
		now(),
		1,
		7);
        
	INSERT INTO `expedientes-graduacion-vs`.`estudiante`
		(`id_usuario`,
		`numero_cuenta_estudiante`,
		`estado_excelencia`,
		`estado_informacion`,
		`id_carrera`,
        `identidad_estudiante`,
        `hash_correo`,
        `estado_correo`,
        `estado_documento_descarga`)
		VALUES
		(LAST_INSERT_ID(),
		cuenta_new,
		excelencia_new,
		5,
		carrera_new,
        identidad_new,
        hash_new,
        2,
        1);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GUARDARLINKDESCARGAESTUDIANTE` (IN `link` VARCHAR(500), IN `id_student` INT)  BEGIN

	INSERT INTO `expedientes-graduacion-vs`.`descargas_estudiante`
	(`link_documento`,
	`id_estudiante`)
	VALUES
	(link,
	id_student);
    
    UPDATE `expedientes-graduacion-vs`.`estudiante`
	SET
	`estado_documento_descarga` = 2
	WHERE `id_estudiante` = id_student;
	
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GUARDARLINKDOCESTUDIANTE` (IN `link` VARCHAR(500), IN `id_student` INT)  BEGIN

	INSERT INTO `expedientes-graduacion-vs`.`documento_estudiante`
	(`link_documento`,
	`id_estudiante`)
	VALUES
	(link,
	id_student);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GUARDARPERIODOENTREGA` (IN `inicio` DATETIME, IN `fin` DATETIME, IN `estado_periodo` TINYINT)  BEGIN

	INSERT INTO `expedientes-graduacion-vs`.`periodo_entregas`
	(`fecha_inicio`,
	`fecha_fin`,
	`estado`)
	VALUES
	(inicio,
	fin,
	estado_periodo);


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GUARDARUSUARIO` (IN `nombres_new` VARCHAR(45), IN `apellidos_new` VARCHAR(45), IN `correo_new` VARCHAR(45), IN `contraseña` VARCHAR(300), IN `estado_new` TINYINT, IN `id_rol_new` INT)  BEGIN
	
	INSERT INTO `expedientes-graduacion-vs`.`usuario`
		(`nombres_usuario`,
		`apellidos_usuario`,
		`correo_usuario`,
		`password_usuario`,
		`fecha_creacion`,
		`estado_usuario`,
		`id_rol`)
		VALUES
		(nombres_new,
		apellidos_new,
		correo_new,
		contraseña,
		now(),
		estado_new,
		id_rol_new);

    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_HORASDEFECHA` (IN `rol_coor` INT, IN `buscador` VARCHAR(45) CHARSET utf8)  BEGIN

	SELECT cita.fecha_cita   
	FROM (((cita INNER JOIN estudiante AS est ON cita.id_estudiante = est.id_estudiante) INNER JOIN usuario AS u_est ON est.id_usuario = u_est.id_usuario) INNER JOIN usuario AS coord ON coord.id_usuario = cita.id_usuario)
	WHERE coord.id_rol = rol_coor AND cita.fecha_cita LIKE buscador
    ORDER BY cita.fecha_cita ASC;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_INGRESARHASH` (IN `id_student` INT)  BEGIN
	
    UPDATE `expedientes-graduacion-vs`.`estudiante`
	SET
	`estado_informacion` = 2

	WHERE `id_usuario` = id_student;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_INVALIDARDOCUMENTO` (IN `id_document` INT, IN `id_user` INT, IN `descripcion_doc` VARCHAR(500))  BEGIN
	UPDATE `expedientes-graduacion-vs`.`documento`
	SET
	`estado` = 3
	WHERE `id_documento` = id_document;
    
    INSERT INTO `expedientes-graduacion-vs`.`respuesta_documento`
	(`id_usuario`,
	`id_documento`,
	`descripcion`)
	VALUES
	(id_user,
	id_document,
	descripcion_doc);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_INVALIDARSOLICITUD` (IN `id_soli` INT)  BEGIN
	UPDATE `expedientes-graduacion-vs`.`solicitud`
	SET
	`estado` = 3
	WHERE `id_solicitud` = id_soli;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NUMCOMINFO` ()  BEGIN
    SELECT COUNT(*) AS comentarios
    FROM comentario_informacion;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NUMEROBSERVACIONES` ()  BEGIN
    SELECT COUNT(*) AS comentarios
    FROM respuesta_documento;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NUMEROCITAS` (IN `rol_coor` INT)  BEGIN

	SELECT count(*) as citas
	FROM (((cita INNER JOIN estudiante AS est ON cita.id_estudiante = est.id_estudiante) INNER JOIN usuario AS u_est ON est.id_usuario = u_est.id_usuario) INNER JOIN usuario AS coord ON coord.id_usuario = cita.id_usuario)
	WHERE coord.id_rol = rol_coor;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NUMEROESTUDIANTESINDOC` (IN `rol_coor` INT, IN `estado` TINYINT)  BEGIN
	SELECT COUNT(*) as estudiantes FROM estudiante 
	WHERE estudiante.estado_informacion=1 AND id_carrera=rol_coor AND estado_documento_descarga=estado;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NUMEROESTUDIANTESSINREVISAR` (IN `rol_coor` INT, IN `estado_info` TINYINT)  BEGIN
	SELECT COUNT(*) as estudiantes FROM `expedientes-graduacion-vs`.estudiante WHERE estado_informacion = estado_info AND id_carrera=rol_coor;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_NUMEROEXPEDIENTESSINREVISAR` (IN `estado_solicitud` TINYINT, IN `coor_rol` INT)  BEGIN
	SELECT count(*) as estudiantes FROM (estudiante INNER JOIN solicitud ON estudiante.id_estudiante = solicitud.id_estudiante)
	WHERE solicitud.estado = estado_solicitud AND estudiante.id_carrera = coor_rol;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OBTENERDESCRIPCIONDOCINVALIDO` (IN `id_soli` INT)  BEGIN
	SELECT respuesta_documento.id_documento, respuesta_documento.descripcion, documento.codigo_documento, documento.estado 
	FROM ((solicitud INNER JOIN documento ON solicitud.id_solicitud = documento.id_solicitud) INNER JOIN respuesta_documento ON documento.id_documento = respuesta_documento.id_documento) 
	WHERE solicitud.id_solicitud = id_soli;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OBTENERDOCSOTROS` (IN `carrera` INT)  BEGIN
	SELECT * FROM otros_documentos
	WHERE id_carrera = carrera AND estado = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OBTENERFECHACITA` (IN `id_user_student` INT)  BEGIN

	SELECT cita.fecha_cita FROM (cita INNER JOIN estudiante as est ON cita.id_estudiante = est.id_estudiante) INNER JOIN usuario as us_est ON est.id_usuario = us_est.id_usuario
	WHERE us_est.id_usuario = id_user_student;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OBTENERPERIODOENTREGA` ()  BEGIN
	SELECT * FROM `expedientes-graduacion-vs`.periodo_entregas
	WHERE estado = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OBTENERRUTASOLICITUD` (IN `id_student` INT)  BEGIN

	SELECT ruta_solicitud, id_solicitud, estado  FROM solicitud
	WHERE id_estudiante=id_student;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_OBTENERTOKEN` (IN `token_new` VARCHAR(45), IN `id` INT)  BEGIN

	SELECT * FROM token WHERE Usuario_id_usuario = id AND token = token_new;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_PASSWORD` (IN `id` INT)  BEGIN
	SELECT password_usuario FROM `expedientes-graduacion-vs`.usuario WHERE usuario.id_usuario=id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RECTIFICARINFOESTUDIANTE` (IN `id_student` INT, IN `comentario1` LONGTEXT)  BEGIN

	UPDATE estudiante
	SET estado_informacion = 3
	WHERE id_estudiante = id_student;
    
    INSERT INTO comentario_informacion
	(`comentario`,
	`id_estudiante`)
	VALUES
	(comentario1,
	id_student);
    

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAERESTUDIANTESINVALIDAR` (IN `id_student` INT)  BEGIN

	SELECT estudiante.id_estudiante, usuario.nombres_usuario, usuario.apellidos_usuario, estudiante.numero_cuenta_estudiante, estudiante.identidad_estudiante, usuario.correo_usuario, carrera.nombre_carrera, estudiante.estado_excelencia 
    FROM ((estudiante INNER JOIN usuario ON estudiante.id_usuario = usuario.id_usuario)INNER JOIN carrera ON estudiante.id_carrera = carrera.id_carrera)
	WHERE estudiante.id_estudiante=id_student;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_TRAERUSUARIO` (IN `id_user` INT)  BEGIN
	SELECT id_usuario, nombres_usuario, apellidos_usuario, correo_usuario, estado_usuario, id_rol FROM `expedientes-graduacion-vs`.usuario
	WHERE id_usuario =id_user;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_UPDATEINFOESTUDIANTE` (IN `id_user` INT, IN `name_user` VARCHAR(45), IN `apellido_user` VARCHAR(45), IN `correo_user` VARCHAR(45), IN `cuenta_student` VARCHAR(45), IN `estado_exc` TINYINT, IN `id_carrera` INT, IN `id_student` VARCHAR(45))  BEGIN

	UPDATE `expedientes-graduacion-vs`.`usuario`
	SET
	`nombres_usuario` = name_user,
	`apellidos_usuario` = apellido_user,
	`correo_usuario` = correo_user
	WHERE `id_usuario` = id_user;
    
    
    UPDATE `expedientes-graduacion-vs`.`estudiante`
	SET
	`numero_cuenta_estudiante` = cuenta_student,
	`estado_excelencia` = estado_exc,
	`estado_informacion` = 4,
	`id_carrera` = id_carrera,
	`identidad_estudiante` = id_student
	WHERE `id_usuario` = id_user;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VALIDARCITA` (IN `rol_coor` INT, IN `fecha_v` DATETIME)  BEGIN

	SELECT COUNT(*) as numero 
    FROM (((cita INNER JOIN estudiante AS est ON cita.id_estudiante = est.id_estudiante) INNER JOIN usuario AS u_est ON est.id_usuario = u_est.id_usuario) INNER JOIN usuario AS coord ON coord.id_usuario = cita.id_usuario)
	WHERE coord.id_rol = rol_coor AND fecha_cita = fecha_v;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VALIDARCORREO` (IN `correo_new` VARCHAR(45))  BEGIN
	SELECT usuario.id_usuario, usuario.nombres_usuario, usuario.apellidos_usuario, usuario.correo_usuario, usuario.password_usuario, usuario.estado_usuario, usuario.id_rol, rol.nombre_rol, modulo.id_modulo FROM usuario 
	INNER JOIN rol ON usuario.id_rol=rol.id_rol
	INNER JOIN rolxpermiso ON rol.id_rol = rolxpermiso.id_rol
	INNER JOIN modulo ON rolxpermiso.id_modulo = modulo.id_modulo
    WHERE usuario.correo_usuario = correo_new; 
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VALIDARDOCUMENTO` (IN `id_document` INT)  BEGIN

	UPDATE `expedientes-graduacion-vs`.`documento`
	SET
	`estado` = 1
	WHERE `id_documento` = id_document;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_VALIDARSOLICITUD` (IN `id_soli` INT, IN `id_student` INT, IN `id_coordinador` INT, IN `fecha` DATETIME)  BEGIN
	UPDATE `expedientes-graduacion-vs`.`solicitud`
	SET
	`estado` = 1
	WHERE `id_solicitud` = id_soli;
    
    INSERT INTO `expedientes-graduacion-vs`.`cita`
	(`fecha_creacion`,
	`fecha_cita`,
	`id_usuario`,
	`id_estudiante`)
	VALUES
	(now(),
	fecha,
	id_coordinador,
	id_student);


END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `carrera`
--
-- Creación: 22-06-2021 a las 17:43:20
--

CREATE TABLE `carrera` (
  `id_carrera` int NOT NULL,
  `nombre_carrera` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `carrera`
--

INSERT INTO `carrera` (`id_carrera`, `nombre_carrera`) VALUES
(1, 'Ingenieria Civil'),
(2, 'Ingenieria Industrial'),
(3, 'Ingenieria en Sistemas'),
(4, 'Ingenieria Electrica Industrial'),
(5, 'Ingenieria Mecanica Industrial'),
(6, 'Ingenieria Quimica Industrial');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cita`
--
-- Creación: 22-06-2021 a las 17:47:10
--

CREATE TABLE `cita` (
  `id_cita` int NOT NULL,
  `fecha_creacion` datetime NOT NULL,
  `fecha_cita` datetime NOT NULL,
  `id_usuario` int NOT NULL,
  `id_estudiante` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `cita`
--

INSERT INTO `cita` (`id_cita`, `fecha_creacion`, `fecha_cita`, `id_usuario`, `id_estudiante`) VALUES
(1, '2025-02-23 03:54:02', '2025-02-25 09:55:00', 10, 7),
(2, '2025-02-28 15:37:31', '2025-03-01 10:40:00', 10, 9),
(3, '2025-03-03 17:26:14', '2025-03-04 12:30:00', 10, 12);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `comentario_informacion`
--
-- Creación: 22-06-2021 a las 17:43:20
-- Última actualización: 03-03-2025 a las 04:03:33
-- Última revisión: 28-02-2025 a las 13:02:58
--

CREATE TABLE `comentario_informacion` (
  `id_comentario_informacion` int NOT NULL,
  `comentario` longtext NOT NULL,
  `id_estudiante` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `comentario_informacion`
--

INSERT INTO `comentario_informacion` (`id_comentario_informacion`, `comentario`, `id_estudiante`) VALUES
(6, 'Escriba su nombre completo ', 10),
(7, 'Usted no es excelencia académica', 10),
(5, 'escriba bien su nombre', 9),
(8, 'usted no es excelencia', 11),
(9, 'me confundí, si es excelencia', 11),
(10, 'su numero id está incorrecto', 12),
(11, 'escriba nombre completo', 13);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `descargas_estudiante`
--
-- Creación: 22-06-2021 a las 17:43:20
-- Última actualización: 23-02-2025 a las 03:59:08
-- Última revisión: 24-02-2025 a las 13:04:05
--

CREATE TABLE `descargas_estudiante` (
  `id_descargas_estudiante` int NOT NULL,
  `link_documento` varchar(500) NOT NULL,
  `id_estudiante` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `descargas_estudiante`
--

INSERT INTO `descargas_estudiante` (`id_descargas_estudiante`, `link_documento`, `id_estudiante`) VALUES
(1, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/ConstanciaEgresado_20101003598.pdf', 7);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento`
--
-- Creación: 22-06-2021 a las 17:48:38
--

CREATE TABLE `documento` (
  `id_documento` int NOT NULL,
  `link_documento` varchar(500) NOT NULL,
  `id_solicitud` int NOT NULL,
  `estado` tinyint NOT NULL,
  `codigo_documento` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `documento`
--

INSERT INTO `documento` (`id_documento`, `link_documento`, `id_solicitud`, `estado`, `codigo_documento`) VALUES
(77, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Constancia_verificacion_nombre.pdf', 7, 1, 1),
(78, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Copia_DNI.pdf', 7, 1, 2),
(79, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Certificado_Calificaciones.pdf', 7, 1, 3),
(80, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Constancia_Practica_Profesional.pdf', 7, 2, 5),
(81, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Constancia_VOAE.pdf', 7, 1, 4),
(82, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Solicitud_Examen_Himno_Aprobacion.pdf', 7, 1, 6),
(83, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Solicitud_Extension_Titulo.pdf', 7, 1, 7),
(84, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Copia_Titulo_Educacion_Media.pdf', 7, 1, 8),
(85, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Boleta_Pago_Carnet.pdf', 7, 2, 9),
(86, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Boleta_Tramites_Graduacion.pdf', 7, 1, 10),
(87, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Boleta_Entrega_Titulo_Ventanilla.pdf', 7, 1, 11),
(88, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Solvencia_Registro.pdf', 7, 1, 12),
(89, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Timbre_Contratacion.pdf', 7, 1, 13),
(90, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/20101003598_Fotografia_Ovalada.pdf', 7, 1, 14),
(119, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Constancia_verificacion_nombre.pdf', 12, 1, 1),
(120, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Copia_DNI.pdf', 12, 1, 2),
(121, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Certificado_Calificaciones.pdf', 12, 1, 3),
(122, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Constancia_VOAE.pdf', 12, 1, 4),
(123, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Constancia_Practica_Profesional.pdf', 12, 2, 5),
(124, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Solicitud_Examen_Himno_Aprobacion.pdf', 12, 1, 6),
(125, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Solicitud_Extension_Titulo.pdf', 12, 1, 7),
(126, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Copia_Titulo_Educacion_Media.pdf', 12, 1, 8),
(127, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Boleta_Pago_Carnet.pdf', 12, 2, 9),
(128, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Boleta_Tramites_Graduacion.pdf', 12, 1, 10),
(129, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Boleta_Entrega_Titulo_Ventanilla.pdf', 12, 1, 11),
(130, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Solvencia_Registro.pdf', 12, 3, 12),
(131, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Timbre_Contratacion.pdf', 12, 1, 13),
(132, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Fotografia_Ovalada.pdf', 12, 1, 14),
(133, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Constancia_Conducta.pdf', 12, 3, 15),
(134, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Solicitud_Honores_Academicos.pdf', 12, 1, 16),
(135, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/20161003898_Justificacion_Mencion_Honorifica.pdf', 12, 1, 17),
(136, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Constancia_verificacion_nombre.pdf', 9, 1, 1),
(137, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Copia_DNI.pdf', 9, 1, 2),
(138, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Certificado_Calificaciones.pdf', 9, 1, 3),
(139, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Constancia_VOAE.pdf', 9, 1, 4),
(140, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Constancia_Practica_Profesional.pdf', 9, 2, 5),
(141, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Solicitud_Examen_Himno_Aprobacion.pdf', 9, 1, 6),
(142, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Solicitud_Extension_Titulo.pdf', 9, 1, 7),
(143, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Copia_Titulo_Educacion_Media.pdf', 9, 1, 8),
(144, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Boleta_Pago_Carnet.pdf', 9, 2, 9),
(145, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Boleta_Tramites_Graduacion.pdf', 9, 1, 10),
(146, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Boleta_Entrega_Titulo_Ventanilla.pdf', 9, 1, 11),
(147, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Solvencia_Registro.pdf', 9, 1, 12),
(148, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Timbre_Contratacion.pdf', 9, 1, 13),
(149, 'Ingenieria_Sistemas/9_JuanHernández/20091003457_Fotografia_Ovalada.pdf', 9, 1, 14),
(150, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Constancia_verificacion_nombre.pdf', 13, 1, 1),
(151, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Copia_DNI.pdf', 13, 1, 2),
(152, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Certificado_Calificaciones.pdf', 13, 1, 3),
(153, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Constancia_VOAE.pdf', 13, 1, 4),
(154, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Constancia_Practica_Profesional.pdf', 13, 2, 5),
(155, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Solicitud_Examen_Himno_Aprobacion.pdf', 13, 1, 6),
(156, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Solicitud_Extension_Titulo.pdf', 13, 1, 7),
(157, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Copia_Titulo_Educacion_Media.pdf', 13, 1, 8),
(158, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Boleta_Pago_Carnet.pdf', 13, 2, 9),
(159, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Boleta_Tramites_Graduacion.pdf', 13, 1, 10),
(160, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Boleta_Entrega_Titulo_Ventanilla.pdf', 13, 1, 11),
(161, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Solvencia_Registro.pdf', 13, 1, 12),
(162, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Timbre_Contratacion.pdf', 13, 1, 13),
(163, 'Ingenieria_Sistemas/12_JorgeCalix/20201615478_Fotografia_Ovalada.pdf', 13, 1, 14),
(164, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Constancia_verificacion_nombre.pdf', 14, 1, 1),
(165, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Copia_DNI.pdf', 14, 1, 2),
(166, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Certificado_Calificaciones.pdf', 14, 1, 3),
(167, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Constancia_VOAE.pdf', 14, 1, 4),
(168, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Constancia_Practica_Profesional.pdf', 14, 2, 5),
(169, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Solicitud_Examen_Himno_Aprobacion.pdf', 14, 1, 6),
(170, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Solicitud_Extension_Titulo.pdf', 14, 1, 7),
(171, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Copia_Titulo_Educacion_Media.pdf', 14, 3, 8),
(172, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Boleta_Pago_Carnet.pdf', 14, 2, 9),
(173, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Boleta_Tramites_Graduacion.pdf', 14, 1, 10),
(174, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Boleta_Entrega_Titulo_Ventanilla.pdf', 14, 1, 11),
(175, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Solvencia_Registro.pdf', 14, 3, 12),
(176, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Timbre_Contratacion.pdf', 14, 1, 13),
(177, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/20181006549_Fotografia_Ovalada.pdf', 14, 1, 14),
(178, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Constancia_verificacion_nombre.pdf', 15, 1, 1),
(179, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Copia_DNI.pdf', 15, 1, 2),
(180, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Certificado_Calificaciones.pdf', 15, 1, 3),
(181, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Constancia_VOAE.pdf', 15, 3, 4),
(182, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Constancia_Practica_Profesional.pdf', 15, 2, 5),
(183, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Solicitud_Examen_Himno_Aprobacion.pdf', 15, 1, 6),
(184, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Solicitud_Extension_Titulo.pdf', 15, 1, 7),
(185, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Copia_Titulo_Educacion_Media.pdf', 15, 1, 8),
(186, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Boleta_Pago_Carnet.pdf', 15, 2, 9),
(187, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Boleta_Tramites_Graduacion.pdf', 15, 1, 10),
(188, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Boleta_Entrega_Titulo_Ventanilla.pdf', 15, 1, 11),
(189, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Solvencia_Registro.pdf', 15, 1, 12),
(190, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Timbre_Contratacion.pdf', 15, 1, 13),
(191, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Fotografia_Ovalada.pdf', 15, 1, 14),
(192, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Constancia_Conducta.pdf', 15, 1, 15),
(193, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Solicitud_Honores_Academicos.pdf', 15, 1, 16),
(194, 'Ingenieria_Sistemas/14_RosaHerrera/20012503698_Justificacion_Mencion_Honorifica.pdf', 15, 1, 17),
(195, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Constancia_verificacion_nombre.pdf', 16, 1, 1),
(196, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Copia_DNI.pdf', 16, 1, 2),
(197, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Constancia_VOAE.pdf', 16, 3, 4),
(198, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Constancia_Practica_Profesional.pdf', 16, 2, 5),
(199, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Solicitud_Examen_Himno_Aprobacion.pdf', 16, 1, 6),
(200, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Solicitud_Extension_Titulo.pdf', 16, 1, 7),
(201, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Copia_Titulo_Educacion_Media.pdf', 16, 1, 8),
(202, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Boleta_Pago_Carnet.pdf', 16, 2, 9),
(203, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Boleta_Tramites_Graduacion.pdf', 16, 1, 10),
(204, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Boleta_Entrega_Titulo_Ventanilla.pdf', 16, 1, 11),
(205, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Solvencia_Registro.pdf', 16, 1, 12),
(206, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Timbre_Contratacion.pdf', 16, 1, 13),
(207, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Fotografia_Ovalada.pdf', 16, 1, 14),
(208, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Constancia_Conducta.pdf', 16, 1, 15),
(209, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Solicitud_Honores_Academicos.pdf', 16, 1, 16),
(210, 'Ingenieria_Sistemas/15_JerryBengston/20011029541_Justificacion_Mencion_Honorifica.pdf', 16, 1, 17);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documentos_solicitud`
--
-- Creación: 22-06-2021 a las 17:43:20
--

CREATE TABLE `documentos_solicitud` (
  `id_documentos_solicitud` int NOT NULL,
  `nombre_documento` varchar(45) NOT NULL,
  `formato_documento` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento_estudiante`
--
-- Creación: 22-06-2021 a las 17:43:20
-- Última actualización: 03-03-2025 a las 20:32:35
-- Última revisión: 09-03-2025 a las 00:07:50
--

CREATE TABLE `documento_estudiante` (
  `id_documento_estudiante` int NOT NULL,
  `link_documento` varchar(500) NOT NULL,
  `id_estudiante` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `documento_estudiante`
--

INSERT INTO `documento_estudiante` (`id_documento_estudiante`, `link_documento`, `id_estudiante`) VALUES
(13, 'Ingenieria_Sistemas/12_JorgeCalix/DocsCoordinador-20201615478.docx', 12),
(4, 'Ingenieria_Sistemas/4_KennethJoannContrerasColindres/DocsCoordinador-20211020683.docx', 4),
(7, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado/DocsCoordinador-20101003598.docx', 7),
(9, 'Ingenieria_Sistemas/9_JuanHernández/DocsCoordinador-20091003457.docx', 9),
(12, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios/DocsCoordinador-20161003898.docx', 11),
(14, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios/DocsCoordinador-20181006549.docx', 13),
(15, 'Ingenieria_Sistemas/14_RosaHerrera/DocsCoordinador-20012503698.docx', 14),
(16, 'Ingenieria_Sistemas/15_JerryBengston/DocsCoordinador-20011029541.docx', 15);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estudiante`
--
-- Creación: 22-06-2021 a las 17:46:34
--

CREATE TABLE `estudiante` (
  `id_estudiante` int NOT NULL,
  `id_usuario` int NOT NULL,
  `numero_cuenta_estudiante` varchar(45) NOT NULL,
  `estado_excelencia` tinyint NOT NULL,
  `estado_informacion` tinyint NOT NULL,
  `id_carrera` int NOT NULL,
  `identidad_estudiante` varchar(45) NOT NULL,
  `hash_correo` varchar(45) NOT NULL,
  `estado_correo` tinyint NOT NULL,
  `estado_documento_descarga` tinyint NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `estudiante`
--

INSERT INTO `estudiante` (`id_estudiante`, `id_usuario`, `numero_cuenta_estudiante`, `estado_excelencia`, `estado_informacion`, `id_carrera`, `identidad_estudiante`, `hash_correo`, `estado_correo`, `estado_documento_descarga`) VALUES
(7, 18, '20101003598', 2, 1, 3, '0801199209876', 'JPfA', 2, 2),
(9, 20, '20091003457', 2, 1, 3, '0610197003214', 'iPZd', 2, 1),
(11, 22, '20161003898', 1, 1, 3, '0801199805111', 'URi9', 2, 1),
(12, 23, '20201615478', 2, 1, 3, '0123456789654', 'uUnv', 2, 1),
(13, 24, '20181006549', 2, 1, 3, '0801200001511', 'zK9Q', 2, 1),
(14, 25, '20012503698', 1, 1, 3, '0801195032140', 'x8XR', 2, 1),
(15, 26, '20011029541', 1, 1, 3, '0915196532145', 'qvpp', 2, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modulo`
--
-- Creación: 22-06-2021 a las 17:43:20
--

CREATE TABLE `modulo` (
  `id_modulo` int NOT NULL,
  `nombre_modulo` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `modulo`
--

INSERT INTO `modulo` (`id_modulo`, `nombre_modulo`) VALUES
(1, 'Administrador'),
(2, 'Coordinador'),
(3, 'Estudiante'),
(4, 'Super');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `otros_documentos`
--
-- Creación: 22-06-2021 a las 17:50:30
-- Última actualización: 23-06-2021 a las 13:48:51
--

CREATE TABLE `otros_documentos` (
  `id_otros_documentos` int NOT NULL,
  `nombre_documento` varchar(200) NOT NULL,
  `id_carrera` int NOT NULL,
  `estado` tinyint NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `periodo_entregas`
--
-- Creación: 22-06-2021 a las 17:49:39
-- Última actualización: 03-03-2025 a las 20:27:20
-- Última revisión: 09-03-2025 a las 00:06:47
--

CREATE TABLE `periodo_entregas` (
  `id_periodo_entregas` int NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime NOT NULL,
  `estado` tinyint NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `periodo_entregas`
--

INSERT INTO `periodo_entregas` (`id_periodo_entregas`, `fecha_inicio`, `fecha_fin`, `estado`) VALUES
(1, '2021-06-18 13:25:00', '2021-07-02 12:00:00', 2),
(2, '2024-12-11 08:10:00', '2025-05-03 17:10:00', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permiso`
--
-- Creación: 22-06-2021 a las 17:43:20
--

CREATE TABLE `permiso` (
  `id_permiso` int NOT NULL,
  `nombre_permiso` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `permiso`
--

INSERT INTO `permiso` (`id_permiso`, `nombre_permiso`) VALUES
(1, 'Ingenieria Civil'),
(2, 'Ingenieria Industrial'),
(3, 'Ingenieria en Sistemas'),
(4, 'Ingenieria Electrica Industrial'),
(5, 'Ingenieria Mecanica Industrial'),
(6, 'Ingenieria Quimica Industrial');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `respuesta_documento`
--
-- Creación: 22-06-2021 a las 17:49:08
--

CREATE TABLE `respuesta_documento` (
  `id_respuesta_documento` int NOT NULL,
  `id_usuario` int NOT NULL,
  `id_documento` int NOT NULL,
  `descripcion` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `respuesta_documento`
--

INSERT INTO `respuesta_documento` (`id_respuesta_documento`, `id_usuario`, `id_documento`, `descripcion`) VALUES
(8, 10, 130, 'se confundió de documento'),
(9, 10, 133, 'se confundió de documento'),
(10, 10, 171, 'no se mira bien la información'),
(11, 10, 175, 'pagó otra cosa'),
(12, 10, 181, 'Le faltan '),
(13, 10, 197, 'le faltan');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--
-- Creación: 22-06-2021 a las 17:45:34
--

CREATE TABLE `rol` (
  `id_rol` int NOT NULL,
  `nombre_rol` varchar(45) NOT NULL,
  `fecha_creacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`id_rol`, `nombre_rol`, `fecha_creacion`) VALUES
(1, 'Coordinador Ingenieria Civil', '2021-06-22 18:01:48'),
(2, 'Coordinador Ingenieria Industrial', '2021-06-22 18:01:48'),
(3, 'Coordinador Ingenieria en Sistemas', '2021-06-22 18:01:48'),
(4, 'Coordinador Ingenieria Electrica Industrial', '2021-06-22 18:01:48'),
(5, 'Coordinador Ingenieria Mecanica Industrial', '2021-06-22 18:01:48'),
(6, 'Coordinador Ingenieria Quimica Industrial', '2021-06-22 18:01:48'),
(7, 'Estudiante', '2021-06-22 18:01:48'),
(8, 'Administrador', '2021-06-22 18:01:48');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rolxpermiso`
--
-- Creación: 22-06-2021 a las 17:45:53
--

CREATE TABLE `rolxpermiso` (
  `id_permiso` int DEFAULT NULL,
  `id_rol` int NOT NULL,
  `id_modulo` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `rolxpermiso`
--

INSERT INTO `rolxpermiso` (`id_permiso`, `id_rol`, `id_modulo`) VALUES
(1, 1, 2),
(2, 2, 2),
(3, 3, 2),
(4, 4, 2),
(5, 5, 2),
(6, 6, 2),
(NULL, 7, 3),
(NULL, 8, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitud`
--
-- Creación: 03-03-2025 a las 03:32:59
--

CREATE TABLE `solicitud` (
  `id_solicitud` int NOT NULL,
  `estado` tinyint NOT NULL,
  `fecha_solicitud` datetime NOT NULL,
  `id_estudiante` int NOT NULL,
  `ruta_solicitud` varchar(500) NOT NULL,
  `hora_envio` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `solicitud`
--

INSERT INTO `solicitud` (`id_solicitud`, `estado`, `fecha_solicitud`, `id_estudiante`, `ruta_solicitud`, `hora_envio`) VALUES
(7, 1, '2025-02-23 03:48:34', 7, 'Ingenieria_Sistemas/7_ReynaIsabelPonceDoblado', NULL),
(9, 1, '2025-02-24 13:06:23', 9, 'Ingenieria_Sistemas/9_JuanHernández', NULL),
(12, 3, '2025-02-28 13:56:54', 11, 'Ingenieria_Sistemas/11_JorgeIsaacCoelloBerrios', NULL),
(13, 1, '2025-03-03 03:41:17', 12, 'Ingenieria_Sistemas/12_JorgeCalix', '2025-03-03 03:43:00'),
(14, 3, '2025-03-03 04:03:54', 13, 'Ingenieria_Sistemas/13_JasonMauricioCoelloBerrios', '2025-03-02 22:04:57'),
(15, 3, '2025-03-03 16:57:57', 14, 'Ingenieria_Sistemas/14_RosaHerrera', '2025-03-03 11:11:18'),
(16, 3, '2025-03-03 20:32:35', 15, 'Ingenieria_Sistemas/15_JerryBengston', '2025-03-03 14:53:26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `token`
--
-- Creación: 22-06-2021 a las 17:48:09
--

CREATE TABLE `token` (
  `id_token` int NOT NULL,
  `token` varchar(45) NOT NULL,
  `estado_token` tinyint NOT NULL,
  `Usuario_id_usuario` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--
-- Creación: 22-06-2021 a las 17:46:17
--

CREATE TABLE `usuario` (
  `id_usuario` int NOT NULL,
  `nombres_usuario` varchar(45) NOT NULL,
  `apellidos_usuario` varchar(45) NOT NULL,
  `correo_usuario` varchar(45) NOT NULL,
  `password_usuario` varchar(300) NOT NULL,
  `fecha_creacion` datetime NOT NULL,
  `estado_usuario` tinyint NOT NULL,
  `id_rol` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombres_usuario`, `apellidos_usuario`, `correo_usuario`, `password_usuario`, `fecha_creacion`, `estado_usuario`, `id_rol`) VALUES
(1, 'Admin', 'Admin', 'admin777@unah.edu.hn', '$2y$10$nlFaXxvEN9na4ssgi74xt.xnbd65qtp00OaaugewUE6uON0VFAxTm', '2021-06-22 18:01:48', 1, 8),
(8, 'Tulio Guadalupe', 'Martínez Green', 'tulio.martinez@unah.edu.hn', '$2y$10$koMnd3t4biUinwid5.3vo.ykpDpYgg2F1tbINhgygFHNntAA6eTDS', '2021-06-28 16:18:52', 1, 2),
(9, 'Tania Suyapa', 'Hernández Zelaya', 'tania.hernandez@unah.edu.hn', '$2y$10$FBnD.oHDjgFyIPQKiQ.RZejnHiAeZ1iYDzp02hi5s.0C2d62.fETi', '2021-06-28 17:12:38', 1, 1),
(10, 'Coordinacion ', 'IS', 'coordinacion.is@unah.edu.hn', '$2y$10$nlFaXxvEN9na4ssgi74xt.xnbd65qtp00OaaugewUE6uON0VFAxTm', '2021-06-28 19:39:57', 1, 3),
(11, 'Edwin Gustavo', 'Chavarría Fajardo', 'edwin.chavarria@unah.edu.hn', '$2y$10$2OikjWsYNRDjbhdNmOhXgeJp12YM2ffGCWfRxEr/NE23Ahqzakr.6', '2021-06-30 20:18:09', 1, 5),
(18, 'Reyna Isabel ', 'Ponce Doblado ', 'reyna.ponce@unah.hn', '$2y$10$h6L9GxSEgzrc2Je10RGK0el8Cvnwp28sfxO9NHJ8IV7.hx6SUopva', '2025-02-23 03:43:51', 1, 7),
(20, 'Juan ', 'Hernández', 'juanhhernandez@unah.hn', '$2y$10$4Dq/jE1JgTr8dX4vyo8w6.me9ggp0A.ER.PTdgkDWgHb796mtv.3y', '2025-02-24 13:02:44', 1, 7),
(22, 'Jorge Isaac', 'Coello Berrios', 'jicoello@unah.hn', '$2y$10$71Zj7Jr0QhrkcJgpgQGWE.MfQngoN0OmQssksSVxRRvXskKXECfry', '2025-02-28 13:53:59', 1, 7),
(23, 'Jorge ', 'Calix', 'jjjcalix@unah.hn', '$2y$10$49QcM8N/jFY.hN2TbNkutOhco5gFizQk.S/tppMEH86egCjbwVMH.', '2025-03-03 03:02:45', 1, 7),
(24, 'Jason Mauricio', 'Coello Berrios ', 'jasoncoello@unah.hn', '$2y$10$28FIcDW44tusyyInmwuwOegd.NmaxWt9GHNjgZIgS59lkqY2TFjTe', '2025-03-03 04:02:47', 1, 7),
(25, 'Rosa ', 'Herrera', 'chocha@unah.hn', '$2y$10$iv5nY2VpEwTdmAh9JYUceOo6n2RLmM8/9LL1D9MyZ5NUTCQ6zoahG', '2025-03-03 16:56:00', 1, 7),
(26, 'Jerry', 'Bengston', 'jerry@unah.hn', '$2y$10$5cvOSztktPfZkATl.EfdJeroOSJAptUAmvft1aEDUG.BxLAVZz7te', '2025-03-03 20:30:44', 1, 7);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `carrera`
--
ALTER TABLE `carrera`
  ADD PRIMARY KEY (`id_carrera`);

--
-- Indices de la tabla `cita`
--
ALTER TABLE `cita`
  ADD PRIMARY KEY (`id_cita`),
  ADD KEY `fk_Cita_Usuario1_idx` (`id_usuario`),
  ADD KEY `fk_Cita_Estudiante1_idx` (`id_estudiante`);

--
-- Indices de la tabla `comentario_informacion`
--
ALTER TABLE `comentario_informacion`
  ADD PRIMARY KEY (`id_comentario_informacion`),
  ADD KEY `fk_Solicitud_Estudiante1_idx` (`id_estudiante`);

--
-- Indices de la tabla `descargas_estudiante`
--
ALTER TABLE `descargas_estudiante`
  ADD PRIMARY KEY (`id_descargas_estudiante`),
  ADD KEY `fk_Descargas_Estudiante_Estudiante1_idx` (`id_estudiante`);

--
-- Indices de la tabla `documento`
--
ALTER TABLE `documento`
  ADD PRIMARY KEY (`id_documento`),
  ADD KEY `fk_Documento_Solicitud1_idx` (`id_solicitud`);

--
-- Indices de la tabla `documentos_solicitud`
--
ALTER TABLE `documentos_solicitud`
  ADD PRIMARY KEY (`id_documentos_solicitud`);

--
-- Indices de la tabla `documento_estudiante`
--
ALTER TABLE `documento_estudiante`
  ADD PRIMARY KEY (`id_documento_estudiante`),
  ADD KEY `fk_Documento_Estudiante_Estudiante1_idx` (`id_estudiante`);

--
-- Indices de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD PRIMARY KEY (`id_estudiante`),
  ADD KEY `fk_Estudiante_Carrera1_idx` (`id_carrera`),
  ADD KEY `fk_Estudiante_Usuario1_idx` (`id_usuario`);

--
-- Indices de la tabla `modulo`
--
ALTER TABLE `modulo`
  ADD PRIMARY KEY (`id_modulo`);

--
-- Indices de la tabla `otros_documentos`
--
ALTER TABLE `otros_documentos`
  ADD PRIMARY KEY (`id_otros_documentos`),
  ADD KEY `fk_Otros_Documentos_Carrera1_idx` (`id_carrera`);

--
-- Indices de la tabla `periodo_entregas`
--
ALTER TABLE `periodo_entregas`
  ADD PRIMARY KEY (`id_periodo_entregas`);

--
-- Indices de la tabla `permiso`
--
ALTER TABLE `permiso`
  ADD PRIMARY KEY (`id_permiso`);

--
-- Indices de la tabla `respuesta_documento`
--
ALTER TABLE `respuesta_documento`
  ADD PRIMARY KEY (`id_respuesta_documento`),
  ADD KEY `fk_Respuesta_Documento_Usuario1_idx` (`id_usuario`),
  ADD KEY `fk_Respuesta_Documento_Documento1_idx` (`id_documento`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `rolxpermiso`
--
ALTER TABLE `rolxpermiso`
  ADD KEY `fk_Rol_Permiso1_idx` (`id_permiso`),
  ADD KEY `fk_RolUsuarioxPermiso_Rol1_idx` (`id_rol`),
  ADD KEY `fk_RolxPermiso_Modulo1_idx` (`id_modulo`);

--
-- Indices de la tabla `solicitud`
--
ALTER TABLE `solicitud`
  ADD PRIMARY KEY (`id_solicitud`),
  ADD KEY `fk_Solicitud_Estudiante1_idx` (`id_estudiante`);

--
-- Indices de la tabla `token`
--
ALTER TABLE `token`
  ADD PRIMARY KEY (`id_token`),
  ADD KEY `fk_token_Usuario1_idx` (`Usuario_id_usuario`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `fk_Usuario_Rol1_idx` (`id_rol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `carrera`
--
ALTER TABLE `carrera`
  MODIFY `id_carrera` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `cita`
--
ALTER TABLE `cita`
  MODIFY `id_cita` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `comentario_informacion`
--
ALTER TABLE `comentario_informacion`
  MODIFY `id_comentario_informacion` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `descargas_estudiante`
--
ALTER TABLE `descargas_estudiante`
  MODIFY `id_descargas_estudiante` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `documento`
--
ALTER TABLE `documento`
  MODIFY `id_documento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=211;

--
-- AUTO_INCREMENT de la tabla `documento_estudiante`
--
ALTER TABLE `documento_estudiante`
  MODIFY `id_documento_estudiante` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `estudiante`
--
ALTER TABLE `estudiante`
  MODIFY `id_estudiante` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `modulo`
--
ALTER TABLE `modulo`
  MODIFY `id_modulo` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `otros_documentos`
--
ALTER TABLE `otros_documentos`
  MODIFY `id_otros_documentos` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `periodo_entregas`
--
ALTER TABLE `periodo_entregas`
  MODIFY `id_periodo_entregas` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `permiso`
--
ALTER TABLE `permiso`
  MODIFY `id_permiso` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `respuesta_documento`
--
ALTER TABLE `respuesta_documento`
  MODIFY `id_respuesta_documento` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `id_rol` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `solicitud`
--
ALTER TABLE `solicitud`
  MODIFY `id_solicitud` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `token`
--
ALTER TABLE `token`
  MODIFY `id_token` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cita`
--
ALTER TABLE `cita`
  ADD CONSTRAINT `fk_Cita_Estudiante1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`),
  ADD CONSTRAINT `fk_Cita_Usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `documento`
--
ALTER TABLE `documento`
  ADD CONSTRAINT `fk_Documento_Solicitud1` FOREIGN KEY (`id_solicitud`) REFERENCES `solicitud` (`id_solicitud`);

--
-- Filtros para la tabla `estudiante`
--
ALTER TABLE `estudiante`
  ADD CONSTRAINT `fk_Estudiante_Carrera1` FOREIGN KEY (`id_carrera`) REFERENCES `carrera` (`id_carrera`),
  ADD CONSTRAINT `fk_Estudiante_Usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `respuesta_documento`
--
ALTER TABLE `respuesta_documento`
  ADD CONSTRAINT `fk_Respuesta_Documento_Documento1` FOREIGN KEY (`id_documento`) REFERENCES `documento` (`id_documento`),
  ADD CONSTRAINT `fk_Respuesta_Documento_Usuario1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `rolxpermiso`
--
ALTER TABLE `rolxpermiso`
  ADD CONSTRAINT `fk_Rol_Permiso1` FOREIGN KEY (`id_permiso`) REFERENCES `permiso` (`id_permiso`),
  ADD CONSTRAINT `fk_RolUsuarioxPermiso_Rol1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`),
  ADD CONSTRAINT `fk_RolxPermiso_Modulo1` FOREIGN KEY (`id_modulo`) REFERENCES `modulo` (`id_modulo`);

--
-- Filtros para la tabla `solicitud`
--
ALTER TABLE `solicitud`
  ADD CONSTRAINT `fk_Solicitud_Estudiante1` FOREIGN KEY (`id_estudiante`) REFERENCES `estudiante` (`id_estudiante`);

--
-- Filtros para la tabla `token`
--
ALTER TABLE `token`
  ADD CONSTRAINT `fk_token_Usuario1` FOREIGN KEY (`Usuario_id_usuario`) REFERENCES `usuario` (`id_usuario`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_Usuario_Rol1` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
