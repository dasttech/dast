// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3;
import "../Structs/Structs.sol";

library Utils  {

    function compareStrings(string memory str1, string memory str2) public pure returns (bool) {
        return (keccak256(abi.encodePacked((str1))) == keccak256(abi.encodePacked((str2))));
    }

    function checkPercent(uint256 y,uint256 x) public pure returns (uint256){
         return (100*x)/y;
      }

}