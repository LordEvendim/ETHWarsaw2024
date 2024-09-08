// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solidity-stringutils/strings.sol";

interface ENS {
    function resolver(bytes32 node) external view returns (address);
}

interface Resolver {
    function addr(bytes32 node) external view returns (address);
}

interface IENSResolver {
    function resolveENS(string memory name) external view returns (address);
}

contract ENSResolver is IENSResolver {
    using strings for *;

    ENS public ens;

    // Set the ENS registry address (mainnet address: 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e)
    constructor(address _ens) {
        ens = ENS(_ens);
    }

    function resolveENS(string memory name) public view returns (address) {
        bytes32 node = namehash(name);
        address resolverAddress = ens.resolver(node);
        require(resolverAddress != address(0), "No resolver found");

        Resolver resolver = Resolver(resolverAddress);
        address addr = resolver.addr(node);
        require(addr != address(0), "No address found");

        return addr;
    }

    function namehash(string memory name) internal pure returns (bytes32) {
        bytes32 node = bytes32(0);
        strings.slice memory s = name.toSlice();
        strings.slice memory delim = ".".toSlice();
        string[] memory labels = new string[](s.count(delim) + 1);

        for (uint256 i = labels.length; i > 0; i--) {
            labels[i - 1] = s.split(delim).toString();
        }

        for (uint256 i = 0; i < labels.length; i++) {
            node = keccak256(abi.encodePacked(node, keccak256(abi.encodePacked(labels[i]))));
        }

        return node;
    }
}
