// SPDX-License-Identifier: MIT
pragma solidity 0.5.0;

import "./EthPriceOracleInterface";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CallerContract is Ownable {
    address public oracleAddress;
    EthPriceOracleInterface private oracleInstance;
    mapping(address => uint256) myRequests;

    event newOracleAddressEvent(address oracleAddress);
    event ReceivedNewRequestIdEvent(uint256 requestId);

    function setOracleInstanceAddress(address _oracleInstanceAddress)
        internal
        onlyOwner
    {
        oracleAddress = _oracleInstanceAddress;
        oracleInstance = EthPriceOracleInterface(oracleAddress);
        emit newOracleAddressEvent(oracleAddress);
    }

    function updateEthPrice() public {
        uint256 id = oracleInstance.getLatestthPrice();
        myRequests[id] = true;
        emit ReceivedNewRequestIdEvent(id);
    }
}
