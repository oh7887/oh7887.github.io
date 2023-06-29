//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol";
interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract ERC20 is IERC20 {

    string public constant name = "CNY";
    string public constant symbol = unicode"￥";
    uint8 public constant decimals = 18;
    mapping(address => uint256) balances;
    address public owner;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_ = 10 ether;

   constructor(uint256 i){
    balances[msg.sender] = i;
    owner=msg.sender;
    }

    function totalSupply() public override view returns (uint256) {
    return totalSupply_;
    }
    function earn(uint256 i) public 
    {
        require(msg.sender==owner,"you can not do it");
        balances[owner]+=i;
    }
    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender]-numTokens;
        balances[receiver] = balances[receiver]+numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
contract MultiSigWallet {

    event SubmitTransaction(
        address indexed owner,
        address indexed to,
        uint value,
        uint txIndex,
        bytes data            
    );

    event ConfirmTransaction(address indexed owner,uint txIndex);
    event RevokeTransaction(address indexed owner,uint txIndex);
    event ExecuteTransaction(address indexed owner,uint txIndex);
    event Deposit(address indexed sender, uint amount, uint balance);

    address public deployer;
    address [] public owners;
    mapping (address => bool) public isOwner;
    uint public required;
    ERC20 erc20;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
        uint256 reason;//0:earn
        //1:speand;
    }

    Transaction [] public transactions;
    mapping (uint => mapping (address => bool) ) isConfirmed;

    modifier onlyOwner() {
        require(isOwner[msg.sender],"not owner");
        _;
    }
    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "tx does not exist");
        _;
    }

    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed,"tx already executed");
        _;
    }

    modifier notConfirmed(uint _txIndex) {
        require(!isConfirmed[_txIndex][msg.sender],"tx already confirmed");
        _;
    }
    
    constructor(address [] memory _owners,uint _required,uint256 budget) {
        require(_owners.length>0,"owners required");
        require(_required>0 && _required<_owners.length,"invalid number of required confirmations");
        
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner!=address(0),"invalid owner");
            //require(!isOwner[owner],"owner not unique");

            isOwner[owner]=true;
            owners.push(owner);
        }
        required=_required;
        deployer=msg.sender;
        erc20=new ERC20(budget); 
    }

    receive() external payable{
        emit Deposit(msg.sender,msg.value,address(this).balance);        
    }

    function submitTransaction(
        address _to,
        uint _value,
        bytes memory _data,
        uint256 i
    ) external payable onlyOwner{
        uint txIndex = transactions.length;

        transactions.push(
            Transaction({
                to:_to,
                value: _value,
                data: _data, 
                executed: false, 
                numConfirmations:0,
                reason:i
            })
        );
        
        emit SubmitTransaction(msg.sender,_to,_value,txIndex,_data);
        
    }


    function confirmTransaction(
          uint _txIndex
        ) public onlyOwner txExists(_txIndex) notExecuted( _txIndex) notConfirmed( _txIndex) {
            Transaction storage transaction = transactions[_txIndex];
            transaction.numConfirmations+=1;
            isConfirmed[_txIndex][msg.sender]=true;

            emit ConfirmTransaction(msg.sender, _txIndex);

        }

    function executeTransaction(
            uint _txIndex
        ) external onlyOwner txExists(_txIndex) notExecuted( _txIndex)  {
            Transaction storage transaction = transactions[_txIndex];
 
            require(transaction.numConfirmations >= required,"cannot execute tx");

            transaction.executed=true;
            
            emit ExecuteTransaction(msg.sender, _txIndex);
    }

    function revokeTransaction(
        uint _txIndex
        ) external onlyOwner txExists(_txIndex) notExecuted( _txIndex)  {
            Transaction storage transaction = transactions[_txIndex];

            require(isConfirmed[_txIndex][msg.sender],"tx not confirmed");

            transaction.numConfirmations-=1;
            isConfirmed[_txIndex][msg.sender]=false;

            emit RevokeTransaction(msg.sender, _txIndex);

        }

    function getOwners() external view returns(address [] memory){
        return owners;
    }

    function getTransactionCount() external view returns (uint) {
        return transactions.length;
    }

    function getTransaction(
        uint _txIndex
        ) external view returns(
            address to,
            uint value,
            bytes memory data,
            bool executed,
            uint numConfirmations
    ){

        Transaction storage transaction = transactions[_txIndex];

        return(
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations

        );
    }

    function getBalance(address _address) external view returns(uint256){
        return address(_address).balance;
    }
    function spendMoney(uint256 i)public returns(uint256)
     {
        require(transactions[i].executed,"your transaction has been not passed now");
        require(transactions[i].reason==1,"your transaction is wrong");
       erc20.transfer(transactions[i].to,transactions[i].value);
       transactions[i].executed=false;
    return erc20.balanceOf(address(this));
     }
    function earnmoney(uint256 i)public returns(uint256)
    {
        require(transactions[i].executed,"your transaction has been not passed now");
         require(transactions[i].reason==0,"your transaction is wrong");
        erc20.earn(transactions[i].value);
        transactions[i].executed=false;
        return erc20.balanceOf(address(this));
    }
}
contract holdMoney
{
    address public owner;
    address[] public PoweFulMan;
    uint256 public Budget;
    uint256 public number=1;
     MultiSigWallet public multisigwallet;
constructor(uint256 budget) public
    {
        Budget=budget;
        PoweFulMan.push(msg.sender);
        owner=msg.sender;
    }
    
   modifier checkRight
   {
       require(owner == msg.sender,"you are not the owner");
       _;
   }
        function addPoweFulMan(address p) public checkRight
    {
        PoweFulMan.push(p);
        number++;
    }
    function deletePoweFulMan(uint256 who) public checkRight
    {
        require(who!=0,"you can not delete it");
        require(who<=number,"number of the 'who' is too big");
        if(who==number)
        {
            number--;
        }
        else if(who<number)
        {
            for(uint i=who;i<number;i++)
            {
                PoweFulMan[i]= PoweFulMan[i+1];
            }
            number--;
        }
    }
     function creat() public
     {
        multisigwallet = new MultiSigWallet(PoweFulMan,3,Budget);
     }
}
