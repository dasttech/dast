// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;

library StorageStruct {

    struct User{
        uint id;
        address addr;
        string email;
        string phone;
        string bio;
    }

   struct Asset{
       uint id;
       string token;
       string title;
       string asset;
   }

   struct Contact{
       uint id;
       string email;
       string phone;
   }
    
}