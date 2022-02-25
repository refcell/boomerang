// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import {ERC721} from "@solmate/tokens/erc721.sol";

/// @title Boomerang
/// @notice A gas-optimized erc721 for playing in production
/// @author andreas@nascent.xyz
contract Boomerang is ERC721 {
  /// @notice The Contract Owner
  address public immutable OWNER;

  /// @notice The mint price
  uint256 public constant MINT_PRICE = 0.01 ether;

  /// @notice The maximum supply
  uint256 public immutable MAX_SUPPLY;

  /// @notice Thrown when the caller isn't the owner
  error OnlyOwner();

  /// @notice Thrown if the full mint price isn't provided
  error InsuffucientPrice();

  /// @notice Thrown when the minting is disabled
  error MintingDisabled();

  /// @notice When minting becomes available
  bool public mintingEnabled;

  /// @notice The total number of tokens brought into existence
  uint256 public totalSupply;

  /// @notice Initializes the ERC721 Metadata and sets the contract owner
  constructor(
    string memory name,
    string memory symbol,
    uint256 maxSupply
  ) ERC721(name, symbol) {
    OWNER = msg.sender;
    MAX_SUPPLY = maxSupply;
  }

  /// @notice The token uri
  function tokenURI(uint256) public pure virtual override returns (string memory) {}

  /// @notice Allows minting at the `MINT_PRICE`
  /// @dev Only allows ETH payments through `msg.value`
  function mint(address to) public payable virtual {
    if (!mintingEnabled) revert MintingDisabled();
    if (msg.value < MINT_PRICE) revert InsuffucientPrice();
    uint256 tokenId = totalSupply;
    totalSupply += 1;
    _mint(to, tokenId);
  }

  /// @notice I guess there's no reason not to burn tokens \_o_o_/
  function burn(uint256 tokenId) public virtual {
      _burn(tokenId);
  }

  /// @notice Allows the owner to enable or disable minting
  function enableMinting(bool enabled) public {
    if (msg.sender != OWNER) revert OnlyOwner();
    mintingEnabled = enabled;
  }

  /// @notice Destructs the contract and sends all eth held to the owner
  function destruct() external {
    if (msg.sender != OWNER) revert OnlyOwner();
    selfdestruct(payable(OWNER));
  }
}
