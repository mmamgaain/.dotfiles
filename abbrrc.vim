" Place all your abbreviations in here

" ==========Function definition starts======================
function! VimCompleterAbbreviations()
	iabbrev <buffer> function function!()<CR><CR>endfunction<Up><Tab><Up><Esc>I<Esc>w<Right>i
endfunction

function! PythonCompleterAbbreviations()
	iabbrev <buffer> def def():<CR><Tab>pass<Up><Esc>I<Esc>wi
endfunction

function! JavaScriptCompleterAbbreviations()
	iabbrev <buffer> function function() {<CR><CR>}<Up><Up><Esc>I<Esc>wi
endfunction
" ==========Function definition ends========================

