pragma solidity ^0.4.24;

contract PiggyBank {
    address owner;
    uint balance;
    bytes32 hashedPassword;

    modifier IsOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor(bytes32 _hashedPassword) public payable {
        owner = msg.sender;
        balance += uint(msg.value);
        hashedPassword = _hashedPassword;
    }

    function AddFunds() public payable IsOwner {
        balance += uint(msg.value);
    }
    
    function WithdrawFunds() public IsOwner {
        owner.transfer(balance);
    }

    function kill(bytes32 password) public IsOwner {
        require(keccak256(abi.encodePacked(owner, password)) == hashedPassword);
        selfdestruct(owner);
    }
}
