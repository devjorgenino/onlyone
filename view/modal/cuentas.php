<title>Onlyone | Productos</title>
<?php date_default_timezone_set('America/La_Paz'); ?>
<!-- Productos-->
<div class="modal fade productos" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
	<!-- modal-->
	<div class="modal-dialog modal-md">
		<!-- modal2-->
		<div class="modal-content">
			<!-- modal3-->
			<button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>

			<div class="modal-header headermodal">
				<!-- header-->
				<h5 class="modal-title letrasmodal titlemodal"> Productos / Crear Cuenta
					<small></small></h5>
				
			</div><!-- header-->

			<div class="modal-body">
				<!-- body-->
				<div class="row">
					<!-- row-->
					<div class="col-md-12 float-left d-none">
						<span class="letrasmodal"> <i class="far fa-calendar-check"></i> Fecha:
							<?php  echo date("d-m-Y"); ?></span>
					</div>
				</div><!-- row-->
				<br>

				<form class="formulario" id="formulario">
                        <!-- form-->
                        <input type="hidden" name="fechaSaldo" value="<?php  echo date("d-m-Y");?>">

                        <div class="row">
                            <!-- row-->
                            <div class="col-md-12 col-sm-12">
                                <!-- row12-->
                                <div class="form-group">
                                    <label for="exampleInputPassword1" class="letrasmodal">Tipo de Producto</label>
                                    <select class="custom-select form-control" id="tipoCuenta" name="tipoCuenta"
                                        onChange="productosSelect(this);">
                                        <option></option>
                                        <?php 
                                            foreach ($this->p as $r) {
                                                echo '<option value="'.$r['id'].'">'.ucwords($r['nombre']).'</option>';
                                            }
                                        ?>
                                    </select>
                                </div>
                            </div><!-- row12-->
                        </div><!-- row-->

                        <div class="row">
                            <div class="col-md-12 col-sm-12">
                                <!-- row12-->
                                <div class="form-group">
                                    <label for="exampleInputEmail1" class="letrasmodal">Banco</label>
                                    <select class="custom-select form-control" id="banco" name="banco"
                                        onChange="bancosSelect(this);" disabled>
                                        <option>Selecione</option>
                                    </select>
                                </div>
                            </div><!-- row12-->
                        </div><!-- row-->

                        <div class="row">
                            <!-- row-->
                            <div class="col-md-12 col-sm-12">
                                <!-- row12-->
                                <div class="form-group">
                                    <label for="exampleInputEmail1" id="tipo" class="letrasmodal">Moneda</label>
                                    <select class="custom-select form-control" id="divisa" name="divisa"
                                        onChange="divisaSelect(this);" disabled>
                                        <option>Selecione</option>
                                    </select>
                                </div>
                            </div><!-- row12-->
                        </div><!-- row-->

                        <div class="row">
                            <div class="col-md-12 col-sm-12">
                                <!-- row12-->
                                <div class="form-group">
                                    <label for="exampleInputEmail1" id="cuenta" class="letrasmodal">N° de cuenta</label>
                                    <div class="input-group">
                                        <div class="input-group-prepend">
                                            <input type="hidden" id="codigoB" name="codigoB" value="">
                                            <span class="input-group-text" id="tc"></span>
                                        </div>
                                        <input type="text" class="form-control" id="numCuenta" name="numCuenta"
                                            onkeypress="return soloNum(event)" placeholder="" disabled>
                                    </div>
                                </div>
                            </div><!-- row12-->
                        </div><!-- row-->

                        <div class="row">
                            <!-- row-->
                            <div class="col-md-12 col-sm-12">
                                <div class="form-group">
                                    <label for="exampleInputPassword1" class="letrasmodal">Saldo actual</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="montoCuenta" name="montoCuenta"
                                            onkeypress="return decimal(event)" placeholder="0,00" disabled>
                                        <!--<div class="input-group-prepend">
                                            <span class="input-group-text" id="ts"></span>
                                        </div>-->
                                    </div>
                                </div>
                            </div>
                        </div><!-- row-->
                
                        <button type="submit" class="btn btn-block agregar" id="enviarFormulario" form="formulario"disabled="true">
							Guardar 
						</button>

						<button type="reset" class="btn btn-block cerrar" id="limpiarc" onclick=desabitarBotonesCuenta(1) disabled="true">
							Limpiar 
						</button>
                        <!--  -->
				</form><!-- form-->
			</div><!-- body-->

			<div class="row">
				<div class="col-12" id="cn">
				</div>
			</div>
		</div><!-- modal3-->
	</div><!-- modal2-->
</div><!-- modal-->

