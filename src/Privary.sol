// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {
    bool public locked = true;
    uint256 public ID = block.timestamp;
    uint8 private flattening = 10;
    uint8 private denomination = 255;
    uint16 private awkwardness = uint16(block.timestamp);
    bytes32[3] private data;

    constructor(bytes32[3] memory _data) {
        data = _data;
    }

    function unlock(bytes16 _key) public {
        require(_key == bytes16(data[2]));
        locked = false;
    }

    /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
    */
}

/*
The creator of this contract was careful enough to protect the sensitive areas of its storage.

Unlock this contract to beat the level.

Things that might help:

Understanding how storage works
Understanding how parameter parsing works
Understanding how casting works
Tips:

Remember that metamask is just a commodity. Use another tool if it is presenting problems. 
Advanced gameplay could involve using remix, or your own web3 provider.


@Hack:
contract.address
'0x1026e6Aff0c39b795d1d6b912250BCD06Dc67737'
await contract.locked()
true
await web3.eth.getStorageAt(contract.address, 5);
'0xe36da69c131c7cd82bb7608faa62a7c04d311c3f3e096f6a15ee624b3f485f5b'
b32 = 0xe36da69c131c7cd82bb7608faa62a7c04d311c3f3e096f6a15ee624b3f485f5b
1.0286875285612022e+77
const b32 = "0xe36da69c131c7cd82bb7608faa62a7c04d311c3f3e096f6a15ee624b3f485f5b"
undefined
b32.length
66
const b16 = b32.slice(0,34)
undefined
b16
'0xe36da69c131c7cd82bb7608faa62a7c0'
await contract.unlock("0xe36da69c131c7cd82bb7608faa62a7c0")
 */
