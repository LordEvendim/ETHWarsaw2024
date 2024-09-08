// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../src/ForumOracle.sol";

contract MockForumOracle is IForumOracle {
    function getThreadData(uint256 threadId) external pure returns (string memory) {
        if (threadId == 1) {
            return "<very interesting and valuable discussion>";
        }
        return "";
    }
}
