// Library imports
use option::OptionTrait;
use starknet::contract_address_try_from_felt252;

// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;
use two_words::tests::constants_test::CALLER_ADDRESS;

fn deploy_erc721() {
    ERC721::constructor(CONTRACT_NAME, TOKEN_SYMBOL);
}

fn set_caller_address() {
    let address = contract_address_try_from_felt252(CALLER_ADDRESS).unwrap();
    starknet::testing::set_caller_address(address);
}
