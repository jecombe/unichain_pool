// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Presale {
    IERC20 public token;
    address public owner;
    uint256 public pricePerToken;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public raisedAmount;
    bool public isFinalized;

    mapping(address => uint256) public contributions;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier saleActive() {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Sale is not active");
        _;
    }

    modifier saleEnded() {
        require(block.timestamp > endTime, "Sale has not ended");
        _;
    }

    constructor(
        address _tokenAddress,
        uint256 _pricePerToken,
        uint256 _startTime,
        uint256 _endTime
    ) {
        require(_startTime < _endTime, "Invalid time range");

        token = IERC20(_tokenAddress);
        owner = msg.sender;
        pricePerToken = _pricePerToken;
        startTime = _startTime;
        endTime = _endTime;
    }

    function buyTokens() external payable saleActive {
        uint256 amountToBuy = msg.value * pricePerToken;
        raisedAmount += msg.value;
        contributions[msg.sender] += msg.value;

        token.transfer(msg.sender, amountToBuy);
    }

    function finalizePresale() external onlyOwner saleEnded {
        require(!isFinalized, "Presale already finalized");
        isFinalized = true;

        payable(owner).transfer(address(this).balance);
    }
}
