(function ($) {
    $('img').on('error', function () {
        var image = $(this).attr('src');
        if (/(\.svg)$/i.test(image)) {
            $(this).attr('src', image.replace('.svg', '.png'));
        }
    })
})(jQuery);
$(function () {
    jQuery('img.svg').each(function () {
        var $img = jQuery(this);
        var imgID = $img.attr('id');
        var imgClass = $img.attr('class');
        var imgURL = $img.attr('src');

        jQuery.get(imgURL, function (data) {
            // Get the SVG tag, ignore the rest
            var $svg = jQuery(data).find('svg');
            // Add replaced image's ID to the new SVG
            if (typeof imgID !== 'undefined') {
                $svg = $svg.attr('id', imgID);
            }
            // Add replaced image's classes to the new SVG
            if (typeof imgClass !== 'undefined') {
                $svg = $svg.attr('class', imgClass + ' replaced-svg');
            }
            $svg = $svg.removeAttr('xmlns:a');
            // Check if the viewport is set, else we gonna set it if we can.

            if (!$svg.attr('viewBox') && $svg.attr('height') && $svg.attr('width')) {
                $svg.attr('viewBox', '0 0 ' + $svg.attr('height') + ' ' + $svg.attr('width'))
            }
            // Replace image with new SVG
            $img.replaceWith($svg);
        }, 'xml');
    });
});

function exito() {
    var elem = document.getElementById("myBar");
    var elem2 = document.getElementById("myBar3");
    var elem4 = document.getElementById("myBar5");
    var width = 1;
    var id = setInterval(frame, 20);

    function frame() {
        if (width >= 100) {
            clearInterval(id);
        } else {
            width++;
            elem.style.width = width + '%';                        
            elem.innerHTML = width * 1 + '%';
            elem2.style.width = width + '%';
            elem2.innerHTML = width * 1 + '%';
            elem4.style.width = width + '%';
            elem4.innerHTML = width * 1 + '%';
        }
    }
}

function error() {
    var elem1 = document.getElementById("myBar2");
    var elem3 = document.getElementById("myBar4");
    var width = 1;
    var id = setInterval(frame, 20);

    function frame() {
        if (width >= 100) {
            clearInterval(id);
        } else {
            width++;
            elem1.style.width = width + '%';
            elem1.innerHTML = width * 1 + '%';
            elem3.style.width = width + '%';
            elem3.innerHTML = width * 1 + '%';
        }
    }
}

