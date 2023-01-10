// SPDX-License-Identifier: GPL-2.0-or-later
// File: src/hardhat/contracts/Misc_AMOs/convex/IConvexBaseRewardPool.sol


pragma solidity 0.8.17;

// interface IConvexBaseRewardPool {
//   function addExtraReward(address _reward) external returns (bool);
//   function balanceOf(address account) external view returns (uint256);
//   function clearExtraRewards() external;
//   function currentRewards() external view returns (uint256);
//   function donate(uint256 _amount) external returns (bool);
//   function duration() external view returns (uint256);
//   function earned(address account) external view returns (uint256);
//   function extraRewards(uint256) external view returns (address);
//   function extraRewardsLength() external view returns (uint256);
//   function getReward() external returns (bool);
//   function getReward(address _account, bool _claimExtras) external returns (bool);
//   function historicalRewards() external view returns (uint256);
//   function lastTimeRewardApplicable() external view returns (uint256);
//   function lastUpdateTime() external view returns (uint256);
//   function newRewardRatio() external view returns (uint256);
//   function operator() external view returns (address);
//   function periodFinish() external view returns (uint256);
//   function pid() external view returns (uint256);
//   function queueNewRewards(uint256 _rewards) external returns (bool);
//   function queuedRewards() external view returns (uint256);
//   function rewardManager() external view returns (address);
//   function rewardPerToken() external view returns (uint256);
//   function rewardPerTokenStored() external view returns (uint256);
//   function rewardRate() external view returns (uint256);
//   function rewardToken() external view returns (address);
//   function rewards(address) external view returns (uint256);
//   function stake(uint256 _amount) external returns (bool);
//   function stakeAll() external returns (bool);
//   function stakeFor(address _for, uint256 _amount) external returns (bool);
//   function stakingToken() external view returns (address);
//   function totalSupply() external view returns (uint256);
//   function userRewardPerTokenPaid(address) external view returns (uint256);
//   function withdraw(uint256 amount, bool claim) external returns (bool);
//   function withdrawAll(bool claim) external;
//   function withdrawAllAndUnwrap(bool claim) external;
//   function withdrawAndUnwrap(uint256 amount, bool claim) external returns (bool);
// }
// // File: src/hardhat/contracts/Staking/OwnedV2.sol


// // https://docs.synthetix.io/contracts/Owned
// contract OwnedV2 {
//     error OwnerCannotBeZero();
//     error InvalidOwnershipAcceptance();
//     error OnlyOwner();

//     address public owner;
//     address public nominatedOwner;

//     constructor (address _owner) {
//         // require(_owner != address(0), "Owner address cannot be 0");
//         if(_owner == address(0)) revert OwnerCannotBeZero();
//         owner = _owner;
//         emit OwnerChanged(address(0), _owner);
//     }

//     function nominateNewOwner(address _owner) external onlyOwner {
//         nominatedOwner = _owner;
//         emit OwnerNominated(_owner);
//     }

//     function acceptOwnership() external {
//         // require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
//         if(msg.sender != nominatedOwner) revert InvalidOwnershipAcceptance();
//         emit OwnerChanged(owner, nominatedOwner);
//         owner = nominatedOwner;
//         nominatedOwner = address(0);
//     }

//     modifier onlyOwner {
//         // require(msg.sender == owner, "Only the contract owner may perform this action");
//         if(msg.sender != owner) revert OnlyOwner();
//         _;
//     }

//     event OwnerNominated(address newOwner);
//     event OwnerChanged(address oldOwner, address newOwner);
// }
// // File: src/hardhat/contracts/Utils/ReentrancyGuardV2.sol


// /**
//  * @dev Contract module that helps prevent reentrant calls to a function.
//  *
//  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
//  * available, which can be applied to functions to make sure there are no nested
//  * (reentrant) calls to them.
//  *
//  * Note that because there is a single `nonReentrant` guard, functions marked as
//  * `nonReentrant` may not call one another. This can be worked around by making
//  * those functions `private`, and then adding `external` `nonReentrant` entry
//  * points to them.
//  *
//  * TIP: If you would like to learn more about reentrancy and alternative ways
//  * to protect against it, check out our blog post
//  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
//  */
// abstract contract ReentrancyGuard {
//     error ReentrancyGuardFailure();
//     // Booleans are more expensive than uint256 or any type that takes up a full
//     // word because each write operation emits an extra SLOAD to first read the
//     // slot's contents, replace the bits taken up by the boolean, and then write
//     // back. This is the compiler's defense against contract upgrades and
//     // pointer aliasing, and it cannot be disabled.

//     // The values being non-zero value makes deployment a bit more expensive,
//     // but in exchange the refund on every call to nonReentrant will be lower in
//     // amount. Since refunds are capped to a percentage of the total
//     // transaction's gas, it is best to keep them low in cases like this one, to
//     // increase the likelihood of the full refund coming into effect.
//     uint256 private constant _NOT_ENTERED = 1;
//     uint256 private constant _ENTERED = 2;

//     uint256 private _status;

//     constructor () {
//         _status = _NOT_ENTERED;
//     }

//     /**
//      * @dev Prevents a contract from calling itself, directly or indirectly.
//      * Calling a `nonReentrant` function from another `nonReentrant`
//      * function is not supported. It is possible to prevent this from happening
//      * by making the `nonReentrant` function external, and make it call a
//      * `private` function that does the actual work.
//      */
//     modifier nonReentrant() {
//         // On the first call to nonReentrant, _notEntered will be true
//         // require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
//         if(_status == _ENTERED) revert ReentrancyGuardFailure();
//         // Any calls to nonReentrant after this point will fail
//         _status = _ENTERED;

//         _;

//         // By storing the original value once again, a refund is triggered (see
//         // https://eips.ethereum.org/EIPS/eip-2200)
//         _status = _NOT_ENTERED;
//     }
// }
// // File: src/hardhat/contracts/Uniswap/TransferHelperV2.sol




// // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
// library TransferHelperV2 {
//     error TranferHelperApproveFailed();
//     error TranferHelperTransferFailed();
//     error TranferHelperTransferFromFailed();
//     error TranferHelperTransferETHFailed();
//     function safeApprove(address token, address to, uint value) internal {
//         // bytes4(keccak256(bytes('approve(address,uint256)')));
//         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
//         // require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
//         if(!success || (data.length != 0 && !abi.decode(data, (bool)))) revert TranferHelperApproveFailed();
//     }

//     function safeTransfer(address token, address to, uint value) internal {
//         // bytes4(keccak256(bytes('transfer(address,uint256)')));
//         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
//         // require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
//         if(!success || (data.length != 0 && !abi.decode(data, (bool)))) revert TranferHelperTransferFailed();
//     }

