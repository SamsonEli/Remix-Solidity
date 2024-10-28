// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract TransactionExecution {
    
    struct Product {
        uint256 productId;
        string description;
        uint256 price; // Price in wei
        bool isActive; // Indicates if the product is active
    }

    struct CustomerContract {
        uint256 contractId;
        uint256 productId;
        address customer;
        bool isApproved;
        bool isPaid;
    }


    uint256 public contractCount;
    uint256 public productCount;


    mapping(uint256 => CustomerContract) public customerContracts;
    mapping(uint256 => Product) public products;

    event ProductAdded(uint256 productId, string description, uint256 price);
    event ProductUpdated(uint256 productId, string description, uint256 price, bool status);

    event ContractCreated(uint256 contractId, uint256 productId, address customer);
    event ContractApproved(uint256 contractId, address customer);
    event ContractPaid(uint256 contractId, address customer, uint256 ContractAmount, uint256 PaidAmount, uint256 excessAmount, address contractAddress);
    

    event senderAddress(address senderAddress);

    function addProduct(string memory _description, uint256 _price) external  {
        productCount++;
        require(products[productCount].price == 0, "Product already exists");

        products[productCount] = Product({
            productId: productCount,
            description: _description,
            price: _price,
            isActive: true
        });

        emit ProductAdded(productCount, _description, _price);
    }

    function updateProduct(uint256 _productId, string memory _description, uint256 _price, bool _isActive) external     
    {
        Product storage product = products[_productId];
        
        require(product.price != 0, "Product not found or inactive");

        product.description = _description;
        product.price = _price;
        product.isActive = _isActive; 

        emit ProductUpdated(_productId, _description, _price, _isActive);
    }

    function getProduct(uint256 _productId) external view returns (string memory description, uint256 price) {
        Product memory product = products[_productId];
        require(product.isActive, "Product not found or inactive");
        return (product.description, product.price);
    }

    function createCustomerContract(uint256 _productId, address _customer) external {
        contractCount++;

        customerContracts[contractCount] = CustomerContract({
            contractId: contractCount,
            productId: _productId,
            customer: _customer,
            isApproved: false,
            isPaid: false
        });

        emit ContractCreated(contractCount, _productId, _customer);
    }

    function getCustomerContract(uint256 _contractId) external view returns (uint256 contractId, uint256 productId, address customer, bool isApproved, bool isPaid) {

       CustomerContract storage customerContract = customerContracts[_contractId];
       return (customerContract.contractId, customerContract.productId, customerContract.customer, customerContract.isApproved, customerContract.isPaid);

    }

    function approveContract(uint256 _contractId, address sender) external {
        emit senderAddress(msg.sender);
        CustomerContract storage customerContract = customerContracts[_contractId];
        require(customerContract.customer != address(0), "Contract doesn't exist");
        require(customerContract.customer == sender, "Only the assigned customer can approve this contract");
        emit senderAddress(customerContract.customer); // Log the customer address
        emit senderAddress(msg.sender);
        require(!customerContract.isApproved, "Contract already approved");
        customerContract.isApproved = true;

        emit ContractApproved(_contractId, msg.sender);
    }


    event DebugValues(uint256 contractPrice, uint256 msgValue);

    function payContract(uint256 _contractId, address sender) external payable {
        CustomerContract storage customerContract = customerContracts[_contractId];
        require(customerContract.customer != address(0), "Contract doesn't exist");
        require(customerContract.customer == sender, "Only the assigned customer can pay for this contract");
        require(customerContract.isApproved, "Contract must be approved before payment");
        require(!customerContract.isPaid, "Contract already paid");

        uint256 contractPrice = products[customerContract.productId].price;

        require(msg.value >= contractPrice, "Incorrect payment amount");

        uint256 excessAmount = msg.value - contractPrice;

        if (excessAmount > 0) {
            payable(sender).transfer(excessAmount);
        }

        customerContract.isPaid = true;

        emit ContractPaid(_contractId, msg.sender, contractPrice, msg.value, excessAmount, address(this));
    }

    function withdrawFunds(address sender) external {
        address payable owner = payable(sender);
        owner.transfer(address(this).balance);
    }

    function getTotalValue() external view returns (uint256) {
        return address(this).balance;
    }
}

//     function isTransactionOwner() {

//     }

//     function isProductOwner() {

//     }
// }