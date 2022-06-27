// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "./StorageStruct.sol";

contract AssetStore  {
    
    mapping(address =>StorageStruct.Asset[])  private  Assets;

    function store(StorageStruct.Asset memory asset,address owner) public returns (bool){
        Assets[owner][Assets[owner].length] = asset;
        return true;
    }

    function fetch(address owner) public view returns (StorageStruct.Asset[] memory){
        return Assets[owner];
    }    

     function edit(StorageStruct.Asset memory asset,address owner, uint index) public returns (bool){
        Assets[owner][index] = asset;
        return true;
    }

      function remove(address owner, uint index) public returns (bool){
       if (index >= Assets[owner].length) return false;

        for (uint i = index; i<Assets[owner].length-1; i++){
            Assets[owner][i] = Assets[owner][i+1];
        }
        delete Assets[owner][Assets[owner].length-1];
        return true;
    }
}
