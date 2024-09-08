// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../src/Prompt.sol";
import "../../src/ContributorRewards.sol";
import "../../src/utils/ENSResolver.sol";

// A contract to expose internal functions for testing
contract ContributorRewardsHarness is ContributorRewards {
    constructor(Prompt _prompt, IForumOracle _forumOracle, IENSResolver _ensResolver)
        ContributorRewards(_prompt, _forumOracle, _ensResolver)
    {}

    function exposed_extractAddresses(string memory result)
        external
        view
        returns (address[] memory addresses, uint256 count)
    {
        return extractAddresses(result);
    }
}
