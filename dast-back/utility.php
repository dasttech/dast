<?php
require "conn.php";
header('Access-Control-Allow-Origin: *');

class utility
{

    public $conn;

    // check if wallet exist
    public static function check_wallet($condition)
    {
        $conn = new conn();
        $check = "select * from users where $condition";

        if ($conn->connect->query($check)->num_rows > 0) {
            return true;
        } else {
            return false;
        }
    }

    //verify_id
    public static function verify_id($id)
    {

        if (self::check_wallet("ref_id='$id'")) {
            $conn = new conn();
            $verify = "update users set status = '1' where ref_id='$id'";
            $verify = $conn->connect->query($verify);
            $conn->connect->close();
            // return $verify;
            if ($verify) {
                return array("data"=>"Verification successfull. Visit https://dast.tech/profile to claim your reward");
            } else {
                return array("data"=>"Verification Failed. Visit https://dast.tech/profile get your valid ID");
            }
        } else {
            return array("data"=>"Verification Failed. Visit https://dast.tech/profile get your valid ID");
        }
    }


        //Claim bonus
        public static function buy_ico($user_id,$amount)
        {
            $conn = new conn();
                $purchased = "select * from users where ref_id = '$user_id'";
                $result = $conn->connect->query($purchased);
                if($result->num_rows>0){
                    while($row = $result->fetch_assoc()){
                        $purchased = $row['purchased_ico'];
                    }
                }
                $new_purchased = $purchased+$amount;

                $update_purchase = "update users set purchased_ico = '$new_purchased' where ref_id = '$user_id'";
                $update_purchase = $conn->connect->query($update_purchase);
                $conn->connect->close();
                return $new_purchased;
        }

    //Claim bonus
    public static function claim_bonus($bonus_id)
    {
        $conn = new conn();
        $ids = explode("-", $bonus_id);
        for($i=0;$i<count($ids);$i++){
            $bonus_id = $ids[$i];
            $claim = "update bonus set status = '1',claim_on = now() where id = '$bonus_id'";
            $claim = $conn->connect->query($claim);
        }
        $conn->connect->close();
        return $claim;
    }

        //Claim airdrop
        public static function claim_airdrop($user_id)
        {
            $conn = new conn();
           
                $claim = "update users set airdrop_status = '1' where ref_id = '$user_id'";
                $claim = $conn->connect->query($claim);
            $conn->connect->close();
            return $claim;
        }

    // generate id for new user
    public static function generate_id()
    {
        $uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $number = '0123456789';
        $uniq_id = "";
        do {
            $uniq_id = getdate(date("U"))['mday'] . "-" . $uppercase[rand(0, strlen($uppercase) - 1)] . "-" . $uppercase[rand(0, strlen($uppercase) - 1)] . "-" . $number[rand(0, strlen($number) - 1)] . "-" .
                $uppercase[rand(0, strlen($uppercase) - 1)] . "-" . $uppercase[rand(0, strlen($uppercase) - 1)] . "-" . $number[rand(0, strlen($number) - 1)];
            $uniq_id = explode("-", $uniq_id);
            shuffle($uniq_id);
            $uniq_id = implode("-", $uniq_id);
            $uniq_id = str_replace("-", "", $uniq_id);
        } while (self::check_wallet("ref_id='$uniq_id'"));
        return $uniq_id;
    }

    //create wallet
    public static function create_user($address, $ref_id)
    {
        $conn = new conn();
        $uniq_id = self::generate_id();

        $newUser = "insert into users (address,ref_id,status,reg_date) values ('$address','$uniq_id','1',now())";
        $bonus = "insert into bonus (referer,refered) values ('$ref_id','$address')";

        if ($conn->connect->query($newUser) === true) {
            if ($ref_id != "") {
                if ($conn->connect->query($bonus) === true) {
                    $conn->connect->close();
                    return true;
                }
            } else {
                $conn->connect->close();
                return true;
            }
        } else {
            $conn->connect->close();
            return $conn->connect->error;
        }
    }

    //get userData
    public static function getUserData($address)
    {
        $conn = new conn();
        $userData = "select * from users where address = '$address'";
        $userInfo = array("hasData" => false);
        $userBonus = array();
        $userRefId = "";
        $result = $conn->connect->query($userData);

        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {

                $userInfo["user"] = $row;
                $userRefId = $row['ref_id'];
            }

            // fetch bonus data

            $bonusData = "select * from bonus where referer = '$userRefId' AND status = '0'";
            $result = $conn->connect->query($bonusData);
            if ($result->num_rows > 0) {
                $userInfo['hasData'] = true;
                while ($row = $result->fetch_assoc()) {
                    array_push($userBonus, $row);
                }

                $userInfo['bonus'] = $userBonus;
            }

            $conn->connect->close();
            return json_encode($userInfo);
        } else {
            $conn->connect->close();
        }
    }

    public static function getBnbPrice(){
        return json_encode(file_get_contents("https://api.nomics.com/v1/currencies/ticker?key=1895a74e3600d3857ae40e6a68a265594cc84cc9&ids=BNB&interval=1h&convert=USD&per-page=100&page=1",true));
       
    }


       // Convert date to time age
       public static function timeago($date) {
        $timestamp = strtotime($date);

        $strTime = array("second", "minute", "hour", "day", "month", "year");
        $length = array("60","60","24","30","12","10");

        $currentTime = time();
        if($currentTime >= $timestamp) {
             $diff     = time()- $timestamp;
             for($i = 0; $diff >= $length[$i] && $i < count($length)-1; $i++) {
             $diff = $diff / $length[$i];
             }

             $diff = round($diff);
             return  $diff . " " . $strTime[$i] . "(s) ago ";
        }
        else{
            return "Upcoming";
        }
     }


}

// recieving requests

if (isset($_GET['action'])) {
    $action = $_GET['action'];

    if ($action == "verify") {
        if(!isset($_GET['id'])){return;}
        $id = $_GET['id'];
        echo json_encode(utility::verify_id($id));
    }

    if ($action == "claim") {
        if(!isset($_GET['id'])){return;}
        $bonus_id = $_GET['id'];
        echo json_encode(utility::claim_bonus($bonus_id));
    }

    if ($action == "airdrop") {
        if(!isset($_GET['id'])){return;}
        $ref_id = $_GET['id'];
        echo json_encode(utility::claim_airdrop($ref_id));
    }

    if ($action == "ico") {
        if(!isset($_GET['ref_id'])){return;}
        if(!isset($_GET['amount'])){return;}
        $ref_id = $_GET['ref_id'];
        $amount = $_GET['amount'];
        echo json_encode(utility::buy_ico($ref_id,$amount));
    }
    if($action=="bnbPrice"){
        echo utility::getBnbPrice();
    }


    
}


