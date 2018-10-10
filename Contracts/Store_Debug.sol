pragma solidity ^0.4.24;

interface WarehouseI {
    function setDeliveryAddress(string where) external;
    function ship(uint id, address customer) external returns (bool handled);
}

contract Store {
    address wallet;
    WarehouseI warehouse;

    event LogShipped(uint id, string where, address customer);
    
    constructor(address _wallet, address _warehouse) public {
        wallet = _wallet;
        warehouse = WarehouseI(_warehouse);
    }

    function purchase(uint id, string where) public payable returns (bool success) {
        require(wallet.send(msg.value),'failed to send funds');
        warehouse.setDeliveryAddress(where);
        return warehouse.ship(id, msg.sender);
        emit LogShipped(id, where, msg.sender);
    }
}
