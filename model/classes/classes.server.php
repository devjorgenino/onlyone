<?php

class MyApp {
    protected $title = "onlyOne";
    private $codeName = "onlyone-alpha";
    protected $stage = "alpha";
    protected $version = "0.1.0";
    protected $host = "https://geekhack.net.ve/";
    protected $root = "onlyone/";
    protected $url;
    protected $empresa = "geekHACK";
    protected $webServices = "webservices/";
    protected $models = "model/";
    protected $views = "view/";
    protected $controllers = "controller/";
    protected $images = "assets/img/";
    protected $copyright = "geekHACK, C.A.";
    protected $Mongo = array(
        "host"=>"vps1.geekhack.net.ve",
        "port"=>"27017",
        "user"=>"",
		"passwd"=>"",
		"db"=>""
    );
    protected $Postgre = array(
        "host"=>"geekhack.net.ve",
        "port"=>"5432",
        "user"=>"",
        "passwd"=>"",
        "db"=>""
    );
    protected $logo = "";//"geekhack-logo1.png";
	protected $mongoURI;
	protected $postgreURI;

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
        $this->url = $this->host . $this->root;
        $this->webServices = $this->url . $this->webServices;
        $this->models = $this->url . $this->models;
        $this->views = $this->url . $this->views;
		$this->controllers = $this->url . $this->controllers;
		$this->mongoURI = "mongodb://" . $this->Mongo["user"] . ":" . $this->Mongo["passwd"] . "@" . $this->Mongo["host"] . ":" . $this->Mongo["port"];
		$this->postgreURI = "postgredb://" . $this->Postgre["user"] . ":" . $this->Postgre["passwd"] . "@" . $this->Postgre["host"] . ":" . $this->Postgre["port"];
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }
    public function title() {
        return $this->title;
    }
    public function copyright() {
        return $this->copyright;
    }
    public function logo() {
        if ($this->logo != "") {
            $ret = $this->root . $this->images . $this->logo;
        } else {
            $ret = "";
        }
        return $ret;
    }
    public function empresa() {
        return $this->empresa;
    }

    protected function getJson_Decode($webService, $params) {
        return json_decode(file_get_contents($this->app->webServices . $webService . $params));
    }

    protected function getModel($item, $params) {

    }

    protected function getView($item, $params) {
        
    }

    protected function getController($item, $params) {
        
    }

} // END MyApp

class myAPI {
    protected $api;
    protected $host = "http://vps1.geekhack.net.ve/";
    protected $root = "productos/intranet/";
    protected $url;
    protected $Mongo = array(
        "host"=>"vps1.geekhack.net.ve",
        "port"=>"27017",
        "user"=>"",
		"passwd"=>"",
		"db"=>""
    );
    protected $Postgre = array(
        "host"=>"vps1.geekhack.net.ve",
        "port"=>"5432",
        "user"=>"",
        "passwd"=>"",
        "db"=>""
    );
    protected $mongo;
    protected $postgre;

    /*
    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
        $this->mongo = new myMongoDB($this->Mongo);
    }
    */
    public function __construct($api = null) {
        //print "Constructing " . __CLASS__ . "\n";
        if ($api != null) {
            $this->api = $api;
        }
        $this->mongo = new myMongoDB($this->Mongo);
    }

    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }
}



class myMailServer {
    protected $domain = 'inventoryHACK.com.ve';
    protected $sender = 'noreply@inventoryHACK.com.ve';
    protected $pass = 'x=PkXBo$qcPd';
    protected $outServer = "host.caracashosting70.com";
    protected $outPort = "465";

    public function __construct() {
        //print "Constructing " . __CLASS__ . "\n";
    }
    public function __destruct() {
        //print "Destroying " . __CLASS__ . "\n";
    }
}

?>