// Library imports
use starknet::testing::set_block_timestamp;

use traits::TryInto;
use option::OptionTrait;

// Internal imports
use two_words::randomizer::Randomizer;

use two_words::tests::asserts::assert_eq;

use two_words::tests::constants_test::TWENTY;
use two_words::tests::constants_test::BIG;

#[test]
#[available_gas(2000000)]
fn test_randomizer__should_pass_with_ts_less_than_items() {
    // Given
    let block_ts: u64 = TWENTY.try_into().unwrap();
    set_block_timestamp(block_ts);

    // When
    let random_noun_adj = Randomizer::get_random_noun_adj();

    // Then
    assert_eq(random_noun_adj.noun, 'Valley', 'incorrect noun');
    assert_eq(random_noun_adj.adj, 'Sublime', 'incorrect noun');
}

#[test]
#[available_gas(2000000)]
fn test_randomizer__should_pass_with_ts_more_than_items() {
    // Given
    let block_ts: u64 = BIG.try_into().unwrap();
    set_block_timestamp(block_ts);

    // When
    let random_noun_adj = Randomizer::get_random_noun_adj();

    // Then
    assert_eq(random_noun_adj.noun, 'Village', 'incorrect noun');
    assert_eq(random_noun_adj.adj, 'Rustic', 'incorrect noun');
}
// TODO: either encrypt or pedersen hash the data


