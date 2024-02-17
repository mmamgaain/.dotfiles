" Double-quotes to start comments
" ascii 'VimRC' art coming soon....

" Detect different filetypes
filetype on

" Basic syntax highlighting
syntax on
syntax enable

" Relative numbers
set number relativenumber

" Disable error bells
set noerrorbells

" set guifont=Dejavu\ Sans\ Mono:h2
set tabstop=4
set shiftwidth=4
" set expandtab
set smartindent
" set nowrap
set nohlsearch
set smartcase
set noswapfile
set nobackup
set undodir=$HOME/.vim/undodir
set undofile
" Search as you type... how is this not the default?
set incsearch
set scrolloff=8
" REMOVE THIS WHEN NOT USING LIGHTLINE EXTENSION
set termguicolors
set laststatus=2
set noshowmode
let g:lightline = { 'colorscheme': 'catppuccin_mocha' }

" set colorcolumn=130
" highlight ColorColumn ctermbg=0 guibg=lightgrey

" Disable Previews. I HATE PREVIEWS!
set completeopt=menu
" set completeopt-=preview
