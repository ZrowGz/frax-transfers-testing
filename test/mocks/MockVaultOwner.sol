// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @notice Spoofs a code-containing vault owner, so that it can return the onLockReceived selector

import "lib/forge-std/src/console2.sol";
import "../../src/interfaces/ILockReceiver.sol";

contract MockVaultOwner {

    function beforeLockTransfer(
        address,
        address,
        uint256,
        bytes calldata
    ) external returns (bytes4) {
        return this.beforeLockTransfer.selector;
    }
    function onLockReceived(
        address,
        address,
        uint256,
        bytes calldata
    ) external returns (bytes4) {
        return this.onLockReceived.selector;
    }
}