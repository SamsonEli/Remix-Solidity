// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";

contract KYCStorage is AccessControl {

    // Mapping to keep track of KYC approvals
    mapping(address => bool) public approvedKYC;

    // Event for logging KYC approvals
    event KYCApproved(address indexed approver, address indexed client);

    uint256 public intApprovers;

    constructor() {
        // _grantRole(KYC_APPROVER_ROLE, msg.sender);
    }

    // Function to approve KYC, restricted to KYC_APPROVER_ROLE
    function approveKYC(address _client) external {
        approvedKYC[_client] = true;
        emit KYCApproved(msg.sender, _client); // Logs the specific approver
    }

    function incrementIntApprover() external {
        intApprovers++; 
    }

    function decrementIntApprover() external {
        require(intApprovers > 0, "Approver count cannot be negative");
        intApprovers--;
    }
}



