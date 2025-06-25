// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LendingPool {
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public borrows;
    uint256 public interestRate = 10; // 10% annual interest
    uint256 public collateralRatio = 150; // 150%
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 amount) external payable {
        deposits[msg.sender] += amount;
    }

    function borrow(uint256 amount) external {
        uint256 maxBorrow = (deposits[msg.sender] * 100) / collateralRatio;
        require(amount <= maxBorrow, "Exceeds collateral limit");
        borrows[msg.sender] += amount;
        deposits[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function getInterest(address user) public view returns (uint256) {
        return (borrows[user] * interestRate);
    }
}