// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

contract MockRewardsDistributor {
    uint256 _weeks_elapsed;
    uint256 _reward_tally;

    constructor(uint256 weeks_elapsed, uint256 reward_tally) {
        _weeks_elapsed = weeks_elapsed;
        _reward_tally = reward_tally;
    }

    function distributeReward(address gauge_address)
        external
        view
        returns (uint256 weeks_elapsed, uint256 reward_tally)
    {
        gauge_address;
        return (_weeks_elapsed, _reward_tally);
    }
}