//     function safeTransferFrom(address token, address from, address to, uint value) internal {
//         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
//         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
//         // require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
//         if(!success || (data.length != 0 && !abi.decode(data, (bool)))) revert TranferHelperTransferFromFailed();
//     }

//     function safeTransferETH(address to, uint value) internal {
//         (bool success,) = to.call{value:value}(new bytes(0));
//         // require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
//         if(!success) revert TranferHelperTransferETHFailed();
//     }
// }
// // File: src/hardhat/contracts/Common/ContextV2.sol


// // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

// /**
//  * @dev Provides information about the current execution context, including the
//  * sender of the transaction and its data. While these are generally available
//  * via msg.sender and msg.data, they should not be accessed in such a direct
//  * manner, since when dealing with meta-transactions the account sending and
//  * paying for execution may not be the actual sender (as far as an application
//  * is concerned).
//  *
//  * This contract is only required for intermediate, library-like contracts.
//  */
// abstract contract Context {
//     function _msgSender() internal view virtual returns (address) {
//         return msg.sender;
//     }

//     function _msgData() internal view virtual returns (bytes calldata) {
//         return msg.data;
//     }
// }
// // File: src/hardhat/contracts/ERC20/IERC20V2.sol


// // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)


// // import "../Math/SafeMath.sol";

// /**
//  * @dev Interface of the ERC20 standard as defined in the EIP.
//  */
// interface IERC20 {
//     /**
//      * @dev Emitted when `value` tokens are moved from one account (`from`) to
//      * another (`to`).
//      *
//      * Note that `value` may be zero.
//      */
//     event Transfer(address indexed from, address indexed to, uint256 value);

//     /**
//      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
//      * a call to {approve}. `value` is the new allowance.
//      */
//     event Approval(address indexed owner, address indexed spender, uint256 value);

//     /**
//      * @dev Returns the amount of tokens in existence.
//      */
//     function totalSupply() external view returns (uint256);

//     /**
//      * @dev Returns the amount of tokens owned by `account`.
//      */
//     function balanceOf(address account) external view returns (uint256);

//     /**
//      * @dev Moves `amount` tokens from the caller's account to `to`.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transfer(address to, uint256 amount) external returns (bool);

//     /**
//      * @dev Returns the remaining number of tokens that `spender` will be
//      * allowed to spend on behalf of `owner` through {transferFrom}. This is
//      * zero by default.
//      *
//      * This value changes when {approve} or {transferFrom} are called.
//      */
//     function allowance(address owner, address spender) external view returns (uint256);

//     /**
//      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * IMPORTANT: Beware that changing an allowance with this method brings the risk
//      * that someone may use both the old and the new allowance by unfortunate
//      * transaction ordering. One possible solution to mitigate this race
//      * condition is to first reduce the spender's allowance to 0 and set the
//      * desired value afterwards:
//      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
//      *
//      * Emits an {Approval} event.
//      */
//     function approve(address spender, uint256 amount) external returns (bool);

//     /**
//      * @dev Moves `amount` tokens from `from` to `to` using the
//      * allowance mechanism. `amount` is then deducted from the caller's
//      * allowance.
//      *
//      * Returns a boolean value indicating whether the operation succeeded.
//      *
//      * Emits a {Transfer} event.
//      */
//     function transferFrom(address from, address to, uint256 amount) external returns (bool);
// }
// // File: src/hardhat/contracts/Curve/IFraxGaugeFXSRewardsDistributor.sol

// interface IFraxGaugeFXSRewardsDistributor {
//   function acceptOwnership() external;
//   function curator_address() external view returns(address);
//   function currentReward(address gauge_address) external view returns(uint256 reward_amount);
//   function distributeReward(address gauge_address) external returns(uint256 weeks_elapsed, uint256 reward_tally);
//   function distributionsOn() external view returns(bool);
//   function gauge_whitelist(address) external view returns(bool);
//   function is_middleman(address) external view returns(bool);
//   function last_time_gauge_paid(address) external view returns(uint256);
//   function nominateNewOwner(address _owner) external;
//   function nominatedOwner() external view returns(address);
//   function owner() external view returns(address);
//   function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
//   function setCurator(address _new_curator_address) external;
//   function setGaugeController(address _gauge_controller_address) external;
//   function setGaugeState(address _gauge_address, bool _is_middleman, bool _is_active) external;
//   function setTimelock(address _new_timelock) external;
//   function timelock_address() external view returns(address);
//   function toggleDistributions() external;
// }
// // File: src/hardhat/contracts/Curve/IFraxGaugeController.sol



// // https://github.com/swervefi/swerve/edit/master/packages/swerve-contracts/interfaces/IGaugeController.sol

// interface IFraxGaugeController {
//     struct Point {
//         uint256 bias;
//         uint256 slope;
//     }

//     struct VotedSlope {
//         uint256 slope;
//         uint256 power;
//         uint256 end;
//     }

//     // Public variables
//     function admin() external view returns (address);
//     function future_admin() external view returns (address);
//     function token() external view returns (address);
//     function voting_escrow() external view returns (address);
//     function n_gauge_types() external view returns (int128);
//     function n_gauges() external view returns (int128);
//     function gauge_type_names(int128) external view returns (string memory);
//     function gauges(uint256) external view returns (address);
//     function vote_user_slopes(address, address)
//         external
//         view
//         returns (VotedSlope memory);
//     function vote_user_power(address) external view returns (uint256);
//     function last_user_vote(address, address) external view returns (uint256);
//     function points_weight(address, uint256)
//         external
//         view
//         returns (Point memory);
//     function time_weight(address) external view returns (uint256);
//     function points_sum(int128, uint256) external view returns (Point memory);
//     function time_sum(uint256) external view returns (uint256);
//     function points_total(uint256) external view returns (uint256);
//     function time_total() external view returns (uint256);
//     function points_type_weight(int128, uint256)
//         external
//         view
//         returns (uint256);
//     function time_type_weight(uint256) external view returns (uint256);

//     // Getter functions
//     function gauge_types(address) external view returns (int128);
//     function gauge_relative_weight(address) external view returns (uint256);
//     function gauge_relative_weight(address, uint256) external view returns (uint256);
//     function get_gauge_weight(address) external view returns (uint256);
//     function get_type_weight(int128) external view returns (uint256);
//     function get_total_weight() external view returns (uint256);
//     function get_weights_sum_per_type(int128) external view returns (uint256);

