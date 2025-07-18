// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";


contract PriceFeed{

    uint256 public minUsd = 5e18;

    address[] public funders;

    mapping (address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable{
        require (msg.value >= minUsd, "You need to spend more ETH!"); 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
    }

    function getPriceFeed() public view returns(uint256){
        AggregatorV3Interface priceFeed= AggregatorV3Interface(0x5fb1616F78dA7aFC9FF79e0371741a747D2a7F22);
        (,int256 answer,,,)=priceFeed.latestRoundData();
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 ethAmt) public view returns(uint256){
        uint256 price = getPriceFeed();
        uint256 ethAmtUSD = (price * ethAmt) / 1e18;
        return ethAmtUSD;
    } 

}