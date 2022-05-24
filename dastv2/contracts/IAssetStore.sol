// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./StorageStruct.sol";

interface IAssetStore {
    
    function store(StorageStruct.Asset memory asset,address owner) external view returns (bool);
    
    function fetch(address owner) external  view returns (StorageStruct.Asset[] memory);   

    function edit(StorageStruct.Asset memory asset,address owner, uint index) external view returns (bool);

    function remove(address owner, uint index) external view returns (bool);
}