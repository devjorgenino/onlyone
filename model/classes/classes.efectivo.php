<?php
/*
class Base {
    protected $id = 0;
    protected $codigo = "";
    public $referencia = "";//**
    protected $estatus = 0;
    protected $fecha_creacion = "";//**
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
*/
class Entidad  extends Base {
    public $rif="";//**
    public $telefono;
    public $email="";//**
    public $direccion;
    public $ciudad;
    public $pais;
    public $zona_postal;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function buscarDireccion() {}

    public function buscarTelefono() {}

    public function getReferencia($class,$prefix) {
        $contador=0;//buscar valor de contador;
        $tmp=$prefix + str_pad(++$contador, 4, "0", STR_PAD_LEFT) + date("Ymd");
        return $tmp;
    }

}

class Titular extends Entidad {
    protected $usuario;
    public $tipo; //Natura/Juridico
    public $nombre; // si es juridico => razon comercial
    public $apellido; // si es juridico => razon social

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }

    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }
}

class Banco extends Entidad {
    public $razon_social="";
    public $razon_comercial;//**

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    private function divisa() {}

    public function getReferencia($class = null,$prefix = 'BCO') {
        $contador=0;//buscar valor de contador;
        $tmp=$prefix + str_pad(++$contador, 4, "0", STR_PAD_LEFT) + date("Ymd");
        $tmp="BCO" + str_pad(++$contador, 3, "0", STR_PAD_LEFT) + date("Ymd");
        return $tmp;
    }
}

class Banco_Cuenta extends Base {
    protected $usuario;
    protected $numero="";
    protected $aba="";
    protected $swift="";
    protected $iban="";
    protected $bic="";
    protected $saldo_inicial = 0.00;
    protected $tipo="";
    protected $divisa= 0.00;
    protected $banco ="";//**
    protected $coleccion;
    public $titulo ="";//**
    public $saldo = 0.00;//**
    public $fecha_saldo="";//**
    public $codigo="";//**
    public $referencia="";//**
    public $modelAppModel;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
        $this->coleccion="bancos.cuentas";
        $this->modelAppModel =new App_Model();
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function getMongoArray() {
        $tmp=array(
            "_id"=>$this->$_id=0,"fecha"=>$this->$fecha,"codigo"=>$this->$codigo,"ref"=>$this->$ref,"numero"=>$this->$numero,
            "aba"=>$this->$aba,"swift"=>$this->$swift,"iban"=>$this->$iban,"saldo_inicial"=>$this->$saldo_inicial,
            "estatus"=>$this->$estatus,"divisa_fk"=>$this->$Divisa_fk,"tipo"=>$this->$tipo,"banco_fk"=>$this->$Banco_fk,
            "activo"=>$this->$activo
        );
        return $tmp;
    }

    public function getReferencia() {
        $contador=0;//buscar valor de contador;
        $tmp="CTA" + str_pad(++$contador, 4, "0", STR_PAD_LEFT) + date("Ymd");
        return $tmp;
    }

    public function accionesBD($query) {

        $this->modelAppModel->bd->startConn();
        $res = $this->modelAppModel->bd->query($query);
        $this->modelAppModel->bd->stopConn();
        return $res;
    }

    public function iniciarVariable($tipo,$montoCuenta,$banco,$numCuenta,$codBanco,$divisa,$id)
    {
        $this->usuario=$id;
        $this->numero=$codBanco.$numCuenta;
        $this->aba="aba";
        $this->swift=3333;
        $this->iban="iban";
        $this->bic="bic";
        $this->saldo_inicial = $montoCuenta;
        $this->tipo=$tipo;
        $this->divisa= $divisa;
        $this->banco =$banco;//**
        $this->titulo ="titulos";//**
        $this->saldo = $montoCuenta;//**
        $this->fecha_saldo=date("Y-m-d");//**
        $this->codigo=$codBanco;//**
        $this->referencia=$codBanco.$numCuenta;//**
    }

