// SPDX-License-Identifier: MIT
pragma solidity 0.5.0;

import "./EthPriceOracleInterface";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract CallerContract is Ownable {
    uint256 ethPrice;
    address public oracleAddress;
    EthPriceOracleInterface private oracleInstance;
    mapping(address => uint256) myRequests;

    event newOracleAddressEvent(address oracleAddress);
    event ReceivedNewRequestIdEvent(uint256 requestId);
    event PriceUpdatedEvent(uint256 ethPrice, uint256 id);

    function setOracleInstanceAddress(address _oracleInstanceAddress)
        internal
        onlyOwner
    {
        oracleAddress = _oracleInstanceAddress;
        oracleInstance = EthPriceOracleInterface(oracleAddress);
        emit newOracleAddressEvent(oracleAddress);
    }

    function updateEthPrice() public {
        uint256 id = oracleInstance.getLatestEthPrice();
        myRequests[id] = true;
        emit ReceivedNewRequestIdEvent(id);
    }

    function callback(uint256 _ethPrice, uint256 _id) public onlyOracle {
        require(myRequests[_id], "This request is not in pending price list.");
        ethPrice = _ethPrice;
        delete myRequests[_id];
        emit PriceUpdatedEvent(_ethPrice, _id);
    }

    modifier onlyOracle() {
      require(msg.sender === oracleAddress, "You are not authorized to call this function.");
      _;
    }
}
