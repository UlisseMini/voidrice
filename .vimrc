"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/morhetz/gruvbox.git'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
call plug#end()

" Some basics:
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number
	set tabstop=4
	set shiftwidth=4
" allow the mouse to be used (more user friendly)
	set mouse=a

" don't allow colorschemes to change the background
	autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE

" colorscheme
	set background=dark
	colorscheme gruvbox

" Destraction free mode
	noremap <C-g> :set number!<CR>i<esc>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace all is aliased to S.
	nnoremap S :%s//<Left>

" Copy selected text to system clipboard (requires gvim/nvim/vim-x11 installed):
	vnoremap <C-c> "+y
	map <C-p> "+P
" shortcuts for speeeeed
	nnoremap H 0
	nnoremap L $
	nnoremap J G
	nnoremap K gg

" my stuff
	" Lets you shift <movement> (idea from parth's dotfiles)
	nnoremap H 0
	nnoremap L $
	nnoremap J G
	nnoremap K gg

	" Tweaks for file browsing
	let g:netrw_banner=0 " disable anoying banner
	let g:netrw_liststyle=3 " tree view

	" tabs for diferent languages
	autocmd Filetype go setlocal noexpandtab tabstop=4 shiftwidth=4
	autocmd Filetype lua setlocal noexpandtab tabstop=2 shiftwidth=2
	autocmd Filetype asm set syntax=nasm

	" disable gay ass auto commenting
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
