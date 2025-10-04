<body class="fondo1">
  <div class="contenedor">


    <div class="row2">

      <div class="col">
        <div class="borderr row">
          <img src="./assets/img/login/00_login_1280.psd_0011_Capa-15.png" class="img-fluid">
          <img src="./assets/img/login/00_login_1280.psd_0012_Capa-16.png" class="img-fluid">
          <img src="./assets/img/login/00_login_1280.psd_0013_Capa-17.png" class="img-fluid">
        </div>

        <div class="row justify-content-center">
          <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body">
              <div class="row">
                <div class="p-4">
                  <div class="col-lg-12 text-center">
                    <div class="text-center mb-5">
                      <img src="./assets/img/login/00_login_1280_0002_Capa-5.png" alt="logo_onlyone" class="logoLogin">
                    </div>
                    <form name="formLogin" method="post" action="?c=home&a=login" id="formLogin">
                      <div class="input-group mb-3">

                        <div class="input-group-prepend">
                          <div class="input-group-text"> <img src="./assets/img/login/00_login_1920_0006_Capa-11.png"
                              alt="" class="UserKey"></div>
                        </div>

                        <input type="text" class="form-control form-control-user" id="nnombre"
                          aria-describedby="emailHelp" placeholder="Usuario" name="nnombre">
                      </div>
                      <div class="input-group ">

                        <div class="input-group-prepend">
                          <div class="input-group-text"> <img src="./assets/img/login/00_login_1280_0005_Capa-10.png"
                              alt="" class="UserKey"></div>
                        </div>
                        <input type="password" class="form-control form-control-user" id="npassword"
                          placeholder="Clave de acceso" name="npassword">
                      </div>
                      <div class="text-right  mb-3">
                        <a class="small" href="#" data-toggle="modal" data-target=".recuperar">Recuperar clave de acceso</a>
                      </div>
                      <div class="text-center">
                        <button class="btn agregar btn-block btn-circle btn-xl" type="submit"
                          style="background: #3399ff !important; color: white !important;	border-color: white !important;">
                          Entrar
                        </button>
                      </div>
                      <hr>
                      <div class="msj"> </div>
                    </form>
                  </div>
                </div>
              </div>

            </div>

          </div>

        </div>
        <div class="text-center agnostica">
          <span class="small" style="color:white;">by Agnostica -- 2019</span>
        </div>

      </div>


      <div class="col fondo2 d-none d-xs-none d-sm-none d-md-none d-lg-block d-xl-block">
          <div class="text-center imgYake">
            <img src="./assets/img/login/00_login_1280_0012_Capa-6.png" width="70%" height="70%" class="img-fluid my-5">
          </div>
          <div class="marginP">
            <p class="textLogin1"> Todos tus productos <br>
            financieros <br>
            en un solo lugar</p>
          </div>
        </div>
      </div>


    </div>
    <?php require_once 'view/modal/reset_clave.php'; ?>
</body>