pragma solidity ^0.8.28;
// SPDX-License-Identifier: MIT

contract Audit{

    struct AuditRecord {
        uint256 timestamp;
        string financialAudit; 
        string securityAudit;
        string additionalNotes; 
        string auditor;
        uint256 auditor_id;  
    }

    AuditRecord[] public auditRecords; 

    // include any necessary functions for the audit here


    function addAuditRecord(
        string memory financialAudit,
        string memory securityAudit,
        string memory additionalNotes,
        string memory auditor,
        uint256 auditor_id
    ) public {
        AuditRecord memory newRecord = AuditRecord({
            timestamp: block.timestamp,
            financialAudit: financialAudit,
            securityAudit: securityAudit,
            additionalNotes: additionalNotes,
            auditor: auditor,
            auditor_id: auditor_id
        });
        
        auditRecords.push(newRecord);
    }
    
    function getAuditRecord(uint256 index) public view returns (uint256, string memory, string memory, string memory) 
    {
        require(index < auditRecords.length, "Audit record does not exist");

        AuditRecord memory record = auditRecords[index];
        return (
            record.timestamp,
            record.financialAudit,
            record.securityAudit,
            record.auditor
        );
    }

    function getAuditRecordCount() public view returns (uint256) {
        return auditRecords.length;
    }

    function getLatestAuditRecord() public view returns (uint256, string memory, string memory, string memory) {
        require(auditRecords.length > 0, "No audit records available");

        AuditRecord memory latestRecord = auditRecords[auditRecords.length - 1];
        
        return (
            latestRecord.timestamp,
            latestRecord.financialAudit,
            latestRecord.securityAudit,
            latestRecord.auditor
        );
    }






}