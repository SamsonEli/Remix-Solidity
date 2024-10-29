pragma solidity ^0.8.28;
// SPDX-License-Identifier: MIT


contract DisputeManagement {

    enum DisputeStatus {Filed, Ongoing, Resolved, Escalated}

    struct Dispute {
        uint256 disputeId;
        address client;
        uint256 productId;
        uint256 transactionId;
        string reason;
        string details; 
        DisputeStatus status;
        string response;  
        uint256 timestamp;
    }

    Dispute[] public disputes;
    mapping(address => uint256[]) public disputesByClient;

    event DisputeFiled(uint256 disputeId, address indexed client, uint256 transactionId, uint256 productId, string reason, uint256 timestamp);
    event DisputeStatusUpdated(uint256 disputeId, DisputeStatus newStatus, string notes, uint256 timestamp);

    function fileDispute(uint256 _productId, uint256 _transactionId, string calldata _reason, string calldata _details, address _sender) external {
        require(bytes(_reason).length > 0, "Reason is required");
        require(_productId > 0, "productId is required");
        require(_transactionId > 0, "transactionId is required");

        uint256 disputeId = disputes.length+1;

        disputes.push(Dispute({
            disputeId: disputeId,
            client: _sender,
            productId: _productId,
            transactionId: _transactionId,
            reason: _reason,
            details: _details,
            response: "",
            status: DisputeStatus.Filed,
            timestamp: block.timestamp
        }));

        disputesByClient[_sender].push(disputeId);

        emit DisputeFiled(disputeId, _sender, _transactionId, _productId, _reason, block.timestamp);
    }

    function getDisputeDetails(uint256 _disputeId) external view returns (uint256 disptueId, address client, uint256 productId, uint256 transactionId, string memory reason, string memory details, uint256 status, string memory response, uint256 timestmap) {
        require(_disputeId < disputes.length, "Invalid dispute ID");
        Dispute storage dispute = disputes[_disputeId];
        return (dispute.disputeId, dispute.client, dispute.productId, dispute.transactionId, dispute.reason, dispute.details, uint256(dispute.status), dispute.response, dispute.timestamp);
    }

    function getClientDisputeDetails(address _client) external view returns (uint256[] memory) {
        return disputesByClient[_client];
    }

    function updateDisputeStatus(uint256 _disputeId, DisputeStatus _newStatus, string calldata _response) external {
        require(_disputeId < disputes.length, "Invalid dispute ID");
        Dispute storage dispute = disputes[_disputeId];
        dispute.status = _newStatus;
        dispute.response = _response;

        emit DisputeStatusUpdated(_disputeId, _newStatus, _response, block.timestamp);

    }


    


}