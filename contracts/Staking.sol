// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IERC20.sol";


error ADDRESS_ZERO_DETECTED();
error ZERO_VALUE_DETECTED();
error NOT_ENOUGH_TOKENS();
error STAKE_TIME_MUST_BE_IN_THE_FUTURE();
error STAKE_TIME_YET_TO_ELAPSE();
error NO_STAKE_TO_WITHDRAW();
error CANNOT_STAKE_NOW_TRY_AGAIN_LATER();

contract Staking {
    uint256 unstakeTime;
    uint256 totalStaked;
    address public owner;
    address rewardToken;
    
    mapping (address => uint256) stakeBalance;
    mapping (address => uint256) stakeDuration;
    mapping (address => uint256) lastStakedTime;
    mapping (address => uint256) noOfStakes;


    event StakingSuccessful (address staker, uint256 amount, uint256 staketime) ;
    event UnstakedSuccessful (address staker, uint256 stakedAmount); 
    
        constructor(address _rewardToken) {
            rewardToken = _rewardToken;
            owner = msg.sender;
        }


   function stake(uint256 _duration) external payable {
    uint256 _amount = msg.value;

    // Check if user has staked before and if the cooldown period has passed
    if (noOfStakes[msg.sender] != 0 && block.timestamp - lastStakedTime[msg.sender] < 10) {
        revert("Cannot stake now, try again later");
    }

    // Validate non-zero address
    if (msg.sender == address(0)) {
        revert("Address zero detected");
    }

    // Validate amount
    if (_amount == 0) {
        revert("Cannot stake zero value");
    }

    // Validate duration
    if (_duration == 0) {
        revert("Stake duration must be in the future");
    }

    // Transfer tokens
      (bool success, ) = payable(address(this)).call{value: msg.value}("");
        require(success, "Failed to send Ether");
    // Update staking records
    stakeBalance[msg.sender] += _amount;
    totalStaked += _amount;
    stakeDuration[msg.sender] = block.timestamp + _duration;
    noOfStakes[msg.sender]++;
    lastStakedTime[msg.sender] = block.timestamp;

    // Emit event
    emit StakingSuccessful(msg.sender, _amount, _duration);
}

    function unstake(uint256 _amount) public {

     if (msg.sender == address(0)){
            revert ADDRESS_ZERO_DETECTED();
        }
        if(block.timestamp <= stakeDuration[msg.sender]){
            revert STAKE_TIME_YET_TO_ELAPSE();
        }
   
        if(stakeBalance[msg.sender] <= 0){
            revert NO_STAKE_TO_WITHDRAW();
        }

        require(stakeBalance[msg.sender] >= _amount, "Insufficient staked balance");

         // Transfer tokens
         (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "Failed to send Ether");

        uint256 _stk = stakeBalance[msg.sender];
        uint time = block.timestamp - stakeDuration[msg.sender];
        totalStaked -= _stk;
        stakeBalance[msg.sender] = 0;
        uint _tAmount = _stk + Calculatereward(_stk, time);

        IERC20(rewardToken).transfer(msg.sender, _tAmount);
        lastStakedTime[msg.sender] = block.timestamp;

        emit UnstakedSuccessful(msg.sender, _tAmount);
    }

     function emergencyWithdraw() public {
        if (msg.sender == address(0)){
            revert ADDRESS_ZERO_DETECTED();
        }
        
         if(stakeBalance[msg.sender] <= 0){
        revert NO_STAKE_TO_WITHDRAW();
            }
        uint _amount;
        stakeBalance[msg.sender] = _amount;
         totalStaked -= _amount;
        stakeBalance[msg.sender] = 0;

         IERC20(rewardToken).transfer(msg.sender, _amount);
         emit UnstakedSuccessful(msg.sender, _amount);
        emit UnstakedSuccessful(msg.sender, block.timestamp);
    }

    function Calculatereward(uint256 _amount, uint256 _timeInSec)public pure returns(uint256){
       uint256 _reward = (_amount * 7 * _timeInSec) / 100000;
       return _reward;
    }

    function checkUserStakedBalance(address _user) external view returns (uint256) {
        return stakeBalance[_user];
    }
    function totalStakedBalance() external view returns (uint256) {
        return totalStaked;
    }
    function _calcDuration() external   view returns(uint256, string memory){
       if(stakeBalance[msg.sender] == 0){
        return(0, "you have no stake to withdraw");
       }
       
        if((stakeDuration[msg.sender] - block.timestamp) > 1){
        return (stakeDuration[msg.sender] - block.timestamp, "Staking not Matured");
        }
        else{
            return(0, "Stake Matured");
        }
        
    }
    function returnStakeDuration(address _user) external view returns(uint256){
       return stakeDuration[_user];
    }
    
    function returnNoOfStakes() private view returns(uint256){
        
        return noOfStakes[msg.sender];
    }

    function returnOwner() external view returns(address){
        return owner;
    }

    receive() external payable {}
}