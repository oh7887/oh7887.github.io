// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract GuessTheSecretNumberChallenge {
    bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;

    function guessTheSecretNumberChallenge() public payable {
        require(msg.value == 1 ether);
    }
    
    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable {
        require(msg.value == 1 ether);

        if (keccak256(n) == answerHash) {
            msg.sender.transfer(2 ether);
        }
    }
}//uint8 只有255 所以直接爆破 boom~~~
contract attack
{
  bytes32 answerHash = 0xdb81b4d58595fbbbb592d3661a34cdca14d7ab379441400cbfa1b78bc447c365;
  function att() public returns(uint8)
  {
    for(uint8 i=0;i<255;i++)
    {
      if(keccak256(i) == answerHash)
      {
        return i;
      }
    }
  }
  fallback()  external payable{}
}
