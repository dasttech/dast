<?php
    require "conn.php";

    $conn = new conn();
    $conn = $conn->connect;
        
// // Update user table
$sql = "alter table users add column if not exists accessToken varchar(50) default('199362004') after purchased_ico";
    
    if ($conn->query($sql) === TRUE) {
        echo "Updated Successfully";
    } else {
        echo "Failed: " . $conn->error."<br>";
    }

//     // sql to create  admins table
// $sql2 = "alter table users drop column if exists icoClaimedTimes";
    
// if ($conn->query($sql2) === TRUE) {
//     echo "Updated Successfully";
// } else {
//     echo "Failed: " . $conn->error."<br>";
// }

 // New Access Token
//  $sql3 = "update users set accessToken = '123456'";
    
//  if ($conn->query($sql3) === TRUE) {
//      echo "Updated Successfully";
//  } else {
//      echo "Failed: " . $conn->error."<br>";
//  }

//         $conn->close();
