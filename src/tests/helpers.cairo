// Library imports
use option::OptionTrait;
use traits::TryInto;
use traits::Into;
use starknet::Felt252TryIntoContractAddress;

// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;
use two_words::tests::constants_test::TOKEN_SUPPLY;

fn deploy_erc721() {
    let owner = 1.try_into().unwrap();
    let eth_address = 1.try_into().unwrap();
    ERC721::constructor(CONTRACT_NAME, TOKEN_SYMBOL, TOKEN_SUPPLY.into(), owner, eth_address);
}

fn set_caller_address(address: felt252) {
    let address = address.try_into().unwrap();
    starknet::testing::set_caller_address(address);
}

fn set_token_owner(owner: felt252, token_id: felt252) {
    let owner = owner.try_into().unwrap();
    ERC721::erc721_owners::write(token_id.into(), owner);
}
