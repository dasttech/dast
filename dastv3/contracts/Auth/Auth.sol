// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
import "../Hashing/Hashing.sol";

contract Auth {

    using Hashing for *;
    using Utils for *;

    string public Platform_Token;

    constructor(string memory platform_token){
        Platform_Token = Hashing.hash(platform_token, platform_token);
    }

   
   function platformCheck(string memory platform_token) public view returns(bool){
    return Utils.compareStrings(Platform_Token, Hashing.hash(platform_token, platform_token));
   }

}