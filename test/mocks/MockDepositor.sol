// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

// import "@interfaces/ITokenMinter.sol";
// import "@interfaces/IVoteEscrow.sol";
// import "@interfaces/IVoterProxy.sol";
// import "@openzeppelin-upgradeable/contracts/access/OwnableUpgradeable.sol";
// import "@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
// import "@openzeppelin-upgradeable/contracts/token/ERC20/IERC20Upgradeable.sol";
// import "@openzeppelin-upgradeable/contracts/token/ERC20/utils/SafeERC20Upgradeable.sol";

// contract MockDepositor is OwnableUpgradeable, UUPSUpgradeable {
//     using SafeERC20Upgradeable for IERC20Upgradeable;

//     address public staker;
//     address public minter;
//     address public fxs;
//     address public veFXS;

//     error AlreadyInitialized();
//     event Locked();

//     function initialize(
//         address _staker,
//         address _minter,
//         address _fxs,
//         address _veFXS
//     ) public initializer {
//         if (owner() != address(0)) revert AlreadyInitialized();
//         __UUPSUpgradeable_init_unchained();
//         __Context_init_unchained();
//         __Ownable_init_unchained();
//         staker = _staker;
//         minter = _minter;
//         fxs = _fxs;
//         veFXS = _veFXS;
//     }

//     function deposit(uint256 _amount, bool _lock) public {
//         // transfer the tokens over so it doesn't cause problems for calculations down the road in the test
//         IERC20Upgradeable(fxs).safeTransferFrom(msg.sender, staker, _amount);

//         // mint the tokens, don't worry about other things...
//         if (_lock) {
//             lockFXS();
//         }

//         // Mint token for sender
//         ITokenMinter(minter).mint(msg.sender, _amount);
//     }

//     function lockFXS() public {
//         // mint baybee mint!
//         emit Locked();
//     }

//     // used to manage upgrading the contract
//     function _authorizeUpgrade(address) internal override onlyOwner {}
// }
