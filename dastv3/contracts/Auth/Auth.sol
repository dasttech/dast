// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3;
import "../Hashing/Hashing.sol";
import "../Users/Users.sol";
import "../Structs/Structs.sol";
import "../Users/Users.sol";

contract Auth {
    using Hashing for *;
    using Utils for *;
    using Structs for *;

    string Platform_Token;
    uint256 Recovery_Percent;
    Users users;
 
    modifier isAdmin(){
        require(users.hasRole(keccak256("ADMIN"),msg.sender),"access denined");
        _;
    } 
 

    constructor(string memory platform_token) {
        Platform_Token = Hashing.hash(platform_token, platform_token);
        Recovery_Percent = 66;
    }

    function platformCheck(string memory platform_token)
        public
        view
        returns (bool)
    {
        return
            Utils.compareStrings(
                Platform_Token,
                Hashing.hash(platform_token, platform_token)
            );
    }

    function setUser(Users newUserAddr) public isAdmin()  {
        users = Users(newUserAddr);
    }

    function changePlatformToken(string memory newToken) public isAdmin() {
        require(
            bytes(newToken).length >= 10,
            "Must be 10 characters and above"
        );
        Platform_Token = newToken;
    }

     function changeRecoveryPercent(uint256 newPercent) public isAdmin() {
        Recovery_Percent = newPercent;
    }

     function percentangeCheck(uint256 percent) external view returns(bool) {
       return percent>=Recovery_Percent;
    }
}