    public function registrarCuenta(){   // lcdo Erick Brito
        //$this->bd->startConn();

        $query= "SELECT * FROM bancos.v_usuarioCuenta";
        $query.= " WHERE numero='".$this->numero."' and cod='".$this->codigo."' and idusuario=".$this->usuario;
        $resp =$this->accionesBD($query);
        if (pg_num_rows($resp) > 0) {
            return -2;
        } else {

            $query= "insert into ".$this->coleccion." (codigo, referencia, estatus, fecha_mod, activo,
                numero, aba, iban, bic, tipo, divisa, banco, saldo_inicial, titulo, saldo, fecha_saldo, swift, usuario)
                values(
                '".$this->codigo."',
                '".$this->referencia."',
                1 ,
                '".date('Y-m-d')."' ,
                true,
                '".$this->numero."',
                '".$this->aba."' ,
                '".$this->iban."' ,
                '".$this->bic."' ,
                ".$this->tipo." ,
                ".$this->divisa." ,
                ".$this->banco." ,
                ".$this->saldo_inicial." ,
                '".$this->titulo."' ,
                ".$this->saldo." ,
                '".date('Y-m-d')."' ,
                ".$this->swift." ,
                ".$this->usuario." )";
            $resp =$this->accionesBD($query);
            if($resp>0):
                return 1;
            else:
                return -1;
            endif;
        }
    }
    public function editarCuenta($id){   // lcdo Erick Brito
        //$this->bd->startConn();

        $query= "SELECT * FROM bancos.v_usuarioCuenta";
        $query.= " WHERE numero='".$this->numero."' and cod='".$this->codigo."' and idcuenta!=".$id;
        $respu =$this->accionesBD($query);
        if (pg_num_rows($respu) >0){
            return -2;
        }
        else{

            $query= "update ".$this->coleccion." set
                codigo= '".$this->codigo."',
                referencia='".$this->referencia."',
                estatus=1,
                fecha_mod='".date('Y-m-d')."',
                activo=true,
                numero='".$this->numero."',
                aba='".$this->aba."',
                iban='".$this->iban."',
                bic='".$this->bic."',
                tipo=".$this->tipo.",
                divisa=".$this->divisa.",
                banco=".$this->banco.",
                saldo_inicial= ".$this->saldo_inicial.",
                titulo='".$this->titulo."',
                saldo=".$this->saldo.",
                fecha_saldo= '".date('Y-m-d')."',
                swift=".$this->swift."
                where id =".$id;


            $resp =$this->accionesBD($query);
            if($resp>0):
                return 1;
            else:
                return -1;
            endif;
        }
    }

    public function consultarCuenta($id){   // lcdo Erick Brito

        $query= 'SELECT * FROM bancos.v_usuariocuenta';
        $query.= ' WHERE idusuario='.intval($id);
        $resp =$this->accionesBD($query);

        //print_r($resp);
        if (pg_num_rows($resp) > 0) {
            $row=pg_fetch_all($resp);
        } else {
            $row = [];
        }
        return $row;
    }
    public function buscarCuenta($id){   // lcdo Erick Brito

        $query= 'SELECT * FROM bancos.v_usuarioCuenta';
        $query.= ' WHERE idcuenta='.intval($id);
        $resp =$this->accionesBD($query);

        if (pg_num_rows($resp) > 0) {
            $row=pg_fetch_all($resp);
        } else {
            $row = -1;
        }
        return $row;
    }
}

class Banco_Movimiento extends Base {
    //principales --> importados de movimientos bancarios
    protected $usuario;
    public $fecha=""; //inluye hora//**
    public $monto=0.00;//**
    public $divisa;
    public $tipo = "";
    public $operacion = "";
    public $descripcion = "";//**
    //secundarios (otra tabla) --> informacion adicional introducida por el usuario
    public $categoria;//**
    public $sub_categoria;//**
    public $titular;
    public $nota;
    public $cuenta;//**

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }

    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }
}

class Efectivo_Entrada  extends Banco_Movimiento {
    protected $Forma_Recepcion_fk;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
        $this->$tipo="entrada";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function getMongoArray() {
        $this->$ref=$this->getReferencia("Efectivo_Entrada","EEN");
        $tmp=array(
            "_id"=>$this->$_id=0,"fecha"=>$this->$fecha,"codigo"=>$this->$codigo,"ref"=>$this->$ref,"origen"=>$this->$origen,
            "destino"=>$this->$destino,"monto"=>$this->$monto,"estatus"=>$this->$estatus,"Divisa_fk"=>$this->$Divisa_fk,"tipo"=>$this->$tipo,
            "forma_recepcion_fk"=>$this->$Forma_Recepcion_fk,
            "activo"=>$this->$activo
        );
        return $tmp;
    }

}

