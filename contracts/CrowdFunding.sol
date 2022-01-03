// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CrowdFunding {
  enum FundRaisingState { Closed, Opened }

  struct Contribution {
    address contributor;
    uint amount;
  }

  struct Project {
    uint id;
    FundRaisingState state;
    string name;
    string description;
    address payable owner;
    uint goal;
    uint totalFunded;
    uint funds;
  }

  Project[] public projects;
  mapping( uint => Contribution[]) public contributions;

  event Projectfunded(address editor, uint amount);
  event ProjectStateChanged(address editor, FundRaisingState newState);
  event ProjectCreated(uint id, string name, string description, uint goal);

  modifier onlyOwner(uint _id) {
      require(msg.sender == projects[_id].owner, 'Only owner can change the goal.');
      _;
  }

  modifier notOwner(uint _id) {
    require(msg.sender != projects[_id].owner, 'Owner cannot fund the project.');
    _;
  }

  function createProject(uint _id, string memory _name, string memory _description, uint _goal) public {
    require(_goal > 0, 'The fundraising goal must be larger than 0.');
    Project memory project = Project(_id, FundRaisingState.Opened, _name, _description, payable(msg.sender), _goal, 0, 0);
    projects.push(project);
    emit ProjectCreated(_id, _name, _description, _goal);
  }

  function fundProject(uint _id) public payable notOwner(_id) {
    require(projects[_id].state == FundRaisingState.Opened, 'The project is not open for funding');
    require(msg.value > 0, 'You cant contribute with 0 eth');
    projects[_id].owner.transfer(msg.value);
    projects[_id].funds += msg.value;

    contributions[_id].push(Contribution(msg.sender, msg.value));
    emit Projectfunded(msg.sender, msg.value);
  }

  function changeProjectState(FundRaisingState value, uint _id) public onlyOwner(_id) {
    require(value != projects[_id].state, 'You cannot change to the same state.');
    projects[_id].state = value;
    emit ProjectStateChanged(msg.sender, value);
  }

}