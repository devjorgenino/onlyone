<!-- Dasarrollo --->
<div class="modal fade" id="d_desarrollo" role="dialog">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <!-- Modal Header -->
            <button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>
            <div class="modal-header headermodal">
                <h4 class="titlemodal text-center" >Opción No disponible </h4>
            </div>
            <div class="row">
            <div class="col">
            <div class="modal-body">
                <div class="alert alert-primary text-center" role="alert">
                    Estamos Trabajando...
                </div>
            </div>
            </div>
            </div>
                  <div class="modal-footer">
                    <button type="button" class="btn cerrar" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;Cerrar</button>
                  </div>
                  </form>
        </div>
    </div>
</div>
<!-- Desarrollo-->
<!-- *******************************USUARIO*****************************************-->
<!-- Registrar USuario-->
<div class="modal fade" id="n_usuario" role="dialog"><!-- Modal fade -->
    <div class="modal-dialog modal-md"><!-- Modal dialog -->
        <div class="modal-content"><!-- Modal content -->
        <button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>
            <div class="modal-header headermodal"> 
                <h4 class="titlemodal text-center" >Invitación de Registro - App Pagos</h4>
            </div><!-- Modal Header -->
            <form action="?c=app&a=n_usuario" method="post" role="form"  id="n_usuario"  class="Form" data-form="n_usuario">
            <div class="modal-body"><!-- Modal body -->
            <div class="row"><!-- Modal row -->
                <div class="col-12">
                    <div class="form-group">
                        <label for="exampleInputEmail1">Email Usuario </label>
                        <input type="email" name="correo" class="form-control" id="email" placeholder="Ingrese el Email" onblur="consutarNombre()" required>
                        <small id="emailHelp" class="form-text text-muted danger">El Usuario Recibira un Enlace con la invitación al Registro App Pagos.</small>
                    </div>
                </div>
                <input type="hidden" name="nivel" value="1">
                <!--<div class="col-12">
                <label for="exampleInputEmail1">Nivel Usuario </label>
                    <div class="form-check">
                    <input class="form-check-input" type="radio" name="nivel"  value="1" checked required>
                    <label class="form-check-label" >
                        Operador
                    </label>
                    </div>
                    <div class="form-check">
                    <input class="form-check-input" type="radio" name="nivel" value="2" required>
                    <label class="form-check-label" >
                       Administrador
                    </label>
                    </div>
                </div>-->
            </div><!-- Modal row -->
            </div><!-- Modal body -->
                  <div class="modal-footer">
                    <button type="submit" class="btn agregar" id="btn-guardar_inv" ><i class="far fa-save"></i>&nbsp;Guardar</button>
                    <button type="button" class="btn cerrar" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;Cerrar</button>
                  </div>
                  </form>
                <div class="res"></div>
        </div><!-- Modal content -->
    </div><!-- Modal dialog -->
</div><!-- Modal fade -->
<!-- Registrar Usuario-->
<!-- *******************************USUARIO*****************************************-->

<!-- *******************************FACTURAS*****************************************-->
<!-- Registrar facturas-->
<div class="modal fade" id="n_factura" role="dialog"><!-- Modal fade -->
    <div class="modal-dialog modal-md"><!-- Modal dialog -->
        <div class="modal-content"><!-- Modal content -->
        <button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>
            <div class="modal-header headermodal"> 
                <h4 class="titlemodal text-center" >Registro de Facturas</h4>
            </div><!-- Modal Header -->
            <form action="?c=app&a=n_factura" method="post" role="form"  id="formulario_factura"  class="Form" data-form="n_factura">
            <div class="modal-body"><!-- Modal body -->

            <div class="form-group">
                        <label for="formGroupExampleInput">Correo Electronico</label>
                        <input type="text" class="form-control" name="f_correo" id="f_correo" placeholder="geekhack@geekhack.net.ve" blur="consutarNombre()"  required>
                    </div>

                    <div class="form-group">
                        <label for="formGroupExampleInput">Nombres Cliente</label>
                        <input type="text" class="form-control" name="f_cliente"  id="f_cliente" placeholder="Ingrese Nombre"  disabled required>
                    </div>

                    <div class="form-group">
                        <label for="formGroupExampleInput">Datos de Facturas</label>
                        <div class="row">
                        <div class="col-6"><input type="number" class="form-control" name="f_numero" placeholder="Numero" required></div>
                        <div class="col-6"><input type="text" class="form-control" name="f_monto" id="inputMonto" placeholder="Monto" required></div>
                        </div>
                        </div>
                        <div class="form-group">
                        <div class="row">
                        <div class="col-12">  
                        <label for="exampleFormControlTextarea1">Fecha Factura </label>
                        <input type="date" class="form-control" name="f_fecha" required>
                        </div>
                        </div>
                        </div>
                        <div class="form-group">
                        <div class="row">
                        <div class="col-12">  
                        <label for="exampleFormControlTextarea1">Descripción de Facturas </label>
                        <textarea class="form-control" id="exampleFormControlTextarea1" rows="3" name="f_descripcion" required></textarea>
                        </div>
                        </div>
                    </div>

            </div><!-- Modal body -->
                  <div class="modal-footer"><!-- Modal footer -->
                    <button type="submit" class="btn agregar" id="btn-guardar_fact" ><i class="far fa-save"></i>&nbsp;Guardar</button>
                    <button type="button" class="btn cerrar" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;Cerrar</button>
                  </div><!-- Modal footer -->
                  <div class="res2" ></div>
            </form>
        </div><!-- Modal content -->
    </div><!-- Modal dialog -->
