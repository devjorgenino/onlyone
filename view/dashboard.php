<title>Onlyone | Inicio</title>
<div class="container-fluid">
  <div class="row brand-color-grey-date">
    <div class="col-11 col-sm-11 col-md-11 col-lg-11 col-xl-11 update-info d-none d-sm-block">
      Actualizado: <?php echo date("d/m/Y"). ' a las '.date("h:i a");?>
    </div>
  </div>

  <div class="row">
    <div class="col-12 col-sm-12 col-md-11 col-lg-11 col-xl-11">
      <div class="border-table">
        <div class="row">
        
          <!--Graficos-->
          <div class="col-md-6 mt-5">
            <div class="container-fluid">
                <canvas id="popChart" width="600" height="450" style="60px 60px 60px 0px"></canvas>
            </div>
          </div>

          <br><br>
          <!--Bancos-->
          <div class="col-md-6 mt-4">

            <div class="card mb-3 sinborde">
              <div class="row no-gutters">
                <div class="card-body bodybancos">
                    <?php echo $this->p;?>
                </div>
              </div>
            </div>

          </div>
        </div>

        <!--Alertas y Notificaciones-->
        <div class="card bodyalertas mt-3">      
            <h5 class="letrasmodal ml-1" >Alertas y Notificaciones</h5>
           <?php echo $this->b; ?>
         </div>
  

      </div>
    </div>