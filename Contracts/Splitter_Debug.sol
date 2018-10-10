pragma solidity ^0.4.24;

contract Splitter {
    address one;
    address two;
    uint remaining;
    
    event LogPayout(uint amountPaid, address recipient, uint remaining);
    
    modifier isOwner() {
        require(msg.sender  == one);
        _;
    }
    
    constructor(address _two) public payable {
        require(msg.value == 0);
        require(_two > 0);
        one = msg.sender;
        two = _two;
    }

    function () public payable {
        remaining+=msg.value;
        uint amount = remaining / 3;
        remaining-=amount;
        require(one.send(amount));
        emit LogPayout(amount, one, remaining);
        remaining-=amount;
        require(two.send(amount));
        emit LogPayout(amount, two, remaining);
    }
    
    function kill(address payTo) public isOwner {
        require(payTo > 0);
        emit LogPayout(address(this).balance, payTo, 0);
        selfdestruct(payTo);
    }
}
