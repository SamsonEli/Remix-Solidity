pragma solidity ^0.8.28;
// SPDX-License-Identifier: MIT

contract Compliance{

    struct ComplianceRecord {
        uint256 timestamp;
        bool isCompliant;
        string additionalNotes;
        bool furtherAction; 
    }

    mapping(address => ComplianceRecord) public complianceRecords;

    function recordCompliance(address user, bool isCompliant, string memory additionalNotes, bool furtherAction) public {
        complianceRecords[user] = ComplianceRecord({
            timestamp: block.timestamp,
            isCompliant: isCompliant,
            additionalNotes: additionalNotes,
            furtherAction: furtherAction
        });
    }

    function updateCompliance(address user, bool isCompliant, string memory additionalNotes, bool furtherAction) public {
        require(complianceRecords[user].timestamp != 0, "Record does not exist");

        complianceRecords[user] = ComplianceRecord({
            timestamp: block.timestamp,
            isCompliant: isCompliant,
            additionalNotes: additionalNotes,
            furtherAction: furtherAction
        });
    }

    function isUserCompliant(address user) public view returns (bool) {
        return complianceRecords[user].isCompliant;
    }


}