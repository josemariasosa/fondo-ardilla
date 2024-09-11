// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

struct withdrawRequest {
    uint256 amount;
    uint256 unlockEpoch;
    address receiver;
}

interface IWithdrawals {
    function pendingWithdraws(address _address) external view returns (withdrawRequest memory);
}