$(document).ready(function () {
    $('#formInstall').submit(function (e) {
        e.preventDefault();
        var informacion = $('#formInstall').serialize();
        var metodo = $('#formInstall').attr('method');
        var peticion = $('#formInstall').attr('action');
        $.ajax({
            type: metodo,
            url: peticion,
            data: informacion,
            beforeSend: function () {
                $(".msj").html('<p class="text-center alert alert-info">Un Momento... <br> Conectando con la Base Datos</p></div>');
            },
            error: function () {
                $(".msj").html('<p class="text-center alert alert-danger">Ha Ocurrido un Error</p>');
            },
            success: function (data) {
                $(".msj").html(data);

            }
        });
    });
    $('#formInstall2').submit(function (e) {
        e.preventDefault();
        var informacion = $('#formInstall2').serialize();
        var metodo = $('#formInstall2').attr('method');
        var peticion = $('#formInstall2').attr('action');
        $.ajax({
            type: metodo,
            url: peticion,
            data: informacion,
            beforeSend: function () {
                $(".msj2").html('<p class="text-center alert alert-info">Un Momento... <br> Conectando con la Base Datos</p></div>');
            },
            error: function () {
                $(".msj2").html('<p class="text-center alert alert-danger">Ha Ocurrido un Error</p>');
            },
            success: function (data) {
                $(".msj2").html(data);

            }
        });
    });
});
function setup(){
    $('#instalar').modal('show'); 
    $('#instalar').modal({backdrop: 'static', keyboard: false})
    setTimeout(function() {
        createUser();
    }, 1000);
}
function createUser(){
    $.ajax({
		type : 'post',
        url : '?c=Install&a=configurar_user',
        
		beforeSend: function () {
			$("#user").html(estatus(1));
		},
		error: function () {
			$("#user").html(estatus(3));
		},
		success : function(data){
            console.log(data);
            if(data==="1"){
                $("#user").html(estatus(2));
                createdb();
                }else{
                $("#user").html(estatus(3));
                }
		}
	});
}
function createdb(){
    $.ajax({
		type : 'post',
        url : '?c=Install&a=configurar_db',
        
		beforeSend: function () {
			$("#db").html(estatus(1));
		},
		error: function () {
			$("#db").html(estatus(3));
		},
		success : function(data){
            if(data==="1"){
            $("#db").html(estatus(2));
            createsh();
            }else{
            $("#db").html(estatus(3));
            }
		}
	});
}
function createsh(){
    $.ajax({
		type : 'post',
        url : '?c=Install&a=configurar_sh',
        
		beforeSend: function () {
			$("#sh").html(estatus(1));
		},
		error: function () {
			$("#sh").html(estatus(3));
		},
		success : function(data){
            console.log(data);
            if(data==="1"){
            $("#sh").html(estatus(2));
            createtd();
            }else{
            $("#sh").html(estatus(3));
            }
		}
	});
}
function createtd(){
    $.ajax({
		type : 'post',
        url : '?c=Install&a=configurar_td',
        
		beforeSend: function () {
			$("#td").html(estatus(1));
		},
		error: function () {
			$("#td").html(estatus(3));
		},
		success : function(data){
            console.log(data);
            if(data==="1"){
                createvs();
            $("#td").html(estatus(2));
            }else{
            $("#td").html(estatus(3));
            }
		}
	});
}

function createvs(){
    $.ajax({
		type : 'post',
        url : '?c=Install&a=configurar_vt',
        
		beforeSend: function () {
			$("#tv").html(estatus(1));
		},
		error: function () {
			$("#tv").html(estatus(3));
		},
		success : function(data){
            console.log(data);
            if(data==="1"){
                importar_data()
            $("#tv").html(estatus(2));
            }else{
            $("#tv").html(estatus(3));
            }
		}
	});
}
function importar_data(){
    $.ajax({
		type : 'post',
        url : '?c=Install&a=importar_data',
        
		beforeSend: function () {
			$("#im").html(estatus(1));
		},
		error: function () {
			$("#im").html(estatus(3));
		},
		success : function(data){
            console.log(data);
            if(data==="1"){
            $("#im").html(estatus(2));
            terminar();
            }else{
            $("#im").html(estatus(3));
            }
		}
	});
}
function terminar(){
    $.ajax({
		type : 'post',
        url : '?c=Install&a=terminado',
        
		beforeSend: function () {
			$("#tm").html(estatus(1));
		},
		error: function () {
			$("#tm").html(estatus(3));
		},
		success : function(data){
            console.log(data);
            if(data==="1"){
            $("#tm").html(estatus(2));
            $("#rep_rc").html('<div class="alert alert-success text-center"> Queda Solo un Pago, Mano a la Obra </div>');
            setTimeout(function () {
                window.location.href = "?c=install&a=terminar";
             }, 2000);
             }else{
            $("#tm").html(estatus(3));
            }
		}
	});
}
function estatus(key){
    switch (key) {
        case 1:
            return '<span  class="badge badge-primary badge-pill"><i class="fa fa-cog fa-spin fa-1x fa-fw margin-bottom" aria-hidden="true"></i></span>';
        break;

        case 2:
            return '<span class="badge badge-success badge-pill"><i class="fa fa-1x fa-check" aria-hidden="true"></i></span>';
        break;

        case 3:
            return   '<span class="badge badge-danger badge-pill"><i class="fa fa-1x fa-exclamation-triangle" aria-hidden="true"></i></span>';
        break;
        default:
            console.log("Ha ocurrido un Error");
            break;
    }
}