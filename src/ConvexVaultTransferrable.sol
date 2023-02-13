
// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


import "lib/forge-std/src/console2.sol";

// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

pragma solidity 0.8.17;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/contracts/interfaces/ILockReceiver.sol


pragma solidity >=0.8.0;

interface ILockReceiver {
    function beforeLockTransfer(
        address _sender,
        address _receiver,
        uint256 _lockId,
        bytes calldata _data
    ) external returns (bytes4);

    function onLockReceived(
        address _sender,
        address _receiver,
        uint256 _lockId,
        bytes calldata _data
    ) external returns (bytes4);
}
// File: contracts/contracts/interfaces/IFraxFarmERC20TransferByIndex.sol


pragma solidity >=0.8.0;

interface IFraxFarmERC20 {
    
    struct LockedStake {
        uint256 start_timestamp;
        uint256 liquidity;
        uint256 ending_timestamp;
        uint256 lock_multiplier; // 6 decimals of precision. 1x = 1000000
    }

    function owner() external view returns (address);
    function stakingToken() external view returns (address);
    function fraxPerLPToken() external view returns (uint256);
    function calcCurCombinedWeight(address account) external view
        returns (
            uint256 old_combined_weight,
            uint256 new_vefxs_multiplier,
            uint256 new_combined_weight
        );
    function lockedStakesOf(address account) external view returns (LockedStake[] memory);
    function lockedStakesOfLength(address account) external view returns (uint256);
    function lockAdditional(uint256 lockId, uint256 addl_liq) external;
    function lockLonger(uint256 lockId, uint256 new_ending_ts) external;
    function stakeLocked(uint256 liquidity, uint256 secs) external returns (uint256);
    function withdrawLocked(uint256 lockId, address destination_address) external returns (uint256);



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
    function vefxs_max_multiplier() external view returns(uint256);
    function vefxs_boost_scale_factor() external view returns(uint256);
    function vefxs_per_frax_for_max_boost() external view returns(uint256);
    function getProxyFor(address addr) external view returns (address);

    function sync() external;

    function setAllowance(address spender, uint256 lockId, uint256 amount) external;
    function increaseAllowance(address spender, uint256 lockId, uint256 amount) external;
    function removeAllowance(address spender, uint256 lockId) external;
    function setApprovalForAll(address spender, bool approved) external;
    function transferLocked(address receiver_address, uint256 sender_lock_index, uint256 transfer_amount, bool use_receiver_lock_index, uint256 receiver_lock_index) external returns(uint256,uint256);
}

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert(errorMessage);
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.0;




/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

// File: contracts/contracts/interfaces/IRewards.sol


interface IRewards{
    struct EarnedData {
        address token;
        uint256 amount;
    }
    
    function initialize(uint256 _pid, bool _startActive) external;
    function addReward(address _rewardsToken, address _distributor) external;
    function approveRewardDistributor(
        address _rewardsToken,
        address _distributor,
        bool _approved
    ) external;
    function deposit(address _owner, uint256 _amount) external;
    function withdraw(address _owner, uint256 _amount) external;
    function getReward(address _forward) external;
    function notifyRewardAmount(address _rewardsToken, uint256 _reward) external;
    function balanceOf(address account) external view returns (uint256);
    function claimableRewards(address _account) external view returns(EarnedData[] memory userRewards);
    function rewardTokens(uint256 _rid) external view returns (address);
    function rewardTokenLength() external view returns(uint256);
    function active() external view returns(bool);
}
// File: contracts/contracts/interfaces/IFraxFarmBase.sol


pragma solidity >=0.8.0;

interface IFraxFarmBase{

    function totalLiquidityLocked() external view returns (uint256);
    function lockedLiquidityOf(address account) external view returns (uint256);

    function toggleValidVeFXSProxy(address proxy_address) external;
    function proxyToggleStaker(address staker_address) external;
    function stakerSetVeFXSProxy(address proxy_address) external;
    function getReward(address destination_address) external returns (uint256[] memory);

}

// File: contracts/contracts/interfaces/IFeeRegistry.sol


interface IFeeRegistry{
    function cvxfxsIncentive() external view returns(uint256);
    function cvxIncentive() external view returns(uint256);
    function platformIncentive() external view returns(uint256);
    function totalFees() external view returns(uint256);
    function maxFees() external view returns(uint256);
    function feeDeposit() external view returns(address);
    function getFeeDepositor(address _from) external view returns(address);
}
// File: contracts/contracts/interfaces/IProxyVault.sol


