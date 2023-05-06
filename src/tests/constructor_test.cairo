// Library imports
use starknet::ContractAddress;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use starknet::Felt252TryIntoContractAddress;


// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::helpers::deploy_erc721;
use two_words::tests::asserts::assert_eq;

use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;
use two_words::tests::constants_test::TOKEN_SUPPLY;

use two_words::tests::constants_test::CALLER;
use two_words::tests::constants_test::ETH_ADDRESS;

use two_words::tests::constants_test::ZERO;
use two_words::tests::constants_test::ONE;

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: zero address caller', ))]
fn test_constructor__should_panic_with_zero_address_owner() {
    // Given
    let zero = ZERO.try_into().unwrap();
    let one = ONE.try_into().unwrap();

    // When
    ERC721::constructor(TOKEN_SYMBOL, CONTRACT_NAME, TOKEN_SUPPLY.into(), zero, one);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: zero address caller', ))]
fn test_constructor__should_panic_with_zero_address_eth() {
    // Given
    let one = ONE.try_into().unwrap();
    let zero = ZERO.try_into().unwrap();

    // When
    ERC721::constructor(TOKEN_SYMBOL, CONTRACT_NAME, TOKEN_SUPPLY.into(), one, zero);
}

#[test]
#[available_gas(2000000)]
fn test_constructor() {
    // Given
    let caller = CALLER.try_into().unwrap();
    let expected_eth_address = ETH_ADDRESS.try_into().unwrap();

    // When
    ERC721::constructor(
        TOKEN_SYMBOL, CONTRACT_NAME, TOKEN_SUPPLY.into(), caller, expected_eth_address
    );

    // Then
    let owner = ERC721::erc721_contract_owner::read();
    let actual_eth_address = ERC721::erc721_eth_address::read();

    assert_eq(owner, caller, 'incorrect contract owner');
    assert_eq(expected_eth_address, actual_eth_address, 'incorrect eth address');
}
