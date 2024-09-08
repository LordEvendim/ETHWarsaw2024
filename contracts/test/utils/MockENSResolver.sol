// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../src/utils/ENSResolver.sol";

contract MockENSResolver is IENSResolver {
    function resolveENS(string memory name) public pure returns (address) {
        if (keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("vitalik.eth"))) {
            return 0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045; // Mock address for vitalik.eth
        }
        revert(); // Revert for any other name
    }
}
