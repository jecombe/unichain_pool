// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IUniswapV2Router02 } from "v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract Presale {
    IERC20 public token;
    address public owner;
    uint256 public pricePerToken;
    uint256 public startTime;
    uint256 public endTime;
    uint256 public raisedAmount;
    bool public isFinalized;

    mapping(address => uint256) public contributions;

    struct PresaleOptions {
        uint256 tokenDeposit;
        uint256 hardCap;
        uint256 softCap;
        uint256 max;
        uint256 min;
        uint112 start;
        uint112 end;
        uint32 liquidityBps;
    }

    struct Pool {
        IERC20 token;
        IUniswapV2Router02 uniswapV2Router02;
        uint256 tokenBalance;
        uint256 tokensClaimable;
        uint256 tokensLiquidity;
        uint256 weiRaised;
        address weth;
        uint8 state;
        PresaleOptions options;
    }

    Pool public pool;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier saleActive() {
        require(
            block.timestamp >= startTime && block.timestamp <= endTime,
            "Sale is not active"
        );
        _;
    }

    modifier saleEnded() {
        require(block.timestamp > endTime, "Sale has not ended");
        _;
    }

    constructor(
        address _weth,
        address _token,
        address _uniswapV2Router02,
        PresaleOptions memory _options
    ) {
        require(_startTime < _endTime, "Invalid time range");

        pool.uniswapV2Router02 = IUniswapV2Router02(_uniswapV2Router02);
        pool.token = IERC20(_token);
        pool.state = 1;
        pool.weth = _weth;
        pool.options = _options;
    }
}
