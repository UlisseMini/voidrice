"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|

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

	" Other languages
	Plug 'https://github.com/rhysd/vim-crystal', { 'for': 'crystal' }
	Plug 'leafo/moonscript-vim'
	Plug 'UlisseMini/vim-pp'

	" Tiny plugins
	Plug 'PotatoesMaster/i3-vim-syntax', { 'for': 'i3' }
	Plug 'gcmt/taboo.vim'
	Plug 'ntpeters/vim-better-whitespace'

	" ColorSchemes
	Plug 'UlisseMini/gruvbox'
	Plug 'altercation/vim-colors-solarized'
	Plug 'sickill/vim-monokai'
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
	syntax enable
	set encoding=utf-8
	set number relativenumber ruler showmode noshowcmd
	set autoread				 " read changes outside of vim automatically
	set noerrorbells			 " begone beeps
	set autowrite				 " Automatically save before :next, :make etc.
	set hidden
	set history=1000             " vim ex mode history
	set fileformats=unix,dos,mac " Prefer Unix over Windows over OS 9 formats
	set copyindent               " copy existing indentation

	" use this if you want /shrug
	"if has("termguicolors")
	"	set termguicolors
	"endif

	" don't fill the rest of the screen with folding
	set fillchars=fold:\ 

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
	set foldmethod=manual

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
	nn <leader>b :Lexplore<cr>
	"nn <leader>e :echo synIDattr(synIDtrans(synID(line("."), col("."), 1)), "fg")<cr>
	map <leader>e :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

	func TabMessage(cmd)
		redir => message
		silent execute a:cmd
		redir END
		if empty(message)
			echoerr "no output"
		else
			tabnew
			setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
			silent put=message
		endif
	endf

	" toggle iferr block folding
	func ToggleIfErr()
		if !exists("b:IfErr") || !b:IfErr
			" set status
			let b:IfErr = 1

			" fold all iferr blocks
			%g/if .*err != nil.*{\_.\{-\}}/.,/}/fo

			" go to where we where before the regex
			execute "normal \<C-o>"
		else
			" set status
			let b:IfErr = 0

			" unfold all
			normal zR
		endif
	endfu
	nn <leader>gf :call ToggleIfErr()<cr>:<bs>
"}}}



" AutoCmd{{{
	" for some reason asm.vim in ./ftplugin was not working
	au Filetype asm set syntax=nasm

	func ColorScheme()
		hi Folded ctermbg=NONE guibg=NONE
		hi Comment ctermfg=245 guifg=#928374
		hi Normal ctermbg=NONE guibg=NONE
	endf
	au ColorScheme * call ColorScheme()

	" Disable line numbers in the terminal
	au TermOpen * setlocal nonumber norelativenumber noruler noshowmode
	" showmode is a global option, so on terminal close we need to reset it
	au TermClose * setlocal showmode

	" Disable auto commenting
	au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

	" Hide QFix buffer (quickfix)
	augroup QFix
		autocmd!
		autocmd FileType qf setlocal nobuflisted
	augroup END
"}}}

" Binary editing{{{
" shortcut commands
command -bar Hex call ToggleHex()
command -bar Binary call ToggleBin()

" http://vim.wikia.com/wiki/Improved_hex_editing
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

function ToggleBin()
  " bin mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editBin") || !b:editBin
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary       " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries
              "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editBin=1
    " switch to binary editor
    %!xxd -b
	setlocal nomodifiable " editing binary is not supported
  else
    " restore old options
	setlocal modifiable
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editBin=0
    " return to normal editing (reload file)
	edit!
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
"}}}

" Remaps{{{
	" just in case ;)
	com W w
	com WQ wq
	com Q q

	" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

	" next error in quickfix
	nnoremap J :cn<cr>:<bs>

	" exit terminal mode with control a
	tnoremap <C-a> <C-\><C-n>

	" Bindings to make copying and pasting easier
	vnoremap <C-c> "+y
	" inoremap <C-v> <esc>"+p

	" Center the screen when searching
	nnoremap n nzzzv

	" make Y non retarded
	nnoremap Y y$
"}}}

" Colorscheme{{{
	set background=dark
	" try and load the colorscheme but ignore errors
	silent! colo gruvbox
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

