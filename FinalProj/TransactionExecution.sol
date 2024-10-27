// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CustomerPolicyContract {
    struct Customer {
        uint256 id;
        string name;
        address walletAddress;
        bool isVerified;
        bool isAudited; 
    }

    struct Policy {
        uint256 policyId;
        string policyName; 
        string policyDetails;
        // uint256 startDate;
        // uint256 endDate;
    }

    address public verifyingAuthority;
    address public auditingAuthority;

    constructor(address _verifyingAuthority, address _auditingAuthority) {
        verifyingAuthority = _verifyingAuthority;
        auditingAuthority = _auditingAuthority;
    }


    mapping(uint256 => Customer) public customers;
    mapping(uint256 => Policy) public policies;
    mapping(uint256 => uint256[]) public customerPolicies;

    uint256 public nextCustomerId = 1;
    uint256 public nextPolicyId = 1;

    function addCustomer(string memory _name) public {
        customers[nextCustomerId] = Customer({
            id: nextCustomerId,
            name: _name,
            walletAddress: msg.sender,
            isVerified: false,
            isAudited: false
        });
        nextCustomerId++;
    }

    function addPolicy(
        string memory _policyDetails,
        string memory _policyName
        // uint256 _startDate,
        // uint256 _endDate

    ) public returns (uint256) {
        policies[nextPolicyId] = Policy({
            policyId: nextPolicyId,
            policyName: _policyName,
            policyDetails: _policyDetails
            // startDate: _startDate,
            // endDate: _endDate
        });

        nextPolicyId++;
        return nextPolicyId - 1; // Return the ID of the created policy
    }

    function addPolicyToCustomer(uint256 _customerId, uint256 _policyId) public {
        require(customers[_customerId].id != 0, "Customer does not exist");
        require(policies[_policyId].policyId != 0, "Policy does not exist");

        customerPolicies[_customerId].push(_policyId);
    }

    function getPoliciesOfCustomer(uint256 _customerId)
        public
        view
        returns (uint256[] memory)
    {
        return customerPolicies[_customerId];
    }

    // Get details of a specific policy
    function getPolicyDetails(uint256 _policyId) public view returns (Policy memory)
    {
        require(policies[_policyId].policyId != 0, "Policy does not exist");
        return policies[_policyId];
    }

    function getCustomer(uint256 _customerId) public view returns (Customer memory)
    {
        require(customers[_customerId].id != 0, "Customer does not exist");
        return customers[_customerId];
    }

    function verifyCustomer(uint _customerId) public {
        require(msg.sender == verifyingAuthority, "Only the verifying authority can verify the user.");
        require(_customerId > 0 && _customerId <= nextCustomerId, "Invalid transaction ID.");
        customers[_customerId].isVerified = true;
    }

    function auditCustomer(uint _customerId) public {
        require(msg.sender == auditingAuthority, "Only the auditing authority can verify the user.");
        require(_customerId > 0 && _customerId <= nextCustomerId, "Invalid transaction ID.");
        customers[_customerId].isAudited = true;
    }
}
