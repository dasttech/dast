// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
import "../Hashing/Hashing.sol";
import "../Auth/Auth.sol";
import "../Structs/Structs.sol";

contract Users {
    using Hashing for *;
    using Utils for *;
    using Structs for *;

    
    Auth auth;
    // owner=>assets
    mapping(address=>Structs.Asset[]) assets;
    // assettoken=>owner
    mapping(string=>address) assetOwners;
    //token=>contacts[]
    mapping(string=>Structs.Contact[]) contacts;
    
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
        require(assetOwners[assetToken]!=address(0),"1:Token exists");
        _;
    }
    


    constructor(Auth _auth){
        auth = Auth(_auth);
    }

    // Save assets
    function saveAsset(

        string memory platform_token,
        Structs.Asset memory _asset,
        Structs.Contact[] memory _contact

            ) 
            public 
            platformCheck(platform_token) 
            tokenNotExist(_asset.token)
            
            returns(bool)
        
        {
            require(_contact.length>=3,"Add more contacts");

            uint256 nextIndex = assets[tx.origin].length;
            assetOwners[_asset.token] = tx.origin;
            assets[tx.origin].push(
                Structs.Asset({
                    id:nextIndex,
                    owner:_asset.owner,
                    token:_asset.token,
                    title:_asset.title,
                    asset:_asset.asset
            }));

            for(uint i =0; i<_contact.length; i++){
                contacts[_asset.token].push(
                    Structs.Contact({
                        id:i,
                        assetToken:_contact[i].assetToken,
                        name:_contact[i].name,
                        email:_contact[i].email,
                        phone:_contact[i].phone,
                        country:_contact[i].country,
                        relationship:_contact[i].relationship
                    })
                );
            }

            
            emit AssetSaved(tx.origin, nextIndex);

            return true;
            
    
        }

    // Edit asset
    function editAsset( 
        
        string memory platform_token,
        Structs.Asset memory _asset,
        Structs.Contact[] memory _contact

            ) 
            public 
            platformCheck(platform_token) 
            tokenExist(_asset.token)
            
            returns(bool)

        {
            require(_contact.length>=3,"Add more contacts");

            assets[tx.origin][_asset.id] = 
                Structs.Asset({
                    id:_asset.id,
                    owner:_asset.owner,
                    token:_asset.token,
                    title:_asset.title,
                    asset:_asset.asset
            });

            Structs.Contact[] memory NewContacts = new Structs.Contact[](_contact.length);

            for(uint i = 0; i < _contact.length; i++){
                NewContacts[i] =
                    Structs.Contact({
                        id:i,
                        assetToken:_contact[i].assetToken,
                        name:_contact[i].name,
                        email:_contact[i].email,
                        phone:_contact[i].phone,
                        country:_contact[i].country,
                        relationship:_contact[i].relationship
                    });
            }

            contacts[_asset.token] = NewContacts;
            
            emit AssetEdited(tx.origin, _asset.id);

            return true;
            

    }

    // Delete Asset
    function deleteAsset(
        
        string memory platform_token,
        string memory _asset_token,
        uint256 _asset_id

            ) 
            public 
            platformCheck(platform_token) 
            tokenExist(_asset_token)
            
            returns(bool)

        {
            for(uint256 i = _asset_id; i < assets[tx.origin].length; i++){
                assets[tx.origin][i] = assets[tx.origin][i+1];
            }

             assets[tx.origin].pop();

             delete assetOwners[_asset_token];

             delete contacts[_asset_token];

             emit AssetDeleted(tx.origin,_asset_token);

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
                Structs.Asset[] memory,
                Structs.Contact[][] memory
            )

        {
                uint256 assetCount = assets[tx.origin].length;
                Structs.Asset[] memory _assets =assets[tx.origin];
                Structs.Contact[][] memory _contacts = new Structs.Contact[][](assetCount);

            for(uint256 i = 0; i<assetCount; i++){
                uint256 contactCount = contacts[assets[tx.origin][i].token].length;               
               for(uint256 j = 0; j < contactCount; j++ ){
                
                _contacts[i][j] = Structs.Contact({
                        id:contacts[assets[tx.origin][i].token][j].id,
                        assetToken:contacts[assets[tx.origin][i].token][j].assetToken,
                        name:contacts[assets[tx.origin][i].token][j].name,
                        email:contacts[assets[tx.origin][i].token][j].email,
                        phone:contacts[assets[tx.origin][i].token][j].phone,
                        country:contacts[assets[tx.origin][i].token][j].country,
                        relationship:contacts[assets[tx.origin][i].token][j].relationship

                });

               }

            }
            return (_assets,_contacts);
    }

        // Find asset by token
    function findAsset(  
        
        string memory platform_token,
        string memory asset_token
            ) 
            public 
            view
            platformCheck(platform_token) 
            tokenExist(asset_token)
            returns(
                Structs.Asset memory
            )

        {
            uint256 assetIndex;
            address assetOwner = assetOwners[asset_token];
            uint256 assetCount = assets[assetOwner].length;

            for(uint256 i = 0; i < assetCount; i++){
                if(Utils.compareStrings(asset_token, assets[assetOwner][i].token)){
                    assetIndex = i;
                    break;
                }
            }

         return Structs.Asset({
                    id:assets[assetOwner][assetIndex].id,
                    owner:assets[assetOwner][assetIndex].owner,
                    token:assets[assetOwner][assetIndex].token,
                    title:assets[assetOwner][assetIndex].title,
                    asset:""
            });

    }


}