//     // External functions
//     function commit_transfer_ownership(address) external;
//     function apply_transfer_ownership() external;
//     function add_gauge(
//         address,
//         int128,
//         uint256
//     ) external;
//     function checkpoint() external;
//     function checkpoint_gauge(address) external;
//     function global_emission_rate() external view returns (uint256);
//     function gauge_relative_weight_write(address)
//         external
//         returns (uint256);
//     function gauge_relative_weight_write(address, uint256)
//         external
//         returns (uint256);
//     function add_type(string memory, uint256) external;
//     function change_type_weight(int128, uint256) external;
//     function change_gauge_weight(address, uint256) external;
//     function change_global_emission_rate(uint256) external;
//     function vote_for_gauge_weights(address, uint256) external;
// }

// // File: src/hardhat/contracts/Curve/IFraxGaugeControllerV2.sol



// // https://github.com/swervefi/swerve/edit/master/packages/swerve-contracts/interfaces/IGaugeController.sol

// interface IFraxGaugeControllerV2 is IFraxGaugeController {
//     struct CorrectedPoint {
//         uint256 bias;
//         uint256 slope;
//         uint256 lock_end;
//     }

//     function get_corrected_info(address) external view returns (CorrectedPoint memory);
// }

// // File: src/hardhat/contracts/Curve/IveFXS.sol


// interface IveFXS {

//     struct LockedBalance {
//         int128 amount;
//         uint256 end;
//     }

//     function commit_transfer_ownership(address addr) external;
//     function apply_transfer_ownership() external;
//     function commit_smart_wallet_checker(address addr) external;
//     function apply_smart_wallet_checker() external;
//     function toggleEmergencyUnlock() external;
//     function recoverERC20(address token_addr, uint256 amount) external;
//     function get_last_user_slope(address addr) external view returns (int128);
//     function user_point_history__ts(address _addr, uint256 _idx) external view returns (uint256);
//     function locked__end(address _addr) external view returns (uint256);
//     function checkpoint() external;
//     function deposit_for(address _addr, uint256 _value) external;
//     function create_lock(uint256 _value, uint256 _unlock_time) external;
//     function increase_amount(uint256 _value) external;
//     function increase_unlock_time(uint256 _unlock_time) external;
//     function withdraw() external;
//     function balanceOf(address addr) external view returns (uint256);
//     function balanceOf(address addr, uint256 _t) external view returns (uint256);
//     function balanceOfAt(address addr, uint256 _block) external view returns (uint256);
//     function totalSupply() external view returns (uint256);
//     function totalSupply(uint256 t) external view returns (uint256);
//     function totalSupplyAt(uint256 _block) external view returns (uint256);
//     function totalFXSSupply() external view returns (uint256);
//     function totalFXSSupplyAt(uint256 _block) external view returns (uint256);
//     function changeController(address _newController) external;
//     function token() external view returns (address);
//     function supply() external view returns (uint256);
//     function locked(address addr) external view returns (LockedBalance memory);
//     function epoch() external view returns (uint256);
//     function point_history(uint256 arg0) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
//     function user_point_history(address arg0, uint256 arg1) external view returns (int128 bias, int128 slope, uint256 ts, uint256 blk, uint256 fxs_amt);
//     function user_point_epoch(address arg0) external view returns (uint256);
//     function slope_changes(uint256 arg0) external view returns (int128);
//     function controller() external view returns (address);
//     function transfersEnabled() external view returns (bool);
//     function emergencyUnlockActive() external view returns (bool);
//     function name() external view returns (string memory);
//     function symbol() external view returns (string memory);
//     function version() external view returns (string memory);
//     function decimals() external view returns (uint256);
//     function future_smart_wallet_checker() external view returns (address);
//     function smart_wallet_checker() external view returns (address);
//     function admin() external view returns (address);
//     function future_admin() external view returns (address);
// }
// // File: src/hardhat/contracts/Math/MathV2.sol


// // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)

// /**
//  * @dev Standard math utilities missing in the Solidity language.
//  */
// library Math {
//     /**
//      * @dev Returns the largest of two numbers.
//      */
//     function max(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a > b ? a : b;
//     }

//     /**
//      * @dev Returns the smallest of two numbers.
//      */
//     function min(uint256 a, uint256 b) internal pure returns (uint256) {
//         return a < b ? a : b;
//     }

//     /**
//      * @dev Returns the average of two numbers. The result is rounded towards
//      * zero.
//      */
//     function average(uint256 a, uint256 b) internal pure returns (uint256) {
//         // (a + b) / 2 can overflow.
//         return (a & b) + (a ^ b) / 2;
//     }

//     /**
//      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
//      *
//      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
//      */
//     function sqrt(uint256 a) internal pure returns (uint256) {
//         if (a == 0) {
//             return 0;
//         }

//         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
//         //
//         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
//         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
//         //
//         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
//         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
//         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
//         //
//         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
//         uint256 result = 1 << (log2(a) >> 1);

//         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
//         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
//         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
//         // into the expected uint128 result.
//         unchecked {
//             result = (result + a / result) >> 1;
//             result = (result + a / result) >> 1;
//             result = (result + a / result) >> 1;
//             result = (result + a / result) >> 1;
//             result = (result + a / result) >> 1;
//             result = (result + a / result) >> 1;
//             result = (result + a / result) >> 1;
//             return min(result, a / result);
//         }
//     }

//     /**
//      * @dev Return the log in base 2, rounded down, of a positive value.
//      * Returns 0 if given 0.
//      */
//     function log2(uint256 value) internal pure returns (uint256) {
//         uint256 result = 0;
//         unchecked {
//             if (value >> 128 > 0) {
//                 value >>= 128;
//                 result += 128;
//             }
//             if (value >> 64 > 0) {
//                 value >>= 64;
//                 result += 64;
//             }
//             if (value >> 32 > 0) {
//                 value >>= 32;
//                 result += 32;
//             }
//             if (value >> 16 > 0) {
//                 value >>= 16;
//                 result += 16;
//             }
//             if (value >> 8 > 0) {
//                 value >>= 8;
//                 result += 8;
//             }
//             if (value >> 4 > 0) {
//                 value >>= 4;
//                 result += 4;
//             }
//             if (value >> 2 > 0) {
//                 value >>= 2;
//                 result += 2;
//             }
//             if (value >> 1 > 0) {
//                 result += 1;
//             }
//         }
//         return result;
//     }

// }
// // File: src/hardhat/contracts/Staking/FraxUnifiedFarmTemplate_V2.sol


