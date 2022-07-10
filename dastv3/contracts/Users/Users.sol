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

    // Users list;
    mapping(address => Structs.User) UserAccounts;
    address[] usersList;
    uint256 public userCount;

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
    function createAccount(
            string memory platform_token,
            Structs.User memory new_user
        )
        public userExist(tx.origin) platformCheck(platform_token)
            returns (bool){
                
                // create account;
                UserAccounts[tx.origin] = Structs.User({
                    id:userCount++,
                    wallet_addr:tx.origin,
                    fullname:new_user.fullname,
                    avatar:"",
                    email:new_user.email,
                    phone:new_user.phone,
                    country:new_user.country,
                    street_address:new_user.street_address,
                    next_of_kin:new_user.next_of_kin,
                    next_of_kin_phone:new_user.next_of_kin_phone,
                    next_of_kin_email:new_user.next_of_kin_email, 
                    others:new_user.others
                });

                // add user to user list
                usersList.push(tx.origin);
                emit UserCreated(tx.origin);
                return true;

            }

    function editAccount(
            string memory platform_token,
            Structs.User memory edited_user
        )
        public platformCheck(platform_token)
            returns (bool){
                
                // create account;
                UserAccounts[tx.origin].fullname = edited_user.fullname;
                UserAccounts[tx.origin].country = edited_user.country;
                UserAccounts[tx.origin].street_address = edited_user.street_address;
                UserAccounts[tx.origin].next_of_kin = edited_user.next_of_kin;
                UserAccounts[tx.origin].next_of_kin_phone = edited_user.next_of_kin_phone;
                UserAccounts[tx.origin].next_of_kin_email = edited_user.next_of_kin_email;
                UserAccounts[tx.origin].others = edited_user.others;

                // add user to user list
                usersList.push(tx.origin);
                emit UserAccountEdited(tx.origin);
                return true;

            }

        function updateContacts(
                string memory platform_token,
                string memory email,
                string memory phone
            )
            public platformCheck(platform_token) returns (bool){
                
                UserAccounts[tx.origin].email = email;
                UserAccounts[tx.origin].phone = phone;
                emit UserContactsUpdated(tx.origin);
                return true;
            }

        function fetchUserData(
                string memory platform_token
            )
            public view platformCheck(platform_token) returns(Structs.User memory){
                
                return UserAccounts[tx.origin];
            }


}