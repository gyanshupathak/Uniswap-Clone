// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/MultiHopSwap.sol";
import "../src/IWETH.sol";
import "forge-std/console.sol";

contract MultiHopSwapTest is Test {
    MultiHopSwap public multiHopSwap;
    IWETH public weth;
    address public user = address(0x1234); // Simulate a user
    address public recipient = address(0x5678); // Simulate a recipient
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant UniswapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    function setUp() public {
        // Deploy MultiHopSwap contract
        multiHopSwap = new MultiHopSwap(
            UniswapRouter,
            WETH9,
            DAI,
            USDC
        );

        // Initialize the WETH contract
        weth = IWETH(WETH9);

        // Provide the user with some WETH for testing
        deal(WETH9, user, 2 ether); // Allocate 2 WETH to user
        console.log("Deployed contract and allocated 2 WETH to user:", user);
    }

    function testConstructorInitialization() public view {
        assertEq(address(multiHopSwap.swapRouter()), UniswapRouter);
        assertEq(multiHopSwap.WETH9(), WETH9);
        assertEq(multiHopSwap.DAI(), DAI);
        assertEq(multiHopSwap.USDC(), USDC);
        console.log("Constructor Initialization Check Passed");
    }

    function testTokenApproval() public {
        uint256 amount = 1 ether;

        // Simulate user action
        vm.startPrank(user);
        weth.approve(address(multiHopSwap), amount);
        console.log("User approved %s WETH for MultiHopSwap contract", amount);

        // Check that the allowance is set correctly
        uint256 allowedAmount = weth.allowance(user, address(multiHopSwap));
        assertEq(allowedAmount, amount);
        console.log("Approval amount set to: %s", allowedAmount);

        vm.stopPrank();
    }

    function testSwapExactInputMultihop() public {
        uint256 amountIn = 1 ether;
        uint256 amountOutMinimum = 0;
        uint256 deadline = block.timestamp + 15 minutes;
        address to = recipient;

        vm.startPrank(user);
        weth.approve(address(multiHopSwap), amountIn);
        console.log("User approved %s WETH for swap", amountIn);

        uint256 amountOut = multiHopSwap.swapExactInputMultihop(
            amountIn,
            amountOutMinimum,
            deadline,
            to
        );

        console.log("Swap result: %s WETH -> %s DAI", amountIn, amountOut);
        assert(amountOut > 0);
        vm.stopPrank();
    }

    function testSwapExactInputMultihopDeadlineExceeded() public {
        uint256 amountIn = 1 ether;
        uint256 amountOutMinimum = 0;
        uint256 deadline = block.timestamp - 1; // Past deadline
        address to = recipient;

        console.log("Testing swap with expired deadline...");
        console.log("Amount In: ", amountIn);
        console.log("Deadline: ", deadline);

        vm.startPrank(user);
        weth.approve(address(multiHopSwap), amountIn);

        console.log("Approving WETH for swap...");

        vm.expectRevert();
        multiHopSwap.swapExactInputMultihop(
            amountIn,
            amountOutMinimum,
            deadline,
            to
        );
        console.log("Swap should revert due to expired deadline.");

        vm.stopPrank();
    }

    function testSwapExactOutputMultihop() public {
        uint256 amountOut = 1000; // Example output amount
        uint256 amountInMaximum = 1 ether;
        uint256 deadline = block.timestamp + 15 minutes;
        address to = recipient;

        vm.startPrank(user);
        weth.approve(address(multiHopSwap), amountInMaximum);
        console.log("User approved %s WETH for swap", amountInMaximum);

        uint256 amountIn = multiHopSwap.swapExactOutputMultihop(
            amountOut,
            amountInMaximum,
            deadline,
            to
        );

        console.log("Swap result: Used %s WETH to obtain %s DAI", amountIn, amountOut);
        assert(amountIn > 0 && amountIn <= amountInMaximum);
        vm.stopPrank();
    }

    function testSwapExactOutputMultihopExcessRefund() public {
        uint256 amountOut = 1000; // Example output amount
        uint256 amountInMaximum = 2 ether; // Provide more than needed
        uint256 deadline = block.timestamp + 15 minutes;
        address to = recipient;

        vm.startPrank(user);
        weth.approve(address(multiHopSwap), amountInMaximum);
        console.log("User approved %s WETH for swap", amountInMaximum);

        uint256 amountIn = multiHopSwap.swapExactOutputMultihop(
            amountOut,
            amountInMaximum,
            deadline,
            to
        );

        console.log("Swap result: Used %s WETH to obtain %s DAI", amountIn, amountOut);
        assert(amountIn > 0 && amountIn <= amountInMaximum);

        uint256 refundedAmount = amountInMaximum - amountIn;
        if (refundedAmount > 0) {
            console.log("Excess WETH refunded: %s", refundedAmount);
        }

        vm.stopPrank();
    }
}
