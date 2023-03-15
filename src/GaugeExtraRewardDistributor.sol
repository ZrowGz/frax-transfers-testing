
// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

pragma solidity ^0.8.10;

// /**
//  * @dev Collection of functions related to the address type
//  */
// library Address {
//     /**
//      * @dev Returns true if `account` is a contract.
//      *
//      * [IMPORTANT]
//      * ====
//      * It is unsafe to assume that an address for which this function returns
//      * false is an externally-owned account (EOA) and not a contract.
//      *
//      * Among others, `isContract` will return false for the following
//      * types of addresses:
//      *
//      *  - an externally-owned account
//      *  - a contract in construction
//      *  - an address where a contract will be created
//      *  - an address where a contract lived, but was destroyed
//      * ====
//      *
//      * [IMPORTANT]
//      * ====
//      * You shouldn't rely on `isContract` to protect against flash loan attacks!
//      *
//      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
//      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
//      * constructor.
//      * ====
//      */
//     function isContract(address account) internal view returns (bool) {
//         // This method relies on extcodesize/address.code.length, which returns 0
//         // for contracts in construction, since the code is only stored at the end
//         // of the constructor execution.

//         return account.code.length > 0;
//     }

//     /**
//      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
//      * `recipient`, forwarding all available gas and reverting on errors.
//      *
//      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
//      * of certain opcodes, possibly making contracts go over the 2300 gas limit
//      * imposed by `transfer`, making them unable to receive funds via
//      * `transfer`. {sendValue} removes this limitation.
//      *
//      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
//      *
//      * IMPORTANT: because control is transferred to `recipient`, care must be
//      * taken to not create reentrancy vulnerabilities. Consider using
//      * {ReentrancyGuard} or the
//      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
//      */
//     function sendValue(address payable recipient, uint256 amount) internal {
//         require(address(this).balance >= amount, "Address: insufficient balance");

//         (bool success, ) = recipient.call{value: amount}("");
//         require(success, "Address: unable to send value, recipient may have reverted");
//     }

//     /**
//      * @dev Performs a Solidity function call using a low level `call`. A
//      * plain `call` is an unsafe replacement for a function call: use this
//      * function instead.
//      *
//      * If `target` reverts with a revert reason, it is bubbled up by this
//      * function (like regular Solidity function calls).
//      *
//      * Returns the raw returned data. To convert to the expected return value,
//      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
//      *
//      * Requirements:
//      *
//      * - `target` must be a contract.
//      * - calling `target` with `data` must not revert.
//      *
//      * _Available since v3.1._
//      */
//     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
//         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
//     }

//     /**
//      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
//      * `errorMessage` as a fallback revert reason when `target` reverts.
//      *
//      * _Available since v3.1._
//      */
//     function functionCall(
//         address target,
//         bytes memory data,
//         string memory errorMessage
//     ) internal returns (bytes memory) {
//         return functionCallWithValue(target, data, 0, errorMessage);
//     }

//     /**
//      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
//      * but also transferring `value` wei to `target`.
//      *
//      * Requirements:
//      *
//      * - the calling contract must have an ETH balance of at least `value`.
//      * - the called Solidity function must be `payable`.
//      *
//      * _Available since v3.1._
//      */
//     function functionCallWithValue(
//         address target,
//         bytes memory data,
//         uint256 value
//     ) internal returns (bytes memory) {
//         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
//     }

//     /**
//      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
//      * with `errorMessage` as a fallback revert reason when `target` reverts.
//      *
//      * _Available since v3.1._
//      */
//     function functionCallWithValue(
//         address target,
//         bytes memory data,
//         uint256 value,
//         string memory errorMessage
//     ) internal returns (bytes memory) {
//         require(address(this).balance >= value, "Address: insufficient balance for call");
//         (bool success, bytes memory returndata) = target.call{value: value}(data);
//         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
//     }

//     /**
//      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
//      * but performing a static call.
//      *
//      * _Available since v3.3._
//      */
//     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
//         return functionStaticCall(target, data, "Address: low-level static call failed");
//     }

//     /**
//      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
//      * but performing a static call.
//      *
//      * _Available since v3.3._
//      */
//     function functionStaticCall(
//         address target,
//         bytes memory data,
//         string memory errorMessage
//     ) internal view returns (bytes memory) {
//         (bool success, bytes memory returndata) = target.staticcall(data);
//         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
//     }

//     /**
//      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
//      * but performing a delegate call.
//      *
//      * _Available since v3.4._
//      */
//     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
//         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
//     }

