// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./token/Erc20.sol";
import "./Presale.sol";

contract TokenPresaleFactory {
    struct PresaleInfo {
        address presaleContract;
        address tokenContract;
    }

    mapping(address => PresaleInfo[]) public userPresales;

    event PresaleCreated(
        address indexed owner,
        address indexed presaleContract,
        address indexed tokenContract
    );

    function createTokenAndPresale(
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        uint256 pricePerToken,
        uint256 startTime,
        uint256 endTime
    ) external returns (address, address) {
        // Deploy new ERC20 token
        CustomToken token = new CustomToken(name, symbol, initialSupply);
        token.transferOwnership(msg.sender);

        // Deploy presale contract
        Presale presale = new Presale(
            address(token),
            pricePerToken,
            startTime,
            endTime
        );

        // Transfer tokens to the presale contract for selling
        uint256 presaleTokens = initialSupply / 2; // for example, 50% of total supply goes to presale
        token.transfer(address(presale), presaleTokens);

        // Store the presale info for the user
        userPresales[msg.sender].push(PresaleInfo(address(presale), address(token)));

        emit PresaleCreated(msg.sender, address(presale), address(token));

        return (address(token), address(presale));
    }

    // Function to get all presales created by a user
    function getPresalesByUser(address user) external view returns (PresaleInfo[] memory) {
        return userPresales[user];
    }
}
