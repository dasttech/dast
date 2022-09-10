// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;
import "../Structs/Structs.sol";
import "../Utils/Utils.sol";

library UserLib{

    function createUser(
        Structs.User memory new_user,
        mapping(address=>Structs.User) storage userAccounts,
        address[] storage usersList,
        mapping(string=>address) storage accountTokens,
        uint256 userCount        
    ) public returns (bool){

         userAccounts[msg.sender] = Structs.User({
                    id:userCount++,
                    wallet_addr:msg.sender,
                    account_token:new_user.account_token,
                    fullname:new_user.fullname,
                    avatar:"",
                    email:new_user.email,
                    phone:new_user.phone,
                    country:new_user.country,
                    street_address:new_user.street_address,
                    last_activity: block.timestamp,
                    others:new_user.others
                });

                // add user to user list
                usersList.push(msg.sender);
                accountTokens[new_user.account_token] = msg.sender;

                return true;
    }

    function fetchUserData(
        mapping(address=>Structs.User) storage userAccouts,
        mapping(address=>Structs.NextOfKin) storage nextOfKin,
        mapping(address=>Structs.Contact[]) storage tContacts        
    ) public view returns(
        Structs.User memory,
        Structs.NextOfKin memory,
        Structs.Contact[] memory
    ){

      return (userAccouts[tx.origin],nextOfKin[tx.origin],tContacts[tx.origin]);
    }


  function recoverAccount(
        address old_wallet_addr,
        mapping(address=>Structs.User) storage UserAccounts,
        address[] storage usersList,
        mapping(address=>Structs.Contact[]) storage Contacts,
        mapping(address=>Structs.NextOfKin) storage NextOfKin,
        mapping(string=>address) storage AccountTokens
        
    )
    public 

    returns (bool)
     {

    // move assets to new account

    UserAccounts[tx.origin] = UserAccounts[old_wallet_addr];

    usersList.push(tx.origin);

    Contacts[tx.origin] = Contacts[old_wallet_addr];

    NextOfKin[tx.origin] = NextOfKin[old_wallet_addr];

    AccountTokens[UserAccounts[old_wallet_addr].account_token] = tx.origin;

    return (true);
     }


     function accountSearch(
        Structs.SEARCH_TYPE search_type,
        string[] memory otp,
        string memory search_string,
        mapping(address=>Structs.User) storage UserAccounts,
        address[] storage usersList,
        mapping(address=>Structs.Contact[]) storage Contacts,
        mapping(string=>address) storage AccountTokens,
        mapping(address=>string[]) storage Rtoken
     ) 
     public  returns(Structs.FoundUser memory,Structs.Contact[] memory)  {

        

            Rtoken[msg.sender] = otp;
            Structs.FoundUser memory foundUser;
            
            if(search_type == Structs.SEARCH_TYPE.ACCOUNT_TOKEN){
                Structs.User memory user = UserAccounts[AccountTokens[search_string]];
                if(AccountTokens[search_string]==address(0)){return (foundUser,Contacts[address(0)]);}
              foundUser = Structs.FoundUser(user.fullname,user.phone,user.email,user.wallet_addr);
               return (foundUser,Contacts[user.wallet_addr]);
            }
            else if(search_type == Structs.SEARCH_TYPE.EMAIL){
                for (uint256 i = 0; i<usersList.length; i++){
                    string memory current_email = UserAccounts[usersList[i]].email;
                    if(Utils.compareStrings(current_email,search_string)){
                       foundUser = Structs.FoundUser(
                        UserAccounts[usersList[i]].fullname,
                        UserAccounts[usersList[i]].phone,
                        UserAccounts[usersList[i]].email,
                        UserAccounts[usersList[i]].wallet_addr);
                        return (foundUser,Contacts[UserAccounts[usersList[i]].wallet_addr]);
                    }
                }
                return (foundUser,Contacts[address(0)]);
            }
            else{

                for (uint256 i = 0; i <usersList.length; i++){

                    string memory current_phone = UserAccounts[usersList[i]].phone;

                    if(Utils.compareStrings(current_phone,search_string)){
                        foundUser = Structs.FoundUser(
                            UserAccounts[usersList[i]].fullname,
                            UserAccounts[usersList[i]].phone,
                            UserAccounts[usersList[i]].email,
                            UserAccounts[usersList[i]].wallet_addr
                        );

                        return (foundUser,Contacts[UserAccounts[usersList[i]].wallet_addr]);
                    }
                }
                return (foundUser,Contacts[address(0)]);
            }

     }
}