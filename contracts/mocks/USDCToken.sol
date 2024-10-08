// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDCToken is ERC20 {
    constructor() ERC20("USD Coin", "USDC") {}

    function allocateTo(address _receiver, uint256 _amount) public {
        _mint(_receiver, _amount);
    }

    function decimals() public override pure returns (uint8) {
        return 18;
    }
}