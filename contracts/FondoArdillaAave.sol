// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "hardhat/console.sol";


import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


// Aave address Arbitrum One
// address constant public AAVE_POOL = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;
// address constant public ADAI_TOKEN = 0x82E64f49Ed5EC1bC6e43DAD4FC8Af9bb3A2312EE;
// address constant public DAI_TOKEN = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;



/// @title Fondo Ardilla - Generate base-token rewards from AAVE-v3
/// @author Centauri dev team
contract FondoArdillaAave is ERC4626 {

    using SafeERC20 for IERC20;

    uint16 constant private BASIS_POINTS = 100_00; // 100%

    address immutable public aavePool;
    address immutable public aaveToken; // for the baseToken or asset().

    constructor(
        address _baseToken,
        address _aavePool,
        address _aaveToken,
        string memory _name,
        string memory _symbol
    ) ERC4626(IERC20(_baseToken)) ERC20(_name, _symbol) {
        aavePool = _aavePool;
        aaveToken = _aaveToken;
    }

    /// @notice Esta función reemplaza la definida en el ERC-4626.
    function _deposit(
        address caller,
        address receiver,
        uint256 assets,
        uint256 shares
    ) internal override {
        // Get tokens from users.
        IERC20(asset()).safeTransferFrom(caller, address(this), assets);

        // Send tokens to the DAI AAVE pool.
        IERC20(asset()).safeIncreaseAllowance(aavePool, assets);
        IPool(aavePool).supply(asset(), assets, address(this), 0);

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
        IPool(aavePool).withdraw(asset(), assetsToSend, receiver);

        emit Withdraw(caller, receiver, owner, assets, shares);
    }

    function totalAssets() public view override returns (uint256) {
        return IERC20(aaveToken).balanceOf(address(this));
    }
}