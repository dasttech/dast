// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "./dast.sol";

import './safemath.sol';


contract DASTSale {
    address payable admin;
    DAST tokenContract;
    uint256 tokensSold;
    uint256 airDropQty;
    uint256 bonusQty;
    uint256 dollarRate;
    mapping(address =>uint256) public airdropBalance;
    mapping(address =>uint256) public icoBalance;
    mapping(address =>string) public myReferral;
    

     event Sell(address _buyer, uint256 _amount);
     event Received(address sender, uint256 value);
     
     
     constructor(DAST _tokenContract, uint256 airDropQ, uint256 rate) payable {
        admin = payable(msg.sender);
        tokenContract = _tokenContract;
        airDropQty = SafeMath.mul(airDropQ,1e18);
        bonusQty = SafeMath.div(airDropQty,2);
        dollarRate = rate;
        
    }


    function setDollarRate(uint256 rate) public returns(uint256){
        require(msg.sender==admin);
        dollarRate = rate;
        return dollarRate;
    }
    
    function setAirdrop(uint256 qty) public returns(uint256){
        require(msg.sender==admin);
        airDropQty = qty;
        return airDropQty;
    }
    
    function setBonusQty(uint256 qty) public returns(uint256){
        require(msg.sender==admin);
        bonusQty = qty;
        return bonusQty;
    }
    
    function _getTokenAmount(uint256 value) private view  returns (uint256){
        uint256 amount = SafeMath.mul(SafeMath.div(SafeMath.div(SafeMath.mul(dollarRate,value),1e18)*10,5),1e18);
        return amount;
    }
    
    function fetchRate() public view  returns(uint256){
        return dollarRate;
    }
    
    //bnbamount = amount of bnb sent in wei
    function buyTokens(uint256 bnbAmount) public payable returns(bool)  {
        require(msg.value >= bnbAmount);
        require(icoBalance[msg.sender]<4000,"You have exceeded max ICO");
        //  uint256 tokenAmount = (SafeMath.div(SafeMath.div((bnbAmount*dollarRate),1e18)*10000,5)*1e18);
        uint256 tokenAmount = _getTokenAmount(bnbAmount);
         
        require(tokenContract.balanceOf(address(this)) >= tokenAmount);
        require(tokenContract.transfer(msg.sender, tokenAmount));
        
        icoBalance[msg.sender]+=tokenAmount;
        
        tokensSold += tokenAmount;

        emit Sell(msg.sender, tokenAmount);
        
        return true;
    }

    //bnbprice =  value of 0.23 dollar
    function claimAirdrop(uint256 bnbPrice) public payable returns(bool) {
        require(airdropBalance[msg.sender]<airDropQty,"You have claimed airdrop");
        require(msg.value >= bnbPrice,"Insufficient Balance");
        require(tokenContract.balanceOf(address(this)) >= airDropQty);
        require(tokenContract.transfer(msg.sender, airDropQty));
        
        airdropBalance[msg.sender]+=airDropQty;
        
        tokensSold += airDropQty;
        return true;
    }
    
    // bnbPrice value of 0.23 dollars and qty  = how many bonus he want to claim
     function claimBonus(uint256 bnbPrice,uint256 qty, string memory ids) public payable returns(bool) {
        require(msg.value >= bnbPrice*qty);
        uint256 tokenAmount = bonusQty*qty;
        require(tokenContract.balanceOf(address(this)) >= tokenAmount);
        require(tokenContract.transfer(msg.sender, tokenAmount));
        tokensSold += tokenAmount;
        myReferral[msg.sender] = string(abi.encodePacked(myReferral[msg.sender],"-",ids));
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


