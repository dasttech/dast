// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

library StorageStruct {

   struct Asset{

       address owner;
       string asset;
       string fullname;
       string user_email;
       string user_phone;
       Contact[] contacts;
       string password;
   }

   struct Contact{

       string phone;
       string email;
   }
    
}