// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
import "./StorageStruct.sol";

library Recovery  {
    using StorageStruct for *;
    
    function fetchRecoveredAssets(
         address addr,
         mapping(address=>StorageStruct.Asset[]) storage assets,
         mapping(string=>StorageStruct.Contact[]) storage contacts
    )internal view returns(
        bool,
        StorageStruct.Asset[] memory,
        StorageStruct.Contact[][] memory
    ){
        uint totalAssets = assets[addr].length;

        StorageStruct.Asset[] memory myassets = assets[addr];
        StorageStruct.Contact[][] memory mycontacts = new StorageStruct.Contact[][](totalAssets);
                           
            for(uint j = 0; j < myassets.length; j++){
                mycontacts[j] = contacts[myassets[j].token];
            }

            return (
            myassets.length > 0, 
            myassets, 
            mycontacts
        );

    }
        

    function changeOwnership(
        address oldOwner,
        mapping(address => StorageStruct.User) storage users,
        //ownership by email=>address
        mapping(string => address) storage ownerByEmail,
        // msg.sender=>Asset
        mapping(address => StorageStruct.Asset[]) storage assets,
        // asset's token =>msg.sender
        mapping(string => address) storage owners
    ) internal returns(bool){
        users[tx.origin] = users[oldOwner];
        ownerByEmail[users[tx.origin].email] = tx.origin;
        assets[tx.origin] = assets[oldOwner];
        uint assetCount = assets[tx.origin].length;

        for(uint i = 0; i<assetCount; i++){
            owners[assets[tx.origin][i].token] = tx.origin;
        }
        return true;
    }

}