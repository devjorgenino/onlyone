<?php
class data {
    protected $conn;
    public $host = "127.0.0.1";
    public $port = "5432";
    public $user = "onlyone";
    public $pass = "onlyone-12345+";
    public $dbName = "";
    private $db;
    private $strConn = "";

            public function __construct($db) {
                $this->dbName=$db;
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