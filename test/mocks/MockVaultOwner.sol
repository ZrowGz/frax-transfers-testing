// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @notice Spoofs a code-containing vault owner, so that it can return the onLockReceived selector

import "lib/forge-std/src/console2.sol";

contract MockVaultOwner {
    function beforeLockTransfer(
        address,
        address,
        uint256,
        bytes calldata
    ) external view returns (bytes4) {
        console2.log("VAULT OWNER CALLED BEFORE lock transfer", address(this));
        console2.logBytes4(this.beforeLockTransfer.selector);
        return this.beforeLockTransfer.selector;
    }
    function onLockReceived(
        address,
        address,
        uint256,
        bytes calldata
    ) external view returns (bytes4) {
        console2.log("VAULT OWNER CALLED AFTER lock transfer", address(this));
        return this.onLockReceived.selector;
    }
}