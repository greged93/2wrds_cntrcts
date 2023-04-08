mod ErrorCodes {
    // Token related errors
    const NON_EXISTENT_TOKEN: felt252 = 'ERC721: nonexistent token';
    const TOKEN_ALREADY_MINTED: felt252 = 'ERC721: token already minted';

    // Account related errors
    const ZERO_CALLER: felt252 = 'ERC721: zero address caller';
    const ZERO_DESTINATION: felt252 = 'ERC721: zero address dest';
    const ZERO_OPERATOR: felt252 = 'ERC721: zero address operator';
    const ZERO_QUERY: felt252 = 'ERC721: query for zero address';

    // Approval related errors
    const APPROVAL_TO_SELF: felt252 = 'ERC721: approval to owner';
    const CALLER_NOT_APPROVED: felt252 = 'ERC721: caller not approved';

    // Transfer related errors
    const INCORRECT_OWNER: felt252 = 'ERC721: incorrect owner';
}
