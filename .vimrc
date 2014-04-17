" ~/.vimrc

set t_Co=256
colorscheme calmar256-dark

syntax on
set nu
set nowrap
set incsearch
set hlsearch
set ls=2
map <C-N> :tabn <enter>
map <C-P> :tabp <enter>

":inoremap ( ()<Esc>i
":inoremap { {}<Esc>i
":inoremap [ []<Esc>i