interface IProxyVault {
    function initialize(address _owner, address _stakingAddress, address _stakingToken, address _rewardsAddress, address _poolRegistry, uint256 _pid) external;
    function usingProxy() external returns(address);
    function owner() external returns(address);
    function stakingAddress() external returns(address);
    function rewards() external returns(address);
    function getReward() external;
    function getReward(bool _claim) external;
    function getReward(bool _claim, address[] calldata _rewardTokenList) external;
    function earned() external view returns (address[] memory token_addresses, uint256[] memory total_earned);
}

interface ITransferChecker {
    function vaultMap(uint256 _poolId, address _user) external returns(address);
}

interface IVaultType {
    enum VaultType{
        Erc20Basic,
        UniV3,
        Convex,
        Erc20Joint
    }
}
// File: contracts/contracts/StakingProxyBaseTransfers.sol


contract StakingProxyBase is IVaultType{
    using SafeERC20 for IERC20;

    address public constant fxs = address(0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0);
    address public constant vefxsProxy = address(0x59CFCD384746ec3035299D90782Be065e466800B);
    address public constant feeRegistry = address(0xC9aCB83ADa68413a6Aa57007BC720EE2E2b3C46D); //fee registry

    address public owner; //owner of the vault
    address public stakingAddress; //farming contract
    address public stakingToken; //farming token
    address public rewards; //extra rewards on convex
    address public usingProxy; //address of proxy being used

    uint256 public constant FEE_DENOMINATOR = 10000;

    constructor() {
    }

    function vaultType() external virtual pure returns(VaultType){
        return VaultType.Erc20Basic;
    }

    function vaultVersion() external virtual pure returns(uint256){
        return 1;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "!auth");
        _;
    }

    modifier onlyAdmin() {
        require(vefxsProxy == msg.sender, "!auth_admin");
        _;
    }

    //initialize vault
    function initialize(address _owner, address _stakingAddress, address _stakingToken, address _rewardsAddress) external virtual{//, address _poolRegistry, uint256 _pid) external override{

    }

    function changeRewards(address _rewardsAddress) external onlyAdmin{
        
        //remove from old rewards and claim
        if(IRewards(rewards).active()){
            uint256 bal = IRewards(rewards).balanceOf(address(this));
            if(bal > 0){
                IRewards(rewards).withdraw(owner, bal);
            }
            IRewards(rewards).getReward(owner);
        }

        //set to new rewards
        rewards = _rewardsAddress;

        //update balance
        _checkpointRewards();
    }

    //checkpoint weight on farm by calling getReward as its the lowest cost thing to do.
    function checkpointRewards() external onlyAdmin{
        //checkpoint the frax farm
        _checkpointFarm();
    }

    function _checkpointFarm() internal{
        //claim rewards to local vault as a means to checkpoint
        IFraxFarmBase(stakingAddress).getReward(address(this));
    }

    function setVeFXSProxy(address _proxy) external virtual onlyAdmin{
        //set the vefxs proxy
        _setVeFXSProxy(_proxy);
    }

    function _setVeFXSProxy(address _proxyAddress) internal{
        //set proxy address on staking contract
        IFraxFarmBase(stakingAddress).stakerSetVeFXSProxy(_proxyAddress);
        usingProxy = _proxyAddress;
    }


    function getReward() external virtual{}
    function getReward(bool _claim) external virtual{}
    function getReward(bool _claim, address[] calldata _rewardTokenList) external virtual{}
    function earned() external view virtual returns (address[] memory token_addresses, uint256[] memory total_earned){}


    //checkpoint and add/remove weight to convex rewards contract
    function _checkpointRewards() internal{
        //if rewards are active, checkpoint
        if(IRewards(rewards).active()){
            //using liquidity shares from staking contract will handle rebasing tokens correctly
            uint256 userLiq = IFraxFarmBase(stakingAddress).lockedLiquidityOf(address(this));
            //get current balance of reward contract
            uint256 bal = IRewards(rewards).balanceOf(address(this));
            if(userLiq >= bal){
                //add the difference to reward contract
                IRewards(rewards).deposit(owner, userLiq - bal);
            }else{
                //remove the difference from the reward contract
                IRewards(rewards).withdraw(owner, bal - userLiq);
            }
        }
    }

    //apply fees to fxs and send remaining to owner
    function _processFxs() internal{

        //get fee rate from fee registry
        uint256 totalFees = IFeeRegistry(feeRegistry).totalFees();

        //send fxs fees to fee deposit
        uint256 fxsBalance = IERC20(fxs).balanceOf(address(this));
        uint256 sendAmount = fxsBalance * totalFees / FEE_DENOMINATOR;
        if(sendAmount > 0){
            IERC20(fxs).transfer(IFeeRegistry(feeRegistry).getFeeDepositor(usingProxy), sendAmount);
        }

        //transfer remaining fxs to owner
        sendAmount = IERC20(fxs).balanceOf(address(this));
        if(sendAmount > 0){
            IERC20(fxs).transfer(owner, sendAmount);
        }
    }

    //get extra rewards
    function _processExtraRewards() internal{
        if(IRewards(rewards).active()){
            //check if there is a balance because the reward contract could have be activated later
            //dont use _checkpointRewards since difference of 0 will still call deposit() and cost gas
            uint256 bal = IRewards(rewards).balanceOf(address(this));
            uint256 userLiq = IFraxFarmBase(stakingAddress).lockedLiquidityOf(address(this));
            if(bal == 0 && userLiq > 0){
                //bal == 0 and liq > 0 can only happen if rewards were turned on after staking
                IRewards(rewards).deposit(owner,userLiq);
            }
            IRewards(rewards).getReward(owner);
        }
    }

    //transfer other reward tokens besides fxs(which needs to have fees applied)
    function _transferTokens(address[] memory _tokens) internal{
        //transfer all tokens
        for(uint256 i = 0; i < _tokens.length; i++){
            if(_tokens[i] != fxs){
                uint256 bal = IERC20(_tokens[i]).balanceOf(address(this));
                if(bal > 0){
                    IERC20(_tokens[i]).safeTransfer(owner, bal);
                }
            }
        }
    }
}

