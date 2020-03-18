pragma solidity ^0.5.4;

import "@keep-network/keep-core/contracts/IRandomBeacon.sol";

import "@nomiclabs/buidler/console.sol";

/// @title Random Beacon Service Stub
/// @dev This contract is for testing purposes only.
contract RandomBeaconStub is IRandomBeacon {
    uint256 feeEstimate = 58;
    uint256 entry = 0;
    uint256 public requestCount = 0;
    bool shouldFail;

    /// @dev Get the entry fee estimate in wei for relay entry request.
    /// @param callbackGas Gas required for the callback.
    function entryFeeEstimate(uint256 callbackGas)
        public
        view
        returns (uint256)
    {
        return callbackGas + feeEstimate;
    }

    function requestRelayEntry(
        address callbackContract,
        string memory callbackMethod,
        uint256 callbackGas
    ) public payable returns (uint256) {
        requestCount++;

        if (shouldFail) {
            console.log("RandomBeaconStub: request relay entry failed");
            revert("request relay entry failed");
        }

        if (entry != 0) {
            (bool success,) = callbackContract.call.gas(callbackGas)(
                abi.encodeWithSignature(callbackMethod, entry)
            );
            if (!success) {
                console.log("RandomBeaconStub: callback failed");
            }
            require(success, "callback failed");
        }
    }

    function requestRelayEntry() external payable returns (uint256) {
        return requestRelayEntry(address(0), "", 0);
    }

    function setEntry(uint256 newEntry) public {
        entry = newEntry;
    }

    function setShouldFail(bool value) public {
        shouldFail = value;
    }
}