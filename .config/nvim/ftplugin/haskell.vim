" haskellers use spaces not tabs
" NOTE: Style guide says indent 'where' with 2 spaces.
set expandtab

let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

func! HaskellRun()
    exe "sp term://ghci " . shellescape(expand("%")) . " -v0"
    " start inserting in the terminal.
    norm! A
endf

" mappings
nn <leader>f :call LanguageClient#textDocument_formatting()<cr>
nn <leader>gb :!ghc -dynamic %<cr>
nn <leader>r :call HaskellRun()<cr>
