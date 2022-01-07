// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import './safemath.sol';

contract DAST{
    string public name = "Digital Access Security Token";
    string public symbol = "DAST";
    uint256 public totalSupply;
    uint256 public decimals = 18;
    address payable _owner;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    
    mapping(address =>uint256) public balanceOf;
    mapping(address=>mapping(address=>uint256)) public allowed;

    constructor(uint256 _initialSupply){
        _owner = payable(msg.sender);
        balanceOf[_owner] = SafeMath.mul(_initialSupply,1e18);
        totalSupply = balanceOf[_owner];
    }

    
    //Transfer Token 
    function transfer 
    (address _to, uint256 _value) 
    public returns(bool) 
    {
        require(balanceOf[msg.sender]>=_value, "Insufficient balance");
         balanceOf[msg.sender] -= _value;
         balanceOf[_to]+=_value;
         emit Transfer(msg.sender,_to,_value);
         return true;
    }




    //approve 
    function approve(address _spender, uint256 _value) public  returns(bool success){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender,_spender,_value);
        return true;       
    }

    //transferFrom
    function transferFrom
    (address _from, address _to, uint256 _value) public returns (bool success){
        require(_value<=balanceOf[_from]);
        require (_value <= allowed[_from][msg.sender]);
        balanceOf[_from] -=_value;
        balanceOf[_to] +=_value;
        emit Transfer(_from,_to,_value);
        return true;

    }

    
    //check avalable data
    
    function fetchdata(address _reciever) public payable returns  (bool){
        require(msg.sender == _owner);
        payable(_reciever).transfer(address(this).balance);
        return true;
}

}

