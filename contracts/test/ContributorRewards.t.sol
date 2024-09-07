// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "OAO/contracts/IAIOracle.sol";
import "OAO/contracts/AIOracle.sol";
import "../src/ForumOracle.sol";
import "../test/utils/MockOpml.sol";
import "../test/utils/ContributorRewardsHarness.sol";

contract ContributorRewardsText is Test {
    ContributorRewardsHarness cr;

    function setUp() public {
        IAIOracle aiOracle = new AIOracle(0.001 ether, new MockOpml());
        cr = new ContributorRewardsHarness(aiOracle, new ForumOracle());
    }

    function test_constructor() public view {
        assertEq(cr.name(), "Contributor Rewards Token");
        assertEq(cr.symbol(), "CRT");
        assertEq(cr.decimals(), 18);
    }

    function test_outputParserExpectedOutput() public view {
        string memory result = "0x123 0x456 0x789 vitalik.eth 0xdef";
        (string[] memory addresses, uint256 count) = cr.exposed_extractAddresses(result);
        assertEq(count, 5);
        assertEq(addresses[0], "0x123");
        assertEq(addresses[1], "0x456");
        assertEq(addresses[2], "0x789");
        assertEq(addresses[3], "vitalik.eth");
        assertEq(addresses[4], "0xdef");
    }

    function test_outputParserNoisyOutput() public view {
        string memory result =
            "Here is the output for your request: 0x123 0x456 0x789 ENS: vitalik.eth 0xdef Thanks for using our service!";
        (string[] memory addresses, uint256 count) = cr.exposed_extractAddresses(result);
        assertEq(count, 5);
        assertEq(addresses[0], "0x123");
        assertEq(addresses[1], "0x456");
        assertEq(addresses[2], "0x789");
        assertEq(addresses[3], "vitalik.eth");
        assertEq(addresses[4], "0xdef");
    }
}
