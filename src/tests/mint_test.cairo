// Library imports
use starknet::ContractAddress;
use starknet::testing::set_contract_address;
use starknet::testing::set_block_timestamp;

use debug::PrintTrait;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;
use starknet::Felt252TryIntoContractAddress;


// Internal imports
use two_words::constants::MINT_PRICE;
use two_words::ERC721::ERC721;
use two_words::tests::helpers::approve_erc20;
use two_words::tests::helpers::deploy_erc20;
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
use two_words::tests::constants_test::TWENTY;

use two_words::tests::constants_test::TOKEN_ID;
use two_words::tests::constants_test::TOKEN_SUPPLY;

#[abi]
trait IERC20 {
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256);
    fn balance_of(account: ContractAddress) -> u256;
    fn approve(spender: ContractAddress, amount: u256);
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: zero address dest', ))]
fn test_mint__should_panic_with_zero_address_destination() {
    // Given 
    deploy_erc721(1);
    set_caller_address(CALLER);

    let destination = ZERO.try_into().unwrap();

    // When
    ERC721::mint(destination);
}

#[test]
#[available_gas(2000000)]
#[should_panic(expected: ('ERC721: reached max supply', ))]
fn test_mint__should_panic_with_max_supply() {
    // Given 
    deploy_erc721(1);
    set_caller_address(CALLER);

    ERC721::erc721_mint_id::write(TOKEN_SUPPLY.into());
    ERC721::erc721_supply::write(TOKEN_SUPPLY.into());

    let destination = DESTINATION.try_into().unwrap();

    // When
    ERC721::mint(destination);
}

#[test]
#[available_gas(2000000)]
fn test_mint__should_update_balances_and_transfer_mint_fee() {
    // Given 
    let erc20_address = deploy_erc20(CALLER);
    deploy_erc721(erc20_address);

    let contract_address = TWENTY.try_into().unwrap();
    set_contract_address(CALLER.try_into().unwrap());
    approve_erc20(erc20_address, contract_address, MINT_PRICE);

    set_caller_address(CALLER);
    set_contract_address(contract_address);

    let destination = DESTINATION.try_into().unwrap();

    ERC721::erc721_mint_id::write((TOKEN_SUPPLY - ONE).into());
    ERC721::erc721_supply::write(TOKEN_SUPPLY.into());
    ERC721::erc721_eth_address::write(erc20_address.try_into().unwrap());
    ERC721::erc721_contract_owner::write(OWNER.try_into().unwrap());

    // When
    ERC721::mint(destination);

    // Then
    let owner = ERC721::erc721_owners::read(TOKEN_SUPPLY.into());
    let balance = ERC721::erc721_balances::read(destination);
    let current_mint_id = ERC721::erc721_mint_id::read();

    assert_eq(owner, destination, 'incorrect owner');
    assert_eq(balance, 1.into(), 'incorrect balance');
    assert_eq(current_mint_id, TOKEN_SUPPLY.into(), 'incorrect token id');

    let erc20_balance = IERC20Dispatcher {
        contract_address: erc20_address.try_into().unwrap()
    }.balance_of(OWNER.try_into().unwrap());
    assert_eq(erc20_balance, MINT_PRICE.into(), 'incorrect erc20 balance');
}

#[test]
#[available_gas(2000000)]
fn test_mint__should_update_metadata() {
    // Given 
    let erc20_address = deploy_erc20(CALLER);
    deploy_erc721(erc20_address);

    let contract_address = TWENTY.try_into().unwrap();
    set_contract_address(CALLER.try_into().unwrap());
    approve_erc20(erc20_address, contract_address, MINT_PRICE);

    set_caller_address(CALLER);
    set_contract_address(contract_address);

    ERC721::erc721_supply::write(TOKEN_SUPPLY.into());
    ERC721::erc721_eth_address::write(erc20_address.try_into().unwrap());
    ERC721::erc721_contract_owner::write(OWNER.try_into().unwrap());

    let block_ts: u64 = TWENTY.try_into().unwrap();
    set_block_timestamp(block_ts);

    let destination = DESTINATION.try_into().unwrap();

    // When
    ERC721::mint(destination);

    // Then
    let metadata = ERC721::erc721_token_metadata::read(ONE.into());

    assert_eq(metadata.noun, 'Valley', 'incorrect metadata for noun');
    assert_eq(metadata.adj, 'Sublime', 'incorrect metadata for adj');
}
