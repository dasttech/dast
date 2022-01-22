<?php
    require "conn.php";

    $conn = new conn();
    $conn = $conn->connect;
        
// // Update user table
$sql = "alter table patterns add column if not exists dueForRecover int(10) NOT NULL DEFAULT(0) after lastReminderDate";
    
    if ($conn->query($sql) === TRUE) {
        echo "Updated Successfully";
    } else {
        echo "Failed: " . $conn->error."<br>";
    }

// sql to create  admins table
// $sql2 = "alter table patterns drop column if exists dueForRecover";
    
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
