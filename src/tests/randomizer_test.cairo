// Library imports
use starknet::testing::set_block_timestamp;

use debug::PrintTrait;
use option::OptionTrait;
use traits::TryInto;

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
    assert_eq(random_noun_adj.adj, 'Sublime', 'incorrect adjective');
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
    assert_eq(random_noun_adj.adj, 'Rustic', 'incorrect adjective');
}

#[test]
#[available_gas(2000000)]
fn test_randomizer__should_pass_with_hashed_data_returned() {
    // Given
    let block_ts: u64 = TWENTY.try_into().unwrap();
    set_block_timestamp(block_ts);

    // When
    let random_noun_adj = Randomizer::get_random_hashed_noun_adj();

    // Then
    assert_eq(
        random_noun_adj.noun,
        1721349416151816451055006869977543599826335615754689105249964190999723192550,
        'incorrect hashed noun'
    );
    assert_eq(
        random_noun_adj.adj,
        3114175145383441378887435236515012976188651341047694887260277950353367211479,
        'incorrect hashed adjective'
    );
}
// TODO: either encrypt or pedersen hash the data


