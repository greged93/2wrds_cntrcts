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
#[should_panic(expected: ('ERC721: incorrect owner', ))]
fn test_transfer__should_panic_owner_not_from() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(OWNER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let caller = CALLER.try_into().unwrap();
    let owner = OWNER.try_into().unwrap();
    let destination = OWNER.try_into().unwrap();

    ERC721::erc721_balances::write(owner, ONE.into());
    ERC721::erc721_balances::write(caller, ONE.into());

    // When
    ERC721::_transfer(caller, destination, token_id);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: zero address dest', ))]
fn test_transfer__should_panic_to_zero_address() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(OWNER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let owner = OWNER.try_into().unwrap();
    let zero = ZERO.try_into().unwrap();

    ERC721::erc721_balances::write(owner, ONE.into());

    // When
    ERC721::_transfer(owner, zero, token_id);
}

#[test]
#[available_gas(2000000)]
fn test_transfer__should_remove_approval() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(CALLER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let caller = CALLER.try_into().unwrap();
    let destination = DESTINATION.try_into().unwrap();
    let operator = OPERATOR.try_into().unwrap();

    ERC721::erc721_token_approvals::write(token_id, operator);
    ERC721::erc721_balances::write(caller, ONE.into());

    // When
    ERC721::_transfer(caller, destination, token_id);

    // Then
    let operator = ERC721::erc721_token_approvals::read(token_id);

    assert(operator.into() == 0, 'incorrect operator');
}

#[test]
#[available_gas(2000000)]
fn test_transfer__should_transfer_token() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(CALLER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let caller = CALLER.try_into().unwrap();
    let destination = DESTINATION.try_into().unwrap();

    ERC721::erc721_balances::write(caller, ONE.into());

    // When
    ERC721::_transfer(caller, destination, token_id);

    // Then
    let owner = ERC721::owner_of(token_id);
    let balance_caller = ERC721::balance_of(caller);
    let balance_destination = ERC721::balance_of(destination);

    assert(owner == destination, 'incorrect owner');
    assert(balance_caller == ZERO.into(), 'incorrect balance caller');
    assert(balance_destination == ONE.into(), 'incorrect balance destination');
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: caller not approved', ))]
fn test_transfer_from__should_panic_owner_not_caller_or_approved() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(OWNER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let caller = CALLER.try_into().unwrap();
    let owner = OWNER.try_into().unwrap();

    ERC721::erc721_balances::write(owner, ONE.into());

    // When
    ERC721::transfer_from(owner, caller, token_id);
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from__should_transfer_when_() {
    // Given
    deploy_erc721();
    set_caller_address(OWNER);
    set_token_owner(OWNER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let destination = DESTINATION.try_into().unwrap();
    let owner = OWNER.try_into().unwrap();

    ERC721::erc721_balances::write(owner, ONE.into());

    // When
    ERC721::transfer_from(owner, destination, token_id);

    // Then
    let balance_owner = ERC721::balance_of(owner);
    let balance_destination = ERC721::balance_of(destination);
    let owner = ERC721::owner_of(token_id);

    assert(owner == destination, 'incorrect owner');
    assert(balance_owner == ZERO.into(), 'incorrect balance owner');
    assert(balance_destination == ONE.into(), 'incorrect balance destination');
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from__should_transfer_when_caller_is_approved() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(OWNER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let destination = DESTINATION.try_into().unwrap();
    let owner = OWNER.try_into().unwrap();

    ERC721::erc721_balances::write(owner, ONE.into());
    ERC721::erc721_token_approvals::write(token_id, CALLER.try_into().unwrap());

    // When
    ERC721::transfer_from(owner, destination, token_id);

    // Then
    let balance_owner = ERC721::balance_of(owner);
    let balance_destination = ERC721::balance_of(destination);
    let owner = ERC721::owner_of(token_id);

    assert(owner == destination, 'incorrect owner');
    assert(balance_owner == ZERO.into(), 'incorrect balance owner');
    assert(balance_destination == ONE.into(), 'incorrect balance destination');
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from__should_transfer_when_caller_is_approved_for_all() {
    // Given
    deploy_erc721();
    set_caller_address(CALLER);
    set_token_owner(OWNER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let destination = DESTINATION.try_into().unwrap();
    let owner = OWNER.try_into().unwrap();
    let caller = CALLER.try_into().unwrap();

    ERC721::erc721_balances::write(owner, ONE.into());
    ERC721::erc721_operator_approvals::write((owner, caller), bool::True(()));

    // When
    ERC721::transfer_from(owner, destination, token_id);

    // Then
    let balance_owner = ERC721::balance_of(owner);
    let balance_destination = ERC721::balance_of(destination);
    let owner = ERC721::owner_of(token_id);

    assert(owner == destination, 'incorrect owner');
    assert(balance_owner == ZERO.into(), 'incorrect balance owner');
    assert(balance_destination == ONE.into(), 'incorrect balance destination');
}

