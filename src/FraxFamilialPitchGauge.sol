
// File: src/hardhat/contracts/Curve/IFraxGaugeController.sol


import "lib/forge-std/src/console2.sol";


pragma solidity ^0.8.0;

// https://github.com/swervefi/swerve/edit/master/packages/swerve-contracts/interfaces/IGaugeController.sol

interface IFraxGaugeController {
    struct Point {
        uint256 bias;
        uint256 slope;
    }

    struct VotedSlope {
        uint256 slope;
        uint256 power;
        uint256 end;
    }

    // Public variables
    function admin() external view returns (address);
    function future_admin() external view returns (address);
    function token() external view returns (address);
    function voting_escrow() external view returns (address);
    function n_gauge_types() external view returns (int128);
    function n_gauges() external view returns (int128);
    function gauge_type_names(int128) external view returns (string memory);
    function gauges(uint256) external view returns (address);
    function vote_user_slopes(address, address)
        external
        view
        returns (VotedSlope memory);
    function vote_user_power(address) external view returns (uint256);
    function last_user_vote(address, address) external view returns (uint256);
    function points_weight(address, uint256)
        external
        view
        returns (Point memory);
    function time_weight(address) external view returns (uint256);
    function points_sum(int128, uint256) external view returns (Point memory);
    function time_sum(uint256) external view returns (uint256);
    function points_total(uint256) external view returns (uint256);
    function time_total() external view returns (uint256);
    function points_type_weight(int128, uint256)
        external
        view
        returns (uint256);
    function time_type_weight(uint256) external view returns (uint256);

    // Getter functions
    function gauge_types(address) external view returns (int128);
    function gauge_relative_weight(address) external view returns (uint256);
    function gauge_relative_weight(address, uint256) external view returns (uint256);
    function get_gauge_weight(address) external view returns (uint256);
    function get_type_weight(int128) external view returns (uint256);
    function get_total_weight() external view returns (uint256);
    function get_weights_sum_per_type(int128) external view returns (uint256);

    // External functions
    function commit_transfer_ownership(address) external;
    function apply_transfer_ownership() external;
    function add_gauge(
        address,
        int128,
        uint256
    ) external;
    function checkpoint() external;
    function checkpoint_gauge(address) external;
    function global_emission_rate() external view returns (uint256);
    function gauge_relative_weight_write(address)
        external
        returns (uint256);
    function gauge_relative_weight_write(address, uint256)
        external
        returns (uint256);
    function add_type(string memory, uint256) external;
    function change_type_weight(int128, uint256) external;
    function change_gauge_weight(address, uint256) external;
    function change_global_emission_rate(uint256) external;
    function vote_for_gauge_weights(address, uint256) external;
}

// File: src/hardhat/contracts/Curve/IFraxGaugeControllerV2.sol


pragma solidity ^0.8.0;


// https://github.com/swervefi/swerve/edit/master/packages/swerve-contracts/interfaces/IGaugeController.sol

interface IFraxGaugeControllerV2 is IFraxGaugeController {
    struct CorrectedPoint {
        uint256 bias;
        uint256 slope;
        uint256 lock_end;
    }

    function get_corrected_info(address) external view returns (CorrectedPoint memory);
}

// File: src/hardhat/contracts/Curve/IFraxFarm.sol


pragma solidity >=0.8.0;

interface IFraxswap {
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function token0() external view returns (address);

    function token1() external view returns (address);
}

/// @notice Minimalistic IFraxFarmUniV3
interface IFraxFarmUniV3TokenPositions {
    function uni_token0() external view returns (address);

    function uni_token1() external view returns (address);
}

interface IFraxswapERC20 {
    function decimals() external view returns (uint8);
}

interface IFraxFarm {
    function owner() external view returns (address);

    function stakingToken() external view returns (address);

    function fraxPerLPToken() external view returns (uint256);

    function calcCurCombinedWeight(address account)
        external
        view
        returns (
            uint256 old_combined_weight,
            uint256 new_vefxs_multiplier,
            uint256 new_combined_weight
        );

    function periodFinish() external view returns (uint256);

    function getAllRewardTokens() external view returns (address[] memory);

    function earned(address account) external view returns (uint256[] memory new_earned);

    function totalLiquidityLocked() external view returns (uint256);

