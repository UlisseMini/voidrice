set noexpandtab

func! BuildC()
  let l:file = expand("%")
  let l:out  = l:file[:strlen(l:file)-3]

  exe "!gcc -Wall " . l:file . " -o " . l:out
endf

nn <leader>gb :call BuildC()<cr>
