// SPDX-License-Identifier: MIT
pragma solidity >=0.7.3;
import "../Structs/Structs.sol";
import "../Auth/Auth.sol";
import "../Users/Users.sol";

contract Recovery {

    using Structs for *;
    using Utils for *;
    
    Auth auth;
    Users user;

    // Recovery request
    mapping(string => Structs.RecoveryRequest) recoveryRequest;
    // requester: address =>account_token;
    mapping(address=>string) requester;
    // Pending request token
    string[] RequestTokens;
    // token=>Validators
    mapping(string=>address[])  validators;
    // is Validating
    // address => Structs.IsValidating
    mapping(address=>Structs.IsValidating) currentlyValidating;
    // recovery Report
    // token=>Structs.Report
    mapping(string=>Structs.Report[]) validationReport;

    constructor(Auth _auth, Users _user){
        auth = Auth(_auth);
        user = Users(_user);
    }

    modifier hasRole(
        string memory role
            ){
                
        require(user.hasRole(keccak256(abi.encodePacked(role)), msg.sender), 
        "You dont have the permission");
        _;
    }

    modifier platformCheck(string memory platform_token){
        require(auth.platformCheck(platform_token), "Invalid access token");
        _;
    }

    function saveRequest(
        string memory platform_token,
        Structs.RecoveryRequest memory recovery_request
        ) 
        public
        platformCheck(platform_token)
        {
            recoveryRequest[recovery_request.account_token] = recovery_request;
            RequestTokens.push(recovery_request.account_token);
            requester[msg.sender] = recovery_request.account_token;
        }

    function fetchRequests(
        string memory platform_token
        ) 
        public
        view
        platformCheck(platform_token)
        hasRole("VALIDATOR")
        returns (Structs.RecoveryRequest[] memory)
        {
            Structs.RecoveryRequest[] memory requests = new Structs.RecoveryRequest[](RequestTokens.length);
            
            for (uint256 i = 0; i < RequestTokens.length; i++){
                requests[i] = recoveryRequest[RequestTokens[i]];
            }
            return requests;
        }

    
    function acceptValidation(
        string memory platform_token,
        string memory account_token,
        uint16 numberOfContacts,
        Structs.IsValidating memory is_validaing
        )
        public
        platformCheck(platform_token)
        hasRole("VALIDATOR")
        returns(bool)
        {
            require(!currentlyValidating[msg.sender].status, "You have unfinish task");
            require(validators[account_token].length < numberOfContacts,"Not available");
            for (uint256 i = 0; i < validators[account_token].length; i++){
                if(
                   validators[account_token][i]==msg.sender
                ){
                    revert("You cannot validate more than one contact from this request");
                }
            }

            currentlyValidating[tx.origin] = is_validaing;
            validators[account_token].push(msg.sender);
            return true;

        }


function saveReport(
        string memory platform_token,
        string memory account_token,
        Structs.Report memory report
        )
        public
        platformCheck(platform_token)
        hasRole("VALIDATOR")
        returns(bool)
        {
            validationReport[account_token].push(report);
            delete currentlyValidating[msg.sender];
            return true;
        }

function requestStatus(
        string memory platform_token
        )
        public
        view
        platformCheck(platform_token)
        returns (
            Structs.RecoveryRequest memory,
            Structs.Report[] memory
        )
        {
            return(recoveryRequest[requester[msg.sender]],validationReport[requester[msg.sender]]);
        }

    function recoverAccount(
        string memory platform_token,
        address old_wallet_addr
        )
        public
        platformCheck(platform_token)
        returns (bool){
            require(
                bytes(requester[msg.sender]).length>2,
                "No asset to recovery"
            );

        uint256 numberOfApprovals;

        for (uint16 i = 0; i <  validationReport[requester[msg.sender]].length; i++){
            if(validationReport[requester[msg.sender]][i].report_type==Structs.REPORT_TYPE.APPROVED){
                numberOfApprovals++;
            }
        }

        if(!auth.percentangeCheck(Utils.checkPercent(recoveryRequest[requester[msg.sender]].num_of_contacts,numberOfApprovals))){
            revert("Recovery request rejected");
        }

        return user.recoverAccountByNextOfKin(platform_token,old_wallet_addr);

        }

}

