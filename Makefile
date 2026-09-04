.PHONY: lint test 

test:
	bash scripts/run_tests.sh

lint:
	luacheck lua/ --ignore 113
