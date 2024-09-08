// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solmate/auth/Owned.sol";

interface IForumOracle {
    function getThreadData(uint256 threadId) external view returns (string memory);
}

contract ForumOracle is IForumOracle, Owned {
    mapping(uint256 => string) public threadsData;

    constructor() Owned(msg.sender) {}

    function getThreadData(uint256 threadId) external view returns (string memory) {
        return threadsData[threadId];
    }

    function pushThreadData(uint256 threadId, string calldata data) external onlyOwner {
        threadsData[threadId] = data;
    }
}