// // ====================================================================
// // |     ______                   _______                             |
// // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
// // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
// // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
// // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
// // |                                                                  |
// // ====================================================================
// // ====================== FraxUnifiedFarmTemplate =====================
// // ====================================================================
// // Farming contract that accounts for veFXS
// // Overrideable for UniV3, ERC20s, etc
// // New for V2
// //      - Multiple reward tokens possible
// //      - Can add to existing locked stakes
// //      - Contract is aware of proxied veFXS
// //      - veFXS multiplier formula changed
// // Apes together strong

// // Frax Finance: https://github.com/FraxFinance

// // Primary Author(s)
// // Travis Moore: https://github.com/FortisFortuna

// // Reviewer(s) / Contributor(s)
// // Jason Huan: https://github.com/jasonhuan
// // Sam Kazemian: https://github.com/samkazemian
// // Dennis: github.com/denett

// // Originally inspired by Synthetix.io, but heavily modified by the Frax team
// // (Locked, veFXS, and UniV3 portions are new)
// // https://raw.githubusercontent.com/Synthetixio/synthetix/develop/contracts/StakingRewards.sol









// // Extra rewards


// contract FraxUnifiedFarmTemplate_V2 is OwnedV2, ReentrancyGuard {

//     error NeedsPreTransferProcessLogic();
//     error NeedsCCCWLogic();
//     error NeedsFPLPTLogic();
//     error InvalidProxy();
//     error ProxyHasNotApprovedYou();
//     error RewardsCollectionPaused();
//     error NeedsGRELLogic();
//     error NoValidTokensToRecover();
//     error MustBeGEMulPrec();
//     error MustBeGEZero();
//     error MustBeGEOne();
//     error NotOwnerOrTimelock();
//     error NotOwnerOrTknMgr();
//     error NotEnoughRewardTokensAvailable(address);

//     /* ========== STATE VARIABLES ========== */

//     // Instances
//     IveFXS private constant veFXS = IveFXS(0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0);
    
//     // Frax related
//     address internal constant frax_address = 0x853d955aCEf822Db058eb8505911ED77F175b99e;
//     uint256 public fraxPerLPStored; // fraxPerLPToken is a public view function, although doesn't show the stored value

//     // Constant for various precisions
//     uint256 internal constant MULTIPLIER_PRECISION = 1e18;

//     // Time tracking
//     uint256 public periodFinish;
//     uint256 public lastUpdateTime;

//     // Lock time and multiplier settings
//     uint256 public lock_max_multiplier = 2e18; // E18. 1x = e18
//     uint256 public lock_time_for_max_multiplier = 1 * 1095 * 86400; // 3 years
//     // uint256 public lock_time_for_max_multiplier = 2 * 86400; // 2 days
//     uint256 public lock_time_min = 594000; // 6.875 * 86400 (~7 day)


//     // veFXS related
//     uint256 public vefxs_boost_scale_factor = 4e18;//uint256(4e18); // E18. 4x = 4e18; 100 / scale_factor = % vefxs supply needed for max boost
//     uint256 public vefxs_max_multiplier = 2e18;//uint256(2e18); // E18. 1x = 1e18
//     uint256 public vefxs_per_frax_for_max_boost = 4e18;//uint256(4e18); // E18. 2e18 means 2 veFXS must be held by the staker per 1 FRAX

//     mapping(address => uint256) internal _vefxsMultiplierStored;
//     mapping(address => bool) internal valid_vefxs_proxies;
//     mapping(address => mapping(address => bool)) internal proxy_allowed_stakers;

//     // Reward addresses, gauge addresses, reward rates, and reward managers
//     mapping(address => address) public rewardManagers; // token addr -> manager addr
//     address[] internal rewardTokens;
//     address[] internal gaugeControllers;
//     address[] internal rewardDistributors;
//     uint256[] internal rewardRatesManual;
//     mapping(address => uint256) public rewardTokenAddrToIdx; // token addr -> token index
    
//     // Reward period
//     uint256 public constant rewardsDuration = 604800; // 7 * 86400  (7 days)

//     // Reward tracking
//     uint256[] private rewardsPerTokenStored;
//     mapping(address => mapping(uint256 => uint256)) private userRewardsPerTokenPaid; // staker addr -> token id -> paid amount
//     mapping(address => mapping(uint256 => uint256)) private rewards; // staker addr -> token id -> reward amount
//     mapping(address => uint256) public lastRewardClaimTime; // staker addr -> timestamp
    
//     // Gauge tracking
//     uint256[] private last_gauge_relative_weights;
//     uint256[] private last_gauge_time_totals;

//     // Balance tracking
//     uint256 internal _total_liquidity_locked;
//     uint256 internal _total_combined_weight;
//     mapping(address => uint256) internal _locked_liquidity;
//     mapping(address => uint256) internal _combined_weights;
//     mapping(address => uint256) public proxy_lp_balances; // Keeps track of LP balances proxy-wide. Needed to make sure the proxy boost is kept in line


//     // Stakers set which proxy(s) they want to use
//     mapping(address => address) public staker_designated_proxies; // Keep public so users can see on the frontend if they have a proxy

//     // Admin booleans for emergencies and overrides
//     bool public stakesUnlocked; // Release locked stakes in case of emergency
//     bool internal withdrawalsPaused; // For emergencies
//     bool internal rewardsCollectionPaused; // For emergencies
//     bool internal stakingPaused; // For emergencies

//     /* ========== STRUCTS ========== */
//     // In children...


//     /* ========== MODIFIERS ========== */

//     modifier onlyByOwnGov() {
//         // require(msg.sender == owner || msg.sender == 0x8412ebf45bAC1B340BbE8F318b928C466c4E39CA, "Not owner or timelock");
//         if(msg.sender != owner && msg.sender != 0x8412ebf45bAC1B340BbE8F318b928C466c4E39CA) revert NotOwnerOrTimelock();
//         _;
//     }

//     modifier onlyTknMgrs(address reward_token_address) {
//         // require(msg.sender == owner || isTokenManagerFor(msg.sender, reward_token_address), "Not owner or tkn mgr");
//         if(msg.sender != owner && !isTokenManagerFor(msg.sender, reward_token_address)) revert NotOwnerOrTknMgr();
//         _;
//     }

//     modifier updateRewardAndBalanceMdf(address account, bool sync_too) {
//         updateRewardAndBalance(account, sync_too);
//         _;
//     }

//     /* ========== CONSTRUCTOR ========== */

//     constructor (
//         address _owner,
//         address[] memory _rewardTokens,
//         address[] memory _rewardManagers,
//         uint256[] memory _rewardRatesManual,
//         address[] memory _gaugeControllers,
//         address[] memory _rewardDistributors
//     ) OwnedV2(_owner) {

