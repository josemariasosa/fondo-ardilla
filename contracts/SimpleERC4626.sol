// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract SimpleERC4626 is ERC4626 {
    constructor(
        IERC20 _asset
    ) ERC4626(_asset) ERC20("Name of the Share Token", "SHARE") {}
}