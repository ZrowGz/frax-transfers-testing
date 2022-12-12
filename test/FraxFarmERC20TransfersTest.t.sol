// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";

// frax contracts
// import "@staking/FraxUnifiedFarm_ERC20.sol";
import "../src/FraxFarmERC20Transferrable.sol";
// convex contracts
//import "@convex/StakingProxyConvex.sol";
//import "../src/ConvexVaultTransferrable.sol";

// external mocks
import "@fraxmocks/MockConvexVault.sol";
import "@fraxmocks/MockConvexRegistry.sol";
import {MockERC20, MockFraxswapLP} from "@mocks/MockERC20.sol";
import {MockGaugeController} from "@mocks/MockGaugeController.sol";
import {MockRewardsDistributor} from "@mocks/MockRewardsDistributor.sol";

contract FraxFarmERC20TransfersTest is Test, FraxUnifiedFarm_ERC20 {//, StakingProxyConvex {
    FraxUnifiedFarm_ERC20 public frxEthFarm;
    //StakingProxyConvex public cvxVault;
    MockConvexRegistry public mockRegistry;
    MockGaugeController public gaugeController;
    MockRewardsDistributor public fraxRewardDistributor;
    MockERC20 public frax;
    MockERC20 public fxs;
    MockERC20 public veFXS;
    // cvx? 
    
    // convex addresses
    address public frxEth = 0x5E8422345238F34275888049021821E8E08CAa1f;
    address public frxETHCRV = 0xf43211935C781D5ca1a41d2041F397B8A7366C7A;
    address public cvxStkFrxEthLp = 0x4659d5fF63A1E1EDD6D5DD9CC315e063c95947d0;
    address public frxFarm = 0xa537d64881b84faffb9Ae43c951EEbF368b71cdA; // frxEthFraxFarm
    address public fraxToken = 0x853d955aCEf822Db058eb8505911ED77F175b99e; // FRAX
    address public fxs = address(0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0); // FXS
    address public vefxs = address(0xc8418aF6358FFddA74e09Ca9CC3Fe03Ca6aDC5b0); // veFXS
    address public fraxAdmin = address(0xB1748C79709f4Ba2Dd82834B8c82D4a505003f27); // Frax Admin
    address public controller = address(0x3669C421b77340B2979d1A00a792CC2ee0FcE737); // Sets Gauge Params
    /// TODO get these values
    address public newGauge = address(0x24C66Ba25ca2A53bB97B452B9F45DD075b07Cf55); // New Gauge/LP Staking
    address public distributor = 0x278dC748edA1d8eFEf1aDFB518542612b49Fcd34; // Gauge Reward Distro

    // Local values
    address[] private _rewardTokens;
    address[] private _rewardManagers;
    uint256[] private _rewardRates;
    address[] private _gaugeControllers;
    address[] private _rewardDistributors;

    function setUp() public {
        veFXS = new MockERC20("veFXS", "veFXS", 18);
        frax = new MockERC20("Frax", "FRAX", 18);
        fxs = new MockERC20("FXS", "FXS", 18);
        gaugeController = new MockGaugeController(89850835663, 89850835663, 144675925925);

        // Set the rewards parameters
        _rewardManagers.push(address(this));
        _rewardManagers.push(address(this));
        _rewardRates.push(12345); // half as much fxs as pitch
        _rewardRates.push(24690); // twice as many pitch as fxs
        _rewardDistributors.push(address(fraxRewardDistributor));

        vm.etch(fraxToken, address(frax).code);
        frax = MockERC20(fraxToken);        
        
        _rewardTokens.push(address(fxs));
        _rewardTokens.push(address(frax));

        vm.etch(vf, address(veFXS).code); // mocking veFXS

        /// TODO establish the rest of the necessary tokens for both frax & convex

        vm.prank(fraxAdmin);
        IFraxGaugeController(controller).commit_transfer_ownership(here);
        vm.prank(fraxAdmin);
        IFraxGaugeController(controller).apply_transfer_ownership();
        vm.etch(controller, address(gaugeController).code); // mocking FraxGaugeController
        _gaugeControllers.push(address(gaugeController));
        _gaugeControllers.push(address(gaugeController));

        frxEthFarm = new FraxUnifiedFarm_ERC20(address(this), _rewardTokens, _rewardManagers, _rewardRates, _gaugeControllers, _rewardDistributors, cvxStkFrxEthLp);

        // set up the frxEth gauge
        frxEthFarm = new FraxFarmERC20(
            address(this),
            _rewardTokens,
            _rewardManagers,
            _rewardRates,
            _gaugeControllers,
            _rewardDistributors,
            address(pitchFxsFrax)
        );


        vm.prank(fraxAdmin);
        IFraxFarmERC20(newGauge).nominateNewOwner(address(this));
        IFraxFarmERC20(newGauge).acceptOwnership();

    }
}
