/*********************************GLOBALES***************************************** */
(function($){
    $('img').on('error', function(){
      var image = $(this).attr('src');
      if ( /(\.svg)$/i.test( image )) {
        $(this).attr('src', image.replace('.svg', '.png'));
      }
    })  
  })(jQuery);
  $(function(){
    jQuery('img.svg').each(function(){
        var $img = jQuery(this);
        var imgID = $img.attr('id');
        var imgClass = $img.attr('class');
        var imgURL = $img.attr('src');

        jQuery.get(imgURL, function(data) {

            // Get the SVG tag, ignore the rest

            var $svg = jQuery(data).find('svg');

    

            // Add replaced image's ID to the new SVG

            if(typeof imgID !== 'undefined') {

                $svg = $svg.attr('id', imgID);

            }

            // Add replaced image's classes to the new SVG

            if(typeof imgClass !== 'undefined') {

                $svg = $svg.attr('class', imgClass+' replaced-svg');

            }
            $svg = $svg.removeAttr('xmlns:a');

            

            // Check if the viewport is set, else we gonna set it if we can.

            if(!$svg.attr('viewBox') && $svg.attr('height') && $svg.attr('width')) {

                $svg.attr('viewBox', '0 0 ' + $svg.attr('height') + ' ' + $svg.attr('width'))

            }

    

            // Replace image with new SVG

            $img.replaceWith($svg);

    

        }, 'xml');

    

    });

});

    

