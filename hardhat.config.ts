import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config({ path: ".env" });

module.exports = {
  solidity: "0.8.20",
  networks: {
    hardhat: {},

    sepolia: {
      url: "rpc url",
      accounts: ['private key'],
      
    },
  },
  lockGasLimit: 200000000000,
  gasPrice: 10000000000,
  etherscan: {
    apiKey: "api key",
  },

  sourcify: {
  enabled: true
}


};
