// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;

import "./StorageStruct.sol";
import "./AssetStore.sol";

interface IAssetStore {
    
    function store(StorageStruct.Asset memory asset,address owner) external view returns (bool);
    
    function fetch(address owner) external  view returns (StorageStruct.Asset[] memory);   

    function edit(StorageStruct.Asset memory asset,address owner, uint index) external view returns (bool);

    function remove(address owner, uint index) external view returns (bool);
}