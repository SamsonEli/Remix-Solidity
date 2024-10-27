// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";

contract KYCStorage is AccessControl {

    // Mapping to keep track of KYC approvals
    mapping(address => bool) public approvedKYC;

    // Event for logging KYC approvals
    event KYCApproved(address indexed approver, address indexed client);

    // Constructor to set up the admin role
    // constructor(address admin) {
    //     _grantRole(DEFAULT_ADMIN_ROLE, admin);
    // }
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


// add array for all role-based participants



// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/access/AccessControl.sol";

// contract KYCContract is AccessControl {
//     bytes32 public constant KYC_APPROVER_ROLE = keccak256("KYC_APPROVER");
//     bytes32 public constant KYC_APPROVED_ROLE = keccak256("KYC_APPROVED");

//     // Event for logging KYC approvals
//     event KYCApproved(address indexed approver, address indexed client);

//     // Constructor to set up the admin role
//     constructor() {
//         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
//         _setupRole(KYC_APPROVER_ROLE, msg.sender); // Admin also has approver role
//     }

//     // Function to approve KYC for a user
//     function approveKYC(address client) public onlyRole(KYC_APPROVER_ROLE) {
//         grantRole(KYC_APPROVED_ROLE, client);
//         emit KYCApproved(msg.sender, client); // Log the KYC approval
//     }

//     // Function to revoke KYC approval for a user
//     function revokeKYC(address client) public onlyRole(KYC_APPROVER_ROLE) {
//         revokeRole(KYC_APPROVED_ROLE, client);
//     }

//     // Restricted function that only KYC-approved users can call
//     function restrictedFunction() public view onlyRole(KYC_APPROVED_ROLE) returns (string memory) {
//         return "Access granted: You have passed KYC";
//     }

//     // Function to check if a user is KYC-approved
//     function isKYCApproved(address client) public view returns (bool) {
//         return hasRole(KYC_APPROVED_ROLE, client);
//     }
// }
