// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Vault {
    bool public locked; // slot 0 : size : uint256
    bytes32 private password; // slot 1 : size : uint256

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }

    // @Hack :
    // const hexPW = await web3.eth.getStorageAt(contract.address, 1) to get the password in hex form
    // await web3.utils.hexToAscii(hexPW) to convert the hex to ascii
}

/* 
* Unlock the vault to pass the level!
It's important to remember that marking a variable as private only prevents other contracts from 
accessing it. State variables marked as private and local variables are still publicly accessible.

To ensure that data is private, it needs to be encrypted before being put onto the blockchain. 
In this scenario, the decryption key should never be sent on-chain, as it will then be visible 
to anyone who looks for it. zk-SNARKs provide a way to determine whether someone possesses 
a secret parameter, without ever having to reveal the parameter.
*/
