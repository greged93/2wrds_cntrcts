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

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_mint__should_panic_with_zero_address() {
    // Given 
    deploy_erc721();
    set_caller_address(CALLER);

    let destination = ZERO.try_into().unwrap();
    let token_id = TOKEN_ID.into();

    // When
    ERC721::mint(destination, token_id);
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_mint__should_panic_with_token_exists() {
    // Given 
    deploy_erc721();
    set_caller_address(CALLER);

    let destination = DESTINATION.try_into().unwrap();
    let token_id = TOKEN_ID.into();
    ERC721::mint(destination, token_id);

    // When
    ERC721::mint(destination, token_id);
}

#[test]
#[available_gas(2000000)]
fn test_mint() {
    // Given 
    deploy_erc721();
    set_caller_address(CALLER);

    let destination = DESTINATION.try_into().unwrap();
    let token_id = TOKEN_ID.into();

    // When
    ERC721::mint(destination, token_id);

    // Then
    let owner = ERC721::erc721_owners::read(token_id);
    let balance = ERC721::erc721_balances::read(destination);

    assert_eq(owner, destination, 'incorrect owner');
    assert_eq(balance, 1.into(), 'incorrect balance');
}
