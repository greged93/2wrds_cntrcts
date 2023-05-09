// Library imports
use option::OptionTrait;
use traits::Into;
use traits::TryInto;
use debug::PrintTrait;
use starknet::ContractAddress;
use starknet::Felt252TryIntoContractAddress;

// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::helpers::deploy_erc721;
use two_words::tests::helpers::set_token_owner;
use two_words::tests::asserts::assert_eq;

use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;

use two_words::tests::constants_test::OWNER;
use two_words::tests::constants_test::OPERATOR;

use two_words::tests::constants_test::ZERO;
use two_words::tests::constants_test::BALANCE;

use two_words::tests::constants_test::TOKEN_ID;
use two_words::tests::constants_test::OTHER_TOKEN_ID;

#[test]
#[available_gas(2000000)]
fn test_contract_view__contract_information() {
    // Given
    deploy_erc721(1);

    // When
    let name = ERC721::name();
    let symbol = ERC721::symbol();

    // Then
    assert_eq(symbol, TOKEN_SYMBOL, 'incorrect symbol');
    assert_eq(name, CONTRACT_NAME, 'incorrect name');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: query for zero address', ))]
fn test_contract_view__balance_of_should_panic_zero_address() {
    // Given
    deploy_erc721(1);

    let zero: ContractAddress = ZERO.try_into().unwrap();
    let balance: u256 = BALANCE.into();

    // When
    let actual_balance = ERC721::balance_of(zero);
}

#[test]
#[available_gas(2000000)]
fn test_contract_view__balance_of() {
    // Given
    deploy_erc721(1);

    let owner: ContractAddress = OWNER.try_into().unwrap();
    let balance: u256 = BALANCE.into();
    ERC721::erc721_balances::write(owner, balance);

    // When
    let actual_balance = ERC721::balance_of(owner);

    // Then
    assert_eq(actual_balance, balance, 'incorrect balance');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: nonexistent token', ))]
fn test_contract_view__owner_of_should_panic_zero_address() {
    // Given
    deploy_erc721(1);

    let owner: ContractAddress = OWNER.try_into().unwrap();
    let token_id: u256 = TOKEN_ID.into();

    // When
    let actual_owner = ERC721::owner_of(token_id);
}

#[test]
#[available_gas(2000000)]
fn test_contract_view__owner_of() {
    // Given
    deploy_erc721(1);
    set_token_owner(OWNER, TOKEN_ID);

    let owner = OWNER.try_into().unwrap();
    let token_id: u256 = TOKEN_ID.into();

    // When
    let actual_owner = ERC721::owner_of(token_id);

    // Then
    assert_eq(actual_owner, owner, 'incorrect balance');
}

#[test]
#[available_gas(2000000)]
fn test_contract__token_exists() {
    // Given
    deploy_erc721(1);
    set_token_owner(OWNER, TOKEN_ID);

    // When
    let token_exists = ERC721::exists(TOKEN_ID.into());
    let token_not_exists = ERC721::exists(OTHER_TOKEN_ID.into());

    // Then
    assert(token_exists, 'token should exist');
    assert(!token_not_exists, 'token should not exist');
}

#[test]
#[available_gas(2000000)]
fn test_contract__get_approved() {
    // Given
    deploy_erc721(1);
    set_token_owner(OWNER, TOKEN_ID);

    let operator = OPERATOR.try_into().unwrap();
    ERC721::erc721_token_approvals::write(TOKEN_ID.into(), operator);

    // When
    let approved = ERC721::get_approved(TOKEN_ID.into());

    // Then
    assert(approved == operator, 'operator should be approved');
}

#[test]
#[available_gas(2000000)]
fn test_contract__is_approved_for_all() {
    // Given
    deploy_erc721(1);
    let operator = OPERATOR.try_into().unwrap();
    let owner = OWNER.try_into().unwrap();

    ERC721::erc721_operator_approvals::write((owner, operator), bool::True(()));

    // When
    let approved = ERC721::is_approved_for_all(owner, operator);

    // Then
    assert(approved, 'operator not approved for all');
}

#[test]
#[available_gas(2000000)]
fn test_contract__token_uri() {
    // Given
    deploy_erc721(1);
    let token_id = TOKEN_ID.into();
    let owner = OWNER.try_into().unwrap();

    ERC721::erc721_token_uri::write(token_id, 'my token');
    ERC721::erc721_owners::write(token_id, owner);

    // When
    let uri = ERC721::token_uri(token_id);

    // Then
    assert(uri == 'my token', 'incorrect uri');
}
