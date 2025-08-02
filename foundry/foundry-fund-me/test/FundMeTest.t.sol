// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Test, console } from "forge-std/Test.sol";
import { FundMe } from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; // 1e18
    uint256 constant STARTING_BALANCE = 10 ether; // 10e18

    function setUp() external {
       // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    // TEST TYPES
    // 1. Unit
    //      -testing a specific part of the code
    // 2. Integration
    //      -Testing how the code works with other parts of our code
    // 3.Forked
    //      -Testing code on a simulated real env
    // 4. Staging
    //      -Testing code in a real env thats not production

    function testPriceFeedVersionIsAccurate() public view{
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailedWithoutEnoughEth() public {
        vm.expectRevert(); // hey! the next line should revert
        // assert(This tx fails/reverts)
        fundMe.fund(); // Send 0 value
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next tx will be send by USER
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}