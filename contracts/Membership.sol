// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol";

//Soul bound Membership NFT for Toronto DAO
contract TDAO_Memberships is ERC721, ERC721URIStorage, Ownable, EIP712, ERC721Votes {
    uint256 private _nextTokenId;

    // Mapping to store the soulbound status of each token
    mapping(uint256 => bool) private _soulboundTokens;

    constructor(address initialOwner)
        ERC721("TorontoDAO", "TDAO")
        Ownable(initialOwner)
        EIP712("TorontoDAO", "1")
    {}

        /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */

    string internal __baseURI;
    function _baseURI() internal view override returns (string memory) {
        return __baseURI;
    }

    bool public metadataLocked = false;

    function lockMetadata() public onlyOwner() {
        metadataLocked = true; 
    }

    function updateBaseURI(string memory ___baseURI) public onlyOwner() {
        require(!metadataLocked, "Metadata is Locked");
        __baseURI = ___baseURI;
    } 
     
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, "");

        // Set the soulbound status of the token
        _soulboundTokens[tokenId] = true;
    }

    // Function to check if a token is soulbound
    function isSoulbound(uint256 tokenId) public view returns (bool) {
        return _soulboundTokens[tokenId];
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Votes)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Votes)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return string.concat(super.tokenURI(tokenId), ".png");
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
