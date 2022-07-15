// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;

library Structs {

    struct User{
        uint256 id;
        address wallet_addr;
        string fullname;
        string avatar;
        string email;
        string phone;
        string country;
        string street_address;
        string next_of_kin;
        string next_of_kin_phone;
        string next_of_kin_email; 
        string others;
    }

   struct Asset{
       uint256 id;
       address owner;
       string token;
       string title;
       string asset;
   }

   struct Contact{
       uint256 id;
       string assetToken;
       string name;
       string email;
       string phone;
       string country;
       string relationship;

   }
    
}