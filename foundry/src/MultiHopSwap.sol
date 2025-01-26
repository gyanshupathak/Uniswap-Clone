// SPDX-License-Identifier: GPL-2.0

pragma solidity ^0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "forge-std/console.sol";


contract MultiHopSwap {

    // State Variables
    ISwapRouter public immutable swapRouter;
    address public immutable WETH9;
    address public immutable DAI;
    address public immutable USDC;

    // Events
    event MultiHopSwapExecuted(address indexed sender, uint256 amountIn, uint256 amountOut);

    // Constructor
    constructor(address _swapRouter, address _weth9, address _dai, address _usdc) {
        swapRouter = ISwapRouter(_swapRouter);
        WETH9 = _weth9;
        DAI = _dai;
        USDC = _usdc;
    }

    /**
     * @dev Perform a multi-hop swap (e.g., WETH -> USDC -> DAI)
     * @param amountIn Amount of the input token (WETH) to swap
     * @param amountOutMinimum Minimum amount of the output token (DAI) to receive
     * @param deadline Timestamp after which the transaction is invalid
     * @param to Address to receive the output tokens
     * @return amountOut The amount of output tokens received
     */
    function swapExactInputMultihop(
        uint256 amountIn,
        uint256 amountOutMinimum,
        uint256 deadline,
        address to
    ) external returns (uint256 amountOut) {
        require(block.timestamp <= deadline, "Deadline exceeded");
        require(amountIn > 0, "Invalid input amount");

        console.log("Attempting multi-hop swap: %s WETH", amountIn);

        // Transfer WETH from user to this contract
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountIn);
        console.log("Transferred %s WETH to contract", amountIn);

        // Approve the swapRouter to spend WETH
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);
        console.log("Approved %s WETH for router", amountIn);
        
            // Encode path with fee tiers
        bytes memory path = abi.encodePacked(
            WETH9, 
            uint24(3000), 
            USDC, 
            uint24(3000),   
            DAI
        );

        // Parameters for exactInput
        ISwapRouter.ExactInputParams memory params = ISwapRouter.ExactInputParams({
            path: path,
            recipient: to,
            deadline: block.timestamp + 15 minutes,
            amountIn: amountIn,
            amountOutMinimum: amountOutMinimum
        });

        // Execute the multi-hop swap
        amountOut = swapRouter.exactInput(params);
        console.log("Multi-hop swap executed: %s WETH -> %s DAI", amountIn, amountOut);

        // Emit the event after successful swap
        emit MultiHopSwapExecuted(msg.sender, amountIn, amountOut);
    }

    /**
     * @dev Perform a multi-hop swap (e.g., WETH -> USDC -> DAI) with an exact output amount.
     * @param amountOut Exact amount of the output token (DAI) to receive
     * @param amountInMaximum Maximum amount of the input token (WETH) to swap
     * @param deadline Timestamp after which the transaction is invalid
     * @param to Address to receive the output tokens
     * @return amountIn The amount of input tokens used
     */
    function swapExactOutputMultihop(
        uint256 amountOut,
        uint256 amountInMaximum,
        uint256 deadline,
        address to
    ) external returns (uint256 amountIn) {
        require(block.timestamp <= deadline, "Deadline exceeded");
        require(amountOut > 0, "Invalid output amount");
        require(amountInMaximum > 0, "Invalid maximum input amount");
        require(amountOut <= amountInMaximum, "Amount exceeds maximum input");

        console.log("Attempting multi-hop swap for exact output: %s DAI", amountOut);

        // Transfer WETH from user to this contract
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountInMaximum);
        console.log("Transferred up to %s WETH to contract", amountInMaximum);

        // Approve the swapRouter to spend WETH
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountInMaximum);
        console.log("Approved up to %s WETH for router", amountInMaximum);

        bytes memory path = abi.encodePacked(
            DAI, 
            uint24(3000), 
            USDC, 
            uint24(3000),   
            WETH9
        );

        // Parameters for exactOutput
        ISwapRouter.ExactOutputParams memory params = ISwapRouter.ExactOutputParams({
            path: path,
            recipient: to,
            deadline: block.timestamp + 15 minutes,
            amountOut: amountOut,
            amountInMaximum: amountInMaximum
        });

        // Execute the multi-hop swap
        amountIn = swapRouter.exactOutput(params);
        console.log("Multi-hop swap executed: %s WETH -> %s DAI", amountIn, amountOut);

        // Refund any excess input tokens back to the sender
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(WETH9, address(swapRouter), 0);
            TransferHelper.safeTransfer(WETH9, msg.sender, amountInMaximum - amountIn);
            console.log("Refunded excess WETH: %s", amountInMaximum - amountIn);
        }

        // Emit the event after successful swap
        emit MultiHopSwapExecuted(msg.sender, amountIn, amountOut);
    }
}
