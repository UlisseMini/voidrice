" haskellers use spaces not tabs
" NOTE: Style guide says indent 'where' with 2 spaces.
set expandtab

" let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

func! RunGHC( ... )
    exe "25sp term://runghc " . shellescape(expand(join(a:000))) . " --ghci-options=-v0"
    norm! A
endf

" mappings
nn <leader>b :!ghc --make -odir /tmp/ghc/ -hidir /tmp/ghc %<cr>
nn <leader>r :call RunGHC("%")<cr>

" highlighting
hi! link Character Statement
hi! link haskellIdentifier Identifier
hi! link haskellType Type
