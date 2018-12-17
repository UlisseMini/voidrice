"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'SirVer/ultisnips'
Plug 'morhetz/gruvbox'
Plug 'vimwiki/vimwiki'
call plug#end()

" Some basics:
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number
	set history=1000

	" tab settings
	set tabstop=4
	set shiftwidth=4

	" disable status bar
	set laststatus=0

" deoplete settings
	let g:deoplete#enable_at_startup = 1

" vim-go settings
	let g:go_doc_keywordprg_enabled = 0
	let g:go_template_file = "default.go"
	let g:go_template_test_file = "default_test.go"

	" Autocompetion from source code
	let g:go_gocode_propose_source = 1


" uncomment if you want the mouse to be useable inside vim
"	set mouse=a

" don't allow colorschemes to change the background
	autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

" colorscheme
	set background=dark
	colorscheme gruvbox

" Destraction free mode
	noremap <C-g> :set number!<CR>:<BS>

" Splits open at the bottom and right
	set splitbelow splitright

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace all is aliased to S.
	nnoremap S :%s//<Left>

" Copy selected text to system clipboard using xclip
	let g:clipboard = {
		   \   'name': 'xclip',
		   \   'copy': {
		   \      '+': 'xclip -i -selection clipboard',
		   \      '*': 'xclip -i -selection clipboard',
		   \    },
		   \   'paste': {
		   \      '+': 'xclip -i -selection clipboard',
		   \      '*': 'xclip -i -selection clipboard',
		   \   },
		   \   'cache_enabled': 1,
		   \ }

	vnoremap <C-c> "+y
	map <C-p> "+p

" Lets you shift <movement> (idea from parth's dotfiles)
	nnoremap H 0
	nnoremap L $
	nnoremap J G
	nnoremap K gg

" Tweaks for file browsing
	let g:netrw_banner=0 " disable anoying banner
	let g:netrw_liststyle=3 " tree view

" Tabs settings for diferent languages
	autocmd Filetype go setlocal noexpandtab tabstop=4 shiftwidth=4
	autocmd Filetype lua setlocal noexpandtab tabstop=2 shiftwidth=2
	autocmd Filetype yaml setlocal expandtab tabstop=2 shiftwidth=2
	autocmd Filetype asm set syntax=nasm

" Disable auto commenting
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
