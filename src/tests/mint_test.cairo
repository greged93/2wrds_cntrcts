// Library imports
use starknet::ContractAddress;
use debug::PrintTrait;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use starknet::Felt252TryIntoContractAddress;


// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::helpers::deploy_erc721;
use two_words::tests::asserts::assert_eq;
use two_words::tests::helpers::set_caller_address;
use two_words::tests::helpers::set_token_owner;

use two_words::tests::constants_test::CALLER;
use two_words::tests::constants_test::DESTINATION;
use two_words::tests::constants_test::OPERATOR;
use two_words::tests::constants_test::OWNER;

use two_words::tests::constants_test::ZERO;
use two_words::tests::constants_test::ONE;

use two_words::tests::constants_test::TOKEN_ID;
use two_words::tests::constants_test::SUPPLY;

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_mint__should_panic_with_zero_address() {
    // Given 
    deploy_erc721();
    set_caller_address(CALLER);

    let destination = ZERO.try_into().unwrap();

    // When
    ERC721::mint(destination);
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_mint__should_panic_with_max_supply() {
    // Given 
    deploy_erc721();
    set_caller_address(CALLER);

    ERC721::erc721_mint_id::write(SUPPLY.into());
    ERC721::erc721_supply::write(SUPPLY.into());

    let destination = DESTINATION.try_into().unwrap();

    // When
    ERC721::mint(destination);
}

#[test]
#[available_gas(2000000)]
fn test_mint__should_update_balances() {
    // Given 
    deploy_erc721();
    set_caller_address(CALLER);

    let destination = DESTINATION.try_into().unwrap();
    ERC721::erc721_mint_id::write((SUPPLY - ONE).into());
    ERC721::erc721_supply::write(SUPPLY.into());

    // When
    ERC721::mint(destination);

    // Then
    let owner = ERC721::erc721_owners::read(SUPPLY.into());
    let balance = ERC721::erc721_balances::read(destination);
    let current_mint_id = ERC721::erc721_mint_id::read();

    assert_eq(owner, destination, 'incorrect owner');
    assert_eq(balance, 1.into(), 'incorrect balance');
    assert_eq(current_mint_id, SUPPLY.into(), 'incorrect token id');
}

#[test]
#[available_gas(2000000)]
fn test_mint__should_update_metadata() {
    // Given 
    deploy_erc721();
    set_caller_address(CALLER);

    let destination = DESTINATION.try_into().unwrap();

    // When
    ERC721::mint(destination);

    // Then
    let metadata = ERC721::erc721_token_metadata::read(ONE.into());

    assert_eq(metadata.noun, 'noun', 'incorrect metadata for noun');
    assert_eq(metadata.adj, 'adj', 'incorrect metadata for adj');
}
