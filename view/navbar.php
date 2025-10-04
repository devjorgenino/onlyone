<nav class="navbar navbar-expand-lg navbar-margin">
  <a class="navbar-brand" href="index.php?c=app&a=dashboard" ><img src="./assets/img/logo only one 1280.svg"  class="svg" alt="logo_onlyone"></a>
  <button class="navbar-toggler custom-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>
  <div class="collapse navbar-collapse custom-navbar" id="navbarNav">
    <ul class="navbar-nav text-center mr-auto custom-margin-menu">
      <li class="nav-item no-arrow mx-1 d-block d-md-none">
        <a class="nav-link custom-menu-superior" href="index.php?c=app&a=dashboard">
          <span class="navbar-icon"><img data-alt-src="./assets/img/icono_lateral_1_hoy_on.png"
              src="./assets/img/icono_lateral_1_hoy_off.png"
              alt="icono_lateral_1_hoy_off"></span><U><?php echo 'Hoy '.date("d/m/Y");?></U>
        </a>
      </li>
      <li class="nav-item dropdown no-arrow mx-1 d-block d-md-none">
        <a class="nav-link custom-menu-superior dropdown-toggle" href="#" id="pagesDropdown2" role="button"
          data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="navbar-icon"><img data-alt-src="./assets/img/icono_lateral_2_realizar_on.png"
              src="./assets/img/icono_lateral_2_realizar_of.png"
              alt="icono_lateral_2_realizar_of"></span><U>REALIZAR</U>
        </a>
        <div class="dropdown-menu dropdown-menu-right pagesDropdown2" aria-labelledby="pagesDropdown">
          <a class="dropdown-item custom-menu-superior" href="index.php?c=app&a=movimientos">Consulta de Saldos y
            Movimientos</a>
          <a class="dropdown-item custom-menu-superior" data-toggle="modal" data-target="#importar" >Importar Movimientos</a>
          <a class="dropdown-item custom-menu-superior" href="index.php?c=app&a=AppPagos">Conciliación</a>
          <a class="dropdown-item custom-menu-superior" href="#">Transferencias</a>
          <a class="dropdown-item custom-menu-superior" href="#">Pago de Nómina</a>
          <a class="dropdown-item custom-menu-superior" href="#">Pago de IVSS</a>
          <a class="dropdown-item custom-menu-superior" href="#">Pago de Impuestos</a>
        </div>
      </li>
      <li class="nav-item no-arrow mx-1 d-block d-md-none">
        <a class="nav-link custom-menu-superior" href="#">
          <span class="navbar-icon"><img data-alt-src="./assets/img/icono_lateral_3_presup_on.png"
              src="./assets/img/icono_lateral_3_presup_off.png"
              alt="icono_lateral_3_presup_off"></span><U>PRESUPUESTO</U>
        </a>
      </li>
      <li class="nav-item no-arrow mx-1 d-block d-md-none">
        <a class="nav-link custom-menu-superior" href="#">
          <span class="navbar-icon"><img data-alt-src="./assets/img/icono_lateral_4_buscar_on.png"
              src="./assets/img/icono_lateral_4_buscar_off.png"
              alt="icono_lateral_4_buscar_off"></span><U>BIBLIOTECA</U>
        </a>
      </li>
      <li class="nav-item  dropdown no-arrow mx-1 d-block d-md-none">
        <a class="nav-link custom-menu-superior" href="#" id="pagesDropdown3" role="button" data-toggle="dropdown"
          aria-haspopup="true" aria-expanded="false">
          <span class="navbar-icon"><img data-alt-src="./assets/img/icono_lateral_5_report2_on.png"
              src="./assets/img/icono_lateral_5_report2_off.png"
              alt="icono_lateral_5_report2_off"></span><U>REPORTES</U>
        </a>
        <div class="dropdown-menu dropdown-menu-right pagesDropdown3" aria-labelledby="pagesDropdown">
          <a class="dropdown-item custom-menu-superior" href="index.php?c=app&a=conciliacion">Reporte de Conciliación</a>
        </div>
      </li>
      <li class="nav-item no-arrow mx-1 d-block d-md-none">
        <a class="nav-link custom-menu-superior" href="#">
          <span class="navbar-icon"><img data-alt-src="./assets/img/icono_lateral_6_compar_on.png"
              src="./assets/img/icono_lateral_6_compar_off.png" alt="icono_lateral_6_compar_off"></span><U>COMPARTIR</U>
        </a>
        <div class="menu-separator"></div>
      </li>
      <li class="nav-item no-arrow mx-1">
        <a class="nav-link custom-menu-superior" href="#">
          <U>Usuarios</U>
        </a>
      </li>
      <li class="nav-item dropdown no-arrow mx-1">
        <a class="nav-link custom-menu-superior" href="#">
          <U>Empresas</U>
        </a>
      </li>
      <li class="nav-item dropdown no-arrow mx-1">
        <a class="nav-link custom-menu-superior" href="#">
          <U>Bancos</U>
        </a>
      </li>
      <li class="nav-item dropdown no-arrow">
        <a class="nav-link custom-menu-superior dropdown-toggle" href="#" id="userDropdown" role="button"
          data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <U>Productos</U>
        </a>
        <div class="dropdown-menu dropdown-menu-right userDropdown" aria-labelledby="userDropdown">
          <a class="dropdown-item custom-menu-superior" href="index.php?c=app&a=cuentas">Cuentas</a>
          <a class="dropdown-item custom-menu-superior" href="#">Criptoactivos</a>
          <a class="dropdown-item custom-menu-superior" href="#">Acciones</a>
          <a class="dropdown-item custom-menu-superior" href="#">Bonos</a>
          <a class="dropdown-item custom-menu-superior" href="#">Propiedades</a>
        </div>
      </li>
      <li class="nav-item dropdown no-arrow mx-1">
        <a class="nav-link custom-menu-superior dropdown-toggle" href="#">
          <U>Claves</U>
        </a>
      </li>
      <li class="nav-item dropdown no-arrow mx-1">
        <a class="nav-link custom-menu-superior dropdown-toggle" href="#">
          <U>Monedas</U>
        </a>
      </li>
      <li class="nav-item dropdown no-arrow mx-1">
        <a class="nav-link custom-menu-superior dropdown-toggle" href="#">
          <U>Vistas</U>
        </a>
      </li>
      <li class="nav-item dropdown no-arrow mx-1 d-block d-md-block d-lg-none d-xl-none">
        <a class="nav-link custom-menu-superior dropdown-toggle" href="index.php?c=app&a=logout">
          <U>LOGOUT</U>
        </a>
      </li>
    </ul>
  </div>
</nav>