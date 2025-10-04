<?php

class Apppagos {
    
    protected $id = 0;
    protected $dbName;
    public $dbServer;

    public function __construct($db = null) {
       // echo 'iniciando';
       $this->dbServer = new PostgreDB();
    }
    /*********************************usuario****************************************/
    public function APP_n_usuario($array,$code,$empresa){
        $sql="INSERT INTO seguridad.usuario_invitado (codigo,email,empresa,rol) VALUES ('".$code."','".$array['correo']."','".$empresa."',1)";
        return $this->insertar($sql);
    }
    public function APP_v_usuario($email){
        $sql="SELECT (SELECT COUNT(*) FROM seguridad.usuario where email='".$email."') AS V_U, (SELECT COUNT(*) FROM seguridad.usuario_invitado where email='".$email."') AS V_I";
        return $this->consultas($sql);
    }
    public function APP_ct_usuario($usuario){
        $sql="SELECT *, (select COUNT(*) as yes from seguridad.usuario where email=u.email ),  (select nombre from seguridad.roles where id=u.rol ) as roll FROM seguridad.usuario_invitado as u where u.empresa='".$usuario."'";
        return $this->consultas($sql);
    }
    public function APP_cs_usuario($email){
        $sql="SELECT CONCAT(nombre,' ', apellido) as nombre  FROM seguridad.usuario where email='".$email."'";
        return $this->consultas($sql);
    }
    /*********************************usuario****************************************/
    /*********************************facturas****************************************/
    public function APP_n_factura($array,$empresa){
        $sql="INSERT INTO administracion.facturas (numero,email,empresa,nombre_cliente,descripcion, monto, fecha) 
        VALUES ('".$array['f_numero']."','".$array['f_correo']."','".$empresa."','".$array['f_cliente']."','".$array['f_descripcion']."','".$array['f_monto']."','".$array['f_fecha']."')";
        return $this->insertar($sql);
    }
    public function APP_ct_facturas($empresa){
        $sql="SELECT *, (select nombre from seguridad.estatus_facturas where id=af.estatus_fact) as estatuss FROM administracion.facturas af  where af.empresa=".$empresa."";
        return $this->consultas($sql);
    }
     /********************************facturaso****************************************/
     /*********************************Reporte de PAgo****************************************/
    public function APP_ct_reporte($empresa){
        $sql="  SELECT ar.estatus_rep,cuenta_detallada,fecha_pago,nombre,ar.id,ar.idcuenta,ar.numero_operacion,SUM(af.monto) as monto,COUNT(*) as total_faturas ,(select nombre from seguridad.estatus_reporte_pago where id=ar.estatus_rep) as nombreEstatus
        FROM  dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,cuenta_detallada FROM bancos.v_bancos4') as (codigo integer ,cuenta_detallada VARCHAR)
        INNER JOIN administracion.reporte_pagos ar on ar.idcuenta = codigo INNER JOIN administracion.reporte_pago_factura af on ar.id=af.idpago
        where ar.empresa='".$empresa."'
        GROUP BY af.idpago,ar.id,ar.idcuenta,cuenta_detallada
        ORDER BY ar.id desc";
        return $this->consultas($sql);
    }
    public function APP_c_reporte($id){
        $sql="SELECT (SELECT nombre from maestros.tipo_operacion where id=CAST(ar.tipo_operacion AS INTEGER)) as tipo,*,(SELECT SUM(MONTO) FROM administracion.reporte_pago_factura where idpago=ar.id) as total,(select nombre from seguridad.estatus_reporte_pago where id=ar.estatus_rep) as nombreEstatus
        FROM  dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,cuenta_detallada FROM bancos.v_bancos4') as (codigo integer ,cuenta_detallada VARCHAR)
        INNER JOIN administracion.reporte_pagos ar on ar.idcuenta = codigo INNER JOIN administracion.reporte_pago_factura af on ar.id=af.idpago
        where ar.id='".$id."'" ;
        return $this->consultas($sql);
    }
    public function reporte_pendientes($empresa){
        $sql="SELECT count(*) as total FROM administracion.reporte_pagos where estatus_rep=1 and empresa='".$empresa."'";
        return $this->consultas($sql)[0]['total'];
    }
    public function APP_e_concialiacion($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=2,
            movimiento=(select idd from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia,monto, fecha,cuenta from bancos.movimientos where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float, fecha  DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia and fecha=fecha_pago and  (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='1' and ap.id=rps.id )
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia,monto, fecha, cuenta from bancos.movimientos where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float,fecha  DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia and fecha=fecha_pago and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta  and ap.tipo_operacion='1' and estatus_rep = 1 and ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar($sql);
    }
    public function APP_e_concialiacionmd($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=3,
            movimiento=(select idd from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia,monto, fecha,cuenta from bancos.movimientos where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float, fecha  DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia and fecha=fecha_pago and  (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='1' and ap.id=rps.id )
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia,monto, fecha, cuenta from bancos.movimientos where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float,fecha  DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia and fecha=fecha_pago and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta  and ap.tipo_operacion='1' and estatus_rep = 1 and ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar($sql);
    }
    public function conciliacion_OB_banesco($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps 
        SET estatus_rep=2, movimiento=(SELECT id_cuenta FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,cuenta,codigo_trans,cedula_trans,monto,fecha  from bancos.v_movimientobanescoconciliar where usuario=".$empresa."') as (id_cuenta INTEGER, cuenta integer, codigo_trans varchar(30),cedula_trans varchar,monto float, fecha date ) INNER JOIN administracion.reporte_pagos ar on cuenta=ar.idcuenta and cedula_trans=ar.doc where ar.movimiento=0 and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ar.id)=monto and fecha_pago BETWEEN fecha and (fecha+5) and estatus_rep=1 and codigo_trans=codigocuenta  and tipo_operacion='2' and id=rps.id)
        WHERE empresa='".$empresa."' and
         rps.id in (SELECT ar.id FROM dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,cuenta,codigo_trans,cedula_trans,monto,fecha  from bancos.v_movimientobanescoconciliar where usuario=".$empresa."') as (id_cuenta INTEGER, cuenta integer, codigo_trans varchar(30),cedula_trans varchar,monto float, fecha date ) INNER JOIN administracion.reporte_pagos ar on cuenta=ar.idcuenta and cedula_trans=ar.doc where ar.movimiento=0 and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ar.id)=monto and fecha_pago BETWEEN fecha and (fecha+5) and estatus_rep=1 and codigo_trans=codigocuenta  and tipo_operacion='2' and id=rps.id);";
        return $this->modificar($sql);
    }
    public function conciliacion_OB_bod($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=2,
            movimiento=(select idd from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia,monto, fecha,cuenta from bancos.v_movimientobodconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id)
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia,monto, fecha,cuenta from bancos.v_movimientobodconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5 and ap.movimiento=0 and  ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar($sql);
    }
    public function conciliacion_OB_bodmd($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=2,
            movimiento=(select idd from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia,monto, fecha,cuenta from bancos.v_movimientobodconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id)
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia,monto, fecha,cuenta from bancos.v_movimientobodconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5 and ap.movimiento=0 and  ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar($sql);
    }
    public function conciliacion_OB_bnc($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=2,
            movimiento=(select idd from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia_2,monto, fecha,cuenta from bancos.v_movimientobncconciliar where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id)
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia_2,monto, fecha,cuenta from bancos.v_movimientobncconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5 and ap.movimiento=0 and  ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar($sql);
    }
    public function conciliacion_OB_bncmd($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=2,
            movimiento=(select idd from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia_2,monto, fecha,cuenta from bancos.v_movimientobncconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id)
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=127.0.0.1 port=5432 dbname=onlyone user=geekhack password=geekHACK-12345+', 'SELECT id,referencia_2,monto, fecha,cuenta from bancos.v_movimientobncconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5 and ap.movimiento=0 and  ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar($sql);
    }
    public function actulizar_facturas_conciliadas($id){
        $sql="UPDATE administracion.facturas SET estatus_fact=3 WHERE numero=(SELECT numero FROM administracion.reporte_pago_factura where idpago=".$id." limit 1)";
        return $this->modificar($sql);
    }
    public function reportes_conciliacion($id){
        $sql="SELECT   cr.id_reporte,cr.total_c,cr.total_nc,cr.total_ncm,cr.fecha_reporte  FROM conciliacion.v_conciliacionreportes cr where empresa='".$id."' group by id_reporte,total_c,total_nc,total_ncm,fecha_reporte";
        return $this->consultas($sql);
    }
    public function conciliado_noconciliados($id){
        $sql="SELECT (SELECT COUNT(*) from  administracion.reporte_pagos where estatus_rep=1 and movimiento=0 and empresa='".$id."') as no_conciliados,(SELECT COUNT(*) from  administracion.reporte_pagos where estatus_rep=2 and movimiento<>0 and empresa='".$id."') as conciliados";
        return $this->consultas($sql);
    }
    public function conciliado_nocinciliados_xbancos($id){
        $sql=" SELECT bm.razon_comercial ,SUM((SELECT sum(monto) FROM administracion.reporte_pago_factura where idpago=rp.id )) as total,SUM((SELECT sum(monto) FROM administracion.reporte_pago_factura where idpago=rp.id and rp.movimiento<> 0 and  rp.estatus_rep=2)) as total_2,SUM((SELECT sum(monto) FROM administracion.reporte_pago_factura where  rp.estatus_rep not in(2) and idpago=rp.id )) as total_3 
        FROM administracion.reporte_pagos rp inner join maestros.bancos bm on rp.idbanco_tipo_operacion=bm.id where empresa='".$id."' group by idbanco_tipo_operacion,bm.razon_comercial ;";
        return $this->consultas($sql);
    }
     /********************************facturaso****************************************/
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
    public function insertar($sql){
        $this->dbServer->connect();
        $res=$this->dbServer->getQuery($sql);
        $res=pg_affected_rows($res);
        return $res;
    }
    public function eliminar($sql){
        $this->dbServer->connect();
        $res=$this->dbServer->getQuery($sql);
        $res=pg_affected_rows($res);
        return $res;
    }
    public function modificar($sql){
        $this->dbServer->connect();
        $res=$this->dbServer->getQuery($sql);
        return $res;
    }
}
class PostgreDB {
    protected $conn;
    private $host = "localhost";
    private $port = "5432";
    private $user = "geekhack";
    private $pass = "geekHACK-12345+";
    private $dbName = "apppagos";
    private $db;
    private $strConn = "";

    public function __construct() {
        $this->setStringConnection();
    }

    public function __destruct() {

    }

    public function host() {
        return $this->host;
    }

    public function dbName() {
        return $this->dbName;
    }

    public function connect() {
        $this->conn = pg_connect($this->strConn);
    }

    public function disconnect() {
        $close = false;
        if ($this->conn != null) {
            $close = pg_close($this->conn);
        }
        if ($close) {
            //echo 'La desconexion de la base de datos se ha hecho satisfactoriamente';
        } else {
            //echo 'Ha sucedido un error inexperado en la desconexion de la base de datos';
        }
        return $close;
    }

    private function setStringConnection() {
        $this->strConn = "host='".$this->host . "'port='" . $this->port . "'dbname='" .  $this->dbName . "'user='" . $this->user . "'password='" . $this->pass . "'";
    }

    public function setDB($db) {
        $this->dbName = $db;
        $this->setStringConnection();
    }

    public function getQuery($sql) {
        $result = pg_query($this->conn, $sql);
        return $result;
    }

}
?>