//     /**
//      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
//      * but performing a delegate call.
//      *
//      * _Available since v3.4._
//      */
//     function functionDelegateCall(
//         address target,
//         bytes memory data,
//         string memory errorMessage
//     ) internal returns (bytes memory) {
//         (bool success, bytes memory returndata) = target.delegatecall(data);
//         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
//     }

//     /**
//      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
//      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
//      *
//      * _Available since v4.8._
//      */
//     function verifyCallResultFromTarget(
//         address target,
//         bool success,
//         bytes memory returndata,
//         string memory errorMessage
//     ) internal view returns (bytes memory) {
//         if (success) {
//             if (returndata.length == 0) {
//                 // only check isContract if the call was successful and the return data is empty
//                 // otherwise we already know that it was a contract
//                 require(isContract(target), "Address: call to non-contract");
//             }
//             return returndata;
//         } else {
//             _revert(returndata, errorMessage);
//         }
//     }

//     /**
//      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
//      * revert reason or using the provided one.
//      *
//      * _Available since v4.3._
//      */
//     function verifyCallResult(
//         bool success,
//         bytes memory returndata,
//         string memory errorMessage
//     ) internal pure returns (bytes memory) {
//         if (success) {
//             return returndata;
//         } else {
//             _revert(returndata, errorMessage);
//         }
//     }

//     function _revert(bytes memory returndata, string memory errorMessage) private pure {
//         // Look for revert reason and bubble it up if present
//         if (returndata.length > 0) {
//             // The easiest way to bubble the revert reason is using memory via assembly
//             /// @solidity memory-safe-assembly
//             assembly {
//                 let returndata_size := mload(returndata)
//                 revert(add(32, returndata), returndata_size)
//             }
//         } else {
//             revert(errorMessage);
//         }
//     }
// }

// // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol


// // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

// // pragma solidity ^0.8.0;

// /**
//  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
//  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
//  *
//  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
//  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
//  * need to send a transaction, and thus is not required to hold Ether at all.
//  */
// interface IERC20Permit {
//     /**
//      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
//      * given ``owner``'s signed approval.
//      *
//      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
//      * ordering also apply here.
//      *
//      * Emits an {Approval} event.
//      *
//      * Requirements:
//      *
//      * - `spender` cannot be the zero address.
//      * - `deadline` must be a timestamp in the future.
//      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
//      * over the EIP712-formatted function arguments.
//      * - the signature must use ``owner``'s current nonce (see {nonces}).
//      *
//      * For more information on the signature format, see the
//      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
//      * section].
//      */
//     function permit(
//         address owner,
//         address spender,
//         uint256 value,
//         uint256 deadline,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) external;

//     /**
//      * @dev Returns the current nonce for `owner`. This value must be
//      * included whenever a signature is generated for {permit}.
//      *
//      * Every successful call to {permit} increases ``owner``'s nonce by one. This
//      * prevents a signature from being used multiple times.
//      */
//     function nonces(address owner) external view returns (uint256);

//     /**
//      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
//      */
//     // solhint-disable-next-line func-name-mixedcase
//     function DOMAIN_SEPARATOR() external view returns (bytes32);
// }

// // File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

// // pragma solidity ^0.8.0;

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
//     function transferFrom(
//         address from,
//         address to,
//         uint256 amount
//     ) external returns (bool);
// }

// // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol


// // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)

// // pragma solidity ^0.8.0;




// /**
//  * @title SafeERC20
//  * @dev Wrappers around ERC20 operations that throw on failure (when the token
//  * contract returns false). Tokens that return no value (and instead revert or
//  * throw on failure) are also supported, non-reverting calls are assumed to be
//  * successful.
//  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
//  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
//  */
// library SafeERC20 {
//     using Address for address;

//     function safeTransfer(
//         IERC20 token,
//         address to,
//         uint256 value
//     ) internal {
//         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
//     }

//     function safeTransferFrom(
//         IERC20 token,
//         address from,
//         address to,
//         uint256 value
//     ) internal {
//         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
//     }

//     /**
//      * @dev Deprecated. This function has issues similar to the ones found in
//      * {IERC20-approve}, and its usage is discouraged.
//      *
//      * Whenever possible, use {safeIncreaseAllowance} and
//      * {safeDecreaseAllowance} instead.
//      */
//     function safeApprove(
//         IERC20 token,
//         address spender,
//         uint256 value
//     ) internal {
//         // safeApprove should only be called when setting an initial allowance,
//         // or when resetting it to zero. To increase and decrease it, use
//         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
//         require(
//             (value == 0) || (token.allowance(address(this), spender) == 0),
//             "SafeERC20: approve from non-zero to non-zero allowance"
//         );
//         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
//     }

