"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

" Fuck you vi (don't remove this its much better trust me)
set nocompatible

" Basics{{{
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
	set history=1000
	let mapleader = ","

	" tab settings
	set tabstop=4
	set shiftwidth=4

	" disable status bar
	set laststatus=0

	" Better pattern matching
	set ignorecase
	set smartcase

	" folding
	set foldmethod=marker

	" Splits open at the bottom and right
	set splitbelow splitright

	" vim = best fuzzy finder
	set path=.**
	set wildmenu

	" Tweaks for file browsing
	let g:netrw_banner=0 " disable anoying banner
	let g:netrw_liststyle=3 " tree view
"}}}

" Plugins{{{
call plug#begin('~/.config/nvim/plugged')
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'SirVer/ultisnips'
Plug 'morhetz/gruvbox'
Plug 'vimwiki/vimwiki'
Plug 'gcmt/taboo.vim'
Plug 'UlisseMini/test-plugin'
call plug#end()

" make deoplete load on startup
let g:deoplete#enable_at_startup = 1

" vim-go settings{{{
	let g:go_doc_keywordprg_enabled = 0
	let g:go_template_file = "default.go"
	let g:go_template_test_file = "default_test.go"

	" Autocompetion from source code
	let g:go_gocode_propose_source = 1
	"}}}
"}}}

" Leader bindings{{{
	" Find where a variable is defined with <Leader> + g
	noremap <Leader>g :GoDef<CR>:<BS>

	" Create new terminal in a new tab
	fu! TabTerm()
		:TabooOpen /bin/bash
		:terminal
	endfunction

	noremap <Leader>t :call TabTerm()<CR>:<BS>i
"}}}

" AutoCmd{{{
	" don't allow colorschemes to change the background
	au ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

	" Disable line numbers in the terminal
	au TermOpen * setlocal nonumber norelativenumber

	" Tabs settings for diferent languages
	au Filetype go setlocal noexpandtab tabstop=4 shiftwidth=4
	au Filetype lua setlocal noexpandtab tabstop=2 shiftwidth=2
	au Filetype yaml setlocal expandtab tabstop=2 shiftwidth=2
	au Filetype make setlocal noexpandtab tabstop=4 shiftwidth=4
	au Filetype asm set syntax=nasm

	" Disable auto commenting
	au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

	" On file close remove whitespace
	au BufWritePre * :%s/\s\+$//e
"}}}

" Remaps{{{
	" exit terminal mode with esc
	tnoremap <Esc> <C-\><C-n>

	" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

	" Bindings to make copying and pasting easier
	vnoremap <C-c> "+y
	map <C-p> "+p

	" Will use when i figure out a good mapping
	nnoremap K <nop>
	nnoremap J <nop>
"}}}

" Colorscheme{{{
	set background=dark
	" try and load the colorscheme but ignore errors
	silent! colorscheme gruvbox"}}}

" Copy selected text to system clipboard using xclip{{{
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
		   \ }"}}}
