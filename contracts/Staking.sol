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
    uint private unstakeTime;
    uint TotalStaked;
    address private owner;
    address ajidokwuToken;
    mapping (address => uint) stakeBalance;
    mapping (address => uint) stakeDuration;
    mapping (address => uint) lastStakedTime;
    mapping (address => uint) noOfStakes;
    

    event StakingSuccessful (address staker, uint amount, uint staketime) ;
    event UnstakedSuccessful (address staker, uint stakedAmount); 
    
        constructor(address _ajidokwuToken) {
            ajidokwuToken = _ajidokwuToken;
            owner = msg.sender;
        }


    function stake(uint256 _amount, uint _duration) external{

        if (noOfStakes[msg.sender] != 0 && block.timestamp - lastStakedTime[msg.sender] < 10) {
        revert CANNOT_STAKE_NOW_TRY_AGAIN_LATER();
        }
            if (msg.sender == address(0)){
                revert ADDRESS_ZERO_DETECTED();
            }
        // require(msg.sender != address(0), "Address zero detected");
        if (_amount <= 0){
                revert ZERO_VALUE_DETECTED();
            }
        // require(_amount > 0, "Can't stake zero value");

        if(IERC20(ajidokwuToken).balanceOf(msg.sender) <= _amount){
            revert NOT_ENOUGH_TOKENS();
        }
        // require(IERC20(ajidokwuToken).balanceOf(msg.sender) >= _amount, "Not enough tokens to stake");
        if(_duration <= 0){
            revert STAKE_TIME_MUST_BE_IN_THE_FUTURE();
        }
        // require(_duration > 0, "Unstake time Must be in the funture");
        IERC20(ajidokwuToken).transferFrom(msg.sender, address(this), _amount);

            stakeBalance[msg.sender] += _amount;
            TotalStaked+=_amount;

            emit StakingSuccessful(msg.sender, _amount, _duration);
            
            uint256 inow = block.timestamp + _duration; 
            stakeDuration[msg.sender] = inow;
            noOfStakes[msg.sender]++;

    }
   
    function unstake() public {
        // require(msg.sender != address(0), "Address zero detected");
     if (msg.sender == address(0)){
            revert ADDRESS_ZERO_DETECTED();
        }
        if(block.timestamp <= stakeDuration[msg.sender]){
            revert STAKE_TIME_YET_TO_ELAPSE();
        }

        // require(block.timestamp >= stakeDuration[msg.sender]   , "You can't withdraw yet");
        // require(block.timestamp >= unlockTime, "You can't withdraw yet");

        if(stakeBalance[msg.sender] <= 0){
            revert NO_STAKE_TO_WITHDRAW();
        }
        
        // require(stakeBalance[msg.sender] > 0, "No stake to withdraw");

        uint256 _stk = stakeBalance[msg.sender];
        uint time = block.timestamp - stakeDuration[msg.sender];
        TotalStaked -= _stk;
        stakeBalance[msg.sender] = 0;
        uint _amount = _stk + Calculatereward(_stk, time);

        IERC20(ajidokwuToken).transfer(msg.sender, _amount);
        lastStakedTime[msg.sender] = block.timestamp;

        emit UnstakedSuccessful(msg.sender, _amount);
    }

     function emergencyWithdraw() public {
        if (msg.sender == address(0)){
            revert ADDRESS_ZERO_DETECTED();
        }
        // require(msg.sender != address(0), "Address zero detected");
        // require(stakeBalance[msg.sender] > 0, "no stake to withdraw");
         if(stakeBalance[msg.sender] <= 0){
        revert NO_STAKE_TO_WITHDRAW();
            }
        uint _amount;
        stakeBalance[msg.sender] = _amount;
         TotalStaked -= _amount;
        stakeBalance[msg.sender] = 0;

         IERC20(ajidokwuToken).transfer(msg.sender, _amount);
         emit UnstakedSuccessful(msg.sender, _amount);
        emit UnstakedSuccessful(msg.sender, block.timestamp);
    }

    function Calculatereward(uint256 _amount, uint _timeInSec)public pure returns(uint256){
       uint256 _reward = (_amount * 1 * _timeInSec) / 100000;
       return _reward;
    }

    function checkUserStakedBalance(address _user) external view returns (uint256) {
        return stakeBalance[_user];
    }
    function totalStakedBalance() external view returns (uint256) {
        return TotalStaked;
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
}