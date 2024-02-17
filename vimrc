" Source all the vim sets when loading this rc file
so $HOME/.dotfiles/setrc.vim

" Make the vim-plug plugin manager download automatically
"
let data_dir = has('nvim') ? stdpath('data') . '$HOME/.config/nvim' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
	silent execute '!curl -fLo ' . data_dir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	autocmd VimEnter * PlugInstall --sync
endif

" Source all the vim plugins when loading this rc file
so $HOME/.dotfiles/pluginrc.vim

" colorscheme gruvbox
colorscheme catppuccin_mocha
set background=dark

if executable('rg')
        let g:rg_derive_root='true'
endif

let ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let mapleader = " "
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_win_size = 25

" ag is fast enough that ctrlp doesn't need to cache
let g:ctrlp_use_caching = 0

" Source all the CoC based settings when loading this rc file
so $HOME/.dotfiles/cocrc.vim

" Source all the vim plugins when loading this rc file
so $HOME/.dotfiles/maprc.vim

" Source all the vim autocommands when loading this rc file
so $HOME/.dotfiles/autocmdrc.vim

" Source all the vim abbreviations when loading this rc file
so $HOME/.dotfiles/abbrrc.vim

