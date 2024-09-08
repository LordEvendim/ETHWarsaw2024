// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "OAO/contracts/IAIOracle.sol";
import "OAO/contracts/AIOracle.sol";
import "../src/ForumOracle.sol";
import "../test/utils/MockOpml.sol";
import "../test/utils/ContributorRewardsHarness.sol";
import "forge-std/console.sol";

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
        string memory result =
            "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC vitalik.eth 0x90F79bf6EB2c4f870365E785982E1f101E93b906";
        (address[] memory addresses, uint256 count) = cr.exposed_extractAddresses(result);
        for (uint256 i = 0; i < count; i++) {
            console.log(addresses[i]);
        }
        assertEq(count, 5);
        assertEq(addresses[0], 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        assertEq(addresses[1], 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        assertEq(addresses[2], 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        // assertEq(addresses[3], "vitalik.eth");  -- ENS not supported yet
        assertEq(addresses[4], 0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    }

    function test_outputParserNoisyOutput() public view {
        string memory result =
            "Here is the output for your request: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 0x70997970C51812dc3A010C7d01b50e0d17dc79C8-:D:pp 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC ENS: vitalik.eth 0x90F79bf6EB2c4f870365E785982E1f101E93b906!?!. Thanks for using our service!";
        (address[] memory addresses, uint256 count) = cr.exposed_extractAddresses(result);
        for (uint256 i = 0; i < count; i++) {
            console.log(addresses[i]);
        }
        assertEq(count, 5);
        assertEq(addresses[0], 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        assertEq(addresses[1], 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        assertEq(addresses[2], 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        // assertEq(addresses[3], "vitalik.eth");  -- ENS not supported yet
        assertEq(addresses[4], 0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    }
}
