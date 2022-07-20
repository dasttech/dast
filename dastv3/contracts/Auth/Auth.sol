// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3;
import "../Hashing/Hashing.sol";
import "../Users/Users.sol";
import "../Structs/Structs.sol";

contract Auth {
    using Hashing for *;
    using Utils for *;
    using Structs for *;

    string public Platform_Token;
    Users users;

 

    constructor(string memory platform_token) {
        Platform_Token = Hashing.hash(platform_token, platform_token);
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

    function setUser(Users newUserAddr) public  {
        users = Users(newUserAddr);
    }

    function changePlatformToken(string memory newToken) public  {
        require(
            bytes(newToken).length >= 10,
            "Must be 10 characters and above"
        );
        Platform_Token = newToken;
    }
}
