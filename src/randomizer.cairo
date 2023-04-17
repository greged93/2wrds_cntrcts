mod Randomizer {
    use two_words::types::NounAdj;

    use starknet::get_block_info;

    use array::ArrayTrait;
    use box::BoxTrait;
    use option::OptionTrait;
    use hash::LegacyHashFelt252;
    use traits::TryInto;

    fn get_random_noun_adj() -> NounAdj {
        let block_info = get_block_info().unbox();
        let ts = block_info.block_timestamp;
        let ts = ts.try_into().unwrap();
        NounAdj { noun: get_random_noun(ts), adj: get_random_adj(ts),  }
    }

    fn get_random_hashed_noun_adj() -> NounAdj {
        let block_info = get_block_info().unbox();
        let ts = block_info.block_timestamp;
        let ts = ts.try_into().unwrap();

        let hash_noun = LegacyHashFelt252::hash(get_random_noun(ts), 1);
        let hash_adj = LegacyHashFelt252::hash(get_random_adj(ts), 1);
        NounAdj { noun: hash_noun, adj: hash_adj,  }
    }

    fn get_random_noun(index: u32) -> felt252 {
        let mut arr = ArrayTrait::<felt252>::new();
        arr.append('Galaxy');
        arr.append('Ruins');
        arr.append('Landscape');
        arr.append('Sunset');
        arr.append('Forest');
        arr.append('Castle');
        arr.append('Cityscape');
        arr.append('Mountain');
        arr.append('Waterfall');
        arr.append('Nebula');
        arr.append('Coastline');
        arr.append('Island');
        arr.append('Aurora');
        arr.append('Jungle');
        arr.append('Cavern');
        arr.append('Village');
        arr.append('Terrain');
        arr.append('Cathedral');
        arr.append('Desert');
        arr.append('Ocean');
        arr.append('Valley');
        arr.append('Garden');
        arr.append('Marsh');
        arr.append('Sculpture');
        arr.append('Maze');
        arr.append('Palace');
        arr.append('Bridge');
        arr.append('Skyline');
        arr.append('Wasteland');
        arr.append('Utopia');
        arr.append('Portal');
        arr.append('Clocktower');
        arr.append('Metropolis');
        arr.append('Glacier');
        arr.append('Beach');
        arr.append('Mirage');
        arr.append('Statue');
        arr.append('Meadow');
        arr.append('Canyon');
        arr.append('Lake');
        arr.append('River');
        arr.append('Temple');
        arr.append('Abandoned');
        arr.append('Symphony');
        arr.append('Tornado');
        arr.append('Storm');
        arr.append('Volcano');
        arr.append('Vortex');
        arr.append('Sanctuary');
        arr.append('Oasis');
        let index = index % arr.len();
        return *arr.get(index).unwrap().unbox();
    }

    fn get_random_adj(index: u32) -> felt252 {
        let mut arr = ArrayTrait::<felt252>::new();
        arr.append('Celestial');
        arr.append('Ancient');
        arr.append('Serene');
        arr.append('Vibrant');
        arr.append('Whimsical');
        arr.append('Enchanted');
        arr.append('Futuristic');
        arr.append('Majestic');
        arr.append('Tranquil');
        arr.append('Ethereal');
        arr.append('Dreamy');
        arr.append('Surreal');
        arr.append('Mesmerizing');
        arr.append('Lush');
        arr.append('Crystal');
        arr.append('Rustic');
        arr.append('Alien');
        arr.append('Gothic');
        arr.append('Barren');
        arr.append('Luminous');
        arr.append('Sublime');
        arr.append('Mysterious');
        arr.append('Eerie');
        arr.append('Abstract');
        arr.append('Intricate');
        arr.append('Opulent');
        arr.append('Minimalist');
        arr.append('Radiant');
        arr.append('Dystopian');
        arr.append('Utopian');
        arr.append('Magical');
        arr.append('Steampunk');
        arr.append('Cyberpunk');
        arr.append('Glacial');
        arr.append('Tropical');
        arr.append('Elusive');
        arr.append('Colossal');
        arr.append('Verdant');
        arr.append('Arid');
        arr.append('Tranquil');
        arr.append('Iridescent');
        arr.append('Ornate');
        arr.append('Decayed');
        arr.append('Harmonious');
        arr.append('Chaotic');
        arr.append('Melancholic');
        arr.append('Volcanic');
        arr.append('Hypnotic');
        arr.append('Immaculate');
        arr.append('Pristine');
        let index = index % arr.len();
        return *arr.get(index).unwrap().unbox();
    }
}
