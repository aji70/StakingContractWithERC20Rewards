import { ethers } from "hardhat";

async function main() {
  const initialOwner = "0x09c5096AD92A3eb3b83165a4d177a53D3D754197";
  const ajidokwuToken = await ethers.deployContract("Ajidokwu20", [
    initialOwner,
  ]);

  await ajidokwuToken.waitForDeployment();
  // const staking = await ethers.deployContract("Ajidokwu20", [
  //   ajidokwuToken.target,
  // ]);

  console.log(
    `Ajidokwu Token was deployed to ${ajidokwuToken.target}
    `
  );
  // console.log(` staking contract was deployed to ${staking.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
