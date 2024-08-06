// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract MintMoodNft is Script {
    function run() external {
        // Retrieves the most recently deployed Mood NFT contract address and mints a new NFT.

        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        // Calls the DevOpsTools library to fetch the address of the most recently deployed MoodNft contract from the broadcast logs
        // on the current blockchain (identified by block.chainid).

        mintNftOnContract(mostRecentlyDeployedBasicNft);
        // Calls the function to mint an NFT on the contract at the retrieved address.
    }

    function mintNftOnContract(address moodNftAddress) public {
        vm.startBroadcast();

        MoodNft(moodNftAddress).mintNft();
        // Calls the mintNft function on the MoodNft contract to mint a new NFT.
        // The function assumes that the caller (msg.sender) is an address authorized to mint NFTs.

        vm.stopBroadcast();
    }
}

contract FlipMoodNft is Script {
    // This contract defines a script to flip the mood of an existing Mood NFT.

    uint256 public constant TOKEN_ID_TO_FLIP = 0;
    // A constant representing the ID of the token whose mood will be flipped.
    // This script is currently set to flip the mood of the token with ID 0.

    function run() external {
        // The main function that gets executed when the script is run.
        // It retrieves the most recently deployed Mood NFT contract address and flips the mood of a specified token.

        address mostRecentlyDeployedBasicNft = DevOpsTools
            .get_most_recent_deployment("MoodNft", block.chainid);
        // Calls the DevOpsTools library to fetch the address of the most recently deployed MoodNft contract
        // on the current blockchain (identified by block.chainid).

        flipMoodNft(mostRecentlyDeployedBasicNft);
        // Calls the function to flip the mood of an NFT on the contract at the retrieved address.
    }

    function flipMoodNft(address moodNftAddress) public {
        // Function to flip the mood of a specified NFT on the MoodNft contract at the given address.

        vm.startBroadcast();

        MoodNft(moodNftAddress).flipMood(TOKEN_ID_TO_FLIP);
        // Calls the flipMood function on the MoodNft contract to change the mood of the NFT with ID specified by TOKEN_ID_TO_FLIP.

        vm.stopBroadcast();
    }
}
