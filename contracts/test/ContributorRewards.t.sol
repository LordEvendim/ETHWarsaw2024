// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "OAO/contracts/IAIOracle.sol";
import "OAO/contracts/AIOracle.sol";
import "../test/utils/MockForumOracle.sol";
import "../test/utils/MockOpml.sol";
import "../test/utils/ContributorRewardsHarness.sol";
import "../test/utils/MockENSResolver.sol";
import "../src/Prompt.sol";
import "forge-std/console.sol";

contract ContributorRewardsText is Test {
    ContributorRewardsHarness cr;
    AIOracle aiOracle;
    Prompt prompt;

    function setUp() public {
        aiOracle = new AIOracle(0.001 ether, new MockOpml());
        prompt = new Prompt(aiOracle);
        cr = new ContributorRewardsHarness(prompt, new MockForumOracle(), new MockENSResolver());
    }

    function test_constructor() public view {
        assertEq(cr.name(), "Contributor Rewards Token");
        assertEq(cr.symbol(), "CRT");
        assertEq(cr.decimals(), 18);
    }

    function test_tokensMinted() public {
        cr.calculateThreadRewards{value: 0.002 ether}(1);
        vm.prank(address(aiOracle));
        prompt.aiOracleCallback(
            11,
            "Act as an objective judge. Your task is to evaluate users' contributions to the forum discussion provided in the Data section. Criteria: relevance, originality, and quality, with an emphasis on quality over quantity. Provide as output 5 unique user addresses that you believe deserve rewards. Return only the addresses, separated by spaces, and nothing else. Example: 0x123 0x456 0x789 0xabc 0xdef | Data:<very interesting and valuable discussion>",
            "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
        );
        cr.rewardThread(1);
        assertEq(cr.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 1e18);
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
        assertEq(addresses[3], 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045);
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
        assertEq(addresses[3], 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045);
        assertEq(addresses[4], 0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    }

    function test_unknownENSSkipped() public view {
        string memory result =
            "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 0x70997970C51812dc3A010C7d01b50e0d17dc79C8 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC unknown.eth 0x90F79bf6EB2c4f870365E785982E1f101E93b906";
        (address[] memory addresses, uint256 count) = cr.exposed_extractAddresses(result);
        for (uint256 i = 0; i < count; i++) {
            console.log(addresses[i]);
        }
        assertEq(count, 4);
        assertEq(addresses[0], 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        assertEq(addresses[1], 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        assertEq(addresses[2], 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        assertEq(addresses[3], 0x90F79bf6EB2c4f870365E785982E1f101E93b906);
    }
}
