// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

/// @title  Events of the Engine contract
/// @author Primitive
interface IMarketEvents {
    /// @notice             Creates a pool with liquidity
    /// @dev                Keccak256 hash of the engine address, strike, sigma, maturity, and gamma
    /// @param  from        Calling `msg.sender` of the create function
    /// @param  strike      Marginal price of the pool's quote token at maturity, with the same decimals as the base token, valid [0, 2^128-1]
    /// @param  sigma       AKA Implied Volatility in basis points, determines the price impact of swaps, valid for (1, 10_000_000)
    /// @param  maturity    Timestamp which starts the BUFFER countdown until swaps will cease, in seconds, valid for (block.timestamp, 2^32-1]
    /// @param  gamma       Multiplied against swap in amounts to apply fee, equal to 1 - fee % but units are in basis points, valid for (9000, 10_000)
    /// @param  delQuote    Amount of quote tokens deposited
    /// @param  delBase   Amount of base tokens deposited
    /// @param  delLiquidity Amount of liquidity granted to `recipient`
    event Create(
        address indexed from,
        uint128 strike,
        uint32 sigma,
        uint32 indexed maturity,
        uint32 indexed gamma,
        uint256 delQuote,
        uint256 delBase,
        uint256 delLiquidity
    );

    /// @notice             Updates the time until expiry of the pool with `poolId`
    /// @param  poolId      Keccak256 hash of the engine address, strike, sigma, maturity, and gamma
    event UpdateLastTimestamp(bytes32 indexed poolId);

    // ===== Margin ====

    /// @notice             Added base and/or quote tokens to a margin account
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Margin account recieving deposits
    /// @param  delQuote    Amount of quote tokens deposited
    /// @param  delBase   Amount of base tokens deposited
    event Deposit(address indexed from, address indexed recipient, uint256 delQuote, uint256 delBase);

    /// @notice             Removes base and/or quote from a margin account
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that tokens are sent to
    /// @param  delQuote    Amount of quote tokens withdrawn
    /// @param  delBase   Amount of base tokens withdrawn
    event Withdraw(address indexed from, address indexed recipient, uint256 delQuote, uint256 delBase);

    // ===== Liquidity =====

    /// @notice             Adds liquidity of quote and base tokens to a specified `poolId`
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that receives liquidity
    /// @param  poolId      Keccak256 hash of the engine address, strike, sigma, maturity, and gamma
    /// @param  delQuote    Amount of quote tokens deposited
    /// @param  delBase     Amount of base tokens deposited
    /// @param  delLiquidity Amount of liquidity granted to `recipient`
    event Allocate(
        address indexed from,
        address indexed recipient,
        bytes32 indexed poolId,
        uint256 delQuote,
        uint256 delBase,
        uint256 delLiquidity
    );

    /// @notice             Adds liquidity of quote and base tokens to a specified `poolId`
    /// @param  from        Method caller `msg.sender`
    /// @param  poolId      Keccak256 hash of the engine address, strike, sigma, maturity, and gamma
    /// @param  delQuote    Amount of quote tokens deposited
    /// @param  delBase   Amount of base tokens deposited
    /// @param  delLiquidity Amount of liquidity decreased from `from`
    event Remove(
        address indexed from,
        bytes32 indexed poolId,
        uint256 delQuote,
        uint256 delBase,
        uint256 delLiquidity
    );

    // ===== Swaps =====

    /// @notice             Swaps between `quote` and `base` assets
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that receives `deltaOut` amount of tokens
    /// @param  poolId      Keccak256 hash of the engine address, strike, sigma, maturity, and gamma
    /// @param  quoteForBase  If true, swaps quote to base, else swaps base to quote
    /// @param  deltaIn     Amount of tokens added to reserves
    /// @param  deltaOut    Amount of tokens removed from reserves
    event Swap(
        address indexed from,
        address indexed recipient,
        bytes32 indexed poolId,
        bool quoteForBase,
        uint256 deltaIn,
        uint256 deltaOut
    );
}
