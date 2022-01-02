// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CrowdFunding {
  bool public isOpen;
  address payable public owner;
  uint public goal;
  uint public totalFunded;
  uint public funds;

  constructor() {
    isOpen = true;
    goal = 1000000;
    totalFunded = 0;
    owner = payable(msg.sender);
  }

  function fundProject() public payable {
    owner.transfer(msg.value);
    funds += msg.value;
  }

  function changeProjectState(bool value) public {
    isOpen = value;
  }

}