<?php

include("../../Resources/lib/connection.php");
include("../../Resources/config.php");

header('Content-Type: application/json');

$response = [
    'success' => false,
    'message' => 'Error desconocido'
];

// Habilitar la visualización de errores en PHP
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Verificar la conexión a la base de datos
if (!$connection) {
    die(json_encode(['success' => false, 'message' => 'Error en la conexión a la base de datos: ' . mysqli_connect_error()]));
}

// Verificar si todos los campos requeridos están presentes
if (
    empty($_POST["id"]) || empty($_POST["cuenta"]) || empty($_FILES["file"]) || 
    empty($_POST["ruta"]) || empty($_POST["codigo"]) || empty($_POST["extension"]) || 
    empty($_POST["id_solicitud"])
) {
    die(json_encode(['success' => false, 'message' => 'Faltan datos requeridos']));
}

$id = $_POST["id"];
$id_solicitud = $_POST["id_solicitud"];
$cuenta = $_POST["cuenta"];
$documento = $_FILES["file"];
$ruta = $_POST["ruta"];
$codigo = $_POST["codigo"];
$extension = $_POST["extension"];

// Asignar el nombre del archivo según el código del documento
$documentos = [
    "1" => "_Constancia_verificacion_nombre",
    "2" => "_Copia_DNI",
    "3" => "_Certificado_Calificaciones",
    "4" => "_Constancia_VOAE",
    "5" => "_Constancia_Practica_Profesional",
    "6" => "_Solicitud_Examen_Himno_Aprobacion",
    "7" => "_Solicitud_Extension_Titulo",
    "8" => "_Copia_Titulo_Educacion_Media",
    "9" => "_Boleta_Pago_Carnet",
    "10" => "_Boleta_Tramites_Graduacion",
    "11" => "_Boleta_Entrega_Titulo_Ventanilla",
    "12" => "_Solvencia_Registro",
    "13" => "_Timbre_Contratacion",
    "14" => "_Fotografia_Ovalada",
    "15" => "_Constancia_Conducta",
    "16" => "_Solicitud_Honores_Academicos",
    "17" => "_Justificacion_Mencion_Honorifica"
];

if (!isset($documentos[$codigo])) {
    die(json_encode(['success' => false, 'message' => 'Código de documento inválido']));
}

$nombre_archivo = '/' . $cuenta . $documentos[$codigo] . '.' . $extension;
$ruta_final = $BASEPATHEXPEDIENTES . $ruta . $nombre_archivo;
$ruta_final_base = $ruta . $nombre_archivo;

// Verificar si el archivo tiene errores
if ($documento['error'] !== 0) {
    die(json_encode(['success' => false, 'message' => 'Error al subir el archivo']));
}

// Si el archivo ya existe, eliminarlo antes de subir el nuevo
if (file_exists($ruta_final)) {
    unlink($ruta_final);
} else {
    // Insertar en la base de datos solo si es la primera vez que se sube
    $sp = "CALL SP_GUARDARDOCUMENTO('$ruta_final_base', '$id_solicitud', '$codigo');";
    $query = mysqli_query($connection, $sp);

    if (!$query) {
        die(json_encode(['success' => false, 'message' => 'Error en la base de datos: ' . mysqli_error($connection)]));
    }
}

// Subir el archivo al servidor
if (!move_uploaded_file($documento["tmp_name"], $ruta_final)) {
    die(json_encode(['success' => false, 'message' => 'Error al mover el archivo. Verifica permisos y ruta.']));
}

@chmod($ruta_final, 0777);

$response['success'] = true;
$response['message'] = 'Archivo subido con éxito';

cerrarConexion($connection);

echo json_encode($response);
?>