    function lockedLiquidityOf(address account) external view returns (uint256);

    function totalCombinedWeight() external view returns (uint256);

    function combinedWeightOf(address account) external view returns (uint256);

    function lockMultiplier(uint256 secs) external view returns (uint256);

    function rewardRates(uint256 token_idx) external view returns (uint256 rwd_rate);

    function userStakedFrax(address account) external view returns (uint256);

    function proxyStakedFrax(address proxy_address) external view returns (uint256);

    function maxLPForMaxBoost(address account) external view returns (uint256);

    function minVeFXSForMaxBoost(address account) external view returns (uint256);

    function minVeFXSForMaxBoostProxy(address proxy_address) external view returns (uint256);

    function veFXSMultiplier(address account) external view returns (uint256 vefxs_multiplier);

    function toggleValidVeFXSProxy(address proxy_address) external;

    function proxyToggleStaker(address staker_address) external;

    function stakerSetVeFXSProxy(address proxy_address) external;

    function getReward(address destination_address) external returns (uint256[] memory);

    function getReward(address destination_address, bool also_claim_extra) external returns (uint256[] memory);

    function vefxs_max_multiplier() external view returns (uint256);

    function vefxs_boost_scale_factor() external view returns (uint256);

    function vefxs_per_frax_for_max_boost() external view returns (uint256);

    function getProxyFor(address addr) external view returns (address);

    function sync() external;

    function nominateNewOwner(address _owner) external;

    function acceptOwnership() external;

    function updateRewardAndBalance(address acct, bool sync) external;

    function setRewardVars(
        address reward_token_address,
        uint256 _new_rate,
        address _gauge_controller_address,
        address _rewards_distributor_address
    ) external;

    function calcCurrLockMultiplier(address account, uint256 stake_idx)
        external
        view
        returns (uint256 midpoint_lock_multiplier);

    function staker_designated_proxies(address staker_address) external view returns (address);

    function sync_gauge_weights(bool andForce) external;
}

interface IFraxFarmTransfers {
    function setAllowance(address spender, uint256 lockId, uint256 amount) external;
    function removeAllowance(address spender, uint256 lockId) external;
    function setApprovalForAll(address spender, bool approved) external;
    function isApproved(address staker, uint256 lockId, uint256 amount) external view returns (bool);
    function transferLockedFrom(
        address sender_address,
        address receiver_address,
        uint256 sender_lock_index,
        uint256 transfer_amount,
        bool use_receiver_lock_index,
        uint256 receiver_lock_index
    ) external returns (uint256);

    function transferLocked(
        address receiver_address,
        uint256 sender_lock_index,
        uint256 transfer_amount,
        bool use_receiver_lock_index,
        uint256 receiver_lock_index
    ) external returns (uint256);

    function beforeLockTransfer(address operator, address from, uint256 lockId, bytes calldata data) external returns (bytes4);
    function onLockReceived(address operator, address from, uint256 lockId, bytes memory data) external returns (bytes4);

}

interface IFraxFarmERC20 is IFraxFarm, IFraxFarmTransfers {
    struct LockedStake {
        uint256 start_timestamp;
        uint256 liquidity;
        uint256 ending_timestamp;
        uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
    }

    /// TODO this references the public getter for `lockedStakes` in the contract
    function lockedStakes(address account, uint256 stake_idx) external view returns (LockedStake memory);

    function lockedStakesOf(address account) external view returns (LockedStake[] memory);

    function lockedStakesOfLength(address account) external view returns (uint256);

    function lockAdditional(uint256 lockId, uint256 addl_liq) external;

    function lockLonger(uint256 lockId, uint256 _newUnlockTimestamp) external;

    function stakeLocked(uint256 liquidity, uint256 secs) external returns (uint256);

    function withdrawLocked(uint256 lockId, address destination_address) external returns (uint256);
}

interface IFraxFarmUniV3 is IFraxFarm, IFraxFarmUniV3TokenPositions {
    struct LockedNFT {
        uint256 token_id; // for Uniswap V3 LPs
        uint256 liquidity;
        uint256 start_timestamp;
        uint256 ending_timestamp;
        uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
        int24 tick_lower;
        int24 tick_upper;
    }

    function uni_tick_lower() external view returns (int24);

