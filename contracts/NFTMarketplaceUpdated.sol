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
    mapping(uint256 => address) private _creators;
    mapping(uint256 => uint256) private _royalties;
    mapping(address => uint256[]) private _ownedTokens; // Track owned tokens

    event NFTListed(uint256 tokenId, uint256 price, address seller);
    event NFTSold(
        uint256 tokenId,
        uint256 price,
        address seller,
        address buyer
    );

    constructor() ERC721("MyNFT", "MNFT") {}

    function mint(
        string memory _tokenURI,
        uint256 royalty
    ) public returns (uint256) {
        require(royalty <= 100, "Royalty must be between 0 and 100");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);
        _creators[newItemId] = msg.sender;
        _royalties[newItemId] = royalty;
        _ownedTokens[msg.sender].push(newItemId); // Track ownership
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

        // Calculate royalty
        uint256 royaltyAmount = (price * _royalties[tokenId]) / 100;

        // Pay seller and creator
        payable(seller).transfer(price - royaltyAmount);
        payable(_creators[tokenId]).transfer(royaltyAmount);

        delete _listings[tokenId];

        // Update ownership tracking
        removeTokenFromOwner(seller, tokenId);
        _ownedTokens[msg.sender].push(tokenId);

        _transfer(seller, msg.sender, tokenId);

        emit NFTSold(tokenId, price, seller, msg.sender);

        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }
    }

    function getOwnedTokens(
        address owner
    ) public view returns (uint256[] memory) {
        return _ownedTokens[owner];
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

    function removeTokenFromOwner(address owner, uint256 tokenId) internal {
        uint256 length = _ownedTokens[owner].length;

        for (uint256 i = 0; i < length; i++) {
            if (_ownedTokens[owner][i] == tokenId) {
                _ownedTokens[owner][i] = _ownedTokens[owner][length - 1];
                _ownedTokens[owner].pop();
                break;
            }
        }
    }

    function getNFTListing(
        uint256 tokenId
    ) public view returns (uint256 price, address seller) {
        Listing memory listing = _listings[tokenId];
        return (listing.price, listing.seller);
    }

    function getCreator(uint256 tokenId) public view returns (address) {
        return _creators[tokenId];
    }

    function getRoyalty(uint256 tokenId) public view returns (uint256) {
        return _royalties[tokenId];
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
            delete _creators[tokenId];
            delete _royalties[tokenId];
            removeTokenFromOwner(ownerOf(tokenId), tokenId); // Remove from tracking
        }
    }
}
