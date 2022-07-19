// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;
import "../Hashing/Hashing.sol";
import "../Auth/Auth.sol";
import "../Structs/Structs.sol";

contract Users {
    using Hashing for *;
    using Utils for *;
    using Structs for *;

    Auth auth;

    // Users list;
    mapping(address => Structs.User) UserAccounts;
    address[] usersList;
    uint256 public userCount;
    // address=>contacts[]
    mapping(address=>Structs.Contact[]) Contacts;
    // address=>nextOfkin[]
    mapping(address=>Structs.NextOfKin) NextOfKin;
    // user tokens
    mapping(string=>address) AccountTokens;
    //otp tokens: address== => OTP
    mapping(address=>Structs.OTP)  OTPS;

    
    constructor(Auth _auth){
        auth = Auth(_auth);
    }

    // Modifiers
    modifier userExist(address user_address){
        require(bytes(UserAccounts[user_address].fullname).length < 1,"User already exist");
        _;
    }

    modifier platformCheck(string memory platform_token){
        require(auth.platformCheck(platform_token), "Access denied - Invalid access token");
        _;
    }

    // Events

    event UserCreated(address indexed user_address);
    event UserContactsUpdated(address indexed user_address);
    event UserAccountEdited(address indexed user_address);

    function updateLastActivity() internal {
        UserAccounts[msg.sender].last_activity = block.timestamp;
    }

    function createAccount(
            string memory platform_token,
            Structs.User memory new_user
        )
        public userExist(msg.sender) platformCheck(platform_token)
            returns (bool){
                
                // create account;
                UserAccounts[msg.sender] = Structs.User({
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
                AccountTokens[new_user.account_token] = msg.sender;
                emit UserCreated(msg.sender);
                return true;

            }

    function editAccount(
            string memory platform_token,
            Structs.User memory edited_user
        )
        public platformCheck(platform_token)
            returns (bool){
                
                // create account;
                UserAccounts[msg.sender].fullname = edited_user.fullname;
                UserAccounts[msg.sender].country = edited_user.country;
                UserAccounts[msg.sender].street_address = edited_user.street_address;
                UserAccounts[msg.sender].others = edited_user.others;
                
                // add user to user list
                emit UserAccountEdited(msg.sender);
                updateLastActivity();
                return true;

            }

    function updateContacts(
                string memory platform_token,
                string memory email,
                string memory phone
            )
            public platformCheck(platform_token) returns (bool){
                
                UserAccounts[msg.sender].email = email;
                UserAccounts[msg.sender].phone = phone;
                emit UserContactsUpdated(msg.sender);
                updateLastActivity();
                return true;
            }

    function addNextOfKin(
            string memory platform_token,
            Structs.NextOfKin memory nextOfKin
        )
        public 
        platformCheck(platform_token)
        returns(bool){

            NextOfKin[msg.sender] = nextOfKin;
            updateLastActivity();
            return true;

        }

    function addContact(
            string memory platform_token,
            Structs.Contact[] memory contacts
        )
        public 
        platformCheck(platform_token)
        returns(bool){
            require(contacts.length>=3,"Minimum number of contacts is 3");
           
           delete Contacts[msg.sender];

           for(uint i = 0; i<contacts.length; i++){
                Contacts[msg.sender].push(contacts[i]);
           }

            updateLastActivity();
            return true;
        }


    function fetchUserData(
                string memory platform_token
                )
            public platformCheck(platform_token) 
            returns(Structs.User memory,Structs.NextOfKin memory){
                updateLastActivity();
                return( UserAccounts[msg.sender],NextOfKin[msg.sender]);
            }


    function accountSearch(
        string memory platform_token,
        Structs.RECOVERY_TYPE recovery_type,
        Structs.SEARCH_TYPE search_type,
        Structs.OTP memory otp,
        string memory search_string
        )
        public 
        platformCheck(platform_token)
         returns(string[] memory){

            OTPS[msg.sender] = otp;
            
            string[] memory data = new string[](3);

            if(search_type == Structs.SEARCH_TYPE.ACCOUNT_TOKEN){

                Structs.User memory user = UserAccounts[AccountTokens[search_string]];
                if(AccountTokens[search_string]==address(0)){return data;}
               data[0] = user.fullname;
               data[1] = user.phone;
               data[2] = user.email;
               return data;
            }
            else if(search_type == Structs.SEARCH_TYPE.EMAIL){
                for (uint256 i = 0; i<usersList.length; i++){

                    string memory current_email = UserAccounts[usersList[i]].email;

                    if(Utils.compareStrings(current_email,search_string)){
                        data[0] = UserAccounts[usersList[i]].fullname;
                        data[1] = UserAccounts[usersList[i]].phone;
                        data[2] = UserAccounts[usersList[i]].email;
                        return data;
                    }

                }
                return data;
            }
            else{

                for (uint256 i = 0; i<usersList.length; i++){

                    string memory current_phone = UserAccounts[usersList[i]].phone;

                    if(Utils.compareStrings(current_phone,search_string)){
                        data[0] = UserAccounts[usersList[i]].fullname;
                        data[1] = UserAccounts[usersList[i]].phone;
                        data[2] = UserAccounts[usersList[i]].email;
                        return data;
                    }

                }
                return data;
            }

         }
}