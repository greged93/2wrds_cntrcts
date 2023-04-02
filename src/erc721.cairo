#[contract]
mod ERC721 {
    use starknet::ContractAddress;
    use starknet::ContractAddressZeroable;

    use traits::Into;
    use zeroable::Zeroable;

    struct Storage {
        erc721_name: felt252,
        erc721_symbol: felt252,
        owners: LegacyMap::<u256, ContractAddress>,
        balances: LegacyMap::<ContractAddress, u256>,
        token_approvals: LegacyMap::<u256, ContractAddress>,
        // (owner, operator)
        operator_approvals: LegacyMap::<(ContractAddress, ContractAddress), bool>,
    }

    #[event]
    fn Approval(owner: ContractAddress, to: ContractAddress, token_id: u256) {}

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {}

    #[event]
    fn ApprovalForAll(owner: ContractAddress, operator: ContractAddress, approved: bool) {}

    #[constructor]
    fn constructor(_name: felt252, _symbol: felt252) {
        erc721_name::write(_name);
        erc721_symbol::write(_symbol);
    }

    #[view]
    fn name() -> felt252 {
        erc721_name::read()
    }

    #[view]
    fn symbol() -> felt252 {
        erc721_symbol::read()
    }

    #[view]
    fn balance_of(owner: ContractAddress) -> u256 {
        balances::read(owner)
    }

    #[view]
    fn owner_of(token_id: u256) -> ContractAddress {
        owners::read(token_id)
    }

    // #[external]
    // fn set_approval_for_all(operator: ContractAddress, approved: bool) {
    //     let caller = starknet::get_caller_address();
    //     _set_approval_for_all(caller, operator, approved);
    // }

    // fn _set_approval_for_all(owner: ContractAddress, operator: ContractAddress, approved: bool) {
    //     // ContractAddress equation is not supported so into() is used here
    //     let owner: felt252 = owner.into();
    //     let operator: felt252 = operator.into();

    //     assert(owner * operator != 0, 'ERC721: either the caller or operator is the zero address');
    //     assert(owner != operator, 'ERC721: approve to caller');

    //     operator_approvals::write((owner, operator), approved);
    //     ApprovalForAll(owner, operator, approved);
    // }

    #[external]
    fn approve(to: ContractAddress, token_id: u256) {
        let caller = starknet::get_caller_address();
        assert(!caller.is_zero(), 'ERC721: zero address caller');

        let owner = owners::read(token_id);
        assert(to != owner, 'ERC721: approval to owner');

        let is_caller_owner = caller == owner;
        let is_caller_approved_for_all = operator_approvals::read((owner, caller));
        assert(is_caller_owner | is_caller_approved_for_all, 'ERC721: caller not approved');

        token_approvals::write(token_id, to);
        Approval(owner, to, token_id);
    }
// #[external]
// fn transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256) {
//     assert(_is_approved_or_owner(from, token_id), 'Caller is not owner or appvored');
//     _transfer(from, to, token_id);
// }

// fn _exists(token_id: u256) -> bool {
//     !_owner_of(token_id).is_zero()
// }

// fn _mint(to: ContractAddress, token_id: u256) {
//     assert(!to.is_zero(), 'ERC721: mint to 0');
//     assert(!_exists(token_id), 'ERC721: already minted');
//     _beforeTokenTransfer(contract_address_const::<0>(), to, token_id, 1.into());
//     assert(!_exists(token_id), 'ERC721: already minted');

//     balances::write(to, balances::read(to) + 1.into());
//     owners::write(token_id, to);
//     // contract_address_const::<0>() => means 0 address
//     Transfer(contract_address_const::<0>(), to, token_id);

//     _afterTokenTransfer(contract_address_const::<0>(), to, token_id, 1.into());
// }

// fn _burn(token_id: u256) {
//     let owner = owner_of(token_id);
//     _beforeTokenTransfer(owner, contract_address_const::<0>(), token_id, 1.into());
//     let owner = owner_of(token_id);
//     token_approvals::write(token_id, contract_address_const::<0>());

//     balances::write(owner, balances::read(owner) - 1.into());
//     owners::write(token_id, contract_address_const::<0>());
//     Transfer(owner, contract_address_const::<0>(), token_id);

//     _afterTokenTransfer(owner, contract_address_const::<0>(), token_id, 1.into());
// }

// fn _require_minted(token_id: u256) {
//     assert(_exists(token_id), 'ERC721: invalid token ID');
// }

// fn _is_approved_or_owner(spender: ContractAddress, token_id: u256) -> bool {
//     let owner = owners::read(token_id);
//     // || is not supported currently so we use | here
//     spender.into() == owner.into() | is_approved_for_all(
//         owner, spender
//     ) | get_approved(token_id).into() == spender.into()
// }

// fn _transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {
//     assert(from.into() == owner_of(token_id).into(), 'Transfer from incorrect owner');
//     assert(!to.is_zero(), 'ERC721: transfer to 0');

//     _beforeTokenTransfer(from, to, token_id, 1.into());
//     assert(from.into() == owner_of(token_id).into(), 'Transfer from incorrect owner');

//     token_approvals::write(token_id, contract_address_const::<0>());

//     balances::write(from, balances::read(from) - 1.into());
//     balances::write(to, balances::read(to) + 1.into());

//     owners::write(token_id, to);

//     Transfer(from, to, token_id);

//     _afterTokenTransfer(from, to, token_id, 1.into());
// }

// #[view]
// fn is_approved_for_all(owner: ContractAddress, operator: ContractAddress) -> bool {
//     operator_approvals::read((owner, operator))
// }

// #[view]
// fn get_approved(token_id: u256) -> ContractAddress {
//     _require_minted(token_id);
//     token_approvals::read(token_id)
// }

// #[view]
// fn token_uri(token_id: u256) -> felt252 {
//     _require_minted(token_id);
//     let base_uri = _base_uri();
//     // base_uri + felt(token_id)
//     // considering how felt and u256 can be concatted.
//     base_uri + ''
// }

// #[view]
// fn _base_uri() -> felt252 {
//     ''
// }

// #[view]
// fn balance_of(account: ContractAddress) -> u256 {
//     assert(!account.is_zero(), 'ERC721: address zero');
//     balances::read(account)
// }

// #[view]
// fn owner_of(token_id: u256) -> ContractAddress {
//     let owner = _owner_of(token_id);
//     // both are OK!
//     // assert(owner.into() != contract_address_const::<0>().into(), 'ERC721: invalid token ID');
//     assert(!owner.is_zero(), 'ERC721: invalid token ID');
//     owner
// }
}

