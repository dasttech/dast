// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract just_connect {
    uint256 public currentNumber;
    address public owner;

    constructor() {
        owner = msg.sender;
        currentNumber += 1;
    }

    function connect() public returns (bool) {
        currentNumber++;
        return true;
    }
}
