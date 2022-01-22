<?php
header('Access-Control-Allow-Origin: *');
require_once "utility.php";
require_once "crudModel.php";
require_once "mailer.php";

class pattern
{
    public $utility;

    public $crudModel;

    function __construct()
    {
        $this->utility = new utility();

        $this->crudModel = new crudModel();
    }
    // claimData
    public  function addPattern($params)
    {


        $pattern = $this->crudModel->insertIntoTable("patterns", $params);

        Email::sendMail($params['yourEmail'], "", "Security pattern added - " . $params['title'],  "Your security pattern has been deployed to blockchain");

        return json_encode($pattern);
    }

    //Fetch Pattern
    public  function fetchPattern($params)
    {
        $userId = $params['userId'];
        unset($params['id']);
        $myPattern = $this->crudModel->selectFromTable("patterns", "*", "where id = '$userId' order by date desc limit 20");
        return json_encode($myPattern);
    }
    //Fetch User Pattern
    public  function fetchUserPattern($params)
    {
        $address = $params['address'];
        $myPattern = $this->crudModel->selectFromTable("patterns", "*", "where address = '$address' order by id desc");
        return json_encode($myPattern);
    }

    //Recover Pattern
    public  function recoverPattern($params)
    {
        $email = $params['email'];
        $myPattern = $this->crudModel->selectFromTable("patterns", "*", "where nKinEmail = '$email' && reminderCount>=5 order by id desc");
        return json_encode($myPattern);
    }

    //Fetch Investment
    public  function fetchBalance($params)
    {
        $username = $params['username'];
        unset($params['id']);
        $myInvestment = $this->crudModel->selectFromTable("wallet", "*", "where username = '$username'");
        return json_encode($myInvestment);
    }

    //cancel
    public  function cancel($params)
    {
        $id = $params['id'];
        $params['status'] = "cancelled";
        unset($params['id']);
        $cancel = $this->crudModel->updateTable("investment", $params, "where id = '$id'");

        return json_encode($cancel);
    }



    //approve
    public  function updatePattern($params)
    {
        $id = $params['id'];
        unset($params['id']);
        $approve = $this->crudModel->updateTable("patterns", $params, "where id = '$id'");
        Email::sendMail($params['yourEmail'], "", "Pattern updated - " . $params['title'],  "Your security pattern has been updated");
        return json_encode($approve);
    }

    //notifier
    public  function notifier()
    {
        $duepatterns = $this->crudModel->selectFromTable("patterns", "*", " where dueForRecover < 2");

        if ($duepatterns["status"]) {
            $patterns = $duepatterns["msg"];
            for ($i = 0; $i < count($patterns); $i++) {
                $id = $patterns[$i]["id"];
                $title = $patterns[$i]["title"];
                $yourEmail = $patterns[$i]['yourEmail'];
                $nKinEmail = $patterns[$i]['nKinEmail'];
                $reminderCount = $patterns[$i]['reminderCount'];
                $dueForRecover = $patterns[$i]['dueForRecover'];
                $recoveryDate = $patterns[$i]['recoveryDate'];
                $recoveryDate =  utility::timeago($recoveryDate);

                if ($recoveryDate !== "Upcoming") {
                    if ($dueForRecover > 0) {
                        Email::sendMail($nKinEmail, "", "Access Recovery Alert", "Visit https://dast.tech to recover an asset which you have been choosen as next of kin");
                    } else {
                        Email::sendMail($yourEmail, "", "Extension of Date", "You are required to extend your access recovery date at dast platform. Please do this ASAP before we notify your next of kin");
                       

                        if($reminderCount>5){ $dueForRecover = 1; }

                         $reminderCount+=1;

                        $this->crudModel->updateTable("patterns",array("reminderCount"=>$reminderCount,"dueForRecover"=>$dueForRecover)," where id = $id");
                    }
                }

            }
        }
    }
}

// REQUEST HANDLING

if (isset($_POST['action'])) {
    $pattern = new pattern();

    // Add Pattern
    // data: action=addPattern,address,yourEmail,phraseOrder,nKinName,nKinPhone,nKinEmail,recoveryDate}
    if ($_POST['action'] == "addPattern") {
        unset($_POST['action']);
        echo $pattern->addPattern($_POST);
        return;
    }

    // Fetch Pattern
    // data: action=fetchPattern,id
    if ($_POST['action'] == "fetchPattern") {
        unset($_POST['action']);
        echo $pattern->fetchPattern($_POST);
        return;
    }

    // Fetch User Pattern
    // data: action=fetchUserPattern,address
    if ($_POST['action'] == "fetchUserPattern") {
        unset($_POST['action']);
        echo $pattern->fetchUserPattern($_POST);
        return;
    }

    // recovered Pattern
    // data: action=recoverPattern,email
    if ($_POST['action'] == "recoverPattern") {
        unset($_POST['action']);
        echo $pattern->recoverPattern($_POST);
        return;
    }

    // UPDATE PATTERN
    // data: action=updatePattern,address,yourEmail,phraseOrder,nKinName,nKinPhone,nKinEmail,recoveryDate}
    if ($_POST['action'] == "updatePattern") {
        unset($_POST['action']);
        echo $pattern->updatePattern($_POST);
        return;
    }
}

// Sending notification messages
$pattern = new pattern();
$patterns =  $pattern->notifier();
// echo $patterns['msg'];
