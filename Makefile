TEST_ENTRYPOINT = .

.PHONY:


test:
	cairo-test --starknet -p $(TEST_ENTRYPOINT)

format:
	cairo-format -r .