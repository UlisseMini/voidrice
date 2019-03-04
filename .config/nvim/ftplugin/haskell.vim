" haskellers use spaces not tabs
" NOTE: Style guide says indent 'where' with 2 spaces.
set expandtab

let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

func! HideErrors()
  if !exists("g:LanguageClient_diagnosticsEnable") || g:LanguageClient_diagnosticsEnable
    let g:LanguageClient_diagnosticsEnable = 0
  else
    let g:LanguageClient_diagnosticsEnable = 1
  endif

  " restart the language server
  LanguageClientStop
  LanguageClientStart

  " redraw everything?
  norm! mkggdGu`k
endf

func! Ghci( ... )
    exe "sp term://ghci " . shellescape( expand( join(a:000) ) ) . " -v0"
    norm! A
endf

" mappings
nn <leader>gb :!ghc --make -odir /tmp/ghc/ -hidir /tmp/ghc %<cr>
nn <leader>r :call Ghci("%")<cr>
nn <leader>i :call Ghci()<cr>

nn <leader>gd :call LanguageClient#textDocument_definition()<CR>
nn <leader>gn :call LanguageClient#textDocument_rename()<CR>
