// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
import "../Structs/Structs.sol";

library Utils  {

    function compareStrings(string memory str1, string memory str2) public pure returns (bool) {
        return (keccak256(abi.encodePacked((str1))) == keccak256(abi.encodePacked((str2))));
    }

}