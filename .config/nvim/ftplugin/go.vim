" ==============================================================================
" #                                                                            #
" #             ##     ## #### ##     ##          ######    #######            #
" #             ##     ##  ##  ###   ###         ##    ##  ##     ##           #
" #             ##     ##  ##  #### ####         ##        ##     ##           #
" #             ##     ##  ##  ## ### ## ####### ##   #### ##     ##           #
" #              ##   ##   ##  ##     ##         ##    ##  ##     ##           #
" #               ## ##    ##  ##     ##         ##    ##  ##     ##           #
" #                ###    #### ##     ##          ######    #######            #
" #                                                                            #
" ==============================================================================
" ...is awesome

" vim-go settings
let g:go_doc_keywordprg_enabled = 1 " K = godoc
let g:go_template_autocreate = 0    " Don't use templates
let g:go_snippet_engine = 'neosnippet'


" use goimports instead of gofmt
let g:go_fmt_command = "goimports"

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
