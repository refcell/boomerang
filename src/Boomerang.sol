// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import {ERC721} from "@solmate/tokens/erc721.sol";

/// @title Boomerang
/// @notice A gas-optimized erc721 for playing in production
/// @author andreas@nascent.xyz
contract Boomerang is ERC721 {
  /// @notice The Contract Owner
  address public immutable OWNER;

  /// @notice Emitted when the caller isn't the owner
  error OnlyOwner();

  /// @notice Initializes the ERC721 Metadata and sets the contract owner
  constructor(
    string memory name,
    string memory symbol
  ) ERC721(name, symbol) {
    OWNER = msg.sender
  }

  /// @notice Destructs the contract and sends all eth held to the owner
  function destruct() external {
    if (msg.sender != OWNER) revert OnlyOwner();
    selfdestruct(OWNER);
  }
}
