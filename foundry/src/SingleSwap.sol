// SPDX-License-Identifier: GPL-2.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "forge-std/console.sol";

contract SingleSwap {

    // State Variables
    ISwapRouter public immutable swapRouter;
    address public owner;
    address public immutable WETH9;
    address public immutable DAI;

    // Events
    event SwapExecuted(address indexed sender, uint256 amountIn, uint256 amountOut);

    // Constructor
    constructor(address _swapRouter, address _weth9, address _dai) {
        swapRouter = ISwapRouter(_swapRouter);
        WETH9 = _weth9;
        DAI = _dai;
        owner = msg.sender;
        console.log("SingleSwap Contract deployed by:", owner);
    }

    // Function to perform a token swap
    function swapExactInputSingle(
        uint256 amountIn,
        uint256 amountOutMinimum,
        uint24 fee,
        address to,
        uint256 deadline
    ) external returns (uint256 amountOut) {
        require(block.timestamp <= deadline, "Deadline exceeded");
        require(amountIn > 0, "Insufficient input amount");

        console.log("Attempting to swap exact input: %s WETH", amountIn);

        // Transfer WETH or DAI from user to this contract
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountIn);
        console.log("Transferred %s WETH to contract", amountIn);

        // Approve swapRouter to spend tokenIn
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);
        console.log("Approved %s WETH for router swap", amountIn);

        // Parameters for swap
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: DAI,
            fee: 3000,
            recipient: to,
            deadline: block.timestamp + 15 minutes,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        // Execute the swap
        amountOut = swapRouter.exactInputSingle(params);
        console.log("Swap executed: %s WETH -> %s DAI", amountIn, amountOut);

        // Emit the event after successful swap
        emit SwapExecuted(msg.sender, amountIn, amountOut);
    }

    function swapForConstantOutput(
        uint256 amountOut,
        uint256 amountInMaximum,
        uint24 fee,
        address to,
        uint256 deadline
    ) external returns (uint256 amountIn) {
        require(block.timestamp <= deadline, "Deadline exceeded");
        require(amountOut > 0, "Invalid output amount");
        require(amountInMaximum > 0, "Invalid maximum input amount");
        require(amountOut <= amountInMaximum, "Amount exceeds maximum input");

        console.log("Attempting to swap for constant output: %s DAI", amountOut);
        // Transfer WETH or DAI from user to this contract
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountInMaximum);
        console.log("Transferred %s WETH to contract", amountInMaximum);

        // Approve swapRouter to spend tokenIn
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountInMaximum);
        console.log("Approved %s WETH for router swap", amountInMaximum);

        // Parameters for swap
        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
            tokenIn: WETH9,
            tokenOut: DAI,
            fee: 3000,
            recipient: to,
            deadline: block.timestamp + 15 minutes,
            amountOut: amountOut,
            amountInMaximum: amountInMaximum,
            sqrtPriceLimitX96: 0
        });

        // Execute the swap
        amountIn = swapRouter.exactOutputSingle(params);
        console.log("Swap executed: %s WETH -> %s DAI", amountIn, amountOut);

        // Refund any unused amountIn back to the user
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(WETH9, address(swapRouter), 0);
            TransferHelper.safeTransfer(WETH9, msg.sender, amountInMaximum - amountIn);
            console.log("Refunded %s WETH to user", amountInMaximum - amountIn);
        }

        // Emit the event after successful swap
        emit SwapExecuted(msg.sender, amountIn, amountOut);
    }
}
