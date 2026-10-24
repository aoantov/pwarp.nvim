set rtp +=./
set rtp +=deps/plenary.nvim/
set rtp +=deps/telescope.nvim/

runtime! plugin/plenary.vim
runtime! plugin/telescope.vim
runtime! plugin/pwarp.lua

set nowritebackup
set noswapfile
set nobackup


lua << EOF
require('pwarp.init')
EOF