//     function safeIncreaseAllowance(
//         IERC20 token,
//         address spender,
//         uint256 value
//     ) internal {
//         uint256 newAllowance = token.allowance(address(this), spender) + value;
//         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
//     }

//     function safeDecreaseAllowance(
//         IERC20 token,
//         address spender,
//         uint256 value
//     ) internal {
//         unchecked {
//             uint256 oldAllowance = token.allowance(address(this), spender);
//             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
//             uint256 newAllowance = oldAllowance - value;
//             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
//         }
//     }

//     function safePermit(
//         IERC20Permit token,
//         address owner,
//         address spender,
//         uint256 value,
//         uint256 deadline,
//         uint8 v,
//         bytes32 r,
//         bytes32 s
//     ) internal {
//         uint256 nonceBefore = token.nonces(owner);
//         token.permit(owner, spender, value, deadline, v, r, s);
//         uint256 nonceAfter = token.nonces(owner);
//         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
//     }

//     /**
//      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
//      * on the return value: the return value is optional (but if data is returned, it must not be false).
//      * @param token The token targeted by the call.
//      * @param data The call data (encoded using abi.encode or one of its variants).
//      */
//     function _callOptionalReturn(IERC20 token, bytes memory data) private {
//         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
//         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
//         // the target address contains contract code and also asserts for success in the low-level call.

//         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
//         if (returndata.length > 0) {
//             // Return data is optional
//             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
//         }
//     }
// }

// // File: contracts/contracts/interfaces/IConvexWrapper.sol


// // pragma solidity 0.8.10;

// interface IConvexWrapper{

//    struct EarnedData {
//         address token;
//         uint256 amount;
//     }

//   function collateralVault() external view returns(address vault);
//   function convexPoolId() external view returns(uint256 _poolId);
//   function curveToken() external view returns(address);
//   function convexToken() external view returns(address);
//   function balanceOf(address _account) external view returns(uint256);
//   function totalBalanceOf(address _account) external view returns(uint256);
//   function deposit(uint256 _amount, address _to) external;
//   function stake(uint256 _amount, address _to) external;
//   function withdraw(uint256 _amount) external;
//   function withdrawAndUnwrap(uint256 _amount) external;
//   function getReward(address _account) external;
//   function getReward(address _account, address _forwardTo) external;
//   function rewardLength() external view returns(uint256);
//   function earned(address _account) external view returns(EarnedData[] memory claimable);
//   function setVault(address _vault) external;
//   function user_checkpoint(address[2] calldata _accounts) external returns(bool);
// }
// // File: contracts/contracts/interfaces/IFraxFarmERC20.sol


// // pragma solidity >=0.8.0;

// interface IFraxFarmERC20 {
    
//     struct LockedStake {
//         bytes32 kek_id;
//         uint256 start_timestamp;
//         uint256 liquidity;
//         uint256 ending_timestamp;
//         uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
//     }

//     function owner() external view returns (address);
//     function stakingToken() external view returns (address);
//     function fraxPerLPToken() external view returns (uint256);
//     function calcCurCombinedWeight(address account) external view
//         returns (
//             uint256 old_combined_weight,
//             uint256 new_vefxs_multiplier,
//             uint256 new_combined_weight
//         );
//     function lockedStakesOf(address account) external view returns (LockedStake[] memory);
//     function lockedStakesOfLength(address account) external view returns (uint256);
//     function lockAdditional(bytes32 kek_id, uint256 addl_liq) external;
//     function lockLonger(bytes32 kek_id, uint256 new_ending_ts) external;
//     function stakeLocked(uint256 liquidity, uint256 secs) external returns (bytes32);
//     function withdrawLocked(bytes32 kek_id, address destination_address) external returns (uint256);



//     function periodFinish() external view returns (uint256);
//     function rewardsDuration() external view returns (uint256);
//     function getAllRewardTokens() external view returns (address[] memory);
//     function earned(address account) external view returns (uint256[] memory new_earned);
//     function totalLiquidityLocked() external view returns (uint256);
//     function lockedLiquidityOf(address account) external view returns (uint256);
//     function totalCombinedWeight() external view returns (uint256);
//     function combinedWeightOf(address account) external view returns (uint256);
//     function lockMultiplier(uint256 secs) external view returns (uint256);
//     function rewardRates(uint256 token_idx) external view returns (uint256 rwd_rate);

