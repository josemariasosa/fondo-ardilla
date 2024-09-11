// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "hardhat/console.sol";

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";
import {IComet} from "./interfaces/IComet.sol";
import {ERC20, IERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC4626} from "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

struct ProtocolAddresses {
    address baseToken;
    address aavePool;
    address aaveToken;
    address compoundComet;
}


/// @title Fondo Ardilla - Generate base-token rewards from AAVE-v3 and Compound-Comet.
/// @author Centauri dev team
contract FondoArdillaAaveComp is ERC4626 {

    using SafeERC20 for IERC20;
    using Math for uint256;

    uint16 constant private BASIS_POINTS = 100_00; // 100%

    address immutable baseToken;

    address immutable aavePool;
    address immutable aaveToken;
    uint16 immutable aaveShare;

    address immutable compoundComet;
    uint16 immutable compoundShare;

    uint256 immutable minDeposit;

    // address constant public AAVE_POOL = 0x794a61358D6845594F94dc1DB02A252b5b4814aD;
    // address constant public ADAI_TOKEN = 0x82E64f49Ed5EC1bC6e43DAD4FC8Af9bb3A2312EE;
    // address constant public DAI_TOKEN = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;

    error IncorrectSharesTotal(uint16 _sharesTotal);
    error LessThanMinDeposit();

    constructor(
        uint16 _aaveShare,
        uint16 _compoundShare,
        uint256 _minDeposit,
        ProtocolAddresses memory _addresses,
        string memory _name,
        string memory _symbol
    ) ERC4626(IERC20(_addresses.baseToken)) ERC20(_name, _symbol) {
        validateShares(_aaveShare, _compoundShare);
        baseToken = _addresses.baseToken;
        aavePool = _addresses.aavePool;
        aaveToken = _addresses.aaveToken;
        compoundComet = _addresses.compoundComet;
        minDeposit = _minDeposit;
    }

    function validateShares(uint16 _share1, uint16 _share2) private pure {
        if (_share1 + _share2 != BASIS_POINTS) revert IncorrectSharesTotal(_share1 + _share2);
    }

    function splitAssets(uint256 _assets) private view returns (uint256 _forAave, uint256 _forComet) {
        _forAave = _assets.mulDiv(aaveShare, BASIS_POINTS, Math.Rounding.Floor);
        _forComet = _assets - _forAave;
    }

    function splitAssetsWithdraw(
        uint256 _assets,
        uint256 aaveBalance,
        uint256 cometBalance
    ) private pure returns (uint256 _fromAave, uint256 _fromComet) {
        _fromAave = _assets.mulDiv(aaveBalance, aaveBalance + cometBalance, Math.Rounding.Floor);
        _fromComet = _assets - _fromAave;
    }

    function _deposit(
        address caller,
        address receiver,
        uint256 assets,
        uint256 shares
    ) internal override {
        if (assets < minDeposit) revert LessThanMinDeposit();
        // Get tokens from users.
        IERC20(baseToken).safeTransferFrom(caller, address(this), assets);
        (uint256 assetsForAave, uint256 assetsForComet) = splitAssets(assets);

        // Send tokens to the AAVE pool and Compound Comet ☄️.
        if (assetsForAave > 0) {
            IERC20(baseToken).safeIncreaseAllowance(aavePool, assetsForAave);
            IPool(aavePool).supply(baseToken, assetsForAave, address(this), 0);
        }
        if (assetsForComet > 0) {
            IERC20(baseToken).safeIncreaseAllowance(compoundComet, assetsForComet);
            IComet(compoundComet).supply(baseToken, assetsForComet);
        }

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

        (
            uint256 assetsFromAave,
            uint256 assetsFromComet
        ) = splitAssetsWithdraw(assets, getAaveBalance(), getCometBalance());

        if (assetsFromAave > 0) {
            IPool(aavePool).withdraw(baseToken, assetsFromAave, receiver);
        }
        if (assetsFromComet > 0) {
            IComet(compoundComet).withdraw(baseToken, assetsFromComet);
            IERC20(baseToken).safeTransfer(receiver, assetsFromComet);
        }

        emit Withdraw(caller, receiver, owner, assets, shares);
    }

    function getAaveBalance() private view returns (uint256) {
        return IERC20(aaveToken).balanceOf(address(this));
    }

    function getCometBalance() private view returns (uint256) {
        return IERC20(compoundComet).balanceOf(address(this));
    }

    function totalAssets() public view override returns (uint256) {
        return getAaveBalance() + getCometBalance();
    }
}