//         // Address arrays
//         rewardTokens = _rewardTokens;
//         gaugeControllers = _gaugeControllers;
//         rewardDistributors = _rewardDistributors;
//         rewardRatesManual = _rewardRatesManual;

//         for (uint256 i; i < _rewardTokens.length; i++){ 
//             // For fast token address -> token ID lookups later
//             rewardTokenAddrToIdx[_rewardTokens[i]] = i;

//             // Initialize the stored rewards
//             rewardsPerTokenStored.push(0);

//             // Initialize the reward managers
//             rewardManagers[_rewardTokens[i]] = _rewardManagers[i];

//             // Push in empty relative weights to initialize the array
//             last_gauge_relative_weights.push(0);

//             // Push in empty time totals to initialize the array
//             last_gauge_time_totals.push(0);
//         }

//         // Other booleans
//         // stakesUnlocked = false;

//         // Initialization
//         lastUpdateTime = block.timestamp;
//         periodFinish = block.timestamp + rewardsDuration;
//     }

//     /* ============= VIEWS ============= */

//     // ------ REWARD RELATED ------

//     // See if the caller_addr is a manager for the reward token 
//     function isTokenManagerFor(address caller_addr, address reward_token_addr) public view returns (bool){
//         if (caller_addr == owner) return true; // Contract owner
//         else if (rewardManagers[reward_token_addr] == caller_addr) return true; // Reward manager
//         return false; 
//     }

//     // All the reward tokens
//     function getAllRewardTokens() external view returns (address[] memory) {
//         return rewardTokens;
//     }

//     // Last time the reward was applicable
//     function lastTimeRewardApplicable() internal view returns (uint256) {
//         return Math.min(block.timestamp, periodFinish);
//     }

//     function rewardRates(uint256 token_idx) public view returns (uint256 rwd_rate) {
//         // address gauge_controller_address = gaugeControllers[token_idx];
//         if (gaugeControllers[token_idx] != address(0)) {
//             rwd_rate = (
//                 IFraxGaugeController(gaugeControllers[token_idx]).global_emission_rate() * 
//                 last_gauge_relative_weights[token_idx]
//             ) / MULTIPLIER_PRECISION;
//         }
//         else {
//             rwd_rate = rewardRatesManual[token_idx];
//         }
//     }

//     // Amount of reward tokens per LP token / liquidity unit
//     function rewardsPerToken() public view returns (uint256[] memory newRewardsPerTokenStored) {
//         if (_total_liquidity_locked == 0 || _total_combined_weight == 0) {
//             return rewardsPerTokenStored;
//         }
//         else {
//             newRewardsPerTokenStored = new uint256[](rewardTokens.length);
//             for (uint256 i; i < rewardsPerTokenStored.length; i++){ 
//                 newRewardsPerTokenStored[i] = rewardsPerTokenStored[i] + (
//                     ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRates(i) * MULTIPLIER_PRECISION) / _total_combined_weight
//                 );
//             }
//             return newRewardsPerTokenStored;
//         }
//     }

//     // Amount of reward tokens an account has earned / accrued
//     // Note: In the edge-case of one of the account's stake expiring since the last claim, this will
//     // return a slightly inflated number
//     function earned(address account) public view returns (uint256[] memory new_earned) {
//         uint256[] memory reward_arr = rewardsPerToken();
//         new_earned = new uint256[](rewardTokens.length);

//         if (_combined_weights[account] > 0){
//             for (uint256 i; i < rewardTokens.length; i++){ 
//                 new_earned[i] = (
//                     (_combined_weights[account] * 
//                         (reward_arr[i] - userRewardsPerTokenPaid[account][i])
//                     ) / MULTIPLIER_PRECISION
//                 ) + rewards[account][i];
//             }
//         }
//     }

//     // Total reward tokens emitted in the given period
//     function getRewardForDuration() external view returns (uint256[] memory rewards_per_duration_arr) {
//         rewards_per_duration_arr = new uint256[](rewardRatesManual.length);

//         for (uint256 i; i < rewardRatesManual.length; i++){ 
//             rewards_per_duration_arr[i] = rewardRates(i) * rewardsDuration;
//         }
//     }


//     // ------ LIQUIDITY AND WEIGHTS ------

//     // User locked liquidity / LP tokens
//     function totalLiquidityLocked() external view returns (uint256) {
//         return _total_liquidity_locked;
//     }

//     // Total locked liquidity / LP tokens
//     function lockedLiquidityOf(address account) external view returns (uint256) {
//         return _locked_liquidity[account];
//     }

//     // Total combined weight
//     function totalCombinedWeight() external view returns (uint256) {
//         return _total_combined_weight;
//     }

//     // Total 'balance' used for calculating the percent of the pool the account owns
//     // Takes into account the locked stake time multiplier and veFXS multiplier
//     function combinedWeightOf(address account) external view returns (uint256) {
//         return _combined_weights[account];
//     }

//     // Calculated the combined weight for an account
//     function calcCurCombinedWeight(address) public virtual view 
//         returns (
//             uint256,
//             uint256,
//             uint256
//         )
//     {
//         revert NeedsCCCWLogic();
//     }
//     // ------ LOCK RELATED ------

//     // Multiplier amount, given the length of the lock
//     function lockMultiplier(uint256 secs) public view returns (uint256) {
//         // return Math.min(
//         //     lock_max_multiplier,
//         //     uint256(MULTIPLIER_PRECISION) + (
//         //         (secs * (lock_max_multiplier - MULTIPLIER_PRECISION)) / lock_time_for_max_multiplier
//         //     )
//         // ) ;
//         return Math.min(
//             lock_max_multiplier,
//             (secs * lock_max_multiplier) / lock_time_for_max_multiplier
//         ) ;
//     }

//     // ------ FRAX RELATED ------

//     function userStakedFrax(address account) public view returns (uint256) {
//         return (fraxPerLPStored * _locked_liquidity[account]) / MULTIPLIER_PRECISION;
//     }

//     function proxyStakedFrax(address proxy_address) public view returns (uint256) {
//         return (fraxPerLPStored * proxy_lp_balances[proxy_address]) / MULTIPLIER_PRECISION;
//     }

//     // Max LP that can get max veFXS boosted for a given address at its current veFXS balance
//     function maxLPForMaxBoost(address account) external view returns (uint256) {
//         return (veFXS.balanceOf(account) * MULTIPLIER_PRECISION * MULTIPLIER_PRECISION) / (vefxs_per_frax_for_max_boost * fraxPerLPStored);
//     }

//     // Meant to be overridden
//     function fraxPerLPToken() public virtual view returns (uint256) {
//         revert NeedsFPLPTLogic();
//     }

