// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MLModelMarketplace {
    uint public modelCount = 0;

    struct Model {
        uint id;
        address payable owner;
        string ipfsHash;
        string name;
        string description;
        uint price; // in wei
    }

    mapping(uint => Model) public models;
    mapping(address => mapping(uint => bool)) public purchases;

    event ModelListed(uint id, address owner, string name, uint price);
    event ModelPurchased(uint id, address buyer);

    // List a new model
    function listModel(string memory _ipfsHash, string memory _name, string memory _description, uint _price) public {
        require(_price > 0, "Price must be > 0");
        modelCount++;
        models[modelCount] = Model(modelCount, payable(msg.sender), _ipfsHash, _name, _description, _price);
        emit ModelListed(modelCount, msg.sender, _name, _price);
    }

    // Buy a model
    function buyModel(uint _id) public payable {
        Model memory _model = models[_id];
        require(_model.id > 0, "Model does not exist");
        require(msg.value == _model.price, "Incorrect payment");
        require(msg.sender != _model.owner, "Owner cannot buy own model");
        require(!purchases[msg.sender][_id], "Model already purchased");

        // Transfer payment to the model owner
        _model.owner.transfer(msg.value);

        // Mark as purchased for the buyer
        purchases[msg.sender][_id] = true;

        emit ModelPurchased(_id, msg.sender);
    }

    // Check if a user owns a model
    function hasPurchased(address _buyer, uint _id) public view returns (bool) {
        return purchases[_buyer][_id];
    }
}
