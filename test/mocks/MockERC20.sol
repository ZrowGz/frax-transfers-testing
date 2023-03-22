// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
/// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
/// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
abstract contract ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(address indexed owner, address indexed spender, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    /*//////////////////////////////////////////////////////////////
                            EIP-2612 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 internal immutable INITIAL_CHAIN_ID;

    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;

    mapping(address => uint256) public nonces;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        INITIAL_CHAIN_ID = block.chainid;
        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
    }

    /*//////////////////////////////////////////////////////////////
                               ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(address to, uint256 amount) public virtual returns (bool) {
        balanceOf[msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    /*//////////////////////////////////////////////////////////////
                             EIP-2612 LOGIC
    //////////////////////////////////////////////////////////////*/

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");

        // Unchecked because the only math done is incrementing
        // the owner's nonce which cannot realistically overflow.
        unchecked {
            address recoveredAddress = ecrecover(
                keccak256(
                    abi.encodePacked(
                        "\x19\x01",
                        DOMAIN_SEPARATOR(),
                        keccak256(
                            abi.encode(
                                keccak256(
                                    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                                ),
                                owner,
                                spender,
                                value,
                                nonces[owner]++,
                                deadline
                            )
                        )
                    )
                ),
                v,
                r,
                s
            );

            require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");

            allowance[recoveredAddress][spender] = value;
        }

        emit Approval(owner, spender, value);
    }

    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
        return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
    }

    function computeDomainSeparator() internal view virtual returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                    keccak256(bytes(name)),
                    keccak256("1"),
                    block.chainid,
                    address(this)
                )
            );
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint256 amount) internal virtual {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}

contract MockERC20 is ERC20 {
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) ERC20(_name, _symbol, _decimals) {}

    function mint(address to, uint256 value) public virtual {
        _mint(to, value);
    }

    function burn(address from, uint256 value) public virtual {
        _burn(from, value);
    }
}

contract MockLp is MockERC20 {
    address _token0; // = address(0x0a92aC70B5A187fB509947916a8F63DD31600F80);
    // address _token1 = address(0x853d955aCEf822Db058eb8505911ED77F175b99e);
    //uint256 _totalSupply;
    uint112 _reserve0;
    uint112 _reserve1;
    uint32 _blockTimestampLast;
    bool _successTransfer;

    constructor(
        address token0,
        //uint256 totalSupply,
        // uint112 reserve0,
        // uint112 reserve1,
        uint32 blockTimestampLast,
        bool successTransfer,
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) MockERC20(_name, _symbol, _decimals) {
        _token0 = token0;
        //_totalSupply = totalSupply;
        // _reserve0 = reserve0;
        // _reserve1 = reserve1;
        _blockTimestampLast = blockTimestampLast;
        _successTransfer = successTransfer;
    }

    function mint(address to, uint256 value) public override {
        uint256 valueFraction = value / 20;
        _reserve0 += uint112(valueFraction * 11);  // frxEth about 55% of the total pool
        _reserve1 += uint112(valueFraction * 9); // eth value to eth estimate 95%
        _blockTimestampLast = uint32(block.timestamp - 1);
        _mint(to, value);
    }

    function token0() external view returns (address) {
        return _token0;
    }

    function getReserveAfterTwamm(uint256 blockTimestamp)
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint256 lastVirtualOrderTimestamp,
            uint112 _twammReserve0,
            uint112 _twammReserve1
        )
    {
        blockTimestamp;
        return (_reserve0, _reserve1, _blockTimestampLast, _reserve0, _reserve1);
    }
}
// interface VotingEscrow {
//     function balanceOf(address) external view returns (uint256);
//     function get_last_user_slope(address) external view returns (int128);
//     function locked__end(address) external view returns (uint256);
//     function locked(address) external view returns (struct { int128 amount; uint256 end; });
// }
contract MockVotes is MockERC20 {
    struct LockedBalance{
        int128 amount;
        uint256 end;
    }

    LockedBalance public lockedBalance;

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) MockERC20(_name, _symbol, _decimals) {}

    /**
        * @notice Get the most recently recorded rate of voting power decrease for `addr`
        * @param addr Address of the user wallet
        * @return Value of the slope
    */
    function get_last_user_slope(address addr) external view returns (int128) {
        // return 2069063926940;
        return 3583101530994425; // pitch's voter proxy
    }

    function locked__end(address addr) external view returns (uint256) {
        return 1796860800; // pitch's voter proxy
    }

    function locked(address user) external view returns (LockedBalance memory) {
        return LockedBalance({
            amount: 451986759525760867604886,
            end: 1796860800
        });
        // return lockedBalance;
        // return struct { int128 amount; uint256 end; }({
        //     amount: 451986759525760867604886,
        //     end: 1796860800
        // });
    }
}