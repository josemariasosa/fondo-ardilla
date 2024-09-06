// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "hardhat/console.sol";


import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

/// @title Fondo Ardilla - Generate DAI rewards from AAVE in ARBITRUM
/// @author Centauri dev team
contract FondoArdillaV1 is ERC4626 {

    using SafeERC20 for IERC20;

    address constant public AAVE_POOL = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;
    address constant public ADAI_TOKEN = 0x82E64f49Ed5EC1bC6e43DAD4FC8Af9bb3A2312EE;
    address constant public DAI_TOKEN = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;

    constructor() ERC4626(IERC20(DAI_TOKEN)) ERC20("Staked DAI in aave", "stDAI") {}

    function _deposit(address caller, address receiver, uint256 assets, uint256 shares) internal override {
        // Get tokens from users.
        // console.log("IM here");
        // console.log("allowance", IERC20(DAI_TOKEN).allowance(msg.sender, address(this)));
        IERC20(DAI_TOKEN).safeTransferFrom(caller, address(this), assets);
        // console.log("total assets", IERC20(DAI_TOKEN).balanceOf(address(this)));

        // Send tokens to the DAI AAVE pool.
        IERC20(DAI_TOKEN).safeIncreaseAllowance(AAVE_POOL, assets);
        IPool(AAVE_POOL).supply(DAI_TOKEN, assets, address(this), 0);

        _mint(receiver, shares);

        emit Deposit(caller, receiver, assets, shares);
    }

    function _withdraw(
        address caller,
        address receiver,
        address owner,
        uint256 assets,
        uint256 shares
    ) internal override {
        if (caller != owner) {
            _spendAllowance(owner, caller, shares);
        }

        _burn(owner, shares);

        uint256 assetsToSend = totalSupply() == 0 ? type(uint).max : assets;
        IPool(AAVE_POOL).withdraw(DAI_TOKEN, assetsToSend, receiver);

        emit Withdraw(caller, receiver, owner, assets, shares);
    }

    function totalAssets() public view override returns (uint256) {
        return IERC20(ADAI_TOKEN).balanceOf(address(this));
    }
}