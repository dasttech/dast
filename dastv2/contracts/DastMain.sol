// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
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
        string memory asset_text,
        string memory fullname,
        string memory user_email,
        string memory user_phone,
        string[][] memory contacts,
        string memory password
        ) 
        public {
        StorageStruct.Asset memory asset;
        asset.owner = msg.sender;
        asset.asset = asset_text;
        asset.fullname = fullname;
        asset.user_email = user_email;
        asset.user_phone = user_phone;
        asset.password = password;
        asset.contacts;

        for(uint i = 0; i<contacts.length; i++){    
            
            StorageStruct.Contact memory next_of_kins;
            next_of_kins.phone = contacts[i][0];
            next_of_kins.email = contacts[i][1];

            asset.contacts[i] = next_of_kins;
        }
        bool success = asset_store.store(asset, msg.sender);
              emit save(msg.sender,success );

        }


        }