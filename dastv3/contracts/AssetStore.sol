// SPDX-License-Identifier: MIT
pragma solidity >=0.8.6;
import "./Structs/Structs.sol";
import "./Recovery.sol";
import "./Utils/Utils.sol";
import "./Hashing/Hashing.sol";

contract AssetStore {
    // using Structs for *;
    // using Recovery for *;
    // using Utils for *;
    // using Hashing for *;

    // address admin;
    // // users
    // mapping(address => Structs.User) users;
    // uint256 userCount;
    // //ownership by email=>address
    // mapping(string => address) ownerByEmail;
    // // msg.sender=>Asset
    // mapping(address => Structs.Asset[]) assets;
    // // asset's token =>msg.sender
    // mapping(string => address) public owners;
    // // asset's token => trusted contaccts
    // mapping(string => Structs.Contact[]) contacts;
    // //Recovery pins: token=>owner=> [pins]
    // //token,onwner and pins must be hash
    // mapping(string => mapping(address=> string[])) recoveryPins;

    // //Platform access token
    // string dbAccessToken;

    // enum recoveryMethod{
    //     OTP,
    //     VALIDATOR
    // }

    // modifier onlyOwner(){
    //     require(tx.origin==admin,"Only admin call this");
    //     _;
    // }

    // modifier plaformCheck(string memory dbToken){
    //     string memory dehashedToken = Hashing.dehash(dbToken,dbAccessToken);
    //     require(Utils.compareStrings(dbToken,dehashedToken),"Access outside dast platform denied");
    //     _;
    // }

    // constructor(){
    //     admin = tx.origin;
    // }

    //  function changeAdmin(address newAdmin) 
    // public onlyOwner returns(bool){
    //     admin = newAdmin;
    //     return true;
    // }

    // //Token should be hashed with itself from the frontend;
    // function setDbAccessToken(string memory token) 
    // public onlyOwner returns(bool){
    //     dbAccessToken = token;
    //     return true;
    // }


    // function createAccount(
    //     string memory email,
    //     string memory phone,
    //     string memory bio
    // )
    // public returns(bool){
    //     require(ownerByEmail[email]==address(0),"Email has been used");
    //     users[tx.origin] = Structs.User(userCount++,tx.origin,email,phone,bio);
    //     ownerByEmail[email] = tx.origin;
    //     return true;
    // }

    

    // function store(
    //     string memory token,
    //     string memory title,
    //     string memory asset,
    //     Structs.Contact[] memory trusted_contacts
    // ) public returns (bool) {
    //     address owner = tx.origin;
    //     uint256 nextAsset = assets[owner].length;

    //     // Save asset
    //     assets[tx.origin].push(
    //         Structs.Asset({
    //             id: nextAsset,
    //             token: token,
    //             title: title,
    //             asset: asset
    //         })
    //     );

    //     // add address to the owners
    //     owners[token] = owner;

    //     // save contacts
    //     for (uint256 i = 0; i < trusted_contacts.length; i++) {
    //         contacts[token].push(
    //             Structs.Contact(
    //                 i,
    //                 trusted_contacts[i].email,
    //                 trusted_contacts[i].phone
    //             )
    //         );
    //     }

    
    //     return true;
    // }

    // function fetch()
    //     public
    //     view
    //     returns (Structs.Asset[] memory, Structs.Contact[][] memory)
    // {
    //     Structs.Asset[] memory asset = assets[tx.origin];
    //     Structs.Contact[][]
    //         memory contact = new Structs.Contact[][](asset.length);
    //     for (uint256 i = 0; i < asset.length; i++) {
    //         contact[i] = contacts[asset[i].token];
    //     }

    //     return (assets[tx.origin], contact);
    // }

    // function edit(
    //     uint256 id,
    //     string memory token,
    //     string memory title,
    //     string memory asset,
    //     Structs.Contact[] memory trusted_contacts
    // ) public payable returns (bool) {

    //     address owner = tx.origin;
        
    //     assets[owner][id] = Structs.Asset({
    //         id: id,token: token,title: title,asset: asset
    //     });

    //     owners[token] = owner;
    //     uint counter = trusted_contacts.length;
    //     // remove form contacts
    //     delete contacts[token];
    //     for (uint256 i = 0; i < counter; i++) {
            
    //            contacts[token].push(Structs.Contact(
    //                 i,
    //                 trusted_contacts[i].email,
    //                 trusted_contacts[i].phone
    //             ));
    //     }

    //     return true;
    // }

    // function remove(uint256 index) public returns (bool) {
    //     string memory token = assets[tx.origin][index].token;

    //     delete owners[token];
    //     uint256 j = assets[tx.origin].length - 1;
    //     for (uint256 i = index; index < j; i++) {
    //         assets[tx.origin][i] = assets[tx.origin][i + 1];
    //     }

    //     // delete assets[tx.origin][j];
    //     assets[tx.origin].pop();
    //     delete contacts[token];

    //     return true;
    // }

    // function findAccountByEmail(string memory email)
    //     public
    //     view
    //     returns (
    //         bool,
    //         // Structs.Asset[] memory,
    //         // Structs.Contact[][] memory
    //         address
    //     )
    // {
    //     address addr = ownerByEmail[email];
    //     bool status = addr != address(0);
    //     return (status,addr);
    // }

    
    // //pins are to be hashed with dbToken
    // //new token is generate for every request
    // //addr is account address to be recovered
    // //security pins are the encrypted pins for recovery of the assets
    // function requestRecovery(
    //     string memory dbToken,
    //     string memory token,
    //     address addr,
    //     string[] memory securityPins
    //      ) 
    //      public 
    //      plaformCheck(dbToken) 
    //      returns(bool){
    //         recoveryPins[token][addr] = securityPins;
    //         return true;
    //      }

    // function recoverAccount(
    //     string memory dbToken,
    //     recoveryMethod rm,
    //     address addr,
    //     string memory token,        
    //     string[] memory securityPins
    //     )  public plaformCheck(dbToken) returns(bool){
    //         string[] memory Pins = recoveryPins[token][addr];
    //         require(Pins.length>0,"Invalid Token");
    //         bool isPinValid = false;

    //         if(rm==recoveryMethod.OTP){
    //             require(
    //                 Utils.compareStrings(securityPins[0],Pins[0])&&
    //                 Utils.compareStrings(securityPins[1],Pins[1]), 
    //                 "Incorrect Pins"
    //                 );
    //                 isPinValid = true;
    //         }
    //         else{

    //             for(uint i = 0; i < securityPins.length; i++){
    //                 if(Utils.compareStrings(securityPins[i],
    //                     Pins[i])){

    //                 isPinValid = true;
                        
    //                     }
    //                     else{

    //                 isPinValid = false;

    //                 }
    //             }
    //         }

    //         if(isPinValid){
    //             //change ownership
    //             return  Recovery.changeOwnership(
    //                     addr,
    //                     users,
    //                     ownerByEmail,
    //                     assets,
    //                     owners
    //                 );
    //         }else{
    //             revert("Incorrect Pins");
    //         }
    //      }
}
