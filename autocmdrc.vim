" Place your auto-commands here

" ==========Function definition starts======================
" Not being used as I'm not sold on this mapping yet...
function! SwapColonsAndSemicolons()
	nnoremap <buffer> : ;
	nnoremap <buffer> ; :
endfunction

function! IsCurrLineCommented()
	return synIDattr(synIDtrans(synID(line("."), col("$") - 1, 1)), "name") =~? "comment" || "commentstring"
endfunction

" Returns the visually selected text
" Copied from https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
function! s:GetVisualSelection()
	" Why is this not a built-in Vim script function?!
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end] = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if len(lines) == 0
		return ''
	endif
	let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][column_start - 1:]
	return join(lines, "\n")
endfunction

function! BatchComments()
	execute "'<,'>s!^!" . a:1 . " !"
endfunction

function! SetPythonComments()
	nnoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "^xx" : "I# <Esc>"
	inoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "<Esc>^xxi" : "<Esc>I# "
	xnoremap <buffer> <C-o> :'<,'>norm I# <CR>
endfunction

function! SetCComments()
	nnoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "^xxx" : "I// <Esc>"
	inoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "<Esc>^xxxi" : "<Esc>I// "
	xnoremap <buffer> <C-o> I<Esc>==i/* <Esc>gv=gv$<Esc>i<Right> */<Esc>gv
endfunction

function! SetCSSComments()
	nnoremap <buffer> <C-o> I/* <Esc>$i<Right> */<Esc>
	inoremap <buffer> <C-o> <Esc>I/* <Esc>$i<Right> */<Esc>
	xnoremap <buffer> <C-o> I<Esc>==i/* <Esc>gv=gv$<Esc>i<Right> */<Esc>gv
endfunction

function! SetVimComments()
	nnoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "^xx" : "I\" <Esc>"
	inoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "<Esc>^xxi" : "<Esc>I\" "
	xnoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "^xx" : "I\" <Esc>"
endfunction

function! SetHTMLComments()
	nnoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "^xxxxx$xxxx" : "I<!-- <Esc>$i<Right> --><Esc>"
	inoremap <expr> <buffer> <C-o> IsCurrLineCommented() ? "<Esc>^xxxxx$xxxxi" : "<Esc>I<!-- <Esc>$i<Right> --><Esc>i"
endfunction

function! SetAppropriateComments(filetype)
	if a:filetype ==# 'python' || a:filetype ==# 'sh' || a:filetype ==# 'make'
		call SetPythonComments()
	elseif a:filetype ==# 'c' || a:filetype ==# 'cpp' || a:filetype ==# 'java' || a:filetype ==# 'javascript'
		call SetCComments()
	elseif a:filetype ==# 'css'
		call SetCSSComments()
	elseif a:filetype ==# 'vim'
		call SetVimComments()
	elseif a:filetype ==# 'html' || a:filetype ==# 'htmldjango'
		call SetHTMLComments()
		" elseif a:filetype ==# 'text' || a:filetype ==# 'help' || a:filetype ==# 'netrw'
		" Do something meaningless for a passthrough block
		" let some_var = 0
		" else
		" :echom '"' . a:filetype . '" could not be recognized by the custom code commenting mapper.'<CR>
	endif
endfunction

function! SetCompleter(filetype)
	if a:filetype ==# 'vim'
		call VimCompleterAbbreviations()
	elseif a:filetype ==# 'python'
		call PythonCompleterAbbreviations()
	elseif a:filetype ==# 'javascript'
		call JavaScriptCompleterAbbreviations()
	elseif a:filetype ==# 'text' || a:filetype ==# 'help'
		" Do something meaningless for a passthrough block
		" let some_var = 0
		return
		" else
		" :echom "No completer available for filetype " . a:filetype . ", for now."<CR>
	endif
endfunction

function! CreateHeaderFiles()
	if filereadable('%:r' . '.h')
		call delete(expand('%:r') . '.h')
	endif
	w %:r.h
	tabe %:r.h
	execute 'g/^\S.*{/norm $h%s;'
	execute 'tabc'
endfunction

function! TrimWhitespaces()
	let save = winsaveview()
	keeppatterns %s/\s\+$//e
	call winrestview(l:save)
endfunction
" ==========Function definition ends========================

" ============Auto-group definition starts==================
augroup MAYANK
	autocmd!
	autocmd BufRead * call SetAppropriateComments(&filetype)
	autocmd BufRead * call SetCompleter(&filetype)
	autocmd BufWritePre * call TrimWhitespaces()
	autocmd FileType json syntax match Comment +\/\/.\+$+
	autocmd Filetype netrw
				\ 	nnoremap <buffer> <leader>root :Ex /<CR>
				\ |	nnoremap <buffer> <leader>home :Ex $HOME<CR>
	" autocmd BufWritePost *.c,*.cpp call CreateHeaderFiles()
	" autocmd BufNewFile *.c iint<SPACE>main<SPACE>{}
	" These are the ones suggested as defaults by Context.vim
	" autocmd VimEnter     * ContextActivate
	" autocmd BufAdd       * call context#update('BufAdd')
	" autocmd BufEnter     * call context#update('BufEnter')
	" autocmd CursorMoved  * call context#update('CursorMoved')
	" autocmd VimResized   * call context#update('VimResized')
	" autocmd CursorHold   * call context#update('CursorHold')
	" autocmd OptionSet number,relativenumber,numberwidth,signcolumn,tabstop,list
	"     \          call context#update('OptionSet')
	" if exists('##WinScrolled')
	" autocmd WinScrolled * call context#update('WinScrolled')
	" endif
	" Setup formatexpr specified filetype(s)
	autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
	" Update signature help on jump placeholder
	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup END
" ============Auto-group definition ends====================

