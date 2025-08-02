// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { PriceConvertor } from "./PriceConvertor.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// constant, immutable

// 859, 757
// 840, 197

error NotOwner();

contract FundMe{
    using PriceConvertor for uint256;

    uint256 public MINIMUM_USD = 50e18;

    address[] public funders;
    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "didn't send enough eth!");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
        // What is  a revert? -> Undo any actions that have been done, and send the remaining gas back
        
    }

    function withdraw() public onlyOwner {
        // for (/* start index, ending index, step amount*/)
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++) {
           address funder = funders[funderIndex];
           addressToAmountFunded[funder] = 0;
        }
        // reset the array
        funders = new address[](0);
        // Withdraw the funds
        
        // transfer
        // payable (msg.sender).transfer(address(this).balance);

        // send
        // bool sendSuccess = payable (msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send Failed!");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed!");
    }

    function getVersion() internal view returns (uint256) {
        return AggregatorV3Interface(0x6D41d1dc818112880b40e26BD6FD347E41008eDA).version();
        
    }

    modifier onlyOwner() {
        // require(msg.sender == i_owner, " Sender is not the Owner!");
        if (msg.sender != i_owner ) { revert NotOwner(); }
        _;
    }
    
    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    } 
}