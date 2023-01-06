// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";

// import {FraxUnifiedFarm_ERC20_V2} from "../src/FraxFarmERC20Transferrable.sol";
import {FraxUnifiedFarm_ERC20_Convex_frxETH_V2 as FraxUnifiedFarm_ERC20_V2} from "../src/TransferrableConvexFrxEthFarm.sol";
import {StakingProxyConvex as Vault} from "../src/ConvexVaultTransferrable.sol";
import {FRAXStablecoin} from "@frax/../Frax/Frax.sol";
import {IFraxFarmTransfers, IFraxFarmERC20} from "@interfaces/IFraxFarm.sol";
import "@frax_testing/gauges/Curve/IFraxGaugeController.sol";
import {MockVaultOwner as VaultOwner} from "@mocks/MockVaultOwner.sol";
import "../src/ConvexBoosterImprovedInitializer.sol";

interface IDeposits {
    function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function deposit(uint256 _amount) external;
    function deposit(uint256 _amount, address _to) external;
    function depositAll(uint256 poolId, bool andStake) external;
}

contract FraxFarmERC20TransfersTest is Test {
    FraxUnifiedFarm_ERC20_V2 public frxEthFarm;
    Vault public cvxVault;
    
    // PoolRegistry public poolRegistry;
    VaultOwner public vaultOwner;

    address public alice;
    address public bob;
    
    address public frxEth = 0x5E8422345238F34275888049021821E8E08CAa1f;
    address public frxETHCRV = 0xf43211935C781D5ca1a41d2041F397B8A7366C7A; // frxeth/eth crv LP token
    address public cvxfrxEthFrxEth = address(0xC07e540DbFecCF7431EA2478Eb28A03918c1C30E);
    address public cvxStkFrxEthLp = 0x4659d5fF63A1E1EDD6D5DD9CC315e063c95947d0; // convex wrapped curve lp token STAKING TOKEN
    FraxUnifiedFarm_ERC20_V2 public frxFarm = FraxUnifiedFarm_ERC20_V2(0xa537d64881b84faffb9Ae43c951EEbF368b71cdA); // frxEthFraxFarm
    address public curveLpMinter = address(0xa1F8A6807c402E4A15ef4EBa36528A3FED24E577);
    address public vaultRewardsAddress = address(0x3465B8211278505ae9C6b5ba08ECD9af951A6896);
    address public frxEthMinter = address(0xbAFA44EFE7901E04E39Dad13167D089C559c1138);
    address public convexOperator = address(0xF403C135812408BFbE8713b5A23a04b3D48AAE31);
    address public distributor = 0x278dC748edA1d8eFEf1aDFB518542612b49Fcd34; // Gauge Reward Distro
    
    // PID is 36 at convexPoolRegistry
    Booster public convexBooster = Booster(0x569f5B842B5006eC17Be02B8b94510BA8e79FbCa); // VAULT DEPLOYER
    address public convexPoolRegistry = address(0x41a5881c17185383e19Df6FA4EC158a6F4851A69); // The deployed vaults use this, not the hardcoded address

    /// @notice The sending vault
    Vault public senderVault = Vault(0x6f82cD44e8A757C0BaA7e841F4bE7506B529ce41);
    /// @notice The sending vault owner - IS NOT A CONTRACT
    address public senderOwner = address(0x712cABaE569B54222BfB8E02A83AD98cc6D2Fb30);
    Vault public receiverVault = Vault(0x7e39FacaC567c8B48b0Ea88E7a5021391Eb848D0);
    /// @notice The receiving vault owner - IS A CONTRACT
    address public receiverOwner = address(0xaf0FDd39e5D92499B0eD9F68693DA99C0ec1e92e);
    Vault public nonCompliantVault;
    Vault public compliantVault;
    address public vaultImpl = address(0x03fb8543E933624b45abdd31987548c0D9892F07);

    address public fraxToken = 0x853d955aCEf822Db058eb8505911ED77F175b99e; // FRAX
    address public fxsToken = address(0x3432B6A60D23Ca0dFCa7761B7ab56459D9C964D0); // FXS
    address public cvxToken = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
    // Local values
    address[] private _rewardTokens;
    address[] private _rewardManagers;
    uint256[] private _rewardRates;
    address[] private _gaugeControllers;
    address[] private _rewardDistributors;

    function setUp() public {
        // create two users
        alice = vm.addr(0xdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef);
        vm.deal(alice, 1e10 ether);
        //cvxStkFrxEthLp.mint(alice, 2000 ether);
        vm.label(alice, "Alice");

        bob = vm.addr(0xeeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef);
        vm.deal(bob, 1e10 ether);
        vm.label(bob, "Bob");

        // Set the rewards parameters
        _rewardManagers.push(address(this));
        _rewardManagers.push(address(this));
        _rewardRates.push(12345); // half as much fxs as pitch
        _rewardRates.push(24690); // twice as many pitch as fxs
        _rewardDistributors.push(address(distributor));
        _rewardTokens.push(address(fxsToken));
        _rewardTokens.push(address(cvxToken));


        // Give the vault owners some ETH
        vm.deal(senderOwner, 1e10 ether);
        vm.deal(receiverOwner, 1e10 ether);
        vm.deal(address(this), 1e10 ether);

        // Deploy the logic for the transferrable fraxfarm
        frxEthFarm = new FraxUnifiedFarm_ERC20_V2(address(this), _rewardTokens, _rewardManagers, _rewardRates, _gaugeControllers, _rewardDistributors, cvxStkFrxEthLp);
        vm.etch(address(frxFarm), address(frxEthFarm).code); 
        frxEthFarm = FraxUnifiedFarm_ERC20_V2(frxFarm);

        // Deploy the logic for the transferrable vault
        cvxVault = new Vault();
        cvxVault.initialize(address(this), address(frxFarm), cvxStkFrxEthLp, vaultRewardsAddress);//, convexPoolRegistry, 36);
        // overwrite the deployed vault code with the transferrable
        vm.etch(address(senderVault), address(cvxVault).code);
        vm.etch(address(receiverVault), address(cvxVault).code);
        vm.etch(address(vaultImpl), address(cvxVault).code);

        cvxVault = Vault(vaultImpl);

        // deploy our own convex vault 
        // (bool success, bytes memory retBytes) = convexBooster.call(abi.encodeWithSignature("createVault(uint256)", 36)); 
        // require(success, "createVault failed");
        nonCompliantVault = convexBooster.createVault(36);
        // nonCompliantVault = Vault(abi.decode(retBytes, (address)));

        ///// Deploy the compliant vault owner logic /////
        vaultOwner = new VaultOwner();
        vm.etch(address(vaultOwner), address(vaultOwner).code);
        vm.deal(address(vaultOwner), 1e10 ether);

        // deploy a vault owned by a a compliant contract
        vm.prank(address(vaultOwner));
        // (success, retBytes) = convexBooster.call(abi.encodeWithSignature("createVault(uint256)", 36)); 
        // require(success, "createVault failed");
        compliantVault = convexBooster.createVault(36);//Vault(abi.decode(retBytes, (address)));
    }

    // to prevent stack too deep errors, store informational values here
    struct TestState {
        bytes retval;
        uint256 retbal;
        uint256 senderPreAdd;
        uint256 senderBaseLockedLiquidity;
        uint256 senderPostAdd;
        uint256 senderInitialLockedLiquidity;
        uint256 receiverInitialLockedLiquidity;
        uint256 senderPostTransfer1;
        uint256 senderPostTransfer2;
        uint256 receiverPreTransfer1;
        uint256 receiverPostTransfer1;
        uint256 receiverPostTransfer2;
        bytes32 senderKek;
        bytes32 destKek1;
        bytes32 destKek2;
        bytes32 destKek3;
        uint256 senderPostTransfer1Balance;
        uint256 senderPostTransfer2Balance;
        uint256 senderPreTransfer3;
        uint256 receiverPostTransfer1Balance;
        uint256 receiverPostTransfer2Balance;
        uint256 receiverPreTransfer3;
        uint256 senderPostTransfer3Balance;
        uint256 receiverPostTransfer3Balance;
        uint256 senderPostTransfer3;
        uint256 receiverPostTransfer3;
        uint256 transferAmount;
    }

    function testEnd2End() public {
        TestState memory t;
        // check that we're using the correct vaults/staking address
        assertEq(senderVault.stakingAddress(), address(frxFarm), "invalid staking address");

        t.transferAmount = 10 ether;
        
        ///// Let the testing begin! /////
        vm.startPrank(senderOwner);

        /// obtain some frxEth
        frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
        (,t.retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", senderOwner));
        t.retbal = abi.decode(t.retval, (uint256));
        assertEq(t.retbal, 1000 ether, "invalid mint amount frxETH");

        /// deposit it as LP into the curve pool
        IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
        IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
        t.retbal = IDeposits(frxETHCRV).balanceOf(senderOwner);
        assertGt(t.retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

        /// Since the `etch` completely overwrites the existing contract storage, pull these values to double check at each step
        t.senderPreAdd = frxFarm.lockedStakesOfLength(address(senderVault));
        t.senderBaseLockedLiquidity = frxFarm.lockedLiquidityOf(address(senderVault));

        /// create a known kekId
        t.senderKek = senderVault.stakeLockedCurveLp(990 ether, (60*60*24*300));
        console2.logBytes32(t.senderKek);
        t.senderPostAdd = frxFarm.lockedStakesOfLength(address(senderVault));
        assertEq(t.senderPostAdd, t.senderPreAdd + 1, "sender should have new LockedStake");
        t.senderInitialLockedLiquidity = frxFarm.lockedLiquidityOf(address(senderVault));

        ///// transfer the lockKek to receiverVault /////
        skip(1 days);

        /// get receiver's pre-transfer number of locks, should be 0
        t.receiverPreTransfer1 = frxFarm.lockedStakesOfLength(address(receiverVault));
        t.receiverInitialLockedLiquidity = frxFarm.lockedLiquidityOf(address(receiverVault));

        ///// Transfer part of the LockedStake to receiverVault - creates new kekId ///// 
        (, t.destKek1) = senderVault.transferLocked(address(receiverVault), t.senderKek, t.transferAmount, bytes32(0));
        
        /// Double check that this stake exists now & that sender didn't lose or add a LockedStake
        t.senderPostTransfer1 = frxFarm.lockedStakesOfLength(address(senderVault));
        t.receiverPostTransfer1 = frxFarm.lockedStakesOfLength(address(receiverVault));
        assertEq(t.senderPostTransfer1, t.senderPostAdd, "sender should have same # locks");
        assertEq(t.receiverPostTransfer1, (t.receiverPreTransfer1 + 1), "receiver should have 1 more lock");
        // check that liquidity has changed
        t.senderPostTransfer1Balance = frxFarm.lockedLiquidityOf(address(senderVault));
        t.receiverPostTransfer1Balance = frxFarm.lockedLiquidityOf(address(receiverVault));
        assertEq(t.senderPostTransfer1Balance, t.senderInitialLockedLiquidity - t.transferAmount, "sender should have 980 locked");
        assertEq(t.receiverPostTransfer1Balance, t.receiverInitialLockedLiquidity + t.transferAmount, "receiver should have 10 locked");

        ///// Try sending to a kekId (69420) that receiver doesn't have - SHOULD FAIL /////
        vm.expectRevert();
        senderVault.transferLocked(address(receiverVault), t.senderKek, t.transferAmount, 0x0000000000000000000000000000000000000000000000000000000000010f2c);

        ///// Send more to same kek_id /////
        skip(1 days);
        
        /// transfer to a specific receiver lockKek (the same as was created last time)
        assertEq(frxFarm.lockedStakesOfLength(address(receiverVault)), t.receiverPostTransfer1, "receiver should still have same number locks");
        assertEq(frxFarm.lockedStakesOfLength(address(senderVault)), t.senderPostTransfer1, "sender should still have same number locks");

        //// transfer to the previous added kekId
        (, t.destKek2) = senderVault.transferLocked(address(receiverVault), t.senderKek, t.transferAmount, t.destKek1);

        /// Check that the total number of both sender & receiver LockedStakes remained the same
        t.senderPostTransfer2 = frxFarm.lockedStakesOfLength(address(senderVault));
        t.receiverPostTransfer2 = frxFarm.lockedStakesOfLength(address(receiverVault));
        assertEq(t.senderPostTransfer2, t.senderPostTransfer1, "Sender should have same num locks");
        assertEq(t.receiverPostTransfer2, t.receiverPostTransfer1, "Receiver should have same num locks");
        // check that liquidity has changed
        t.senderPostTransfer2Balance = frxFarm.lockedLiquidityOf(address(senderVault));
        t.receiverPostTransfer2Balance = frxFarm.lockedLiquidityOf(address(receiverVault));
        assertEq(t.senderPostTransfer2Balance, t.senderPostTransfer1Balance - t.transferAmount , "sender should have 970 locked");
        assertEq(t.receiverPostTransfer2Balance, t.receiverPostTransfer1Balance + t.transferAmount, "receiver should have 20 locked");

        ///// Test sending to an address that isn't a Convex Vault /////
        vm.expectRevert();
        senderVault.transferLocked(address(bob), t.senderKek, 10 ether, bytes32(0));

        ///// Test sending entire remaining balance of sender's lockedStake liquidity /////
        skip(1 days);
        t.senderPreTransfer3 = frxFarm.lockedStakesOfLength(address(senderVault));
        t.receiverPreTransfer3 = frxFarm.lockedStakesOfLength(address(receiverVault));
        (, t.destKek3) = senderVault.transferLocked(address(receiverVault), t.senderKek, (t.senderInitialLockedLiquidity - t.senderBaseLockedLiquidity - (2 * t.transferAmount)), t.destKek2);
        // check that liquidity has changed
        t.senderPostTransfer3Balance = frxFarm.lockedLiquidityOf(address(senderVault));
        t.receiverPostTransfer3Balance = frxFarm.lockedLiquidityOf(address(receiverVault));
        assertEq(t.senderPostTransfer3Balance, t.senderBaseLockedLiquidity, "all of sender's locked liquidity should be back to base level");
        assertEq(t.receiverPostTransfer3Balance, (t.receiverInitialLockedLiquidity + (t.senderInitialLockedLiquidity - t.senderBaseLockedLiquidity)), "receiver should have all of sender's locked");

        vm.stopPrank();

        console2.log("E2E Test Success!");
    }

    function testOnLockReceivedNonCompliance() public {
        vm.startPrank(senderOwner);

        frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
        (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", senderOwner));
        uint256 retbal = abi.decode(retval, (uint256));
        assertEq(retbal, 1000 ether, "invalid mint amount frxETH");

        // deposit it as LP into the curve pool
        IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
        IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
        retbal = IDeposits(frxETHCRV).balanceOf(senderOwner);
        assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

        // create a known kekId
        bytes32 lockKek = senderVault.stakeLockedCurveLp(990 ether, (60*60*24*300));

        skip(1 days);

        bytes32 destKek;

        /// Test sending to a non-compliant vault owner ///// 
        vm.expectRevert();
        (, destKek) = senderVault.transferLocked(address(nonCompliantVault), lockKek, 10 ether, "");

        vm.stopPrank();

        console2.log("PASS = non-compliant vault FAILS on onLockReceived check");
    }

    function testOnLockReceivedCompliance() public {
        vm.startPrank(address(senderOwner));

        frxEthMinter.call{value: 1000*1e18}(abi.encodeWithSignature("submit()"));
        (,bytes memory retval) = frxEth.call(abi.encodeWithSignature("balanceOf(address)", senderOwner));
        uint256 retbal = abi.decode(retval, (uint256));
        assertEq(retbal, 1000 ether, "invalid mint amount frxETH");

        // deposit it as LP into the curve pool
        IDeposits(address(frxEth)).approve(curveLpMinter, type(uint256).max);
        IDeposits(curveLpMinter).add_liquidity([uint256(0), uint256(1000 ether)], 990 ether);
        retbal = IDeposits(frxETHCRV).balanceOf(senderOwner);
        assertGt(retbal, 990 ether, "invalid minimum mint amount frxETHCRV");

        // create a known kekId
        bytes32 lockKek = senderVault.stakeLockedCurveLp(990 ether, (60*60*24*300));
  
        skip(1 days);

        bytes32 destKek;

        // /// Test transfering to a compliant vault owner /////
        (, destKek) = senderVault.transferLocked(address(compliantVault), lockKek, 10 ether, "");

        vm.stopPrank();

        console2.log("PASS = compliant vault PASSES on onLockReceived check");
    }
}
