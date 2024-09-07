// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "OAO/contracts/IAIOracle.sol";
import "OAO/contracts/AIOracleCallbackReceiver.sol";

contract Prompt is AIOracleCallbackReceiver {
    event promptsUpdated(bytes32 requestId, string output);
    event promptRequest(address sender, uint256 modelId, string prompt);

    struct AIOracleRequest {
        address sender;
        uint256 modelId;
        bytes input;
        bytes output;
    }

    mapping(bytes32 => AIOracleRequest) public requests;
    mapping(bytes32 => string) public prompts;

    constructor(IAIOracle _aiOracle) AIOracleCallbackReceiver(_aiOracle) {}

    uint64 private constant AIORACLE_CALLBACK_GAS_LIMIT = 5000000;

    /**
     * @notice Requests AI results from the OAO AI Oracle asynchronously.
     * The Oracle will call the `aiOracleCallback` function upon completion.
     * @param modelId The ID of the AI model to use.
     * @param prompt The input prompt string for the AI model.
     * @return requestId A unique identifier for the AI request generated using the model ID and prompt.
     */
    function calculateAIResult(uint256 modelId, string calldata prompt) external payable returns (bytes32 requestId) {
        bytes memory input = bytes(prompt);
        address callbackAddress = address(this);
        aiOracle.requestCallback{value: msg.value}(
            modelId, input, callbackAddress, this.aiOracleCallback.selector, AIORACLE_CALLBACK_GAS_LIMIT
        );
        requestId = this.getRequestId(modelId, prompt);
        AIOracleRequest storage request = requests[requestId];
        request.input = input;
        request.sender = msg.sender;
        request.modelId = modelId;
        emit promptRequest(msg.sender, modelId, prompt);
    }

    /**
     * @notice Retrieves the AI result from the prompts state mapping.
     * @param requestId A unique identifier for the AI request generated using the model ID and prompt.
     * @return result The AI-generated output string corresponding to the input prompt.
     */
    function getAIResult(bytes32 requestId) external view returns (string memory result) {
        return prompts[requestId];
    }

    /**
     * @notice Callback function called by the OAO AI Oracle with the AI result.
     * Stores the Oracle's response in the prompts state mapping.
     * @dev This function is only callable by the authorized AI Oracle.
     * @param modelId The ID of the AI model used in the request.
     * @param input The input data bytes that were sent to the AI model.
     * @param output The output data bytes returned by the AI model.
     */
    function aiOracleCallback(uint256 modelId, bytes calldata input, bytes calldata output)
        external
        onlyAIOracleCallback
    {
        bytes32 requestId = this.getRequestId(modelId, string(input));
        AIOracleRequest storage request = requests[requestId];
        require(request.sender != address(0), "request does not exist");
        request.output = output;
        prompts[requestId] = string(output);
        emit promptsUpdated(requestId, string(output));
    }

    function getRequestId(uint256 modelId, string calldata prompt) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(modelId, prompt));
    }
}
