// Library imports
use array::ArrayTrait;
use option::OptionTrait;
use result::ResultTrait;
use traits::TryInto;
use traits::Into;
use starknet::ClassHash;
use starknet::class_hash::Felt252TryIntoClassHash;
use starknet::contract_address::ContractAddress;
use starknet::Felt252TryIntoContractAddress;
use starknet::syscalls::deploy_syscall;

// Internal imports
use two_words::ERC721::ERC721;
use two_words::tests::erc20::ERC20;
use two_words::tests::constants_test::CONTRACT_NAME;
use two_words::tests::constants_test::TOKEN_SYMBOL;
use two_words::tests::constants_test::TOKEN_SUPPLY;

#[abi]
trait IERC20 {
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256);
    fn balance_of(account: ContractAddress) -> u256;
    fn approve(spender: ContractAddress, amount: u256);
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;
}

fn deploy_erc20(recipient: felt252) -> felt252 {
    let mut constructor_calldata = array::ArrayTrait::<felt252>::new();
    constructor_calldata.append('easy');
    constructor_calldata.append('GG');
    constructor_calldata.append(6);
    constructor_calldata.append(100000000000000000);
    constructor_calldata.append(0);
    constructor_calldata.append(recipient);
    let (erc20_address, _) = deploy_syscall(
        ERC20::TEST_CLASS_HASH.try_into().unwrap(), 6, constructor_calldata.span(), true
    )
        .unwrap();
    return erc20_address.into();
}

fn approve_erc20(erc20_address: felt252, spender: ContractAddress, amount: u256) {
    let erc20_address = erc20_address.try_into().unwrap();
    IERC20Dispatcher { contract_address: erc20_address }.approve(spender, amount);
}

fn deploy_erc721(address: felt252) {
    let owner = 1.try_into().unwrap();
    let eth_address = address.try_into().unwrap();
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
