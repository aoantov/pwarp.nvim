.PHONY: lint 

test:
	nvim --headless --noplugin -u scripts/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'scripts/minimal.vim'}"

lint:
	luacheck lua/ --ignore 113