//     function userStakedFrax(address account) external view returns (uint256);
//     function proxyStakedFrax(address proxy_address) external view returns (uint256);
//     function maxLPForMaxBoost(address account) external view returns (uint256);
//     function minVeFXSForMaxBoost(address account) external view returns (uint256);
//     function minVeFXSForMaxBoostProxy(address proxy_address) external view returns (uint256);
//     function veFXSMultiplier(address account) external view returns (uint256 vefxs_multiplier);

//     function toggleValidVeFXSProxy(address proxy_address) external;
//     function proxyToggleStaker(address staker_address) external;
//     function stakerSetVeFXSProxy(address proxy_address) external;
//     function getReward(address destination_address) external returns (uint256[] memory);
//     function vefxs_max_multiplier() external view returns(uint256);
//     function vefxs_boost_scale_factor() external view returns(uint256);
//     function vefxs_per_frax_for_max_boost() external view returns(uint256);
//     function getProxyFor(address addr) external view returns (address);

//     function sync() external;

//     function setAllowance(address spender, bytes32 kek_id, uint256 amount) external;
//     function increaseAllowance(address spender, bytes32 kek_id, uint256 amount) external;
//     function removeAllowance(address spender, bytes32 kek_id) external;
//     function setApprovalForAll(address spender, bool approved) external;
//     function transferLocked(address receiver_address, bytes32 source_kek_id, uint256 transfer_amount, bytes32 destination_kek_id) external returns(bytes32,bytes32);
//     function setRewardVars(address reward_token_address, uint256 _new_rate, address _gauge_controller_address, address _rewards_distributor_address) external;
// }

// // File: contracts/contracts/GaugeExtraRewardDistributor.sol


// // pragma solidity 0.8.10;






    
// contract GaugeExtraRewardDistributor {
//     using SafeERC20 for IERC20;

//     address public farm;
//     address public wrapper;

//     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
//     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);

//     event Recovered(address _token, uint256 _amount);
//     event Distributed(address _token, uint256 _rate);

//     constructor(){}

//     function initialize(address _farm, address _wrapper) external {
//         require(farm == address(0),"init fail");

//         farm = _farm;
//         wrapper = _wrapper;
//     }

//     //owner is farm owner
//     modifier onlyOwner() {
//         require(msg.sender == IFraxFarmERC20(farm).owner(), "!owner");
//         _;
//     }

//     function recoverERC20(address _tokenAddress, uint256 _tokenAmount) external onlyOwner {
//         require(_tokenAddress != crv && _tokenAddress != cvx, "invalid");
//         IERC20(_tokenAddress).safeTransfer(IFraxFarmERC20(farm).owner(), _tokenAmount);
//         emit Recovered(_tokenAddress, _tokenAmount);
//     }

//     // Add a new reward token to be distributed to stakers
//     function distributeReward(address _farm) external{
//         //only allow farm to call
//         require(msg.sender == farm);
        
//         //get rewards
//         IConvexWrapper(wrapper).getReward(_farm);

//         //get last period update from farm and figure out period
//         uint256 duration = IFraxFarmERC20(_farm).rewardsDuration();
//         uint256 periodLength = ((block.timestamp + duration) / duration) - IFraxFarmERC20(_farm).periodFinish();

//         //reward tokens on farms are constant so dont need to loop, just distribute crv and cvx
//         uint256 balance = IERC20(crv).balanceOf(address(this));
//         uint256 rewardRate = IERC20(crv).balanceOf(address(this)) / periodLength;
//         if(balance > 0){
//             IERC20(crv).transfer(farm, balance);
//         }
//         //if balance is 0, still need to call so reward rate is set to 0
//         IFraxFarmERC20(_farm).setRewardVars(crv, rewardRate, address(0), address(this));
//         emit Distributed(crv, rewardRate);

//         balance = IERC20(cvx).balanceOf(address(this));
//         rewardRate = IERC20(cvx).balanceOf(address(this)) / periodLength;
//         if(balance > 0){
//             IERC20(cvx).transfer(farm, balance);
//         }
//         IFraxFarmERC20(_farm).setRewardVars(cvx, rewardRate, address(0), address(0)); //keep distributor 0 since its shared
//         emit Distributed(cvx, rewardRate);
//     }
// }