// File: contracts/contracts/interfaces/IConvexWrapperV2.sol


interface IConvexWrapperV2{

   struct EarnedData {
        address token;
        uint256 amount;
    }

  function collateralVault() external view returns(address vault);
  function convexPoolId() external view returns(uint256 _poolId);
  function curveToken() external view returns(address);
  function convexToken() external view returns(address);
  function balanceOf(address _account) external view returns(uint256);
  function totalBalanceOf(address _account) external view returns(uint256);
  function deposit(uint256 _amount, address _to) external;
  function stake(uint256 _amount, address _to) external;
  function withdraw(uint256 _amount) external;
  function withdrawAndUnwrap(uint256 _amount) external;
  function getReward(address _account) external;
  function getReward(address _account, address _forwardTo) external;
  function rewardLength() external view returns(uint256);
  function earned(address _account) external returns(EarnedData[] memory claimable);
  function earnedView(address _account) external view returns(EarnedData[] memory claimable);
  function setVault(address _vault) external;
  function user_checkpoint(address[2] calldata _accounts) external returns(bool);
}
// File: contracts/contracts/interfaces/ICurveConvex.sol


interface ICurveConvex {
   function earmarkRewards(uint256 _pid) external returns(bool);
   function earmarkFees() external returns(bool);
   function poolInfo(uint256 _pid) external returns(address _lptoken, address _token, address _gauge, address _crvRewards, address _stash, bool _shutdown);
}
// File: contracts/contracts/StakingProxyConvexTransfersByIndex.sol


/// @notice Testing was completed in a separate repository: https://github.com/ZrowGz/frax-transfers.git

