setlocal expandtab tabstop=2 shiftwidth=2

let s:lua = "lua"
if executable("luvit")
	let s:lua = "luvit"
endif

func LuaRun()
	:exe "!" . expand(s:lua) . " " . shellescape(expand("%"))
endf

nn <leader>r :call LuaRun()
