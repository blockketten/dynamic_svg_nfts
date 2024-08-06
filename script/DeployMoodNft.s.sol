// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory sadSVG = vm.readFile("./img/sad.svg");
        // Reads the sad SVG image file from the specified path into a string variable.

        string memory happySVG = vm.readFile("./img/happy.svg");
        // Reads the happy SVG image file from the specified path into a string variable.

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageURI(sadSVG),
            svgToImageURI(happySVG)
        );
        // Deploys a new MoodNft contract with the given sad and happy SVG image URIs.
        // The svgToImageURI function converts the raw SVG strings into base64-encoded data URIs.
        vm.stopBroadcast();

        return moodNft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        // Converts an SVG string to a base64-encoded image URI.

        string memory baseURL = "data:image/svg+xml;base64,";
        // Base URI for SVG images, specifying the data type and encoding.

        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        // Encodes the SVG string into base64 format using OpenZeppelin's Base64 utility.

        return string(abi.encodePacked(baseURL, svgBase64Encoded));
        // Concatenates the base URL with the base64-encoded SVG data and returns the complete data URI.
    }
}
