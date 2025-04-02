<?php
    session_start();
    // Check user login or not
    if(!isset($_SESSION['id_user'])){
        header('Location: ../../index.php');
    } 
    if(strcmp($_SESSION['modulo'],'3') !== 0){
        header('Location: ../../index.php');
    } 
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Estado Expediente</title>
    <link rel="stylesheet" href="../../Resources/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../Resources/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" href="../../Resources/css/simple-sidebar.css">
    <link rel="stylesheet" href="../../Resources/css/toastr.css" />
    <link rel="stylesheet" href="../../Resources/css/mis-estilos.css">
    <style> 
        @font-face {
        font-family: helvica;
        src: url(../../Resources/fonts/helvica.ttf);
        }
    </style>
</head>
<body>

    
    <div class="d-flex" id="wrapper">
        <!---------------------------SIDEBAR ---------------------------------------->
        <div class="border-right color-bnav" id="sidebar-wrapper">


            <!-----------------------------ENCABEZADO DEL SIDEBAR-------------------->
            <input type="hidden" id="id-user-session" id-student='<?php echo $_SESSION['id_user'] ?>'>
            <div class="sidebar-heading text-center">
                <img src="../../Resources/icon/ingenieria2.png" width="125" height="125" class="mt-2 mb-3 sombra-corta2 rounded-circle">
                <p class="lead text-light" > <small style='font-family:helvica;'>Estudiante</small><br>
                <small>
                    <?php
                        echo explode(' ',$_SESSION['nombres'])[0].' '. explode(' ',$_SESSION['apellidos'])[0];
                    ?>
                </small>
                </p>
            </div>
            <!-----------------------------FINAL ENCABEZADO DEL SIDEBAR-------------------->
            <div class="container">
                <div class="row" style='background-color: #182B52  ;'>
                    <div class="col text-center ">
                        <small class='lead text-light ' style='font-family:helvica;'>  Menu </small>
                    </div>
                </div>
            </div>
            <!-----------------------------CONTENIDO DEL SIDEBAR-------------------->
            <div class="container sidebar-content  py-3 " style='background-color:#000e2bb0 '>
            
            <div class="row text-center">
                    <div class="col-1"></div>
                        <div class="pt-1 pb-2 mb-2  text-white text-center col-9" style='border-radius: 5px; background-color: #184e77'> 
                            <div class="row">
                                <div class="col">
                                    <small > <strong> 1.Mis datos </strong></small> 
                                </div>   
                            </div>
                            <div class="row">
                                <div class="col">
                                    <a href="estado-informacion.php" class="btn btn-warning naranja m-2 col-11 sombra-corta3 btn-sm" role="button" style='border-radius: 5px;'> <small><strong>Ir</strong> </small></a>
                                </div>
                            </div> 
                        </div>
                    <div class="col-1"></div>
                </div>
                <div class="row text-center">
                    <div class="col-1"></div>
                        <div class="pt-1 pb-2 mb-2 text-white text-center col-9" style='border-radius: 5px;  background-color: #1e6091'> 
                            <div class="row">
                                <div class="col">
                                    <small > <strong> 2.Creación Expediente </strong></small> 
                                </div>   
                            </div>
                            <div class="row">
                                <div class="col">
                                <a href="creacion-expediente.php" class="btn btn-warning naranja m-2 col-11 btn-sm sombra-corta3" role="button" id='crear-exp' style='border-radius: 5px;'> <small><strong>Ir</strong> </small></a>
                                </div>
                            </div> 
                        </div>
                    <div class="col-1"></div>
                </div>
                <div class="row text-center">
                    <div class="col-1"></div>
                        <div class="pt-1 pb-2 mb-2 text-white text-center col-9" style='border-radius: 5px; background-color: #1a759f '> 
                            <div class="row">
                                <div class="col">
                                    <small > <strong> 3.Estado Expediente </strong></small> 
                                </div>   
                            </div>
                            <div class="row">
                                <div class="col">
                                    <a href="#" class="btn btn-warning naranja m-2 col-11 sombra-corta3 btn-sm" id='estado-exp' role="button" style='border-radius: 5px;'> <small><strong>Ir</strong> </small></a>                                   
                                </div>
                            </div> 
                        </div>
                    <div class="col-1"></div>
                </div>
                <div class="row text-center">
                    <div class="col-1"></div>
                        <div class="pt-1 pb-1 mb-2 text-white text-center col-9" style='border-radius: 5px; background-color: #168aad'> 
                            <div class="row">
                                <div class="col">
                                    <small > <strong> 4.Fecha Cita</strong></small> 
                                </div>   
                            </div>
                            <div class="row">
                                <div class="col">
                                    <a href="cita.php" class="btn btn-warning naranja m-2 col-11 sombra-corta3 btn-sm disabled" id='cita-estudiante' role="button" style='border-radius: 5px;'> <small><strong>Ir</strong> </small></a>
                                </div>
                            </div> 
                        </div>
                    <div class="col-1"></div>
                </div>
                <div class="row text-center">
                    <div class="col-1"></div>
                        <div class="pt-1 pb-1 mb-2 text-white text-center col-9" style='border-radius: 5px; background-color: #168aad'> 
                            <div class="row">
                                <div class="col">
                                    <small > <strong> 5.Descarga Constancia</strong></small> 
                                </div>   
                            </div>
                            <div class="row">
                                <div class="col">
                                    <a href="descarga-constancia.php" class="btn btn-warning naranja m-2 col-11 sombra-corta3 btn-sm disabled" id='descarga' role="button" style='border-radius: 5px;'> <small><strong>Ir</strong> </small></a>
                                </div>
                            </div> 
                        </div>
                    <div class="col-1"></div>
                </div>
                
                
                
                
                
                
            </div>
            
            <!-----------------------------FINAL DEL CONTENIDO DEL SIDEBAR-------------------->
            <div class="row "  style='position: fixed; bottom:0px; width: 14.9rem;'>
                <div class="col">
                    <a role="button" href="../../log-out.php" class="btn btn-danger col-12 py-1 btn-salir">
                        <svg xmlns="../../Resources/icon/back.svg" width="22" height="22" fill="currentColor" class="bi bi-box-arrow-left" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" d="M6 12.5a.5.5 0 0 0 .5.5h8a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-8a.5.5 0 0 0-.5.5v2a.5.5 0 0 1-1 0v-2A1.5 1.5 0 0 1 6.5 2h8A1.5 1.5 0 0 1 16 3.5v9a1.5 1.5 0 0 1-1.5 1.5h-8A1.5 1.5 0 0 1 5 12.5v-2a.5.5 0 0 1 1 0v2z"/>
                            <path fill-rule="evenodd" d="M.146 8.354a.5.5 0 0 1 0-.708l3-3a.5.5 0 1 1 .708.708L1.707 7.5H10.5a.5.5 0 0 1 0 1H1.707l2.147 2.146a.5.5 0 0 1-.708.708l-3-3z"/>
                        </svg>
                        <small> Salir </small>
                    </a>
                </div>
            </div>
        </div>
        <!-----------------------------FINAL DEL SIDEBAR-------------------->
        
        
        <!-----------------------------CONTENIDO DE LA PAGINA-------------------->
        <div id="page-content-wrapper">
            <!-----------------------------NAVBAR PARA EL TOGGLE DEL MENU (SOLO DISPOSITIVOS)-------------------->
            <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom " >
                <button class="btn btn-primary color-bnav " id="menu-toggle" style='font-family:helvica; border-radius: 5px;'>
                    <svg xmlns="../../Resources/icon/list.svg" width="16" height="16" fill="currentColor" class="bi bi-list" viewBox="0 0 16 16">
                        <path fill-rule="evenodd" d="M2.5 11.5A.5.5 0 0 1 3 11h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4A.5.5 0 0 1 3 7h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5zm0-4A.5.5 0 0 1 3 3h10a.5.5 0 0 1 0 1H3a.5.5 0 0 1-.5-.5z"/>
                    </svg>
                     Menu
                </button>
                
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
                        <li class="nav-item active">
                            <h>Sistema de Gestión de Expedientes de Graduación</h4>
                        </li>
                        
                    </ul>
                    <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
                        <li class="nav-item active">
                            <a href="../../controller/estudiante/descarga-manual.php" class="btn btn-info btn-sm redondear" role="button">Descargar Manual de Usuario</a>
                        </li>
                        
                    </ul>
                </div>
            </nav>
            <nav class="text-center text-muted" style="background-color: #E8EEF4; ">
                <svg xmlns="/Resources/icon/warn.svg" width="15" height="15" fill="currentColor" class="bi bi-exclamation-triangle" viewBox="0 0 16 16" style="fill:#ff873f;">
                    <path d="M7.938 2.016A.13.13 0 0 1 8.002 2a.13.13 0 0 1 .063.016.146.146 0 0 1 .054.057l6.857 11.667c.036.06.035.124.002.183a.163.163 0 0 1-.054.06.116.116 0 0 1-.066.017H1.146a.115.115 0 0 1-.066-.017.163.163 0 0 1-.054-.06.176.176 0 0 1 .002-.183L7.884 2.073a.147.147 0 0 1 .054-.057zm1.044-.45a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566z"/>
                    <path d="M7.002 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 5.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995z"/>
                </svg>
                
                    <?php
                        include("../../Resources/lib/connection.php");
                        date_default_timezone_set("America/Tegucigalpa");

                        $sp = "call SP_OBTENERPERIODOENTREGA();";
                        $query = mysqli_query($connection, $sp);
                        $contador = mysqli_num_rows($query);

                        if($contador >= 1) {
                            
                            while($row = mysqli_fetch_array($query)){
                                $inicio = $row["fecha_inicio"];
                                $fin = $row["fecha_fin"];
                            }

                            $fecha_inicio = strtotime($inicio);
                            $fecha_fin = strtotime($fin);
                            
                            $hoy = strtotime(date("Y-m-d H:i:00",time()));

                            
                            if ( $fecha_inicio < $hoy && $hoy < $fecha_fin ){
                                echo "Tiene desde el $inicio hasta el $fin (GMT-6), para gestionar su expediente, después de esas fechas no podrá seguir gestionando su expediente.";
                            } else {
                                echo "Actualmente no se están gestionando expedientes de graduación. Podrá continuar con la gestión de su expediente cuando se inicie un nuevo periodo de recepción de expedientes.";
                                die();
                                
                            }

                        }else {
                            echo "Actualmente no se están gestionando expedientes de graduación. Podrá continuar con la gestión de su expediente cuando se inicie un nuevo periodo de recepción de expedientes.";
                            die();
                            
                        }

                    ?>
                
                <svg xmlns="/Resources/icon/warn.svg" width="15" height="15" fill="currentColor" class="bi bi-exclamation-triangle" viewBox="0 0 16 16" style="fill:#ff873f;">
                    <path d="M7.938 2.016A.13.13 0 0 1 8.002 2a.13.13 0 0 1 .063.016.146.146 0 0 1 .054.057l6.857 11.667c.036.06.035.124.002.183a.163.163 0 0 1-.054.06.116.116 0 0 1-.066.017H1.146a.115.115 0 0 1-.066-.017.163.163 0 0 1-.054-.06.176.176 0 0 1 .002-.183L7.884 2.073a.147.147 0 0 1 .054-.057zm1.044-.45a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566z"/>
                    <path d="M7.002 12a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 5.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995z"/>
                </svg>
            </nav>


            <!-----------------------------FIN NAVBAR PARA EL TOGGLE DEL MENU------------------------------------>

            <!-----------------------------------------------CONTENIDO----------------------------------->
            
            <div class="container px-4 centrar" >
                <div class="container pt-3 pb-1 mt-4 mb-4 fadeInDown sombra redondear" style="background-color: #E8EEF4; ">


                    <input type="text" id="id-estudiante" placeholder="" class="form-control" hidden>
                    <input type="text" id="cuenta-estudiante" placeholder="" class="form-control" hidden>

                    <div class="row  align-items-end">
                        <div class="col-1"></div>
                        <div class="col-10">
                            <div class="row">
                                <div class="col">
                                    <h3>Estado Expediente:</h3>
                                </div>
                                <div class="col">
                                    <h3 class='float-right text-muted' > <strong id='text-estado-expediente'> Sin Revisar </strong></h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-1"></div>
                    </div>

                    <div class="row align-items-end pt-2">
                        <div class="col-1"></div>
                        <div class="col-10">
                            <h3 class="bg-dark text-center " style="border-radius: 5px;"> <p style="color:white;">Documentos Necesarios</p></h3>
                        </div>
                        <div class="col-1"></div>
                    </div>

                    <div class="row pt-2">
                        <div class="col text-center">
                            <div class="table-responsive">
                                
                                <table class="table table-hover table-striped text-center align-self-center table-light" id="example">
                                        
                                        <thead class="thead-dark">
                                            <tr>
                                                <th scope="col">Nombre Documento y Formato</th>
                                                <th scope="col">Estado</th>
                                                <th scope="col">Descripción</th>
                                                <th scope="col"></th>
                                                <th scope="col">Enlace Subida</th>
                                                <th scope="col">Subir</th>
                                                

                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr codigo='1'>
                                                <td> <small> Constancia de Verificación de Nombre <br> (.pdf) </small></td>
                                                <td>
                                                    <span id='sub-doc-1' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-1' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-1' hidden>Subir</button>
                                                </td>
                                                
                                            </tr>
                                            <tr codigo='2'>
                                                <td> <small>Copia de DNI <br>Ambos lados<br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-2' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-2' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-2' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='3'>
                                                <td> <small>Certificado de Calificaciones <br> (Original) <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-3' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-3' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-3' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='4'>
                                                <td> <small> Constancia de Horas Artículo 140 <br>VOAE <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-4' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-4' disabled>Ver Comentarios</button>
                                                </td>
                                               <td>
                                                    <button class="btn btn-info btn-sm" data-toggle="modal" data-target="#agregar-documento">Generar Documento</button>
                                               </td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-4' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='5' hidden>
                                                <td> <small>  Constancia de Práctica Profesional <br>(.pdf) </small></td>
                                                <td>
                                                    <span id='sub-doc-5' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-5' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-5' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='6'>
                                                <td> <small> Solicitud de Realización del Himno y su Aprobación <br>(.pdf)</small></td>
                                                <td>
                                                    <span id='sub-doc-6' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-6' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-6' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='7'>
                                                <td> <small>Solicitud de Extensión de Título <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-7' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-7' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-7' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='8'>
                                                <td> <small>Copia de Título de Educación Media <br>Ambos lados <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-8' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-8' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-8' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='9' hidden>
                                                <td> <small>Boleta de Pago de Carnet de Estudiante <br> L.30.00 <br>(.pdf)</small></td>
                                                <td>
                                                    <span id='sub-doc-9' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-9' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-9' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='10'>
                                                <td> <small> Boleta de Pago de Trámites de Graduación <br> L.4,000.00 <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-10' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-10' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-10' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='11'>
                                                <td> <small> Boleta de Pago dde Enrega de Título por Ventanilla <br> L.2,500.00 <br>(.pdf)</small></td>
                                                <td>
                                                    <span id='sub-doc-11' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-11' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-11' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='12'>
                                                <td> <small>Solvencia de Registro <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-12' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-12' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-12' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='13'>
                                                <td> <small>Timbre de Contratación L. 100 <br> Banco de Occidente <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-13' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-13' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-13' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            <tr codigo='14'>
                                                <td> <small>Fotografía Ovalada (1) <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-14' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-14' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-14' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            </tr>
                                            <tr codigo='15' class='docs-excelencia'>
                                                <td> <small>Solicitud de Honores Académicos y Justificación por Estudiante <br>(.pdf)</small> </td>
                                                <td>
                                                    <span id='sub-doc-15' class="badge badge-secondary">Sin revisar</span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm ver-comentarios" id='ver-comentarios-15' disabled>Ver Comentarios</button>
                                                </td>
                                                <td></td>
                                                <td class='doc-estudiante'>
                                                    <input type="file" class="form-control-file doc" aria-describedby="fileHelp">
                                                </td>
                                                <td>
                                                    <button class="btn btn-info btn-sm subir" id='btn-subir-15' hidden>Subir</button>
                                                </td>
                                            </tr>
                                            
                                        </tbody>
                                </table>
                                

                            </div>    
                        </div>
                    </div>

                    <div class="row pb-3">
                        <div class="col-4"></div>
                        <div class="col-4">
                            <button type="button" style='border-radius: 5px;' class="btn btn-sm btn-success float-right add-user mt-3 mb-2 sombra-corta3 btn-block" id='enviar' disabled>Enviar Todo</button>          
                        </div>
                        <div class="col-4"></div>
                    
                    </div>
                    <div class="row">
                        <div class="col-1"></div>
                        <div class="col-10">
                            <p class='text-center'><small class='text-muted'>Una vez todos los documentos sean subidos, se habilitará el botón para enviar todos los documentos para que el coordinador de su carrera 
                            pueda validar el estado de estos.</small></p>
                        </div>
                        <div class="col-1"></div>
                </div>

                </div>
            </div>
            <!-----------------------------FINAL CONTENIDO------------------------------>
    </div>
    <!-----------------------------FINAL CONTENIDO DE LA PAGINA-------------------->

    <!----------------------MODAL PARA LOS ESTUDIANTES CON DATOS SIN VALIDAR AUN---------------------->
    <div class="modal fade modal-usuario" id="expediente-sinaprobar">
        <div class="modal-dialog">
            <div class="modal-content">
        
                <!-- Modal Header -->
                <div class="modal-header">
                <h4 class="modal-title" >ESTADO DE SU EXPEDIENTE: <div class='text-muted'> <strong> Sin Revisar </strong></div></h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
        
                <!-- Modal body -->
                <div class="modal-body">
                    <p>Actualmente su expediente se encuentra en estado sin revisar, lo que quiere decir que el coordinador aun no ha revisado sus documentos, se espera 
                    que su expediente se pueda validar lo mas antes posible</p>
                </div>
        
                <!-- Modal footer -->
                <div class="modal-footer">

                <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">Ok</button>
                </div>
        
            </div>
        </div>
    </div>
    <!----------------------FIN DE MODAL PARA LOS ESTUDIANTES CON DATOS SIN VALIDAR AUN---------------------->



    <!----------------------MODAL PARA LOS ESTUDIANTES CON DATOS APROBADO---------------------->
    <div class="modal fade modal-usuario" id="expediente-aprobado">
        <div class="modal-dialog">
            <div class="modal-content">
        
                <!-- Modal Header -->
                <div class="modal-header">
                <h4 class="modal-title" >ESTADO DE SU EXPEDIENTE: <div class='text-success'> <strong>Aprobado </strong> </div></h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
        
                <!-- Modal body -->
                <div class="modal-body">
                    <p>Su Expediente ha sido aprobada, ya puede acceder a ver la fecha de su cita para ir a dejar la documentación de manera presencial</p>
                </div>
        
                <!-- Modal footer -->
                <div class="modal-footer">

                <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">Ok</button>
                </div>
        
            </div>
        </div>
    </div>
    <!----------------------FIN DE MODAL PARA LOS ESTUDIANTES CON DATOS APROBADO---------------------->

    <!----------------------MODAL PARA LOS ESTUDIANTES CON DATOS NO APROBADO---------------------->
    <div class="modal fade modal-usuario" id="expediente-noaprobado">
        <div class="modal-dialog">
            <div class="modal-content">
        
                <!-- Modal Header -->
                <div class="modal-header">
                <h4 class="modal-title" >ESTADO DE SU EXPEDIENTE: <div class='text-danger'> <strong>No Aprobado</strong> </div></h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
        
                <!-- Modal body -->
                <div class="modal-body">
                    <p>Su expediente no ha sido aprobado, al aparecer algunos documentos presentan algún tipo de inconsistencia, en la caja de descripción se 
                    especifica a detalle el por que el documento no ha sido aprobado, se habilitará el botón de subida para que pueda subir de nuevo el documento, con 
                    los respectivos cambios pertinentes.</p>
                </div>
        
                <!-- Modal footer -->
                <div class="modal-footer">

                <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">Ok</button>
                </div>
        
            </div>
        </div>
    </div>
    <!----------------------FIN DE MODAL PARA LOS ESTUDIANTES CON DATOS NO APROBADO---------------------->

    <!----------------------MODAL PARA VER LOS COMENTARIOS DE LOS DOCUMENTOS---------------------->
    <div class="modal fade" id="comentariosModal" tabindex="-1" aria-labelledby="comentariosModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="comentariosModalLabel" style="font-weight: bold;">Comentarios del Documento</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <table class="table table-striped table-hover table-bordered">
                        <thead class="thead-dark">
                            <tr>
                                <th scope="col" class="text-center">Código del Documento</th>
                                <th scope="col" class="text-center">Comentarios</th>
                            </tr>
                        </thead>
                        <tbody id="modalComentariosBody">
                            <!-- Aquí se mostrarán los comentarios en filas de la tabla -->
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                </div>
            </div>
        </div>
    </div>
    <style>
       /* Estilos para la tabla */
        .table {
            width: 100%;
            margin-bottom: 1rem;
            color: #333;
        }

        .table thead th {
            background-color: #182B52; /* Fondo claro para el encabezado */
            color: #333; /* Texto oscuro */
            font-weight: bold;
            color: white
        }

        .table-striped tbody tr:nth-of-type(odd) {
            background-color: rgba(0, 0, 0, 0.05); /* Filas alternas con fondo claro */
        }

        .table-hover tbody tr:hover {
            background-color: rgba(0, 0, 0, 0.075); /* Efecto hover en las filas */
        }

        .table-bordered {
            border: 1px solid #dee2e6; /* Borde para la tabla */
        }

        .table-bordered th,
        .table-bordered td {
            border: 1px solid #dee2e6; /* Borde para las celdas */
        }

        /* Estilos para la modal */
        .modal-header {
            background-color: #f8f9fa; /* Fondo claro para el encabezado de la modal */
            border-bottom: 1px solid #dee2e6; /* Línea divisoria en el encabezado */
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            border-top: 1px solid #dee2e6; /* Línea divisoria en el pie de la modal */
        }
    </style>
    <!----------------------FIN DE MODAL PARA VER LOS COMENTARIOS DE LOS DOCUMENTOS---------------------->
    
    <!------------------------------------MODAL PARA SUBIR HORAS ART. 140--------------------------------->
    <div class="modal fade" id="agregar-documento" tabindex="-1" aria-labelledby="activityModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="activityModalLabel" style="color: blue; font-weight: bold;">Registro de Actividades de Artículo 140 (VOAE)</h5>
                    <button type="button" class="btn-close" data-dismiss="modal" aria-label="Close"></button>
                </div>
                <div style="padding-left: 3vw; padding-right: 3vw;">
                    <br><b style="color: red;">NOTA: Primero debe seleccionar la casilla del ámbito, para indicar que tipo de Actividad está subiendo y de esta forma indicará la cantidad de Horas que tiene la misma.</b>
                </div>
                <div class="modal-body">
                    <form id="activityForm" method="POST" enctype="multipart/form-data">
                        <!-- Contenedor de archivos -->
                        <div id="fileContainer"></div>

                        <div class="mb-3">
                            <button type="button" class="btn btn-primary" id="addFileButton">Agregar Más Archivos PDF</button>
                        </div>

                        <!-- Resumen -->
                        <div id="summary" class="mt-3">
                            <h6>Resumen</h6>
                            <input type="number" class="form-control" id="total" placeholder="Total" readonly>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
                            <button type="button" id="downloadPdfButton" class="btn btn-warning">Descargar PDF Combinado</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery y Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <!-- PDF-Lib para combinar PDFs -->
    <script src="https://cdn.jsdelivr.net/npm/pdf-lib/dist/pdf-lib.min.js"></script>

    <script>
       let fileIndex = 0;

        // Función para agregar un nuevo formulario de archivo PDF
        function addFileForm() {
            const fileContainer = document.getElementById('fileContainer');
            
            const fileForm = document.createElement('div');
            fileForm.classList.add('mb-3');
            fileForm.setAttribute('id', `fileForm-${fileIndex}`);
            
            // Contenedor para nombre de la actividad y archivo PDF
            const activityNameAndFileContainer = `
                <div class="d-flex align-items-center">
                    <!-- Input para el nombre de la actividad -->
                    <div class="flex-grow-1">
                        <label for="activityName-${fileIndex}" class="form-label">Nombre de Actividad</label>
                        <input type="text" id="activityName-${fileIndex}" name="activityName" class="form-control" placeholder="Nombre de actividad" required>
                    </div>
                    
                    <!-- Input para el archivo PDF -->
                    <div class="ms-3">
                        <label for="activityPdf-${fileIndex}" class="form-label">Subir PDF</label>
                        <input type="file" id="activityPdf-${fileIndex}" name="activityPdf[]" class="form-control" accept=".pdf">
                    </div>
                </div>
            `;

            // Checkboxes y horas
            const hoursInput = `
                <div class="mb-3">
                <br>
                    <label class="form-label" style="font-weight: bold; font-size: 150"><u>Ámbitos</u></label>
                    <div class="form-check">
                        <label class="form-check-label">
                            <input type="checkbox" class="form-check-input" id="academicasCheckbox-${fileIndex}" onchange="sumarValores(${fileIndex})"> Científico - Académicas
                        </label>
                        <input type="number" class="form-control form-control-sm ms-2 valor" id="academicasInput-${fileIndex}" placeholder=" Científico - Académicas" min="0" oninput="sumarValores(${fileIndex})">
                    </div>
                    <div class="form-check">
                        <label class="form-check-label">
                            <input type="checkbox" class="form-check-input" id="socialesCheckbox-${fileIndex}" onchange="sumarValores(${fileIndex})"> Sociales
                        </label>
                        <input type="number" class="form-control form-control-sm ms-2 valor" id="socialesInput-${fileIndex}" placeholder=" Sociales" min="0" oninput="sumarValores(${fileIndex})">
                    </div>
                    <div class="form-check">
                        <label class="form-check-label">
                            <input type="checkbox" class="form-check-input" id="culturalesCheckbox-${fileIndex}" onchange="sumarValores(${fileIndex})"> Culturales
                        </label>
                        <input type="number" class="form-control form-control-sm ms-2 valor" id="culturalesInput-${fileIndex}" placeholder=" Culturales" min="0" oninput="sumarValores(${fileIndex})">
                    </div>
                    <div class="form-check">
                        <label class="form-check-label">
                            <input type="checkbox" class="form-check-input" id="deportivasCheckbox-${fileIndex}" onchange="sumarValores(${fileIndex})"> Deportivas
                        </label>
                        <input type="number" class="form-control form-control-sm ms-2 valor" id="deportivasInput-${fileIndex}" placeholder=" Deportivas" min="0" oninput="sumarValores(${fileIndex})">
                    </div>
                </div>
            `;

            // Incluir todo el formulario
            fileForm.innerHTML = activityNameAndFileContainer + hoursInput;
            fileContainer.appendChild(fileForm);
            
            fileIndex++;
        }

        // Función para sumar los valores de horas
        function sumarValores(index) {
            const academicas = document.getElementById(`academicasInput-${index}`).value || 0;
            const sociales = document.getElementById(`socialesInput-${index}`).value || 0;
            const culturales = document.getElementById(`culturalesInput-${index}`).value || 0;
            const deportivas = document.getElementById(`deportivasInput-${index}`).value || 0;

            const total = 
                (document.getElementById(`academicasCheckbox-${index}`).checked ? parseInt(academicas) : 0) +
                (document.getElementById(`socialesCheckbox-${index}`).checked ? parseInt(sociales) : 0) +
                (document.getElementById(`culturalesCheckbox-${index}`).checked ? parseInt(culturales) : 0) +
                (document.getElementById(`deportivasCheckbox-${index}`).checked ? parseInt(deportivas) : 0);

            document.getElementById('total').value = total;
        }

        // Función para combinar los PDFs y generar el PDF final
        document.getElementById('downloadPdfButton').addEventListener('click', async () => {
        const { PDFDocument, rgb } = PDFLib;
        const pdfDoc = await PDFDocument.create();
        const font = await pdfDoc.embedFont(PDFLib.StandardFonts.Helvetica);

        let totalHoras = 0; // Variable para acumular el total de horas
        let hasUploadedFiles = false; // Variable para verificar si se ha subido al menos un archivo

        // Obtener todos los formularios de archivo
        const fileForms = document.querySelectorAll('[id^="fileForm-"]');
        for (const form of fileForms) {
            const index = form.id.split('-')[1]; // Obtener el índice del archivo

            // Verificar si se ha subido un archivo PDF en este formulario
            const fileInput = document.getElementById(`activityPdf-${index}`);
            if (fileInput.files.length === 0) {
                continue; // Saltar este formulario si no hay archivo subido
            }

            hasUploadedFiles = true; // Marcar que se ha subido al menos un archivo

            // Nombre de la actividad
            const activityName = document.getElementById(`activityName-${index}`).value || 'Actividad sin nombre';
            
            // Agregar nombre de la actividad al PDF
            const page = pdfDoc.addPage([600, 400]);
            page.drawText(`Actividad: ${activityName}`, { x: 50, y: 370, size: 18, font, color: rgb(0, 0, 0) });

            // Resumen de horas
            page.drawText(`Resumen de Horas`, { x: 50, y: 330, size: 16, font, color: rgb(0, 0, 0) });
            const academicas = document.getElementById(`academicasInput-${index}`).value || 0;
            const sociales = document.getElementById(`socialesInput-${index}`).value || 0;
            const culturales = document.getElementById(`culturalesInput-${index}`).value || 0;
            const deportivas = document.getElementById(`deportivasInput-${index}`).value || 0;

            page.drawText(`Académicas: ${academicas} horas`, { x: 50, y: 310, size: 12 });
            page.drawText(`Sociales: ${sociales} horas`, { x: 50, y: 290, size: 12 });
            page.drawText(`Culturales: ${culturales} horas`, { x: 50, y: 270, size: 12 });
            page.drawText(`Deportivas: ${deportivas} horas`, { x: 50, y: 250, size: 12 });

            // Actualizar el total de horas
            totalHoras += parseInt(academicas) + parseInt(sociales) + parseInt(culturales) + parseInt(deportivas);

            // Agregar archivo PDF subido
            const uploadedPdfBytes = await fileInput.files[0].arrayBuffer();
            const uploadedPdfDoc = await PDFDocument.load(uploadedPdfBytes);
            const copiedPages = await pdfDoc.copyPages(uploadedPdfDoc, uploadedPdfDoc.getPageIndices());
            copiedPages.forEach(page => pdfDoc.addPage(page));
        }

        // Verificar si se ha subido al menos un archivo
        if (!hasUploadedFiles) {
            // Mostrar el mensaje personalizado
            const customAlert = document.getElementById('customAlert');
            const customAlertMessage = document.getElementById('customAlertMessage');
            customAlertMessage.textContent = 'No has subido ningún archivo PDF. Por favor, sube al menos un archivo antes de descargar.';
            customAlert.style.display = 'flex'; // Mostrar el mensaje

            // Cerrar el mensaje al hacer clic en el botón
            document.getElementById('customAlertCloseButton').onclick = () => {
                customAlert.style.display = 'none';
            };
            return; // Detener la ejecución si no hay archivos subidos
        }

        // Crear una página final con el resumen total de horas
        const page = pdfDoc.addPage([600, 400]);
        page.drawText(`Resumen Final de Horas`, { x: 50, y: 370, size: 18, font, color: rgb(0, 0, 0) });
        page.drawText(`Total de Horas: ${totalHoras}`, { x: 50, y: 330, size: 16, font, color: rgb(0, 0, 0) });

        // Descargar el PDF combinado
        const pdfBytes = await pdfDoc.save();
        const blob = new Blob([pdfBytes], { type: 'application/pdf' });
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = 'Resumen_Actividades_140.pdf';
        link.click();
        });


        // Inicializar el formulario con el primer archivo
        addFileForm();

        // Evento para agregar más archivos
        document.getElementById('addFileButton').addEventListener('click', addFileForm);
    </script>

    <!-------------------------------FIN MODAL PARA SUBIR HORAS ART. 140------------------------------------>

    <script src="../../Resources/jquery/jquery.min.js"></script>
    <script src="../../Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../../Resources/js/toastr.js"></script>
    <!--<script src="../../Resources/js/estado-expediente-estudiante.js"></script>-->
    <script>
        /**
     * CODIGOS DE DOCUMENTOS
     * 
     * 1: Constancia de Verificación de nombre 
     * 2: Copia de DNI 
     * 3: Certificado de calificaciones 
     * 4: Constancia de Trabajo Social 
     * 5: Constancia de pŕactica profesional 
     * 6: Solicitud de realización del himno y su aprobación 
     * 7: Solicitud de extensión de título 
     * 8: Copia de título de educación media 
     * 9: Boleta de pago de carnet de estudiante 
     * 10: Boleta de pago trámites de graduacion 
     * 11: Boleta de pago de entrega de titulo por ventanilla
     * 12: Solvencia de registro 
     * 13: Timbre de contratación 
     * 14: Fotografía ovalada 
     * 15: Solicitud de Honores Académicos y Justificación por Estudiante
     * 
     */

    /**
     * ESTADOS EXPEDIENTE DE ESTUDIANTE
     * 
     * 1: REVISADA (APROBADA)
     * 2: SIN REVISAR
     * 3: REVISADA (NO APROBADA)
     * 4: SIN REVISAR (REPETIDA)
     * 5: SIN ENVIAR (EL ESTUDIANTE AUN NO LO ENVIA)
     * 
     */


    ID_STUDENT = document.getElementById('id-user-session').getAttribute('id-student');        //ID ESTUDIANTE LOGUEADO

    /**FUNCION PARA REALIZAR FUNCIONES NECESARIAS EN CUANTO CARGUE LA PAGINA */
    $(document).ready(function () {

        inicializar();

    });

    async function inicializar () {

        let id = await obtenerDatosEstudiante();
        estadoSolicitud(id);

        /**HABILITAMOS LOS BOTONS SEGUN EL ESTADO DE SOLICITUD */
        $.get("../../controller/estudiante/obtener-estado-soli.php", {id}, function (e) {
            let estado = JSON.parse(e);


            if( estado.estado == "1" ){

    
                $('#cita-estudiante').removeClass("disabled");
                $('#descarga').removeClass("disabled");
                

            }

        });
        
    }

    /**OBTIENE LOS VALORES DEL ESTUDIANTE Y ALMACENA EN INPUTS HIDDEN */
    async function obtenerDatosEstudiante(){

        let id_user = ID_STUDENT;

        const resultado = await $.get("../../controller/estudiante/obtener-estudiante.php", {id_user});
        let estudiante = JSON.parse(resultado);

        if(estudiante.estado_info !== "1"){
            location.href ="estado-informacion.php";
        } else {
            //ALMACENAMOS ESTOS VALORES EN INPUTS HIDDEN PARA ACCEDER A ELLOS MAS TARDE
            $("#id-estudiante").val(estudiante.id);
            $("#cuenta-estudiante").val(estudiante.cuenta);

            //**EN CASO DE PERTENECER A EXCELENCIA SE MOSTRARAN LOS CAMPOS DONDE PUEDE SUBIR LOS DOCUMENTOS QUE SOLO REQUIEREN LOS DE EXCELENCIA */
            if (estudiante.excelencia == "2"){
                $('.docs-excelencia').remove();
            }

            return estudiante.id;
        }


    }


    function estadoSolicitud(id_estudent) {

        const getData = {
            id: id_estudent
        }


        $.get("../../controller/estudiante/obtener-estado-soli.php", getData, function (e) {
            let estado = JSON.parse(e);

            if (estado.estado == "1"){
                
                $("#expediente-aprobado").modal({backdrop: 'static', keyboard: false});
                $("#text-estado-expediente").removeClass("text-muted");
                template = 'Aprobado';
                $("#text-estado-expediente").html(template);
                $("#text-estado-expediente").addClass("text-success");

                template_badge = "Validado";
                $(".badge").removeClass('badge-secondary');
                $(".badge").addClass('badge-success');
                $(".badge").html(template_badge);


            }else if (estado.estado == "3"){
                
                $("#expediente-noaprobado").modal({backdrop: 'static', keyboard: false});
                $("#text-estado-expediente").removeClass("text-muted");
                template = 'No Aprobado';
                $("#text-estado-expediente").html(template);
                $("#text-estado-expediente").addClass("text-danger");
            
                mostrarNoValidos();

            }else{
                $("#expediente-sinaprobar").modal({backdrop: 'static', keyboard: false});
            }

        });
    }


    function cambiarEstilosEnviadoValidar(){

        $("#expediente-sinaprobar").modal({backdrop: 'static', keyboard: false});
                

        $("#text-estado-expediente").removeClass("text-danger");
        template = 'Sin Revisar';
        $("#text-estado-expediente").html(template);
        $("#text-estado-expediente").addClass("text-muted");

        var template_badge = "Sin revisar";

        $(".badge").removeClass('badge-danger');
        $(".badge").removeClass('badge-info');
        $(".badge").addClass("bg-secondary");

                
        $(".badge").html(template_badge);

        let filasTabla = $("#example tr").length-1;
                    
        for (var i = 1; i < filasTabla + 1 ; i++){
            let btn_id = "btn-subir-" + i;
            document.getElementById(btn_id).hidden=true;
        }

        

    }


    function mostrarNoValidos() {
        let student_id = $("#id-estudiante").val();

        const getData = {
            id: student_id
        };

        $.get("../../controller/estudiante/obtener-docs-invalidos.php", getData, function (e) {
            let documentos = JSON.parse(e);

            if (documentos == 'Fallo') {
                toastr["warning"]("Ups! Ha ocurrido un error");
            } else {
                if (documentos.length !== 0) {
                    var template = "Validado";
                    $(".badge").removeClass('badge-secondary');
                    $(".badge").addClass('badge-success');
                    $(".badge").html(template);

                    var x = 0;
                    var docsOcultos = 0;

                    // Agrupar comentarios por código de documento
                    let comentariosPorDocumento = {};
                    documentos.forEach(documento => {
                        if (!comentariosPorDocumento[documento.codigo]) {
                            comentariosPorDocumento[documento.codigo] = [];
                        }
                        comentariosPorDocumento[documento.codigo].push(documento);
                    });

                    // Recorrer los documentos agrupados
                    Object.keys(comentariosPorDocumento).forEach(codigo => {
                        let comentarios = comentariosPorDocumento[codigo];
                        let elementoBoton = "btn-subir-" + codigo;
                        let elementoBadge = "#sub-doc-" + codigo;
                        let elementoVerComentarios = "#ver-comentarios-" + codigo;

                        if (codigo == 3 || codigo == 5 || codigo == 9 || codigo == 17) {
                            docsOcultos++;
                        }

                        // Verificar si el documento tiene estado "3" (inválido)
                        if (comentarios.some(comentario => comentario.estado == "3")) {
                            var template = "Invalido";

                            $(elementoBadge).removeClass('badge-secondary');
                            $(elementoBadge).addClass('badge-danger');
                            $(elementoBadge).html(template);

                            document.getElementById(elementoBoton).hidden = false;

                            // Habilitar el botón "Ver Comentarios" si hay comentarios
                            if (comentarios.length > 0) {
                                $(elementoVerComentarios).removeAttr("disabled");

                                // Asignar el evento click al botón
                                $(elementoVerComentarios).off("click").on("click", function () {
                                    // Invertir el orden de los comentarios (último primero)
                                    let comentariosInvertidos = comentarios.reverse();

                                    // Crear el contenido de la tabla con todos los comentarios
                                    let comentariosHTML = comentariosInvertidos.map(comentario => {
                                        return `
                                            <tr>
                                                <td>${codigo}</td>
                                                <td>${comentario.descripcion}</td>
                                            </tr>
                                        `;
                                    }).join("");

                                    // Mostrar los comentarios en la tabla de la modal
                                    $("#modalComentariosBody").html(comentariosHTML);
                                    $("#comentariosModal").modal("show");
                                });
                            } else {
                                // Deshabilitar el botón si no hay comentarios
                                $(elementoVerComentarios).attr("disabled", true);
                            }

                            x++;
                        } else if (comentarios.some(comentario => comentario.estado == "2")) {
                            var template = "Subido";

                            $(elementoBadge).removeClass('badge-danger');
                            $(elementoBadge).addClass('badge-info');
                            $(elementoBadge).html(template);

                            document.getElementById(elementoBoton).hidden = false;
                        }
                    });

                    if (x - docsOcultos == 0) {
                        toastr["success"]("Todos los documentos han sido subidos, se habilitó el botón de envío.");
                        $('#enviar').removeAttr("disabled");
                    }
                }
            }
        });
    }



    $(document).on("click", ".subir", function() {

    let button = $(this);
    button[0].disabled = true;
    let element_codigo = button[0].parentElement.parentElement;           
    let codigo = $(element_codigo).attr("codigo"); // OBTENEMOS EL CODIGO DEL DOCUMENTO

    let element_archivo = button[0].parentElement.parentElement.getElementsByClassName("doc-estudiante")[0].getElementsByClassName("doc")[0]; // ACCEDEMOS DONDE ESTA EL ARCHIVO CARGADO
    let archivo = $(element_archivo).prop('files')[0]; // OBTENEMOS EL ARCHIVO CARGADO


    if (!archivo) {
        button[0].disabled = false;
        toastr["error"]("El campo del archivo está vacío, debe subir el documento correspondiente.");
    } else {
        var x = 0;
        var errormsg = "";

        var pesoArchivo = archivo.size;
        var nombreArchivo = archivo.name;

        var extensionValida = /(.pdf)$/i;
        var extensionValida2 = /(.jpg|.pdf|.jpeg)$/i;

        // VALIDAMOS EL PESO Y EXTENSION DEL ARCHIVO
        if (!extensionValida.exec(nombreArchivo)) {
            x = x + 1;
            errormsg += "La extensión del archivo debe ser '.pdf'";
        }

        if (pesoArchivo > 5000000) {
            x = x + 1;
            errormsg += "El archivo excede los 5MB";
        }

        if (x > 0) {
            toastr["warning"](errormsg);
            button[0].disabled = false;
        } else {
            let id_estudiante = $("#id-estudiante").val();
            let cuenta_student = $("#cuenta-estudiante").val();

            $.get("../../controller/estudiante/obtener-linksolicitud.php", { id_estudiante }, function(e) {
                let link = JSON.parse(e);
                toastr["success"]("Espere, se está subiendo su archivo");
                if (link == "Fallo") {
                    toastr["warning"]("UPS! Ha ocurrido un error, inténtelo de nuevo");
                    button[0].disabled = false;
                } else {
                    let extension = nombreArchivo.slice((nombreArchivo.lastIndexOf(".") - 1 >>> 0) + 2);
                    let ruta = link.link;
                    let id_solicitud = link.id;
                    var formData = new FormData();
                    formData.append('file', archivo);
                    formData.append('id', id_estudiante);
                    formData.append('cuenta', cuenta_student);
                    formData.append('ruta', ruta);
                    formData.append('codigo', codigo);
                    formData.append('extension', extension);
                    formData.append('id_solicitud', id_solicitud);


                    $.ajax({
                        data: formData,
                        url: "../../controller/estudiante/subir-documento-invalidado.php",
                        type: "POST",
                        contentType: false,
                        processData: false,
                        success: function(e) {
                            if (e == "Error") {
                                toastr["error"]("Ups! Ha ocurrido un error, inténtelo de nuevo");
                            } else {
                                toastr["success"]("Se ha subido el documento satisfactoriamente");
                                // Actualizar el estado del documento en la interfaz
                                let elementoBadge = "#sub-doc-" + codigo;
                                var template = "Subido";
                                $(elementoBadge).removeClass('badge-danger');
                                $(elementoBadge).addClass('badge-info');
                                $(elementoBadge).html(template);
                                mostrarNoValidos();
                            }
                            button[0].disabled = false;
                        },
                        error: function() {
                            toastr["error"]("Error en la solicitud AJAX");
                            button[0].disabled = false;
                        }
                    });
                }
            });
        }
    }
});

    $(document).on("click", "#enviar", function(){

        let id_estudiante = $("#id-estudiante").val();
        let estado = 4;

        $.post("../../controller/estudiante/enviar-expediente.php", {id_estudiante, estado}, function (e) {
            let respuesta = JSON.parse(e);

            if (respuesta == 'Error'){
                toastr["warning"]("Ups! Ha ocurrido un error");
            } else{
                toastr["success"]("Se ha enviado su documentacion");
                $('#enviar').attr('disabled','disabled');
                cambiarEstilosEnviadoValidar();
            }
        });

    });
    </script>

    <!--<script src="../../Resources/jquery/jquery.min.js"></script>
    <script src="../../Resources/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../../Resources/js/toastr.js"></script>
    <script src="../../Resources/js/estado-expediente-estudiante.js"></script>-->
    


    <script>
        $("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
        });
    </script>

</body>
</html>
