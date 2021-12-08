<?php

    require "utility.php";
    require_once "crudModel.php";
    header('Access-Control-Allow-Origin: *');

    class user {

        // connecting
        public static function connect_wallet($address = "", $ref_id = "") {
            // check if wallet already connected
            $newUtility = new utility();

            if($newUtility->check_wallet("address='$address'")){
                // creating new user    
                return $newUtility->getUserData($address);
            }else{
                 $createUser = $newUtility->create_user($address,$ref_id);
                 if($createUser){
                    return $newUtility->getUserData($address);
                 }
            };
            

        }

     

    }

    // recieving requests
if(isset($_GET['action'])){
    $action = $_GET['action'];

    // connecting wallet
    if($action=="connect"){
        $address = $_GET['address'];
        $ref_id =  isset($_GET['ref_id'])?$_GET['ref_id']:"";
      echo user::connect_wallet($address,$ref_id);
    
    }
}