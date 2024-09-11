const hre = require("hardhat");
const { ethers, upgrades } = require("hardhat");

console.log("Network: %s", hre.network.name);

ADDRESSBOOK = {
  hardhat: {
    "mpETH": "0x48afbbd342f64ef8a9ab1c143719b63c2ad81710",
    "bigBagMpETH": "0x962d00611208f83175dA312277925b88E44708c7",
    "mpETHWithdraw": "0xE55E5fDe6C25ac4AD75D867817D2d8a45836Af49",
  }
}

async function main() {

  const mpeth = await ethers.getContractAt("IMPETH", ADDRESSBOOK[hre.network.name]["mpETH"]);
  const mpethWithdraw = await ethers.getContractAt("IWithdrawals", ADDRESSBOOK[hre.network.name]["mpETHWithdraw"]);
  const alice = await ethers.getImpersonatedSigner(ADDRESSBOOK[hre.network.name]["bigBagMpETH"]);

  console.log("alice: ", alice.address);
  console.log("alice mpeth: ", ethers.formatEther(await mpeth.balanceOf(alice.address)));
  console.log("balance eth: ", ethers.formatEther(await hre.ethers.provider.getBalance(alice.address)));

//   withdraw(uint256 assets, address receiver, address owner)
  const tx = await mpeth.connect(alice).withdraw(ethers.parseEther("180"), alice.address, alice.address);
  tx.wait();
  console.log("alice mpeth: ", ethers.formatEther(await mpeth.balanceOf(alice.address)));

  console.log(await mpethWithdraw.pendingWithdraws(alice.address));



//   console.log("aToken balance: ", await ATokenContract.balanceOf(alice.address));
  
//   const DAIToken = await ethers.getContractFactory("DAIToken");
//   const DAITokenContract = await DAIToken.attach(ADDRESSBOOK[hre.network.name]["DAIToken"]);

//   console.log("dai: ", await DAITokenContract.name());
//   console.log("dai balance: ", await DAITokenContract.balanceOf(alice.address));

//   await DAITokenContract.connect(alice).approve(PoolContract.target, ethers.parseUnits("100", 18));

//   const tx = await PoolContract.connect(alice).supply(
//     // address asset,
//     DAITokenContract.target,
//     // uint256 amount,
//     ethers.parseUnits("100", 18),
//     // address onBehalfOf,
//     alice.address,
//     // uint16 referralCode
//     0
//   );

//   await tx.wait();

//   console.log("alice aave: ", await PoolContract.getUserAccountData(alice.address));
//   console.log("alice aave: ", await PoolContract.getUserConfiguration(alice.address));
//   console.log("aToken balance: ", await ATokenContract.balanceOf(alice.address));
//   console.log("dai balance: ", await DAITokenContract.balanceOf(alice.address));

//   const uintMax = BigInt("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");

//   // console.log(uintMax.toString());

//   const tx2 = await PoolContract.connect(alice).withdraw(
//     // address asset,
//     DAITokenContract.target,
//     // uint256 amount,
//     ethers.parseUnits("50", 18),
//     // uintMax,
//     // address to
//     alice.address
//   );

//   console.log("alice aave: ", await PoolContract.getUserAccountData(alice.address));
//   console.log("alice aave: ", await PoolContract.getUserConfiguration(alice.address));
//   console.log("aToken balance: ", await ATokenContract.balanceOf(alice.address));
//   console.log("dai balance: ", await DAITokenContract.balanceOf(alice.address));



  

  // // Summary
  // console.log("MPETHTokenContract: --------: ", MPETHTokenContract.target);
  // console.log("USDTTokenContract: ---------: ", USDTTokenContract.target);
  // console.log("ETHToUSDOracleContract: ----: ", ADDRESSBOOK[hre.network.name]["ETHUSD"]);
  // console.log("USDTToUSDOracleContract: ---: ", ADDRESSBOOK[hre.network.name]["USDCUSD"]);
  // console.log("MetaPoolETHOracleContract: -: ", MetaPoolETHOracleContract.target);
  // console.log("MPETHPriceFeedContract: ----: ", MPETHPriceFeedContract.target);
  // console.log("VerdeTokenContract: --------: ", VerdeTokenContract.target);
  // console.log("TreasuryVaultContract: -----: ", TreasuryVaultContract.target);
  // console.log("SwapVerdeContract: ---------: ", SwapVerdeContract.target);
  // console.log("BorrowVerdeContract: -------: ", BorrowVerdeContract.target);
  // console.log("ProxyBorrowImplementation: -: ", ProxyBorrowImplementation);
  // console.log("adminProxyBorrowAddress: ---: ", adminProxyBorrowAddress);
  // console.log("StakedVerdeContract: -------: ", StakedVerdeContract.target);
  // console.log("StakedStableContract: ------: ", StakedStableContract.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