//     // ------ veFXS RELATED ------

//     function minVeFXSForMaxBoost(address account) public view returns (uint256) {
//         return (userStakedFrax(account) * vefxs_per_frax_for_max_boost) / MULTIPLIER_PRECISION;
//     }

//     function minVeFXSForMaxBoostProxy(address proxy_address) public view returns (uint256) {
//         return (proxyStakedFrax(proxy_address) * vefxs_per_frax_for_max_boost) / MULTIPLIER_PRECISION;
//     }

//     function getProxyFor(address addr) public view returns (address){
//         if (valid_vefxs_proxies[addr]) {
//             // If addr itself is a proxy, return that.
//             // If it farms itself directly, it should use the shared LP tally in proxyStakedFrax
//             return addr;
//         }
//         else {
//             // Otherwise, return the proxy, or address(0)
//             return staker_designated_proxies[addr];
//         }
//     }

//     function veFXSMultiplier(address account) public view returns (uint256 vefxs_multiplier) {
//         // Use either the user's or their proxy's veFXS balance
//         //  uint256 vefxs_bal_to_use = 0;
//         address the_proxy = getProxyFor(account);
//         uint256 vefxs_bal_to_use = (the_proxy == address(0)) ? veFXS.balanceOf(account) : veFXS.balanceOf(the_proxy);

//         // First option based on fraction of total veFXS supply, with an added scale factor
//         uint256 mult_optn_1 = (vefxs_bal_to_use * vefxs_max_multiplier * vefxs_boost_scale_factor) 
//                             / (veFXS.totalSupply() * MULTIPLIER_PRECISION);
        
//         // Second based on old method, where the amount of FRAX staked comes into play
//         uint256 mult_optn_2;
//         {
//             //uint256 veFXS_needed_for_max_boost;

//             // Need to use proxy-wide FRAX balance if applicable, to prevent exploiting
//             uint256 veFXS_needed_for_max_boost = (
//                 the_proxy == address(0)) ? minVeFXSForMaxBoost(account) : minVeFXSForMaxBoostProxy(the_proxy
//             );

//             if (veFXS_needed_for_max_boost > 0){ 
//                 uint256 user_vefxs_fraction = (vefxs_bal_to_use * MULTIPLIER_PRECISION) / veFXS_needed_for_max_boost;
                
//                 mult_optn_2 = (user_vefxs_fraction * vefxs_max_multiplier) / MULTIPLIER_PRECISION;
//             }
//             /// mult_optn_2 is initialized to zero, so no need to set it to zero again
//         }

//         // Select the higher of the two
//         vefxs_multiplier = (mult_optn_1 > mult_optn_2 ? mult_optn_1 : mult_optn_2);

//         // Cap the boost to the vefxs_max_multiplier
//         if (vefxs_multiplier > vefxs_max_multiplier) vefxs_multiplier = vefxs_max_multiplier;
//     }

//     /* =============== MUTATIVE FUNCTIONS =============== */


//     // Proxy can allow a staker to use their veFXS balance (the staker will have to reciprocally toggle them too)
//     // Must come before stakerSetVeFXSProxy
//     // CALLED BY PROXY
//     function proxyToggleStaker(address staker_address) external {
//         if(!valid_vefxs_proxies[msg.sender]) revert InvalidProxy();

//         proxy_allowed_stakers[msg.sender][staker_address] = !proxy_allowed_stakers[msg.sender][staker_address]; 

//         // Disable the staker's set proxy if it was the toggler and is currently on
//         if (staker_designated_proxies[staker_address] == msg.sender){
//             staker_designated_proxies[staker_address] = address(0); 

//             // Remove the LP as well
//             proxy_lp_balances[msg.sender] -= _locked_liquidity[staker_address];
//         }
//     }

//     // Staker can allow a veFXS proxy (the proxy will have to toggle them first)
//     // CALLED BY STAKER
//     function stakerSetVeFXSProxy(address proxy_address) external {
//         if(!valid_vefxs_proxies[msg.sender]) revert InvalidProxy();
//         if(!proxy_allowed_stakers[proxy_address][msg.sender]) revert ProxyHasNotApprovedYou();
        
//         // Corner case sanity check to make sure LP isn't double counted
//         // address old_proxy_addr = staker_designated_proxies[msg.sender];
//         if (staker_designated_proxies[msg.sender] != address(0)) {
//             // Remove the LP count from the old proxy
//             proxy_lp_balances[staker_designated_proxies[msg.sender]] -= _locked_liquidity[msg.sender];
//         }

//         // Set the new proxy
//         staker_designated_proxies[msg.sender] = proxy_address; 

//         // Add the the LP as well
//         proxy_lp_balances[proxy_address] += _locked_liquidity[msg.sender];
//     }

//     // ------ STAKING ------
//     // In children...


//     // ------ WITHDRAWING ------
//     // In children...


//     // ------ REWARDS SYNCING ------

//     function updateRewardAndBalance(address account, bool sync_too) public {
//         // Need to retro-adjust some things if the period hasn't been renewed, then start a new one
//         if (sync_too){
//             sync();
//         }
        
//         if (account != address(0)) {
//             // To keep the math correct, the user's combined weight must be recomputed to account for their
//             // ever-changing veFXS balance.
//             (   
//                 uint256 old_combined_weight,
//                 uint256 new_vefxs_multiplier,
//                 uint256 new_combined_weight
//             ) = calcCurCombinedWeight(account);

//             // Calculate the earnings first
//             _syncEarned(account);

//             // Update the user's stored veFXS multipliers
//             _vefxsMultiplierStored[account] = new_vefxs_multiplier;

//             // Update the user's and the global combined weights
//             if (new_combined_weight >= old_combined_weight) {
//                 uint256 weight_diff = new_combined_weight - old_combined_weight;
//                 _total_combined_weight = _total_combined_weight + weight_diff;
//                 _combined_weights[account] = old_combined_weight + weight_diff;
//             } else {
//                 uint256 weight_diff = old_combined_weight - new_combined_weight;
//                 _total_combined_weight = _total_combined_weight - weight_diff;
//                 _combined_weights[account] = old_combined_weight - weight_diff;
//             }
//             // if (new_combined_weight >= old_combined_weight) {
//             //     // uint256 weight_diff = new_combined_weight - old_combined_weight;
//             //     _total_combined_weight += (new_combined_weight - old_combined_weight);
//             //     _combined_weights[account] = old_combined_weight + (new_combined_weight - old_combined_weight);
//             // } else {
//             //     // uint256 weight_diff = old_combined_weight - new_combined_weight;
//             //     _total_combined_weight -= (old_combined_weight - new_combined_weight);
//             //     _combined_weights[account] = old_combined_weight - (old_combined_weight - new_combined_weight);
//             // }

