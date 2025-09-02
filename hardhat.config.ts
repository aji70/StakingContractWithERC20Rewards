import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config({ path: ".env" });

module.exports = {
  solidity: "0.8.20",
  networks: {
    hardhat: {},

    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/KkPRZRdLfkaSApEMmxlTiWgKIBkRymzD ",
      accounts: ['6801c8019e9e9b1266468b47d94baed8b30593a03b1a2e3d8f4cba35b0a11650'],
      
    },
  },
  lockGasLimit: 200000000000,
  gasPrice: 10000000000,
  etherscan: {
    apiKey: "9D2E6X9UM39NEUI1T9UPCGZR9CTGNJF5SN",
  },

  sourcify: {
  enabled: true
}


};
