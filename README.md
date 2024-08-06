
# Dynamic_SVG_NFTs

## Overview

This repository contains smart contracts and scripts for the `Dynamic_SVG_NFTs` project, an implementation of the ERC-721 NFT token standard that allows token owners to express moods visually through dynamically changing the metadata of the NFT. The metadata for the NFTs is stored completely onchain, encoded in base 64 format. The NFTs in this project can flip between "sad" and "happy" moods, represented by on-chain SVG images, utilizing a dynamic metadata approach that is activated by calling a function on the smart contract.

The project uses the Foundry toolchain for contract development, testing, and deployment. The contracts leverage the ERC-721 standard from OpenZeppelin, while deployments and interactions are facilitated through Foundry's scripting capabilities.


## Table of Contents

- [Dynamic\_SVG\_NFTs](#dynamic_svg_nfts)
  - [Overview](#overview)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Deploying, minting, and flipping moods on Anvil](#deploying-minting-and-flipping-moods-on-anvil)
    - [Deploying, minting, and flipping moods on Ethereum Sepolia](#deploying-minting-and-flipping-moods-on-ethereum-sepolia)
    - [Testing](#testing)
  - [Contract Details](#contract-details)
    - [Imports](#imports)
    - [Inherited Functions (from ERC721)](#inherited-functions-from-erc721)
    - [Errors](#errors)
    - [Enums](#enums)
    - [State Variables](#state-variables)
    - [Constructor](#constructor)
    - [Public Functions](#public-functions)
    - [Private and Internal Functions](#private-and-internal-functions)
    - [Public and External View Functions](#public-and-external-view-functions)
  - [Future Improvements](#future-improvements)
  - [License](#license)

## Getting Started

These instructions will help you set up the project on your local machine for development and testing purposes.

### Prerequisites

- [Foundry](https://book.getfoundry.sh/)
- A small balance of Sepolia $ETH

### Installation

Clone the repository and install the necessary dependencies:

```bash
git clone https://github.com/blockketten/Dynamic_SVG_NFTs.git
cd Dynamic_SVG_NFTs
make install
```
### Deploying, minting, and flipping moods on Anvil

To deploy on the Anvil local network:

1. Open a second terminal and pass 

```bash
anvil
```
to initiate a local Anvil network

2. Return to the first terminal and pass

```bash
make deploy
```
The make file contains all the values and logic to deploy the contracts on the Anvil network without any further input.

3. To mint an NFT from the deployed contract, pass
```bash
make mint
```
This will only work for the first NFT you mint, with token ID 0. To mint further NFTs, you will need to specify the tokenID.

4. To flip the mood of your NFT, pass
```bash
make flipMood
```
This will only work for the first NFT you mint, with token ID 0. To flip the mood of NFTs with other token IDs, you will need interact with it by creating a forge cast command with the specified NFT token ID. 

### Deploying, minting, and flipping moods on Ethereum Sepolia

To deploy the smart contract on Ethereum Sepolia, you need to configure environment variables and deploy the contract using Foundry.

1. Create a keystore that encrypts and stores your private key securely:

```bash
cast wallet import <keystore account name> –interactive
```

You will need to type in your private key and then a password that you must remember to decrypt the private key later.

2. Create a `.env` file in the project root and add your environment variables:

```env
SEPOLIA_RPC_URL=<Your Sepolia RPC URL>
ACCOUNT=<Your keystore account name>
ETHERSCAN_API_KEY=<Your Etherscan API Key>
```

3.  Deploy the contract the contract on Sepolia:

```bash
make deploy ARGS="--network sepolia"
```
You will need to enter the aforementioned keystore password to complete the deployment

4. To mint an NFT from the deployed contract, pass:
```bash
make mint ARGS="--network sepolia"
```
This will only work for the first NFT you mint, with token ID 0. To mint further NFTs, you will need to specify the tokenID.

5. To flip the mood of your NFT, pass:
```bash
make flipMood ARGS="--network sepolia"
```
This will only work for the first NFT you mint, with token ID 0. To flip the mood of NFTs with other token IDs, you will need interact with it by creating a forge cast command with the specified NFT token ID. 


### Testing

The contracts in this repo are tested with both unit and integration test. To run the tests, pass:

```bash
forge test
```

## Contract Details

### Imports

- `ERC721`: OpenZeppelin's implementation of the ERC721 standard for non-fungible tokens.
- `Base64`: OpenZeppelin's utility for Base64 encoding.
- 
### Inherited Functions (from ERC721)

- `getApproved`: Checks if an address is approved to manage a token.
- `ownerOf`: Returns the owner of a token.
- `name`: Returns the name of the NFT collection.

### Errors

- `MoodNft__CantFlipMoodIfNotOwnerOrApproved`: Thrown when an unauthorized user tries to flip the mood of an NFT.

### Enums

- `Mood`: Represents the two possible moods for the NFT (SAD, HAPPY).

### State Variables

- `s_tokenCounter`: Keeps track of the total number of tokens minted.
- `s_sadSvgImageUri`: Stores the URI for the sad SVG image.
- `s_happySvgImageUri`: Stores the URI for the happy SVG image.
- `s_tokenIdToMood`: Maps token IDs to their current mood.

### Constructor

Initializes the contract with sad and happy SVG image URIs, sets the NFT name and symbol, and initializes the token counter.

### Public Functions

- `mintNft`: Mints a new NFT to the caller.
- `flipMood`: Allows the owner or approved address to flip the mood of a given token.
- `getMood`: Returns the current mood of a given token.

### Private and Internal Functions

- `_baseURI`: Overrides the base URI to indicate base64 encoded JSON metadata.

### Public and External View Functions

- `tokenURI`: Returns the metadata URI for a given token, including dynamic mood-based image.


## Future Improvements

Only Opensea is reliably rendering the NFT image and metadata for me. Debugging why they won't show up in Metamask is required. 

Testing coverage could be improved by writing more tests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
