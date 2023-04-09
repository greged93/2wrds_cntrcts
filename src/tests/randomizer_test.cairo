// Library imports

// Internal imports
use two_words::randomizer::Randomizer;

use two_words::tests::asserts::assert_eq;

#[test]
#[available_gas(2000000)]
fn test_randomizer() {
    // Given

    // When
    let random_noun_adj = Randomizer::get_random_noun_adj();

    // Then
    assert_eq(random_noun_adj.noun, 'noun', 'incorrect noun');
}
