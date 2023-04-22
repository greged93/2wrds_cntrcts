TEST_ENTRYPOINT = .

.PHONY:


test:
	cairo-test --starknet $(TEST_ENTRYPOINT)

test-filter:
	cairo-test --starknet  $(TEST_ENTRYPOINT) --filter $(filter)

format:
	cairo-format -r .