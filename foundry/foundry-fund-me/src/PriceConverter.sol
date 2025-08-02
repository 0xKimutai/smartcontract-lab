// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    /// @notice Returns the latest ETH/USD price from the Chainlink price feed
    /// @param priceFeed The Chainlink AggregatorV3Interface contract for ETH/USD
    /// @return The latest price, scaled to 18 decimals
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 answer,,,) = priceFeed.latestRoundData();
        // ETH/USD rate with 18 decimals
        return uint256(answer * 1e10); // Chainlink returns 8 decimals; multiply to get 18
    }

    /// @notice Converts ETH amount to USD using the price feed
    /// @param ethAmount The amount of ETH in wei
    /// @param priceFeed The Chainlink AggregatorV3Interface contract for ETH/USD
    /// @return The USD equivalent of the given ETH amount
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }
}
