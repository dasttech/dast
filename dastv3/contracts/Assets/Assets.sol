// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3;
import "../Hashing/Hashing.sol";
import "../Auth/Auth.sol";
import "../Structs/Structs.sol";

contract Assets {
    using Hashing for *;
    using Utils for *;
    using Structs for *;

    
    Auth auth;
    // owner=>assets
    mapping(address=>Structs.Asset[]) assets;
    // assettoken=>owner
    mapping(string=>address) assetOwners;
    
    // events
    event AssetSaved(address indexed owner,uint indexed id);

     // events
    event AssetEdited(address indexed owner,uint indexed id);
    
    // events
    event AssetDeleted(address indexed owner,string indexed _asset_token);

    //modifiers
    modifier platformCheck(string memory platform_token){
        require(auth.platformCheck(platform_token),"Wrong token");
        _;
    }

    modifier tokenNotExist(string memory assetToken){
        require(assetOwners[assetToken]==address(0),"1:Token exists");
        _;
    }
    modifier tokenExist(string memory assetToken){
        require(assetOwners[assetToken]!=address(0),"1:Token not exists");
        _;
    }
    


    constructor(Auth _auth){
        auth = Auth(_auth);
    }

    // Save assets
    function saveAsset(

        string memory platform_token,
        Structs.Asset memory _asset

            ) 
            public 
            platformCheck(platform_token)
            
            returns(bool)
        
        {
            uint256 nextIndex = assets[msg.sender].length;
            assets[msg.sender].push(
                Structs.Asset({
                    id:nextIndex,
                    title:_asset.title,
                    asset:_asset.asset
            }));
            
            emit AssetSaved(msg.sender, nextIndex);

            return true;
            
    
        }

    // Edit asset
    function editAsset( 
        
        string memory platform_token,
        Structs.Asset memory _asset

            ) 
            public 
            platformCheck(platform_token) 
            
            returns(bool)

        {

            assets[msg.sender][_asset.id] = 
                Structs.Asset({
                    id:_asset.id,
                    title:_asset.title,
                    asset:_asset.asset
            });
            
            emit AssetEdited(msg.sender, _asset.id);

            return true;
            
    }

    // Delete Asset
    function deleteAsset(
        
        string memory platform_token,
        uint256 _asset_id

            ) 
            public 
            platformCheck(platform_token) 
            
            returns(bool)

        {
            for(uint256 i = _asset_id; i < assets[msg.sender].length-1; i++){
                assets[msg.sender][i] = assets[msg.sender][i+1];
            }

             assets[msg.sender].pop();

             return true;

    }

        // Fetch asset
    function fetchAsset( 
        
        string memory platform_token

            ) 
            public 
            view
            platformCheck(platform_token) 
            
            returns(
                Structs.Asset[] memory
            )

        {
                Structs.Asset[] memory _assets = assets[msg.sender];
            return (_assets);
    }

      

}