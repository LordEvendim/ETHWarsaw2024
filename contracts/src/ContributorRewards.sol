// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solmate/tokens/ERC20.sol";
import "OAO/contracts/IAIOracle.sol";
import "../src/Prompt.sol";
import "../src/ForumOracle.sol";

contract ContributorRewards is ERC20 {
    string basePrompt =
        "Act as an objective judge. Your task is to evaluate users' contributions to the forum discussion provided in the Data section. Criteria: relevance, originality, and quality, with an emphasis on quality over quantity. Provide as output 5 unique user addresses that you believe deserve rewards. Return only the addresses, separated by spaces, and nothing else. Example: 0x123 0x456 0x789 0xabc 0xdef | Data:";

    Prompt prompt;
    ForumOracle forumOracle;

    uint256 immutable aiOracleModelId = 11;

    mapping(uint256 => bool) public rewardedThreads;
    mapping(uint256 => bytes32) public threadRequests;

    constructor(IAIOracle _aiOracle, ForumOracle _forumOracle) ERC20("Contributor Rewards Token", "CRT", 18) {
        prompt = new Prompt(_aiOracle);
        forumOracle = _forumOracle;
    }

    function calculateThreadRewards(uint256 threadId) external payable {
        require(threadRequests[threadId] == 0, "Thread rewards calculation already fired");
        string memory threadData = forumOracle.getThreadData(threadId);
        string memory input = string(abi.encodePacked(basePrompt, threadData));
        bytes32 requestId = prompt.calculateAIResult{value: msg.value}(aiOracleModelId, input);
        threadRequests[threadId] = requestId;
    }

    function rewardThread(uint256 threadId) external {
        require(threadRequests[threadId] != 0, "Thread rewards calculation not yet finished");
        require(!rewardedThreads[threadId], "Thread already rewarded");
        bytes32 requestId = threadRequests[threadId];
        string memory result = prompt.getAIResult(requestId);
        if (bytes(result).length == 0) {
            return;
        }
        rewardedThreads[threadId] = true;
        // todo: parse result and reward users
    }
}
