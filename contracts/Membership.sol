// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/cryptography/EIP712Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract TDAOMembership is Initializable, ERC721Upgradeable, OwnableUpgradeable, EIP712Upgradeable, ERC721VotesUpgradeable, UUPSUpgradeable {
    uint256 private _nextTokenId;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    mapping(address member => uint expiry) expiryDates;


    function initialize(address initialOwner) initializer public {
        __ERC721_init("TDAO Membership", "TDAO");
        __Ownable_init(initialOwner);
        __EIP712_init("TDAO Membership", "1");
        __ERC721Votes_init();
        __UUPSUpgradeable_init();
    }

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
        expiryDates[to] = block.timestamp + 60 seconds;  
        _safeMint(to, tokenId);
    }

    function renew(address to) public onlyOwner{
        expiryDates[to] = block.timestamp + 60 seconds;  
    }

    function balanceOf(address owner) public view override returns (uint256) {
        if(expiryDates[owner]<block.timestamp){
            return 0;
        } else {
            return super.balanceOf(owner);
        }
    }

    function _authorizeUpgrade(address newImplementation)
        internal
        onlyOwner
        override
    {}

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721Upgradeable, ERC721VotesUpgradeable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721Upgradeable, ERC721VotesUpgradeable)
    {
        super._increaseBalance(account, value);
    }
}
