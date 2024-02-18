import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",

  networks: {
    matic: {
      url: process.env.SEPOLIA_ALCHEMY_RPC_U,
      account: [process.env.PRIVATEKEY],
    },
  },
};
