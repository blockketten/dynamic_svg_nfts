// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <0.9.0;
import {Vm} from "forge-std/Vm.sol";
import {stdJson} from "forge-std/StdJson.sol";
import {StdCheatsSafe} from "forge-std/StdCheats.sol";
import {console} from "forge-std/console.sol";
import {StringUtils} from "./StringUtils.sol";

library DevOpsTools {
    using stdJson for string;
    using StringUtils for string;

    Vm public constant vm =
        Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
    string public constant RELATIVE_BROADCAST_PATH = "./broadcast";

    function get_most_recent_deployment(
        string memory contractName,
        uint256 chainId
    ) internal view returns (address) {
        console.log("Searching for deployment of contract:", contractName);
        console.log("Chain ID:", chainId);
        return
            get_most_recent_deployment(
                contractName,
                chainId,
                RELATIVE_BROADCAST_PATH
            );
    }

    function get_most_recent_deployment(
        string memory contractName,
        uint256 chainId,
        string memory relativeBroadcastPath
    ) internal view returns (address) {
        address latestAddress = address(0);
        uint256 lastTimestamp;
        bool runProcessed;

        console.log("Reading directory:", relativeBroadcastPath);
        Vm.DirEntry[] memory entries = vm.readDir(relativeBroadcastPath, 3);
        console.log("Number of entries found:", entries.length);

        for (uint256 i = 0; i < entries.length; i++) {
            Vm.DirEntry memory entry = entries[i];
            console.log("Processing entry:", entry.path);

            if (
                entry.path.contains(
                    string.concat("/", vm.toString(chainId), "/")
                ) &&
                entry.path.contains(".json") &&
                !entry.path.contains("dry-run")
            ) {
                runProcessed = true;
                string memory json = vm.readFile(entry.path);
                console.log("JSON file read:", entry.path);

                uint256 timestamp = vm.parseJsonUint(json, ".timestamp");
                console.log("Timestamp from JSON:", timestamp);

                if (timestamp > lastTimestamp) {
                    console.log("Processing run for newer timestamp");
                    latestAddress = processRun(
                        json,
                        contractName,
                        latestAddress
                    );

                    if (latestAddress != address(0)) {
                        lastTimestamp = timestamp;
                        console.log("Updated latest address:", latestAddress);
                    }
                }
            }
        }

        if (!runProcessed) {
            console.log("No deployment artifacts found for chain:", chainId);
            revert("No deployment artifacts were found for specified chain");
        }

        if (latestAddress != address(0)) {
            console.log("Returning latest address:", latestAddress);
            return latestAddress;
        } else {
            console.log("No contract deployed for:", contractName);
            revert("No contract deployed");
        }
    }

    function processRun(
        string memory json,
        string memory contractName,
        address latestAddress
    ) internal view returns (address) {
        console.log("Processing run for contract:", contractName);

        for (
            uint256 i = 0;
            vm.keyExistsJson(
                json,
                string.concat("$.transactions[", vm.toString(i), "]")
            );
            i++
        ) {
            string memory contractNamePath = string.concat(
                "$.transactions[",
                vm.toString(i),
                "].contractName"
            );

            console.log("Checking JSON path:", contractNamePath);

            if (vm.keyExistsJson(json, contractNamePath)) {
                string memory deployedContractName = json.readString(
                    contractNamePath
                );
                console.log("Deployed contract name:", deployedContractName);

                if (deployedContractName.isEqualTo(contractName)) {
                    console.log("Contract name match found");
                    latestAddress = json.readAddress(
                        string.concat(
                            "$.transactions[",
                            vm.toString(i),
                            "].contractAddress"
                        )
                    );
                    console.log("Contract address:", latestAddress);
                    return latestAddress;
                }
            } else {
                console.log(
                    "Contract name not found in JSON for transaction",
                    i
                );
            }
        }

        console.log("No matching contract found in this run");
        return latestAddress;
    }
}
