// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.7.3;
import "./UserLib.sol";
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
    mapping(address=>string[]) Rtoken;

    // user roles
    bytes32 public constant ADMIN = keccak256("ADMIN");
    bytes32 public constant VALIDATOR = keccak256("VALIDATOR");

    
    constructor(Auth _auth){
        auth = Auth(_auth);
         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    // Modifiers
    modifier userExist(address user_address,string memory token){
        require(bytes(UserAccounts[user_address].fullname).length < 1, "User exist");
        require(AccountTokens[token]==address(0),"Token used");
        _;
    }

    modifier platformCheck(string memory platform_token){
        require(auth.platformCheck(platform_token), "Invalid access token");
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
                
                bool isUserCreated = UserLib.createUser(new_user, UserAccounts,usersList,AccountTokens,userCount++);
                emit UserCreated(msg.sender);
                return isUserCreated;

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
            require(contacts.length>=3,"Minimum contacts : 3");
           
           delete Contacts[msg.sender];

           for(uint i = 0; i<contacts.length; i++){
                Contacts[msg.sender].push(contacts[i]);
           }

            updateLastActivity();
            return true;
        }

    function contactCount(address user_address) public view returns (uint256){
            return Contacts[user_address].length;
        }


    function fetchUserData(
                string memory platform_token
                )
            external platformCheck(platform_token) 
            returns(
                    Structs.User memory,
                    Structs.NextOfKin memory,
                    Structs.Contact[] memory
                ){
                
                updateLastActivity();

                return UserLib.fetchUserData(UserAccounts,NextOfKin,Contacts);
        
            }


    function accountSearch(
        string memory platform_token,
        Structs.SEARCH_TYPE search_type,
        string[] memory otp,
        string memory search_string
        )
        public 
        platformCheck(platform_token)
         returns(Structs.FoundUser memory,Structs.Contact[] memory){
            return UserLib.accountSearch(
                search_type,
                otp,
                search_string,
                UserAccounts,
                usersList,
                Contacts,
                AccountTokens,
                Rtoken                
            );
         }


        function recoverAccount(
            string memory platform_token,
            address old_wallet_addr,
            string[] memory otps
        )
        public 
        platformCheck(platform_token)

        returns (bool)
        {

            require(
                Utils.compareStrings(otps[0],Rtoken[msg.sender][0])&&
                Utils.compareStrings(otps[1],Rtoken[msg.sender][1]),
                "Invalid Tokens"
            );

    emit AccountRecovered(old_wallet_addr,msg.sender);
    return UserLib.recoverAccount(
        old_wallet_addr,
        UserAccounts,
        usersList,
        Contacts,
        NextOfKin,
        AccountTokens
        );

     }

      function recoverAccountByNextOfKin(
            string memory platform_token,
            address old_wallet_addr
        )
        external 
        platformCheck(platform_token)
        returns (bool)
        {

    emit AccountRecovered(old_wallet_addr,msg.sender);
    return UserLib.recoverAccount(
        old_wallet_addr,
        UserAccounts,
        usersList,
        Contacts,
        NextOfKin,
        AccountTokens
        );

     }

}