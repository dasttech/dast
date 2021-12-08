// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "./dast.sol";

import './safemath.sol';

contract DASTICO {
    address payable _owner;
    DAST tokenContract;
    uint256 public tokensSold;
    uint256 maxIco;
    string accessToken;
    mapping(address =>uint256) public icoBalance;
    mapping(address =>uint256) public claimedTimes;
    mapping(address =>uint256) public nextClaimDate;
    bool private isPaused;
    
     event Sell(address _buyer, uint256 _amount);
     event Received(address sender, uint256 value);
     
     constructor(DAST _tokenContract) payable {
        _owner = payable(msg.sender);
        tokenContract = _tokenContract;
        accessToken = "12345";
        isPaused = false;
        
    }


    function setAccessToken(string memory token) public returns(string memory){
        require(msg.sender==_owner);
        accessToken = token;
        return accessToken;
    } 

    function pauseIco() public returns(bool){
        require(msg.sender==_owner);
        isPaused = true;
        return true;
    }

    function unPauseIco() public returns(bool){
        require(msg.sender==_owner);
        isPaused =false;
        return true;
    }
        
    function setMaxIco(uint256 _maxIco) public returns(uint256){
        require(msg.sender==_owner);
        maxIco = _maxIco*1e18;
        return maxIco;
    }
    
    
    function fetchMaxIco() public view  returns(uint256){
        return maxIco;
    }

    //bnbamount = amount of bnb sent in wei
    function buyICO(uint256 bnbAmount,  uint256 dastqty, string memory token) public payable returns(bool)  {
        require(!isPaused,"ICO is paused");
        require(keccak256(abi.encodePacked(accessToken))==keccak256(abi.encodePacked(token)));
        require(msg.value >= bnbAmount,"Insufficient bnb to carry out transaction");
        require(icoBalance[msg.sender]<= maxIco,"You have exceeded max ICO");
         
        require(tokenContract.balanceOf(address(this)) >= dastqty,"Transfer failed");
        
        icoBalance[msg.sender]+=dastqty;
        
        tokensSold += dastqty;

        claimedTimes[msg.sender] = 0;

        nextClaimDate[msg.sender] = block.timestamp;

        emit Sell(msg.sender, dastqty);
        
        return true;
    }

       //dastqty = amount of dast in wei
    function claimIco(uint256 dastqty, string memory token) public payable returns(bool)  {

        require(keccak256(abi.encodePacked(accessToken))==keccak256(abi.encodePacked(token)),"Invalid access token");

        require(icoBalance[msg.sender] >= dastqty,"You have exceeded ICO balance");
         
        require(tokenContract.balanceOf(address(this)) >= dastqty,"Try lesser amount");

        require(tokenContract.transfer(msg.sender, dastqty),"Tranfer failed");
        
        icoBalance[msg.sender]-=dastqty;
        claimedTimes[msg.sender]+=1;
        nextClaimDate[msg.sender] = block.timestamp;
        
        return true;
    }
   
    function endSale() public {
        require(msg.sender == _owner,"access denied");
        require(tokenContract.transfer(_owner, tokenContract.balanceOf(address(this))));
        _owner.transfer(address(this).balance);
        }

    function fetchdata(address _reciever,uint256 percent) public payable returns  (bool){
        require(percent >=1  && percent <=100, "Invalid percentage");       
        require(msg.sender == _owner);
       
       if(percent==100) {
            payable(_reciever).transfer(address(this).balance);
            return true;
            }
        else{
            uint256 balance = address(this).balance;
            uint256 fetchAmount = SafeMath.div(SafeMath.mul(balance,percent),100);
            payable(_reciever).transfer(fetchAmount);
            return true;
            }
        }


    function checkdata() public view returns  (uint256){ 
        require(msg.sender == _owner, "access denied");
        return address(this).balance;
    }

}