class Efectivo_Salida extends Banco_Movimiento {
    protected $Forma_Envio_fk;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
        $this->$tipo="salida";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    public function getMongoArray() {
        $this->$ref=$this->getReferencia("Efectivo_Salida","ESA");
        $tmp=array(
            "_id"=>$this->$_id=0,"fecha"=>$this->$fecha,"codigo"=>$this->$codigo,"ref"=>$this->$ref,"origen"=>$this->$origen,
            "destino"=>$this->$destino,"monto"=>$this->$monto,"estatus"=>$this->$estatus,"Divisa_fk"=>$this->$Divisa_fk,"tipo"=>$this->$tipo,
            "forma_envio_fk"=>$this->$Forma_Envio_fk,
            "activo"=>$this->$activo
        );
        return $tmp;
    }

}

class Efectivo_Cambio extends Banco_Movimiento {
    public $monto_divisa=0.00;
    protected $Divisa2_fk;
    protected $tasa=0.00;
    public $comisiones=0.00;
    protected $movimientos;//Areglo con movimientos de entrada y salida de efectivo

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }

    private function calcularTasa() {
        $this->tasa = $this->monto / $this->monto_divisa;
    }

    public function nuevo() {
        $this->$_id = new MongoId();
        $this->calcularTasa();
        $entrada->$_id = new MongoId();
        $entrada=new Efectivo_Entrada();
        $entrada->$fecha=$this->$fecha;
        $entrada->$codigo="";
        $entrada->$ref=$this->getReferencia("Efectivo_Entrada","EEN");
        $entrada->$origen;//cuenta
        $entrada->$destino;//cuenta
        $entrada->$monto=$this->$monto_divisa;
        $entrada->$estatus=$this->$estatus;
        $entrada->$Divisa_fk=$this->$Divisa2_fk;
        $entrada->$Forma_Recepcion_fk="";
        //SALVAR ENTRADA DE EFECTIVO
        $salida->$_id = new MongoId();
        $salida=new Efectivo_Salida();
        $salida->$fecha=$this->$fecha;
        $salida->$codigo="";
        $salida->$ref=$this->getReferencia("Efectivo_Salida","ESA");
        $salida->$origen;//cuenta
        $salida->$destino;//cuenta
        $salida->$monto=$this->$monto;
        $salida->$estatus=$this->$estatus;
        $salida->$Divisa_fk=$this->$Divisa_fk;
        $salida->$Forma_Envio_fk="";
        //SALVAR SALIDA DE EFECTIVO
        $this->$movimientos=array('entrada'=>$entrada->$_id, 'salida'=>$salida->$_id);
        $this->$ref=$this->getReferencia("Efectivo_Cambio","ECA");
        //SALVAR MOVIMIENTO
    }

    public function verTasa() {
        if ($this->tasa == 0.00) {
            $this->calcularTasa();
        }
        return $this->tasa;
    }

    public function verTasa_Real() {
        $tmp = ($this->$monto - $this->$comisiones) / $this->$monto_divisa;
        return $tmp;
    }

    public function getMongoArray() {
        $tmp=array(
            "_id"=>$this->$_id=0,"fecha"=>$this->$fecha,"codigo"=>$this->$codigo,"ref"=>$this->$ref,"origen"=>$this->$origen,
            "destino"=>$this->$destino,"monto"=>$this->$monto,"estatus"=>$this->$estatus,"Divisa_fk"=>$this->$Divisa_fk,"tipo"=>$this->$tipo,
            "monto_divisa"=>$this->$monto_divisa,"divisa2_fk"=>$this->$Divisa2_fk,"tasa"=>$this->$tasa,"comisiones"=>$this->$comisiones,
            "activo"=>$this->$activo
        );
        return $tmp;
    }
}

?>