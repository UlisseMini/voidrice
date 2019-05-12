func! Cargo(...)
  exe "15sp term://cargo " . shellescape(expand(join(a:000)))
endf

nn <leader>r :call Cargo("run")<cr>
nn <leader>b :call Cargo("build")<cr>
nn <leader>t :call Cargo("test")<cr>
