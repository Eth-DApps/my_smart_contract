// SPDX-License-Identifier: MIT
pragma solidity >=0.4.18 <0.9.0;
import "../node_modules/openzeppelin-solidity/";
import "../node_modules/openzeppelin-solidity/contracts/access/Ownable.sol";

abstract contract ERC20 {

  mapping(address => uint256) balances;
  uint256 totalSupply_;

  function totalSupply() public view returns (uint256);
  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns(bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);
  event Approval(address indexed owner, address indexed spender, uint256 value);

}

contract TNSToken is Ownable {
  
  mapping (address => mapping (address => uint256)) internal allowed;
  mapping (address => uint256) locked;
  
  // learning on this one
  constructor(string memory _name, string memory _symbol, uint8 _decimal, uint256 _totalSupply) public {
    name = _name;
    symbol = _symbol;
    decimals = decimals;
    totalSupply_ = _totalSupply;
    balances[msg.sender] = totalSupply_;
  }
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spener, uint256 value);
  event Locked(address indexed owner, uint256 indexed amount);

  string public name;
  string public symbol;
  uint8 public decimals;


  function totalSupply() public view returns (uint256){
    return totalSupply_;
  }
  function balanceOf(address _owner) public view returns (uint256){
    return balances[_owner];
  }
  function transfer(address _to, uint256 _value) public returns (bool){
    require(_to != address(0));
    require(_value <= balances[msg.sender] - locked[msg.sender]);

    balances[msg.sender] = balances[msg.sender] - _value;
    balances[_to] = balances[_to] + _value;
    emit Transfer(msg.sender, _to, _value);
    return true;
  }
  function transferFrom(address _from,address _to, uint256 _value) public returns (bool){
    require(_to != address(0));
    require(_value <= balances[_from] - locked[_from]);
    require(_value <= allowed[_from][msg.sender][mg.sender] - locked[_from]);

    balances[msg.sender] = balances[msg.sender] - _value;
    balances[_to] = balances[_to] + _value;
    allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
    // Emit Event
    emit Transfer(_from, _to, _value);
    return true;
  }

  // To Check How Much User Can Spend From Another User's Account.
  function allowance(address _owner, address _spender) public view returns (uint256){
    return allowed[_owner][_spender];
  }
  function  approve(address _spender, uint256 _value) public returns (bool){
    allowed[msg.sender][_spender] = _value;
    // Emit Event Of Approve
    emit Approval(msg.sender, _spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public returns (bool){
    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender]) + _addedValue;
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint _addedValue) public returns (bool){
    allowed[msg.sender][_spender] = (allowed[msg.sender][_spender]) - _addedValue;
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
    return true;
  }

  function increaseLockedAmount(address _owner, uint256 _amount ) onlyOwner public returns (uint256) {
    uint256 lockingAmount = locked[_owner] + _amount;
    require(balanceOf(_owner) >= lockingAmount, "Locing amount must not exceed balance");
    locked[_owner] = lockingAmount;
    emit Locked(_owner, lockingAmount);
    return LockingAmount;
  }
  
  function decreaseLockedAmount(address _owner, uint256 _amount) onlyOwner public returns (uint256) {
    uint256 amt = _amount;
    require(balanceOf(_owner) > 0, "Cannot go negative. Already at 0 locked tokens.");
    if (amt > locked[_owner]){
      amt = locked[_owner];
    }
    
    uint256 lockingAmount = locked[_owner] - amt;
    locked[_owner] = lockingAmount;
    emit Locked(_owner, lockingAmount);
    return LockingAmount;
  }
  
  function getLockedAmount(address _owner) view public returns (uint256){
    return locked[_owner];
  }
  
  function getUnLockedAmount(address _owner) view public returns (uint256){
    return balances[_owner] - locked[_owner];
  }
}

contract StoryDAO is Ownable {

}
