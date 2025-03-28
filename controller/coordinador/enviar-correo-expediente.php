<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '../../Resources/php/Exception.php';
require '../../Resources/php/PHPMailer.php';
require '../../Resources/php/SMTP.php';

// Instantiation and passing `true` enables exceptions
$correo = $_POST["correo"];
$mensajePersonalizado = $_POST["mensaje"] ?? ''; // Mensaje opcional

// Leer la plantilla de correo
$message = file_get_contents('../../Resources/mail/mail-validacion.html');

// Procesar el mensaje personalizado
if(!empty($mensajePersonalizado)) {
    // Escapar y formatear el mensaje
    $mensajeFormateado = nl2br(htmlspecialchars($mensajePersonalizado));
    
    // Crear el bloque HTML para el mensaje personalizado
    $bloqueMensaje = '
    <div style="margin-top:20px;padding:15px;background:#f8f9fa;border-left:4px solid #dc3545;">
        <h4 style="color:#dc3545;margin-top:0;margin-bottom:10px;">Mensaje del coordinador:</h4>
        <p style="margin:0;">'.$mensajeFormateado.'</p>
    </div>';
    
    // Reemplazar el marcador en la plantilla
    $message = str_replace('{{mensaje_personalizado}}', $bloqueMensaje, $message);
} else {
    // Si no hay mensaje personalizado, eliminar el marcador
    $message = str_replace('{{mensaje_personalizado}}', '', $message);
}

$mail = new PHPMailer(true);

try {
    //Server settings
    $mail->isSMTP();                                            //Send using SMTP
    $mail->Host       = 'smtp.office365.com';                   //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                   //Enable SMTP authentication
    $mail->Username   = 'facultadingenieria@unah.edu.hn';       //SMTP username
    $mail->Password   = 'UGwBCc*gJL';                           //SMTP password
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;         //Enable TLS encryption
    $mail->Port       = 587;                                    //TCP port to connect to

    //Recipients
    $mail->setFrom('facultadingenieria@unah.edu.hn', utf8_decode('Sistema de Gestión de Expedientes de Graduación'));
    $mail->addAddress($correo);                                 //Name is optional

    //Content
    $mail->isHTML(true);                                        //Set email format to HTML
    $mail->Subject = utf8_decode('Estado Expediente');
    $mail->AddEmbeddedImage('../../Resources/icon/Ingenieria.png', 'imagen');
    $mail->Body    = utf8_decode($message);

    $mail->send();
    echo 'El correo ha sido enviado';
} catch (Exception $e) {
    echo "Message could not be sent. Mailer Error: {$mail->ErrorInfo}";
}
?>