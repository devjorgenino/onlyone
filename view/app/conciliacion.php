<title>Onlyone | Concialiación</title>
<div class="row">
  <div class="col-12 col-sm-12 col-md-11 col-lg-11 col-xl-11">
    <div class="border-table">
      <br>
      <div class="table-responsive">
        <table class="table table-hover records-table text-center nowrap no-footer" id="dataTable2" width="100%" cellspacing="0">
          <thead>
            <tr class="text-center">
              <th>N° REPORTE</th>
              <th>CONCILIADOS</th>
              <th>NO CONCILIADOS</th>
              <th>ERROR CONCILIACIÓN</th>
              <th>FECHA CREACIÓN</th>
              <th>ACCIONES</th>
            </tr>
          </thead>
          <!--tfoot>
              <th></th>
              <th></th>
              <th></th>
              <th></th>
              <th></th>
              <th></th>
          </tfoot-->
          <tbody id="reporte_conciliacion">
              <?php print_r($this->p); ?>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <?php require('modal/modal.php') ?>
  <script src="assets/js/jquery.min.js"></script>
  <script src="assets/js/pagos.js"></script>