    function uni_tick_upper() external view returns (int24);

    function uni_required_fee() external view returns (uint24);

    function lockedNFTsOf(address account) external view returns (LockedNFT[] memory);

    function lockedNFTsOfLength(address account) external view returns (uint256);

    function lockAdditional(
        uint256 token_id,
        uint256 token0_amt,
        uint256 token1_amt,
        uint256 token0_min_in,
        uint256 token1_min_in,
        bool use_balof_override
    ) external;

    function stakeLocked(uint256 token_id, uint256 secs) external;

    function withdrawLocked(uint256 token_id, address destination_address) external;
}

// File: src/hardhat/contracts/Staking/Owned.sol


pragma solidity >=0.6.11;

// https://docs.synthetix.io/contracts/Owned
contract Owned {
    address public owner;
    address public nominatedOwner;

    constructor (address _owner) public {
        require(_owner != address(0), "Owner address cannot be 0");
        owner = _owner;
        emit OwnerChanged(address(0), _owner);
    }

    function nominateNewOwner(address _owner) external onlyOwner {
        nominatedOwner = _owner;
        emit OwnerNominated(_owner);
    }

    function acceptOwnership() external {
        require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
        emit OwnerChanged(owner, nominatedOwner);
        owner = nominatedOwner;
        nominatedOwner = address(0);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner may perform this action");
        _;
    }

    event OwnerNominated(address newOwner);
    event OwnerChanged(address oldOwner, address newOwner);
}
// File: src/hardhat/contracts/Uniswap/TransferHelper.sol


pragma solidity >=0.6.11;

// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
library TransferHelper {
    function safeApprove(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
    }

    function safeTransfer(address token, address to, uint value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
    }

    function safeTransferFrom(address token, address from, address to, uint value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
    }

    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}
// File: src/hardhat/contracts/Curve/IFraxGaugeFXSRewardsDistributor.sol


pragma solidity ^0.8.0;

interface IFraxGaugeFXSRewardsDistributor {
  function acceptOwnership() external;
  function curator_address() external view returns(address);
  function currentReward(address gauge_address) external view returns(uint256 reward_amount);
  function distributeReward(address gauge_address) external returns(uint256 weeks_elapsed, uint256 reward_tally);
  function distributionsOn() external view returns(bool);
  function gauge_whitelist(address) external view returns(bool);
  function is_middleman(address) external view returns(bool);
  function last_time_gauge_paid(address) external view returns(uint256);
  function nominateNewOwner(address _owner) external;
  function nominatedOwner() external view returns(address);
  function owner() external view returns(address);
  function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
  function setCurator(address _new_curator_address) external;
  function setGaugeController(address _gauge_controller_address) external;
  function setGaugeState(address _gauge_address, bool _is_middleman, bool _is_active) external;
  function setTimelock(address _new_timelock) external;
  function timelock_address() external view returns(address);
  function toggleDistributions() external;
}
// File: src/hardhat/contracts/Curve/FraxFamilialPitchGauge.sol


pragma solidity ^0.8.17;

// ====================================================================
// |     ______                   _______                             |
// |    / _____________ __  __   / ____(_____  ____ _____  ________   |
// |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
// |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
// | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
// |                                                                  |
// ====================================================================
// ======================== FraxMiddlemanGauge ========================
// ====================================================================
// Looks at the gauge controller contract and pushes out FXS rewards once
// a week to the gauges (farms).
// This contract is what gets added to the gauge as a 'slice'

// Frax Finance: https://github.com/FraxFinance

// Primary Author(s)
// Travis Moore: https://github.com/FortisFortuna

// Reviewer(s) / Contributor(s)
// Jason Huan: https://github.com/jasonhuan
// Sam Kazemian: https://github.com/samkazemian

// import "../Math/Math.sol";
// import "../Math/SafeMath.sol";
// import "../ERC20/ERC20.sol";
// import "../ERC20/SafeERC20.sol";



// import "../Utils/ReentrancyGuard.sol";



