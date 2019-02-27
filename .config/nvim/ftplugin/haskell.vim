" haskellers use spaces not tabs
" NOTE: Style guide says indent 'where' with 2 spaces.
set expandtab

let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

func! Ghci( ... )
    exe "sp term://ghci " . shellescape( expand( join(a:000) ) ) . " -v0" . 
    norm! A
endf

" mappings
nn <leader>f :call LanguageClient#textDocument_formatting()<cr>
nn <leader>gb :!ghc --make -odir /tmp/ghc/ -hidir /tmp/ghc %<cr>
nn <leader>r :call Ghci("%")<cr>
nn <leader>i :call Ghci()<cr>
