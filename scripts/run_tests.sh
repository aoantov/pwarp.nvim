if [ ! -d deps/plenary.nvim ]; then
  git clone --depth 1 https://github.com/nvim-lua/plenary.nvim ./deps/plenary.nvim
fi

if [ ! -d deps/telescope.nvim ]; then
  git clone --depth 1 https://github.com/nvim-telescope/telescope.nvim ./deps/telescope.nvim
fi

nvim --headless --clean --noplugin -u scripts/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'scripts/minimal.vim'}"
