/// <reference types="ethers" />
import {
  time
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { ethers } from "hardhat";
import { expect } from "chai";
import { Cohort7 } from "../typechain-types";
import { Staking } from "../typechain-types";


describe("Staking Contract", function () {

  let staking: any;
  let cohort7: any;
  const contractDeposit = 1000000000000000;


  beforeEach(async () => {
    const [owner] = await ethers.getSigners();

    const Cohort7 = await ethers.getContractFactory("Cohort7");

    cohort7 = await Cohort7.deploy(owner);

    const Staking = await ethers.getContractFactory("Staking");
    staking = await Staking.deploy(cohort7.target);

    await cohort7.connect(owner).transfer(staking.target, contractDeposit);
     
    const CurrentTime = await time.latest();
  });

  describe("Balance of contract to improved after deployment", () => {
    it("should Transfer Rewards tokens to contract", async () => {
      const [owner, addr1] = await ethers.getSigners();
      const contractBal = await cohort7
        .balanceOf(staking.target);
      expect(contractBal).to.equal(contractDeposit);
      const stakingOwner = await staking.owner();
      expect(stakingOwner).to.equal(owner);

    });
  });

  describe("Test Stake", () => {
    it("Should Stake properly", async () => {
      const stakeAmount = 1000;
      const stakedTime = 20;

      const [_, emma] = await ethers.getSigners();

      await staking.connect(emma).stake(stakedTime, { value: stakeAmount });
      expect(await staking.connect(emma).checkUserStakedBalance(emma.address)).to.equal(
        stakeAmount
      );
    });
  });

  describe("Unstake", () => {
    it("should Unstake properly", async () => {
      const [owner] = await ethers.getSigners();
       const stakeAmount = 1000;
      const stakedTime = 20;

      const [_, emma] = await ethers.getSigners();

      const balanceb4 = await ethers.provider.getBalance(staking.target);
      console.log("Contract Balance b4:", balanceb4.toString());

       const emmaBalanceb4 = await ethers.provider.getBalance(emma.address);
      console.log("Emma Balance b4:", emmaBalanceb4.toString());

      await staking.connect(emma).stake(stakedTime, { value: stakeAmount });
      await time.increase(stakedTime + 25);

      const balanceaft = await ethers.provider.getBalance(staking.target);
      console.log("Contract Balance aft:", balanceaft.toString());

      const contractBal = await cohort7
        .balanceOf(staking.target);
        console.log("Contract Token Balance:", contractBal.toString());
       const emmaTokenBalB4 = await cohort7
        .balanceOf(emma.address);
        console.log("Emma Token Balance B4:", emmaTokenBalB4.toString());
      await staking.connect(emma).unstake(stakeAmount);

       const emmaBalanceaft = await ethers.provider.getBalance(emma.address);
      console.log("Emma Balance aft:", emmaBalanceaft.toString());
       const emmaTokenBal = await cohort7
        .balanceOf(emma.address);
        console.log("Emma Token Balance:", emmaTokenBal.toString());
    });
  });
  describe("Emergency Withdraw", () => {
    it("should unstake during emergencyproperly", async () => {
  
    });
  });
});
