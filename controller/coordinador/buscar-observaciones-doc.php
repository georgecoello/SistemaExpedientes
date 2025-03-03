<?php

    include("../../Resources/lib/connection.php");

    $buscador = $_GET["buscador"];

    $sp = "call SP_BUSCAROBSERVACIONESDOC('$buscador%');";

    $query = mysqli_query($connection, $sp);

    if (!$query) {
        echo json_encode("problema");
    } else{
        $json = array();
        while($row = mysqli_fetch_array($query)){
            $json[] = array(
                "id_estudiante" => $row["id_estudiante"],
                "nombres_estudiante" => $row["nombres_usuario"],
                "apellidos_estudiante" => $row["apellidos_usuario"],
                "numero_cuenta" => $row["numero_cuenta_estudiante"],
                "id_respuesta" => $row["id_respuesta_documento"], 
                "descripcion" => $row["descripcion"]
            );
        }

        $json_string = json_encode($json);
        echo $json_string;

    }

    cerrarConexion($connection);
    

?>