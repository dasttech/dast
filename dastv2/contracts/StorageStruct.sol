// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

library StorageStruct {

   struct Asset{
       address owner;
       bytes32 asset;
       string fullname;
       string user_email;
       string user_phone;
       bytes32 contacts;
       string password;
   }
    
}