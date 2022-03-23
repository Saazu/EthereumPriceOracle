// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

abstract contract EthPriceOracleInterface {
    function getLatestEthPrice() public virtual returns (uint256);
}
