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

" for compatibility with syntastic
let g:go_fmt_fail_silently = 1
let g:go_list_type = "quickfix"

" C O L O R S (if you want them)
let g:go_highlight_build_constraints     = 0
let g:go_highlight_fields                = 1
let g:go_highlight_function_calls        = 1
let g:go_highlight_operators             = 0
let g:go_highlight_space_tab_error       = 0

let g:go_highlight_types                 = 0
let g:go_highlight_extra_types           = 0
let g:go_highlight_variable_declarations = 0
let g:go_highlight_variable_assignments  = 0

" use goimports instead of gofmt
let g:go_fmt_command = "goimports"

" better vimgo fmt
" let g:go_fmt_experimental = 0

setlocal noexpandtab tabstop=4 shiftwidth=4

" General
nn <leader>gl :GoMetaLinter<cr>
nn <leader>gb :GoBuild<cr>
nn <leader>r :GoRun<cr>
nn <leader>gn :GoRename<cr>

" Navigation
nn <leader>gh :GoDoc<space>
nn <leader>gd :GoDef<cr>

" Testing
nn <leader>gg :GoTests<cr>
nn <leader>gt :GoTest<cr>
nn <leader>gc :GoCoverage

func! IfErrText()
	let l:padding = ''
	let i = 0

	while i < v:foldlevel
		let l:padding = l:padding . ' '
		let i = i + 1
	endfor

	return l:padding . '// handle err'
endf

" Set foldtext
set foldtext=IfErrText()