function soloNum(e) {
	tecla = document.all ? e.keyCode : e.which;

	//Tecla de retroceso para borrar, siempre la permite
	if (tecla == 8) {
		return true;
	}

	// Patron de entrada, en este caso solo acepta numeros y letras
	patron = /[z0-9]/;
	tecla_final = String.fromCharCode(tecla);
	return patron.test(tecla_final);
}
$("#montoCuenta").on({
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
$("#montoCuenta").on({
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
$("#montoCuentae").on({
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
function decimal(e) {
	tecla = document.all ? e.keyCode : e.which;

	//Tecla de retroceso para borrar, siempre la permite
	if (tecla == 8) {
		return true;
	}

	patron = /^[0-9.]+$/;
	tecla_final = String.fromCharCode(tecla);
	return patron.test(tecla_final);
}
function LimpiarFC(){
	$("#formulario")[0].reset();
	desabitarBotonesCuenta(1);
	$("#cn").html("");
	$("#ce").html("");
}

$('#pagesDropdown').on('click',function(){
	$('.pagesDropdown').toggle();
	$('.pagesDropdown1').hide();
	$('.pagesDropdown2').hide();
	$('.pagesDropdown3').hide();
	$('.userDropdown').hide();
});

$('#pagesDropdown1').on('click',function(){
	$('.pagesDropdown1').toggle();
	$('.pagesDropdown').hide();
	$('.pagesDropdown2').hide();
	$('.pagesDropdown3').hide();
	$('.userDropdown').hide();
});

$('#pagesDropdown2').on('click',function(){
	$('.pagesDropdown2').toggle();
	$('.pagesDropdown').hide();
	$('.pagesDropdown1').hide();
	$('.pagesDropdown3').hide();
	$('.userDropdown').hide();
});

$('#pagesDropdown3').on('click',function(){
	$('.pagesDropdown3').toggle();
	$('.pagesDropdown').hide();
	$('.pagesDropdown1').hide();
	$('.pagesDropdown2').hide();
	$('.userDropdown').hide();
});

$('#userDropdown').on('click',function(){
	$('.userDropdown').toggle();
	$('.pagesDropdown').hide();
	$('.pagesDropdown1').hide();
	$('.pagesDropdown2').hide();
	$('.pagesDropdown3').hide();
});


//********************************************Dashboard**************************************/
function cargargrafico(){
	var popCanvas = $("#popChart");
	var popCanvas = document.getElementById("popChart");
	var popCanvas = document.getElementById("popChart").getContext("2d");
	
	$.ajax({
		type : 'GET',
		url : '?c=app&a=datos_graficos',
		beforeSend: function () {
			console.log('consultando');
		},
		error: function () {
			console.log('Error');
		},
		success : function(data){
			datos=$.parseJSON(data);
			if(datos=="-1"){
			console.log("no hay data");
			}else{
			mostrargrafico(datos);
			}
		}
	});
	
}
function mostrargrafico(datos){
	var popCanvas = $("#popChart");
	var popCanvas = document.getElementById("popChart");
	var popCanvas = document.getElementById("popChart").getContext("2d");

	var pieChart = new Chart(popCanvas, {
		type: 'pie',
		data: {
		labels: [datos[0].tipo+' ('+datos[0].monto_rep+')', datos[1].tipo+' ('+datos[1].monto_rep+')'],
		datasets: [{
			label:'Population',
			data: [datos[0].total_re, datos[1].total_re],
			backgroundColor: [
				'#ff9900',
				'#3399ff'	
			]
		}]
		},
		options: {
			responsive: true,

	   legend: {
			display: true,
			position: "bottom"
		}
		}
	});
}
//********************************************Dashboard**************************************/
//********************************************Cuentaas**************************************/
function cargarCuenta() {
	var act;
	$("#dataTableCuentas").DataTable({
		destroy: true,
		paging: true,
      	lengthChange: false,
      	searching: false,
      	ordering: false,
      	info: false,
      	autoWidth: false,
      	pagingType: "simple",
      	responsive: true,
		language: {
			"paginate": {
			  "previous": "<",
			  "next": ">"
			}
		},
		ajax: {
			type: "POST",
			dataType: "json",
			url: "index.php?c=app&a=cargarCuentas"
		},
		columns: [
			{ data: "numero", className: "text-center"},
			{ data: "nombrebanco", className: "text-left" },
			//{ data: "fechsaldo", className: "d-none d-md-none d-lg-table-cell text-center" },
			{
				render: function(data, type, row) {
					if (row.retrazado == 2) {
						return '<p>'+row.fechsaldo+'</p>';
					} else {
						return '<p style="color:red;">'+row.fechsaldo+'</p>';
					}
				}, className: "text-center"
			},
			{
				render: function(data, type, row) {
					return row.saldo;
				}, className: "text-right"
			},
			{
				render: function(data, type, row) {
					if (row.estatu == 1) {
						return '<span class="badge badge-pill badge-success">Activo</span>';
					} else {
							return '<span class="badge badge-pill badge-danger">Inactivo</span>';
					}
				}, className: "d-none d-md-none d-lg-table-cell text-center"
			}, 
			{
				render: function(data, type, row) {
					if(row.movimiento==0){
					act="";			
					
								if(row.estatu==1){
									act ='<div class="btn-group" role="group" aria-label="Basic example"> <button class="btn detallecuenta mr-1" title="Editar" data-toggle="modal" data-target=".editarCuenta" data-idCuenta="' +
									row.idcuenta +
									'"><i class="fas fa-file-signature"></i></button>&nbsp<button class="btn detallecuenta mr-1" title="Inactivar" data-toggle="modal" data-target=".ad_cuenta" data-idCuenta="' +
									row.idcuenta +
									'"><i class="fas fa-lock">';
								}else{
									act ='<div class="btn-group" role="group" aria-label="Basic example"> <button class="btn detallecuenta mr-1" title="Editar" disabled><i class="fas fa-file-signature"></i></button>&nbsp<button class="btn detallecuenta" title="Activar" data-toggle="modal" data-target=".ad_cuenta" data-idCuenta="' +
									row.idcuenta +
									'"><i class="fas fa-unlock">';
								}
								act +='</i></button>&nbsp<button class="btn detallecuenta mr-1" title="Eliminar" data-toggle="modal" data-target=".eliminar_cuenta" data-idCuenta="' +
								row.idcuenta +
								'"><i class="fas fa-trash-alt"></i></button></div> ';

						return act;
					}else{
						if(row.estatu==1){
							act ='<div class="btn-group" role="group" aria-label="Basic example"> <button class="btn detallecuenta mr-1" title="Editar" data-toggle="modal" data-target=".editarCuenta" data-idCuenta="' +
							row.idcuenta +
							'"><i class="fas fa-file-signature"></i></button>&nbsp<button class="btn detallecuenta mr-1" title="Inactivar" data-toggle="modal" data-target=".ad_cuenta" data-idCuenta="' +
							row.idcuenta +
							'"><i class="fas fa-lock">';
						}else{
							act ='<div class="btn-group" role="group" aria-label="Basic example"> <button class="btn detallecuenta mr-1" title="Editar" disabled><i class="fas fa-file-signature"></i></button>&nbsp<button class="btn detallecuenta" title="Activar" data-toggle="modal" data-target=".ad_cuenta" data-idCuenta="' +
							row.idcuenta +
							'"><i class="fas fa-unlock">';
						}

							act +='</i></button>&nbsp<button class="btn detallecuenta mr-1" title="Eliminar" disabled><i class="fas fa-trash-alt"></i></button></div> ';
							return act;
					}
				} , className: "text-center"
			}
		],
		initComplete: function () {

		}
	});
}
function productosSelectEditar(id){
	$("#formularioe").removeAttr("disabled");
	var data;
	var div="#ce";
	var url="index.php?c=app&a=consultarMaestros";
	var msj="Consultando Bancos...";

			switch (id.value) {
				case "1":
					data=1;
					peticionAjax(url,data,msj,div,"#bancoe"); 
					maskSelector(1);
					$('#numCuentae').val('');
				break;
				case "2":
					data=1;
					peticionAjax(url,data,msj,div,"#bancoe"); 
					maskSelector(2);
					$('#numCuentae').val('');
				break;
				case "4":
					data=1;
					peticionAjax(url,data,msj,div,"#bancoe"); 
					maskSelector(4);
					$('#numCuentae').val('');
				break;				
				default:
					desabitarBotonesCuenta(1);
					break;
			}
}
function productosSelect(id){
	var data;
	var div="#cn";
	var url="index.php?c=app&a=consultarMaestros";
	var msj="Consultando Bancos...";
			switch (id.value) {
				case "1":
					data=1;
					peticionAjax(url,data,msj,div,"#banco"); 
					desabitarBotonesCuenta(1);

					maskSelector2("1");
				break;
				case "2":
					data=1;
					desabitarBotonesCuenta(1);
					peticionAjax(url,data,msj,div,"#banco"); 
					maskSelector2("2");
				break;
				case "3":
					data=2;
					desabitarBotonesCuenta(1);
					peticionAjax(url,data,msj,div,"#banco"); 
					maskSelector2("3");
				break;
				case "4":
					data=1;
					desabitarBotonesCuenta(1);
					peticionAjax(url,data,msj,div,"#banco"); 
					maskSelector2("4");
				break;				
				default:
					desabitarBotonesCuenta(1);
					break;
			}
}
function desabitarBotonesCuenta(nivel){
	if(nivel===1){
		$("#banco").attr('disabled','disabled');
		$("#divisa").attr('disabled','disabled');
		$("#numCuenta").attr('disabled','disabled');
		$("#numCuenta").val('');
		$("#montoCuenta").attr('disabled','disabled');
		$("#montoCuenta").val('');
		$("#tc").html("");
		//$("#ts").html("");
		$("#limpiarc").removeAttr("disabled");
	}else{
		$("#divisa").attr('disabled','disabled');
		$("#numCuenta").attr('disabled','disabled');
		$("#montoCuenta").attr('disabled','disabled');
		$("#numCuenta").val('');
		$("#montoCuenta").val('');
		$("#tc").html("");
	//	$("#ts").html("");
	}
}
function peticionAjax(url,datos,msj,div,d) {
	$.ajax({
		type: "POST",
		url: url,
		data:{id: datos},
		/*beforeSend: function() {
			$(div).html(
				'<div class="alert alert-info text-center msj_margen" >'+msj+'</div>'
			);
		},*/
		error: function() {
			$(div).html(
				'<div class="alert alert-danger">Oops, Estimado Usuario Ha Ocurrido Un Error<br>Intente Nuevamente </div>'
			);
		},
		success: function(data) {
			presentacionAjax(data,div,d);
		}
	});
}
function maskSelector2(codigo){
	switch (codigo) {
		case "1":
			$('#numCuenta').attr('maxlength', 16);
			$('#numCuenta').attr('minlength', 16);
			break;
		case "2":
			$('#numCuenta').attr('maxlength', 16);
			$('#numCuenta').attr('minlength', 16);
				break;
		case "3":
			$('#numCuenta').attr('maxlength', 8);
			$('#numCuenta').attr('minlength', 8);
				break;
		case "4":
			$('#numCuenta').attr('maxlength', 8);
			$('#numCuenta').attr('minlength', 8);
				break;
		}

 }
 function presentacionAjax(data,div,d){
	switch (d) {
		case "#banco":
				if(data===-1){
					$(div).html('<div class="alert alert-warning">No existe bancos Disponibles para este producto </div>');
				}else{
					$("#banco").removeAttr("disabled");
					$("#banco").empty().append(data);
					$(div).html('');
				}
			break;
			case "#bancoe":
				if(data===-1){
					$(div).html('<div class="alert alert-warning">No existe bancos Disponibles para este producto </div>');
				}else{
					$("#bancoe").removeAttr("disabled");
					$("#bancoe").empty().append(data);
					$(div).html('');
				}
			break;
		case "#divisa":
			data=$.parseJSON(data);
					if(data.data===-1){
						$(div).html('<div class="alert alert-warning">No existe divisas Disponibles Disponibles para este producto </div>');
					}else{
						$("#divisa").removeAttr("disabled");
						$("#divisa").empty().append(data.data);
						
						$(div).html('');
					}
				break;
				case "#divisae":
					data=$.parseJSON(data);
							if(data.data===-1){
								$(div).html('<div class="alert alert-warning">No existe divisas Disponibles Disponibles para este producto </div>');
							}else{
								$("#divisae").removeAttr("disabled");
								$("#divisae").empty().append(data.data);
								
								$(div).html('');
							}
						break;
	
		default:
			console.log("Ha Ocurrido un Error");
			break;
	}
	
}
function bancosSelect(id){
	var data;
	var div="#cn";
	var url="index.php?c=app&a=consultarMaestrosD";
	var msj="Consultando Divisa...";
	var codigo =$("#banco option:selected").data('cod');
			switch (id.value) {
				case "1":
					desabitarBotonesCuenta(2);
					data="fisica";
					peticionAjax(url,data,msj,div,"#divisa"); 
				break;	
				case "2":
					desabitarBotonesCuenta(2);
					data="fisica";
					peticionAjax(url,data,msj,div,"#divisa"); 
				break;	
				case "3":
						desabitarBotonesCuenta(2);
						data="fisica";
						peticionAjax(url,data,msj,div,"#divisa"); 
					break;	
				case "4":
						desabitarBotonesCuenta(2);
						data="fisica";
						peticionAjax(url,data,msj,div,"#divisa"); 
					break;	
				case "5":
						desabitarBotonesCuenta(2);
						data="virtual";
						peticionAjax(url,data,msj,div,"#divisa"); 
					break;	
				case "7":
							desabitarBotonesCuenta(2);
							data="virtual";
							peticionAjax(url,data,msj,div,"#divisa"); 
				break;	
				case "8":
					desabitarBotonesCuenta(2);
					data="fisica";
					peticionAjax(url,data,msj,div,"#divisa"); 
				break;	

				case "6":
					desabitarBotonesCuenta(2);
					data="fisica";
					peticionAjax(url,data,msj,div,"#divisa"); 
				break;	

				default:
					desabitarBotonesCuenta(2);
					console.log("Formato de cuenta no valido");
					break;
			}
}
function divisaSelect(){
	var codigo =$("#banco option:selected").data('cod');
	var codigo2 =$("#divisa option:selected").data('cod');
	$("#numCuenta").removeAttr("disabled");
	$("#montoCuenta").removeAttr("disabled");
	$("#codigoB").val(codigo);
	$("#tc").html(codigo);
	//$("#ts").html(codigo2);
	var c =$("#tipoCuenta option:selected").val();
	if(c==="1"){
		$("#tc").css("display", "block");
	}else{
		$("#tc").css("display", "none");
	}
}
$(document).on("keyup", "#montoCuenta", function() {
	if ($("#montoCuenta").val() != "") {
		$("#enviarFormulario").removeAttr("disabled");
	} else {
		$("#enviarFormulario").prop("disabled", true);
	}
});
$(document).on("keyup", "#montoCuentae", function() {
	if ($("#montoCuentae").val() != "") {
		$("#formularioe").removeAttr("disabled");
	}
});
$(document).on("keyup", "#numCuentae", function() {
	if ($("#numCuentae").val() != "") {
		$("#formularioe").removeAttr("disabled");
	}
});
$("#formulario").submit(function(e) {
	e.preventDefault();
	var datos = $("#formulario").serialize();
	$.ajax({
		type: "POST",
		url: "?c=app&a=registrar_cuenta",
		data: datos,
		beforeSend: function() {
			$("#cn").html(
				'<div class="alert alert-info text-center msj_margen" >Guardando Cuenta</div>'
			);
		},
		error: function() {
			$("#cn").html(
				'<div class="alert alert-danger">Oops, Estimado Usuario Ha Ocurrido Un Error<br>Intente Nuevamente </div>'
			);
		},
		success: function(data) {
			$("#cn").html(data);
		}
	});
	return false;
});
$("#formularioee").submit(function(e) {
	e.preventDefault();
	var datos = $("#formularioee").serialize();
	$.ajax({
		type: "POST",
		url: "?c=app&a=ModificarCuenta",
		data: datos,
		beforeSend: function() {
			$("#ce").html(
				'<div class="alert alert-info text-center msj_margen" >Espere un momento, por favor</div>'
			);
		},
		error: function() {
			$("#ce").html(
				'<div class="alert alert-danger">Oops, Estimado Usuario Ha Ocurrido Un Error<br>Intente Nuevamente </div>'
			);
		},
		success: function(data) {
			$("#ce").html(data);
		}
	});
	return false;
});
$('.editarCuenta').on('show.bs.modal', function (e) {
	var rowid = $(e.relatedTarget).data('idcuenta');
	$("#formularioe").prop("disabled", true);
	$.ajax({
		type : 'post',
		url : '?c=app&a=modificarProductos',
		data :  'id='+ rowid,
		beforeSend: function () {
			$("#contenido2").html('<div class="alert alert-info text-center">Espere un momento, por favor<br><img src="assets/img/pagoss.gif"></dvi>');
		},
		error: function () {
			$("#contenido2").html('<div class="alert alert-danger text-center">Ha ocurrido un error en el sistema</div>');
		},
		success : function(data){
			RespEditarCuenta(data);
			$("#id").val(rowid);
			$("#contenido2").html('');
		}
	});
 });
 function RespEditarCuenta(data){
	data=JSON.parse(data);
	switch (data.resp) {
	   case 1:
		   $("#contenido").css("display", "block");
		   $("#tipoCuentaE").empty().append(data.p);
		   $("#bancoe").empty().append(data.b);
		   $("#divisae").empty().append(data.d);
		   $("#numCuentae").val(data.n);
		   $("#montoCuentae").val(data.s);
		   var codigo =$("#bancoe option:selected").data('cod');
		   var codigo2 =$("#divisae option:selected").data('cod');
		   $("#codigoBe").val(codigo);
		   $("#tce").html(codigo);
			//$("#tse").html(codigo2);
		   var c =$("#tipoCuentaE option:selected").val();
		   maskSelector(c);
		   if(c==="3"){
			   $('#tipoCuentaE option:not(:selected)').attr('disabled', true);
		   }else{
			   $("#tipoCuentaE option[value='3']").remove();
		   }
	   break;
	   case -1:
		   $("#contenido").css("display", "none");
		   $("#ce").html('<div class="alert alert-danger text-center msj_margen" ><span> <i class="fas fa-exclamation-triangle" style="color: red;"></i> Faltan Datos</span></div>');	 
	   break;
	   case -2:
		   $("#contenido").css("display", "none");
		   $("#ce").html('<div class="alert alert-danger text-center msj_margen" ><span> <i class="fas fa-exclamation-triangle" style="color: red;"></i> Error Cuenta no Encontrada</span></div>');	 
	   break;
	   case -3:
		   $("#contenido").css("display", "none");
		   $("#ce").html('<div class="alert alert-danger text-center msj_margen" ><span> <i class="fas fa-exclamation-triangle" style="color: red;"></i> Ha ocurrido un error al consultar Maestros</span></div>');	 
	   break;
	   default:
		   console.log("no se que hacer");
	   break;
	}
}
function maskSelector(codigo){
	switch (codigo) {
		case "1":
			$('#numCuentae').attr('maxlength', 16);
			$('#numCuentae').attr('minlength', 16);
			break;
		case "2":
			$('#numCuentae').attr('maxlength', 16);
			$('#numCuentae').attr('minlength', 16);
				break;
		case "3":
			$('#numCuentae').attr('maxlength', 8);
			$('#numCuentae').attr('minlength', 8);
				break;
		case "4":
			$('#numCuentae').attr('maxlength', 8);
			$('#numCuentae').attr('minlength', 8);
				break;
		}

 }
 function bancosSelectEditar(id){
	$("#formularioe").removeAttr("disabled");
	var data;
	var div="#ce";
	var url="index.php?c=app&a=consultarMaestrosD";
	var msj="Consultando Divisa...";
			switch (id.value) {
				case "1":
					desabitarBotonesCuenta(2);
					data="fisica";
					peticionAjax(url,data,msj,div,"#divisae"); 
				break;	
				case "2":
					desabitarBotonesCuenta(2);
					data="fisica";
					peticionAjax(url,data,msj,div,"#divisae"); 
				break;	
				case "3":
						desabitarBotonesCuenta(2);
						data="fisica";
						peticionAjax(url,data,msj,div,"#divisae"); 
					break;	
				case "4":
						desabitarBotonesCuenta(2);
						data="fisica";
						peticionAjax(url,data,msj,div,"#divisae"); 
					break;	
				case "5":
						desabitarBotonesCuenta(2);
						data="virtual";
						peticionAjax(url,data,msj,div,"#divisae"); 
					break;	
				case "7":
							desabitarBotonesCuenta(2);
							data="virtual";
							peticionAjax(url,data,msj,div,"#divisae"); 
				break;
			}
}
function divisaSelectEditar(){
	$("#formularioe").removeAttr("disabled");	
	var codigo =$("#bancoe option:selected").data('cod');
	var codigo2 =$("#divisae option:selected").data('cod');
	$("#numCuentae").removeAttr("disabled");
	$("#montoCuentae").removeAttr("disabled");
	$("#codigoBe").val(codigo);
	$("#tce").html(codigo);
	//$("#tse").html(codigo2);
}
$('.eliminar_cuenta').on('show.bs.modal', function (e) {
	var rowid = $(e.relatedTarget).data('idcuenta');
	$("#btn-ec").attr("disabled");
	$.ajax({
		type : 'post',
		url : '?c=app&a=data_eliminar',
		data :  'id='+ rowid,
		beforeSend: function(){
			$(".data_ec").html('<div class="alert alert-info text-center" >Por Favor Espere...<br><img src="assets/img/pagoss.gif"></div>');
		},
		error: function() {
			$(".data_ec").html('<div class="alert alert-danger text-center" >Ha Ocurrido Un Error</div>');
		},
		success : function(data){
			$(".data_ec").html(data);
		}
	});
 });

 $("#form_ec").submit(function(e) {
	e.preventDefault();
	var datos = $("#form_ec").serialize();
	$.ajax({
		type: "POST",
		url: "?c=app&a=eliminar_cuenta",
		data: datos,
		beforeSend: function() {
			$("#rep_ec").html(
				'<div class="alert alert-info text-center" >Eliminado Cuenta Por Favor Espere...<br><img src="assets/img/pagoss.gif"></div>'
			);
		},
		error: function() {
			$("#rep_ec").html(
				'<div class="alert alert-danger text-center" >Ha Ocurrido Un Error</div>'
			);
		},
		success: function(data) {
			$("#rep_ec").html(data);
		}
	});
	return false;
});
$('.ad_cuenta').on('show.bs.modal', function (e) {
	var rowid = $(e.relatedTarget).data('idcuenta');
	$("#btn-adc").attr("disabled");
	$.ajax({
		type : 'post',
		url : '?c=app&a=data_inactivar',
		data :  'id='+ rowid,
		beforeSend: function(){
			$(".data_ad").html('<div class="alert alert-info text-center" >Por Favor Espere...<br><img src="assets/img/pagoss.gif"></div>');
		},
		error: function() {
			$(".data_ad").html('<div class="alert alert-danger text-center" >Ha Ocurrido Un Error</div>');
		},
		success : function(data){
			$(".data_ad").html(data);
		}
	});
 });

 $(".form_ad").submit(function(e) {
	e.preventDefault();
	var datos = $("#form_ad").serialize();
	$.ajax({
		type: "POST",
		url: "?c=app&a=ad_cuenta",
		data: datos,
		beforeSend: function() {
			$("#rep_ad").html(
				'<div class="alert alert-info text-center" > Por Favor Espere...<br><img src="assets/img/pagoss.gif"></div>'
			);
		},
		error: function() {
			$("#rep_ad").html(
				'<div class="alert alert-danger text-center" >Ha Ocurrido Un Error</div>'
			);
		},
		success: function(data) {
			$("#rep_ad").html(data);
		}
	});
	return false;
});
/*******************************************************Movimients*******************************/
function tablaMovimiento() {
	$("#tablaMovimiento").DataTable({
		destroy: true,
		dom: "Bfrtip",
		paging: true,
      	lengthChange: true,
      	searching: true,
      	ordering: true,
      	info: false,
		autoWidth: true,
		scrollX: false,
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
			{
				extend: 'excelHtml5',
				text: 'Exportar a Excel',
				className: 'btn btn-success text-center d-none',
				header: true,
				exportOptions: {
					columns: [0, 1, 2, 3, 4, 5],
					orthogonal: 'sort'
				},
				customizeData: function ( data ) {
					for (var i=0; i<data.body.length; i++){
						for (var j=0; j<data.body[i].length; j++ ){
							data.body[i][j] = '\u200C' + data.body[i][j];
						}
					}
				}     
				
			},
			{
				extend: 'csv',
				text: 'Exportar a csv',
				className: 'btn btn-warning text-center d-none',
				header: true,
				exportOptions: {
					columns: [0, 1, 2, 3, 4, 5]
				}
			},
			{
				extend: 'pdf',
				header: true,
				text: 'Exportar a pdf',
				className: 'btn btn-danger text-center d-none',
				exportOptions: {
					columns: [0, 1, 2, 3, 4, 5]
					
				}
			},
			{
				extend: 'print',
				header: true,
				text: 'Imprimir',
				className: 'btn btn-info text-center d-none',
				exportOptions: {
					columns: [0, 1, 2, 3, 4, 5]
					
				}
			},
		],
		ajax: {
			type: "GET",
			dataType: "json",
			url: "index.php?c=app&a=dataTablaMovimiento"
		},
		columnDefs: [
			{ responsivePriority: 1, targets: 0 },
			{ responsivePriority: 10001, targets: 4 },
            { responsivePriority: 2, targets: 5 }
        ],
		aoColumns: [
			{
				render: function(data, type, row) {
					var fech = row.fechmovimiento.split(" ");
					var fecha = fech[0]
						.split("/")
						.reverse()
						.join("-");
					return fecha;
				},
				className: "text-center"
			},
			{ data: "nombrebanco", className: "text-center" },
			{ data: "titulocategoria", className: "d-none d-md-none d-lg-table-cell text-center" },
			{ data: "referenciamovimiento", className: "" },
			{ data: "descripcionmovimiento", className: "d-none d-md-none d-lg-table-cell text-left" },
			{
				render: function(data, type, row) {
					return row.montomovimiento;
				},
				className: "text-right"
			},
			{
				render: function(data, type, row) {
					return (
						'<div class="btn-group" role="group" aria-label="Basic example"> <button class="btn detallemov btn-sm" title="Detalle de la cuenta" data-toggle="modal" data-target="#c_movimiento" data-id=' +
						row.idmovimiento +
						'><i class="fa fa-info"></i></button>' 
					);
				},
				className: "text-center"
			}
		],

		initComplete: function () {

			this.api().columns([0]).every(function () {

				var text = $(this).text();
				var column = this;
				var html = $('<input class="taminput " type="date" name="buscarFecha" id="buscarFechan" onkeypress="return exprePersonal(event)">')
					.appendTo($(column.footer()).empty());
				;
			});

			this.api()
				.columns([1])
				.every(function () {
					var column = this;
					var select = $('<select class="tamselect"  onchange="info_saldo(this)"> <option value=""> </option></select>')
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


				
			this.api().columns([3]).every(function () {

				var text = $(this).text();
				var column = this;
				var html = $('<input class="taminput " type="text" name="buscarReferencia" id="buscarReferencia" onkeypress="return exprePersonal(event) placeholder="' + text + '">')
					.appendTo($(column.footer()).empty());
				;
			});

			this.api().columns([4]).every(function () {

				var text = $(this).text();
				var column = this;
				var html = $('<input class="taminput " type="text" name="buscarDescripcion" id="buscarDescripcion" onkeypress="return exprePersonal(event) placeholder="' + text + '">')
					.appendTo($(column.footer()).empty());
				;
			});


			this.api()
				.columns([5, 6])
				.every(function () {
					var column = this;
					var html = $('<p class="text-center"> - </p>')
						.appendTo($(column.footer()).empty())
				});

			this.api()
				.columns([0, 3, 4])
				.every(function () {
					var column = this;
					var select = $('input', this.footer())
						.on("keyup change", function () {
							if (column.search() !== this.value) {
								column.search(this.value).draw();
							}

						});

				});

			/*Exportacion de archivos*/
			var $buttons = $('.dt-buttons').hide();
			$('#excel').on('click', function() {
				var btnClass = this.id 
				? '.buttons-' + this.id 
				: null;
			 if (btnClass) $buttons.find(btnClass).click(); 
			})
			$('#csv').on('click', function() {
				var btnClass = this.id 
				? '.buttons-' + this.id 
				: null;
			 if (btnClass) $buttons.find(btnClass).click(); 
			})
			$('#pdf').on('click', function() {
				var btnClass = this.id 
				? '.buttons-' + this.id 
				: null;
			 if (btnClass) $buttons.find(btnClass).click(); 
			})
			$('#print').on('click', function() {
				var btnClass = this.id 
				? '.buttons-' + this.id 
				: null;
			 if (btnClass) $buttons.find(btnClass).click(); 
			})

			//Exportacion de archivos Responsive



		}

	});
}
function info_saldo(id){
	//$("#info_c").html(id.value);
	$.ajax({
		type: "POST",
		url: "?c=app&a=saldo_cuentas",
		data:{id:  JSON.stringify(id.value)},

		beforeSend: function() {
			console.log("consultando");
		},
		error: function() {
			console.log("error");
		},
		success: function(data) {
			$("#res_mon").html(data);
		}
	});
}
 $('#c_movimiento').on('show.bs.modal', function (e) {
	$("#btn-cm").attr("disabled");
	var rowid = $(e.relatedTarget).data('id');
	$.ajax({
		type: 'post',
		url: '?c=app&a=detalle_movimiento',
		data: 'id=' + rowid,
		beforeSend: function () {
			$("#cuepo_rep2").html('<div class="alert alert-info text-center">Consultando Movimiento Bancario<br><img src="assets/img/pagoss.gif"></dvi>');
		},
		error: function () {
			$("#cuepo_rep2").html('<div class="alert alert-danger text-center">Ha ocurrido un error en el sistema</div>');
		},
		success: function (data) {
			$('#cuepo_rep2').html(data);
			$("#btn-cm").removeAttr("disabled");
		}
	});
});
$("#form_mov").submit(function(e) {
	e.preventDefault();
	var datos = $("#form_mov").serialize();
	$.ajax({
		type: "POST",
		url: "?c=app&a=modificar_mov",
		data: datos,
		beforeSend: function() {
			$("#rep_ad").html(
				'<div class="alert alert-info text-center msj_margen" >Guardando Cuentas</div>'
			);
		},
		error: function() {
			$("#rep_ad").html(
				'<div class="alert alert-danger">Oops, Estimado Usuario Ha Ocurrido Un Error<br>Intente Nuevamente </div>'
			);
		},
		success: function(data) {
			$("#rep_ad").html(data);
		}
	});
	return false;
});

//************************************************************cuentas************************************************
//************************************************************Importar************************************************
$('#importar').on('show.bs.modal', function (e) {
	$("#btn-im").attr("disabled");
	var rowid = $(e.relatedTarget).data('id');
	$.ajax({
		type: 'post',
		url: '?c=app&a=importar_csv',
		data: 'id=' + rowid,
		beforeSend: function () {
			$("#cuepo_impo").html('<div class="alert alert-info text-center">Por Favor Espere...<br><img src="assets/img/pagoss.gif"></dvi>');
		},
		error: function () {
			$("#cuepo_impo").html('<div class="alert alert-danger text-center">Ha ocurrido un error en el sistema</div>');
		},
		success: function (data) {
			$('#cuepo_impo').html(data);
			$("#btn-im").removeAttr("disabled");
		}
	});
});
$("#form_imp").on("submit", function(e) {
	e.preventDefault();
	var f = $(this);
	var formData = new FormData(document.getElementById("form_imp"));
	formData.append(f.attr("name"), $(this)[0][2].files[0]);
	$.ajax({
		type: "post",
		url: "?c=app&a=cargarCSVSubir",
		dataType: "html",
		data: formData,
		cache: false,
		contentType: false,
		processData: false,
		beforeSend: function () {
			$("#rep_im").html('<div class="alert alert-info text-center">Espere un momento, por favor<br><img src="assets/img/pagoss.gif"></dvi>');
		},
		error: function () {
			$("#rep_im").html('<div class="alert alert-danger text-center">Ha ocurrido un error en el sistema</div>');
		},
		success: function(data) {
			$("#rep_im").html(data);
		}
	});
});
function activarCampoCVG(id) {
	if (id.value === "-1") {
		$("#carga").attr("disabled");
		$("#inputc").attr("disabled");
	} else {
		$("#carga").removeAttr("disabled");
		$("#inputc").removeAttr("disabled");
	}
}
$('#eliminar_reporte').on('show.bs.modal', function (e) {
	var rowid = $(e.relatedTarget).data('id');
	$("#id_e").val(rowid);
	console.log(rowid);
    $("#btn-ec").attr("disabled");
	$.ajax({
		type : 'post',
		url : '?c=app&a=c_reporte',
		data :  'id='+ rowid,
		beforeSend: function(){
			$("#data_e_rep").html('<div class="alert alert-info text-center" >Por Favor Espere...<br><img src="assets/img/pagoss.gif"></div>');
		},
		error: function() {
			$("#data_e_rep").html('<div class="alert alert-danger text-center" >Ha Ocurrido Un Error</div>');
		},
		success : function(data){
            $("#btn-er2").removeAttr("disabled");
			$("#data_e_rep").html(data);
		}
	});
 });
 $("#form_ec_2").submit(function(e) {
	e.preventDefault();
	var datos = $("#form_ec_2").serialize();
	$.ajax({
		type: "POST",
		url: "?c=app&a=eliminar_rep",
		data: datos,
		beforeSend: function() {
			$("#dat_er").html(
				'<div class="alert alert-info text-center" >Eliminado Cuenta Por Favor Espere...<br><img src="assets/img/pagoss.gif"></div>'
			);
		},
		error: function() {
			$("#dat_er").html(
				'<div class="alert alert-danger text-center" >Ha Ocurrido Un Error</div>'
			);
		},
		success: function(data) {
			$("#dat_er").html(data);
			cargarreporte();
		}
	});
	return false;
});
//************************************************************Importar************************************************