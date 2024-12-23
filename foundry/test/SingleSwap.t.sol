    // SPDX-License-Identifier: GPL-2.0
    pragma solidity ^0.8.0;

    import "forge-std/Test.sol";
    import "../src/SingleSwap.sol"; 
    import "../src/IWETH.sol";   
    import "../script/HelperConfig.s.sol";
    import "forge-std/console.sol";

    contract SingleSwapTest is Test {
        SingleSwap public singleSwap;
        IWETH public weth;
        address public user = address(0x1234); // Simulate a user
        address public recipient = address(0x5678); // Simulate a recipient

        HelperConfig helperConfig;
        HelperConfig.NetworkConfig public networkConfig ;

        function setUp() public {   
            helperConfig = new HelperConfig();

            // Destructure the returned tuple
            (address weth9, address dai, address uniswapRouter) = helperConfig.activeNetworkConfig();

            // Construct the NetworkConfig manually
            HelperConfig.NetworkConfig memory tempConfig = HelperConfig.NetworkConfig({
                weth9: weth9,
                dai: dai,
                uniswapRouter: uniswapRouter
            });

            networkConfig = tempConfig;
            // Deploy SingleSwap contract
            singleSwap = new SingleSwap(networkConfig.uniswapRouter , networkConfig.weth9, networkConfig.dai);

            // Initialize the WETH contract
            weth = IWETH(networkConfig.weth9);

            // Provide the user with some WETH for testing
            deal(networkConfig.weth9, user, 2 ether); // Allocate 2 WETH to user
        }

        function testConstructorInitialization() public view{
            assertEq(address(singleSwap.swapRouter()), networkConfig.uniswapRouter);
            assertEq(singleSwap.owner(), address(this));
        }

        function testTokenApproval() public {
            uint256 amount = 1 ether;

            //simulate user action
            vm.startPrank(user);
            weth.approve(address(singleSwap), amount);

            //check that the allowance is set correctly
            uint256 allowedAmount = weth.allowance(user, address(singleSwap));
            assertEq(allowedAmount, amount);

            vm.stopPrank();
        }

        function testApprovalFailure() public {
            vm.startPrank(user);
            weth.approve(address(0), 1 ether);
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
            uint256 amountOut = singleSwap.swapExactInputSingle(
                amountIn,
                amountOutMinimum,
                fee,
                recipient,
                deadline
            );

            assert(amountOut > 0);
            vm.stopPrank();
        }

        function testSwapExactInputSingleDeadlineExceeded() public {
            uint256 amountIn = 1 ether;
            uint256 amountOutMinimum = 0;
            uint24 fee = 3000;
            uint256 deadline = block.timestamp - 1; 
            address to = recipient;

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountIn);

            vm.expectRevert();
            singleSwap.swapExactInputSingle(
                amountIn,
                amountOutMinimum,
                fee,
                recipient,
                deadline
            );
            vm.stopPrank();
        }

        function testSwapExactInputSingleInsufficientAmount() public {
            uint256 amountIn = 0; 
            uint256 amountOutMinimum = 0;
            uint24 fee = 3000;
            uint256 deadline = block.timestamp + 15 minutes;

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountIn);

            vm.expectRevert();
            singleSwap.swapExactInputSingle(
                amountIn,
                amountOutMinimum,
                fee,
                recipient,
                deadline
            );
            vm.stopPrank();
        }

        function testSwapForExactOutput() public {
            uint256 amountOut = 100; 
            uint256 amountInMaximum = 2 ether; 
            uint24 fee = 3000;
            uint256 deadline = block.timestamp + 15 minutes;

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountInMaximum);

            uint256 amountIn = singleSwap.swapForConstantOutput(
                amountOut,
                amountInMaximum,
                fee,
                recipient,
                deadline
            );

            assert(amountIn > 0 && amountIn <= amountInMaximum);

            vm.stopPrank();
        }

        function testRefundLogic() public {
            uint256 amountOut = 100;
            uint256 amountInMaximum = 2 ether;
            uint24 fee = 3000;
            uint256 deadline = block.timestamp + 15 minutes;

            vm.startPrank(user);
            weth.approve(address(singleSwap), amountInMaximum);

vm.expectRevert(bytes("Some revert reason if known"));
            uint256 amountIn = singleSwap.swapForConstantOutput(
                amountOut,
                amountInMaximum,
                fee,
                recipient,
                deadline
            );

            uint256 refund = amountInMaximum - amountIn;
            assertEq(weth.balanceOf(user), refund); 
            vm.stopPrank();
        }
    }