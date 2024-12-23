// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUniswapV3Router {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params) external returns (uint256 amountOut);
    function exactOutputSingle(ExactOutputSingleParams calldata params) external returns (uint256 amountIn);
}

contract MockUniswapRouter is IUniswapV3Router {

    // This mock contract simulates the behavior of the `exactInputSingle` function
    function exactInputSingle(ExactInputSingleParams calldata params) external override returns (uint256 amountOut) {
        // For testing, simply return a fixed output amount for simplicity
        // You could add logic to calculate the output based on mock rates or just return a fixed value
        require(params.tokenIn != address(0) && params.tokenOut != address(0), "Invalid token addresses");
        require(params.deadline >= block.timestamp, "Transaction expired");
        
        // Example: Returning 1:1 swap rate for simplicity in the mock
        return params.amountIn;
    }

    // This mock contract simulates the behavior of the `exactOutputSingle` function
    function exactOutputSingle(ExactOutputSingleParams calldata params) external override returns (uint256 amountIn) {
        // For testing, return a fixed amount of input tokens required for the output
        // You could simulate price impact here if needed
        require(params.tokenIn != address(0) && params.tokenOut != address(0), "Invalid token addresses");
        require(params.deadline >= block.timestamp, "Transaction expired");

        // Example: For simplicity, return half of the output as input
        return params.amountOut / 2;
    }
}
