<?php
require_once("model/model.app.php");

class App_Controller
{

	private $model;
	public $cuenta;
	public $p, $b;
	public $dolar;
	public $res;

	public function __CONSTRUCT()
	{
		$this->model = new App_Model();
	}


	/***************************Globales*****************************************/
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
	public function tasa_dolar()
	{
		return $this->model->tasa_dolar();
	}
	private function babge($id, $msj)
	{
		switch ($id) {
			case 1:
				return  '<a href="#" class="badge badge-info">' . $msj . '</a>';
				break;
			case 2:
				return  '<a href="#" class="badge badge-success">' . $msj . '</a>';
				break;
			case 3:
				return  '<a href="#" class="badge badge-warning">' . $msj . '</a>';
				break;
			case 4:
				return  '<a href="#" class="badge badge-danger">' . $msj . '</a>';
				break;
		}
	}
	/***************************Globales*****************************************/
	/***************************dashboard*****************************************/
	public function dashboard()
	{
		$this->seguridad();
		$this->p = $this->detalle_cuentas($_SESSION['usuario']);
		$this->b = $this->alerta_vencidos_rep($_SESSION['usuario']);
		$this->b .= $this->alerta_vencidos_cuen($_SESSION['usuario']);
		require_once 'view/header.php';
		require_once 'view/dashboard.php';
		require_once 'view/footer.php';
		echo '<script>cargargrafico()</script>';
	}
	private function detalle_cuentas($id)
	{
		$res = $this->model->conciliado_noconciliados_xbancos($id);
		$html = "";
		if ($res != -1) :
			foreach ($res as $row) :

				$html .= '<!--Imagen Bancos-->
					<div class="row ">
					<div class="">
					<img class="mercantil" src="./assets/img/' . $row['idbanco_tipo_operacion'] . '.png" >
					</div>

					<!--Saldo Bancos-->
					<div class="ml-3 card_cuenta">
					<div>
						<div>
					
							<p class="marginp" allign="justify">Pagos Recibidos:&nbsp;&nbsp;&nbsp; Bs. ' . number_format($row['total'], 2, ',', '.') . '</p>
					
					
							<p class="marginp" allign="justify">Pagos Conciliados: Bs. ' . number_format($row['total_2'], 2, ',', '.') . '</p>
					
					
							<p class="marginp" allign="justify">Pagos Pendientes:&nbsp; Bs. ' . number_format($row['total_3'], 2, ',', '.') . '</p>
					
						</div>
					</div>
					</div><!--Saldo Bancos-->
					</div><br>';

			endforeach;
			return $html;
		else :
			return '<div class="alert alert-warning alert-dismissible fade show text-center" role="alert">
				<strong><i class="fas fa-exclamation-triangle"></i></strong>No existe reporte de pagos registrados
				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
				</div>';
		endif;
	}
	private function alerta_vencidos_rep($id)
	{
		$res = $this->model->reporte_vencidos($id);
		$html = "";
		if ($res != -1) :
			foreach ($res as $row) :
				$html .= '<div class="alert alert-warning alert-dismissible fade show text-center" role="alert">
						<strong><i class="fas fa-exclamation-triangle"></i></strong> El registro de Pago Nro. 0000000' . $row['id'] . ' Tiene más de 48  horas sin  ser conciliado
						<button type="button" class="close" data-dismiss="alert" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
						</div>';
			endforeach;
			return $html;
		else :
			return '<div class="alert alert-success alert-dismissible fade show text-center" role="alert">
				<strong><i class="fa fa-check"></i> Exito! </strong>Sin Novedad
				<button type="button" class="close" data-dismiss="alert" aria-label="Close">
				<span aria-hidden="true">&times;</span>
				</button>
				</div>';
		endif;
	}
	private function alerta_vencidos_cuen($id)
	{
		$res = $this->model->consultarCuenta_v($id);
		$html = "";
		if ($res != -1) :
			foreach ($res as $row) :
				$html .= '<div class="alert alert-info alert-dismissible fade show text-center" role="alert">
						<strong><i class="fas fa-exclamation-triangle"></i></strong> La  cuenta Nro. ' . $row['referencia'] . 'Tiene más de 48 horas sin ser Actualizada
						<button type="button" class="close" data-dismiss="alert" aria-label="Close">
						<span aria-hidden="true">&times;</span>
						</button>
						</div>';
			endforeach;
			return $html;
		else :
			return '';
		endif;
	}
	public function datos_graficos()
	{
		$this->seguridad();
		$res = $this->model->conciliado_noconciliados($_SESSION['usuario']);
		if ($res != -1) :
			$res[0]['total_re'] = ($res[0]['total_rep'] * 100) / ($res[0]['total_rep'] + $res[1]['total_rep']);
			$res[1]['total_re'] = ($res[1]['total_rep'] * 100) / ($res[0]['total_rep'] + $res[1]['total_rep']);
			$res[0]['total_re'] = number_format($res[0]['total_re'], 2, ',', '.');
			$res[1]['total_re'] = number_format($res[1]['total_re'], 2, ',', '.');
			$res[0]['monto_rep'] = 'Bs ' . number_format($res[0]['monto_rep'], 2, ',', '.');
			$res[1]['monto_rep'] = 'Bs ' . number_format($res[1]['monto_rep'], 2, ',', '.');
			$res[0]['total_re'] = str_replace(',', '.', $res[0]['total_re']);
			$res[1]['total_re'] = str_replace(',', '.', $res[1]['total_re']);
			$res[0]['tipo'] = ucwords($res[0]['tipo']);
			$res[1]['tipo'] = ucwords($res[1]['tipo']);
			echo json_encode($res);
		else :
			echo json_encode($res);
		endif;
	}
	/***************************dashboard*****************************************/
	/***************************Cuentas*****************************************/
	public function cuentas()
	{
		$this->seguridad();
		require_once 'view/header.php';
		$this->b = $this->model->cargarBancos();
		$this->p = $this->model->BuscarProductos();
		require_once 'view/view.cuentas.php';
		require_once 'view/footer.php';
		echo '<script> cargarCuenta();</script>';
	}
	public function cargarCuentas()
	{
		session_name("onlyone");
		session_start();
		$data = $this->model->consultarCuenta($_SESSION['usuario']);
		for ($i = 0; $i < count($data); $i++) {
			$data[$i]['saldo'] = number_format($data[$i]['saldo'], 2, ',', '.');
		}

		echo '{ "data":' . json_encode($data) . '}';
	}
	public function consultarMaestros()
	{
		$html = "";
		$b = $this->model->cargarBancosTipo($_REQUEST['id']);
		if ($this->b = -1) :
			$html .= "<option value='' >Selecione</option>";
			foreach ($b as $r) :
				$html .= '<option value="' . $r['id'] . '" data-cod="' . $r['codigo'] . '">' . ucwords($r['razon_comercial']) . '</option>';
			endforeach;
		else :
			return $html = -1;
		endif;
		print_r($html);
	}
	public function consultarMaestrosD()
	{
		$html =  new \stdClass();
		$b = $this->model->cargarDivisaTipo($_REQUEST['id']);
		if ($this->b = -1) :
			$html->data = "";
			$html->data .= "<option value='' >Selecione</option>";
			foreach ($b as $r) :
				$html->data .= '<option value="' . $r['id'] . '" data-cod="' . $r['simbolo'] . '">' . ucwords($r['nombre']) . '</option>';
			endforeach;
		else :
			return $html->data = -1;
		endif;

		echo json_encode($html);
	}
	public function registrar_cuenta()
	{
		session_name("onlyone");
		session_start();
		if (empty($_REQUEST['tipoCuenta']) or empty($_REQUEST['montoCuenta']) or empty($_REQUEST['banco']) or empty($_REQUEST['numCuenta']) or empty($_REQUEST['divisa']) or empty($_REQUEST['codigoB'])) :
			echo $this->alertas(2, "Faltan Datos");
		else :
			$res = $this->model->validar_cuenta($_REQUEST, $_SESSION['usuario']);
			if ($res == -1) :
				if (intval($_REQUEST['numCuenta']) == 0) :
					echo $this->alertas(2, "Error Numero Cuenta No Valido");
				else :
					$_REQUEST['montoCuenta'] = str_replace('.', '', $_REQUEST['montoCuenta']);
					$_REQUEST['montoCuenta'] = str_replace(',', '.', $_REQUEST['montoCuenta']);
					$res = $this->model->registrar_cuenta($_REQUEST, $_SESSION['usuario']);
					if ($res = 1) :
						echo $this->alertas(1, "Cuenta Registrada");
						echo '<script>
								cargarCuenta();
								setTimeout(function() {
									$(".productos").modal("hide");
									LimpiarFC();
								}, 5000);
							</script>';
					else :
						echo $this->alertas(3, "Ha Ocurrido un Error");
					endif;
				endif;
			else :
				echo $this->alertas(2, " La Información de la cuenta fue Registrada Satisfactoriamente");
			endif;
		endif;
	}
	public function modificarProductos()
	{
		$data = new \stdClass();
		if (empty($_REQUEST['id'])) {
			$data->resp = -1;
		} else {
			$res = $this->model->BuscarCuentasDetalle($_REQUEST['id']);
			if ($res == -1) :
				$data->resp = -1;
			else :
				$data->resp = 1;
				$data->p = "";
				$data->b = "";
				$data->d = "";
				$resc = $this->model->BuscarProductos();
				if ($res != 1) :
					foreach ($resc as $r) {
						$data->p .= $r['id'] ==  $res[0]['tipo'] ? '<option value="' . $r['id'] . '" selected >' . ucwords($r['nombre']) . '</option>' : '<option value="' . $r['id'] . '">' . ucwords($r['nombre']) . '</option>';
					} else :
					$data->resp = -3;
				endif;
				$resc = $this->model->cargarBancosTipo($res[0]['tipo_bancos']);
				if ($res != 1) :
					foreach ($resc as $r) {
						$data->b .= $r['id'] ==  $res[0]['banco'] ? '<option value="' . $r['id'] . '" data-cod="' . $r['codigo'] . '" selected>' . ucwords($r['razon_comercial']) . '</option>' : '<option value="' . $r['id'] . '" data-cod="' . $r['codigo'] . '">' . ucwords($r['razon_comercial']) . '</option>';
					} else :
					$data->resp = -3;
				endif;
				$resc = $this->model->cargarDivisaTipo($res[0]['tipo_divisa']);
				if ($res != 1) :
					foreach ($resc as $r) {
						$data->d .= $r['id'] ==  $res[0]['divisa'] ? '<option value="' . $r['id'] . '" data-cod="' . $r['simbolo'] . '" selected>' . ucwords($r['nombre']) . '</option>' : '<option value="' . $r['id'] . '" data-cod="' . $r['simbolo'] . '">' . ucwords($r['nombre']) . '</option>';
					} else :
					$data->resp = -3;
				endif;
				$data->n = $res[0]['cuentareal'];
				$data->s = number_format(floatval($res[0]['saldo']), 2, ',', '.');
			endif;
		}
		echo (json_encode($data));
	}
	public function ModificarCuenta()
	{
		session_name("onlyone");
		session_start();
		if (empty($_REQUEST['tipoCuentaE']) or empty($_REQUEST['montoCuentae'])  or empty($_REQUEST['id']) or empty($_REQUEST['bancoe']) or empty($_REQUEST['numCuentae']) or empty($_REQUEST['divisae']) or empty($_REQUEST['codigoBe'])) :
			echo $this->alertas(2, "Faltan Datos");
		else :
			$res = $this->model->validar_cuenta_editar($_REQUEST, $_SESSION['usuario']);
			if ($res == -1) :
				if (intval($_REQUEST['numCuentae']) == 0) :
					echo $this->alertas(2, "Error Numero Cuenta No Valido");
				else :
					$_REQUEST['montoCuentae'] = str_replace('.', '', $_REQUEST['montoCuentae']);
					$_REQUEST['montoCuentae'] = str_replace(',', '.', $_REQUEST['montoCuentae']);
					$res = $this->model->modificar_cuenta($_REQUEST, $_SESSION['usuario']);
					if ($res > 0) :
						echo $this->alertas(1, " Información Actualizada Satisfactoriamente");
						echo '<script>
												cargarCuenta();
												setTimeout(function() {
													$(".editarCuenta").modal("hide");
													LimpiarFC();
												}, 5000);
											</script>';
					else :
						echo $this->alertas(3, "Ha Ocurrido un Error");
					endif;
				endif;
			else :
				echo $this->alertas(2, "Cuenta Ya Registrada");
			endif;
		endif;
	}
	public function data_eliminar()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->consultarCuenta_id($_REQUEST, $_SESSION['usuario']);
		if ($res != -1) :
			$res[0]['fecha_creacion'] = new DateTime($res[0]['fecha_creacion']);
			$res[0]['fecha_creacion'] = $res[0]['fecha_creacion']->format('Y-m-d H:i:s');
			echo
				'<input type="hidden" name="id" value="' . $res[0]['id'] . '">
						<div class="row">
							<div class="col-md-12 col-sm-12">
								<div class="alert alert-danger text-center" role="alert">
								¿Desea Eliminar el Productos?
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label for="inpuCuenta" class="col-sm-5 col-form-label"><i class="fa fa-university" aria-hidden="true"></i>Banco: </label>
							<div class="col-sm-7">
							<input type="text" class="form-control" value="' . $res[0]['nombre'] . '" readonly>
							</div>
						</div>

