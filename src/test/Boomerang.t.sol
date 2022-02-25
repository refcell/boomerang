// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.11;

import {DSTestPlus} from "./utils/DSTestPlus.sol";

import {Boomerang} from "../Boomerang.sol";

contract BoomerangTest is DSTestPlus {
    Boomerang boom;

    /// @dev The Boomerang owner
    address public constant OWNER = address(1337);

    /// @notice The minting price
    uint256 public constant MINT_PRICE = 10;

    /// @notice The maximum supply
    uint256 public constant MAX_SUPPLY = 10_000;

    /// @notice Sets up the testing suite
    function setUp() public {
        startHoax(OWNER, OWNER, type(uint256).max);
        boom = new Boomerang(
            "Name",
            "Symbol",
            MINT_PRICE,
            MAX_SUPPLY
        );
        vm.stopPrank();

        // Validate Boomerang Metadata and Ownership
        assert(OWNER == boom.OWNER());
        assert(keccak256(abi.encodePacked("Name")) == keccak256(abi.encodePacked(boom.name())));
        assert(keccak256(abi.encodePacked("Symbol")) == keccak256(abi.encodePacked(boom.symbol())));
        assert(MAX_SUPPLY == boom.MAX_SUPPLY());
        assert(MINT_PRICE == boom.MINT_PRICE());
    }

    /// @notice Allows anyone to mint tokens after the start time
    function testMinting(address alice) public {
        startHoax(alice, alice, type(uint256).max);
        vm.expectRevert(abi.encodePacked(bytes4(keccak256("MintingDisabled()"))));
        boom.mint(alice);
        vm.stopPrank();

        // Enable minting from the owner
        startHoax(OWNER, OWNER, 0);
        boom.enableMinting(true);
        vm.stopPrank();

        // Minter still can't mint if they don't supply the required payment
        startHoax(alice, alice, type(uint256).max);
        vm.expectRevert(abi.encodePacked(bytes4(keccak256("InsuffucientPrice()"))));
        boom.mint{value: 1}(alice);
        vm.stopPrank();

        // Minter can mint if they supply the required payment
        startHoax(alice, alice, MINT_PRICE);
        boom.mint{value: MINT_PRICE}(alice);
        assert(alice.balance == 0);
        vm.stopPrank();

        // Validate Successful Mint
        assert(boom.balanceOf(alice) == 1);

        // Owner can disable minting
        startHoax(OWNER, OWNER, 0);
        boom.enableMinting(false);
        vm.stopPrank();

        // Minting should be disabled now
        startHoax(alice, alice, type(uint256).max);
        vm.expectRevert(abi.encodePacked(bytes4(keccak256("MintingDisabled()"))));
        boom.mint(alice);
        vm.stopPrank();
    }

    /// @notice Allows minters to burn tokens
    function testBurning(address alice) public {
        // Enable minting from the owner
        startHoax(OWNER, OWNER, 0);
        boom.enableMinting(true);
        vm.stopPrank();

        // Minter can mint if they supply the required payment
        startHoax(alice, alice, MINT_PRICE);
        boom.mint{value: MINT_PRICE}(alice);
        assert(alice.balance == 0);
        vm.stopPrank();

        // Validate Successful Mint
        assert(boom.balanceOf(alice) == 1);

        // Alice can now burn her token
        startHoax(alice, alice);
        boom.burn(0);
        vm.stopPrank();

        // Validate Successful Burn
        assert(boom.balanceOf(alice) == 0);
    }

    /// @notice Allows only the owner to destruct the contract
    function testDestruction(address alice) public {
        if (alice == OWNER) alice = address(69);
        startHoax(alice, alice, type(uint256).max);
        vm.expectRevert(abi.encodePacked(bytes4(keccak256("OnlyOwner()"))));
        boom.destruct();
        vm.stopPrank();

        // Mint Something to give the contracts fundsies
        startHoax(OWNER, OWNER, 0);
        boom.enableMinting(true);
        vm.stopPrank();
        startHoax(alice, alice, MINT_PRICE);
        boom.mint{value: MINT_PRICE}(alice);
        assert(alice.balance == 0);
        vm.stopPrank();

        // Make sure the owner can self destruct and funds sifu
        startHoax(OWNER, OWNER, 0);
        boom.destruct();
        vm.stopPrank();

        // Funds sifu?
        // The mint price should be sent back to the owner
        assert(OWNER.balance == MINT_PRICE);
    }
}