contract StakingProxyConvex is StakingProxyBase, ReentrancyGuard{
    using SafeERC20 for IERC20;

    error ConfirmationFailed();
    error NonVaultReceiver();

    using SafeERC20 for IERC20;

    address public constant poolRegistry = address(0x41a5881c17185383e19Df6FA4EC158a6F4851A69);//0x7413bFC877B5573E29f964d572f421554d8EDF86);
    address public constant convexCurveBooster = address(0xF403C135812408BFbE8713b5A23a04b3D48AAE31);
    address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
    address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);

    address public curveLpToken;
    address public convexDepositToken;

    //the poolId for calling vaultMap in the registry to verify a receiver is a legitimate convex vault (for lock transfers)
    uint256 public constant poolId = 36; //made constant so that it gets written to the bytecode

    constructor() {
    }

    function vaultType() external pure override returns(VaultType){
        return VaultType.Convex;
    }

    function vaultVersion() external pure override returns(uint256){
        return 4;
    }

    /// @notice before transfer hook called to sender of lock - checks that receiver is a known convex vault & claims rewards
    /// @dev required to happen because `transferFrom` would otherwise bypass the recipient check
    function beforeLockTransfer(address sender, address receiver, uint256 lockId, bytes memory data) external returns (bytes4) {
        //check that the receiver is a legitimate convex vault
        require(sender == address(this), "!Sender");
        require(msg.sender == stakingAddress, "caller!staker");
        if (receiver != ITransferChecker(poolRegistry).vaultMap(poolId, IProxyVault(receiver).owner())) revert NonVaultReceiver();
        
        /// FraxFarm will execute it's getReward, so we only need to process all other rewards logic first.
        claimOnTransfer();

        // call the owner, if is a contract
        if (owner.code.length > 0) {
            return ILockReceiver(owner).beforeLockTransfer(sender, receiver, lockId, data);
        } else {
            return ILockReceiver.beforeLockTransfer.selector;
        }
    }

    function onLockReceived(address sender, address receiver, uint256 lockId, bytes memory data) external returns (bytes4) {
        // if the owner of the vault is a contract try calling onLockReceived on it, return the selector either way
        require(receiver == address(this) && msg.sender == stakingAddress, "invalid after params");
        if (owner.code.length > 0) {
            return ILockReceiver(owner).onLockReceived(sender, receiver, lockId, data);
        } else {
            return ILockReceiver.onLockReceived.selector;
        }
    }

    //initialize vault
    /// TODO @dev the improved initializer should be enabled in real life
    function initialize(address _owner, address _stakingAddress, address _stakingToken, address _rewardsAddress) external override{//, address _poolRegistry, uint256 _pid) external override{
        require(owner == address(0),"already init");

        //set variables
        owner = _owner;
        stakingAddress = _stakingAddress;
        stakingToken = _stakingToken;
        rewards = _rewardsAddress;

        // set the pool registry & poolId for looking up vault validity on lock transfers
        // poolRegistry = _poolRegistry;
        // poolId = _pid; /// TODO not commented out in actual contract!

        //get tokens from pool info
        (address _lptoken, address _token,,, , ) = ICurveConvex(convexCurveBooster).poolInfo(poolId);

        curveLpToken = _lptoken;
        convexDepositToken = _token;

        //set infinite approvals
        IERC20(_stakingToken).approve(_stakingAddress, type(uint256).max);
        IERC20(_lptoken).approve(_stakingToken, type(uint256).max);
        IERC20(_token).approve(_stakingToken, type(uint256).max);
    }


    //create a new locked state of _secs timelength with a Curve LP token
    function stakeLockedCurveLp(uint256 _liquidity, uint256 _secs) external onlyOwner nonReentrant returns (uint256 lockId){
        if(_liquidity > 0){
            //pull tokens from user
            IERC20(curveLpToken).safeTransferFrom(msg.sender, address(this), _liquidity);

            //deposit into wrapper
            IConvexWrapperV2(stakingToken).deposit(_liquidity, address(this));

            //stake
            lockId = IFraxFarmERC20(stakingAddress).stakeLocked(_liquidity, _secs);
        }
        
        //checkpoint rewards
        _checkpointRewards();
    }

    //create a new locked state of _secs timelength with a Convex deposit token
    function stakeLockedConvexToken(uint256 _liquidity, uint256 _secs) external onlyOwner nonReentrant returns (uint256 lockId){
        if(_liquidity > 0){
            //pull tokens from user
            IERC20(convexDepositToken).safeTransferFrom(msg.sender, address(this), _liquidity);

            //stake into wrapper
            IConvexWrapperV2(stakingToken).stake(_liquidity, address(this));

            //stake into frax
            lockId = IFraxFarmERC20(stakingAddress).stakeLocked(_liquidity, _secs);
        }
        
        //checkpoint rewards
        _checkpointRewards();
    }

    //create a new locked state of _secs timelength
    function stakeLocked(uint256 _liquidity, uint256 _secs) external onlyOwner nonReentrant returns (uint256 lockId){
        if(_liquidity > 0){
            //pull tokens from user
            IERC20(stakingToken).safeTransferFrom(msg.sender, address(this), _liquidity);

            //stake
            lockId = IFraxFarmERC20(stakingAddress).stakeLocked(_liquidity, _secs);
        }
        
        //checkpoint rewards
        _checkpointRewards();
    }

    //add to a current lock
    function lockAdditional(uint256 _lockId, uint256 _addl_liq) external onlyOwner nonReentrant{
        if(_addl_liq > 0){
            //pull tokens from user
            IERC20(stakingToken).safeTransferFrom(msg.sender, address(this), _addl_liq);

            //add stake
            IFraxFarmERC20(stakingAddress).lockAdditional(_lockId, _addl_liq);
        }
        
        //checkpoint rewards
        _checkpointRewards();
    }

    //add to a current lock
    function lockAdditionalCurveLp(uint256 _lockId, uint256 _addl_liq) external onlyOwner nonReentrant{
        if(_addl_liq > 0){
            //pull tokens from user
            IERC20(curveLpToken).safeTransferFrom(msg.sender, address(this), _addl_liq);

            //deposit into wrapper
            IConvexWrapperV2(stakingToken).deposit(_addl_liq, address(this));

            //add stake
            IFraxFarmERC20(stakingAddress).lockAdditional(_lockId, _addl_liq);
        }
        
        //checkpoint rewards
        _checkpointRewards();
    }

    //add to a current lock
    function lockAdditionalConvexToken(uint256 _lockId, uint256 _addl_liq) external onlyOwner nonReentrant{
        if(_addl_liq > 0){
            //pull tokens from user
            IERC20(convexDepositToken).safeTransferFrom(msg.sender, address(this), _addl_liq);

            //stake into wrapper
            IConvexWrapperV2(stakingToken).stake(_addl_liq, address(this));

            //add stake
            IFraxFarmERC20(stakingAddress).lockAdditional(_lockId, _addl_liq);
        }
        
        //checkpoint rewards
        _checkpointRewards();
    }

    // Extends the lock of an existing stake
    function lockLonger(uint256 _lockId, uint256 new_ending_ts) external onlyOwner nonReentrant{
        //update time
        IFraxFarmERC20(stakingAddress).lockLonger(_lockId, new_ending_ts);

        //checkpoint rewards
        _checkpointRewards();
    }

    //withdraw a staked position
    //frax farm transfers first before updating farm state so will checkpoint during transfer
    function withdrawLocked(uint256 _lockId) external onlyOwner nonReentrant{        
        //withdraw directly to owner(msg.sender)
        IFraxFarmERC20(stakingAddress).withdrawLocked(_lockId, msg.sender);

        //checkpoint rewards
        _checkpointRewards();
    }

    //withdraw a staked position
    //frax farm transfers first before updating farm state so will checkpoint during transfer
    function withdrawLockedAndUnwrap(uint256 _lockId) external onlyOwner nonReentrant{
        //withdraw
        IFraxFarmERC20(stakingAddress).withdrawLocked(_lockId, address(this));

        //unwrap
        IConvexWrapperV2(stakingToken).withdrawAndUnwrap(IERC20(stakingToken).balanceOf(address(this)));
        IERC20(curveLpToken).transfer(owner,IERC20(curveLpToken).balanceOf(address(this)));

        //checkpoint rewards
        _checkpointRewards();
    }

    ////////// Lock Management Authorization //////////
    function setAllowance(address spender, uint256 _lockId, uint256 amount) external onlyOwner{
        IFraxFarmERC20(stakingAddress).setAllowance(spender, _lockId, amount);
    }
    function increaseAllowance(address spender, uint256 _lockId, uint256 amount) external onlyOwner{
        IFraxFarmERC20(stakingAddress).increaseAllowance(spender, _lockId, amount);
    }
    function removeAllowance(address spender, uint256 _lockId) external onlyOwner {
        IFraxFarmERC20(stakingAddress).removeAllowance(spender, _lockId);
    }
    function setApprovalForAll(address spender, bool approved) external onlyOwner {
        IFraxFarmERC20(stakingAddress).setApprovalForAll(spender, approved);
    }

    /// TODO transferLockedFrom isn't called here, but if transferLocked 

    // transfer a locked stake to another address
    function transferLocked(address receiver_address, uint256 sender_lock_index, uint256 transfer_amount, bool use_receiver_lock_index, uint256 receiver_lock_index) external onlyOwner nonReentrant returns(uint256,uint256){
        /// @dev the vault check is done in the beforeLockTransfer hook

        // Transfer the amount
        return(IFraxFarmERC20(stakingAddress).transferLocked(receiver_address, sender_lock_index, transfer_amount, use_receiver_lock_index, receiver_lock_index));
    }

    function claimOnTransfer() public{
        //claim convex farm and forward to owner
        IConvexWrapperV2(stakingToken).getReward(address(this),owner);

        //double check there have been no crv/cvx claims directly to this address
        uint256 b = IERC20(crv).balanceOf(address(this));
        if(b > 0){
            IERC20(crv).safeTransfer(owner, b);
        }
        b = IERC20(cvx).balanceOf(address(this));
        if(b > 0){
            IERC20(cvx).safeTransfer(owner, b);
        }

        //process fxs fees
        _processFxs();

        //get list of reward tokens

        address[] memory rewardTokens = IFraxFarmERC20(stakingAddress).getAllRewardTokens();

        //transfer

        _transferTokens(rewardTokens);

        //extra rewards
        _processExtraRewards();
    }

    //helper function to combine earned tokens on staking contract and any tokens that are on this vault
    function earned() external view override returns (address[] memory token_addresses, uint256[] memory total_earned) {
        //get list of reward tokens
        address[] memory rewardTokens = IFraxFarmERC20(stakingAddress).getAllRewardTokens();
        uint256[] memory stakedearned = IFraxFarmERC20(stakingAddress).earned(address(this));
        IConvexWrapperV2.EarnedData[] memory convexrewards = IConvexWrapperV2(stakingToken).earnedView(address(this));

        uint256 extraRewardsLength = IRewards(rewards).rewardTokenLength();
        token_addresses = new address[](rewardTokens.length + extraRewardsLength + convexrewards.length);
        total_earned = new uint256[](rewardTokens.length + extraRewardsLength + convexrewards.length);

        //add any tokens that happen to be already claimed but sitting on the vault
        //(ex. withdraw claiming rewards)
        for(uint256 i = 0; i < rewardTokens.length; i++){
            token_addresses[i] = rewardTokens[i];
            total_earned[i] = stakedearned[i] + IERC20(rewardTokens[i]).balanceOf(address(this));
        }

        IRewards.EarnedData[] memory extraRewards = IRewards(rewards).claimableRewards(address(this));
        for(uint256 i = 0; i < extraRewards.length; i++){
            token_addresses[i+rewardTokens.length] = extraRewards[i].token;
            total_earned[i+rewardTokens.length] = extraRewards[i].amount;
        }

        //add convex farm earned tokens
        for(uint256 i = 0; i < convexrewards.length; i++){
            token_addresses[i+rewardTokens.length+extraRewardsLength] = convexrewards[i].token;
            total_earned[i+rewardTokens.length+extraRewardsLength] = convexrewards[i].amount;
        }
    }

    /*
    claim flow:
        claim rewards directly to the vault
        calculate fees to send to fee deposit
        send fxs to a holder contract for fees
        get reward list of tokens that were received
        send all remaining tokens to owner
    A slightly less gas intensive approach could be to send rewards directly to a holder contract and have it sort everything out.
    However that makes the logic a bit more complex as well as runs a few future proofing risks
    */
    function getReward() external override{
        getReward(true);
    }

    //get reward with claim option.
    //_claim bool is for the off chance that rewardCollectionPause is true so getReward() fails but
    //there are tokens on this vault for cases such as withdraw() also calling claim.
    //can also be used to rescue tokens on the vault
    function getReward(bool _claim) public override{

        //claim
        if(_claim){
            //claim frax farm
            IFraxFarmERC20(stakingAddress).getReward(address(this));
            //claim convex farm and forward to owner
            IConvexWrapperV2(stakingToken).getReward(address(this),owner);

            //double check there have been no crv/cvx claims directly to this address
            uint256 b = IERC20(crv).balanceOf(address(this));
            if(b > 0){
                IERC20(crv).safeTransfer(owner, b);
            }
            b = IERC20(cvx).balanceOf(address(this));
            if(b > 0){
                IERC20(cvx).safeTransfer(owner, b);
            }
        }

        //process fxs fees
        _processFxs();

        //get list of reward tokens
        address[] memory rewardTokens = IFraxFarmERC20(stakingAddress).getAllRewardTokens();

        //transfer
        _transferTokens(rewardTokens);

        //extra rewards
        _processExtraRewards();
    }

    //auxiliary function to supply token list(save a bit of gas + dont have to claim everything)
    //_claim bool is for the off chance that rewardCollectionPause is true so getReward() fails but
    //there are tokens on this vault for cases such as withdraw() also calling claim.
    //can also be used to rescue tokens on the vault
    function getReward(bool _claim, address[] calldata _rewardTokenList)  external override{
        //claim
        if(_claim){
            //claim frax farm
            IFraxFarmERC20(stakingAddress).getReward(address(this));
            //claim convex farm and forward to owner
            IConvexWrapperV2(stakingToken).getReward(address(this),owner);
        }

        //process fxs fees
        _processFxs();

        //transfer
        _transferTokens(_rewardTokenList);

        //extra rewards
        _processExtraRewards();
    }

}