// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solmate/tokens/ERC20.sol";
import "OAO/contracts/IAIOracle.sol";
import "../src/Prompt.sol";
import "../src/ForumOracle.sol";
import "../src/utils/AddressUtils.sol";
import "../src/utils/ENSResolver.sol";
import "solidity-stringutils/strings.sol";
import "forge-std/console.sol";

contract ContributorRewards is ERC20 {
    using strings for *;
    using AddressUtils for string;

    string basePrompt =
        "Act as an objective judge. Your task is to evaluate users' contributions to the forum discussion provided in the Data section. Criteria: relevance, originality, and quality, with an emphasis on quality over quantity. Provide as output 5 unique user addresses that you believe deserve rewards. Return only the addresses, separated by spaces, and nothing else. Example: 0x123 0x456 0x789 0xabc 0xdef | Data:";

    Prompt public prompt;
    IForumOracle forumOracle;
    IENSResolver ensResolver;

    uint256 immutable aiOracleModelId = 11;

    mapping(uint256 => bool) public rewardedThreads;
    mapping(uint256 => bytes32) public threadRequests;

    constructor(Prompt _prompt, IForumOracle _forumOracle, IENSResolver _ensResolver)
        ERC20("Contributor Rewards Token", "CRT", 18)
    {
        prompt = _prompt;
        forumOracle = _forumOracle;
        ensResolver = _ensResolver;
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
        console.log(result);
        if (bytes(result).length == 0) {
            return;
        }
        rewardedThreads[threadId] = true;

        (address[] memory addresses, uint256 count) = extractAddresses(result);
        for (uint256 i = 0; i < count; i++) {
            _mint(addresses[i], 1e18);
        }
    }

    // splits output on spaces, then it checks each word, a word is consiered a valid address if
    //     a) it starts with 0x
    //     b) it ends with .eth
    function extractAddresses(string memory result) internal view returns (address[] memory addresses, uint256 count) {
        strings.slice memory s = result.toSlice();
        strings.slice memory delim = " ".toSlice();
        uint256 allWordsCount = s.count(delim) + 1;
        count = 0;
        address[] memory fullSizedAddressesArray = new address[](allWordsCount);
        for (uint256 i = 0; i < allWordsCount; i++) {
            strings.slice memory wordSlice = s.split(delim);
            if (wordSlice.startsWith("0x".toSlice())) {
                fullSizedAddressesArray[count] = wordSlice.toString().toAddress();
                count++;
            } else if (wordSlice.endsWith(".eth".toSlice())) {
                try ensResolver.resolveENS(wordSlice.toString()) returns (address resolvedAddress) {
                    if (resolvedAddress != address(0)) {
                        fullSizedAddressesArray[count] = resolvedAddress;
                        count++;
                    }
                } catch {}
            }
        }
        // Resize the array to the true size of valid addresses
        addresses = new address[](count);
        for (uint256 i = 0; i < count; i++) {
            addresses[i] = fullSizedAddressesArray[i];
        }
    }
}
