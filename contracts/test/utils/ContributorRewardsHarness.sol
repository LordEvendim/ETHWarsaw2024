// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../src/ContributorRewards.sol";
import "OAO/contracts/IAIOracle.sol";

// A contract to expose internal functions for testing
contract ContributorRewardsHarness is ContributorRewards {
    constructor(IAIOracle _aiOracle, ForumOracle _forumOracle) ContributorRewards(_aiOracle, _forumOracle) {}

    function exposed_extractAddresses(string memory result)
        external
        pure
        returns (address[] memory addresses, uint256 count)
    {
        return extractAddresses(result);
    }
}
