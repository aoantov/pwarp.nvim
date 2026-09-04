if [ ! -d ../plenary.nvim ]; then
  git clone --depth 1 https://github.com/nvim-lua/plenary.nvim ../plenary.nvim
fi
nvim --headless --noplugin -u scripts/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'scripts/minimal.vim'}"
