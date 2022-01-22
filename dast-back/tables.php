<?php
    require "conn.php";

    $conn = new conn();
    $conn = $conn->connect;
        
// sql to create  admins table
$sql = "CREATE TABLE users (
    id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR (300) UNIQUE NOT NULL,
    ref_id VARCHAR (300) UNIQUE NOT NULL,
    status VARCHAR (1) DEFAULT('0'),
    phone varchar(300) NOT NULL,
    email varchar(300) NOT NULL,
    airdrop_status VARCHAR (1) DEFAULT('0'),
    purchased_ico VARCHAR (11) DEFAULT('0'),
    accessToken varchar(50) default('12345'),
    reg_date DATETIME NOT NULL
    )";
    
    if ($conn->query($sql) === TRUE) {
        echo "Table users created successfully<br>";
    } else {
        echo "Error creating users table: " . $conn->error."<br>";
    }
  


   
    // sql to create  members table
    $sql2 = "CREATE TABLE bonus (
        id int (11) primary key auto_increment,
        referer varchar(300) NOT NULL,
        refered varchar(300) NOT NULL,
        status VARCHAR (1) DEFAULT('0'),
        claim_on DATETIME NOT NULL
      
        )";
        
        if ($conn->query($sql2) === TRUE) {
            echo "Bonus table created successfully<br>";
        } else {
            echo "Error creating bonus table: " . $conn->error."<br>";
        }
        
        // sql to create  members table
    $sql2 = "CREATE TABLE patterns (
        id int (11) primary key auto_increment,
        title varchar(300) NOT NULL,
        address varchar(300) NOT NULL,
        phraseOrder varchar(300) NOT NULL,
        description text NOT NULL,
        nKinName varchar(300) NOT NULL,
        yourEmail varchar(300) NOT NULL,
        nKinEmail varchar(300) NOT NULL,
        nKinPhone varchar(300) NOT NULL,
        reminderCount int(10) NOT NULL default(0),
        lastReminderDate DATETIME NULL,
        dueForRecover int(10) NOT NULL default(0),
        recoveryDate DATETIME NOT NULL
        )";
        
        if ($conn->query($sql2) === TRUE) {
            echo "patterns table created successfully<br>";
        } else {
            echo "Error creating patterns table: " . $conn->error."<br>";
        }
   
        $conn->close();
