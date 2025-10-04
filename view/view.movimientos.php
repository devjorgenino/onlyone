<title>Onlyone | Movimientos</title>
<div class="container-fluid">
  <div class="row brand-color-grey-date">
    <div class="col-10 col-sm-10 col-md-10 col-lg-10 col-xl-10 update-info d-none d-sm-block">
      Actualización: <?php echo date("d/m/Y") . ' a las ' . date("h:i a"); ?>
    </div>
  </div>
  <div class="row justify-content-md-center bank-container">

    <div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10 brand-color brand-box">
      <div id="res_mon"></div>
      <div class="row justify-content-md-center" id="info_c">
        <div></div>

        <div class="col-12 col-sm-12 col-md-12 col-lg-4 col-xl-4" id="cintillo" style="visibility: hidden;">
          <div class="row justify-content-md-center">
            <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 d-none d-sm-none d-xs-none d-md-none d-lg-block d-xl-block reduced-padding">
              <img class="mercantil logo_cintinllo">
            </div>
          </div>
        </div>


        <div class="col-12 col-sm-12 col-md-12 col-lg-4 col-xl-4 blue-font balance-info ">
          <br>
          <span class="balance-number" id="totald">Bs.<?php echo (number_format($this->sc[0]['totalsc'], 2, ",", ".")); ?></span>
          <br>
          <span class="balance-label">SALDO DISPONIBLE</span>
        </div>


        <div class="col-12 col-sm-12 col-md-12 col-lg-4 col-xl-4 blue-font final-balance-info d-none d-sm-block">
          <span class="balance-number" id="totaldi">Bs.<?php echo (number_format($this->sc[0]['totalsc'], 2, ",", ".")); ?></span>
          <br>
          <span class="balance-label">SALDO TOTAL</span>

          <br>

          <span class="balance-number" id="totaldif">Bs.<?php echo (number_format($saldo, 2, ",", ".")); ?></span>
          <br>
          <span class="balance-label">SALDO DIFERIDO</span>
          <br>
        </div>

      </div>

    </div>

    <div class="col-12 col-sm-12 col-md-2 col-lg-2 col-xl-2 latter-message" id="texto">
      TASA DEL DÍA
      <br>
      <span class="brand-color-azul">&nbsp;
        <?php
        echo $this->dolar;
        ?>
      </span>
    </div>
  </div>
  <div class="row brand-color-grey-date">
    <div class="col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 update-info d-block d-sm-none">
      Actualización: <?php echo date("d/m/Y") . ' a las ' . date("h:i a"); ?>
    </div>
  </div>
  <br>

 <!-- <div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10 d-block d-xs-block d-sm-block d-md-block d-lg-none d-xl-none utility-panel text-center">
      <p>
        <a class="" href="#" id="excel">
          <img src="./assets/img/icono_doc_excel.png" alt="icono_doc_excel" style="width: 8%;">
        </a>
        <a class="" href="#" id="csv">
          <img src="./assets/img/icono_doc_cvs.png" alt="icono_doc_cvs" style="width: 8%;">
        </a>
        <a class="" href="#" id="pdf">
          <img src="./assets/img/icono_doc_pdf.png" alt="icono_doc_pdf" style="width: 8%;">
        </a>
        <a class="" href="#" id="print">
          <img src="./assets/img/icono_doc_print.png" alt="icono_doc_print" style="width: 8%;">
        </a>
      </p>
    </div>-->


  <br class="d-none d-sm-block">
  <div class="row">
    <div class="col-12 col-sm-12 col-md-10 col-lg-10 col-xl-10">
      <div class="border-table">
        <div class="table-responsive">
          <table class="table table-hover records-table text-center nowrap display" id="tablaMovimiento" width="100%" cellspacing="0">
            <thead>
              <tr class="text-center">
                <th class="text-cebter">FECHA</th>
                <th class="text-center">BANCO</th>
                <th class="text-center">CATEGORIA</th>
                <th class="text-center">REFERENCIA</th>
                <th class="text-left">DESCRIPCIÓN</th>
                <th class="text-right">MONTO</th>
                <th class="text-center"></th>
              </tr>
            </thead>
            <tfoot>
              <tr>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
                <th></th>
              </tr>
            </tfoot>
          </table>
        </div>
      </div>
    </div class="text-center alert-info">

    <div class="col-1 col-sm-1 col-md-1 col-lg-1 col-xl-1 utility-panel">
      <p>
        <a class="" href="#" id="excel">
          <img src="./assets/img/icono_doc_excel.png" alt="icono_doc_excel" style="width: 45%;">
        </a>
        <a class="" href="#" id="csv">
          <img src="./assets/img/icono_doc_cvs.png" alt="icono_doc_cvs" style="width: 45%;">
        </a>
      </p>
      <p>
        <a class="" href="#" id="pdf">
          <img src="./assets/img/icono_doc_pdf.png" alt="icono_doc_pdf" style="width: 45%;">
        </a>
        <a class="" href="#" id="print">
          <img src="./assets/img/icono_doc_print.png" alt="icono_doc_print" style="width: 45%;">
        </a>
      </p>

    </div>


    <?php require_once 'modal/movimiento.php'; ?>

  </div>