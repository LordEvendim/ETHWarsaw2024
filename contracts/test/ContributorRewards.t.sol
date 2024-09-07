// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ContributorRewards.sol";

contract ContributorRewardsText is Test {
    ContributorRewards cr;

    function setUp() public {
        cr = new ContributorRewards();
    }

    function test_constructor() public {
        assertEq(cr.name(), "Contributor Rewards Token");
        assertEq(cr.symbol(), "CRT");
        assertEq(cr.decimals(), 18);
    }
}