</div><!-- Modal fade -->
<!-- Registrar facturas-->
<!-- *******************************FACTURAS*****************************************-->
<!-- *******************************Conciliacion*****************************************-->
<!-- Constal reporte pago --->
<div class="modal fade" id="c_reporte" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <!-- Modal Header -->
            <button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>
            <div class="modal-header headermodal">
                <h4 class="titlemodal text-center" > Reporte de Pago</h4>
            </div>
            <div class="row">
            <div class="col">
            <div class="modal-body" id="cuepo_rep">
            
            </div>
            </div>
            </div>
                  <div class="modal-footer">
                    <button type="button" class="btn cerrar" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;Cerrar</button>
                  </div>
        </div>
    </div>
</div>
<div class="modal fade" id="c_movimiento_c" role="dialog">
    <div class="modal-dialog modal-md">
        <div class="modal-content">
            <!-- Modal Header -->
            <button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>
            <div class="modal-header headermodal">
                <h4 class="titlemodal text-center" > Movimiento Bancario</h4>
            </div>
            <div class="row">
            <div class="col">
            <div class="modal-body" id="cuepo_rep2">
            </div>
            </div>
            </div>
                  <div class="modal-footer">
                    <button type="button" class="btn cerrar" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;Cerrar</button>
                  </div>
        </div>
    </div>
</div>
<!-- Desarrollo-->
<!-- Constal reporte pago --->
<div class="modal fade" id="c_reportePago" role="dialog">
    <div class="modal-dialog modal-md">
        <div class="modal-content">
            <!-- Modal Header -->
            <button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>
            <div class="modal-header headermodal">
                <h4 class="titlemodal text-center" > Conciliar</h4>
            </div>
            <div class="row">
            <div class="col">
            <form action="?c=app&a=procesarConciliacion" method="post" role="form"  id="n_conciliacion"  class="Form" data-form="n_conciliacion">
            <div class="modal-body" >
                <div class="form-group">
                    <label for="formGroupExampleInput">Tipo de Conciliación</label>
                    <select class="form-control form-control-lg" name="tipo"  required readonly>
                        <option value="1" selected>General</option>
                       <!--- <option value="2">Bancos</option>
                        <option value="3">Cuentas</option>--->
                    </select>
                 </div>
            </div>
            </div>
            </div>
                  <div class="modal-footer">
                  <button type="submit" class="btn agregar" id="btn-si" onclick="" ><i class="far fa-save"></i>&nbsp;Generar Reporte</button>
                    <button type="button" class="btn cerrar" id="btn-no" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;Salir</button>
                  </div>
                  <div id="res-conci"></div>
                  </form>
        </div>
    </div>
</div>
<!-- Desarrollo-->
<!-- editar Productos-->
<div class="modal fade " tabindex="-1" id="eliminar_reporte" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
	<!-- modal-->
	<div class="modal-dialog">
		<!-- modal2-->
		<div class="modal-content">
			<!-- modal3-->
			<button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>
			<div class="modal-header headermodal">
				<!-- header-->
				<h5 class="modal-title letrasmodal titlemodal"> Confirmación Eliminar Reporte Pago </h5>
			
			</div><!-- header-->

			<div class="modal-body"><!-- body-->
			<form class="form_ec_2" id="form_ec_2">
            <input type="hidden" name="id" id="id_e">
							<div class="col-md-12 col-sm-12">
							<div id="data_e_rep"></div>
							</div>

			</div><!-- body-->
			<div class="modal-footer">
				
						<button type="submit" class="btn agregar" id="btn-er2" disabled><i class="far fa-save"></i>&nbsp;Si</button>
						<button type="button" class="btn cerrar" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;No</button>
			
			</div>
			<div class="col-12" id="dat_er"></div>
			</form>

		</div><!-- modal3-->
	</div><!-- modal2-->
</div><!-- modal-->
<!-- editar Productos-->
<!-- *******************************Conciliacion*****************************************-->
