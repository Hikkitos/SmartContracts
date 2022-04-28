// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract MopedShop {
    mapping (address => bool) buyers;
    uint public price = 2 ether;
    address public owner;
    address public shopAddress;
    bool fullyPaid;

event ItemFullyPaid(uint _price, address _shopAddress);

    constructor() {
        owner = msg.sender;
        shopAddress = address(this);
    }
    function getBuyer(address _addr) public view returns(bool) {
        require(owner == msg.sender, "You are not an owner");

        return buyers[_addr];
    }

    function addBuyer (address _addr) public {
        require(owner == msg.sender, "You are not an owner");
        buyers[_addr] = true;
    }

    function getBalance() public view returns(uint) {
        return shopAddress.balance;
    }

    function withdrawAll() public {
        require(owner == msg.sender && fullyPaid && shopAddress.balance > 0, "Rejected2");

        address payable receiver = payable(msg.sender);

        receiver.transfer(shopAddress.balance);
    }


    receive() external payable {
        require(buyers[msg.sender] && msg.value <= price && !fullyPaid, "Rejected");

            //0xD7ACd2a9FD159E69Bb102A1ca21C9a3e3A5F771B

        if(shopAddress.balance == price) {
            fullyPaid = true;
            emit ItemFullyPaid(price, shopAddress);
        }
    }
}
