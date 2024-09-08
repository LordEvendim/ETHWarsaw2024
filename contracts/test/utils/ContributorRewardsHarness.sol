// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../src/ContributorRewards.sol";
import "OAO/contracts/IAIOracle.sol";
import "../../src/utils/ENSResolver.sol";

// A contract to expose internal functions for testing
contract ContributorRewardsHarness is ContributorRewards {
    constructor(IAIOracle _aiOracle, ForumOracle _forumOracle, IENSResolver _ensResolver)
        ContributorRewards(_aiOracle, _forumOracle, _ensResolver)
    {}

    function exposed_extractAddresses(string memory result)
        external
        view
        returns (address[] memory addresses, uint256 count)
    {
        return extractAddresses(result);
    }
}
