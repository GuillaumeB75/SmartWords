// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract SmartWords is ERC721Enumerable, ERC721URIStorage, AccessControl {
    using Counters for Counters.Counter;
    using Strings for uint256; 

    struct Text {
        uint256 textId; 
        string title;
        string content;
    }
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    Counters.Counter private _textIds;
    mapping(uint256 => Text) private _texts;

    constructor() ERC721("SmartWords", "Text") {
        _setupRole(MINTER_ROLE, msg.sender);
    }

    function text(
        address author,
        string memory title,
        string memory content,
        uint256 textId
    ) public onlyRole(MINTER_ROLE) returns (uint256) {
        _textIds.increment();
        uint256 currentId = _textIds.current();
        _mint(author, currentId);
        _setTokenURI(currentId, textId.toString());
        _texts[currentId] = Text(textId, title, content);
        return currentId;
    }

    function getTextById(uint256 id) public view returns (Text memory) {
        return _texts[id];
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721URIStorage, ERC721) returns (string memory) {
        return super.tokenURI(tokenId);
    }

   
    function _baseURI() internal view virtual override(ERC721) returns (string memory) {
        return "https://www.magnetgame.com/nft/";
    }

   
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721Enumerable, ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721Enumerable, ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    
    function _burn(uint256 tokenId) internal virtual override(ERC721URIStorage, ERC721) {
        super._burn(tokenId);
    }
}
