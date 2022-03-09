
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// https://remix-ide.readthedocs.io/en/latest/import.html
// npm i @openzeppelin/contracts     
import "@openzeppelin/contracts@4.2.0/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.2.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.2.0/utils/Strings.sol";
import "./TransferHelper.sol";

contract MoonMeta is ERC721Enumerable, Ownable {
    using Strings for uint256;

    bool public _isSaleActive = false;
    bool public _revealed = false;

    // Constants
    uint256 public constant MAX_SUPPLY = 10000;  //Maximum number
    uint256 public mintPrice = 0.05 ether; //price
    uint256 public maxBalance = 2; //Max NFT for each address
    uint256 public maxMint = 2;  ////
    uint256 public MooneyCost = 5000*1e18;  ///Mooney cost
    address public Mooney=0x2A6C3C56BbfEa0ce7A541C34feF7Ca4Ab0DcC9B2;

    string baseURI;
    string public notRevealedUri;
    string public baseExtension = ".json";

    mapping(uint256 => string) private _tokenURIs;

    constructor(string memory initBaseURI, string memory initNotRevealedUri)
        ERC721("MoonDAO Meta", "Mooney")
    {
        setBaseURI(initBaseURI);
        setNotRevealedURI(initNotRevealedUri);
    }

    function mintMoonMeta(uint256 tokenQuantity) public payable {
        require(
            totalSupply() + tokenQuantity <= MAX_SUPPLY,
            "Sale would exceed max supply"
        );
        require(_isSaleActive, "Sale must be active to mint MoonMetas");
        require(
            balanceOf(msg.sender) + tokenQuantity <= maxBalance,
            "Sale would exceed max balance"
        );
        require(
            tokenQuantity * mintPrice <= msg.value,
            "Not enough ether sent"
        );
        require(tokenQuantity <= maxMint, "Can only mint maxMint tokens at a time");

        _mintMoonMeta(tokenQuantity);
        
        TransferHelper.safeTransferFrom( Mooney, msg.sender, 0x000000000000000000000000000000000000dEaD, MooneyCost*tokenQuantity); 
    }

    function _mintMoonMeta(uint256 tokenQuantity) internal {
        for (uint256 i = 0; i < tokenQuantity; i++) {
            uint256 mintIndex = totalSupply();
            if (totalSupply() < MAX_SUPPLY) {
                _safeMint(msg.sender, mintIndex);
            }
        }
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (_revealed == false) {
            return notRevealedUri;
        }

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return
            string(abi.encodePacked(base, tokenId.toString(), baseExtension));
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    //only owner
    function flipSaleActive() public onlyOwner {
        _isSaleActive = !_isSaleActive;
    }

    function flipReveal() public onlyOwner {
        _revealed = !_revealed;
    }

    function setMintPrice(uint256 _mintPrice,uint256 _MooneyPrice) public onlyOwner {
        mintPrice = _mintPrice;
        MooneyCost=_MooneyPrice;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function setMaxBalance(uint256 _maxBalance) public onlyOwner {
        maxBalance = _maxBalance;
    }

    function setMaxMint(uint256 _maxMint) public onlyOwner {
        maxMint = _maxMint;
    }

    function setMooneyAddr(address _MooneyAddr) public onlyOwner {
        Mooney = _MooneyAddr;
    }

    function withdraw(address to) public onlyOwner {
        uint256 balance = address(this).balance;
        payable(to).transfer(balance);
    }
}
