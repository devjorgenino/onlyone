<?php
require_once("classes/classes.data.php");
class App_Model {

    public $bd;
    public $bd_onlyone;
    public $bd_apppagos; 
    public function __construct() {
        $this->bd_onlyone = new Data("onlyone");
        $this->bd_apppagos = new Data("apppagos");
    }
    public function consultas($sql){
        $this->bd_onlyone->connect();
        $res=$this->bd_onlyone->getQuery($sql);
            if (pg_num_rows($res) > 0) {
                $ret=pg_fetch_all($res);
            } else {
                $ret = -1;
            }
            return $ret;
    }
    public function consultas_c($sql){
        $this->bd_apppagos->connect();
        $res=$this->bd_apppagos->getQuery($sql);
            if (pg_num_rows($res) > 0) {
                $ret=pg_fetch_all($res);
            } else {
                $ret = -1;
            }
            return $ret;
    }
    public function insertar($sql){
        $this->bd_onlyone->connect();
        $res=$this->bd_onlyone->getQuery($sql);
        $res=pg_affected_rows($res);
        return $res;
    }
    public function modificar($sql){
        $this->bd_onlyone->connect();
        $res=$this->bd_onlyone->getQuery($sql);
        return $res;
    }
    public function modificar_c($sql){
        $this->bd_apppagos->connect();
        $res=$this->bd_apppagos->getQuery($sql);
        return $res;
    }
    public function eliminar($sql){
        $this->bd_onlyone->connect();
        $res=$this->bd_onlyone->getQuery($sql);
        $res=pg_affected_rows($res);
        return $res;
    }
    public function eliminar_c($sql){
        $this->bd_apppagos->connect();
        $res=$this->bd_apppagos->getQuery($sql);
        $res=pg_affected_rows($res);
        return $res;
    }
    public function insertar_esp($sql){
        $this->bd_onlyone->connect();
        $res=$this->bd_onlyone->getQuery($sql);
        return $res;
    }
    /*****************Globales*******************************/
    public function tasa_dolar(){
        $url = 'https://s3.amazonaws.com/dolartoday/data.json'; 
        $obj = json_decode(file_get_contents($url), true); 
        return 'Bs. '.$obj["USD"]["transferencia"]; 
    }
    /*****************Globales*******************************/
    /*****************dashboard*******************************/
    public function conciliado_noconciliados_xbancos($id){
        $sql=" SELECT rp.idbanco_tipo_operacion,bm.razon_comercial ,SUM((SELECT sum(monto) FROM administracion.reporte_pago_factura where idpago=rp.id )) as total,SUM((SELECT sum(monto) FROM administracion.reporte_pago_factura where idpago=rp.id and rp.movimiento<> 0 and  rp.estatus_rep=2)) as total_2,SUM((SELECT sum(monto) FROM administracion.reporte_pago_factura where  rp.estatus_rep not in(2) and idpago=rp.id )) as total_3 
        FROM administracion.reporte_pagos rp inner join maestros.bancos bm on rp.idbanco_tipo_operacion=bm.id where empresa='".$id."' group by idbanco_tipo_operacion,bm.razon_comercial ;";
        return $this->consultas_c($sql);
    }
    public function conciliado_noconciliados($id){
       // $sql="SELECT (SELECT COUNT(*) from  administracion.reporte_pagos where estatus_rep<>1 and movimiento<>0 and empresa='".$id."') as no_conciliados,(SELECT COUNT(*) from  administracion.reporte_pagos where estatus_rep=2 and movimiento<>0 and empresa='".$id."') as conciliados";
        $sql="SELECT  COUNT(*) total_rep,SUM(total) monto_rep, (CASE WHEN estatus_rep=1 THEN 'pendientes' ELSE 'conciliados' END) as tipo
        FROM administracion.v_reportre_pagos 
        WHERE empresa='".$id."'
        GROUP BY estatus_rep";
        return $this->consultas_c($sql);
    }
    public function reporte_vencidos($id){
        $sql="SELECT (fecha_pago+2) as vencido,fecha_pago,id  FROM  administracion.reporte_pagos where (fecha_pago+2) <= now() and estatus_rep=1 and movimiento=0 and empresa='".$id."' ";
        return $this->consultas_c($sql);
    }
    public function consultarCuenta_v($id){   
        $query= 'SELECT * FROM bancos.v_usuariocuenta';
        $query.= ' WHERE retrazado=1 and idusuario='.intval($id).'order by idcuenta desc';
        $resp =$this->consultas($query);
        if ($resp ==-1) {
            return [];
        } else {
            return  $resp;
        }
    }
    /*****************dashboard*******************************/
    /*****************Onlyone Cuentas*******************************/
    public function cargarBancos(){   

        $query= "SELECT * FROM bancos.v_maestrobanco";
        $resp =$this->consultas($query);

        if ($resp ==-1) {
            return [];
        } else {
            return  $resp;
        }
    }
    public function BuscarProductos() {
        $query = "select * from maestros.productos";
        $query .= " WHERE activo='true'";
        $resp =$this->consultas($query);
        return $resp;
    }
    public function consultarCuenta($id){   
        $query= 'SELECT * FROM bancos.v_usuariocuenta';
        $query.= ' WHERE idusuario='.intval($id).'order by idcuenta desc';
        $resp =$this->consultas($query);
        if ($resp ==-1) {
            return [];
        } else {
            return  $resp;
        }
    }
    public function cargarBancosTipo($id){   
        $query= "SELECT * FROM bancos.bancos";
        $query.= " where tipo=".$id;
        return $this->consultas($query);
    }
    public function cargarDivisaTipo($id){   
        $query= "SELECT * FROM maestros.divisas";
        $query.= " where tipo='".$id."'";
        return $this->consultas($query);
    }
    public function validar_cuenta($array,$id){   

        $query= "SELECT * FROM bancos.v_usuarioCuenta";
        $query.= " WHERE numero='".$array['codigoB'].$array['numCuenta']."' and cod='".$array['codigoB']."' and idusuario=".$id;    
        return $this->consultas($query);

    }
    public function registrar_cuenta($array,$id){   

        $query= "insert into bancos.cuentas (codigo, referencia, estatus, fecha_mod, activo,
        numero, aba, iban, bic, tipo, divisa, banco, saldo_inicial, titulo, saldo, fecha_saldo, swift, usuario)
        values(
        '".$array['codigoB']."',
        '".$array['codigoB'].$array['numCuenta']."',
        1 ,
        '".date('Y-m-d')."' ,
        true,
        '".$array['codigoB'].$array['numCuenta']."',
        'aba' ,
        'iban' ,
        'bic' ,
        ".$array['tipoCuenta']." ,
        ".$array['divisa']." ,
        ".$array['banco']." ,
        ".$array['montoCuenta']." ,
        'titulo' ,
        ".$array['montoCuenta']." ,
        '".date('Y-m-d')."' ,
        'swift',
        ".$id." )";
        return $this->insertar($query);
        
    }
    public function BuscarCuentasDetalle($id) {
        $query = "select bc.id,bc.referencia,SUBSTRING( bc.referencia, 5, 19) as cuentaReal,bc.divisa,bc.tipo,bc.banco,bc.saldo,(select tipo from bancos.bancos  where id=bc.banco) as tipo_bancos, (select tipo from maestros.divisas  where id=bc.divisa) as tipo_divisa from bancos.cuentas bc";
        $query .= " WHERE bc.id=".$id."";
        return $this->consultas($query);
    }
    public function validar_cuenta_editar($array,$id){   
        $query= "SELECT * FROM bancos.v_usuarioCuenta";
        $query.= " WHERE numero='".$array['codigoBe'].$array['numCuentae']."' and cod='".$array['codigoBe']."' and idcuenta!=".$array['id'];    
        return $this->consultas($query);
    }
    public function modificar_cuenta($array,$id){
        $query= "UPDATE bancos.cuentas SET";
        $query.= "
        codigo= '".$array['codigoBe']."',
        referencia='".$array['codigoBe'].$array['numCuentae']."',
        numero='".$array['codigoBe'].$array['numCuentae']."',
        banco=".$array['bancoe'].",
        tipo=".$array['tipoCuentaE'].",
        saldo=".floatval($array['montoCuentae']).",
        fecha_saldo= '".date('Y-m-d')."'
        where id =".$array['id'];   
        return pg_affected_rows($this->modificar($query));
    }
    public function consultarCuenta_id($array,$id){
        $query= 'SELECT id,estatus,(SELECT razon_comercial from bancos.bancos where id=bancos.cuentas.banco) as nombre, referencia, fecha_creacion FROM bancos.cuentas ';
        $query.= 'where id='.$array['id'].' and usuario='.$id;
        return $this->consultas($query);
    }
    public function eliminar_cuenta($array, $id){
        $query= 'DELETE FROM bancos.cuentas';
        $query.= ' WHERE id='.$array['id'].' and usuario='.$id;
        return $this->eliminar($query);
    }
    public function modificar_estatus($array, $id){
        $query='UPDATE bancos.cuentas SET estatus=( CASE WHEN estatus=1 THEN 2 ELSE 1 END)';
        $query.= ' WHERE id='.$array['id'].' and usuario='.$id;
        return pg_affected_rows($this->modificar($query));
    }
    /*****************Onlyone Cuentas*******************************/
    /*****************Onlyone Movimientos*******************************/
    public function totalSaldoCuentas($id) {  
        $query = "SELECT SUM(saldo) as totalsc FROM bancos.cuentas";
        $query .= " WHERE usuario=" . $id ."and estatus=1";
        return $this->consultas($query);
    }
    public function totalSaldoCuentas_xc($id,$banco) {  
        $query = "SELECT SUM(saldo) as totalsc FROM bancos.cuentas";
        $query .= " WHERE usuario=" . $id ." and banco=".$banco;
        return $this->consultas($query);
    }
    public function saber_cuenta($id) {  
        $query = "SELECT id FROM  bancos.bancos where razon_social='$id'";
        return $this->consultas($query);
    }
    public function cargarMovimientos($id){   
        $query= "SELECT * FROM bancos.v_usuariomovimiento";
        $query.= " WHERE idusuario=".intval($id);
        $query.= " ORDER BY fechmovimiento DESC";
        $resp =$this->consultas($query);
        if ($resp != -1) {
            $row=$resp;
        } else {
            $row = [];
        }
       for ($i=0; $i <count($row) ; $i++) {
                $row[$i]['montomovimiento'] = number_format($row[$i]['montomovimiento'], 2,',','.');
            }
        return json_encode($row);
    }
    public function consultar_mov($array, $id){   
        $query= "SELECT * FROM bancos.v_usuariomovimiento";
        $query.= " WHERE idmovimiento=".intval($_REQUEST['id']).'and idusuario='.$id;
        return $this->consultas($query);
    }
    public function listar_SubCategoria($id){
        $query= "SELECT * FROM bancos.subcategorias where categoria=".$id;
        $query.= " order by codigo";
        return $this->consultas($query);
    }
    public function consultarMovimiento($id){   

        $query= "SELECT (SELECT titulo FROM bancos.categorias where id=bm.tipo ),bm.tipo,(SELECT nota from bancos.movimientos_info where id=bm.id) as nota,(select razon_social from bancos.bancos where id=bc.banco),bc.referencia as cuenta,bm.fecha,bm.fecha_creacion,bm.referencia,bm.descripcion,bm.monto 
        FROM bancos.movimientos bm inner join bancos.cuentas bc on bm.cuenta=bc.id 
        where bm.id=$id";
        return $this->consultas($query);
    }
    public function modificar_mov($array,$id){
        $query= "UPDATE bancos.movimientos_info SET subcategoria= '".$array['subCategoria']."', nota = '".$array['notaSub']."'
        WHERE id =".$_REQUEST['idMovimiento'];
        return pg_affected_rows($this->modificar($query));
    }
    /*****************Onlyone Movimientos*******************************/
    /*****************Importar txt*******************************/
    public function consultar_cuentas($id){   
        $query="select * from bancos.v_cuenta_descripcion as b
        WHERE usuario=$id and tipo=1 and (select count(*) from maestros.identificar_banco where id_banco=b.idb) >0 ";
        return $this->consultas($query);
    }
    public function BuscarBancoId($id){   
        $query = "SELECT * FROM bancos.cuentas";
        $query .= " WHERE id=".$id;
        return $this->consultas($query);
    }
    public function cargarCSVBNC($url) {
        $campos = ['fecha'=>11, 'refrencia'=>12, 'descripcion'=>66, 'monto'=>27, 'saldo'=>30];
        $archivo = fopen($url, 'r');
        $array = [];
        $i=1;
        while (!feof($archivo)) {
            $dato = null;
            $datos = fgets($archivo);
	        $datos= utf8_decode($datos);
                if($i>3):
                     if (utf8_decode(trim($datos)) != ""):
                            $dato = $this->getLineData("tab", $datos, $campos);//preguntar a bernardo
                            $dato =explode(";",$dato); 
                            if(strtolower(trim($dato[5]))!='saldo inicial'):
                            $arreglo['fecha']=strtolower(trim($dato[0]));
                            $arreglo['referencia']=strtolower(trim($dato[2]));
                            $arreglo['referencia_2']=strtolower(trim($dato[10]));
                            $arreglo['descripcion']=strtolower(trim($dato[6]));
                            if($dato[7]==0):
                                $monto = trim($dato[8]);
                            else:
                                $monto = trim($dato[7]);
                            endif;
                            $monto = str_replace('.' , '' , $monto);
                            $monto = str_replace(',' , '.' , $monto);
                            $arreglo['monto'] = floatval($monto);
                            array_push($array,$arreglo);
                        endif;
                    endif;
                endif;
                $i++;
        }
        fclose($archivo);
        return json_encode($array);
    }
    public function ejecutar_sql($query){
        return $this->insertar_esp($query);
    }
    public function actualizarSaldo($i,$f) {
        $query = "update bancos.cuentas set saldo=saldo+(select sum(monto) from bancos.movimientos where id between '$i' and  '$f'), fecha_saldo=now()";
        $query .= " WHERE id=(select cuenta from bancos.movimientos where id=$f)";
        return pg_affected_rows($this->modificar($query));
    }
    public function cargarMovimientosCSVBanesco($url) {
        $campos = ['fecha'=>11, 'refrencia'=>12, 'descripcion'=>66, 'monto'=>27, 'saldo'=>30];
        $archivo = fopen($url, 'r');
        $array = [];
        if (!feof($archivo)):
            $datos = fgets($archivo);
            $datos= utf8_decode($datos);
            $tmp = preg_replace("/[\t]/", ";", $datos);
            if (count($tmp) > 1):
                $sep = 'tab';
            else:
                $tmp = explode(';',$datos);
                if (count($tmp) > 1):
                    $sep = ';';
                else:
                    $sep = 'fixed';
                endif;
            endif;
            $header = $this->getLineData($sep, $datos, $campos);
        endif;
        while (!feof($archivo)) {
            $dato = null;
            $datos = fgets($archivo);
            if (utf8_decode(trim($datos)) != ""):
                $dato = $this->getLineData($sep, $datos, $campos);
                $arreglo['fecha']=strtolower(trim($dato[0]));
                $arreglo['referencia']=strtolower(trim($dato[1]));
                $arreglo['referencia_2']=strtolower(trim($dato[1]));
                $arreglo['descripcion']=strtolower(trim($dato[2]));
                $monto = trim($dato[3]);
                $monto = str_replace('.' , '' , $monto);
                $monto = str_replace(',' , '.' , $monto);
                $arreglo['monto'] = floatval($monto);
                array_push($array,$arreglo);
            endif;
        }
        fclose($archivo);
        return json_encode($array);
    }
    public function cargarMovimientosCSVMercantil($url) {
        $linea = 0;
        $archivo = fopen($url, 'r');
        $array=[];
        $monto = "";
        while (!feof($archivo)) {
          $datos= fgets($archivo);
          $datos= utf8_decode($datos);
          $dato=preg_split("/[\t]/",$datos);
          if (count($dato) > 1):
          $tmp = strtolower(trim($dato[1]));
          if (($tmp != 'saldo inicial') && ($tmp != 'saldo final')):
            $arreglo['fecha']=strtolower(trim($dato[0]));
            $desc = explode('-',$tmp);
            $arreglo['tipo']=strtolower(trim($desc[0]));
            $arreglo['descripcion']=strtolower(trim($desc[1]));
            $arreglo['referencia']=strtolower(trim($dato[2]));
            $arreglo['referencia_2']=strtolower(trim($dato[2]));
            if ($dato[3] != ""):
                $monto = trim($dato[3]);
            else:
                $monto = trim($dato[4]);
            endif;
            if(substr($monto, -3, 1)=='.'):
                $monto = str_replace(',' , '.' , $monto);
            else:
                $monto = str_replace('.' , '' , $monto);
                $monto = str_replace(',' , '.' , $monto);
            endif;
            $arreglo['monto'] = floatval($monto);
            array_push($array,$arreglo);
          endif;
        endif;
        }
        fclose($archivo);
        return json_encode($array);
    }
    private function getLineData($sep, $datos, $campos) {
        switch ($sep):
            case 'tab':
                $dato = preg_replace("/[\t]/", ";", $datos);
                break;
            case ';':
                $dato = explode(';',$datos);
                break;
            case ',':
                    $dato = explode(',',$datos);
                    break;
            case ',':
                $dato = explode(' ',$datos);
                break;
            case 'fixed':
                $start = 0;
                foreach ($campos as $key=>$val):
                    $dato[] = str_replace('ó','o',trim(substr($datos, $start, $val)));
                    $start+=$val;
                endforeach;
                break;
            case 'fixed2':
                $start = 0;
                foreach ($campos as $key=>$val):
                    $dato[] = trim(substr($datos, $start, $val));
                    $start+=$val;
                endforeach;
                break;
        endswitch;
        return $dato;
    }
    public function cargarCSVBOD($url) {
        $campos = ['fecha'=>14, 'tipo'=>13,'refrencia'=>14, 'descripcion'=>34, 'monto'=>13, 'saldo'=>0];
        $archivo = fopen($url, 'r');
        $array = [];
        $i=1;
        while (!feof($archivo)) {
            $dato = null;
            $datos = fgets($archivo);
            $datos= utf8_decode($datos);
                if($i>8):
                     if (utf8_decode(trim($datos)) != ""):
                        $dato = $this->getLineData("fixed2", $datos, $campos);//preguntar a bernardo
                        $arreglo['fecha']=strtolower(trim($dato[0]));
                        $arreglo['referencia']=strtolower(trim($dato[2]));
                        $arreglo['referencia_2']=strtolower(trim($dato[2]));
                        $arreglo['descripcion']=strtolower(trim($dato[3]));
                        $monto = trim($dato[4]);
                        $arreglo['monto'] = floatval($monto);
                        array_push($array,$arreglo);
                    endif;
                endif;
                $i++;
        }
        fclose($archivo);
        return json_encode($array);
    }
    public function cargarCSVBancaribe($url) {
        $campos = ['fecha'=>14, 'tipo'=>13,'refrencia'=>14, 'descripcion'=>34, 'monto'=>13, 'saldo'=>0];
        $archivo = fopen($url, 'r');
        $array = [];
        $i=1;
        while (!feof($archivo)) {
            $dato = null;
            $datos = fgets($archivo);
            $datos= utf8_decode($datos);
                if($i>1):
                     if (utf8_decode(trim($datos)) != ""):
                        $dato = $this->getLineData(";", $datos, $campos);
                        $arreglo['fecha']=strtolower(trim($dato[0]));
                        $arreglo['referencia']=strtolower(trim($dato[1]));
                        $arreglo['referencia_2']=strtolower(trim($dato[1]));
                        $arreglo['descripcion']=strtolower(trim($dato[2]));
                        $monto = trim($dato[4]);
                        $monto = str_replace('.' , '' , $monto);
                        $monto = str_replace(',' , '.' , $monto);
                        if(trim($dato[3])=='D'):
                            $monto=floatval($monto)*(-1);
                        else:
                            $monto=floatval($monto);
                        endif;
                        $arreglo['monto'] = floatval($monto);
                        array_push($array,$arreglo);
                    endif;
                endif;
                $i++;
        }
        fclose($archivo);
        return json_encode($array);
    }
    public function cargarCSVBancrecer($url) {
        $campos = ['fecha'=>14, 'tipo'=>13,'refrencia'=>14, 'descripcion'=>34, 'monto'=>13, 'saldo'=>0];
        $archivo = fopen($url, 'r');
        $array = [];
        $i=1;
        while (!feof($archivo)) {
            $dato = null;
            $datos = fgets($archivo);
            $datos= utf8_decode($datos);
                if($i>1):
                     if (utf8_decode(trim($datos)) != ""):
                        $datos=str_replace('"' , '' , $datos);
                        $dato = $this->getLineData(",", $datos, $campos);
                        $arreglo['fecha']=strtolower(trim($dato[0]));
                        $arreglo['referencia']=strtolower(trim($dato[1]));
                        $arreglo['referencia_2']=strtolower(trim($dato[1]));
                        $arreglo['descripcion']=strtolower(trim($dato[2]));
                        if($dato[3]==''):
                            $monto=$dato[4].','.$dato[5];
                            $monto = str_replace('.' , '' , $monto);
                            $monto = str_replace(',' , '.' , $monto);
                            $monto=floatval($monto);
                        else:
                            $monto=$dato[3].','.$dato[4];
                            $monto = str_replace('.' , '' , $monto);
                            $monto = str_replace(',' , '.' , $monto);
                            $monto=floatval($monto)*(-1);
                        endif;
                        $arreglo['monto'] = floatval($monto);
                        //$arreglo['monto'] =strtolower(trim($dato[3])).','.strtolower(trim($dato[4])).','.strtolower(trim($dato[5]));
                        array_push($array,$arreglo);
                    endif;
                endif;
                $i++;
        }
        fclose($archivo);
        return json_encode($array);
    }
    public function cargarMovimientosCSVMercantil2($url) {
        $campos = ['fecha'=>14, 'tipo'=>13,'refrencia'=>14, 'descripcion'=>34, 'monto'=>13, 'saldo'=>0];
        $archivo = fopen($url, 'r');
        $array = [];
        $i=1;
        while (!feof($archivo)) {
            $dato = null;
            $datos = fgets($archivo);
            $datos= utf8_decode($datos);

                if (utf8_decode(trim($datos)) != ""):
                $datos = str_replace('0105   VES   ' , '' , trim($datos));
                $datos = str_replace('  ' , ';' , trim($datos));
                $datos = str_replace(' SF ' , ';SF;' , trim($datos));
                $datos = str_replace(' ND ' , ';ND;' , trim($datos));
                $datos = str_replace(' NC ' , ';NC;' , trim($datos));
                $datos = str_replace(' SI ' , ';SI;' , trim($datos));
                $dato = $this->getLineData(";", $datos, $campos);
                if(trim($dato[1])=='SI' or trim($dato[1])=='SF'):
                //nada
                else:
                    $tmp="";
                    $data1=explode(" ",$dato[0]);
                    $arreglo['fecha']=strtolower(trim($data1[1]));
                    $tmp=substr($arreglo['fecha'], 0,2);
                    $tmp.='/'.substr($arreglo['fecha'], 2,-4);
                    $tmp.='/'.substr($arreglo['fecha'], -4);
                    $arreglo['fecha']=$tmp;
                    $arreglo['referencia']=strtolower(trim($data1[2]));
                    $arreglo['referencia_2']=strtolower(trim($data1[2]));
                    $arreglo['descripcion']=strtolower(trim($dato[2]));
                    $monto=explode(" ",trim($dato[3]));
                    $monto = str_replace('.' , '' , $monto);
                    $monto = str_replace(',' , '.' , $monto);
                    $monto=$monto[0];
                    if(trim($dato[1])=='ND'):
                        $monto=floatval($monto)*(-1);
                    else:
                        $monto=floatval($monto);
                    endif;
                    $arreglo['monto'] = floatval($monto);
                    array_push($array,$arreglo);
                endif;
            endif;
        }
        fclose($archivo);
        return json_encode($array);
    }
    public function identificardor($url){
        $archivo = fopen($url, 'r');
        $datos = fgets($archivo);
        fclose($archivo);
        return utf8_decode($datos);
    }
    /*****************Importar txt*******************************/
    /*****************Conciliacion*******************************/
    public function APP_ct_reporte($empresa){
        $sql="  SELECT (SELECT COUNT(*) FROM administracion.reporte_pagos where (fecha_pago+2) <= now() and estatus_rep=1 and movimiento=0 and id=ar.id)as eliminar, ar.estatus_rep,cuenta_detallada,fecha_pago,nombre,ar.id,ar.idcuenta,ar.numero_operacion,SUM(af.monto) as monto,COUNT(*) as total_faturas ,(select nombre from seguridad.estatus_reporte_pago where id=ar.estatus_rep) as nombreEstatus
        FROM  dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,cuenta_detallada FROM bancos.v_bancos4') as (codigo integer ,cuenta_detallada VARCHAR)
        INNER JOIN administracion.reporte_pagos ar on ar.idcuenta = codigo INNER JOIN administracion.reporte_pago_factura af on ar.id=af.idpago
        where ar.empresa='".$empresa."'
        GROUP BY af.idpago,ar.id,ar.idcuenta,cuenta_detallada
        ORDER BY ar.id desc";
        return $this->consultas_c($sql);
    }
    public function APP_c_reporte($id){
        $sql="SELECT (SELECT razon_comercial from maestros.bancos where codigo=ar.codigocuenta) as banco_o, (SELECT nombre from maestros.tipo_operacion where id=CAST(ar.tipo_operacion AS INTEGER)) as tipo,*,(SELECT SUM(MONTO) FROM administracion.reporte_pago_factura where idpago=ar.id) as total,(select nombre from seguridad.estatus_reporte_pago where id=ar.estatus_rep) as nombreEstatus
        FROM  dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,cuenta_detallada FROM bancos.v_bancos4') as (codigo integer ,cuenta_detallada VARCHAR)
        INNER JOIN administracion.reporte_pagos ar on ar.idcuenta = codigo INNER JOIN administracion.reporte_pago_factura af on ar.id=af.idpago
        where ar.id='".$id."'" ;
        return $this->consultas_c($sql);
    }
    public function consultarMovimiento_2($id){   
        $query= "SELECT (select razon_social from bancos.bancos where id=bc.banco),bc.referencia as cuenta,bm.fecha,bm.fecha_creacion,bm.referencia,bm.descripcion,bm.monto FROM bancos.movimientos bm  inner join bancos.cuentas bc  on bm.cuenta=bc.id where bm.id=$id";
        return $this->consultas($query);
    }
    public function APP_e_concialiacion($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=2,
            movimiento=(select idd from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia,monto, fecha,cuenta from bancos.movimientos where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float, fecha  DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia and fecha=fecha_pago and  (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='1' and ap.id=rps.id )
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia,monto, fecha, cuenta from bancos.movimientos where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float,fecha  DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia and fecha=fecha_pago and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta  and ap.tipo_operacion='1' and estatus_rep = 1 and ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar_c($sql);
    }
    public function conciliacion_OB_banesco($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps 
        SET estatus_rep=2, movimiento=(SELECT id_cuenta FROM dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,cuenta,codigo_trans,cedula_trans,monto,fecha  from bancos.v_movimientobanescoconciliar where usuario=".$empresa."') as (id_cuenta INTEGER, cuenta integer, codigo_trans varchar(30),cedula_trans varchar,monto float, fecha date ) INNER JOIN administracion.reporte_pagos ar on cuenta=ar.idcuenta and cedula_trans=ar.doc where ar.movimiento=0 and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ar.id)=monto and fecha_pago BETWEEN fecha and (fecha+5) and estatus_rep=1 and codigo_trans=codigocuenta  and tipo_operacion='2' and id=rps.id)
        WHERE empresa='".$empresa."' and
         rps.id in (SELECT ar.id FROM dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,cuenta,codigo_trans,cedula_trans,monto,fecha  from bancos.v_movimientobanescoconciliar where usuario=".$empresa."') as (id_cuenta INTEGER, cuenta integer, codigo_trans varchar(30),cedula_trans varchar,monto float, fecha date ) INNER JOIN administracion.reporte_pagos ar on cuenta=ar.idcuenta and cedula_trans=ar.doc where ar.movimiento=0 and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ar.id)=monto and fecha_pago BETWEEN fecha and (fecha+5) and estatus_rep=1 and codigo_trans=codigocuenta  and tipo_operacion='2' and id=rps.id);";
        return $this->modificar_c($sql);
    }
    public function conciliacion_OB_bod($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=2,
            movimiento=(select idd from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia,monto, fecha,cuenta from bancos.v_movimientobodconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on    ap.numero_operacion Like '%'||lower(referencia)||'%'  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id)
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia,monto, fecha,cuenta from bancos.v_movimientobodconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on  ap.numero_operacion Like '%'||lower(referencia)||'%'   and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5 and ap.movimiento=0 and  ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar_c($sql);
    }
    public function conciliacion_OB_bnc($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=2,
            movimiento=(select idd from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia_2,descripcion,monto, fecha,cuenta from bancos.v_movimientobncconciliar where usuario=".$empresa."' ) as (idd integer,referencia_2 varchar,descripcion varchar, monto float, fecha DATE, cuenta integer) 
            INNER JOIN administracion.reporte_pagos ap on descripcion Like '%'||lower(ap.numero_operacion)||'%'  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id)
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia_2,descripcion,monto, fecha,cuenta from bancos.v_movimientobncconciliar where usuario=".$empresa."' ) as (idd integer,referencia_2 varchar,descripcion varchar, monto float, fecha DATE, cuenta integer) 
            INNER JOIN administracion.reporte_pagos ap on descripcion Like '%'||lower(ap.numero_operacion)||'%'  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar_c($sql);
    }
    public function APP_e_concialiacionmd($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=3,
            movimiento=(select idd from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia,monto, fecha,cuenta from bancos.movimientos where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float, fecha  DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia and fecha=fecha_pago and  (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='1' and ap.id=rps.id )
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia,monto, fecha, cuenta from bancos.movimientos where usuario=".$empresa."' ) as (idd integer,referencia varchar, monto float,fecha  DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on ap.numero_operacion=referencia and fecha=fecha_pago and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta  and ap.tipo_operacion='1' and estatus_rep = 1 and ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar_c($sql);
    }
    public function conciliacion_OB_bodmd($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=3,
            movimiento=(select idd from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia,monto, fecha,cuenta from bancos.v_movimientobodconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on    ap.numero_operacion Like '%'||lower(referencia)||'%'  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago<>ap.id)=monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id)
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia,monto, fecha,cuenta from bancos.v_movimientobodconciliar where usuario=".$empresa."') as (idd integer,referencia varchar, monto float, fecha DATE, cuenta integer) INNER JOIN administracion.reporte_pagos ap on  ap.numero_operacion Like '%'||lower(referencia)||'%'   and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5 and ap.movimiento=0 and  ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar_c($sql);
    }
    public function conciliacion_OB_bncmd($empresa){
        $sql="UPDATE administracion.reporte_pagos as rps
        set estatus_rep=3,
            movimiento=(select idd from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia_2,descripcion,monto, fecha,cuenta from bancos.v_movimientobncconciliar where usuario=".$empresa."' ) as (idd integer,referencia_2 varchar,descripcion varchar, monto float, fecha DATE, cuenta integer) 
            INNER JOIN administracion.reporte_pagos ap on descripcion Like '%'||lower(ap.numero_operacion)||'%'  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id)
        where 
        empresa='".$empresa."'  and
        rps.id in 
       (select ap.id from dblink('hostaddr=".$this->bd_onlyone->host." port=".$this->bd_onlyone->port." dbname=".$this->bd_onlyone->dbName." user=".$this->bd_onlyone->user." password=".$this->bd_onlyone->pass."', 'SELECT id,referencia_2,descripcion,monto, fecha,cuenta from bancos.v_movimientobncconciliar where usuario=".$empresa."' ) as (idd integer,referencia_2 varchar,descripcion varchar, monto float, fecha DATE, cuenta integer) 
            INNER JOIN administracion.reporte_pagos ap on descripcion Like '%'||lower(ap.numero_operacion)||'%'  and (SELECT sum(monto) from administracion.reporte_pago_factura where idpago=ap.id)<>monto and cuenta=idcuenta and ap.tipo_operacion='2' and fecha between ap.fecha_pago and ap.fecha_pago+5  and ap.movimiento=0 and ap.id=rps.id )
       RETURNING rps.id";
     return $this->modificar_c($sql);
    }
    public function generarConciliacionReporte($empresa,$total_c,$total_nc,$total_ncm){   
        $query="INSERT INTO conciliacion.conciliacion_reporte (usuario,total_c,total_nc,total_ncm) values (".$empresa.",".$total_c.",".$total_nc.",".$total_ncm.") RETURNING id";
        $this->bd_onlyone->connect();
        return  $this->bd_onlyone->getQuery($query);
    }
    public function reporte_pendientes($empresa){
        $sql="SELECT count(*) as total FROM administracion.reporte_pagos where estatus_rep=1 and empresa='".$empresa."'";
        return $this->consultas_c($sql)[0]['total'];
    }
    public function insertarConciliacionReporte($empresa,$n_reporte,$n_pago){   
        $query="INSERT INTO conciliacion.conciliacion_reportepago (id_reporte,id_pago,usuario) values (".$n_reporte.",".$n_pago.",".$empresa.") RETURNING id";

        return  $this->insertar($query);;
    }
    public function eliminar_rep($array, $id){
        $query= 'DELETE FROM administracion.reporte_pagos';
        $query.= ' WHERE id='.$array['id'].'';
        $this->eliminar_rep_2($array, $id);
        return $this->eliminar_c($query);
    }
    private function eliminar_rep_2($array, $id){
        $query= 'DELETE FROM administracion.reporte_pago_factura';
        $query.= ' WHERE idpago='.$array['id'].'';
        return $this->eliminar_c($query);
    }
    /*****************Conciliacion*******************************/
    /*****************Reporte *******************************/
            
    public function reportes_conciliacion($id){
        $sql="SELECT   cr.id_reporte,cr.total_c,cr.total_nc,cr.total_ncm,cr.fecha_reporte  FROM conciliacion.v_conciliacionreportes cr where empresa='".$id."' group by id_reporte,total_c,total_nc,total_ncm,fecha_reporte";
        return $this->consultas_c($sql);
    }
    /*****************Reporte *******************************/
}