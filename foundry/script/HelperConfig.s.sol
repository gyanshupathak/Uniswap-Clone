// SPDX-License-Identifier: GPL-2.0

//1. Deploy mock when we are on a local anvil chain 
//2. Keep track of contract address across different chains  

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../test/mocks/MockERC20.sol";
import "../test/mocks/MockUniswapRouter.sol";

contract HelperConfig is Script{

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address weth9;
        address dai;
        address uniswapRouter;
    }

    constructor() {
        if(block.chainid==11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            weth9: 0xfFf9976782d46CC05630D1f6eBAb18b2324d6B14,
            dai: 0x3e622317f8C93f7328350cF0B56d9eD4C620C5d6,
            uniswapRouter: 0xE592427A0AEce92De3Edee1F18E0157C05861564
        });
        return sepoliaConfig;
    }

    function getAnvilEthConfig() public returns(NetworkConfig memory) {
        vm.startBroadcast();
        MockERC20 mockWETH = new MockERC20("Mock WETH", "WETH");
        MockERC20 mockDAI = new MockERC20("Mock DAI", "DAI");
        MockUniswapRouter mockRouter = new MockUniswapRouter(); 
        vm.stopBroadcast();

        return NetworkConfig({
            weth9: address(mockWETH),
            dai: address(mockDAI),
            uniswapRouter: address(mockRouter)
        });
    }
}