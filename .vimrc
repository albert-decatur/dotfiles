" ~/.vimrc
syntax on
set nu
set nowrap
set incsearch
set hlsearch
set ls=2
map <C-N> :tabn <enter>
map <C-P> :tabp <enter>
" tabs are four spaces wide
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

" get solarized
"set background=light
set background=dark
colorscheme solarized