						<div class="form-group row">
							<label for="inpuCuenta" class="col-sm-5 col-form-label"><i class="fa fa-university" aria-hidden="true"></i>Numero Cuenta: </label>
							<div class="col-sm-7">
							<input type="text" class="form-control" value="' . $res[0]['referencia'] . '" readonly>
							</div>
						</div>
						<div class="form-group row">
							<label for="inputFecha" class="col-sm-5 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
								Fecha Registro: </label>
							<div class="col-sm-7">
								<input type="text"  class="form-control" value="' . $res[0]['fecha_creacion'] . '"  readonly>
							</div>
						</div>';
			echo '<script>$("#btn-ec").removeAttr("disabled");</script>';
		else :
			echo $this->alertas(3, " Ha Ocurrido un Error");
		endif;
	}
	public function eliminar_cuenta()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->eliminar_cuenta($_REQUEST, $_SESSION['usuario']);
		if ($res == 1) :
			echo $this->alertas(1, " Cuenta Eliminada");
			echo '<script>
						cargarCuenta();
						setTimeout(function() {
							$(".eliminar_cuenta").modal("hide");
							$("#rep_ec").html("");
						}, 5000);
				 </script>';
		else :
			echo $this->alertas(3, " Ha Ocurrido un Error");
		endif;
	}
	public function data_inactivar()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->consultarCuenta_id($_REQUEST, $_SESSION['usuario']);
		if ($res != -1) :
			$res[0]['fecha_creacion'] = new DateTime($res[0]['fecha_creacion']);
			$res[0]['fecha_creacion'] = $res[0]['fecha_creacion']->format('Y-m-d H:i:s');
			echo
				'<input type="hidden" name="id" value="' . $res[0]['id'] . '">
					 <input type="hidden" name="estatus" value="' . $res[0]['estatus'] . '">
						<div class="row">
							<div class="col-md-12 col-sm-12">
								<div class="alert alert-info text-center" role="alert">';
			if ($res[0]['estatus'] == 1) :
				echo '¿Desea  Inactivar Cuenta?';
			else :
				echo '¿Desea  Activar Cuenta?';
			endif;
			echo '
								</div>
							</div>
						</div>
						<div class="form-group row">
							<label for="inpuCuenta" class="col-sm-5 col-form-label"><i class="fa fa-university" aria-hidden="true"></i>Banco: </label>
							<div class="col-sm-7">
							<input type="text" class="form-control" value="' . $res[0]['nombre'] . '" readonly>
							</div>
						</div>

						<div class="form-group row">
							<label for="inpuCuenta" class="col-sm-5 col-form-label"><i class="fa fa-university" aria-hidden="true"></i>Numero Cuenta: </label>
							<div class="col-sm-7">
							<input type="text" class="form-control" value="' . $res[0]['referencia'] . '" readonly>
							</div>
						</div>
						<div class="form-group row">
							<label for="inputFecha" class="col-sm-5 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
								Fecha Registro: </label>
							<div class="col-sm-7">
								<input type="text"  class="form-control" value="' . $res[0]['fecha_creacion'] . '"  readonly>
							</div>
						</div>';
			echo '<script>$("#btn-adc").removeAttr("disabled");</script>';
		else :
			echo $this->alertas(3, " Ha Ocurrido un Error");
		endif;
	}
	public function ad_cuenta()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->modificar_estatus($_REQUEST, $_SESSION['usuario']);
		if ($res == 1) :
			if ($_REQUEST['estatus'] == 1) :
				echo $this->alertas(1, " Cuenta Inactivada");
			else :
				echo $this->alertas(1, " Cuenta Activa");
			endif;
			echo '<script>
						cargarCuenta();
						setTimeout(function() {
							$(".ad_cuenta").modal("hide");
							$("#rep_ad").html("");
						}, 5000);
				 </script>';
		else :
			echo $this->alertas(3, " Ha Ocurrido un Error");
		endif;
	}
	/***************************Cuentas*****************************************/
	/***************************Movimientos*************************************/
	public function movimientos()
	{
		$this->seguridad();
		$this->sc = $this->model->totalSaldoCuentas($_SESSION['usuario']);
		$this->dolar = $this->tasa_dolar();
		require_once 'view/header.php';
		require_once 'view/view.movimientos.php';
		require_once 'view/footer.php';
		echo '<script> tablaMovimiento();</script>';
	}
	public function dataTablaMovimiento()
	{
		session_name("onlyone");
		session_start();
		$data = $this->model->cargarMovimientos($_SESSION['usuario']);
		echo '{ "data":' . $data . '}';
	}
	public function detalle_movimiento()
	{
		session_name("onlyone");
		session_start();
		$html = "";
		$res = $this->model->consultarMovimiento($_REQUEST['id']);
		if ($res != -1) :
			$sub = $this->model->listar_SubCategoria($res[0]['tipo']);
			$html = '
						<input type="hidden" name="idMovimiento" id="id" value="' . $_REQUEST['id'] . '">
							<div class="container">
							<div class="form-group row">
								<label for="inpuCuenta" class="col-sm-4 col-form-label"><i class="fa fa-university"
										aria-hidden="true"></i>
									Banco: </label>
								<div class="col-sm-8">
								<input type="text" class="form-control" value="' . ucwords($res[0]['razon_social']) . '" readonly>
								</div>
							</div>
							<div class="form-group row">
								<label for="inpuCuenta" class="col-sm-4 col-form-label"><i class="fa fa-university"
										aria-hidden="true"></i>
									Cuenta: </label>
								<div class="col-sm-8">
								<input type="text" class="form-control" value="' . $res[0]['cuenta'] . '" readonly>
								</div>
							</div>
								<div class="form-group row">
									<label for="inputFecha" class="col-sm-4 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
										Categoria: </label>
									<div class="col-sm-8">
										<input type="text"  class="form-control" value="' . $res[0]['titulo'] . '"  readonly>
									</div>
								</div>
								<div class="form-group row">
								<label for="inputFecha" class="col-sm-4 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
									Sub Categoria: </label>
								<div class="col-sm-8">
								<select class="custom-select form-control" id="subCategoria" name="subCategoria">';
			foreach ($sub as $r) {
				if ($r['id'] == $array[0]['idsubcategoria']) :
					$html .= '<option value="' . $r['id'] . '" selected>' . ucwords($r['titulo']) . '</option>';
				else :
					$html .=   '<option value="' . $r['id'] . '">' . ucwords($r['titulo']) . '</option>';
				endif;
			}
			$html .= '
									</select>
								</div>
							</div>
								<div class="form-group row">
								<label for="inputFecha" class="col-sm-4 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
									Nota: </label>
								<div class="col-sm-8">
								<input type="text" class="form-control" id="notaSub" name="notaSub" onkeypress="return letraNumero(event)" placeholder="Nota" value="' . $res[0]['nota'] . '">
								</div>
							</div>

							<div class="form-group row">
								<label for="inputNumeroOperacion" class="col-sm-4 col-form-label"><i class="fa fa-info-circle"
										aria-hidden="true"></i>
									Referencia: </label>
									<div class="col-sm-8">
									<div class="input-group">
									<input type="text"  class="form-control" value="' . $res[0]['referencia'] . '"  readonly>
								</div>
								</div>
							</div>

							<div class="form-group row">
								<label for="inputMontoBs" class="col-sm-4 col-form-label"><i class="far fa-money-bill-alt"
										aria-hidden="true"></i>
									Monto Bs.:
								</label>
								<div class="col-sm-8">
								<input type="text"  class="form-control"  value="' . number_format($res[0]['monto'], 2, ',', '.') . '" readonly>
								</div>
							</div>
							<div class="form-group row">
							<label for="inputFecha" class="col-sm-4 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
								Fecha: </label>
							<div class="col-sm-8">
								<input type="text"  class="form-control" value="' . $res[0]['fecha'] . '"  readonly>
							</div>
						</div>

					</div>
					</div><!--Aqui termina reporte de pago-->
				';
			echo $html;
		else :
			echo $this->alertas(3, " Ha Ocurrido un Error");
		endif;
	}
	public function modificar_mov()
	{
		session_name("onlyone");
		session_start();
		if (empty($_REQUEST['notaSub']) or empty($_REQUEST['subCategoria'])  or empty($_REQUEST['idMovimiento'])) :
			echo $this->alertas(2, "Faltan Datos");
		else :
			$res = $this->model->modificar_mov($_REQUEST, $_SESSION['usuario']);
			if ($res > 0) :
				echo $this->alertas(1, "Cambio Realizado");
				echo '<script>
												setTimeout(function() {
													$("#c_movimiento").modal("hide");
													$("#rep_ad").html("");
												}, 5000);
									 </script>';
			else :
				echo $this->alertas(3, "Ha Ocurrido un Error");
			endif;
		endif;
	}
	public function saldo_cuentas()
	{
		session_name("onlyone");
		session_start();
		$_REQUEST['id'] = str_replace('"', "", $_REQUEST['id']);
		if ($_REQUEST['id'] == "") :
			$res = $this->model->totalSaldoCuentas($_SESSION['usuario']);
			echo '<script>$("#cintillo").attr("style","visibility: hidden;");</script>';

		else :
			$res = $this->model->saber_cuenta(trim($_REQUEST['id']));
			$i = $res[0]['id'];
			$res = $this->model->totalSaldoCuentas_xc($_SESSION['usuario'], $res[0]['id']);
			echo '<script>
					$("#cintillo").removeAttr("style");
					$(".logo_cintinllo").attr("src","./assets/img/' . $i . '.png");					
				  </script>';
		endif;

		echo '<script>	$("#totald").html("Bs.' . number_format($res[0]['totalsc'], 2, ',', '.') . '");
						$("#totaldi").html("Bs.' . number_format($res[0]['totalsc'], 2, ',', '.') . '");
						$("#totaldif").html("Bs.0,00");</script>';
	}
	/***************************Movimientos*************************************/
	/*************************** Carga CSV *************************************/
	public function importar_csv()
	{
		session_name("onlyone");
		session_start();
		$html = "";
		$res = $this->model->consultar_cuentas($_SESSION['usuario']);
		if ($res == -1) :
			echo $this->alertas(2, " Debe Registrar Cuentas");
		else :
			$html = '
				<div class="container">
					<div class="form-group row">
						<label for="inpuCuenta" ><i class="fa fa-university" aria-hidden="true"></i>Cuenta: </label>
							<select class="form-control" name="cuenta" onchange="activarCampoCVG(this);">
							<option value="-1">Seleciones un Banco Cuenta</option>';
			foreach ($res as $b) :
				$html .= '<option value="' . $b['id'] . '">	' . ucwords($b['producto']) . ' ' . ucwords($b['razon_comercial']) . ' Nro: ' . $b['cuenta'] . '</option>';
			endforeach;
			$html .= '				
						</select>
					</div>

					<div class="form-group row">
						<label for="inpuCuenta" ><i class="fa fa-university"aria-hidden="true"></i> Txt: </label>
							<input type="file" class="form-control archivo" name="csv" id="inputc" required disabled>
					</div>
				</div>';
			echo $html;
		endif;
	}
	public function ValidarArchivo($id, $url)
	{
		$fila = trim($this->model->identificardor($url));
		switch ($id) {
			case 1:
				$pos = strpos(trim($fila), '0105');
				if ($pos === false) {
					return -1;
				} else {
					return 1;
				}
				break;

			case 2:
				return 1;
				break;

			case 3:
				return 1;
				break;

			case 4:
				return 1;
				break;

			case 6:
				return 1;
				break;

			case 8:
				return 1;
				break;

			default:
				echo 'Ha ocurrido Un Error';
				die();
				break;
		}
		echo 'valiando' . $id;
		die();
	}
	public function cargarCSVSubir()
	{
		session_name("onlyone");
		session_start();
		$this->res = $this->model->BuscarBancoId($_REQUEST['cuenta']);
		if ($_FILES['csv']['error'] == 0 and $_REQUEST['cuenta'] != "" and  $this->res != -1) {
			$url = 'csv/' . $_SESSION['usuario'] . '.csv';
			$moverCSV = copy($_FILES['csv']['tmp_name'], 'csv/' . $_SESSION['usuario'] . '.csv'); //deberia validar si se copio
			$arch = $this->ValidarArchivo($this->res[0]['banco'], $url);
			$querry = "";
			$querry2 = "";
			$querry .= "insert into bancos.movimientos (codigo,referencia,referencia_2,fecha,monto,divisa,tipo,operacion,descripcion,cuenta,usuario) values ";
			switch ($this->res[0]['banco']) {
				case 1: //banc o mercanti
					if ($arch == 1) :
						$mov = json_decode($this->model->cargarMovimientosCSVMercantil2('csv/' . $_SESSION['usuario'] . '.csv'));
					else :
						$mov = json_decode($this->model->cargarMovimientosCSVMercantil('csv/' . $_SESSION['usuario'] . '.csv'));
					endif;

					for ($i = 0; $i < count($mov); $i++) :
						if (floatval($mov[$i]->monto) >= floatval(0.00)) :
							$mov[$i]->tipo = 1;
							$subC[] = 19;
						else :
							$mov[$i]->tipo = 2;
							$subC[] = 22;
						endif;
						//$fecha = date("d-m-Y", strtotime($mov[$i]->fecha));
						$tmp = explode('/', $mov[$i]->fecha);
						if (count($tmp) < 1) :
							$tmp = explode('-', $mov[$i]->fecha);
						endif;
						$fecha = $tmp[2] . "-" . $tmp[1] . "-" . $tmp[0];
						$querry .= "('" . $mov[$i]->referencia . "','" . $mov[$i]->referencia . "','" . $mov[$i]->referencia_2 . "','" . $fecha . "'," . floatval($mov[$i]->monto) . "," . "1" . ",
								" . $mov[$i]->tipo . ",'','" . $mov[$i]->descripcion . "'," . $_REQUEST["cuenta"] . "," . $_SESSION['usuario'] . ")";
						$querry .= ",";
					endfor;
					$querry = trim($querry, ',');
					break;
				case 2: //banco banesco
					$mov = json_decode($this->model->cargarMovimientosCSVBanesco('csv/' . $_SESSION['usuario'] . '.csv'));
					for ($i = 0; $i < count($mov); $i++) {
						//print_r($movimientos[$i]);
						if (floatval($mov[$i]->monto) >= floatval(0.00)) :
							$mov[$i]->tipo = 1;
							$subC[] = 19;
						else :
							$mov[$i]->tipo = 2;
							$subC[] = 22;
						endif;
						$tmp = explode('/', $mov[$i]->fecha);
						if (count($tmp) < 1) :
							$tmp = explode('-', $mov[$i]->fecha);
						endif;
						$fecha = $tmp[2] . "-" . $tmp[1] . "-" . $tmp[0];
						$querry .= "('" . $mov[$i]->referencia . "','" . $mov[$i]->referencia . "','" . $mov[$i]->referencia_2 . "','" . $fecha . "'," . floatval($mov[$i]->monto) . "," . "1" . ",
									" . $mov[$i]->tipo . ",'" . "operacion" . "','" . $mov[$i]->descripcion . "'," . $_REQUEST["cuenta"] . "," . $_SESSION['usuario'] . ")";
						if (($i + 1) < count($mov)) :
							$querry .= ",";
						endif;
					}
					break;
				case 3: //banco bnc
					$mov = json_decode($this->model->cargarCSVBNC('csv/' . $_SESSION['usuario'] . '.csv'));
					for ($i = 0; $i < count($mov); $i++) {
						//print_r($movimientos[$i]);
						if (floatval($mov[$i]->monto) >= floatval(0.00)) :
							$mov[$i]->tipo = 1;
							$subC[] = 19;
						else :
							$mov[$i]->tipo = 2;
							$subC[] = 22;
						endif;
						$tmp = explode('/', $mov[$i]->fecha);
						if (count($tmp) < 1) :
							$tmp = explode('-', $mov[$i]->fecha);
						endif;
						$fecha = $tmp[2] . "-" . $tmp[1] . "-" . $tmp[0];
						$querry .= "('" . $mov[$i]->referencia . "','" . $mov[$i]->referencia . "','" . $mov[$i]->referencia_2 . "','" . $fecha . "'," . floatval($mov[$i]->monto) . "," . "1" . ",
									" . $mov[$i]->tipo . ",'" . "operacion" . "','" . $mov[$i]->descripcion . "'," . $_REQUEST["cuenta"] . "," . $_SESSION['usuario'] . ")";
						if (($i + 1) < count($mov)) :
							$querry .= ",";
						endif;
					}
					break;
				case 4: //banco bod
					$mov = json_decode($this->model->cargarCSVBOD('csv/' . $_SESSION['usuario'] . '.csv'));
					for ($i = 0; $i < count($mov); $i++) {
						//print_r($movimientos[$i]);
						if (floatval($mov[$i]->monto) >= floatval(0.00)) :
							$mov[$i]->tipo = 1;
							$subC[] = 19;
						else :
							$mov[$i]->tipo = 2;
							$subC[] = 22;
						endif;
						$tmp = explode('/', $mov[$i]->fecha);
						if (count($tmp) < 1) :
							$tmp = explode('-', $mov[$i]->fecha);
						endif;
						$fecha = $tmp[2] . "-" . $tmp[1] . "-" . $tmp[0];
						$querry .= "('" . $mov[$i]->referencia . "','" . $mov[$i]->referencia . "','" . $mov[$i]->referencia_2 . "','" . $fecha . "'," . floatval($mov[$i]->monto) . "," . "1" . ",
								" . $mov[$i]->tipo . ",'" . "operacion" . "','" . $mov[$i]->descripcion . "'," . $_REQUEST["cuenta"] . "," . $_SESSION['usuario'] . ")";
						if (($i + 1) < count($mov)) :
							$querry .= ",";
						endif;
					}
					break;
				case 6: //banco bancaribe
					$mov = json_decode($this->model->cargarCSVBancaribe('csv/' . $_SESSION['usuario'] . '.csv'));
					for ($i = 0; $i < count($mov); $i++) {
						//print_r($movimientos[$i]);
						if (floatval($mov[$i]->monto) >= floatval(0.00)) :
							$mov[$i]->tipo = 1;
							$subC[] = 19;
						else :
							$mov[$i]->tipo = 2;
							$subC[] = 22;
						endif;
						$tmp = explode('/', $mov[$i]->fecha);
						if (count($tmp) < 1) :
							$tmp = explode('-', $mov[$i]->fecha);
						endif;
						$fecha = $tmp[2] . "-" . $tmp[1] . "-" . $tmp[0];
						$querry .= "('" . $mov[$i]->referencia . "','" . $mov[$i]->referencia . "','" . $mov[$i]->referencia_2 . "','" . $fecha . "'," . floatval($mov[$i]->monto) . "," . "1" . ",
							" . $mov[$i]->tipo . ",'" . "operacion" . "','" . $mov[$i]->descripcion . "'," . $_REQUEST["cuenta"] . "," . $_SESSION['usuario'] . ")";
						if (($i + 1) < count($mov)) :
							$querry .= ",";
						endif;
					}
					break;
				case 8: //banco bancrecer
					$mov = json_decode($this->model->cargarCSVBancrecer('csv/' . $_SESSION['usuario'] . '.csv'));
					for ($i = 0; $i < count($mov); $i++) {
						//print_r($movimientos[$i]);
						if (floatval($mov[$i]->monto) >= floatval(0.00)) :
							$mov[$i]->tipo = 1;
							$subC[] = 19;
						else :
							$mov[$i]->tipo = 2;
							$subC[] = 22;
						endif;
						$querry .= "('" . $mov[$i]->referencia . "','" . $mov[$i]->referencia . "','" . $mov[$i]->referencia_2 . "','" . $mov[$i]->fecha . "'," . floatval($mov[$i]->monto) . "," . "1" . ",
							" . $mov[$i]->tipo . ",'" . "operacion" . "','" . $mov[$i]->descripcion . "'," . $_REQUEST["cuenta"] . "," . $_SESSION['usuario'] . ")";
						if (($i + 1) < count($mov)) :
							$querry .= ",";
						endif;
					}
					break;
				default:
					echo '<div class="alert alert-danger text-center">Error Al detectar Banco</div>';
					die();
					break;
			}
			$querry .= "ON CONFLICT (referencia,usuario,fecha,cuenta,monto) 
			DO NOTHING returning movimientos.id ;";
			$i = 0;
			$this->res = $this->model->ejecutar_sql($querry);
			$r = pg_fetch_assoc($this->res);
			if (pg_affected_rows($this->res) > 0) :
				echo '<div class="alert alert-success text-center">Movimientos importados satisfactoriamente. Total de Registros ' . pg_affected_rows($this->res) . ' </div>';
				$querry2 .= "insert into bancos.movimientos_info (id,categoria,subcategoria,nota,estatus,activo) values";
				foreach (pg_fetch_all($this->res) as $row) {
					$querry2 .= "('" . $row['id'] . "','" . $mov[$i]->tipo . "','" . $subC[$i] . "',''," . 1 . ",true)";
					$querry2 .= ",";
					$i++;
				}
				$querry2 = trim($querry2, ',') . ';';
				$this->res = $this->model->ejecutar_sql($querry2);
				$this->model->actualizarSaldo($r['id'], $row['id']);
				if (pg_affected_rows($this->res) > 0) :
					echo '<div class="alert alert-success text-center">Info Movimientos Insertados ' . pg_affected_rows($this->res) . ' </div>';
					echo '<script>
							setTimeout(function() {
								$("#importar").modal("hide");
								$("#rep_im").html("");
							}, 5000);
						</script>';
				else :
					echo '<div class="alert alert-danger text-center">Ha Ocurrido un Error al insertar info movimientos</div>';
				endif;

			else :
				echo '<div class="alert alert-warning text-center">No se encontraron Movimientos para Importar</div>';
			endif;
		} else {
			echo '<div class="alert alert-danger text-center">Debe Selecionar un Documento a Importar - Faltan Datos - Banco No Valido</div>';
		}
	}

	/*************************** Carga CSV*************************************/
	/*************************** Conciliacion *************************************/
	public function AppPagos()
	{
		$this->seguridad();
		require_once 'view/header.php';
		$this->ct_reporte(); //cargasFacturas
		require_once 'view/app/index.php';
		require_once 'view/footer.php';
	}
	public function balances()
	{
		$this->ct_reporte(); //cargasFacturas
		require_once 'view/app/balances.php';
	}
	public function ct_reporte()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->APP_ct_reporte($_SESSION['usuario']);
		$this->p = "";
		if ($res == -1) {
			$this->p .= '
						<tr>
							<td colspan="10" class="text-center">No existe Reporte de Pago</td>
						<tr>
				      ';
		} else {
			foreach ($res as $row) :
				$this->p .= '<tr>
                            <td>' . $row['id'] . '</td>
                            <td>' . $row['fecha_pago'] . '</td>
                            <td>' . ucwords($row['cuenta_detallada']) . '</td>
                            <td>' . ucwords($row['nombre']) . '</td>
                            <td class="d-none d-lg-none">' . ucwords($row['total_faturas']) . '</td>
                            <td>' . ucwords($row['numero_operacion']) . '</td>
                            <td>';
				$this->p .= $this->babge($row['estatus_rep'], ucwords($row['nombreestatus']));
				$this->p .= '<td>' . number_format($row['monto'], 2, ',', '.') . '</td>';
				if ($row['estatus_rep'] == 1) :
					$this->p .= '
                                    <td><div class="btn-group" role="group" aria-label="Basic example">
                                    <button type="button" class="btn reenviarrpago d-none btn-sm mr-1"  title="Reenviar" data-toggle="modal" data-target="#d_desarrollo" id="reenviar" data-id="' . $row['id'] . '"><i class="fa fa-book"></i></button>
                                    <button type="button" class="btn verrpago btn-sm"  title="Ver" data-toggle="modal" data-target="#c_reporte" id="ver_reporte" data-id="' . $row['id'] . '"><i class="fa fa-eye"></i></button>';
					$this->p .= $this->habilitar_eliminar($row['eliminar'], $row['id']) . '	
									
									</div></td>';
				else :
					$this->p .= '
                                    <td><div class="btn-group" role="group" aria-label="Basic example">
									<button type="button" class="btn btn-success btn-sm"  title="Ver" data-toggle="modal" data-target="#c_reporte" id="ver" data-id="' . $row['id'] . '"><i class="fa fa-eye"></i></button>
                                    </div></td>';
				endif;
				echo '
                        </tr>';
			endforeach;
		}
	}
	public function c_reporte()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->APP_c_reporte($_REQUEST['id']);
		echo '
					<div class="container">
					<div class="form-group row">
						<label for="inpuCuenta" class="col-sm-4 col-form-label"><i class="fa fa-university"
								aria-hidden="true"></i>
							Cuenta: </label>
						<div class="col-sm-8">
						<input type="text" class="form-control" value="' . $res[0]['cuenta_detallada'] . '" readonly>
						</div>
					</div>
					<div class="form-group row">
						<label for="inputFecha" class="col-sm-4 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
							Fecha: </label>
						<div class="col-sm-8">
							<input type="text"  class="form-control" value="' . $res[0]['fecha_pago'] . '"  readonly>
						</div>
					</div>

					<div class="form-group row">
						<label for="" class="col-sm-4 col-form-label"><i class="fas fa-envelope-open-text"></i>
							Facturas: </label>

						<div class="col-sm-8">
							<div class="row ">
								<div class="col-sm-6">
									<label for="numFactura" class="col-form-label">Numero de Factura:</label>
								</div>
								<div class="col-sm-6">
									<label for="Monto" class="col-form-label">Monto:</label>
								</div>
							</div>';
		foreach ($res as $row) :
			echo '
								<div class="row my-1">
									<div class="col-sm-6">
									<input type="text"  class="form-control"  value="' . $row['numero_factura'] . '"  readonly>
									</div>
									<div class="col-sm-6">
									<input type="text"  class="form-control" value="' . number_format($row['monto'], 2, ',', '.') . '" readonly>
									</div>
								</div>';
		endforeach;
		echo '		
						</div>
					</div>

					<div class="form-group row">
						<label for="inputNumeroOperacion" class="col-sm-4 col-form-label"><i class="fa fa-info-circle"
								aria-hidden="true"></i>
							Número Operación: </label>
							<div class="col-sm-8">
							<div class="input-group">
							<input type="text"  class="form-control" value="' . $res[0]['numero_operacion'] . '"  readonly>
							<div class="input-group-prepend">
							  <span class="input-group-text" id="inputGroupPrepend3">';
		if ($res[0]['movimiento'] == 0) :
			echo   '<i class="fa fa-book danger"></i></span>';
		else :
			echo   '<i class="fa fa-book danger" data-toggle="modal" data-target="#c_movimiento_c" data-id="' . $res[0]['movimiento'] . '" style="color:#3399ff"
								aria-hidden="true"></i></span>';
		endif;
		echo '
							</div>
						  </div>
						</div>
					</div>
					
					<div class="form-group row">
						<label for="gridCheck1" class="col-sm-4 col-form-label"><i class="fa fa-check"
								aria-hidden="true"></i>
							Tipo Operación:
						</label>
						<div class="col-sm-8">
						<input type="text"  class="form-control" value="' . ucwords($res[0]['tipo']) . '" readonly>
						</div>
					</div>';
		if ($res[0]['tipo_operacion'] == 2) :
			echo '<div class="form-group row">
									<label for="inputorigen" class="col-sm-4 col-form-label"><i class="fa fa-address-card"
											aria-hidden="true"></i>
											Banco Origen: </label>
									<div class="col-sm-8">
									<input type="text"  class="form-control" value="' . ucwords($res[0]['banco_o']) . '" readonly>
									</div>
								</div>';
		endif;
		echo '
					<div class="form-group row">
						<label for="inputNumero" class="col-sm-4 col-form-label"><i class="fa fa-address-card"
								aria-hidden="true"></i>
								Número de cuenta Origen: </label>
						<div class="col-sm-8">
						<input type="text"  class="form-control" value="' . ucwords($res[0]['numerocuenta']) . '" readonly>
						</div>
					</div>

					<div class="form-group row">
						<label for="inputCedula" class="col-sm-4 col-form-label"><i class="fa fa-address-card"
								aria-hidden="true"></i>
							Cédula o RIF: </label>
						<div class="col-sm-8">
							<div class="input-group mb-3">
							<input type="text"  class="form-control"  value="' . $res[0]['doc'] . '" readonly>
							</div>
						</div>
					</div>

					<div class="form-group row">
						<label for="inputNombre" class="col-sm-4 col-form-label"><i class="fa fa-address-card"
								aria-hidden="true"></i>
							Nombre: </label>
						<div class="col-sm-8">
						<input type="text"  class="form-control"  value="' . $res[0]['nombre'] . '" readonly>
						</div>
					</div>
					<div class="form-group row">
						<label for="inputEmail" class="col-sm-4 col-form-label"><i class="fas fa-envelope-open-text"></i>
							Su Correo Electrónico: </label>
						<div class="col-sm-8">
						<input type="text"  class="form-control"  value="' . $res[0]['email'] . '" readonly>
						</div>
					</div>

					<div class="form-group row">
						<label for="inputMontoBs" class="col-sm-4 col-form-label"><i class="far fa-money-bill-alt"
								aria-hidden="true"></i>
							Monto Total Bs.:
						</label>
						<div class="col-sm-8">
						<input type="text"  class="form-control"  value="' . number_format($res[0]['total'], 2, ',', '.') . '" readonly>
						</div>
					</div>
			</div>
			</div><!--Aqui termina reporte de pago-->
		';
	}
	public function c_movimiento()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->consultarMovimiento_2($_REQUEST['id']);
		if ($res != -1) :
			echo '
					<div class="container">
					<div class="form-group row">
						<label for="inpuCuenta" class="col-sm-4 col-form-label"><i class="fa fa-university"
								aria-hidden="true"></i>
							Banco: </label>
						<div class="col-sm-8">
						<input type="text" class="form-control" value="' . ucwords($res[0]['razon_social']) . '" readonly>
						</div>
					</div>
					<div class="form-group row">
						<label for="inpuCuenta" class="col-sm-4 col-form-label"><i class="fa fa-university"
								aria-hidden="true"></i>
							Cuenta: </label>
						<div class="col-sm-8">
						<input type="text" class="form-control" value="' . $res[0]['cuenta'] . '" readonly>
						</div>
					</div>
					<div class="form-group row">
						<label for="inputFecha" class="col-sm-4 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
							Fecha: </label>
						<div class="col-sm-8">
							<input type="text"  class="form-control" value="' . $res[0]['fecha'] . '"  readonly>
						</div>
					</div>
					<div class="form-group row">
					<label for="inputFecha" class="col-sm-4 col-form-label"><i class="fa fa-calendar" aria-hidden="true"></i>
						Fecha Creación: </label>
					<div class="col-sm-8">
						<input type="text"  class="form-control" value="' . $res[0]['fecha_creacion'] . '"  readonly>
					</div>
				</div>

					<div class="form-group row">
						<label for="inputNumeroOperacion" class="col-sm-4 col-form-label"><i class="fa fa-info-circle"
								aria-hidden="true"></i>
							Número Operación: </label>
							<div class="col-sm-8">
							<div class="input-group">
							<input type="text"  class="form-control" value="' . $res[0]['referencia'] . '"  readonly>
						  </div>
						</div>
					</div>
					
					<div class="form-group row">
						<label for="gridCheck1" class="col-sm-4 col-form-label"><i class="fa fa-check"
								aria-hidden="true"></i>
							Descripción:
						</label>
						<div class="col-sm-8">
						<input type="text"  class="form-control" value="' . $res[0]['descripcion'] . '" readonly>
						</div>
					</div>

					
					<div class="form-group row">
						<label for="inputMontoBs" class="col-sm-4 col-form-label"><i class="far fa-money-bill-alt"
								aria-hidden="true"></i>
							Monto Bs.:
						</label>
						<div class="col-sm-8">
						<input type="text"  class="form-control"  value="' . number_format($res[0]['monto'], 2, ',', '.') . '" readonly>
						</div>
					</div>
			</div>
			</div><!--Aqui termina reporte de pago-->
		';
		else :
			echo $this->alertas(3, " Error el movimiento no Existe");
		endif;
	}
	public function procesarConciliacion()
	{
		session_name("onlyone");
		session_start();
		switch ($_REQUEST['tipo']) {
			case '1':
				$this->conciliar($_SESSION['usuario']);
				break;
			case '2':
				echo '<script>$("#c_reportePago").modal("hide");</script>';
				echo '<script>$("#d_desarrollo").modal("show");</script>';
				break;
			case '3':
				echo '<script>$("#c_reportePago").modal("hide");</script>';
				echo '<script>$("#d_desarrollo").modal("show");</script>';
				break;

			default:
				echo 'opcion no valida';
				break;
		}
	}
	public function conciliar($usuario)
	{

		//conciliacion mismo bancos
		$res_mb = $this->model->APP_e_concialiacion($usuario);
		$total_cmb = pg_affected_rows($res_mb);
		//conciliacion mismo bancos	

		//conciliacion otros  bancos BANESCOS
		$res_obb = $this->model->conciliacion_OB_banesco($usuario);
		$total_cobb = pg_affected_rows($res_obb);
		//conciliacion otros  bancos BANESCOS

		//conciliacion otros  bancos BOD
		$res_obbod = $this->model->conciliacion_OB_bod($usuario);
		$total_cobBOD = pg_affected_rows($res_obbod);
		//conciliacion otros  bancos BOD

		//conciliacion otros  bancos BNC
		$res_obbnc = $this->model->conciliacion_OB_bnc($usuario);
		$total_cobBNC = pg_affected_rows($res_obbnc);
		//conciliacion otros  bancos BNC


		/***********************************************************/
		//conciliacion mismo bancos md
		$res = $this->model->APP_e_concialiacionmd($usuario);
		$total_cmb_md = pg_affected_rows($res);
		//conciliacion mismo bancos	md

		//conciliacion otros  bancos BOD md
		$res = $this->model->conciliacion_OB_bodmd($usuario);
		$total_cobBOD_md = pg_affected_rows($res);
		//conciliacion otros  bancos BOD md

		//conciliacion otros  bancos BNC md
		$res = $this->model->conciliacion_OB_bncmd($usuario);
		$total_cobBNC_md = pg_affected_rows($res);
		//conciliacion otros  bancos BNC md
		/***********************************************************/

		$total_c = 0;
		$total_c = $total_cmb + $total_cobb + $total_cobBOD + $total_cobBNC;
		$total_c_md = 0;
		$total_c_md_md = $total_cmb_md + $total_cobBOD_md + $total_cobBNC_md;

		if (($total_c > 0) or $total_c_md_md > 0) :
			echo $this->alertas(1, "Proceso de Conciliación Exitosa");
			$conciliacion = $this->model->generarConciliacionReporte($usuario, $total_c, $this->model->reporte_pendientes($usuario), $total_c_md_md);
			if (pg_affected_rows($conciliacion)) :
				$n_reporte = pg_fetch_all($conciliacion)[0]['id'];
				echo $this->alertas(1, "<br>Total de Movimientos Conciliados: <b>" . $total_c . "</b><br>Tota de Movimientos Fallidos: <b>" . $total_c_md_md . "</b><br>Total Movimientos Pendientes: <b>" . $this->model->reporte_pendientes($usuario) . "</b><br>Reporte Generado");
				//pendiente validacion
				$this->conciliacion_reporte($res_mb, $n_reporte, $usuario);
				$this->conciliacion_reporte($res_obb, $n_reporte, $usuario);
				$this->conciliacion_reporte($res_obbod, $n_reporte, $usuario);
				$this->conciliacion_reporte($res_obbnc, $n_reporte, $usuario);
				//pendiente validacion
				echo '<script>
								setTimeout(function() {
									$("#c_reportePago").modal("hide");
									$("#res-conci").html("");
								}, 5000);
							</script>';
			else :
				echo $this->alertas(3, pg_affected_rows($resc) . "Error al Generar Reporte");
			endif;
		else :
			echo $this->alertas(2, "Registro vacio");
		endif;
	}
	private function habilitar_eliminar($op, $id)
	{
		if ($op > 0) :
			return '<button type="button" class="btn btn-sm reenviarrpago"  title="Eliminar" data-toggle="modal" data-target="#eliminar_reporte" id="eliminar" data-id="' . $id . '"><i class="fas fa-trash-alt"></i></button>';
		endif;
	}
	private function conciliacion_reporte($res, $n_reporte, $usuario)
	{
		if (pg_affected_rows($res) > 0) :
			foreach (pg_fetch_all($res) as $row) :
				$this->model->insertarConciliacionReporte($usuario, $n_reporte, $row['id']) . '<br>';
			endforeach;
		endif;
	}
	public function reportesPagos()
	{
		$this->ct_reporte(); //cargando usuario
		echo $this->p;
	}
	public function eliminar_rep()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->eliminar_rep($_REQUEST, $_SESSION['usuario']);
		if ($res == 1) :
			echo $this->alertas(1, " Reporte Eliminado");
			echo '<script>
						cargarCuenta();
						setTimeout(function() {
							$("#eliminar_reporte").modal("hide");
							$("#dat_er").html("");
						}, 5000);
				 </script>';
		else :
			echo $this->alertas(3, " Ha Ocurrido un Error");
		endif;
	}
	/*************************** Conciliacion *************************************/
	/*************************** Reporte conciliacion *************************************/
	public function conciliacion()
	{
		$this->seguridad();
		require_once 'view/header.php';
		$this->ct_conciliacion(); //cargasFacturas
		require_once 'view/app/conciliacion.php';
		require_once 'view/footer.php';
	}
	public function ct_conciliacion()
	{
		session_name("onlyone");
		session_start();
		$res = $this->model->reportes_conciliacion($_SESSION['usuario']);
		$this->p = "";
		if ($res == -1) {
			$this->p .= '
						<tr>
							<td colspan="7" class="text-center">No existe Reporte de Pago</td>
						<tr>
				      ';
		} else {
			foreach ($res as $row) :
				$date = new DateTime($row['fecha_reporte']);
				$this->p .= '<tr>
								<td>' . $row['id_reporte'] . '</td>
								<td>' . $row['total_c'] . '</td>
								<td>' . $row['total_nc'] . '</td>
								<td>' . $row['total_ncm'] . '</td>
								<td>' . $date->format('Y-m-d H:i:s') . '</td>
								<td><div class="btn-group" role="group" aria-label="Basic example">
								<button type="button" class="btn btn-success btn-sm mr-1"  title="Ver Reporte" data-toggle="modal" data-target="#d_desarrollo" id="ver" data-id="' . $row['id_reporte'] . '"><i class="fa fa-eye"></i></button>
								<button type="button" class="btn btn-info btn-sm"  title="Imprimir Reporte " data-toggle="modal" data-target="#d_desarrollo" id="ver" data-id="' . $row['id_reporte'] . '"><i class="fa fa-print"></i></button>
								</div></td>
							</tr>';
			endforeach;
		}
	}
	/*************************** Reporte conciliacion *************************************/

	public function seguridad()
	{
		session_name("onlyone");
		session_start();
		if (isset($_SESSION['usuario'])) :
		//echo 'session anactiva';
		else :
			header('Location: index.php');
		endif;
	}
	public function logout()
	{
		session_name("onlyone");
		session_start();
		session_unset();
		session_destroy();
		header("Location: index.php");
	}

}
