// SPDX-License-Identifier: GPL-2.0

pragma solidity ^0.8.0;

interface IWETH {
    function deposit() external payable ;

    function withdraw(uint) external ; 

    function totalSupply() external view returns (uint) ;

    function balanceOf(address account) external view returns (uint) ;

    function transfer(address recipient , address account ) external view returns (bool) ;

    function allowance(address owner , address spender ) external view returns (uint256) ;

    function approve(address spender , uint amount ) external returns (bool) ;

    function transferFrom(address sender , address recipient , uint amount ) external returns(bool) ;

    event Transfer(address indexed from , address indexed to , uint value ) ;

    event Approval(address indexed owner , address indexed spender , uint value) ;


}