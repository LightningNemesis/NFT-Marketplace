# MyNFTMarketplace

MyNFTMarketplace is a decentralized marketplace for minting, listing, and buying NFTs with royalty functionality. This contract is built on the ERC-721 standard, which allows users to create unique NFTs with a royalty fee structure for resales. The marketplace facilitates secure transactions, ensuring that creators receive royalties on each resale.

## Table of Contents

- [Features](#features)
- [Contract Details](#contract-details)
- [Deployment](#deployment)
- [Usage](#usage)
- [Functions](#functions)
- [Events](#events)
- [License](#license)

## Features

- **Mint NFTs:** Users can mint their own NFTs with custom metadata and a set royalty percentage.
- **List NFTs for Sale:** NFT owners can list their NFTs for sale at a specified price.
- **Buy NFTs:** Users can purchase listed NFTs; royalties are automatically transferred to the original creator.
- **Royalty Structure:** Creators earn royalties on each resale of their NFTs, with a configurable percentage.
- **Ownership Tracking:** Tracks NFTs owned by each user and supports viewing unlisted NFTs.

## Contract Details

- **Name:** MyNFT
- **Symbol:** MNFT
- **Solidity Version:** ^0.8.0
- **Dependencies:** OpenZeppelin's ERC721, Ownable, and Counters libraries.

## Deployment

1.  Install dependencies:

    ```bash
    npm install
    ```

2.  Compile the contract:

    ```
    npx hardhat compile
    ```

3.  Deploy the contract to a testnet:

    ```
    npx hardhat run scripts/deploy.js --network skopje
    ```

4.  Verify the contract on Etherscan (optional):
    ```
    npx hardhat verify --network skopje 0x6A8FBF7459B3a71007B94C0fEF00643A2A53c04b
    ```

## Usage

- Minting: Call the mint function with the token URI and royalty percentage.
- Listing: Call the listNFT function with the token ID and desired sale price.
- Buying: Call the buyNFT function with the token ID and the required payment.

## Functions

mint: Mints a new NFT with metadata and royalty.

```
function mint(string memory _tokenURI, uint256 royalty) public returns (uint256)
```

listNFT: Lists an owned NFT for sale.

```
function listNFT(uint256 tokenId, uint256 price) public
```

buyNFT: Purchases a listed NFT and transfers royalties.

```
function buyNFT(uint256 tokenId) public payable
```

getOwnedTokens: Returns an array of token IDs owned by an address

```
function getOwnedTokens(address owner) public view returns (uint256[] memory)
```

getListedNFTs: Retrieves all NFTs currently listed for sale.

```
function getListedNFTs() public view returns (uint256[] memory)
```

getUnlistedMintedNFTs: Retrieves unlisted NFTs owned by a specific address.

```
function getUnlistedMintedNFTs(address owner) public view returns (uint256[] memory)
```

## Events

- NFTListed: Emitted when an NFT is listed for sale.

```
event NFTListed(uint256 tokenId, uint256 price, address seller);
```

- NFTSold: Emitted when an NFT is sold.

```
event NFTSold(uint256 tokenId, uint256 price, address seller, address buyer);
```