/**
*   @title FraxFamilialPitchGauge
*   @notice Redistributes gauge rewards to multiple gauges (FraxFarms) based on each "child" gauge's `total_combined_weight`.
*   @author Modified version of the FraxMiddlemanGauge - by ZrowGz @ Pitch Foundation
*   @dev To use this:
*       - Add to GaugeController as a gauge
*       - Add to FXS Rewards Distributor as a gauge
*           * BUT do not set as a middleman gauge on the FXS Rewards Distributor
*       - Set as the `gaugeController` & `rewardsDistributor` on all children FraxFarms
*       - Disable rewards for pre-existing gauges on the FXS Rewards Distributor
*/

contract FraxFamilialPitchGauge is Owned {//, ReentrancyGuard {
    // using SafeMath for uint256;
    // using SafeERC20 for ERC20;

    // error LatestPeriodNotFinished(uint256,uint256);

    /* ========== STATE VARIABLES ========== */
    /// Note: variables made internal for execution gas savings, available through getters below

    // Informational
    string public name;

    ///// State Address Storage /////
    /// @notice Address of the timelock
    address internal timelock_address;
    /// @notice Address of the gauge controller
    address internal immutable gauge_controller;
    /// @notice Address of the FXS Rewards Distributor
    address internal immutable rewards_distributor;
    /// @notice Address of the rewardToken
    address internal immutable reward_token; // = 0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0; // FXS

    ///// Familial Gauge Storage /////
    /// @notice Array of all child gauges
    address[] internal gauges;
    /// @notice Whether a child gauge is active or not
    mapping(address => bool) internal gauge_active;
    /// @notice Global reward emission rate from Controller
    uint256 internal global_emission_rate_stored;
    /// @notice Time of the last vote from Controller
    uint256 internal time_total_stored;

    /// @notice Total vote weight from gauge controller vote
    uint256 internal total_familial_relative_weight;
    /// @notice Redistributed relative gauge weights by gauge combined weight
    mapping(address => uint256) internal gauge_to_last_relative_weight;

    /// @notice Sum of all child gauge `total_combined_weight`
    uint256 internal familial_total_combined_weight;
    /// @notice Each gauge's combined weight for this reward epoch, available at the farm
    mapping(address => uint256) internal gauge_to_total_combined_weight;
    
    // Distributor provided 
    /// @notice The timestamp of the vote period
    uint256 public weeks_elapsed;
    /// @notice The amount of FXS awarded to the family by the vote, from the Distributor
    uint256 public reward_tally;
    /// @notice The redistributed FXS rewards payable to each child gauge
    mapping(address => uint256) internal gauge_to_reward_tally;

    // Reward period & Time tracking
    /// @notice The timestamp of the last reward period
    uint256 internal periodFinish;
    /// @notice The number of seconds in a week
    uint256 internal constant rewardsDuration = 604800; // 7 * 86400  (7 days)
    /// @notice For the first time children are added, pull in the reward period finish for each.
    bool internal isFirstTimeAddingGauges;

    /* ========== MODIFIERS ========== */

    modifier onlyByOwnGov() {
        require(msg.sender == owner || msg.sender == timelock_address, "Not owner or timelock");
        _;
    }

    /* ========== CONSTRUCTOR ========== */

    constructor (
        string memory _name,
        address _owner,
        address _timelock_address,
        address _rewards_distributor,
        address _gauge_controller,
        address _reward_token
    ) Owned(_owner) {
        name = _name;
        timelock_address = _timelock_address;
        rewards_distributor = _rewards_distributor;
        gauge_controller = _gauge_controller;
        reward_token = _reward_token;
    }

    /* ========== MUTATIVE FUNCTIONS ========== */
    uint256 public gaugeRelativeWriteCounter;
    /// This should only have the full recalculation logic ran once per epoch.
    /// The first gauge to call this will trigger the full tvl & weight recalc
    /// As other familial gauges call it, they'll be able to obtain the updated values from storage
    /// The farm must call this through the `sync_gauge_weights` or `sync` functions
    /// @notice Updates the relative weights of all child gauges
    /// @dev Note: unfortunately many of the steps in this process need to be done after completing previous step for all children
    //       - this results in numerous for loops being used
    function gauge_relative_weight_write(address child_gauge, uint256 timestamp) external returns (uint256) {
        console2.log("gauge_relative_weight_write", child_gauge, timestamp);
        console2.log("gaugeRelativeWriteCounter", gaugeRelativeWriteCounter);
        gaugeRelativeWriteCounter++;
        // check that the child gauge is active
        require(gauge_active[child_gauge], "Gauge not active");

        // If now is after the last time everything was updated, obtain all values for all gauges & recalculate new rebalanced weights
        if (block.timestamp > time_total_stored) {
            console2.log("block.timestamp > time_total_stored", block.timestamp, time_total_stored);
            //// First, update all the state variables applicable to all child gauges
            // store the most recent time_total for the farms to use & prevent this logic from being executed until epoch
            time_total_stored = IFraxGaugeController(gauge_controller).time_total();//latest_time_total;

            // get & set the gauge controller's last global emission rate
            // note this should be the same for all gauges, but if there were to be multiple controllers,
            // we would need to have the emission rate for each of them.
            global_emission_rate_stored = IFraxGaugeController(gauge_controller).global_emission_rate();//gauge_to_controller[gauges[i]]).global_emission_rate();

            // to prevent re-calling the first gauge
            address _gauge_calling;
            for (uint256 i; i < gauges.length; i++) {
                if (child_gauge == gauges[i]) {
                    _gauge_calling = gauges[i];
                    console2.log("gauge calling found! caller, gauge input, msg.sender", _gauge_calling);
                }
            }

            /// NOTE requiring caller to be `msg.sender` ensures all gauges are distributed to.
            ///      To access this function, must call `sync_gauge_weights` on the gauge, which will call this
            // require it to be one of the child gauges to ensure correctly updating all children
            require(_gauge_calling == child_gauge && child_gauge == msg.sender, "Not a child gauge");

            // zero out the stored familial combined weight
            familial_total_combined_weight = 0;

            // get the familial vote weight for this period
            total_familial_relative_weight = 
                IFraxGaugeController(gauge_controller).gauge_relative_weight_write(address(this), timestamp);
            console2.log("total_familial_relative_weight", total_familial_relative_weight);
            // update all the gauge weights
            for (uint256 i; i < gauges.length; i++) {
                // it shouldn't be zero, unless we don't use `delete` to remove a gauge
                if (gauge_active[gauges[i]]) { 
                    console2.log("active gauge loop", i, gauges[i]);
                    /// update the child gauges' total combined weights
                    gauge_to_total_combined_weight[gauges[i]] = IFraxFarm(gauges[i]).totalCombinedWeight();
                    console2.log("gauge_to_total_combined_weight", gauges[i], gauge_to_total_combined_weight[gauges[i]]);
                    familial_total_combined_weight += gauge_to_total_combined_weight[gauges[i]];
                    console2.log("familial_total_combined_weight", familial_total_combined_weight);
                }
            }

            // divvy up the relative weights based on each gauges `total combined weight` 
            for (uint256 i; i < gauges.length; i++) {
                if (gauge_active[gauges[i]]) { 
                    console2.log("updating guage total combined weights rebalancing", i);
                    gauge_to_last_relative_weight[gauges[i]] = 
                        gauge_to_total_combined_weight[gauges[i]] * total_familial_relative_weight / familial_total_combined_weight;
                        console2.log("gauge_to_last_relative_weight", gauges[i], gauge_to_last_relative_weight[gauges[i]]);
                }
            }

            // pull in the reward tokens allocated to the fam
            (weeks_elapsed, reward_tally) = IFraxGaugeFXSRewardsDistributor(rewards_distributor).distributeReward(address(this));
            emit FamilialRewardClaimed(address(this), weeks_elapsed, reward_tally);
            console2.log("rewards claimed from distributor", weeks_elapsed, reward_tally);
            // divide the reward_tally amount by the gauge's allocation
            // note this will be used when the farm calls `distributeReward`
            for (uint256 i; i < gauges.length; i++) {
                if (gauge_active[gauges[i]]) { 
                    gauge_to_reward_tally[gauges[i]] = reward_tally * gauge_to_total_combined_weight[gauges[i]] / familial_total_combined_weight;
                    console2.log("gauge_to_reward_tally", gauges[i], gauge_to_reward_tally[gauges[i]]);
                }
            }

            // call `sync_gauge_weights` on the other gauges
            for (uint256 i; i < gauges.length; i++) {
                if (gauges[i] != _gauge_calling && gauge_active[gauges[i]]) {
                    console2.log("calling sync_gauge_weights on other gauges", i, gauges[i]);
                    IFraxFarm(gauges[i]).sync_gauge_weights(true);
                    console2.log("gauge weights synced!", i, gauges[i]);
                }
            }
            /// Now all farms should have their relative weights updated. Let the calling farm finish execution
        }
        console2.log("gauge weight write return value, gauge, msgsender, called counter", child_gauge, msg.sender, gaugeRelativeWriteCounter);
        // finally, return the gauge's (msg.sender) rebalanced relative weight
        console2.log("gauge_to_last_relative_weight", gauge_to_last_relative_weight[child_gauge]);
        return gauge_to_last_relative_weight[child_gauge];
    }
    uint256 distributeRewardCounter;
    /// This is called by the farm during `retroCatchUp`
    /// If this is registered as a middleman gauge, distributor will call pullAndBridge, which will distribute the reward to the gauge
    /// note it might be easier to NOT set this as a middleman on the distributor
    /// Needs to be reentered to allow all farms to execute in one call, so is only callable by a gauge
    function distributeReward(address child_gauge) public returns (uint256, uint256) {
        console2.log("FAMILY: distributeReward() called by", msg.sender);
        console2.log("distribute reward call counter", distributeRewardCounter);
        distributeRewardCounter++;
        // check that the child gauge is active
        require(gauge_active[child_gauge], "Gauge not active");

        if (block.timestamp >= periodFinish) {
            console2.log("FAMILY: distributeReward() periodFinish reached");
            // Ensure the provided reward amount is not more than the balance in the contract.
            // This keeps the reward rate in the right range, preventing overflows due to
            // very high values of rewardRate in the earned and rewardsPerToken functions;
            // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
            uint256 num_periods_elapsed = uint256(block.timestamp - periodFinish) / rewardsDuration; // Floor division to the nearest period

            // lastUpdateTime = periodFinish;
            // update period finish here so that the next call to `distributeReward` will bypapss this logic
            periodFinish = periodFinish + ((num_periods_elapsed + 1) * rewardsDuration);

            // to prevent re-calling the first gauge during the farm `sync` calls
            address _gauge_calling;
            for (uint256 i; i < gauges.length; i++) {
                console2.log("FAMILY: distributeReward() set `_gauge_calling`", i, gauges[i]);
                if (child_gauge == gauges[i]) {
                    _gauge_calling = gauges[i];
                    console2.log("gauge calling is", _gauge_calling);
                }
            }

            /// NOTE requiring caller to be `msg.sender` ensures all gauges are distributed to.
            ///      To access this function, must call `sync` on the gauge, which will call this
            // require it to be one of the child gauges to ensure correctly updating all children
            require(_gauge_calling == child_gauge && child_gauge == msg.sender, "Not a child gauge");

            // now that this logic won't be ran on the next call & all gauges are within periodFinish, call each farm's `sync`
            for (uint256 i; i < gauges.length; i++) {
                if (gauges[i] != _gauge_calling && gauge_active[gauges[i]]) {
                    console2.log("calling sync on gauges", i, gauges[i]);
                    IFraxFarm(gauges[i]).sync();
                    console2.log("SYNCED", gauges[i]);
                }
            }
            console2.log("completed farm syncing");
            console2.log("distribute reward call counter", distributeRewardCounter);
            distributeRewardCounter = 0;
            console2.log("distribute reward call counter", distributeRewardCounter);
            /// Now all gauges should have their rewards distributed. Let the calling gauge finish execution.
        }
        console2.log("Distribute REWARD, post periodFinish check", child_gauge, gauge_to_reward_tally[child_gauge]);
        // preserve the gauge's reward tally for returning to the gauge
        uint256 claimingGaugeRewardTally = gauge_to_reward_tally[child_gauge];
        console2.log("Gauge reward tally", child_gauge, claimingGaugeRewardTally);
        
        /// when the reward is distributed, send the amount in gauge_to_reward_tally to the gauge & zero that value out
        TransferHelper.safeTransfer(reward_token, child_gauge, claimingGaugeRewardTally);
        
        // reset the reward tally to zero for the gauge
        gauge_to_reward_tally[child_gauge] = 0;
        emit ChildGaugeRewardDistributed(child_gauge, gauge_to_reward_tally[child_gauge]);
        
        return (weeks_elapsed, claimingGaugeRewardTally);
    }

    /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
    
    // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
    function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyByOwnGov {
        // Only the owner address can ever receive the recovery withdrawal
        TransferHelper.safeTransfer(tokenAddress, owner, tokenAmount);
        emit RecoveredERC20(tokenAddress, tokenAmount);
    }

    // Generic proxy
    function execute(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyByOwnGov returns (bool, bytes memory) {
        (bool success, bytes memory result) = _to.call{value:_value}(_data);
        return (success, result);
    }

    function setTimelock(address _new_timelock) external onlyByOwnGov {
        timelock_address = _new_timelock;
    }

    function addChildGauge(address[] calldata _gauges) external onlyByOwnGov {
        gauges = _gauges;
        // set the latest period finish for the child gauges
        for (uint256 i; i < gauges.length; i++) {
            // set gauge to active
            gauge_active[_gauges[i]] = true;

            emit ChildGaugeAdded(_gauges[i], gauges.length - 1);

            if (isFirstTimeAddingGauges) {
                uint256 childGaugePeriodFinish = IFraxFarm(gauges[i]).periodFinish();
                if (childGaugePeriodFinish > periodFinish) {
                    periodFinish = childGaugePeriodFinish;
                }
            }
        }
        // don't need to re-run that lookup to sync in the future
        if (isFirstTimeAddingGauges) {
            isFirstTimeAddingGauges = false;
        }
    }

    function deactivateChildGauge(uint256 _gaugeIndex) external onlyByOwnGov {
        emit ChildGaugeDeactivated(gauges[_gaugeIndex], _gaugeIndex);
        gauge_active[gauges[_gaugeIndex]] = false;
    }

    // function setRewardsDistributor(address _rewards_distributor) external onlyByOwnGov {
    //     emit RewardsDistributorChanged(rewards_distributor, _rewards_distributor);
    //     rewards_distributor = _rewards_distributor;
    // }

    // function setGaugeController(address _gauge_controller) external onlyByOwnGov {
    //     emit GaugeControllerChanged(gauge_controller, _gauge_controller);
    //     gauge_controller = _gauge_controller;
    // }

    /* ========== GETTERS ========== */

    /// @notice Matches the abi available in the farms 
    /// @return global_emission_rate The global emission rate from the controller
    function global_emission_rate() external view returns (uint256) {
        return global_emission_rate_stored;
    }

    /// @notice Matches the abi available in the farms
    /// @return time_total The end of the vote period from the controller
    function time_total() external view returns (uint256) {
        return time_total_stored;
    }

    
    function getNumberOfGauges() external view returns (uint256) {
        return gauges.length;
    }

    function getChildGauges() external view returns (address[] memory) {
        return gauges;
    }

    function getGaugeState(address _gauge) external view returns (bool) {
        return gauge_active[_gauge];
    }

    function getStateAddresses() external view returns (address, address, address, address) {
        return (timelock_address, gauge_controller, rewards_distributor, reward_token);
    }

    /// @notice Returns the last relative weight and reward tally for a gauge
    /// @return last_relative_weight The redistributed last relative weight of the gauge
    /// @return reward_tally The redistributed reward tally of the gauge
    function getChildGaugeValues(address child_gauge) external view returns (uint256, uint256) {
        return (
            gauge_to_last_relative_weight[child_gauge],
            gauge_to_reward_tally[child_gauge]
        );
    }

    /// @notice Returns the `periodFinish` stored
    /// @return periodFinish The periodFinish timestamp when gauges can call to distribute rewards
    function getPeriodFinish() external view returns (uint256) {
        return periodFinish;
    }

    /* ========== EVENTS ========== */
    event ChildGaugeAdded(address gauge, uint256 gauge_index);
    event ChildGaugeDeactivated(address gauge, uint256 gauge_index);
    event GaugeControllerChanged(address old_controller, address new_controller);
    event RewardsDistributorChanged(address old_distributor, address new_distributor);
    event FamilialRewardClaimed(address familial_gauge, uint256 reward_amount, uint256 weeks_elapsed);
    event ChildGaugeRewardDistributed(address gauge, uint256 reward_amount);
    event RecoveredERC20(address token, uint256 amount);
}