// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ContributorRewards.sol";
import "OAO/contracts/IAIOracle.sol";
import "OAO/contracts/AIOracle.sol";
import "../src/ForumOracle.sol";
import "../test/utils/MockOpml.sol";

contract ContributorRewardsText is Test {
    ContributorRewards cr;

    function setUp() public {
        IAIOracle aiOracle = new AIOracle(0.001 ether, new MockOpml());
        cr = new ContributorRewards(aiOracle, new ForumOracle());
    }

    function test_constructor() public {
        assertEq(cr.name(), "Contributor Rewards Token");
        assertEq(cr.symbol(), "CRT");
        assertEq(cr.decimals(), 18);
    }
}
