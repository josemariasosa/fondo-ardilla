require("dotenv").config()
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  
  networks: {
    hardhat: {
    // arbitrumFork: {
      // gas: 30000000,
      // gasLimit: 30000000,
      // maxFeePerGas: 55000000000,
      // maxPriorityFeePerGas: 55000000000,
      forking: {
        // url: `https://arbitrum-mainnet.infura.io/v3/${process.env.INFURA_KEY}`,
        // blockNumber: Number(process.env.BLOCK_NUMBER),
        url: `https://mainnet.infura.io/v3/${process.env.INFURA_KEY}`,
        blockNumber: Number(process.env.BLOCK_NUMBER_MAINNET),
        enabled: true,
        // enabled: false,
      },
      // chains: {
      //   42161: {
      //     hardforkHistory: {
      //       london: 23850000
      //     }
      //   }
      // }
    },
  },
  etherscan: {
    apiKey: {
      devnet: "abc",
      testnet: "abc",
      mainnet: "abc",
    },
  },
};
