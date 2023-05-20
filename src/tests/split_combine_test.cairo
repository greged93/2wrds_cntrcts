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
use two_words::tests::constants_test::TWO;

use two_words::tests::constants_test::TOKEN_ID;
use two_words::tests::constants_test::TOKEN_ID_SPLIT;

use two_words::types::NounAdj;

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: incorrect owner', ))]
fn test_split__should_panic_owner_not_from() {
    // Given
    deploy_erc721(1);
    set_caller_address(CALLER);
    set_token_owner(OWNER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let caller = CALLER.try_into().unwrap();

    ERC721::erc721_balances::write(caller, ONE.into());

    // When
    ERC721::split(token_id);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: token already split', ))]
fn test_split__should_panic_token_already_split() {
    // Given
    deploy_erc721(1);
    set_caller_address(CALLER);
    set_token_owner(CALLER, TOKEN_ID);
    set_token_owner(CALLER, TOKEN_ID_SPLIT);

    let token_id = TOKEN_ID.into();
    let caller = CALLER.try_into().unwrap();

    ERC721::erc721_balances::write(caller, TWO.into());

    // When
    ERC721::split(token_id);
}

#[test]
#[available_gas(2000000)]
fn test_split__should_split_token() {
    // Given
    deploy_erc721(1);
    set_caller_address(CALLER);
    set_token_owner(CALLER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let token_id_split = TOKEN_ID_SPLIT.into();
    let caller = CALLER.try_into().unwrap();

    ERC721::erc721_balances::write(caller, ONE.into());
    ERC721::erc721_token_metadata::write(token_id, NounAdj { noun: 'Valley', adj: 'Sublime' });

    // When
    ERC721::split(token_id);

    // Then
    let new_balance = ERC721::erc721_balances::read(caller);
    let metadata_token_one = ERC721::erc721_token_metadata::read(token_id);
    let metadata_token_two = ERC721::erc721_token_metadata::read(token_id_split);
    let owner_token_one = ERC721::erc721_owners::read(token_id);
    let owner_token_two = ERC721::erc721_owners::read(token_id_split);

    assert_eq(new_balance, TWO.into(), 'expected new balance to be 2');
    assert_eq(metadata_token_one.noun, 'Valley', 'expected noun to be Valley');
    assert_eq(metadata_token_one.adj, 0, 'expected adj to be 0');
    assert_eq(metadata_token_two.noun, 0, 'expected noun to be 0');
    assert_eq(metadata_token_two.adj, 'Sublime', 'expected adj to be Sublime');
    assert_eq(owner_token_one, caller, 'expected owner to be caller');
    assert_eq(owner_token_two, caller, 'expected owner to be caller');
}
