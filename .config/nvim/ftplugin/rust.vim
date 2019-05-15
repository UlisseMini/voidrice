func! Cargo(...)
  exe "15sp term://cargo " . shellescape(expand(join(a:000)))
endf

nn <leader>r :call Cargo("run")<cr>
nn <leader>b :call Cargo("build")<cr>
nn <leader>t :call Cargo("test")<cr>

let g:rustfmt_autosave = 1

let g:racer_cmd = "/home/peep/.cargo/bin/racer"
