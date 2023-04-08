TEST_ENTRYPOINT = .

.PHONY:


test:
	cairo-test --starknet -p $(TEST_ENTRYPOINT)

test-filter:
	cairo-test --starknet -p $(TEST_ENTRYPOINT) --filter $(filter)

format:
	cairo-format -r .