// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

interface IComet {
   function supply(address asset, uint amount) external;
   function withdraw(address asset, uint amount) external;
}