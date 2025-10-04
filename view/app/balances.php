<title>Onlyone | Conciliación</title>
<div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10 d-block d-sm-block d-md-block d-lg-none d-xl-none utility-panel text-right">
  <a class="btn btn-sm agregar" data-toggle="modal" title="Conciliar" data-target="#c_reportePago">
    <i class="fa fa-university fa-2x float-right" aria-hidden="true"></i>
  </a>
</div>
<br>
<div class="row">
  <div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10">
    <div class="border-table">
      <div class="table-responsive">
        <table class="table table-hover records-table text-center nowrap no-footer"
          width="100%" cellspacing="0" id="dataTable">
          <thead>
            <tr>
              <th>#REPORTE DE PAGO</th>
              <th>FECHA</th>
              <th>BANCO Y CUENTA</th>
              <th>CLIENTE</th>
              <th class="d-none d-lg-none">#FACTURAS</th>
              <th>#REFERENCIA</th>
              <th>ESTATUS</th>
              <th>MONTO</th>
              <th>ACCIONES</th>
            </tr>
          </thead>
          <tfoot>
            <tr>
              <th></th>
              <th></th>
              <th></th>
              <th></th>
              <th class="d-none d-lg-none"></th>
              <th></th>
              <th></th>
              <th></th>
              <th></th>
            </tr>
          </tfoot>
          <tbody id="reporte_lista">
            <?php print_r($this->p); ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>
  <div class="col-1 col-sm-1 col-md-1 col-lg-1 col-xl-1 utility-panel">
        <a class="btn btn-sm agregar" data-toggle="modal" title="Conciliar" data-target="#c_reportePago">
          <i class="fa fa-university fa-2x float-right" aria-hidden="true"></i>
        </a>
      </div>
      <br>

  <!-- cuerpo -->
  <!-- cuerpo -->