<div class="row brand-color-grey-date">
  <div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10 update-info d-sm-block">
    Actualización: <?php echo date("d/m/Y") . ' a las ' . date("h:i:a"); ?>
  </div>
</div>

<br>

<div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10 d-block d-sm-block d-md-block d-lg-none d-xl-none utility-panel text-right">
  <a data-toggle="modal" data-target=".productos" class="btn btn-sm agregar"><i class="fa fa-user-plus fa-2x float-right" aria-hidden="true"></i> </a>
</div>

<br>

<div class="row row2">
  <div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10">
    <div class="border-table">
      <div class="row">
        <div class="col-md-12">
          <div class="alert alert-dismissible" style="display:none" id="msjciudade"></div>
        </div>
      </div>
      <div class="table-responsive">
        <table class="table table-hover records-table nowrap no-footer dataTableCuentas" id="dataTableCuentas"
          width="100%" cellspacing="0">
          <thead>
            <tr>
              <th class="text-center">N° CUENTA</th>
              <th class="text-left">BANCO</th>
              <th class="text-center">FECHA SALDO</th>
              <th class="text-right">SALDO</th>
              <th class="text-center">ESTATUS</th>
              <th class="text-center"></th>
            </tr>
          </thead>
        </table>
      </div>
    </div>
  </div>

  <div class="col-1 col-sm-1 col-md-1 col-lg-1 col-xl-1 utility-panel">
     <a data-toggle="modal" data-target=".productos" class="btn btn-sm agregar"><i class="fa fa-user-plus fa-2x float-right" aria-hidden="true"></i> </a> 
  </div>







  <?php require_once 'view/modal/cuentas.php'; ?>