" TODO: Detect makefile and if it exists use it instead.

set expandtab

func! BuildC()
  let l:file = expand("%")
  let l:out  = l:file[:strlen(l:file)-3]

  exe "!gcc -Wall " . l:file . " -o " . l:out
endf

func! RunC()
  let l:file = expand("%")
  let l:out  = l:file[:strlen(l:file)-3]

  exe "!gcc -Wall " . l:file . " -o " . l:out
  exe "!./" . l:out
endf

nn <leader>c :call BuildC()<cr>
nn <leader>r :call RunC()<cr>
