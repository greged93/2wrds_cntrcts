// Library imports
use starknet::ContractAddress;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use starknet::Felt252TryIntoContractAddress;


// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::helpers::deploy_erc721;
use two_words::tests::helpers::set_token_owner;
use two_words::tests::asserts::assert_eq;
use two_words::tests::helpers::set_caller_address;

use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;

use two_words::tests::constants_test::CALLER;
use two_words::tests::constants_test::DESTINATION;
use two_words::tests::constants_test::OPERATOR;
use two_words::tests::constants_test::OWNER;

use two_words::tests::constants_test::ZERO;

use two_words::tests::constants_test::TOKEN_ID;

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_approve__should_panic_with_zero_address() {
    // Given
    deploy_erc721();

    let destination: ContractAddress = DESTINATION.try_into().unwrap();
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
    set_caller_address(CALLER);
    set_token_owner(DESTINATION, TOKEN_ID);

    let destination = DESTINATION.try_into().unwrap();
    let token_id: u256 = TOKEN_ID.into();

    // When
    ERC721::approve(destination, token_id);
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_approve__should_panic_with_caller_cannot_approve_caller_not_approved() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);

    let caller: ContractAddress = CALLER.try_into().unwrap();
    let destination: ContractAddress = DESTINATION.try_into().unwrap();
    let token_id: u256 = TOKEN_ID.into();

    // When
    ERC721::approve(destination, token_id);
}

#[test]
#[available_gas(2000000)]
fn test_approve__should_approve_owner() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(CALLER, TOKEN_ID);

    let destination = DESTINATION.try_into().unwrap();
    let token_id: u256 = TOKEN_ID.into();

    // When
    ERC721::approve(destination, token_id);
}

#[test]
#[available_gas(2000000)]
fn test_approve__should_approve_approved_for_all() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(OWNER, TOKEN_ID);

    let caller = CALLER.try_into().unwrap();
    let owner = OWNER.try_into().unwrap();
    let destination = DESTINATION.try_into().unwrap();
    let token_id: u256 = TOKEN_ID.into();

    ERC721::erc721_operator_approvals::write((owner, caller), bool::True(()));

    // When
    ERC721::approve(destination, token_id);
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_set_approval_for_call__should_panic_with_zero_address_caller() {
    // Given
    deploy_erc721();

    let caller: ContractAddress = CALLER.try_into().unwrap();
    let operator = DESTINATION.try_into().unwrap();

    // When
    ERC721::set_approval_for_all(operator, bool::True(()));
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_set_approval_for_call__should_panic_with_zero_address_operator() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);

    let operator = ZERO.try_into().unwrap();

    // When
    ERC721::set_approval_for_all(operator, bool::True(()));
}

#[test]
#[available_gas(2000000)]
fn test_set_approval_for_all() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);

    let caller: ContractAddress = CALLER.try_into().unwrap();
    let operator = OPERATOR.try_into().unwrap();

    // When
    ERC721::set_approval_for_all(operator, bool::True(()));

    // Then
    let approval = ERC721::erc721_operator_approvals::read((caller, operator));
    assert(approval, 'operator should be approved');
}
