// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyToken is Initializable, ERC1155Upgradeable, OwnableUpgradeable, ERC1155SupplyUpgradeable {

    mapping(uint256 => uint256) public maxSupply; // Mapping token IDs to their max supply

    function initialize(address initialOwner) initializer public {
        __ERC1155_init("https://ipfs.io/ipns/k51qzi5uqu5dhjcxw46i64erz9aebigbwkr7srw3y9r98n9p25jg14trxbeowb");
        __Ownable_init(initialOwner); 
        __ERC1155Supply_init();
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(uint256 id, uint256 amount) public {
        require(msg.sender == owner() , "Not Authorized"); // Only owner can mint for now, you can add a minting logic based on performance
        require(totalSupply(id) + amount <= maxSupply[id], "Max supply reached for this token ID");
        _mint(msg.sender, id, amount, "");
    }

    function uri(uint256 _id) public view virtual override returns (string memory) {
        require(exists(_id), "uri: token does not exist");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json"));
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function setMaxSupply(uint256 id, uint256 amount) public onlyOwner {
        maxSupply[id] = amount;
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}