//         }
//     }

//     function _syncEarned(address account) internal {
//         if (account != address(0)) {
//             // Calculate the earnings
//             uint256[] memory earned_arr = earned(account);

//             // Update the rewards array
//             for (uint256 i; i < earned_arr.length; i++){ 
//                 rewards[account][i] = earned_arr[i];
//                 userRewardsPerTokenPaid[account][i] = rewardsPerTokenStored[i];
//             }

//             // Update the rewards paid array
//             // for (uint256 i; i < earned_arr.length; i++){ 
//             //     userRewardsPerTokenPaid[account][i] = rewardsPerTokenStored[i];
//             // }
//         }
//     }


//     // ------ REWARDS CLAIMING ------

//     function getRewardExtraLogic(address destination_address) public nonReentrant {
//         if(rewardsCollectionPaused == true) revert RewardsCollectionPaused();

//         return _getRewardExtraLogic(msg.sender, destination_address);
//     }

//     function _getRewardExtraLogic(address, address) internal virtual {
//         revert NeedsGRELLogic();
//     }

//     /// @notice A function that can be overridden to add extra logic to the pre-transfer process to process curve LP rewards
//     function preTransferProcess(address, address) public virtual {
//         revert NeedsPreTransferProcessLogic();
//     }

//     // Two different getReward functions are needed because of delegateCall and msg.sender issues
//     // For backwards-compatibility
//     function getReward(address destination_address) external nonReentrant returns (uint256[] memory) {
//         return _getReward(msg.sender, destination_address, true);
//     }

//     function getReward2(address destination_address, bool claim_extra_too) external nonReentrant returns (uint256[] memory) {
//         return _getReward(msg.sender, destination_address, claim_extra_too);
//     }

//     // No withdrawer == msg.sender check needed since this is only internally callable
//     function _getReward(
//         address rewardee, 
//         address destination_address, 
//         bool do_extra_logic
//     ) internal updateRewardAndBalanceMdf(rewardee, true) returns (uint256[] memory rewards_before) {
//         // Update the last reward claim time first, as an extra reentrancy safeguard
//         lastRewardClaimTime[rewardee] = block.timestamp;
        
//         // Make sure rewards collection isn't paused
//         if(rewardsCollectionPaused == true) revert RewardsCollectionPaused();
        
//         // Update the rewards array and distribute rewards
//         rewards_before = new uint256[](rewardTokens.length);

//         for (uint256 i; i < rewardTokens.length; i++){ 
//             rewards_before[i] = rewards[rewardee][i];
//             rewards[rewardee][i] = 0;
//             if (rewards_before[i] > 0) {
//                 TransferHelperV2.safeTransfer(rewardTokens[i], destination_address, rewards_before[i]);

//                 emit RewardPaid(rewardee, rewards_before[i], rewardTokens[i], destination_address);
//             }
//         }

//         // Handle additional reward logic
//         if (do_extra_logic) {
//             _getRewardExtraLogic(rewardee, destination_address);
//         }
//     }


//     // ------ FARM SYNCING ------

//     // If the period expired, renew it
//     function retroCatchUp() internal {
//         // Pull in rewards from the rewards distributor, if applicable
//         for (uint256 i; i < rewardDistributors.length; i++){ 
//             address reward_distributor_address = rewardDistributors[i];
//             if (reward_distributor_address != address(0)) {
//                 IFraxGaugeFXSRewardsDistributor(reward_distributor_address).distributeReward(address(this));
//             }
//         }

//         // Ensure the provided reward amount is not more than the balance in the contract.
//         // This keeps the reward rate in the right range, preventing overflows due to
//         // very high values of rewardRate in the earned and rewardsPerToken functions;
//         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
//         uint256 num_periods_elapsed = uint256(block.timestamp - periodFinish) / rewardsDuration; // Floor division to the nearest period
        
//         // Make sure there are enough tokens to renew the reward period
//         for (uint256 i; i < rewardTokens.length; i++){ 

//             /// @dev TODO check that this won't break tests or UI displays
//             //require((rewardRates(i) * rewardsDuration * (num_periods_elapsed + 1)) <= IERC20(rewardTokens[i]).balanceOf(address(this)), string(abi.encodePacked("Not enough reward tokens available: ", rewardTokens[i])) );
//             if(
//                 (rewardRates(i) * rewardsDuration * (num_periods_elapsed + 1)) 
//                 > 
//                 IERC20(rewardTokens[i]).balanceOf(address(this))
//             ) revert NotEnoughRewardTokensAvailable(rewardTokens[i]);
//         }
        
//         // uint256 old_lastUpdateTime = lastUpdateTime;
//         // uint256 new_lastUpdateTime = block.timestamp;

//         // lastUpdateTime = periodFinish;
//         periodFinish = periodFinish + ((num_periods_elapsed + 1) * rewardsDuration);

//         // Update the rewards and time
//         _updateStoredRewardsAndTime();

//         // Update the fraxPerLPStored
//         fraxPerLPStored = fraxPerLPToken();

//         // Pull in rewards and set the reward rate for one week, based off of that
//         // If the rewards get messed up for some reason, set this to 0 and it will skip
//         // if (rewardRatesManual[1] != 0 && rewardRatesManual[2] != 0) {
//         //     // CRV & CVX
//         //     // ====================================
//         //     uint256 crv_before = ERC20(rewardTokens[1]).balanceOf(address(this));
//         //     uint256 cvx_before = ERC20(rewardTokens[2]).balanceOf(address(this));
//         //     IConvexBaseRewardPool(0x329cb014b562d5d42927cfF0dEdF4c13ab0442EF).getReward(
//         //         address(this),
//         //         true
//         //     );
//         //     uint256 crv_after = ERC20(rewardTokens[1]).balanceOf(address(this));
//         //     uint256 cvx_after = ERC20(rewardTokens[2]).balanceOf(address(this));

//         //     // Set the new reward rate
//         //     rewardRatesManual[1] = (crv_after - crv_before) / rewardsDuration;
//         //     rewardRatesManual[2] = (cvx_after - cvx_before) / rewardsDuration;
//         // }

//     }

//     function _updateStoredRewardsAndTime() internal {
//         // Get the rewards
//         uint256[] memory rewards_per_token = rewardsPerToken();

//         // Update the rewardsPerTokenStored
//         for (uint256 i; i < rewardsPerTokenStored.length; i++){ 
//             rewardsPerTokenStored[i] = rewards_per_token[i];
//         }

