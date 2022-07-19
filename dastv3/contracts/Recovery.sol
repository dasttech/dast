// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3;
import "./Structs/Structs.sol";

library Recovery  {
    // using Structs for *;
    
    // function fetchRecoveredAssets(
    //      address addr,
    //      mapping(address=>Structs.Asset[]) storage assets,
    //      mapping(string=>Structs.Contact[]) storage contacts
    // )internal view returns(
    //     bool,
    //     Structs.Asset[] memory,
    //     Structs.Contact[][] memory
    // ){
    //     uint totalAssets = assets[addr].length;

    //     Structs.Asset[] memory myassets = assets[addr];
    //     Structs.Contact[][] memory mycontacts = new Structs.Contact[][](totalAssets);
                           
    //         for(uint j = 0; j < myassets.length; j++){
    //             mycontacts[j] = contacts[myassets[j].token];
    //         }

    //         return (
    //         myassets.length > 0, 
    //         myassets, 
    //         mycontacts
    //     );

    // }
        

    // function changeOwnership(
    //     address oldOwner,
    //     mapping(address => Structs.User) storage users,
    //     //ownership by email=>address
    //     mapping(string => address) storage ownerByEmail,
    //     // msg.sender=>Asset
    //     mapping(address => Structs.Asset[]) storage assets,
    //     // asset's token =>msg.sender
    //     mapping(string => address) storage owners
    // ) internal returns(bool){
    //     users[msg.sender] = users[oldOwner];
    //     ownerByEmail[users[msg.sender].email] = msg.sender;
    //     assets[msg.sender] = assets[oldOwner];
    //     uint assetCount = assets[msg.sender].length;

    //     for(uint i = 0; i<assetCount; i++){
    //         owners[assets[msg.sender][i].token] = msg.sender;
    //     }
    //     return true;
    // }

}