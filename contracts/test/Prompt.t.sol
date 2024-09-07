// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../test/utils/MockOpml.sol";
import "OAO/contracts/AIOracle.sol";
import "../src/Prompt.sol";

contract PromptTest is Test {
    event promptsUpdated(bytes32 requestId, string output);
    event promptRequest(address sender, uint256 modelId, string prompt);

    Prompt prompt;
    IAIOracle aiOracle;

    function setUp() public {
        aiOracle = new AIOracle(0.001 ether, new MockOpml());
        prompt = new Prompt(aiOracle);
    }

    function test_requestResponseFlow() public {
        bytes32 requestId = prompt.calculateAIResult{value: 0.002 ether}(1, "hi");
        vm.prank(address(aiOracle));
        prompt.aiOracleCallback(1, "hi", "hello");
        assertEq(prompt.getAIResult(requestId), "hello");
    }

    function test_requestEmitsEvent() public {
        vm.expectEmit(true, true, true, false);
        emit promptRequest(address(this), 1, "hi");
        prompt.calculateAIResult{value: 0.002 ether}(1, "hi");
    }

    function test_properRequestIdReturned() public {
        bytes32 expected = keccak256(abi.encodePacked(uint256(1), "hi"));
        bytes32 requestId = prompt.calculateAIResult{value: 0.002 ether}(1, "hi");
        assertEq(requestId, expected);
    }
}
