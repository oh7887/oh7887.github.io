pragma solidity ^0.4.21;

contract AssumeOwnershipChallenge {
    address owner;
    bool public isComplete;

    function AssumeOwmershipChallenge() public {
        owner = msg.sender;
    }

    function authenticate() public {
        require(msg.sender == owner);

        isComplete = true;
    }
}//我觉得没必要说明做法 看着就行了 
