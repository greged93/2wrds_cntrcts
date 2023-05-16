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
fn test_split__should_panic_owner_not_from() {
    // Given
    deploy_erc721(1);
    set_caller_address(CALLER);
    set_token_owner(OWNER, TOKEN_ID);

    let token_id = TOKEN_ID.into();
    let caller = CALLER.try_into().unwrap();
    let owner = OWNER.try_into().unwrap();

    ERC721::erc721_balances::write(owner, ONE.into());
    ERC721::erc721_balances::write(caller, ONE.into());

    // When
    ERC721::split(token_id);
}
