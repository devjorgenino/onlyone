<?php
require_once 'model/model.login.php';

class Home_Controller
{

	private $model;

	public function __CONSTRUCT()
	{
		$this->model = new Home_Model();
	}
	public function index()
	{
		require_once 'view/header2.php';
		require_once 'view/login.php';
		require_once 'view/footer.php';
	}

	public function login()
	{
		if (isset($_REQUEST['nnombre']) and  isset($_REQUEST['npassword'])) :
			$this->model->referencia = $_REQUEST['nnombre'];
			$this->model->passwd = $_REQUEST['npassword'];
			$this->res = $this->model->login();
			if ($this->res == -1) :
				echo '<p class="text-center alert alert-danger">Credenciales Inválidas</p>';
			else :
				session_name("onlyone");
				session_start();
				$_SESSION['usuario'] = $this->res[0]['empresa'];
				$_SESSION['nombre'] = $this->res[0]['nombre'];
				echo '<p class="text-center alert alert-success">Usuario Válido...</p>';
				echo '<script>setTimeout(function () {
						window.location.href = "?c=app&a=dashboard";
				}, 1000);</script>';
			endif;
		else :
			echo '<p class="text-center alert alert-danger">Credenciales Inválidas</p>';
		endif;
	}
	public function recuperar_clave()
	{

		$res = $this->model->recuperar_clave($_REQUEST['usuario']);
		if ($res != -1) :
			$res = $this->notificaciones($res[0]['email'], "Recuperacion de Clave", "http://vps1.geekhack.net.ve/alpha/onlyone", "Usuario " . $res[0]['referencia'] . " Clave " . $res[0]['passwd']);
			if ($res != -1) :
				$this->alertas(1, ' Hemos enviado la Contraseña a su Correo Electronico');
				echo '<script>
								cargarCuenta();
								setTimeout(function() {
									$(".recuperar").modal("hide");
									LimpiarFC();
								}, 3000);
								</script>';
			else :
				$this->alertas(3, ' Ha Ocurrido Un  error al Enviar Email');
			endif;
		else :
			$this->alertas(2, ' Usuario no Valido');
		endif;
	}
	private function alertas($id, $msj)
	{
		switch ($id) {
			case 1:
				echo  '
						<div class="alert alert-success alert-dismissible fade show text-center" role="alert">
						<strong><i class="fa fa-check"></i> Exito! </strong>' . $msj . '
						<button type="button" class="close" data-dismiss="alert" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
						</div>
						';
				break;
			case 2:
				echo  '
						<div class="alert alert-warning alert-dismissible fade show text-center" role="alert">
						<strong><i class="fas fa-exclamation-triangle"></i></strong>' . $msj . '
						<button type="button" class="close" data-dismiss="alert" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
						</div>
						';
				break;
			case 3:
				echo '
						<div class="alert alert-danger alert-dismissible fade show text-center" role="alert">
						<strong><i class="fa fa-skull-crossbones"></i> Error!</strong>' . $msj . '
						<button type="button" class="close" data-dismiss="alert" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
						</div>
						';
				break;
		}
	}
	public function notificaciones($usuario, $tipo, $enlace, $contenido)
	{
		$array = new \stdClass();
		$array->email = $usuario;
		$array->asunto = urlencode($tipo);
		$array->titulo = urlencode("Credenciales");
		$array->contenido = urlencode($contenido);
		$array->enlace = $enlace;
		$res = json_decode(file_get_contents("http://vps1.geekhack.net.ve/alpha/apppagos/email/emailPago.php?array=" . serialize($array)));
		//echo "http://vps1.geekhack.net.ve/alpha/apppagos/email/emailPago.php?array=".serialize($array);
		if ($res == 1) :
			return 1;
		else :
			return -1;
		endif;
	}

}
