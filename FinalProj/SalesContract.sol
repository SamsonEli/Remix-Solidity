pragma solidity ^0.8.0;

contract SalesContract {

    struct Customer {
        address customer;
        uint256[] policyIds;
        uint256[] transactions;
        bool isVerified;
    }

    struct Policy {
        uint256 policyId;
        string policyType;
        string policyDetails;
        bool isActive;
    }

    uint256 public customerCounter;
    uint256 public policyCounter;
    address public verifyingAuthority;

    mapping(uint256 => Customer) public customers;
    mapping(uint256 => Policy[]) public policies;

    // mapping(address => uint256) public customerIds;

    constructor(address _verifyingAuthority) {
        verifyingAuthority = _verifyingAuthority;
    }

    uint256 public nextCustomerId = 1;
    uint256 public nextPolicyId = 1;

    function addCustomer(address _customerAddress) public {
        customers[nextCustomerId] = Customer({
            customer: _customerAddress,
            policyIds: new uint256,
            transactions: new uint256,
            isVerified: false
        });
        nextCustomerId++;
    }




}
