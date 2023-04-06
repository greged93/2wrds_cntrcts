#[contract]
mod ERC721 {
    use two_words::error_codes::ErrorCodes;

    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use starknet::ContractAddressIntoFelt252;
    use starknet::ContractAddressZeroable;

    use starknet::Felt252TryIntoContractAddress;

    use traits::Into;
    use traits::TryInto;
    use option::OptionTrait;
    use zeroable::Zeroable;

    const ZERO: felt252 = 0x0;

    struct Storage {
        erc721_name: felt252,
        erc721_symbol: felt252,
        erc721_token_uri: LegacyMap::<u256, felt252>,
        erc721_owners: LegacyMap::<u256, ContractAddress>,
        erc721_balances: LegacyMap::<ContractAddress, u256>,
        erc721_token_approvals: LegacyMap::<u256, ContractAddress>,
        // (owner, operator)
        erc721_operator_approvals: LegacyMap::<(ContractAddress, ContractAddress), bool>,
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
        assert(!owner.is_zero(), ErrorCodes::ZERO_QUERY);
        erc721_balances::read(owner)
    }

    #[view]
    fn owner_of(token_id: u256) -> ContractAddress {
        let owner = erc721_owners::read(token_id);
        assert(!owner.is_zero(), ErrorCodes::NON_EXISTENT_TOKEN);
        owner
    }

    #[view]
    fn get_approved(token_id: u256) -> ContractAddress {
        assert(exists(token_id), ErrorCodes::NON_EXISTENT_TOKEN);
        erc721_token_approvals::read(token_id)
    }

    #[view]
    fn is_approved_for_all(owner: ContractAddress, operator: ContractAddress) -> bool {
        erc721_operator_approvals::read((owner, operator))
    }

    #[view]
    fn token_uri(token_id: u256) -> felt252 {
        assert(exists(token_id), ErrorCodes::NON_EXISTENT_TOKEN);
        erc721_token_uri::read(token_id)
    }

    #[external]
    fn approve(to: ContractAddress, token_id: u256) {
        let caller = starknet::get_caller_address();
        assert(!caller.is_zero(), ErrorCodes::ZERO_CALLER);

        let owner = erc721_owners::read(token_id);
        assert(to != owner, ErrorCodes::APPROVAL_TO_SELF);

        let is_caller_owner = caller == owner;
        let is_caller_approved_for_all = erc721_operator_approvals::read((owner, caller));
        assert(is_caller_owner | is_caller_approved_for_all, ErrorCodes::CALLER_NOT_APPROVED);

        _approve(to, token_id);
    }

    fn _approve(to: ContractAddress, token_id: u256) {
        erc721_token_approvals::write(token_id, to);
        let owner = owner_of(token_id);
        Approval(owner, to, token_id);
    }

    #[external]
    fn set_approval_for_all(operator: ContractAddress, approved: bool) {
        let caller = starknet::get_caller_address();

        // TODO split in two
        assert(!caller.is_zero(), ErrorCodes::ZERO_CALLER);
        assert(!operator.is_zero(), ErrorCodes::ZERO_OPERATOR);
        assert(caller != operator, ErrorCodes::APPROVAL_TO_SELF);

        erc721_operator_approvals::write((caller, operator), bool::True(()));
        ApprovalForAll(caller, operator, approved);
    }

    // #[external]
    // fn transfer_from(from: ContractAddress, to: ContractAddress, token_id: u256) {
    //     let caller = starknet::get_caller_address();
    //     let owner = owners::read(token_id);

    //     let is_owner = caller == owner;
    //     let is_approved = token_approvals::read(token_id) == caller;
    //     assert(is_owner | is_approved, 'ERC721: caller not approved');
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

    fn _transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {
        let owner = owner_of(token_id);
        assert(owner == from, ErrorCodes::INCORRECT_OWNER);
        assert(!to.is_zero(), ErrorCodes::ZERO_DESTINATION);

        let zero_address = ZERO.try_into().unwrap();
        _approve(zero_address, token_id);

        let owner_new_balance = erc721_balances::read(from) - 1.into();
        erc721_balances::write(from, owner_new_balance);

        let destination_new_balance = erc721_balances::read(to) + 1.into();
        erc721_balances::write(to, destination_new_balance);

        erc721_owners::write(token_id, to);
        Transfer(from, to, token_id);
    }

    // fn _transfer(from: ContractAddress, to: ContractAddress, token_id: u256) {
    //     let owner = owner_of(token_id);
    //     assert(from == owner, 'ERC721: Transfer from incorrect owner');
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

    fn exists(token_id: u256) -> bool {
        let _exists = erc721_owners::read(token_id);
        return !_exists.is_zero();
    }
}

