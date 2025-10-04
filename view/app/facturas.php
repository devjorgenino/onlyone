
<!-- Page Content -->
    <h3 class="text-center">App Pagos - Facturas</h3>
<!-- /#page-content-wrapper -->
<!-- cuerpo -->
<div class="btn-group float-right" role="group" aria-label="Basic example">
	<a   class="btn btn-success" data-toggle="modal" data-target="#n_factura"><i class="fa fa-plus fa-2x float-right" aria-hidden="true"></i> </a>
</div>

<br><br>
<div class="table-responsive">
    <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
            <thead>
              <tr>
                <th>#</th>
                <th>Factura Nº</th>
                <th>Tipo</th>
                <th>Cliente</th>
                <th>Monto</th>
                <th>Fecha Factura</th>
                <th>Estatus</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody id="Factura_lista">
              <?php print_r($this->p); ?>
            </tbody>
    </table>
</div>
<!-- cuerpo -->
<!-- cuerpo -->