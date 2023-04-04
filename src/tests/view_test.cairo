// Library imports
use option::OptionTrait;
use traits::Into;
use traits::TryInto;
use starknet::ContractAddress;
use starknet::Felt252TryIntoContractAddress;

// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::helpers::deploy_erc721;
use two_words::tests::asserts::assert_eq;

use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;
use two_words::tests::constants_test::OWNER;
use two_words::tests::constants_test::BALANCE;
use two_words::tests::constants_test::TOKEN_ID;

#[test]
#[available_gas(2000000)]
fn test_contract_view__contract_information() {
    // Given
    deploy_erc721();

    // When
    let name = ERC721::name();
    let symbol = ERC721::symbol();

    // Then
    assert_eq(symbol, TOKEN_SYMBOL, 'incorrect symbol');
    assert_eq(name, CONTRACT_NAME, 'incorrect name');
}

#[test]
#[available_gas(2000000)]
fn test_contract_view__balance_of() {
    // Given
    deploy_erc721();

    let owner: ContractAddress = OWNER.try_into().unwrap();
    let balance: u256 = BALANCE.into();
    ERC721::balances::write(owner, balance);

    // When
    let actual_balance = ERC721::balance_of(owner);

    // Then
    assert_eq(actual_balance, balance, 'incorrect balance');
}

#[test]
#[available_gas(2000000)]
fn test_contract_view__owner_of() {
    // Given
    deploy_erc721();

    let owner = OWNER.try_into().unwrap();
    let token_id: u256 = TOKEN_ID.into();
    ERC721::owners::write(token_id, owner);

    // When
    let actual_owner = ERC721::owner_of(token_id);

    // Then
    assert_eq(actual_owner, owner, 'incorrect balance');
}
