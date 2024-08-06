// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "lib/openzeppelin-contracts/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    /*//////////////////////////////////////////////////////////////
                                 ERRORS
    //////////////////////////////////////////////////////////////*/

    error MoodNft__CantFlipMoodIfNotOwnerOrApproved();
    // Custom error to indicate that an unauthorized user tried to flip the mood of an NFT

    /*//////////////////////////////////////////////////////////////
                           TYPE DECLARATIONS
    //////////////////////////////////////////////////////////////*/
    enum Mood {
        SAD,
        HAPPY
    }
    // Represents the two possible moods for the NFT

    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/
    uint256 private s_tokenCounter;
    // Counter to keep track of the total number of tokens minted

    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;
    // Strings to store the URIs for the sad and happy SVG images associated with the moods

    mapping(uint256 => Mood) private s_tokenIdToMood;
    // Mapping to associate each token ID with its current mood

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("MoodNFT", "MN") {
        // Constructor for initializing the NFT with a name and symbol, and setting initial mood image URIs

        s_tokenCounter = 0;
        // Initialize the token counter to zero

        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
        // Set the SVG image URIs for sad and happy moods
    }

    /*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /*//////////////////////////////////////////////////////////////
                            PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function mintNft() public {
        // Public function to mint a new NFT

        _safeMint(msg.sender, s_tokenCounter);
        // Mint a new NFT safely, ensuring it is owned by the caller, with the next available token ID

        s_tokenCounter++;
        // Increment the token counter for the next mint
    }

    function flipMood(uint256 tokenId) public {
        // Public function to flip the mood of a given token

        if (
            getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender
        ) {
            // Check if the caller is either the owner of the token or is approved to manage it

            revert MoodNft__CantFlipMoodIfNotOwnerOrApproved();
            // Revert the transaction with a custom error if the caller is not authorized
        }

        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        } else {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        }
        // Flip the mood of the token: if it's sad, change it to happy, and vice versa
    }

    /*//////////////////////////////////////////////////////////////
                     PRIVATE AND INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
        // Override the base URI to be used for the token metadata, indicating that metadata is encoded in base64 JSON
    }

    /*//////////////////////////////////////////////////////////////
                   PUBLIC AND EXTERNAL VIEW FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        // Public function to return the metadata URI for a given token

        string memory imageURI;
        // Variable to store the image URI based on the token's mood

        if (s_tokenIdToMood[tokenId] == Mood.SAD) {
            imageURI = s_sadSvgImageUri;
        } else {
            imageURI = s_happySvgImageUri;
        }
        // Determine the image URI based on the current mood of the token

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    (
                        Base64.encode(
                            bytes(
                                abi.encodePacked(
                                    '{"name":"',
                                    name(),
                                    '", "description":"A dynamic NFT that reflects the mood of the owner, with the image URI and metadata JSON stored onchain!", ',
                                    '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                    imageURI,
                                    '"}'
                                    // Construct the JSON metadata including name, description, attributes, and image URI, then encode it in base64
                                )
                            )
                        )
                    )
                )
            );
        // Return the final base64-encoded metadata string
    }

    function getMood(uint256 tokenId) public view returns (Mood) {
        return s_tokenIdToMood[tokenId];
        // Public function to get the current mood of a given token
    }
}
