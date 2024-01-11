// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Votes.sol";

//Soul bound Membership NFT for Toronto DAO
contract TDAO_Membership is ERC721, ERC721URIStorage, Ownable, EIP712, ERC721Votes {
    uint256 private _nextTokenId;

    // Mapping to store the soulbound status of each token
    mapping(uint256 => bool) private _soulboundTokens;

    constructor(address initialOwner)
        ERC721("TorontoDAO", "TDAO")
        Ownable(initialOwner)
        EIP712("TorontoDAO", "1")
    {}

    function safeMint(address to, string memory uri, bool soulbound) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        // Set the soulbound status of the token
        _soulboundTokens[tokenId] = soulbound;
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
        return super.tokenURI(tokenId);
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
