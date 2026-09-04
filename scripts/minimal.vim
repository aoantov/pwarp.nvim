set rtp +=./
set rtp +=../plenary.nvim/

runtime! plugin/plenary.vim
runtime! plugin/pwarp.lua

set nowritebackup
set noswapfile
set nobackup


lua << EOF
require('pwarp.init')
EOF