//         // Update the last stored time
//         lastUpdateTime = lastTimeRewardApplicable();
//     }

//     function sync_gauge_weights(bool force_update) public {
//         // Loop through the gauge controllers
//         for (uint256 i; i < gaugeControllers.length; i++){ 
//             // address gauge_controller_address = gaugeControllers[i];
//             if (gaugeControllers[i] != address(0)) {
//                 if (force_update || (block.timestamp > last_gauge_time_totals[i])){
//                     // Update the gauge_relative_weight
//                     last_gauge_relative_weights[i] = IFraxGaugeController(
//                         gaugeControllers[i]).gauge_relative_weight_write(
//                             address(this), block.timestamp
//                         );
//                     last_gauge_time_totals[i] = IFraxGaugeController(gaugeControllers[i]).time_total();
//                 }
//             }
//         }
//     }

//     function sync() public {
//         // Sync the gauge weight, if applicable
//         sync_gauge_weights(false);

//         // Update the fraxPerLPStored
//         fraxPerLPStored = fraxPerLPToken();

//         if (block.timestamp >= periodFinish) {
//             retroCatchUp();
//         }
//         else {
//             _updateStoredRewardsAndTime();
//         }
//     }

//     /* ========== RESTRICTED FUNCTIONS - Curator callable ========== */
    
//     // ------ FARM SYNCING ------
//     // In children...

//     // ------ PAUSES ------

//     function setPauses(
//         bool _stakingPaused,
//         bool _withdrawalsPaused,
//         bool _rewardsCollectionPaused
//     ) external onlyByOwnGov {
//         stakingPaused = _stakingPaused;
//         withdrawalsPaused = _withdrawalsPaused;
//         rewardsCollectionPaused = _rewardsCollectionPaused;
//     }

//     /* ========== RESTRICTED FUNCTIONS - Owner or timelock only ========== */
    
//     function unlockStakes() external onlyByOwnGov {
//         stakesUnlocked = !stakesUnlocked;
//     }

//     // Adds a valid veFXS proxy address
//     function toggleValidVeFXSProxy(address _proxy_addr) external onlyByOwnGov {
//         valid_vefxs_proxies[_proxy_addr] = !valid_vefxs_proxies[_proxy_addr];
//     }

//     // Added to support recovering LP Rewards and other mistaken tokens from other systems to be distributed to holders
//     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyTknMgrs(tokenAddress) {
//         // Check if the desired token is a reward token
//         bool isRewardToken;
//         for (uint256 i; i < rewardTokens.length; i++){ 
//             if (rewardTokens[i] == tokenAddress) {
//                 isRewardToken = true;
//                 break;
//             }
//         }

//         // Only the reward managers can take back their reward tokens
//         // Also, other tokens, like the staking token, airdrops, or accidental deposits, can be withdrawn by the owner
//         if (
//                 (isRewardToken && rewardManagers[tokenAddress] == msg.sender)
//                 || 
//                 (!isRewardToken && (msg.sender == owner))
//             ) {
//                 TransferHelperV2.safeTransfer(tokenAddress, msg.sender, tokenAmount);
//                 return;
//         }
//         // If none of the above conditions are true
//         else {
//             revert NoValidTokensToRecover();
//         }
//     }

//     function setMiscVariables(
//         uint256[6] memory _misc_vars
//         // [0]: uint256 _lock_max_multiplier, 
//         // [1] uint256 _vefxs_max_multiplier, 
//         // [2] uint256 _vefxs_per_frax_for_max_boost,
//         // [3] uint256 _vefxs_boost_scale_factor,
//         // [4] uint256 _lock_time_for_max_multiplier,
//         // [5] uint256 _lock_time_min
//     ) external onlyByOwnGov {
//         // require(_misc_vars[0] >= MULTIPLIER_PRECISION, "Must be >= MUL PREC");
//         // require((_misc_vars[1] >= 0) && (_misc_vars[2] >= 0) && (_misc_vars[3] >= 0), "Must be >= 0");
//         // require((_misc_vars[4] >= 1) && (_misc_vars[5] >= 1), "Must be >= 1");
//         /// TODO check this rewrite
//         if(_misc_vars[4] < _misc_vars[5]) revert MustBeGEMulPrec();
//         if((_misc_vars[1] < 0) || (_misc_vars[2] < 0) || (_misc_vars[3] < 0)) revert MustBeGEZero();
//         if((_misc_vars[4] < 1) || (_misc_vars[5] < 1)) revert MustBeGEOne();

//         lock_max_multiplier = _misc_vars[0];
//         vefxs_max_multiplier = _misc_vars[1];
//         vefxs_per_frax_for_max_boost = _misc_vars[2];
//         vefxs_boost_scale_factor = _misc_vars[3];
//         lock_time_for_max_multiplier = _misc_vars[4];
//         lock_time_min = _misc_vars[5];
//     }

//     // The owner or the reward token managers can set reward rates 
//     function setRewardVars(
//         address reward_token_address, 
//         uint256 _new_rate, 
//         address _gauge_controller_address, 
//         address _rewards_distributor_address
//     ) external onlyTknMgrs(reward_token_address) {
//         rewardRatesManual[rewardTokenAddrToIdx[reward_token_address]] = _new_rate;
//         gaugeControllers[rewardTokenAddrToIdx[reward_token_address]] = _gauge_controller_address;
//         rewardDistributors[rewardTokenAddrToIdx[reward_token_address]] = _rewards_distributor_address;
//     }

//     // The owner or the reward token managers can change managers
//     function changeTokenManager(address reward_token_address, address new_manager_address) external onlyTknMgrs(reward_token_address) {
//         rewardManagers[reward_token_address] = new_manager_address;
//     }

//     /* ========== EVENTS ========== */
//     event RewardPaid(address indexed user, uint256 amount, address token_address, address destination_address);

//     /* ========== A CHICKEN ========== */
//     //
//     //         ,~.
//     //      ,-'__ `-,
//     //     {,-'  `. }              ,')
//     //    ,( a )   `-.__         ,',')~,
//     //   <=.) (         `-.__,==' ' ' '}
//     //     (   )                      /)
//     //      `-'\   ,                    )
//     //          |  \        `~.        /
//     //          \   `._        \      /
//     //           \     `._____,'    ,'
//     //            `-.             ,'
//     //               `-._     _,-'
//     //                   77jj'
//     //                  //_||
//     //               __//--'/`
//     //             ,--'/`  '
//     //
//     // [hjw] https://textart.io/art/vw6Sa3iwqIRGkZsN1BC2vweF/chicken
// }