<!-- Productos-->
<!-- editar Productos-->
<div class="modal fade editarCuenta" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
	<!-- modal-->
	<div class="modal-dialog modal-md">
		<!-- modal2-->
		<div class="modal-content">
			<!-- modal3-->
			<button type="button" class="close closem" data-dismiss="modal" aria-label="Close">
					<span class="botoncerrarmodal" aria-hidden="true">&times;</span>
				</button>

			<div class="modal-header headermodal">
				<!-- header-->
				<h5 class="modal-title letrasmodal titlemodal"> Productos / Editar Cuenta  <small></small></h5>
				
			</div><!-- header-->

			<div class="modal-body">
				<!-- body-->

				<div class="row">
					<!-- row-->
					<div class="col-md-6 float-left d-none">
						<span class="letrasmodal"> <i class="far fa-calendar-check"></i> Fecha:
							<?php  echo date("d-m-Y"); ?></span>
					</div>
				</div><!-- row-->
				<br>							
				<div id="contenido2">
				</div>
				<div style="display: none;" id="contenido">
					<form class="formularioee" id="formularioee">
							<!-- form-->
							<input type="hidden" name="fechaSaldoe" value="<?php  echo date("d-m-Y");?>">
							
							<div class="row">
								<!-- row-->
								<div class="col-md-12 col-sm-12">
									<!-- row12-->
									<div class="form-group">
										<input type="hidden" id="id" name="id" value="">
										<label for="exampleInputPassword1" class="letrasmodal">Tipo de Producto</label>
										<select class="custom-select form-control" id="tipoCuentaE" name="tipoCuentaE"
											onChange="productosSelectEditar(this);" required>
											<option></option>
										</select>
									</div>
								</div><!-- row12-->
							</div><!-- row-->


							<div class="row">
								<div class="col-md-12 col-sm-12">
									<!-- row12-->
									<div class="form-group">
										<label for="exampleInputEmail1" class="letrasmodal">Banco</label>
										<select class="custom-select form-control" id="bancoe" name="bancoe"
											onChange="bancosSelectEditar(this);" required>
											<option value="">Selecione</option>
										</select>
									</div>
								</div><!-- row12-->
							</div><!-- row-->

							<div class="row">
								<!-- row-->
								<div class="col-md-12 col-sm-12">
									<!-- row12-->
									<div class="form-group">
										<label for="exampleInputEmail1" id="tipo" class="letrasmodal">Moneda</label>
										<select class="custom-select form-control" id="divisae" name="divisae"
											onChange="divisaSelectEditar(this);" required>
											<option value="">Selecione</option>
										</select>
									</div>
								</div><!-- row12-->
							</div><!-- row-->   

							<div class="row">
								<div class="col-md-12 col-sm-12">
									<!-- row12-->
									<div class="form-group">
										<label for="exampleInputEmail1" id="cuenta" class="letrasmodal">N° de cuenta</label>
										<div class="input-group">
											<div class="input-group-prepend">
												<input type="hidden" id="codigoBe" name="codigoBe" value="">
												<span class="input-group-text" id="tce"></span>
											</div>
											<input type="text" class="form-control" id="numCuentae" name="numCuentae"
												onkeypress="return soloNum(event)" maxlength="16" minlength="16" required>
										</div>
									</div>
								</div><!-- row12-->
							</div><!-- row-->

							<div class="row">
								<!-- row-->
								<div class="col-md-12 col-sm-12">
									<div class="form-group">
										<label for="exampleInputPassword1" class="letrasmodal">Saldo actual</label>
										<div class="input-group">
											<input type="text" class="form-control" id="montoCuentae" name="montoCuentae"
												onkeypress="return decimal(event)" placeholder="0,00">
											<!--<div class="input-group-prepend">
												<span class="input-group-text" id="tse"></span>
											</div>-->
										</div>
									</div>
								</div>
							</div><!-- row-->
							<button type="submit" class="btn agregar btn-block" id="formularioe" form="formularioee" disabled="true">
								Modificar 
							</button>
				

							<!--  -->
						</form><!-- form-->
				</div>
			</div><!-- body-->

			<div class="row">
				<div class="col-12" id="ce">
				</div>
			</div>

		</div><!-- modal3-->
	</div><!-- modal2-->
</div><!-- modal-->
<!-- editar Productos-->
<!-- editar Productos-->
<div class="modal fade eliminar_cuenta" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
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
				<h5 class="modal-title letrasmodal titlemodal"> Confirmación Eliminar Producto </h5>
			
			</div><!-- header-->

			<div class="modal-body"><!-- body-->
			<form class="form_ec" id="form_ec">
							  
							<div class="col-md-12 col-sm-12">
							<div class="data_ec"></div>
							</div>

			</div><!-- body-->
			<div class="modal-footer">
				
						<button type="submit" class="btn agregar" id="btn-ec" disabled><i class="far fa-save"></i>&nbsp;Si</button>
						<button type="button" class="btn cerrar" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;No</button>
			
			</div>
			<div class="col-12" id="rep_ec"></div>
			</form>

		</div><!-- modal3-->
	</div><!-- modal2-->
</div><!-- modal-->
<!-- editar Productos-->
<div class="modal fade ad_cuenta" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
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
				<h5 class="modal-title letrasmodal titlemodal"> Confirmación Eliminar Producto </h5>
				
			</div><!-- header-->

			<div class="modal-body"><!-- body-->
			<form class="form_ad" id="form_ad">
							  
							<div class="col-md-12 col-sm-12">
							<div class="data_ad"></div>
							</div>

			</div><!-- body-->
			<div class="modal-footer">
			
                    <button type="submit" class="btn agregar" id="btn-adc" disabled><i class="far fa-save"></i>&nbsp;Si</button>
                    <button type="button" class="btn cerrar" data-dismiss="modal"><i class="fas fa-times"></i>&nbsp;No</button>
                  </div>
			<div class="col-12" id="rep_ad"></div>
			</form>

		</div><!-- modal3-->
	</div><!-- modal2-->
</div><!-- modal-->