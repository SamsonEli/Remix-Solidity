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
    event ContractPaid(uint256 contractId, address customer, uint256 amount);

    function addProduct(string memory _description, uint256 _price) public  {
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

    function updateProduct(uint256 _productId, string memory _description, uint256 _price, bool _isActive) public     
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

    function approveContract(uint256 _contractId) external {
        CustomerContract storage customerContract = customerContracts[_contractId];
        require(customerContract.customer != address(0), "Contract doesn't exist");
        require(customerContract.customer == msg.sender, "Only the assigned customer can approve this contract");
        require(!customerContract.isApproved, "Contract already approved");
        customerContract.isApproved = true;

        emit ContractApproved(_contractId, msg.sender);
    }

    function payContract(uint256 _contractId) external payable {
        CustomerContract storage customerContract = customerContracts[_contractId];
        require(customerContract.customer != address(0), "Contract doesn't exist");
        require(customerContract.customer == msg.sender, "Only the assigned customer can pay for this contract");
        require(customerContract.isApproved, "Contract must be approved before payment");
        require(!customerContract.isPaid, "Contract already paid");

        uint256 contractPrice = products[customerContract.productId].price;

        require(msg.value == contractPrice, "Incorrect payment amount");

        customerContract.isPaid = true;

        emit ContractPaid(_contractId, msg.sender, msg.value);
    }

    function withdrawFunds() external {
        address payable owner = payable(msg.sender);
        owner.transfer(address(this).balance);
    }

}