$(document).ready(function() {
		$('#formLogin').submit(function(e) {
			e.preventDefault();
			var informacion=$('#formLogin').serialize();
			var metodo=$('#formLogin').attr('method');
			var peticion=$('#formLogin').attr('action');
			$.ajax({
			type: metodo,
			url: peticion,
			data:informacion,
			beforeSend: function(){
				$(".msj").html('<p class="text-center alert alert-info">Espere un momento, por favor</p>');
			},
			error: function() {
				$(".msj").html('<p class="text-center alert alert-danger">Ha Ocurrido un Error</p>');
			},
			success: function (data) {
				$(".msj").html(data);
				
			}
		});
	});

	$("#form_rc").submit(function(e) {
		e.preventDefault();
		var datos = $("#form_rc").serialize();
		$.ajax({
			type: "POST",
			url: "?c=home&a=recuperar_clave",
			data: datos,
			beforeSend: function() {
				$("#rep_rc").html(
					'<div class="alert alert-info text-center" >Eliminado Cuenta Por Favor Espere...<br><img src="assets/img/pagoss.gif"></div>'
				);
			},
			error: function() {
				$("#rep_rc").html(
					'<div class="alert alert-danger text-center" >Ha Ocurrido Un Error</div>'
				);
			},
			success: function(data) {
				$("#rep_rc").html(data);
			}
		});
		return false;
	});
});