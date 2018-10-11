//B9lab Ethereum Developer Course
//Debug Exercises
//Ex1 - PiggyBank
//Toby Wise - 11.Oct.18

pragma solidity ^0.4.21;

contract PiggyBank {
    address owner;
    uint balance;
    bytes32 hashedPassword;

    event LogHash(bytes32 pwd);
    
    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }
    
    constructor(bytes32 _hashedPassword) public payable {
        owner = msg.sender;
        balance += uint(msg.value);
        hashedPassword = _hashedPassword;
    }

    function () public payable isOwner {
        assert(balance + msg.value >= balance);
        balance += msg.value;
    }

    function kill(bytes32 password) public {
        //Event added for testing to confirm required _hashedPassword
        emit LogHash(keccak256(abi.encodePacked(owner, password)));
        require (keccak256(abi.encodePacked(owner, password)) == hashedPassword);
        selfdestruct(owner);
    }
}
