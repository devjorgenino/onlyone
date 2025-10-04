/** Inico Envio de Formularios **/
$(document).ready(function () { //documento
    $('.Form').submit(function (e) {
        e.preventDefault();
        var data = $(this).serialize();
        var type = $(this).attr('method');
        var url = $(this).attr('action');
        var formType = $(this).attr('data-form');
        if (formType == "n_usuario") {
            $("#btn-guardar_inv").attr('disabled', 'disabled');
            $.ajax({
                type: type,
                url: url,
                data: data,
                beforeSend: function () {
                    $(".res").html('<div class="offset-md-4">Enviando Invitación<br><img src="assets/img/pagoss.gif"></dvi>');
                },
                error: function () {
                    $(".res").html('<div class="alert alert-danger">Ha ocurrido un error en el sistema</div>');
                    $("#btn-guardar_inv").removeAttr("disabled");
                },
                success: function (data) {
                    $('.res').html(data);
                    cargarusuario();
                    $("#btn-guardar_inv").removeAttr("disabled");
                }
            });
            return false;
        } if (formType == "n_factura") {
            $("#btn-guardar_fact").attr('disabled', 'disabled');
            $.ajax({
                type: type,
                url: url,
                data: data,
                beforeSend: function () {
                    $(".res2").html('<div class="offset-md-4">Registrando Factura<br><img src="assets/img/pagoss.gif"></dvi>');
                },
                error: function () {
                    $(".res2").html('<div class="alert alert-danger">Ha ocurrido un error en el sistema</div>');
                    $("#btn-guardar_fact").removeAttr("disabled");
                },
                success: function (data) {
                    $('.res2').html(data);
                    cargarfactura();
                    $("#btn-guardar_fact").removeAttr("disabled");
                }
            });
            return false;
        } if (formType == "n_conciliacion") {
            $("#btn-si").attr('disabled', 'disabled');
            $("#btn-no").attr('disabled', 'disabled');
            $.ajax({
                type: type,
                url: url,
                data: data,
                beforeSend: function () {
                    $("#res-conci").html('<div class="offset-md-4">Conciliando<br><img src="assets/img/pagoss.gif"></dvi>');
                },
                error: function () {
                    $("#res-conci").html('<div class="alert alert-danger">Ha ocurrido un error en el sistema</div>');
                    $("#btn-si").removeAttr("disabled");
                    $("#btn-no").removeAttr("disabled");
                },
                success: function (data) {
                    $('#res-conci').html(data);
                    cargarreporte();
                    $("#btn-si").removeAttr("disabled");
                    $("#btn-no").removeAttr("disabled")
                }
            });
            return false;
        }

    });
    /** Fin Envio de Formularios **/
    $('#c_movimiento_c').on('show.bs.modal', function (e) {
        var rowid = $(e.relatedTarget).data('id');
        console.log(rowid);
        $("#c_reporte").modal("hide");
        $.ajax({
            type: 'post',
            url: '?c=app&a=c_movimiento',
            data: 'id=' + rowid,
            beforeSend: function () {
                $("#cuepo_rep2").html('<div class="offset-md-4">Consultando Movimiento Bancario<br><img src="assets/img/pagoss.gif"></dvi>');
            },
            error: function () {
                $("#cuepo_rep2").html('<div class="alert alert-danger">Ha ocurrido un error en el sistema</div>');
            },
            success: function (data) {
                $('#cuepo_rep2').html(data);
            }
        });
    });

    $('#c_reporte').on('show.bs.modal', function (e) {
        var rowid = $(e.relatedTarget).data('id');
        console.log(rowid);
        $.ajax({
            type: 'post',
            url: '?c=app&a=c_reporte',
            data: 'id=' + rowid,
            beforeSend: function () {
                $("#cuepo_rep").html('<div class="offset-md-4">Consultando Reporte de Pago<br><img src="assets/img/pagoss.gif"></div>');
            },
            error: function () {
                $("#cuepo_rep").html('<div class="alert alert-danger">Ha ocurrido un error en el sistema</div>');
            },
            success: function (data) {
                $('#cuepo_rep').html(data);
            }
        });
    });

    //Datatable de reporte de pagos onlyone
    $("#dataTable").DataTable({
        destroy: true,
        dom: "Bfrtip",
        paging: true,
        lengthChange: false,
        searching: true,
        ordering: false,
        info: false,
        autoWidth: true,
        pagingType: "simple",
        responsive: true,
        //displayLength: 6,
        language: {
            "paginate": {
                "previous": "<",
                "next": ">"
            }
        },
        buttons: [

        ],
        columns: [
            { className: "" },
            { className: "" },
            { className: "" },
            { className: "" },
            { className: "d-none d-lg-none" },
            { className: "" },
            { className: "" },
            { className: "" },
            { className: "" }
        ],

        initComplete: function () {
            //idreporte
            this.api().columns([0]).every(function () {
                var text = $(this).text();
                var column = this;
                var html = $('<input class="taminput " type="text" name="buscarIdRep" id="buscarIdRep">')
                    .appendTo($(column.footer()).empty());
                ;
            });

            //fecha de pago
            this.api().columns([1]).every(function () {
                var text = $(this).text();
                var column = this;
                var html = $('<input class="taminput " type="date" name="buscarFecha" id="buscarFechan">')
                    .appendTo($(column.footer()).empty());
                ;
            });

            //cuenta y estatus
            this.api()
                .columns([2])
                .every(function () {
                    var column = this;
                    var select = $('<select class="tamselect"> <option value=""> </option></select>')
                        .appendTo($(column.footer()).empty())
                        .on("change", function () {
                            var val = $.fn.dataTable.util.escapeRegex($(this).val());
                            column.search(val ? "^" + val + "$" : "", true, false).draw();
                        });
                    column
                        .data()
                        .unique()
                        .sort()
                        .each(function (d, j) {
                            select.append('<option value="' + d + '">' + d + "</option>");
                        });
                });

            //clientes
            this.api().columns([3]).every(function () {

                var text = $(this).text();
                var column = this;
                var html = $('<input class="taminput " type="text" name="buscarNombre" id="buscarNombre">')
                    .appendTo($(column.footer()).empty());
                ;
            });

            //nro operacion
            this.api().columns([6]).every(function () {

                var text = $(this).text();
                var column = this;
                var html = $('<input class="taminput " type="text" name="buscarReferenciaR" id="buscarReferenciaR">')
                    .appendTo($(column.footer()).empty());
                ;
            });

            //estatus
            this.api().columns([5]).every(function () {

                var text = $(this).text();
                var column = this;
                var html = $('<input class="taminput " type="text" name="buscarEstatus" id="buscarEstatus">')
                    .appendTo($(column.footer()).empty());
                ;
            });

            //no filtro
            this.api()
                .columns([4, 7, 8])
                .every(function () {
                    var column = this;
                    var html = $('<p class="text-center"> - </p>')
                        .appendTo($(column.footer()).empty());
                });

            this.api()
                .columns([0, 1, 3, 5, 6])
                .every(function () {
                    var column = this;
                    var select = $('input', this.footer())
                        .on("keyup change", function () {
                            if (column.search() !== this.value) {
                                column.search(this.value).draw();
                            }

                        });

                });

            var $buttons = $('.dt-buttons').hide();
        }

    });

    $("#dataTable2").DataTable({
        destroy: true,
        dom: "Bfrtip",
        paging: true,
        lengthChange: false,
        searching: true,
        ordering: true,
        info: false,
        autoWidth: true,
        pagingType: "simple",
        responsive: true,
        //displayLength: 6,
        language: {
            "paginate": {
                "previous": "<",
                "next": ">"
            }
        },
        buttons: [

        ],
        columns: [
            { className: "" },
            { className: "" },
            { className: "" },
            { className: "" },
            { className: "" },
            { className: "" }
        ],

        initComplete: function () {   
            var $buttons = $('.dt-buttons').hide();
        }

    });


});

