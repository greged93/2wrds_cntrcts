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
use two_words::tests::helpers::set_caller_address;

use two_words::tests::constants_test::CALLER;

use two_words::tests::constants_test::ONE;
use two_words::tests::constants_test::TWENTY;
use two_words::tests::constants_test::ZERO;

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: incorrect owner', ))]
fn test_set_owner__should_panic_not_owner_caller() {
    // Given
    deploy_erc721(1);
    set_caller_address(CALLER);

    // When
    ERC721::set_owner(TWENTY.try_into().unwrap());
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: zero address dest', ))]
fn test_set_owner__should_panic_new_owner_zero_address() {
    // Given
    deploy_erc721(1);
    set_caller_address(ONE);

    // When
    ERC721::set_owner(ZERO.try_into().unwrap());
}

#[test]
#[available_gas(2000000)]
fn test_set_owner__should_update_contract_owner() {
    // Given
    deploy_erc721(1);
    set_caller_address(ONE);

    // When
    ERC721::set_owner(TWENTY.try_into().unwrap());

    // Then
    assert_eq(ERC721::erc721_contract_owner::read(), TWENTY.try_into().unwrap(), 'incorrect owner');
}
