"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

" Fuck you vi (don't remove this its much better trust me)
set nocompatible

" General plugins, more in ./ftplugin/*.vim{{{
call plug#begin('~/.config/nvim/plugged')
	Plug 'tpope/vim-surround'
	Plug 'Shougo/deoplete.nvim'
	Plug 'SirVer/ultisnips'

	Plug 'PotatoesMaster/i3-vim-syntax', { 'for': 'i3' }
	Plug 'morhetz/gruvbox' " my theme
	Plug 'gcmt/taboo.vim'  " small plugin for custom tab names (:TabooOpen)
call plug#end()

" make deoplete load on startup
let g:deoplete#enable_at_startup = 1
"}}}

" Basics{{{
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber ruler showmode noshowcmd
	set history=1000

	set numberwidth=1 " Use the least amount of space possible

	" Map leader, set to space
	nnoremap <Space> <nop>
	let mapleader = " "

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

" General leader bindings more in ./ftplugin/*.vim{{{
	nn <leader>t :tabnew<cr>:te<cr>:<bs>i
	nn <leader>s :%s///g<left><left><left>
	nn <leader>c :noh<cr>:<bs>

"}}}

" AutoCmd{{{
	" don't allow colorscmemes to change the background
	au ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

	" Disable line numbers in the terminal
	au TermOpen * setlocal nonumber norelativenumber noruler noshowmode
	" showmode is a global option, so on terminal close we need to reset it
	au TermClose * setlocal showmode

	" Disable auto commenting
	au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

	" On file close remove whitespace WITH THE CHAD REGEX
	au BufWritePre * :%s/\s\+$//e
"}}}

" Remaps{{{
	" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

	" navigation of errors (that vim-go gives me)
	nn K :cp<cr>
	nn J :cn<cr>

	" exit terminal mode with control a
	tnoremap <C-a> <C-\><C-n>

	" Bindings to make copying and pasting easier
	vnoremap <C-c> "+y
	inoremap <C-v> <esc>"+p
"}}}

" Colorscheme{{{
	set background=dark
	" try and load the colorscheme but ignore errors
	silent! colorscheme gruvbox
"}}}

" Copy selected text to system clipboard using xclip{{{
	let g:clipboard = {
		   \   'name': 'xclip',
		   \   'copy': {
		   \      '+': 'xclip -i -selection clipboard',
		   \      '*': 'xclip -i -selection clipboard',
		   \    },
		   \   'paste': {
		   \      '+': 'xclip -o -selection clipboard',
		   \      '*': 'xclip -o -selection clipboard',
		   \   },
		   \   'cache_enabled': 1,
		   \ }
	"}}}

