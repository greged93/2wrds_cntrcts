fn assert_eq<T, impl TPETrait: PartialEq::<T>, impl TDropTrait: Drop::<T>>(
    a: T, b: T, message: felt252
) {
    assert(a == b, message);
}
