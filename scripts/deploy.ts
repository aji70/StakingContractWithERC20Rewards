import { ethers } from "hardhat";
// const { ethers } = require("hardhat");

async function main() {
  const initialOwner = "0x09c5096AD92A3eb3b83165a4d177a53D3D754197";
  const cohort7 = await ethers.deployContract("Cohort7", [initialOwner]);

  await cohort7.waitForDeployment();

  const stakingContract = await ethers.deployContract("Staking", [
    cohort7.target,
  ]);

  await stakingContract.waitForDeployment();

  console.log(
    ` Token was deployed to ${cohort7.target}

    Staking contract was deployed to ${stakingContract.target}
    `
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
