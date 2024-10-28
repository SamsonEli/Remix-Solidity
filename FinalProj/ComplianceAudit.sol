// audit smart contract -> SC
//fill out questionaire 

//compliance -> SC
//financial product
//questionaire and auditting 

pragma solidity ^0.8.28;
// SPDX-License-Identifier: MIT

contract ComplainceAuditor {

    struct ComplianceRecord {
        uint256 timestamp;
        bool isCompliant;
        string additionalNotes;
        bool furtherAction; 
    }

    struct AuditRecord {
        uint256 timestamp;
        string financialAudit; 
        string securityAudit;
        string auditor; 
    }

    address[] public whitelistAddresses;
    address[] public blacklistAddresses;
    address[] public suspiciousAddresses;

    AuditRecord[] public auditRecords; 

    mapping(address => ComplianceRecord) public complianceRecords;


    // function addUserBlacklist {

    // }

    // function addUserWhitelist {

    // }

    // function recordAuditRecord {   //quarterly

    // }

    // function retrieveLatestAudit public view return AuditRecord {

    // }

    // function recordComplianceRecord {   //quarterly

    // }



}