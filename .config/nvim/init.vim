"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

" Fuck you vi (don't remove this its much better trust me)
set nocompatible

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')
	" General
	Plug 'tpope/vim-surround'
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	Plug 'Shougo/neosnippet.vim'
	Plug 'Shougo/neosnippet-snippets'

	" Golang development (settings in ftplugin/go.vim)
	Plug 'fatih/vim-go', { 'for': 'go' }
	Plug 'sebdah/vim-delve', { 'for': 'go' }
	Plug 'buoto/gotests-vim', { 'for': 'go' }
	Plug 'zchee/deoplete-go', { 'do': 'make', 'for': 'go' }

	" Tiny plugins
	Plug 'PotatoesMaster/i3-vim-syntax', { 'for': 'i3' }
	Plug 'morhetz/gruvbox' " my theme
	Plug 'gcmt/taboo.vim'  " small plugin for custom tab names (:TabooOpen)
call plug#end()

" Make deoplete load on startup
let g:deoplete#enable_at_startup = 1
set pumheight=10 " Completion window max size

" Make neosnippet use tabs for expanding snippets
imap <expr><TAB>
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

"}}}

" Basics{{{
	filetype plugin indent on
	syntax on
	set encoding=utf-8
	set number relativenumber ruler showmode noshowcmd
	set autoread				 " read changes outside of vim automatically
	set noerrorbells			 " begone beeps
	set noswapfile				 " Don't use swapfile
	set nobackup				 " Don't create annoying backup files
	set autowrite				 " Automatically save before :next, :make etc.
	set hidden
	set history=1000             " vim ex mode history
	set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats

	" Undo settings
	set undofile undodir=~/.config/nvim/undo
	set undolevels=1000

	" disable autocompletion preview
	set completeopt-=preview

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
	let g:netrw_banner=0     " disable anoying banner
	let g:netrw_liststyle=3  " tree view
	let g:netrw_winsize = 25 " window size
"}}}

" General leader bindings more in ./ftplugin/*.vim{{{
	nn <C-t> :tabnew<cr>:te<cr>:<bs>i
	nn <leader>s :%s///g<left><left><left>
	nn <leader>c :noh<cr>:<bs>
	nn <leader>a :cclose<CR>

	nn <leader>l :ls<cr>:b
	"nn <leader>f :tab split<cr>:<bs>
	nn <leader>f :tab split<cr>:<bs>
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

	" Hide QFix buffer (quickfix)
	augroup QFix
		autocmd!
		autocmd FileType qf setlocal nobuflisted
	augroup END
"}}}

" Remaps{{{
	" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

	" exit terminal mode with control a
	tnoremap <C-a> <C-\><C-n>

	" Bindings to make copying and pasting easier
	vnoremap <C-c> "+y
	inoremap <C-v> <esc>"+p

	" Center the screen when searching
	nnoremap n nzzzv

	" make Y non retarded
	nnoremap Y y$
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

