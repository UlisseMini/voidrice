setlocal expandtab tabstop=2 shiftwidth=2

let s:lua = "lua"
"if executable("luvit")
"	let s:lua = "luvit"
"endif

" TODO: Call the lua program in a new terminal (vsplit or tab)
func! LuaRun()
	:exe "!" . expand(s:lua) . " " . shellescape(expand("%"))
endf

nn <leader>r :call LuaRun()<cr>
