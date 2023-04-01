# Introduction
The Cairo 1.0 contracts to the 2wrds project. Consist in a modified version of the openzeppelin erc721 contracts.
Allows to transfer value from the caller to the contract owner at minting time as well as spliting an token into two separate token, in the event that the original token still holds two words. In the same way, two tokens can be combined into one, with the condition that one of them holds one noun and the other one adjective.

# Test
Tests are run with `make test`. `cairo-test` binary should be available and correspond to the build at commit `9c1905` from [cairo core lib](https://github.com/starkware-libs/cairo/tree/9c190561ce1e8323665857f1a77082925c817b4c).
