<?php 

class conn {
    public $connect;

    function __construct()
    {
       require_once 'env.php'; 
        // Create connection
        // variable is class from env.php
        $this->connect = new mysqli(variables::$servername, variables::$username, variables::$password, variables::$dbname);
        // Check connection
        if ($this->connect->connect_error) {
            die("Connection failed: " . $connect->connect_error);
        }
        else{
            // echo "connected";
        }
    }
}


