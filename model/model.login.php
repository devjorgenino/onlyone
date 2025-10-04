<?php
require_once("classes/classes.data.php");
class Home_Model {
    public $bd;
    public $referencia;
    public $passwd;
    public $activo=true;

    public function __construct() {
        $this->dbServer = new Data("onlyone");
    }
    public function login() {
        $query="select * from seguridad.usuarios where referencia='".$this->referencia."' and passwd='".MD5($this->passwd)."' and activo='".$this->activo."' ";
        return $this->consultas($query);
    }
    public function recuperar_clave($id) {
        $query="select * from seguridad.usuarios where referencia='".$id."' ";
        return $this->consultas($query);
    }
    public function consultas($sql){
        $this->dbServer->connect();
        $res=$this->dbServer->getQuery($sql);
            if (pg_num_rows($res) > 0) {
                $ret=pg_fetch_all($res);
            } else {
                $ret = -1;
            }
            return $ret;
    }
    
}
?>
