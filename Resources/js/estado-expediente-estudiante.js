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