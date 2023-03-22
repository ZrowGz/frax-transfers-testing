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

        /// Deploy the fake reward token
        // rewardToken = new MockERC20("Reward Token", "RTKN", 18);

        // deploy the fake reward distributor
        // distributor = new Distributor(
        //     address(this),
        //     address(this),
        //     address(this),
        //     address(fxs),
        //     address(gaugeController)
        // );
        // console2.log("distributor", address(distributor));
        // deploy the middleman gauge
        // frxFamilyGauge = new FraxFamilialPitchGauge(
        //     "frxETHETH Family Gauge",
        //     address(this),
        //     address(this),
        //     address(fxsDistributor),
        //     address(gaugeController),
        //     address(fxs)
        // );
        // console2.log("frxFamilyGauge", address(frxFamilyGauge));
        
        // gaugeController = new MockFraxGaugeController(
        //     100 ether
        // );
        // console2.log("gaugeController", address(gaugeController));
        votes = new MockVotes("Votes", "VOTES", 18);
        console2.log("votes", address(votes));

        gaugeController = new GaugeController(
            address(votes), 
            address(votes)
        );
        gaugeController.add_type("Ethereum", 1000000000000000000);
        gaugeController.change_global_emission_rate(165343915343915); // approx 100 FXS/wk
        console2.log("gaugeController", address(gaugeController));

        fxsDistributor = new FraxGaugeFXSRewardsDistributor(
            address(this),
            address(this),
            address(this), 
            address(fxs),
            address(gaugeController)
        );
        console2.log("fxsDistributor", address(fxsDistributor));

        frxFamilyDistributor = new FraxFamilialGaugeDistributor(
            "frxETHETH Family Gauge",
            address(this),
            address(this),
            address(fxsDistributor),
            address(gaugeController)
        );
        console2.log("frxFamilyDistributor", address(frxFamilyGauge));

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
        console2.log("transferrableFarm", address(transferrableFarm));

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
        // fxsDistributor.setGaugeState(address(transferrableFarm), false, false);
        // add the family gauge to the distributor
        fxsDistributor.setGaugeState(address(frxFamilyDistributor), false, true);


        /// Change all the necessary state variables
        vm.startPrank(address(fraxAdmin));
        // set the reward distributor as the token manager so it can set values
        frxEthFarm.changeTokenManager(address(fxs), address(frxFamilyDistributor));
        // set the non-transferrable farm to point to the correct addresses (reward token, rate, gaugecontroller, distributor
        frxEthFarm.setRewardVars(address(fxs), 100000000000000, address(0), address(frxFamilyDistributor));
        // remove the gauge controller from the non-transferrable farm
        // add the family gauge to the controller
        // gaugeController.add_gauge(address(frxFamilyDistributor), int128(0), uint256(1000));
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
        // IERC20(fxs).transfer(address(frxFamilyDistributor), 10000 ether);
        // IERC20(fxs).transfer(address(frxEthFarm), 10000 ether);
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
        // cvxStkFrxEthLp.deposit(990 ether, address(alice));
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
        // cast the votes for the familial gauges @ 80% of total emissions
        // gaugeController.vote(address(frxFamilyDistributor), 8 * 1e17);
        // // cast votes for fake gauge as 20% of total emissions
        // gaugeController.vote(address(69420), 2 * 1e17);
        // require(gaugeController.total_weight() == 1 ether, "total weight should be 1");
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

        // sync the farms
        // transferrableFarm.sync();
        // frxEthFarm.sync();
        // gaugeController.reset();
        // skip(1);    
        
        // // Cast votes
        // gaugeController.vote(address(transferrableFarm), 8 * 1e17);
        // gaugeController.vote(address(frxEthFarm), 2 * 1e17);
        // require(gaugeController.total_weight() == 1 * 1e18, "total weight should be 1");

        // claim rewards
        transferrableFarm.getReward(address(alice));

        // check the rewards
        (, retval) = fxs.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        uint256 aliceFXSBalPost2 = abi.decode(retval, (uint256));
        assertGt(aliceFXSBalPost2, aliceFXSBalPost1, "alice should have some rewards");
        console2.log("aliceFXSBalPost1", aliceFXSBalPost2);

        // transferrableFarm.getReward(address(alice));        
        // // check the rewards
        // (, retval) = fxs.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        // uint256 aliceFXSBalPost2 = abi.decode(retval, (uint256));
        // assertGt(aliceFXSBalPost2, aliceFXSBalPost1, "alice should have some rewards2");
        // console2.log("aliceFXSBalPost1", aliceFXSBalPost2);

        vm.stopPrank();

        // gaugeController.reset(); // fake clear any existing votes
        // /// Cast votes
        // gaugeController.vote(address(transferrableFarm), 8 * 1e17);
        // gaugeController.vote(address(frxEthFarm), 2 * 1e17);
        // require(gaugeController.total_weight() == 1 * 1e18, "total weight should be 1");

        // skip forward beyond the reward period
        skip(7 days + 1);
        gaugeController.checkpoint_gauge(address(frxFamilyDistributor));

        vm.startPrank(address(alice));
        // claim rewards
        transferrableFarm.getReward(address(alice));
        uint256 amtSentToFamily = fxsDistributor.amountSentThisRound(address(frxFamilyDistributor));
        assertGe(amtSentToFamily, 79 ether, "family should have received 80% of the rewards");
        uint256 amtSentToTransferrable = frxFamilyDistributor.amountSentThisRound(address(transferrableFarm));
        uint256 amtSentToNonTransferrable = frxFamilyDistributor.amountSentThisRound(address(frxEthFarm));
        /// there can be some dust left in the familial distro because of rounding errors.
        assertGt(amtSentToTransferrable + amtSentToNonTransferrable, (100000 * amtSentToFamily) / 100001, "both farms should have received all sent to the family");
        
        // check the rewards
        (, retval) = fxs.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        uint256 aliceFXSBalPost3 = abi.decode(retval, (uint256));
        assertGt(aliceFXSBalPost3, aliceFXSBalPost2, "alice should have some rewards2");
        console2.log("aliceFXSBalPost1", aliceFXSBalPost3);

        // // check the rewards
        // (, retval) = fxs.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
        // uint256 aliceFXSBalPost3 = abi.decode(retval, (uint256));
        // assertGt(aliceFXSBalPost3, aliceFXSBalPost2, "alice should have some rewards");
        // console2.log("aliceFXSBalPost2", aliceFXSBalPost3);

        vm.stopPrank();
    }

    // // to prevent stack too deep errors, store informational values here
    // struct TestState {
    //     bytes retval;
    //     uint256 retbal;
    //     uint256 senderPreAdd;
    //     uint256 senderBaseLockedLiquidity;
    //     uint256 senderPostAdd;
    //     uint256 senderInitialLockedLiquidity;
    //     uint256 receiverInitialLockedLiquidity;
    //     uint256 senderPostTransfer1;
    //     uint256 senderPostTransfer2;
    //     uint256 receiverPreTransfer1;
    //     uint256 receiverPostTransfer1;
    //     uint256 receiverPostTransfer2;
    //     uint256 senderLock;
    //     uint256 receiverLock1;
    //     uint256 receiverLock2;
    //     uint256 receiverLock3;
    //     uint256 senderPostTransfer1Balance;
    //     uint256 senderPostTransfer2Balance;
    //     uint256 senderPreTransfer3;
    //     uint256 receiverPostTransfer1Balance;
    //     uint256 receiverPostTransfer2Balance;
    //     uint256 receiverPreTransfer3;
    //     uint256 senderPostTransfer3Balance;
    //     uint256 receiverPostTransfer3Balance;
    //     uint256 senderPostTransfer3;
    //     uint256 receiverPostTransfer3;
    //     uint256 transferAmount;
    // }

    // function testEnd2End() public {
    //     TestState memory t;

    //     t.transferAmount = 10 ether;

    //     ///// transfer the lock to bob /////
    //     skip(1 days);

    //     /// get receiver's pre-transfer number of locks, should be 0
    //     t.receiverPreTransfer1 = transferrableFarm.lockedStakesOfLength(address(bob));
    //     t.receiverInitialLockedLiquidity = transferrableFarm.lockedLiquidityOf(address(bob));
    //     transferrableFarm.getReward(address(alice));
    //     ///// Transfer part of the LockedStake to bob - creates new kekId ///// 
    //     (, t.receiverLock1) = alice.transferLocked(address(bob), t.senderLock, t.transferAmount, false, 0);
        
    //     /// Double check that this stake exists now & that sender didn't lose or add a LockedStake
    //     t.senderPostTransfer1 = transferrableFarm.lockedStakesOfLength(address(alice));
    //     t.receiverPostTransfer1 = transferrableFarm.lockedStakesOfLength(address(bob));
    //     assertEq(t.senderPostTransfer1, t.senderPostAdd, "sender should have same # locks");
    //     assertEq(t.receiverPostTransfer1, (t.receiverPreTransfer1 + 1), "receiver should have 1 more lock");
    //     // check that liquidity has changed
    //     t.senderPostTransfer1Balance = transferrableFarm.lockedLiquidityOf(address(alice));
    //     t.receiverPostTransfer1Balance = transferrableFarm.lockedLiquidityOf(address(bob));
    //     assertEq(t.senderPostTransfer1Balance, t.senderInitialLockedLiquidity - t.transferAmount, "sender should have 980 locked");
    //     assertEq(t.receiverPostTransfer1Balance, t.receiverInitialLockedLiquidity + t.transferAmount, "receiver should have 10 locked");

    //     ///// Try sending to a lockId that receiver doesn't have - SHOULD FAIL /////
    //     vm.expectRevert();
    //     alice.transferLocked(address(bob), t.senderLock, t.transferAmount, true, 69);

    //     ///// Send more to same kek_id /////
    //     skip(1 days);
        
    //     /// transfer to a specific receiver lockKek (the same as was created last time)
    //     assertEq(transferrableFarm.lockedStakesOfLength(address(bob)), t.receiverPostTransfer1, "receiver should still have same number locks");
    //     assertEq(transferrableFarm.lockedStakesOfLength(address(alice)), t.senderPostTransfer1, "sender should still have same number locks");

    //     //// transfer to the previous added kekId
    //     (, t.receiverLock2) = alice.transferLocked(address(bob), t.senderLock, t.transferAmount, true, t.receiverLock1);

    //     /// Check that the total number of both sender & receiver LockedStakes remained the same
    //     t.senderPostTransfer2 = transferrableFarm.lockedStakesOfLength(address(alice));
    //     t.receiverPostTransfer2 = transferrableFarm.lockedStakesOfLength(address(bob));
    //     assertEq(t.senderPostTransfer2, t.senderPostTransfer1, "Sender should have same num locks");
    //     assertEq(t.receiverPostTransfer2, t.receiverPostTransfer1, "Receiver should have same num locks");
    //     // check that liquidity has changed
    //     t.senderPostTransfer2Balance = transferrableFarm.lockedLiquidityOf(address(alice));
    //     t.receiverPostTransfer2Balance = transferrableFarm.lockedLiquidityOf(address(bob));
    //     assertEq(t.senderPostTransfer2Balance, t.senderPostTransfer1Balance - t.transferAmount , "sender should have 970 locked");
    //     assertEq(t.receiverPostTransfer2Balance, t.receiverPostTransfer1Balance + t.transferAmount, "receiver should have 20 locked");

    //     ///// Test sending to an address that isn't a Convex Vault /////
    //     vm.expectRevert();
    //     alice.transferLocked(address(bob), t.senderLock, 10 ether, false, 0);

    //     ///// Test sending entire remaining balance of sender's lockedStake liquidity /////
    //     skip(20 days);
    //     console2.log("SKIP FAR AHEAD TO NEW REWARD PERIOD");
    //     t.senderPreTransfer3 = transferrableFarm.lockedStakesOfLength(address(alice));
    //     t.receiverPreTransfer3 = transferrableFarm.lockedStakesOfLength(address(bob));
    //     (, t.receiverLock3) = alice.transferLocked(address(bob), t.senderLock, (t.senderInitialLockedLiquidity - t.senderBaseLockedLiquidity - (2 * t.transferAmount)), true, t.receiverLock2);
    //     // check that liquidity has changed
    //     t.senderPostTransfer3Balance = transferrableFarm.lockedLiquidityOf(address(alice));
    //     t.receiverPostTransfer3Balance = transferrableFarm.lockedLiquidityOf(address(bob));
    //     assertEq(t.senderPostTransfer3Balance, t.senderBaseLockedLiquidity, "all of sender's locked liquidity should be back to base level");
    //     assertEq(t.receiverPostTransfer3Balance, (t.receiverInitialLockedLiquidity + (t.senderInitialLockedLiquidity - t.senderBaseLockedLiquidity)), "receiver should have all of sender's locked");

    //     vm.stopPrank();

    //     console2.log("E2E Test Success!");
    // }

    // function testOnLockReceivedNonCompliance() public {
    //     vm.startPrank(address(alice));

    //     frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
    //     (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
    //     uint256 retbal = abi.decode(retval, (uint256));
    //     assertGe(retbal, 990 ether, "invalid mint amount frxETH");

    //     // deposit it as LP into the curve pool
    //     IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
    //     IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
    //     retbal = IDeposits(frxETHCRV).balanceOf(address(alice));
    //     assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

    //     // create a known kekId
    //     uint256 senderLockId = alice.stakeLockedCurveLp(990 ether, (60*60*24*300));

    //     skip(1 days);

    //     /// Test sending to a non-compliant vault owner ///// 
    //     vm.expectRevert();
    //     (, uint256 receiverLockId) = alice.transferLocked(address(nonCompliantVault), senderLockId, 10 ether, false, 0);

    //     vm.stopPrank();

    //     console2.log("PASS = non-compliant vault FAILS on onLockReceived check");
    // }

    // function testOnLockReceivedCompliance() public {
    //     vm.startPrank(address(address(alice)));

    //     frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
    //     (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
    //     uint256 retbal = abi.decode(retval, (uint256));
    //     assertGe(retbal, 990 ether, "invalid mint amount frxETH");

    //     // deposit it as LP into the curve pool
    //     IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
    //     IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
    //     retbal = IDeposits(frxETHCRV).balanceOf(address(alice));
    //     assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

    //     // create a known lockId
    //     uint256 senderLockId = alice.stakeLockedCurveLp(990 ether, (60*60*24*300));

    //     skip(1 days);

    //     // initialize it as 69 so that it can be set to 0 by the return value
    //     uint256 receiverLockId = 69;

    //     // /// Test transfering to a compliant vault owner /////
    //     (, receiverLockId) = alice.transferLocked(address(compliantVault), senderLockId, 10 ether, false, 0);
    //     vm.stopPrank();

    //     assertEq(receiverLockId, 0, "didn't reset the value correctly");

    //     console2.log("PASS = compliant vault PASSES on onLockReceived check");
    // }

    // function testSetAllowanceAsOwner() public {
    //     vm.startPrank(address(alice));

    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;

    //     alice.setAllowance(address(bob), senderLockId, 100 ether);
    //     assertEq(transferrableFarm.spenderAllowance(address(alice), senderLockId, address(bob)), 100 ether, "allowance should be set");
    //     vm.stopPrank();
    // }

    // function testSetAllowanceAsNonOwner() public {
    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;

    //     vm.prank(address(bob));
    //     vm.expectRevert();
    //     alice.setAllowance(address(bob), senderLockId, 100 ether);
    // }

    // function testIncreaseAllowanceAsOwner() public {
    //     vm.startPrank(address(alice));

    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;
        
    //     alice.setAllowance(address(bob), senderLockId, 100 ether);
    //     alice.increaseAllowance(address(bob), senderLockId, 100 ether);
    //     vm.stopPrank();
    //     assertEq(transferrableFarm.spenderAllowance(address(alice), senderLockId, address(bob)), 200 ether, "allowance should be increased");
    // }

    // function testIncreaseAllowanceAsNonOwner() public {
    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;

    //     vm.startPrank(address(bob));
    //     vm.expectRevert();
    //     alice.increaseAllowance(address(bob), senderLockId, 100 ether);
    //     vm.stopPrank();
    // }

    // function testCannotIncreaseAllowanceFromZero() public {
    //     vm.startPrank(address(alice));

    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;

    //     vm.expectRevert();
    //     alice.increaseAllowance(address(bob), senderLockId, 100 ether);
    //     vm.stopPrank();
    // }

    // function testRemoveAllowanceAsOwner() public {
    //     vm.startPrank(address(alice));

    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;

    //     alice.setAllowance(address(bob), senderLockId, 100 ether);
    //     alice.removeAllowance(address(bob), senderLockId);

    //     vm.stopPrank();

    //     assertEq(transferrableFarm.spenderAllowance(address(alice), senderLockId, address(bob)), 0, "allowance should be removed");
    // }

    // function testRemoveAllowanceAsNonOwner() public {
    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;

    //     vm.startPrank(address(bob));
    //     vm.expectRevert();
    //     alice.removeAllowance(address(bob), senderLockId);

    //     vm.stopPrank();
    // }

    // function testSetApprovalAsOwner() public {
    //     vm.startPrank(address(alice));

    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;

    //     alice.setApprovalForAll(address(bob), true);
    //     // console2.log("isApproved", transferrableFarm.isApproved())
    //     assertEq(transferrableFarm.spenderApprovalForAllLocks(address(alice), address(bob)), true, "approval should be set");
        
    //     vm.stopPrank();
    // }

    // function testSetApprovalAsNonOwner() public {

    //     /// get number of locked stakes
    //     uint256 senderLockId = transferrableFarm.lockedStakesOfLength(address(alice)) - 1;

    //     vm.startPrank(address(bob));
    //     vm.expectRevert();
    //     alice.setApprovalForAll(address(bob), true);
        
    //     assertEq(transferrableFarm.spenderApprovalForAllLocks(address(alice), address(bob)), false, "approval not should be set");
        
    //     vm.stopPrank();
    // }

    // function testTransferLockedFromAsApprovedForAll() public {
    //     vm.startPrank(address(alice));

    //     frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
    //     (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
    //     uint256 retbal = abi.decode(retval, (uint256));
    //     assertGe(retbal, 990 ether, "invalid mint amount frxETH");

    //     // deposit it as LP into the curve pool
    //     IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
    //     IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
    //     retbal = IDeposits(frxETHCRV).balanceOf(address(alice));
    //     assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

    //     // create a known kekId
    //     uint256 senderLockId = alice.stakeLockedCurveLp(990 ether, (60*60*24*300));

    //     alice.setApprovalForAll(address(this), true);
    //     // console2.log("isApproved", transferrableFarm.isApproved())
    //     assertEq(transferrableFarm.spenderApprovalForAllLocks(address(alice), address(this)), true, "approval should be set");
        
    //     vm.stopPrank();

    //     skip(1 days);

    //     // number of locks held by compliantVault pre-transfer
    //     uint256 compliantLocksPre = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // transfer the lock from alice to compliantVault
    //     transferrableFarm.transferLockedFrom(address(alice), address(compliantVault), senderLockId, 1 ether, false, 0);

    //     // number of locks held by compliantVault post-transfer
    //     uint256 compliantLocksPost = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // check that the lock was transferred
    //     assertEq(compliantLocksPost, compliantLocksPre + 1, "lock should be transferred");
    // }

    // function testTransferLockedFromWithAllAllowance() public {
    //     vm.startPrank(address(alice));

    //     frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
    //     (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
    //     uint256 retbal = abi.decode(retval, (uint256));
    //     assertGe(retbal, 990 ether, "invalid mint amount frxETH");

    //     // deposit it as LP into the curve pool
    //     IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
    //     IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
    //     retbal = IDeposits(frxETHCRV).balanceOf(address(alice));
    //     assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

    //     // create a known kekId
    //     uint256 senderLockId = alice.stakeLockedCurveLp(990 ether, (60*60*24*300));

    //     alice.setAllowance(address(this), senderLockId, 100 ether);
    //     assertEq(transferrableFarm.spenderAllowance(address(alice), senderLockId, address(this)), 100 ether, "allowance should be set");

    //     vm.stopPrank();

    //     skip(1 days);

    //     // number of locks held by compliantVault pre-transfer
    //     uint256 compliantLocksPre = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // transfer the lock from alice to compliantVault
    //     transferrableFarm.transferLockedFrom(address(alice), address(compliantVault), senderLockId, 100 ether, false, 0);

    //     // number of locks held by compliantVault post-transfer
    //     uint256 compliantLocksPost = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // check that the lock was transferred
    //     assertEq(compliantLocksPost, compliantLocksPre + 1, "lock should be transferred");
    // }

    // function testTransferFromWithPartialAllowanceUse() public {
    //     vm.startPrank(address(alice));

    //     frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
    //     (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
    //     uint256 retbal = abi.decode(retval, (uint256));
    //     assertGe(retbal, 990 ether, "invalid mint amount frxETH");

    //     // deposit it as LP into the curve pool
    //     IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
    //     IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
    //     retbal = IDeposits(frxETHCRV).balanceOf(address(alice));
    //     assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

    //     // create a known kekId
    //     uint256 senderLockId = alice.stakeLockedCurveLp(990 ether, (60*60*24*300));

    //     alice.setAllowance(address(this), senderLockId, 100 ether);
    //     assertEq(transferrableFarm.spenderAllowance(address(alice), senderLockId, address(this)), 100 ether, "allowance should be set");

    //     vm.stopPrank();

    //     skip(1 days);

    //     // number of locks held by compliantVault pre-transfer
    //     uint256 compliantLocksPre = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // transfer the lock from alice to compliantVault
    //     transferrableFarm.transferLockedFrom(address(alice), address(compliantVault), senderLockId, 1 ether, false, 0);

    //     // number of locks held by compliantVault post-transfer
    //     uint256 compliantLocksPost = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // check that the lock was transferred
    //     assertEq(compliantLocksPost, compliantLocksPre + 1, "lock should be transferred");
    // }

    // function testTransferLockedFromAsNotApproved() public {
    //     vm.startPrank(address(alice));

    //     frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
    //     (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
    //     uint256 retbal = abi.decode(retval, (uint256));
    //     assertGe(retbal, 990 ether, "invalid mint amount frxETH");

    //     // deposit it as LP into the curve pool
    //     IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
    //     IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
    //     retbal = IDeposits(frxETHCRV).balanceOf(address(alice));
    //     assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

    //     // create a known kekId
    //     uint256 senderLockId = alice.stakeLockedCurveLp(990 ether, (60*60*24*300));

    //     // alice.setApprovalForAll(address(this), true);
    //     // // console2.log("isApproved", transferrableFarm.isApproved())
    //     // assertEq(transferrableFarm.spenderApprovalForAllLocks(address(alice), address(this)), true, "approval should be set");
        
    //     vm.stopPrank();

    //     skip(1 days);

    //     // number of locks held by compliantVault pre-transfer
    //     uint256 compliantLocksPre = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // transfer the lock from alice to compliantVault
    //     vm.expectRevert();
    //     transferrableFarm.transferLockedFrom(address(alice), address(compliantVault), senderLockId, 1 ether, false, 0);

    //     // number of locks held by compliantVault post-transfer
    //     uint256 compliantLocksPost = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // check that the lock was transferred
    //     assertEq(compliantLocksPost, compliantLocksPre, "no lock should be transferred");
    // }

    // function testTransferLockedFromWithInsufficientAllowance() public {
    //     vm.startPrank(address(alice));

    //     frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
    //     (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", address(alice)));
    //     uint256 retbal = abi.decode(retval, (uint256));
    //     assertGe(retbal, 990 ether, "invalid mint amount frxETH");

    //     // deposit it as LP into the curve pool
    //     IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
    //     IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
    //     retbal = IDeposits(frxETHCRV).balanceOf(address(alicealice));
    //     assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

    //     // create a known kekId
    //     uint256 senderLockId = alice.stakeLockedCurveLp(990 ether, (60*60*24*300));

    //     alice.setAllowance(address(bob), senderLockId, 1 ether);
    //     assertEq(transferrableFarm.spenderAllowance(address(alice), senderLockId, address(bob)), 1 ether, "allowance should be set");

    //     vm.stopPrank();

    //     skip(1 days);

    //     // number of locks held by compliantVault pre-transfer
    //     uint256 compliantLocksPre = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // transfer the lock from alice to compliantVault
    //     vm.expectRevert();
    //     transferrableFarm.transferLockedFrom(address(alice), address(compliantVault), senderLockId, 10 ether, false, 0);

    //     // number of locks held by compliantVault post-transfer
    //     uint256 compliantLocksPost = transferrableFarm.lockedStakesOfLength(address(compliantVault));

    //     // check that the lock was transferred
    //     assertEq(compliantLocksPost, compliantLocksPre, "no lock should be transferred");
    // }
}