function exprePersonal(e) {
    tecla = (document.all) ? e.keyCode : e.which;
    if (tecla == 8) {
        return true;
    }
    var patron = /[\w._@]/g;
    tecla_final = String.fromCharCode(tecla);
    return patron.test(tecla_final);
}

/** script de actualizar datos **/
function cargarusuario() {
    $.ajax({
        type: "post",
        url: "?c=app&a=cargarUsuario",
        beforeSend: function () {
            $("#usuario_lista").html('<div class="offset-md-4">Actualizando<br><img src="assets/img/pagos.gif"></dvi>');
        },
        error: function () {
            $("#usuario_lista").html('<div class="alert alert-danger">Ha ocurrido un error en el sistema</div>');
        },
        success: function (data) {
            $('#usuario_lista').html(data);
        }
    });
}
function cargarfactura() {
    $.ajax({
        type: "post",
        url: "?c=app&a=cargarFactura",
        beforeSend: function () {
            $("#Factura_lista").html('<div class="offset-md-4">Actualizando<br><img src="assets/img/pagos.gif"></dvi>');
        },
        error: function () {
            $("#Factura_lista").html('<div class="alert alert-danger">Ha ocurrido un error en el sistema</div>');
        },
        success: function (data) {
            $('#Factura_lista').html(data);
        }
    });
}
function cargarreporte() {
    $.ajax({
        type: "post",
        url: "?c=app&a=reportesPagos",
        beforeSend: function () {
            $("#reporte_lista").html('<div class="offset-md-4">Actualizando<br><img src="assets/img/pagos.gif"></dvi>');
        },
        error: function () {
            $("#reporte_lista").html('<div class="alert alert-danger">Ha ocurrido un error en el sistema</div>');
        },
        success: function (data) {
            $('#reporte_lista').html(data);
        }
    });
}
/** script de actualizar datos **/
function limpiarForm() {
    setTimeout(function () {
        $('.res').html('');
    }, 2000);
}
/** script de pagos **/
function cargarbody(key) {
    var url;
    switch (key) {
        case 1:
            console.log("selecione" + key);
            url = "?c=app&a=inicio";
            peticionbody(url);
            break;

        case 2:
            console.log("selecione" + key);
            url = "?c=app&a=facturas";
            peticionbody(url);
            break;

        case 3:
            console.log("selecione" + key);
            url = "?c=app&a=balances";
            peticionbody(url);
            break;

        case 4:
            console.log("selecione" + key);
            url = "?c=app&a=usuario";
            peticionbody(url);
            break;
        case 5:
            console.log("selecione" + key);
            url = "?c=app&a=conciliacion";
            peticionbody(url);
            break;

        default:
            console.log("ha ocurrido un error");
            break;
    }
}
function limpiarFormulario(key) {
    switch (key) {
        case 1:
            setTimeout(function () {
                $('.res').html('');
                $("#email").val('');
                $("#n_usuario").modal("hide");
            }, 3000);
            break;

        case 2:
            setTimeout(function () {
                $('.res2').html('');
                $('#formulario_factura').trigger("reset");
                $("#n_factura").modal("hide");
            }, 3000);
            break;

        case 3:
            console.log("selecione" + key);
            break;

        case 4:
            console.log("selecione" + key);
            break;
    }
}
function peticionbody(url) {
    console.log("entro aqui");
    $.ajax({
        type: "post",
        url: url,
        beforeSend: function () {
            $("#body").html('<div class="offset-md-4"><img src="assets/img/pagos.gif"></dvi>');
        },
        error: function () {
            $("#body").html('ha ocurrido un error');
        },
        success: function (data) {
            $("#body").html(data);
        }
    });

}
$("#f_correo").blur(function () {
    console.log("entro aqui" + $('#f_correo').val());
    $.ajax({
        type: "post",
        url: "?c=app&a=cn_factura",
        data: 'email=' + $('#f_correo').val(),
        beforeSend: function () {
            console.log("cargando");
        },
        error: function () {
            console.log("Error");
        },
        success: function (data) {
            $("#f_cliente").val("");
            console.log(data);
            if (data != "-1") {
                $("#f_cliente").removeAttr("disabled")
                $("#f_cliente").attr('readonly', 'readonly');
                $("#f_cliente").val(data);
            } else {
                $("#f_cliente").removeAttr("disabled")
                $("#f_cliente").removeAttr("readonly")
            }
        }
    });
});


$("#inputMonto").on({
    "focus": function (event) {
        $(event.target).select();
    },
    "keyup": function (event) {
        $(event.target).val(function (index, value) {
            return value.replace(/\D/g, "")
                .replace(/([0-9])([0-9]{2})$/, '$1,$2')
                .replace(/\B(?=(\d{3})+(?!\d)\.?)/g, ".");
        });
    }
});

