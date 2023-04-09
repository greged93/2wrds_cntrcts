mod Randomizer {
    use two_words::types::NounAdj;
    use starknet::get_block_info;

    fn get_random_noun_adj() -> NounAdj {
        NounAdj { noun: 'noun', adj: 'adj',  }
    }
}
