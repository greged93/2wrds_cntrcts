// Library imports
use starknet::ContractAddress;
use traits::Into;
use option::OptionTrait;
use starknet::contract_address_try_from_felt252;


// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::helpers::deploy_erc721;
use two_words::tests::asserts::assert_eq;
use two_words::tests::helpers::set_caller_address;

use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;
use two_words::tests::constants_test::CALLER_ADDRESS;
use two_words::tests::constants_test::DESTINATION;
use two_words::tests::constants_test::OWNER;
use two_words::tests::constants_test::TOKEN_ID;

#[test]
#[available_gas(2000000)]
fn test_constructor() {
    // Given
    deploy_erc721();

    // Then
    assert_eq(ERC721::name(), CONTRACT_NAME, 'incorrect name');
    assert_eq(ERC721::symbol(), TOKEN_SYMBOL, 'incorrect symbol');
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_approve__should_panic_with_zero_address_address() {
    // Given
    deploy_erc721();

    let destination = contract_address_try_from_felt252(DESTINATION).unwrap();
    let token_id: u256 = TOKEN_ID.into();

    // When
    ERC721::approve(destination, token_id);
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_approve__should_panic_with_approval_to_owner() {
    // Given
    deploy_erc721();
    set_caller_address();

    let destination = contract_address_try_from_felt252(DESTINATION).unwrap();
    let token_id: u256 = TOKEN_ID.into();

    ERC721::owners::write(token_id, destination);

    // When
    ERC721::approve(destination, token_id);
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_approve__should_panic_with_caller_cannot_approve_caller_not_approved() {
    // Given
    deploy_erc721();
    set_caller_address();

    let caller = contract_address_try_from_felt252(CALLER_ADDRESS).unwrap();
    let destination = contract_address_try_from_felt252(DESTINATION).unwrap();
    let token_id: u256 = TOKEN_ID.into();

    // When
    ERC721::approve(destination, token_id);
}

#[test]
#[available_gas(2000000)]
fn test_approve__should_approve_owner() {
    // Given
    deploy_erc721();
    set_caller_address();

    let caller = contract_address_try_from_felt252(CALLER_ADDRESS).unwrap();
    let destination = contract_address_try_from_felt252(DESTINATION).unwrap();
    let token_id: u256 = TOKEN_ID.into();

    ERC721::owners::write(token_id, caller);

    // When
    ERC721::approve(destination, token_id);
}

#[test]
#[available_gas(2000000)]
fn test_approve__should_approve_approved_for_all() {
    // Given
    deploy_erc721();
    set_caller_address();

    let caller = contract_address_try_from_felt252(CALLER_ADDRESS).unwrap();
    let owner = contract_address_try_from_felt252(OWNER).unwrap();
    let destination = contract_address_try_from_felt252(DESTINATION).unwrap();
    let token_id: u256 = TOKEN_ID.into();

    ERC721::owners::write(token_id, owner);
    ERC721::operator_approvals::write((owner, caller), bool::True(()));

    // When
    ERC721::approve(destination, token_id);
}
