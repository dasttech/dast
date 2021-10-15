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

        $newUser = "insert into users (address,ref_id,reg_date) values ('$address','$uniq_id',now())";
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
}
