call plug#begin('~/.config/nvim/plugged')
Plug 'fatih/vim-go'
Plug 'sebdah/vim-delve'
Plug 'buoto/gotests-vim'

" Great autocomplete, annoying vsplit
" Plug 'zchee/deoplete-go'

call plug#end()

" vim-go settings
let g:go_doc_keywordprg_enabled = 0
let g:go_template_autocreate = 0

" goimports!
let g:go_fmt_command = "goimports"
" Autocompetion from source code
"let g:go_gocode_propose_source = 1

setlocal noexpandtab tabstop=4 shiftwidth=4

" General
nn <leader>gl :GoMetaLinter<cr>
nn <leader>gb :GoBuild<cr>
nn <leader>gr :GoRun<cr>
nn <leader>gn :GoRename<cr>

" Navigation
nn <leader>gh :GoDoc<space>
nn <leader>gd :GoDef<cr>

" Testing
nn <leader>gg :GoTests<cr>
nn <leader>gt :GoTest<cr>
nn <leader>gc :GoCoverage
