   <div class="row">
      <div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10">
        <div class="border-table">
          <div class="row">
            <div class="col-md-12">
              <div id="msjSVG" ></div>
            </div>
          </div>
          <div class="table-responsive">
            <table class="table table-hover records-table" id="dataTableCuentas" width="100%" cellspacing="0">
              <thead>
                <?php if($this->res!=-1):?>
                <form  id="formCargarCSV2" enctype="multipart/form-data" method="post">
                  <tr>
                    <th><input type="file" class="form-control" name="csv[]" id="inputc" required multiple > </th>
                  </tr>
                  <tr>
                    <th class="text-center" colspan="2"><button type='submit' id="carga" class="btn btn-sm agregar" >Cargar CVG</button> </th>
                    </form>
                  </tr>
                  <?php else: ?>
                    <tr>
                      <th class="">Estimado Usuario No Posee Cuenta Registradas</th>
                      <th class="text-center"><button type='submit' id="general" class="btn btn-sm agregar"  >Registar Cuenta</button> </th>
                    </tr>
                  <?php endif; ?>
              </thead>
              
              </thead>
            </table>
          </div>
        </div>
      </div>