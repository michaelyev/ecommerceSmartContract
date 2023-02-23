// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Ecommerce {

    struct Product{
        string name;
        string description;
        uint price;
        uint stock;
        bool isAvailable;
    }

    address payable owner;

    Product[] items;

    mapping(address => mapping(uint256 => uint256 )) public purchases;

    modifier onlyOwner{
        require(msg.sender == owner, "No permission");
        _;
    }

    constructor(){
        owner = payable(msg.sender);
    }

    function addProduct(string memory _name, string memory _description, uint _price, uint _stock) public onlyOwner{

        Product memory newProduct = Product(_name, _description, _price, _stock, true);
        items.push(newProduct);
    }

    function purchaseProduct(uint _id, uint _quantity) public payable{
        Product memory product = items[_id];
        require(msg.value == product.price * _quantity, 'Not enough funds');
        require(product.stock >= _quantity, "Out of order");
        purchases[msg.sender][_id] += _quantity;
        product.stock -= _quantity;
    }

    function viewProduct(uint _id) public view returns(string memory name, string memory description, uint price, uint stock){
        Product memory product = items[_id];
        return(product.name, product.description, product.price, product.stock);
    }

    function updateProduct(uint _id, string memory _name, uint _price) public onlyOwner{
        require(items[_id].isAvailable == true, 'Not Available');
        items[_id].name = _name;
        items[_id].price = _price;

    }


}