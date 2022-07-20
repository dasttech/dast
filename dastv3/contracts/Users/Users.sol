// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;
import "../Hashing/Hashing.sol";
import "../Auth/Auth.sol";
import "../Structs/Structs.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Users is AccessControl {
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

    // user roles
    bytes32 public constant ADMIN = keccak256("ADMIN");
    bytes32 public constant VALIDATOR = keccak256("VALIDATOR");

    
    constructor(Auth _auth){
        auth = Auth(_auth);
         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // Modifiers
    modifier userExist(address user_address,string memory token){
        require(bytes(UserAccounts[user_address].fullname).length < 1,"User already exist");
        require(AccountTokens[token]==address(0),"Token has been used");
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
    event AccountRecovered(address indexed olduser,address indexed new_user);

    function updateLastActivity() internal {
        UserAccounts[msg.sender].last_activity = block.timestamp;
    }

    function createAccount(
            string memory platform_token,
            Structs.User memory new_user
        )
        public userExist(msg.sender,new_user.account_token) platformCheck(platform_token)
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
        Structs.SEARCH_TYPE search_type,
        Structs.OTP memory otp,
        string memory search_string
        )
        public 
        platformCheck(platform_token)
         returns(string[] memory){
            string[] memory data = new string[](3);//fullname,
            Structs.foundUser memory foundUser;
            OTPS[msg.sender] = otp;

            if(search_type == Structs.SEARCH_TYPE.ACCOUNT_TOKEN){
                Structs.User memory user = UserAccounts[AccountTokens[search_string]];
                if(AccountTokens[search_string]==address(0)){return data;}
              foundUser.fullname = user.fullname;
              foundUser.phone = user.phone;
              foundUser.email = user.email;
               foundUser.wallet_addr = user.wallet_addr;
               return data;
            }
            else if(search_type == Structs.SEARCH_TYPE.EMAIL){
                for (uint256 i = 0; i<usersList.length; i++){
                    string memory current_email = UserAccounts[usersList[i]].email;
                    if(Utils.compareStrings(current_email,search_string)){
                       foundUser.fullname = UserAccounts[usersList[i]].fullname;
                       foundUser.phone = UserAccounts[usersList[i]].phone;
                       foundUser.email = UserAccounts[usersList[i]].email;
                        foundUser.wallet_addr = UserAccounts[usersList[i]].wallet_addr;
                        return data;
                    }

                }
                return data;
            }
            else{

                for (uint256 i = 0; i<usersList.length; i++){

                    string memory current_phone = UserAccounts[usersList[i]].phone;

                    if(Utils.compareStrings(current_phone,search_string)){
                        foundUser.fullname = UserAccounts[usersList[i]].fullname;
                       foundUser.phone = UserAccounts[usersList[i]].phone;
                       foundUser.email = UserAccounts[usersList[i]].email;
                        foundUser.wallet_addr = UserAccounts[usersList[i]].wallet_addr;
                        return data;
                    }

                }
                return data;
            }

         }


    function recoverAccount(
        string memory platform_token,
        address old_wallet_addr,
        Structs.OTP memory otps
    )
    public 
    platformCheck(platform_token)

    returns (bool)
     {

        require(
            Utils.compareStrings(otps.email_otp,OTPS[old_wallet_addr].email_otp) &&
            Utils.compareStrings(otps.phone_otp,OTPS[old_wallet_addr].phone_otp),
            "Invalid recovery Tokens"
        );


    // move assets to new account

    UserAccounts[msg.sender] = UserAccounts[old_wallet_addr];

    usersList.push(msg.sender);

    Contacts[msg.sender] = Contacts[old_wallet_addr];

    NextOfKin[msg.sender] = NextOfKin[old_wallet_addr];

    AccountTokens[UserAccounts[old_wallet_addr].account_token] = msg.sender;

    emit AccountRecovered(old_wallet_addr,msg.sender);
    
    return true;

     }

}