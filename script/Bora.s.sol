// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {Bora} from "../src/Bora.sol";

contract DeployBora is Script {
    function run() external returns (Bora) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        Bora bora = new Bora();

        vm.stopBroadcast();

        return bora;
    }
}
