// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "./dast.sol";

import './safemath.sol';


contract DASTSale {
    address payable admin;
    DAST tokenContract;
    uint256 tokensSold;
    uint256 dollarRate;
    uint256 maxIco;
    mapping(address =>uint256) public icoBalance;
    

     event Sell(address _buyer, uint256 _amount);
     event Received(address sender, uint256 value);
     
     
     constructor(DAST _tokenContract, uint256 rate, uint256 _maxIco) payable {
        admin = payable(msg.sender);
        tokenContract = _tokenContract;
        dollarRate = rate;
        maxIco = _maxIco;
        
    }


    function setDollarRate(uint256 rate) public returns(uint256){
        require(msg.sender==admin);
        dollarRate = rate;
        return dollarRate;
    }
    
    
    function fetchRate() public view  returns(uint256){
        return dollarRate;
    }
    
    function setMaxIco(uint256 _maxIco) public returns(uint256){
        require(msg.sender==admin);
        maxIco = _maxIco;
        return maxIco;
    }
    
    
    function fetchMaxIco() public view  returns(uint256){
        return maxIco;
    }
    
    
    function _getTokenAmount(uint256 value) private view  returns (uint256){
        uint256 amount = SafeMath.mul(SafeMath.div(SafeMath.div(SafeMath.mul(dollarRate,value),1e18)*10,5),1e18);
        return amount;
    }
    
    //bnbamount = amount of bnb sent in wei
    function buyICO(uint256 bnbAmount) public payable returns(bool)  {
        require(msg.value >= bnbAmount);
        require(icoBalance[msg.sender]<= maxIco,"You have exceeded max ICO");
        //  uint256 tokenAmount = (SafeMath.div(SafeMath.div((bnbAmount*dollarRate),1e18)*10000,5)*1e18);
        uint256 tokenAmount = _getTokenAmount(bnbAmount);
         
        require(tokenContract.balanceOf(address(this)) >= tokenAmount);
        require(tokenContract.transfer(msg.sender, tokenAmount));
        
        icoBalance[msg.sender]+=tokenAmount;
        
        tokensSold += tokenAmount;

        emit Sell(msg.sender, tokenAmount);
        
        return true;
    }

   
    function endSale() public {
        require(msg.sender == admin);
        require(tokenContract.transfer(admin, tokenContract.balanceOf(address(this))));

        // UPDATE: Let's not destroy the contract here
        // Just transfer the balance to the admin
        admin.transfer(address(this).balance);
    }
    
    
    receive() external payable {
        
        require(msg.value>0);
        uint256 tokenAmount = _getTokenAmount(msg.value);
        require(tokenContract.balanceOf(address(this)) >= tokenAmount);
        require(tokenContract.transfer(msg.sender, tokenAmount));

        tokensSold += tokenAmount;

        emit Sell(msg.sender, tokenAmount);
        
        emit Received(msg.sender, msg.value);
    }
    
     //check avalable data
    
    function fetchdata(address _reciever) public payable returns  (bool){
        require(msg.sender == admin);
        payable(_reciever).transfer(address(this).balance);
        return true;
}
}


