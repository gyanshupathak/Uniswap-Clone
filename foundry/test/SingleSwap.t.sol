    // SPDX-License-Identifier: GPL-2.0
    pragma solidity ^0.8.0;

    import "forge-std/Test.sol";
    import "../src/SingleSwap.sol"; 
    import "../src/IWETH.sol";   
    import "forge-std/console.sol";

    contract SingleSwapTest is Test {
        SingleSwap public singleSwap;
        IWETH public weth;
        address public user = address(0x1234); 
        address public recipient = address(0x5678); 
        address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
        address public constant UniswapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
        address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

        function setUp() public {   
            // Deploy SingleSwap contract
            singleSwap = new SingleSwap(UniswapRouter , WETH9, DAI);

            // Initialize the WETH contract
            weth = IWETH(WETH9);

            // Provide the user with some WETH for testing
            deal(WETH9, user, 2 ether); // Allocate 2 WETH to user
            console.log("Deployed contract and allocated 2 WETH to user:", user);
        }

        function testConstructorInitialization() public view{
            assertEq(address(singleSwap.swapRouter()), UniswapRouter);
            assertEq(singleSwap.owner(), address(this));
            console.log("Constructor Initialization Check Passed");
            console.log("Current Chain ID:", block.chainid);
        }

        function testTokenApproval() public {
            uint256 amount = 1 ether;

            //simulate user action
            vm.startPrank(user);
            weth.approve(address(singleSwap), amount);
            console.log("User approved %s WETH for SingleSwap contract", amount);

            //check that the allowance is set correctly
            uint256 allowedAmount = weth.allowance(user, address(singleSwap));
            assertEq(allowedAmount, amount);
            console.log("Approval amount set to: %s", allowedAmount);

            vm.stopPrank();
        }

        function testSwapExactInputSingle() public {
            uint256 amountIn = 1 ether;
            uint256 amountOutMinimum = 0; 
            uint24 fee = 3000; 
            uint256 deadline = block.timestamp + 15 minutes;
            address to = recipient;

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountIn);
            console.log("User approved %s WETH for swap", amountIn);

            uint256 amountOut = singleSwap.swapExactInputSingle(
                amountIn,
                amountOutMinimum,
                fee,
                recipient,
                deadline
            );

            console.log("Swap result: %s WETH -> %s DAI", amountIn, amountOut);
            assert(amountOut > 0);
            vm.stopPrank();
        }

        function testSwapExactInputSingleDeadlineExceeded() public {
            uint256 amountIn = 1 ether;
            uint256 amountOutMinimum = 0;
            uint24 fee = 3000;
            uint256 deadline = block.timestamp - 1;  // Past deadline
            address to = recipient;

            console.log("Testing swap with expired deadline...");
            console.log("Amount In: ", amountIn);
            console.log("Deadline: ", deadline);

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountIn);

            console.log("Approving WETH for swap...");

            vm.expectRevert();
            singleSwap.swapExactInputSingle(
                amountIn,
                amountOutMinimum,
                fee,
                recipient,
                deadline
            );
            console.log("Swap should revert due to expired deadline.");
            
            vm.stopPrank();
        }


        function testSwapExactInputSingleInsufficientAmount() public {
            uint256 amountIn = 0;  // Insufficient amount
            uint256 amountOutMinimum = 0;
            uint24 fee = 3000;
            uint256 deadline = block.timestamp + 15 minutes;

            console.log("Testing swap with insufficient amount...");
            console.log("Amount In: ", amountIn);
            console.log("Deadline: ", deadline);

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountIn);

            console.log("Approving WETH for swap with 0 amount...");

            vm.expectRevert();
            singleSwap.swapExactInputSingle(
                amountIn,
                amountOutMinimum,
                fee,
                recipient,
                deadline
            );
            console.log("Swap should revert due to insufficient amount.");

            vm.stopPrank();
        }


        function testSwapForExactOutput() public {
            uint256 amountOut = 100;  // Desired output amount (DAI)
            uint256 amountInMaximum = 2 ether;  // Maximum input amount (WETH)
            uint24 fee = 3000;
            uint256 deadline = block.timestamp + 15 minutes;

            console.log("Testing swap for exact output...");
            console.log("Desired Amount Out: ", amountOut);
            console.log("Maximum Amount In: ", amountInMaximum);
            console.log("Deadline: ", deadline);

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountInMaximum);

            console.log("Approving WETH for swap...");

            uint256 amountIn = singleSwap.swapForConstantOutput(
                amountOut,
                amountInMaximum,
                fee,
                recipient,
                deadline
            );

            console.log("Amount In used for swap: ", amountIn);
            console.log("Amount Out received: ", amountOut);

            assert(amountIn > 0 && amountIn <= amountInMaximum);
            console.log("Test passed: Amount In is valid.");

            vm.stopPrank();
        }

        function testRefundLogic() public {
            uint256 amountOut = 100;  // Desired output amount (DAI)
            uint256 amountInMaximum = 2 ether;  // Maximum input amount (WETH)
            uint24 fee = 3000;
            uint256 deadline = block.timestamp + 15 minutes;

            console.log("Testing refund logic...");
            console.log("Desired Amount Out: ", amountOut);
            console.log("Maximum Amount In: ", amountInMaximum);
            console.log("Deadline: ", deadline);

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountInMaximum);

            console.log("Approving WETH for swap...");

            uint256 amountIn = singleSwap.swapForConstantOutput(
                amountOut,
                amountInMaximum,
                fee,
                recipient,
                deadline
            );

            console.log("Amount In used for swap: ", amountIn);

            uint256 refund = amountInMaximum - amountIn;
            console.log("Refund Amount: ", refund);

            assertEq(weth.balanceOf(user), refund);
            console.log("Test passed: Refund logic works correctly.");

            vm.stopPrank();
        }
    }