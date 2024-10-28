// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ClientStorage {


    struct Client {
        string name;
        bool isKYCVerified;
        string ipfsHash;  // Encrypted KYC document on IPFS
        string decryptionKey; 
        uint256 registrationDate;

    }


    // Mapping to store client data by their Ethereum address
    mapping(address => Client) private clients;

    // Modifier to ensure only new clients can register
    modifier onlyNewClient(address _clientAddress) {
        require(bytes(clients[_clientAddress].name).length == 0, "Client already registered");
        _;
    }

    modifier existingClient(address _clientAddress) {
        require(bytes(clients[_clientAddress].name).length > 0, "Client not registered");
        _;
    }

    // Register a new client
    function registerClient(address _clientAddress, string memory _name, bool _kycStatus, string memory _ipfsHash, string memory _decryptionKey) external onlyNewClient(_clientAddress) {
        clients[_clientAddress] = Client({
            name: _name,
            isKYCVerified: _kycStatus,
            ipfsHash: _ipfsHash,
            decryptionKey: _decryptionKey,
            registrationDate: block.timestamp
        });
    }

    function updateClient(address _clientAddress, bool _kycStatus) external existingClient(_clientAddress){
        clients[_clientAddress].isKYCVerified = _kycStatus;
    }

    function getClient(address _clientAddress) external view returns (string memory, bool, string memory, string memory, uint256) {
        // Client memory client = clients[_clientAddress];
        
        return(clients[_clientAddress].name, clients[_clientAddress].isKYCVerified, clients[_clientAddress].ipfsHash, clients[_clientAddress].decryptionKey,clients[_clientAddress].registrationDate);
    }
}

