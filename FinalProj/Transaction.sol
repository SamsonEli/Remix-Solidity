// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// audit smart contract -> SC
//fill out questionaire 

//compliance -> SC
//financial product
//questionaire and auditting 


contract TransactionExecution {
    
    struct Transaction {
        uint256 productId;
        address customer;           // Address of the customer
        string description;
        uint256 price;              // Price in wei
        bool isApproved;            // Whether the customer has approved the contract
        bool isPaid;                // Whether the product has been paid for
    }
}