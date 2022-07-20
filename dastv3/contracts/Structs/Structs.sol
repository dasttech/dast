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

    struct foundUser {
        string fullname;
        string phone;
        string email;
        address wallet_addr;
    }

    enum RECOVERY_TYPE {
        OTP,
        VALIDATION
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
