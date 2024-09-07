// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "solmate/tokens/ERC20.sol";

contract ContributorRewards is ERC20 {
    constructor() ERC20("Contributor Rewards Token", "CRT", 18) {}
}
