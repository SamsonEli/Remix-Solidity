// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol";

import "./KYCStorage.sol";
import "./ClientStorage.sol";
import "./Transaction.sol";
import "./ComplianceAudit.sol";
import "./Dispute.sol";


contract main is AccessControl, ReentrancyGuard {

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant KYC_APPROVER_ROLE = keccak256("KYC_APPROVER_ROLE");
    bytes32 public constant FINANCIAL_ADVISOR_ROLE = keccak256("FINANCIAL_ADVISOR_ROLE");
    bytes32 public constant VERIFIED_CLIENT_ROLE = keccak256("VERIFIED_CLIENT_ROLE");
    bytes32 public constant UNVERIFIED_CLIENT_ROLE = keccak256("UNVERIFIED_CLIENT_ROLE");
    bytes32 public constant COMPLIANCE_ROLE = keccak256("COMPLIANCE_ROLE");

    KYCStorage private kyc;
    ClientStorage private client; 
    TransactionExecution private transaction;
    DisputeManagement private dispute; 


    mapping(address => bool) public hasAnyRole; // Tracks if an address has any preexisting role

    event DebugValues(uint256 dsdsds);

    constructor() payable {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
        _grantRole(FINANCIAL_ADVISOR_ROLE, msg.sender);
        // _grantRole(KYC_APPROVER_ROLE, msg.sender);
        client = new ClientStorage();
        kyc = new KYCStorage();
        transaction = new TransactionExecution();
        dispute = new DisputeManagement();
        // hasAnyRole[msg.sender] = true;
        addApprover(msg.sender);

    }

    event RoleGranted(address indexed account, bytes32 role);
    event RoleRevoked(address indexed account, bytes32 role);
    event ClientRegistered(address indexed account, bytes32 role);
    event KYCConfirmed(address indexed account, bytes32 role);

    
    function addApprover(address _approver) public onlyRole(ADMIN_ROLE) {
        require(!hasRole(KYC_APPROVER_ROLE, _approver), "Address is already approver"); // ensures that _approver doesn't have the existing role
        grantRole(KYC_APPROVER_ROLE, _approver);
        kyc.incrementIntApprover(); 
        hasAnyRole[_approver] = true;
        emit RoleGranted(_approver, KYC_APPROVER_ROLE);
    }

    function removeApprover(address _approver) public onlyRole(ADMIN_ROLE) {
        require(hasRole(KYC_APPROVER_ROLE, _approver));
        revokeRole(KYC_APPROVER_ROLE, _approver);
        kyc.decrementIntApprover();

        if (!hasRole(ADMIN_ROLE, _approver) && 
            !hasRole(VERIFIED_CLIENT_ROLE, _approver) && 
            !hasRole(UNVERIFIED_CLIENT_ROLE, _approver)) {
                hasAnyRole[_approver] = false;
            }

        emit RoleRevoked(_approver, KYC_APPROVER_ROLE);
    }

    function getIntApprovers() public view returns (uint256) {
        return kyc.intApprovers();
    }

    function approveKYC(address _clientAddress) public onlyRole(KYC_APPROVER_ROLE) {
        require(hasRole(UNVERIFIED_CLIENT_ROLE, _clientAddress));
        revokeRole(UNVERIFIED_CLIENT_ROLE, _clientAddress);
        grantRole(VERIFIED_CLIENT_ROLE, _clientAddress);
        client.updateClient(_clientAddress, true);
        emit KYCConfirmed(_clientAddress, VERIFIED_CLIENT_ROLE);
        // only for KYC approver
        // require that the address is a customer account
    }

    function registerNewClient(address _clientAddress, string memory _name, string memory _ipfsHash, string memory _decryptionKey) public onlyRole(KYC_APPROVER_ROLE) {
        require(hasAnyRole[_clientAddress] == false, "Address already has a role");
        client.registerClient(_clientAddress, _name, false, _ipfsHash, _decryptionKey);
        grantRole(UNVERIFIED_CLIENT_ROLE, _clientAddress);
        hasAnyRole[_clientAddress] = true; 

        emit ClientRegistered(_clientAddress, UNVERIFIED_CLIENT_ROLE);
    }

    function getClientInfo(address _clientAddress) view public onlyRole(KYC_APPROVER_ROLE) returns (string memory _name, bool _isKYCVerified, string memory _docHash,  string memory _decryptionKey, uint256 _dateReg){
        return client.getClient(_clientAddress);
    }

    //add function to deregister client

    function createContract(uint256 _productId, address _addressClient) public onlyRole(FINANCIAL_ADVISOR_ROLE) {
        require(hasRole(VERIFIED_CLIENT_ROLE, _addressClient), "Client must have VERIFIED_CLIENT_ROLE");
        transaction.createCustomerContract(_productId, _addressClient);
    }

    function addProduct(string memory _description, uint _price) public onlyRole(FINANCIAL_ADVISOR_ROLE) {
        transaction.addProduct(_description, _price);
    }

    function updateProduct(uint256 _productId, string memory _description, uint256 _price, bool _isActive) public onlyRole(FINANCIAL_ADVISOR_ROLE) {
        transaction.updateProduct(_productId, _description, _price, _isActive);
    }

    function getProduct(uint _productId) public view returns (string memory description, uint256 price) {
        return transaction.getProduct(_productId);
    }

    function getContract(uint _contractId) public view returns (uint256 contractId, uint256 productId, address customer, bool isApproved, bool isPaid) {
        return transaction.getCustomerContract(_contractId);
    }

    function approveContract(uint256 _contractId) public onlyRole(VERIFIED_CLIENT_ROLE) {      
        transaction.approveContract(_contractId, msg.sender);
    }

    function payContract(uint256 _contractId) public payable onlyRole(VERIFIED_CLIENT_ROLE) {      
        transaction.payContract{value: msg.value}(_contractId, msg.sender);
    }
    function getTotalContractValue() public view returns (uint256 value) {
        return transaction.getTotalValue();
    }

    function withdrawFunds() public onlyRole(ADMIN_ROLE) nonReentrant {
        transaction.withdrawFunds(msg.sender); 
    }


    function sendDispute(uint256 _transactionId, uint256 _productId, string calldata _reason, string calldata _details) public onlyRole(VERIFIED_CLIENT_ROLE) {
        ( , , address customer, , ) = transaction.getCustomerContract(_transactionId);
        require(customer == msg.sender, "Only the contract owner can file a dispute");
        dispute.fileDispute(_productId,_transactionId, _reason, _details, msg.sender);
    }

    modifier twoRoles(bytes32 role1, bytes32 role2) {
        require(hasRole(role1, msg.sender) || hasRole(role2, msg.sender), "Access Denied: Caller does not have the required roles");
        _;
    }

    function getDispute(uint256 _disputeId) public view twoRoles(VERIFIED_CLIENT_ROLE, COMPLIANCE_ROLE) returns (uint256 disptueId, address clientAddress, uint256 productId, uint256 transactionId, string memory reason, string memory details, uint256 status, string memory response, uint256 timestmap){
        return dispute.getDisputeDetails(_disputeId);
    }

    


}

