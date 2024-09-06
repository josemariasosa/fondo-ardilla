const { expect } = require("chai");
const { ethers, upgrades } = require("hardhat");
const { loadFixture, time } = require("@nomicfoundation/hardhat-network-helpers");

const MLARGE = ethers.parseEther("100000000000000");

describe("Swap Verde - Swap between Stablecoin and $VERDE tokens in Meta Pool ----", function () {
  describe("Preview Swaps", function () {
    it("previewStableToVerde", async function () {
      const {
        FondoArdillaContract,
        DAIContract,
        alice,
        bob,
        carl,
      } = await loadFixture(deployFixture);

      console.log(await DAIContract.balanceOf(alice.address));
      console.log(await DAIContract.balanceOf(bob.address));
      console.log(await DAIContract.balanceOf(carl.address));

      console.log(await FondoArdillaContract.totalAssets());
      const tx1 = await DAIContract.connect(alice).approve(FondoArdillaContract.target, MLARGE);
      tx1.wait(1);
      console.log(await DAIContract.allowance(alice.address, FondoArdillaContract.target));
      await FondoArdillaContract.connect(alice).deposit(ethers.parseEther("10"), alice.address);
      console.log(await FondoArdillaContract.totalAssets());
      await DAIContract.connect(bob).approve(FondoArdillaContract.target, MLARGE);
      await FondoArdillaContract.connect(bob).deposit(ethers.parseEther("20"), bob.address);
      console.log(await FondoArdillaContract.totalAssets());
      await DAIContract.connect(carl).approve(FondoArdillaContract.target, MLARGE);
      await FondoArdillaContract.connect(carl).deposit(ethers.parseEther("30"), carl.address);
      console.log(await FondoArdillaContract.totalAssets());

      console.log(await FondoArdillaContract.totalAssets());
      // await time.increase(10000);
      console.log(await FondoArdillaContract.totalAssets());

      console.log("alice shares: ", await FondoArdillaContract.balanceOf(alice.address))
      console.log("alice shares in DAI: ", await FondoArdillaContract.convertToAssets(await FondoArdillaContract.balanceOf(alice.address)));
  
    });
  });
});

async function deployFixture() {
  const FondoArdilla = await ethers.getContractFactory("FondoArdillaV1");

  const [
    owner,
    alice,
    bob,
    carl,
  ] = await ethers.getSigners();

  const FondoArdillaContract = await FondoArdilla.deploy();
  await FondoArdillaContract.waitForDeployment();
  
  const bigBag = await ethers.getImpersonatedSigner("0x2d070ed1321871841245d8ee5b84bd2712644322");
  const DAIContract = await ethers.getContractAt("ERC20", "0xda10009cbd5d07dd0cecc66161fc93d7c9000da1");

  await DAIContract.connect(bigBag).transfer(alice.address, ethers.parseEther("100"));
  await DAIContract.connect(bigBag).transfer(bob.address, ethers.parseEther("200"));
  await DAIContract.connect(bigBag).transfer(carl.address, ethers.parseEther("300"));

  return {
    FondoArdillaContract,
    DAIContract,
    owner,
    alice,
    bob,
    carl,
  };
}