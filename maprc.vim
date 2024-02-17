" Put all the vim maps in here
" ==========Function definition starts======================
function! OpenManPageInSplit()
	call inputsave()
	let page_name = input('Man page name: ')
	call inputrestore()
	if len(tabpagebuflist()) > 1
		execute 'Man ' . l:page_name
	else
		execute 'Vman ' . l:page_name
	endif
endfunction

function! SearchAndReplace()
	call inputsave()
	let searchTerm = input('Enter search term: ')
	let replaceTerm = input('Enter term to replace with [PRESS ENTER TO DELETE THE SEARCH TERM]: ')
	call inputrestore()
	execute '%s/' . l:searchTerm . '/' . l:replaceTerm . '/g'
endfunction

function! OpenFileInNewSplit(filename)
	if filereadable(expand(a:filename))
		:wincmd v<CR>
		:e '<C-R>"'
	else
		:echom "File '" . a:filename . "' doesn't exist."
	endif
endfunction

" Creates an alias from the value of 'from' to 'to' in Command mode
" ,i.e., if the value of 'from' is 're' and the value of 'to' is 'so $VIMRC'
" typing 're' in command mode (:re) will launch 'so $VIMRC' (:so $VIMRC).
function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
" ==========Function definition ends========================

" Vim key movement maps for moving between multiple windows
nnoremap <leader><Up> :wincmd k<bar> :echom "window up"<CR>
nnoremap <leader>k :wincmd k<bar> : echom "window up"<CR>
nnoremap <leader><Down> :wincmd j<bar> :echom "window down"<CR>
nnoremap <leader>j :wincmd j<bar> :echom "window down"<CR>
nnoremap <leader><Left> :wincmd h<bar> :echom "window left"<CR>
nnoremap <leader>h :wincmd h<bar> :echom "window left"<CR>
nnoremap <leader><Right> :wincmd l<bar> :echom "window right"<CR>
nnoremap <leader>l :wincmd l<bar> :echom "window right"<CR>

" Mapping saving with Ctrl+S
" nnoremap <C-S> :w<CR>
" xnoremap <C-S> <C-C>:w<CR>gv=gv
" inoremap <C-S> <C-O>:w<CR>
" nnoremap <leader>w :w<CR>
" xnoremap <leader>w <C-C>:w<CR>gv=gv

" Mapping to exiting the document with Ctrl+Q
" nnoremap <silent> <C-Q> :q<CR>
" xnoremap <silent> <C-Q> <C-C>:q<CR>gv=gv
" inoremap <silent> <C-Q> <C-O>:q<CR>

" Moving the current line
nnoremap <silent> <S-Down> :m+<CR>==
nnoremap <silent> <S-Up> :m-2<CR>==
" Forgoing using 'j' and 'k' keys in insert mode as
" a CapsLock 'on' state is also taken as a shift key press
" That means, CapsLock+j is taken as a Shift-j
inoremap <silent> <S-Up> <Esc>:m-2<CR>==gi
inoremap <silent> <S-Down> <Esc>:m+<CR>==gi

" Duplicate line
nnoremap <leader>p V"cyP
" Create duplicates of the selected lines
xnoremap <leader>p "cyPgv=gv

