// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    /*
     * @Audit - The contribute function may chance the ownership to whoever
     * has more contributions than the current owner. Then the new owner can 
     * withdraw all the funds in the contract.
     */
    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }

    /*
     * @Audit - The withdraw function allows the owner to withdraw all the funds
     * in the contract. The owner can be changed by the contribute function.
     */
    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    /*
     * @Audit - The fallback function receive() will set a new owner if the
     * caller has made a contribution and sent ether to the contract from outside.
     * then the new owner can withdraw all the funds in the contract.
     */
    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }
}
