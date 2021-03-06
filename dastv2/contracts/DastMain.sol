// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import "./StorageStruct.sol";
import "./IAssetStore.sol";

contract DastMain {
       
        address private owner;
        IAssetStore asset_store;
        event save(address indexed owner, bool success);

        constructor(IAssetStore asset_store_address){
            
            owner = msg.sender;
            asset_store = asset_store_address;

        }

        function saveAsset(
        bytes32 asset_text,
        string calldata fullname,
        string calldata user_email,
        string calldata user_phone,
        bytes32  contacts,
        string calldata password
        ) 
        public { 
                
        StorageStruct.Asset memory asset = StorageStruct.Asset({ 
        owner:msg.sender,
        asset:asset_text,
        fullname:fullname,
        user_email:user_email,
        user_phone:user_phone,
        contacts:contacts, //stringified object
        password:password
        });
               
        bool success = asset_store.store(asset, msg.sender);
              emit save(msg.sender,success );

        }


        }