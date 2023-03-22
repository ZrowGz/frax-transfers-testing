// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";

import {FraxUnifiedFarm_ERC20_Convex_frxETH_V2 as FraxUnifiedFarm_ERC20_V2} from "@staking/Variants/FraxUnifiedFarm_ERC20_Convex_frxETH_V2.sol";
// import {FRAXStablecoin} from "frax/../Frax/Frax.sol";
import {IFraxFarmERC20} from "@convex/interfaces/IFraxFarmERC20.sol";
import "@convex/interfaces/IFraxGaugeController.sol";

import {FraxFamilialPitchGauge} from  "src/FraxFamilialPitchGauge.sol";
import {FraxFamilialGaugeDistributor} from  "src/FraxFamilialGaugeDistributor.sol";
import "./mocks/MockERC20.sol";
// import {MockFraxGaugeController} from "@mocks/MockGaugeController.sol";
import {GaugeController} from "@mocks/FraxGaugeController.sol";
import {FraxGaugeFXSRewardsDistributor} from "@mocks/FraxFXSRewardDistributor.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IDeposits {
    function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function deposit(uint256 _amount) external;
    function deposit(uint256 _amount, address _to) external;
    function depositAll(uint256 poolId, bool andStake) external;
}

contract FamilialGaugeTest is Test {
    // MockFraxGaugeController public gaugeController;
    GaugeController public gaugeController;
    FraxGaugeFXSRewardsDistributor public fxsDistributor;

    FraxUnifiedFarm_ERC20_V2 public transferrableFarm;
    FraxFamilialGaugeDistributor public frxFamilyDistributor;
    FraxFamilialPitchGauge public frxFamilyGauge;

    // MockERC20 public rewardToken;
    // MockLp public mockLp;
    MockVotes public votes;

    address public alice;
    address public bob;
    
    address public frxEth = 0x5E8422345238F34275888049021821E8E08CAa1f;
    address public frxETHCRV = 0xf43211935C781D5ca1a41d2041F397B8A7366C7A; // frxeth/eth crv LP token
    address public cvxfrxEthFrxEth = address(0xC07e540DbFecCF7431EA2478Eb28A03918c1C30E);
    address public cvxStkFrxEthLp = 0x4659d5fF63A1E1EDD6D5DD9CC315e063c95947d0; // convex wrapped curve lp token STAKING TOKEN
    address public curveLpMinter = address(0xa1F8A6807c402E4A15ef4EBa36528A3FED24E577);
    address public frxEthMinter = address(0xbAFA44EFE7901E04E39Dad13167D089C559c1138);

    FraxUnifiedFarm_ERC20_V2 public frxEthFarm = FraxUnifiedFarm_ERC20_V2(0xa537d64881b84faffb9Ae43c951EEbF368b71cdA); // frxEthFraxFarm
    FraxGaugeFXSRewardsDistributor public _fxsDistributor = FraxGaugeFXSRewardsDistributor(0x278dC748edA1d8eFEf1aDFB518542612b49Fcd34); // Gauge Reward Distro
    GaugeController public _gaugeController = GaugeController(0x3669C421b77340B2979d1A00a792CC2ee0FcE737);
    // address public rewardManager = address(0xB1748C79709f4Ba2Dd82834B8c82D4a505003f27);
    address public fraxAdmin = address(0xB1748C79709f4Ba2Dd82834B8c82D4a505003f27);

    address public fraxToken = 0x853d955aCEf822Db058eb8505911ED77F175b99e; // FRAX
    address public fxs = address(0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0); // FXS
    address public fxsWhale = address(0xF977814e90dA44bFA03b6295A0616a897441aceC);

    // Local values
    address[] private _rewardTokens;
    address[] private _rewardManagers;
    uint256[] private _rewardRates;
    address[] private _gaugeControllers;
    address[] private _rewardDistributors;
    address[] private _childGauges;

    // uint256 public nonTransferrableGaugeTVL; 
    // uint256 public transferrableGaugeTVL;
    // random global state vars
    bytes public retval;
    uint256 public retbal;
    uint256 public senderPreAdd;
    uint256 public senderBaseLockedLiquidity;
    uint256 public senderLock;
    uint256 public senderPostAdd;
    uint256 public senderInitialLockedLiquidity;
    uint256 public lockDuration = (60*60*24*300);
    uint256 public aliceLockAmount;
    uint256 public frxEthFarmBalance;
    uint256 public transferrableFarmBalance;
    uint256 public frxFamilyGaugeBalance;
    uint256 public fxsDistributorBalance;

    function setUp() public {
        // deploy a token that will count as if it were veFXS just for pretendsies
        votes = new MockVotes("Votes", "VOTES", 18);

        // deploy the new gauge controller for testing with
        gaugeController = new GaugeController(
            address(votes), 
            address(votes)
        );
        // add the gauge type (from actual FraxGaugeController deployment)
        gaugeController.add_type("Ethereum", 1000000000000000000);
        // set global emission rate to 100 FXS per week (roughly)
        gaugeController.change_global_emission_rate(165343915343915);

        // deploy the new reward distro for testing with
        fxsDistributor = new FraxGaugeFXSRewardsDistributor(
            address(this),
            address(this),
            address(this), 
            address(fxs),
            address(gaugeController)
        );

        // deploy the familial token manager/reward distributor/controller
        frxFamilyDistributor = new FraxFamilialGaugeDistributor(
            "frxETHETH Family Gauge",
            address(this),
            address(this),
            address(fxsDistributor),
            address(gaugeController)
        );

        // Set the rewards parameters
        _rewardTokens.push(address(fxs));
        // _rewardTokens.push(address(fxs));
        _rewardManagers.push(address(frxFamilyDistributor));
        // _rewardManagers.push(address(this)); /// not doing this would mean the farms have different reward managers...
        _rewardRates.push(100000000000000); // 165343915343915 = 100 ether / week total
        // _rewardRates.push(24690); // twice as many pitch as fxs
        _rewardDistributors.push(address(frxFamilyDistributor));
        _gaugeControllers.push(address(0));

        // Deploy the logic for the transferrable fraxfarm
        transferrableFarm = new FraxUnifiedFarm_ERC20_V2(address(this), _rewardTokens, _rewardManagers, _rewardRates, _gaugeControllers, _rewardDistributors, cvxStkFrxEthLp);

        /// Set up the controller, familial, distributors, and old farm
        // Add the two child gauges to the `_gauges` array
        _childGauges.push(address(transferrableFarm));
        _childGauges.push(address(frxEthFarm));
        // add the familial gauge to the gauge controller
        gaugeController.add_gauge(address(frxFamilyDistributor), int128(0), uint256(1000));
        // add some other address to the controller (to vote on)
        gaugeController.add_gauge(address(69420), int128(0), uint256(1000));
        // add the children to the family
        frxFamilyDistributor.addChildren(_childGauges);
        // shut off rewards to the non-transferrable farm at the distributor
        /// @dev in practice, we wouldn't be deploying a new controller & distributor. In that case, this would be needed:
        /// note see above ^ fxsDistributor.setGaugeState(address(transferrableFarm), false, false);
        // add the family gauge to the distributor
        fxsDistributor.setGaugeState(address(frxFamilyDistributor), false, true);


        /// Change all the necessary state variables
        vm.startPrank(address(fraxAdmin));
        // set the reward distributor as the token manager so it can set values
        frxEthFarm.changeTokenManager(address(fxs), address(frxFamilyDistributor));
        // set the non-transferrable farm to point to the correct addresses (reward token, rate, gaugecontroller, distributor
        frxEthFarm.setRewardVars(address(fxs), 100000000000000, address(0), address(frxFamilyDistributor));
        vm.stopPrank();

        // create two users
        alice = vm.addr(0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef);
        vm.label(alice, "Alice");
        bob = vm.addr(0xeeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef);
        vm.label(bob, "Bob");

        // Give the users some ETH
        vm.deal(address(alice), 1e10 ether);
        vm.deal(address(bob), 1e10 ether);
        // vm.deal(address(this), 1e10 ether);
        votes.mint(address(this), 1000000 ether);
        votes.mint(address(alice), 500000 ether);
        votes.mint(address(bob), 500000 ether);

        gaugeController.checkpoint_gauge(address(frxFamilyDistributor));
        gaugeController.vote_for_gauge_weights(address(frxFamilyDistributor), 8000);
        gaugeController.vote_for_gauge_weights(address(69420), 2000);
        gaugeController.checkpoint_gauge(address(frxFamilyDistributor));

        // pull in some FXS to be able to use as needed
        vm.startPrank(fxsWhale);
        IERC20(fxs).transfer(address(this), 200000 ether);
        vm.stopPrank();

        // seed the contracts with some FXS to start
        IERC20(fxs).transfer(address(fxsDistributor), 1000 ether);
        IERC20(fxs).transfer(address(transferrableFarm), 100 ether);

        // Create some stakes
        vm.startPrank(address(alice));
        /// obtain some frxEth
        frxEthMinter.call{value: 10000 ether}(abi.encodeWithSignature("submit()"));
        (, bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        retbal = abi.decode(retval, (uint256));
        assertGe(retbal, 9900 ether, "invalid mint amount frxETH");

        /// deposit it as LP into the curve pool
        IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
        IDeposits(curveLpMinter).add_liquidity([uint256(0), retbal], 990 ether);
        retbal = IDeposits(frxETHCRV).balanceOf(address(alice));
        assertGt(retbal, 9900 ether, "invalid minimum mint amount frxETHCRV");

        /// Wrap the curve LP tokens into cvxStkFrxEthLp
        IDeposits(address(frxETHCRV)).approve(address(cvxStkFrxEthLp), type(uint256).max);
        cvxStkFrxEthLp.call(abi.encodeWithSignature("deposit(uint256,address)", retbal, address(alice)));

        // should be equal to the previous value, but better safe than annoyed
        aliceLockAmount = IDeposits(cvxStkFrxEthLp).balanceOf(address(alice));

        /// Since the `etch` completely overwrites the existing contract storage, pull these values to double check at each step
        senderPreAdd = transferrableFarm.lockedStakesOfLength(address(alice));
        senderBaseLockedLiquidity = transferrableFarm.lockedLiquidityOf(address(alice));

        /// create a known locked stake
        IDeposits(address(cvxStkFrxEthLp)).approve(address(transferrableFarm), type(uint256).max);
        senderLock = transferrableFarm.manageStake(aliceLockAmount, lockDuration, false, 0);
        senderPostAdd = transferrableFarm.lockedStakesOfLength(address(alice));
        assertEq(senderPostAdd, senderPreAdd + 1, "sender should have new LockedStake");
        senderInitialLockedLiquidity = transferrableFarm.lockedLiquidityOf(address(alice));
        console2.log("senderInitialLockedLiquidity", senderInitialLockedLiquidity);

        vm.stopPrank();
        transferrableFarm.sync();
        frxEthFarm.sync();

        // store the balances
        transferrableFarmBalance = IERC20(fxs).balanceOf(address(transferrableFarm));
        frxEthFarmBalance = IERC20(fxs).balanceOf(address(frxEthFarm));
        frxFamilyGaugeBalance = IERC20(fxs).balanceOf(address(frxFamilyDistributor));
        fxsDistributorBalance = IERC20(fxs).balanceOf(address(fxsDistributor));

    }

    function testClaimRewards() public {
        //
        (, bytes memory retval) = fxs.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        uint256 aliceFXSBalPrior = abi.decode(retval, (uint256));
        console2.log("aliceFXSBalPrior", aliceFXSBalPrior);

        vm.startPrank(address(alice));

        skip(2 days);
                // claim rewards
        transferrableFarm.getReward(address(alice));

        // check the rewards
        (, retval) = fxs.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        uint256 aliceFXSBalPost1 = abi.decode(retval, (uint256));
        assertGt(aliceFXSBalPost1, aliceFXSBalPrior, "alice should have some rewards");
        console2.log("aliceFXSBalPost1", aliceFXSBalPost1);

        // skip forward far enough that we can resync things
        skip(7 days);
        gaugeController.checkpoint_gauge(address(frxFamilyDistributor));

        // claim rewards
        transferrableFarm.getReward(address(alice));

        // check the rewards
        (, retval) = fxs.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        uint256 aliceFXSBalPost2 = abi.decode(retval, (uint256));
        assertGt(aliceFXSBalPost2, aliceFXSBalPost1, "alice should have some rewards");
        console2.log("aliceFXSBalPost1", aliceFXSBalPost2);

        // skip forward beyond the reward period
        skip(7 days + 1);
        gaugeController.checkpoint_gauge(address(frxFamilyDistributor));

        // claim rewards
        transferrableFarm.getReward(address(alice));

        ///////////////// 
        console2.log("amountSentThisRound removed for non-testing use");
        /// @dev NOTE the `amountSentThisRound` is commented out - it is for debugging purposes only
        /// @dev these values did check out during the test, but they are not necessary for real world use
        // uint256 amtSentToFamily = fxsDistributor.amountSentThisRound(address(frxFamilyDistributor));
        // assertGe(amtSentToFamily, 79 ether, "family should have received 80% of the rewards");
        // uint256 amtSentToTransferrable = frxFamilyDistributor.amountSentThisRound(address(transferrableFarm));
        // uint256 amtSentToNonTransferrable = frxFamilyDistributor.amountSentThisRound(address(frxEthFarm));
        // /// there can be some dust left in the familial distro because of rounding errors.
        // assertGt(amtSentToTransferrable + amtSentToNonTransferrable, (100000 * amtSentToFamily) / 100001, "both farms should have received all sent to the family");
        
        // check the rewards
        (, retval) = fxs.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        uint256 aliceFXSBalPost3 = abi.decode(retval, (uint256));
        assertGt(aliceFXSBalPost3, aliceFXSBalPost2, "alice should have some rewards2");
        console2.log("aliceFXSBalPost1", aliceFXSBalPost3);

        vm.stopPrank();
    }
}