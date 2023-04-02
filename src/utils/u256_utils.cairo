fn get_max_u128() -> u128 {
    0xffffffffffffffffffffffffffffffff_u128
}

fn get_max_u256() -> u256 {
    u256 {
        low: 0xffffffffffffffffffffffffffffffff_u128, high: 0xffffffffffffffffffffffffffffffff_u128
    }
}
