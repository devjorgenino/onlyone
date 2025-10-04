<!-- Sidebar -->
<nav class="nav-bar-left"> 
  <ul class="sidebar navbar-nav hidden-xs-down">
    <li class="nav-item">
      <a class="nav-link custom-menu-laterales" href="index.php?c=app&a=dashboard">
        <img data-alt-src="./assets/img/icono_lateral_1_hoy_on.png" src="./assets/img/icono_lateral_1_hoy_off.png"
          alt="icono_lateral_1_hoy_off">
        <br>
        <span class="letras-laterales"><?php echo 'Hoy '.date("d/m/Y");?></span>
      </a>
    </li>
    <li class="nav-item dropdown no-arrow">
      <a class="nav-link dropdown-toggle custom-menu-laterales" href="#" id="pagesDropdown" role="button"
        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <img data-alt-src="./assets/img/icono_lateral_2_realizar_on.png" src="./assets/img/icono_lateral_2_realizar_of.png"
          alt="icono_lateral_2_realizar_of">
        <br>
        <span class="letras-laterales">REALIZAR</span>
      </a>
      <div class="dropdown-menu dropdown-color-azul pagesDropdown" aria-labelledby="pagesDropdown">
        <a class="dropdown-item custom-menu-laterales" href="index.php?c=app&a=movimientos">Consulta de Saldos y
          Movimientos</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item custom-menu-laterales" data-toggle="modal" data-target="#importar" >Importar Movimientos</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item custom-menu-laterales" href="index.php?c=app&a=AppPagos">Conciliación</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item custom-menu-laterales" href="#">Transferencias</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item custom-menu-laterales" href="#">Pago de Nómina</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item custom-menu-laterales" href="#">Pago de IVSS</a>
        <div class="dropdown-divider"></div>
        <a class="dropdown-item custom-menu-laterales" href="#">Pago de Impuestos</a>
      </div>
    </li>
    <li class="nav-item">
      <a class="nav-link custom-menu-laterales" href="#">
        <img data-alt-src="./assets/img/icono_lateral_3_presup_on.png" src="./assets/img/icono_lateral_3_presup_off.png"
          alt="icono_lateral_3_presup_off">
        <br>
        <span class="letras-laterales">PRESUPUESTO</span>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link custom-menu-laterales" href="#">
        <img data-alt-src="./assets/img/icono_lateral_4_buscar_on.png" src="./assets/img/icono_lateral_4_buscar_off.png"
          alt="icono_lateral_4_buscar_off">
        <br>
        <span class="letras-laterales">BUSQUEDA</span>
      </a>
    </li>

    <li class="nav-item dropdown no-arrow">
    <a class="nav-link dropdown-toggle custom-menu-laterales" href="#" id="pagesDropdown1" role="button"
        data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <img data-alt-src="./assets/img/icono_lateral_5_report_on.png" src="./assets/img/icono_lateral_5_report_off.png"
          alt="icono_lateral_5_report_off">
        <br>
        <span class="letras-laterales">REPORTES</span>
      </a>
      <div class="dropdown-menu dropdown-color-azul pagesDropdown1" aria-labelledby="pagesDropdown">
        <a class="dropdown-item custom-menu-laterales" href="index.php?c=app&a=conciliacion">Reporte de Conciliación</a>
        <div class="dropdown-divider"></div>
      </div>
    </li>
    
    <li class="nav-item">
      <a class="nav-link custom-menu-laterales" href="#">
        <img data-alt-src="./assets/img/icono_lateral_6_compar_on.png" src="./assets/img/icono_lateral_6_compar_off.png"
          alt="icono_lateral_6_compar_off">
        <br>
        <span class="letras-laterales">COMPARTIR</span>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link custom-menu-laterales" href="index.php?c=app&a=logout">
        <img src="./assets/img/icono_lateral_7_logout.png" alt="icono_lateral_7_logout">
        <br>
      </a>
    </li>
  </ul>
</nav>

<div id="content-wrapper" class="overlap mb-2">
  <!-- /.container-fluid -->
  <div class="right-panel">
    <p>
      <a class="" href="#">
        <img data-alt-src="./assets/img/icono_calend_on.png" class="" src="./assets/img/icono_calend_off.png" alt="icono_calend_off">
      </a>
    </p>
    <p>
      <a class="" href="#">
        <img data-alt-src="./assets/img/icono_notific_on.png" class="" src="./assets/img/icono_notific_off.png"
          alt="icono_notific_off">
      </a>
    </p>
    <p>
      <a class="" href="#">
        <!--<a class="" href="#" data-toggle="modal" data-target=".bd-example2-modal-md" href="#" id="calculadora">-->
        <img data-alt-src="./assets/img/icono_calculador_on.png" class="" src="./assets/img/icono_calculador_off.png"
          alt="icono_calculador_off">
      </a>
    </p>
  </div>

  <?php require_once 'navbar.php'; ?>