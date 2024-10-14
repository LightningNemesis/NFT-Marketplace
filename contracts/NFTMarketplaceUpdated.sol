// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFTMarketplace is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Listing {
        uint256 price;
        address seller;
    }

    mapping(uint256 => string) private _tokenURIs;
    mapping(uint256 => Listing) private _listings;

    event NFTListed(uint256 tokenId, uint256 price, address seller);
    event NFTSold(
        uint256 tokenId,
        uint256 price,
        address seller,
        address buyer
    );

    constructor() ERC721("MyNFT", "MNFT") {}

    function mint(string memory _tokenURI) public returns (uint256) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        return newItemId;
    }

    function listNFT(uint256 tokenId, uint256 price) public {
        require(_exists(tokenId), "NFT does not exist");
        require(ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than zero");

        _listings[tokenId] = Listing(price, msg.sender);
        emit NFTListed(tokenId, price, msg.sender);
    }

    function buyNFT(uint256 tokenId) public payable {
        Listing memory listing = _listings[tokenId];
        require(listing.price > 0, "NFT not for sale");
        require(msg.value >= listing.price, "Insufficient payment");

        address seller = listing.seller;
        uint256 price = listing.price;

        delete _listings[tokenId];
        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(price);

        emit NFTSold(tokenId, price, seller, msg.sender);

        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
    }

    function getListedNFTs() public view returns (uint256[] memory) {
        uint256 listedCount = 0;
        for (uint256 i = 1; i <= _tokenIds.current(); i++) {
            if (_listings[i].price > 0) {
                listedCount++;
            }
        }

        uint256[] memory listedNFTs = new uint256[](listedCount);
        uint256 currentIndex = 0;
        for (uint256 i = 1; i <= _tokenIds.current(); i++) {
            if (_listings[i].price > 0) {
                listedNFTs[currentIndex] = i;
                currentIndex++;
            }
        }

        return listedNFTs;
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory _tokenURI
    ) internal virtual {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return _tokenURIs[tokenId];
    }

    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);
        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }

    // Existing functions (_setTokenURI, tokenURI, _burn) remain the same
}
