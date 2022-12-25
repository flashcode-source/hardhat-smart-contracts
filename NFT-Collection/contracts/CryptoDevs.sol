// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/// @title This my NFT collection contract
/// @author Abdulrahman Muhammad
/// @notice Mint an NFT using Goerli ETH 

import '@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import './IWhitelistContract.sol';

contract CryptoDevs is ERC721Enumerable, Ownable {
    
    string public _baseTokenURI;
    bool public presaleStarted;
    bool public _pause;
    uint public presaleEnded;
    uint public tokenIds;
    uint public maxTokenIds = 20;
    uint public _price = 0.01 ether;
    IWhitelist whitelist;

    constructor(string memory baseURI, address whitelistContract) ERC721('Crypto Devs', 'CD') {
        _baseTokenURI = baseURI;
        whitelist = IWhitelist(whitelistContract);
    }

    modifier onlyWhenNotPaused {
        require(!_pause, 'Contract Paused');
        _;
    }

    function startPresale() public onlyOwner{
        presaleStarted = true;
        presaleEnded = block.timestamp + 5 minutes;
    }


    function presaleMint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp < presaleEnded, 'Presale not started or has presale has ended');
        require(whitelist.whitelistedAddresses(msg.sender), 'You are not in the whitelist');
        require(msg.value >= _price, 'You need to pay the required amount');
        require(tokenIds < maxTokenIds, 'All NFTs had been minted');

        tokenIds++;

        _safeMint(msg.sender, tokenIds);
    }

    function mint() public payable onlyWhenNotPaused{
        require(presaleStarted && block.timestamp >= presaleEnded, 'Presale not ended yet');
        require(msg.value >= _price, 'You need to pay the required amount');
        require(tokenIds < maxTokenIds, 'All NFTs had been minted');

        tokenIds++;

        _safeMint(msg.sender, tokenIds);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setPause(bool val) public onlyOwner{
         _pause = val;
    }    

    function withdraw() public onlyOwner {
        address _owner = owner();
        uint amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}('');
        require(sent, 'Failed to send Ether');
    }


    receive() external payable {}
    fallback() external payable{}
}