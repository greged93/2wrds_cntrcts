// Library imports
use option::OptionTrait;
use traits::TryInto;
use traits::Into;
use starknet::Felt252TryIntoContractAddress;

// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;

use two_words::tests::constants_test::CALLER_ADDRESS;
use two_words::tests::constants_test::OWNER;

fn deploy_erc721() {
    ERC721::constructor(CONTRACT_NAME, TOKEN_SYMBOL);
}

fn set_caller_address(address: felt252) {
    let address = address.try_into().unwrap();
    starknet::testing::set_caller_address(address);
}

fn set_token_owner(owner: felt252, token_id: felt252) {
    let owner = owner.try_into().unwrap();
    ERC721::erc721_owners::write(token_id.into(), owner);
}
