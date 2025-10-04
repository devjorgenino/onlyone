<div class="row">
  <div class="col-12 col-sm-12 col-md-11 col-lg-11 col-xl-11">
    <div class="border-table">
      <div class="row">
        <div class="col-md-12">
          <h5 class="ml-3 mt-3 letrastitulo">Importar Movimiento Bancario</h5>
        </div>
      </div><br>
      <div class="row">
        <div class="col-md-12">
          <div id="msjSVG"></div>
        </div>
      </div>
      <div class="table-responsive">
        <table class="table table-bordered" id="dataTableCuentas" width="100%" cellspacing="0">
          <thead>
            <?php if($this->res!=-1):?>
            <form id="formCargarCSV" enctype="multipart/form-data" method="post">
              <tr>
                <th>
                  <select class="form-control" name="cuenta" onchange="activarCampoCVG(this);">
                    <option value="-1">Seleciones un Banco Cuenta</option>
                    <?php foreach($this->res as $b):
                  echo '<option value="'.$b['id'].'">	'.ucwords($b['producto']).' '.ucwords($b['razon_comercial']).' Nro: '.$b['cuenta'].'</option>';
                  endforeach;
                  ?>
                  </select>
                </th>
                <th><input type="file" class="form-control archivo" name="csv" id="inputc" accept=".txt, .csv" required disabled> </th>
              </tr>
              <tr>
                <th class="text-center" colspan="2"><button type='submit' id="carga" class="btn agregar btn-sm"
                    disabled>Importar</button> </th>
            </form>
            </tr>
            <?php else: ?>
            <tr>
              <th class="">Estimado Usuario No Posee Cuenta Registradas</th>
              <th class="text-center"><button type='submit' id="general" class="btn btn-success btn-sm">Registar
                  Cuenta</button> </th>
            </tr>
            <?php endif; ?>
          </thead>

        </table>
      </div>
    </div>
  </div>