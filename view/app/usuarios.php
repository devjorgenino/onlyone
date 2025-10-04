
<!-- Page Content -->
<h3 class="text-center">App Pagos - Configuracion Usuarios</h3>
<!-- /#page-content-wrapper -->
<!-- cuerpo -->
<div class="btn-group float-right" role="group" aria-label="Basic example">
	<a  class="btn btn-lg btn-success " data-toggle="modal" title="conciliar" data-target="#n_usuario"><i class="fa fa-plus fa-2x float-right" aria-hidden="true"></i> </a>
 </div>

<br><br>
<div class="table-responsive">
    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
            <thead>
              <tr>
                <th>#</th>
                <th>Correo</th>
                <th>Empresa</th>
                <th>Rol</th>
                <th>Fecha Creación</th>
                <th>Estatus</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody id="usuario_lista">
              <?php print_r($this->p); ?>
            </tbody>
    </table>
</div>
<!-- cuerpo -->