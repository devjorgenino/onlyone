<?php

class Base {
    protected $id = 0;
    protected $codigo = "";
    public $referencia = "";
    protected $estatus = 0;
    protected $fecha_creacion = "";
    protected $fecha_mod = "";
    public $activo = false;

    public function id() {
        return $this->id;
    }

    public function codigo() {
        return $this->codigo;
    }

    public function estatus() {
        return $this->estatus;
    }

}

class Rol extends Base {
    public $rol="";
    private $acceso;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }
    public function getId() {
        return $this->$_id;
    }
    public function getCodigo() {
        return $this->$codigo;
    }
    public function getRef() {
        return $this->$ref;
    }
    public function setId($value) {
        $this->$_id=$value;
    }
    public function setCodigo($value) {
        $this->$codigo=$value;
    }
    public function setRef($value) {
        $this->$ref=$value;
    }
}

class Usuario extends Base {
    private $passwd="";
    public $email="";
    protected $logged=false;
    public $nombre;
    public $apellido;
    public $telefono;
    public $ciudad;
    public $pais;
    public $zona_postal;
    private $datos;
    private $collection = "usuarios";
    protected $cambio_passwd = false;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
        $this->datos = new  Data();
    }

    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function logged() {
        return $this->logged;
    }

    public function cambioClave() {
        return $this->cambio_passwd;
    }

    private function getPassword() {
        //$tmp=QUERY DB FOR $this->usuario PASSWORD
        return $tmp;
    }

    private function setPasswd($passwd) {
        $this->$passwd=$passwd;
    }

    private function loadArray($data) {
        foreach ($data as $key => $value) {
            $this->$key = $value;
        }
    }

    private function getDBRecord() {
        $datos->startConn();
        $res = $datos->buscarPorRef($this->collection, $this->referencia);
        if ($res) {
            $data = pg_fetch_assoc($res);
            $this->loadArray($data);
        }
        $datos->stopConn();
    }

    public function login($usuario, $clave) {
        $this->$referencia = $usuario;
        $this->getDBRecord();
        if ($clave == $this->passwd) {
            $this->$logged=true;
        }
        return $this->$logged;
    }

    public function logout() {
        $this->$logged=false;
    }

    public function cargarUsuario($key) {
        $datos->startConn();
        $res = $datos->buscarPorRef($this->collection, $key);
        if ($res) {
            $data = pg_fetch_assoc($res);
            $this->loadArray($data);
        }
    }

}

class Direccion extends Base {
    public $titulo="";
    public $direccion="";
    public $ciudad="";
    public $estado="";
    public $pais;
    public $cod_postal;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function getMongoArray() {
        $tmp=array(
            "_id"=>$this->$_id=0,"codigo"=>$this->$codigo,"ref"=>$this->$ref,"estatus"=>$this->$estatus,
            "titulo"=>$this->$titulo,"direccion"=>$this->$direccion,"ciudad"=>$this->$ciudad,"estado"=>$this->$estado,"pais"=>$this->$pais,
            "cod_postal"=>$this->$cod_postal
        );
        return $tmp;
    }

}

class Telefono  extends Base {
    protected $idTelefono=0;
    protected $titulo="";
    protected $cod_pais="";
    protected $cod_area="";
    protected $telefono="";
    protected $pais;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }
    
    public function getMongoArray() {
        $tmp=array(
            "_id"=>$this->$_id=0,"codigo"=>$this->$codigo,"ref"=>$this->$ref,"estatus"=>$this->$estatus,
            "titulo"=>$this->$titulo,"codPais"=>$this->$cod_pais,"codArea"=>$this->$cod_area,
            "telefono"=>$this->$telefono,"pais"=>$this->$pais,
            "activo"=>$this->$activo
        );
        return $tmp;
    }
}

class Divisa extends Base {
    protected $titulo="";
    protected $simbolo="";
    protected $base=false;
    public $pais;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function tasa($fecha) {}

    public function getMongoArray() {
        $tmp=array(
            "_id"=>$this->$_id=0,"codigo"=>$this->$codigo,"ref"=>$this->$ref,"estatus"=>$this->$estatus,
            "titulo"=>$this->$titulo,"simbolo"=>$this->$simbolo,"base"=>$this->$base,
            "activo"=>$this->$activo
        );
        return $tmp;
    }
}

class Divisa_Tasa {
    protected $fecha;
    protected $tasa=0.00;
    protected $divisa="";
    protected $Divisa_fk;
    protected $movimiento="";

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function getMongoArray() {
        $tmp=array(
            "_id"=>$this->$_id=0,"fecha"=>$this->$fecha,"tasa"=>$this->$tasa,"divisa"=>$this->$divisa,
            "Divisa_fk"=>$this->$Divisa_fk,"movimiento"=>$this->$movimiento
        );
        return $tmp;
    }

}

class Pais extends Base {
    public $pais="";
    public $cod_telefono="";
    public $divisa="";
    public $utc=0;
    public $base=false;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function getMongoArray() {
        $tmp=array(
            "_id"=>$this->$_id=0,"codigo"=>$this->$codigo,
            "pais"=>$this->$pais,"codTelefono"=>$this->$codTelefono,"base"=>$this->$base,
            "activo"=>$this->$activo
        );
        return $tmp;
    }
}

class Categoria extends Base {
    protected $titulo="";
    protected $descripcion="";
    public $icono;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    protected function buscar($id) {}

}

class SubCategoria extends Categoria {
    protected $categoria;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    protected function buscar($id) {}
    
}
/*
//Test classes
class Usuario_Test extends Usuario {

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
        //$this->datos = new  Data();
        $this->id = 1;
        $this->codigo = "";
        $this->referencia = "admin";
        $this->estatus = 0;
        $this->fecha_creacion = "2019-03-22 15:03:00-04";
        $this->fecha_mod = "";
        $this->activo = true;
        $this->passwd = "beni123";
        $this->email = "bb@geekhack.net.ve";
        $this->logged = true;
        $this->nombre = "Bernardo";
        $this->apellido = "Bossio";
        $this->telefono = "+58-0414-7927663";
        $this->ciudad = "Los Robles";
        $this->pais = "Venezuela";
        $this->zona_postal = "6301";
        $this->cambio_passwd = false;
    }

    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function logged() {
        return $this->logged;
    }
}*/

?>