nnoremap x v"_d
xnoremap x "_d
" Delete word
nnoremap xw viw"_d
nnoremap <leader>xw ve"_d
nnoremap xW viW"_d
nnoremap <leader>xW vE"_d
nnoremap XW viW"_d
nnoremap <leader>XW vE"_d
" Replace word
nnoremap rw viw"_dP
nnoremap yw yiw
nnoremap dw diw
nnoremap vw viw
" Delete line(s)
nnoremap <leader>x V"_d
xnoremap <leader>x "_d
" Pattern-based deletion
nnoremap xi( vi("_d
nnoremap xi{ vi{"_d
nnoremap xi[ vi["_d
nnoremap xi" vi""_d
nnoremap xi' vi'"_d
nnoremap xi< vi<"_d
nnoremap xi` vi`"_d
nnoremap xa( va("_d
nnoremap xa{ va{"_d
nnoremap xa[ va["_d
nnoremap xa" va""_d
nnoremap xa' va'"_d
nnoremap xa< va<"_d
nnoremap xa` va`"_d
nnoremap xt "_dt
nnoremap xf "_df
" Pattern-based replacement
nnoremap ri( vi("_dP
nnoremap ri{ vi{"_dP
nnoremap ri[ vi["_dP
nnoremap ri" vi""_dP
nnoremap ri' vi'"_dP
nnoremap ri< vi<"_dP
nnoremap ri` vi`"_dP
nnoremap ra( va("_dP
nnoremap ra{ va{"_dP
nnoremap ra[ va["_dP
nnoremap ra" va""_dP
nnoremap ra' va'"_dP
nnoremap ra< va<"_dP
nnoremap ra` va`"_dP
nnoremap <expr> rt "vt" . (nr2char(getchar())) . "\"_dP"
nnoremap <expr> rf "vf" . (nr2char(getchar())) . "\"_dP"
" Replace line(s)
nnoremap <leader>r V"_dP
xnoremap <leader>r "_dP

nnoremap <leader>y V"+y
xnoremap <leader>y "+y
nnoremap <leader>d V"+d
xnoremap <leader>d "+d

" Create a blank line before the current line
nnoremap <C-Up> I<CR><Up>
inoremap <C-Up> <Esc>I<CR><Up>
nnoremap <C-k> I<CR><Up>
inoremap <C-k> <Esc>I<CR><Up>
" Create a blank line after the current line
nnoremap <C-Down> $i<Right><CR>
inoremap <C-Down> <Esc>$i<Right><CR>
nnoremap <C-j> $i<Right><CR>
inoremap <C-j> <Esc>$i<Right><CR>

" Surround the current word in double-quotes
nnoremap <leader>" viw<Esc>a"<Esc>bi"<Esc>lel
nnoremap <leader>' viw<Esc>a'<Esc>bi'<Esc>lel

" Move selected lines in visual-mode up and down
xnoremap <silent> <S-Up> :m '<-2<CR>gv=gv
xnoremap <silent> <S-Down> :m '>+<CR>gv=gv

" An alternate to escaping to normal mode
inoremap kj <Esc>
xnoremap kj <Esc>

" Opens the file under the cursor in a new split
nnoremap <leader>gg viWy<bar> :call OpenFileInNewSplit('<C-R>"')<CR>

" Navigation window shortcut
nnoremap <silent> <leader>nv :wincmd v<bar> :Ex<bar> :vertical resize 30<CR>

nnoremap <leader>gp viWy<bar> :wincmd v<bar> :Ex <C-R>"<CR>

" Full file indentation
nnoremap <leader>= gg=G``

nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
nnoremap <silent> <leader>sp :wincmd v<bar> :wincmd l<CR>
nnoremap <leader>re :so $MYVIMRC<CR>

" Quick jumping
" nnoremap 3 #
" nnoremap 4 $
" nnoremap 5 %
" nnoremap 6 ^

" Open terminal
nnoremap <silent> <leader>t :terminal<CR>

" Shortcut for execute command
nnoremap ! :!<Space>

" Search and replace mapping
nnoremap <leader>sr :call SearchAndReplace()<CR>

" -----------Shortcuts for plugin commands-------------
" Undo tree mapping
nnoremap <silent> <leader>u :UndotreeShow<CR>
" Rip grep shortcut
nnoremap <leader>ps :Rg<Space>
" Man page
nnoremap <leader>mn :call OpenManPageInSplit()<CR>
" YCM
" python semantic Completer
" let g:ycm_clangd_binary_path = '$HOME/.vim/plugged/YouCompleteMe/third_party/ycmd/clang_archives/libclang-14.0.0-x86_64-unknown-linux-gnu.tar.bz2'
let g:ycm_python_binary_path = 'python'
let g:ycm_confirm_extra_conf = 0
" let g:ycm_cxx_default_flags = [ '-xc++', '-isystem', '/usr/include/c++/9/', '-I', 'lib', '--std=c++17', '-Werror' ]
let g:ycm_extra_conf_globlist = [ '$HOME/Programming/Voyage/lib/' ]
let g:ycm_semantic_triggers = { 'VimspectorPrompt': [ '.', '->', ':', '<' ], 'c': ['->', '.'], 'cpp': ['->', '.', '::'], 'java': ['.',], 'python': ['.',] }
" let g:ycm_global_ycm_extra_conf = '$HOME/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
" Let clangd fully control code completion
let g:ycm_clangd_uses_ycmd_caching = 0
" Use installed clangd, not YCM-bundled clangd which doesn't get updates.
let g:ycm_clangd_binary_path = exepath("clangd")
let g:ycm_clangd_args = ['-log=verbose', '-pretty']
" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dx :call vimspector#Reset()<CR>
nnoremap <leader>de :call VimspectorEval
nnoremap <leader>dw :call VimspectorWatch
nnoremap <leader>do :call VimspectorShowOutput
nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
nnoremap <silent> <leader>gf :YcmCompleter FixIt<CR>
" nnoremap <silent> <leader><S-o> :YcmCompleter OrganizeImports<CR>
" FZF mapping
nnoremap <silent> <leader>f :wincmd v<bar> :wincmd l<bar> :wincmd h<bar> :Files<CR>


