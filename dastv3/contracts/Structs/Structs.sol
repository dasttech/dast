// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3;

library Structs {
    
    struct User {
        uint256 id;
        address wallet_addr;
        string account_token;
        string fullname;
        string avatar;
        string email;
        string phone;
        string country;
        string street_address;
        uint256 last_activity;
        string others;
    }

    struct Asset {
        uint256 id;
        string title;
        string asset;
    }

    struct Contact {
        uint256 id;
        string name;
        string email;
        string phone;
        string country;
        string relationship;
    }

    struct NextOfKin {
        uint256 id;
        string name;
        string email;
        string phone;
        string country;
        string relationship;
    }

    struct OTP {
        string email_otp;
        string phone_otp;
    }

    struct FoundUser {
        string fullname;
        string phone;
        string email;
        address wallet_addr;
    }

    struct RecoveryRequest{
        string requester_name;
        string requester_country;
        string requester_phone;
        string requester_email;
        string relationship;
        string reason;
        string account_token;
        address account_address;
        uint16 num_of_contacts;
        uint16 num_of_validators;
        uint256 request_date;
    }

    struct Report {
        address reporter;
        uint256 contact_index;
        string comment;
        REPORT_TYPE report_type; 

    }
    
     struct IsValidating{
        string account_token;
        uint256 index;
        bool status;
    }

    enum RECOVERY_TYPE {
        OTP,
        VALIDATION
    }

    enum REPORT_TYPE{
        NULL,
        APPROVED,
        REJECTED

    } 

    enum SEARCH_TYPE {
        ACCOUNT_TOKEN,
        EMAIL,
        PHONE_NUMBER
    }

    enum USER_ROLES {
        NONE,
        SUPER_ADMIN,
        ADMIN,
        USER,
        VALIDATOR
    }

}
