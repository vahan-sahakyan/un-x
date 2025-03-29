" Set leader key to space
let mapleader = " "
let maplocalleader = " "

" Enable line numbers
set number
set relativenumber

autocmd FileType netrw setlocal number
autocmd FileType netrw setlocal relativenumber

" Enable mouse support
set mouse=a

" Highlight search results
set hlsearch

" Enable break indent
set breakindent

" Save undo history
set undofile

" Case insensitive search unless capital letters are used
set ignorecase
set smartcase

" Enable terminal colors
set termguicolors
 
" Enable soft tabs
set shiftwidth=4
set expandtab
set smarttab
set tabstop=4

" Enable line wrapping and set scroll offset
set wrap
set scrolloff=8

" Syntax highlighting
syntax on

" Keymap settings
nmap <leader>pv :Vex<CR>
nmap <leader><CR> :source ~/.vimrc<CR>

colorscheme default
colorscheme morning
colorscheme peachpuff
colorscheme murphy
colorscheme industry
colorscheme ron
colorscheme shine
colorscheme pablo
colorscheme elflord
colorscheme desert
